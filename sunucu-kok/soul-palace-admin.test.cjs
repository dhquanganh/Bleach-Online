'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),os=require('node:os'),zlib=require('node:zlib');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-palace-test-'));process.env.BLEACH_ACCOUNT_DIR=dir;process.env.BLEACH_PALACE_FILE=path.join(dir,'palace.json');
for(const f of ['oyuncu.json','veri.json'])fs.copyFileSync(path.join(__dirname,'sunucu',f),path.join(dir,f));
const config=require('./sunucu/soul-palace-config'),palace=require('./sunucu/soul-palace'),{Y,O,tablo}=require('./sunucu/paket'),{createAdmin}=require('./admin-accounts.cjs');
test('Palace configuration: authorization, all towers/floors, character editing, additions, stale writes and cross-process hot reads',async()=>{
 const admin=createAdmin({body:async r=>r.data});async function call(method,data,role='admin'){let out;await admin({method,data},{},'/auth/admin/soul-palace',{account:{role,_id:'admin'}},(status,value)=>out={status,value});return out;}
 assert.equal((await call('GET',null,'player')).status,403);const original=(await call('GET')).value;assert.equal(original.config.towers.length,13);assert.equal(original.config.towers.reduce((n,t)=>n+t.floors.length,0),360);assert(original.config.towers.every(t=>t.openLevel<=159));config.validate(original.config);
 let changed=structuredClone(original.config),t=changed.towers[0];t.name='Edited division';t.floors[0].name='Edited encounter';t.floors[0].units=[{id:11121006,pos:6,level:159,hp:100000,atk:6500,def:5500,speed:180}];
 changed.towers.push({id:15900014,name:'New division',openLevel:159,floors:[{id:15912001,name:'New floor',scene:30000,units:structuredClone(t.floors[0].units),rewards:[{type:1,code:14100003,amount:1}]}]});
 const saved=await call('PATCH',changed);assert.equal(saved.status,200);assert.equal(saved.value.config.revision,2);assert.equal(config.read().towers[13].floors[0].units[0].id,11121006);
 assert.equal((await call('PATCH',changed)).status,409);
 for(const mutate of [d=>d.towers[0].openLevel=175,d=>d.towers[0].floors[0].units.push({...d.towers[0].floors[0].units[0]}),d=>d.towers[0].floors[0].units[0].id=999,d=>d.towers[0].floors[0].units[0].hp=-1,d=>d.towers[0].floors[0].rewards=[{type:1,code:0,amount:1}],d=>d.towers.push(d.towers[0])]){const bad=structuredClone(saved.value.config);mutate(bad);assert.equal((await call('PATCH',bad)).status,400);}
 const worker=require('node:child_process').spawnSync(process.execPath,['-e',"process.stdout.write(JSON.stringify(require('./sunucu/soul-palace-config').read()))"],{cwd:__dirname,env:process.env,encoding:'utf8'});assert.equal(worker.status,0);assert.equal(JSON.parse(worker.stdout).towers.length,14);
});
test('Palace progression: level/sequence/day locks, actual enemy units, limits, victory/loss and single rewards',()=>{
 const cfg=config.read(),t=cfg.towers[0],f=t.floors[0],next=t.floors[1];let d={},awards=[],failSave=false;
 const y={odulVer(state,r){awards.push(...r);state.rewarded=(state.rewarded||0)+1;}};
 const req=(tower,floor)=>new Y().u8(1).u8(0).u32(tower).u32(floor).done();
 const ctx=p=>({payload:p,durum:d,kaydet:s=>{if(failSave)throw Error('disk failure');}});
 const simulate=(floor,state)=>({payload:Buffer.from([1,2,3]),won:true});
 assert(palace.challenge(ctx(req(t.id,next.id)),y,{level:159,simulate}).error);assert(palace.challenge(ctx(req(t.id,f.id)),y,{level:1,simulate}).error);assert(palace.challenge(ctx(Buffer.alloc(9)),y,{level:159,simulate}).error);
 failSave=true;assert(palace.challenge(ctx(req(t.id,f.id)),y,{level:159,simulate}).error);assert.deepEqual(d,{});assert.equal(awards.length,0);failSave=false;
 const loss=palace.challenge(ctx(req(t.id,f.id)),y,{level:159,simulate:()=>({payload:Buffer.from([1]),won:false})});assert(!loss.error);assert.equal(d.kule.pve,1);assert.equal(d.kule.cleared.length,0);assert.equal(awards.length,0);
 const win=palace.challenge(ctx(req(t.id,f.id)),y,{level:159,simulate});assert(!win.error);assert.equal(d.kule.pve,2);assert(d.kule.cleared.includes(f.id));assert.equal(win.ack.length,14);
 const length=awards.length;assert(palace.challenge(ctx(req(t.id,f.id)),y,{level:159,simulate}).error);assert.equal(awards.length,length);
 const other=cfg.towers[1];assert(palace.challenge(ctx(req(other.id,other.floors[0].id)),y,{level:159,simulate}).error);
 assert(!palace.challenge(ctx(req(t.id,next.id)),y,{level:159,simulate}).error);d.kule.pve=255;assert(palace.challenge(ctx(req(t.id,t.floors[2].id)),y,{level:159,simulate}).error);
 d.kule.day='old';palace.state(d);assert.equal(d.kule.dailyTower,0);assert.equal(d.kule.pve,0);assert(d.kule.cleared.includes(f.id));
 const p=palace.packet(d),o=new O(p);o.u32();for(let i=0;i<5;i++)o.u8();let n=o.u16();for(let i=0;i<n;i++){o.u32();o.u8();}assert.equal(o.u16(),0);assert.equal(o.u16(),0);const size=o.u32(),data=JSON.parse(zlib.inflateSync(p.subarray(o.p,o.p+size)));assert.equal(data.towers.length,14);assert(data.towers[0].floors[0].clear);assert(!data.towers[1].floors[0].clear);
 const units=palace.units(f);assert.equal(units[0].id,11121006);assert.equal(units[0].maxHp,100000);assert.equal(units[0].atk,6500);assert.equal(units[0].def,5500);assert.equal(units[0].camp,1);
});
test('Palace chest and purchases: no free or repeated claims, save failure refunds and daily reset',()=>{
 let d={},gold=1000,rewards=0;const y={paraHarca(c){const cost=c[0].amount;if(cost>gold)return null;gold-=cost;return Buffer.from([1]);},paraIcinOdul(c){gold+=c[0].amount;},odulVer(){rewards++;},ekSonra(){}};const H=palace.kur(y).handlers,call=(op,p=Buffer.alloc(0),broken=false)=>H['0x01810a'+op]({payload:p,durum:d,kaydet:()=>{if(broken)throw Error('disk');}}),code=r=>(r.payload||r).readUInt32BE();
 const chest=tablo('TemplePliesNumber').liste[0];assert.notEqual(code(call('07',new Y().u32(chest._id).done())),0);assert.notEqual(code(call('05')),0);assert.equal(rewards,0);
 const before=gold;assert.notEqual(code(call('02',Buffer.from([1]),true)),0);assert.equal(gold,before);assert.equal(code(call('02',Buffer.from([1]))),0);assert(gold<before);
 palace.state(d).cleared=Array.from({length:chest.numberPlies},(_,i)=>15910001+i);assert.equal(code(call('07',new Y().u32(chest._id).done())),0);assert.equal(rewards,1);assert.notEqual(code(call('07',new Y().u32(chest._id).done())),0);assert.equal(rewards,1);
});
test('Palace new hero formation produces a complete real battle report; original random rewards remain available',()=>{
 const battle=require('./sunucu/savas'),codec=require('./sunucu/kodek'),floor=config.read().towers[13].floors[0];
 const own=battle.heroBirim(11100005,6,159,null,null,0,true);Object.assign(own,{hp:1000000,maxHp:1000000,atk:50000,def:10000,speed:10000});
 const r=battle.kadroRapor(0,null,{ad:floor.name,birimler:palace.units(floor)},{playerState:{},playerUnits:[own],scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4,random:()=>.5});
 const decoded=codec.decodeBattleReport(r.payload);assert.equal(decoded._consumed,decoded._total);assert.equal(decoded.player2.roles[0].roleId,11121006);assert.equal(decoded.player2.roles[0].totalHealth,100000);assert(decoded.turns.length>0);
 const original=config.defaults().towers[0].floors[0];assert(original.randomRewards.length>0);const rolled=palace.rewards(original,()=>1);assert(rolled.length>0);assert(rolled.some(r=>r.type===1));
});
test.after(()=>fs.rmSync(dir,{recursive:true,force:true}));
