'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),os=require('node:os'),zlib=require('node:zlib');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'palace-chests-'));process.env.BLEACH_ACCOUNT_DIR=dir;process.env.BLEACH_PALACE_CHEST_FILE=path.join(dir,'chests.json');process.env.BLEACH_PALACE_FILE=path.join(dir,'palace.json');
const config=require('./sunucu/palace-chest-config'),chests=require('./sunucu/palace-chests'),palace=require('./sunucu/soul-palace'),env=require('./sunucu/envanter'),{Y,O,gun}=require('./sunucu/paket'),{createAdmin}=require('./admin-accounts.cjs');
const vf=path.join(dir,'veri.json'),pf=path.join(dir,'oyuncu.json');
function reset(){fs.writeFileSync(vf,JSON.stringify({gumus:100,gumusHigh:0,altin:10,prestij:100,askeriEmir:20}));fs.writeFileSync(pf,'{}');return {};}
const read=()=>JSON.parse(fs.readFileSync(vf));
test('Admin chest configuration: real defaults, icons, add/delete, authorization, CAS, validation and cross-process reads',async()=>{
 reset();const initial=config.read();assert.equal(initial.chests.length,12);assert.deepEqual(initial.chests.map(r=>r.points),[5,10,15,20,50,100,150,200,250,300,330,360]);assert.equal(initial.chests[0].rewards[0].type,5);
 const admin=createAdmin({body:async r=>r.data});async function call(method,data,role='admin'){let out;await admin({method,data},{},'/auth/admin/palace-chests',{account:{role,_id:'admin'}},(status,value)=>out={status,value});return out;}
 assert.equal((await call('GET',null,'player')).status,403);
 const view=(await call('GET')).value;assert(view.chests[0].rewards.find(r=>r.code===14100006).iconFrame);assert(view.currencies.some(r=>r.key==='3:0'));
 const next=structuredClone(initial);next.chests[0].rewards=[{type:1,code:14900002,amount:2},{type:5,code:0,amount:100}];
 const saved=await call('PATCH',next);assert.equal(saved.status,200);assert.equal(saved.value.revision,2);assert.equal(saved.value.chests[0].rewards.length,2);assert(saved.value.chests[0].rewards[0].iconFrame);
 assert.equal((await call('PATCH',next)).status,409);
 for(const mutate of [d=>d.chests.pop(),d=>d.chests[0].rewards.push(d.chests[0].rewards[0]),d=>d.chests[0].rewards[0].amount=-1,d=>d.chests[0].rewards[0].amount=32768,d=>d.chests[0].rewards[0].code=0,d=>d.chests[0].id=123]){const bad=structuredClone(config.read());mutate(bad);assert.equal((await call('PATCH',bad)).status,400);}
 const worker=require('node:child_process').spawnSync(process.execPath,['-e',"process.stdout.write(JSON.stringify(require('./sunucu/palace-chest-config').read()))"],{cwd:__dirname,env:process.env,encoding:'utf8'});assert.equal(worker.status,0);assert.equal(JSON.parse(worker.stdout).chests[0].rewards[0].code,14900002);
});
test('Daily selection: points required, one chest per day, exact item/currency grants, live packets, day rollover, no regrant after config edits',()=>{
 const d=reset(),sent=[],y={ekSonra:(id,payload)=>sent.push({id,payload})},save=next=>fs.writeFileSync(pf,JSON.stringify(next));
 const claim=(id,broken=false)=>chests.claim({durum:d,payload:new Y().u32(id).done(),kaydet:broken?()=>{throw Error('disk full');}:save},y).payload.readUInt32BE();
 assert.notEqual(claim(15930001),0);assert.notEqual(claim(0xffffffff),0);assert.equal(sent.length,0);
 palace.state(d).cleared=Array.from({length:360},(_,i)=>15910001+i);
 const before=JSON.stringify(d),account=fs.readFileSync(vf,'utf8'),player=fs.readFileSync(pf,'utf8');assert.notEqual(claim(15930001,true),0);assert.equal(JSON.stringify(d),before);assert.equal(fs.readFileSync(vf,'utf8'),account);assert.equal(fs.readFileSync(pf,'utf8'),player);assert.equal(sent.length,0);
 assert.equal(claim(15930001),0);assert.equal(env.mevcut(d,14900002),2);assert.equal(read().prestij,200);assert(sent.some(p=>p.id===0x01180f00));assert(sent.some(p=>p.id===0x01180105));
 assert.notEqual(claim(15930001),0);assert.notEqual(claim(15930002),0);assert.equal(read().prestij,200);
 let changed=config.read();changed.chests[0].rewards[0].amount=3;config.write(changed,'test');assert.notEqual(claim(15930001),0);assert.equal(env.mevcut(d,14900002),2);
 d.kule.day='old';d.palaceChest.day='old';chests.info(d);assert.equal(d.kule.chest,0);assert.equal(claim(15930001),0);assert.equal(env.mevcut(d,14900002),5);assert.equal(read().prestij,300);
 const copy=JSON.parse(JSON.stringify(d));assert.equal(chests.state(copy).daily.id,15930001);assert.equal(copy.kule.cleared.length,360);
});
test('Full stack, currency overflow, empty rewards and malformed requests do not consume the daily claim',()=>{
 const d=reset(),k=palace.state(d);k.cleared=Array.from({length:360},(_,i)=>15910001+i);env.ekle(d,[{code:14900002,amount:env.MAX_ADET}]);let writes=0;
 const ctx={durum:d,payload:new Y().u32(15930001).done(),kaydet:()=>{writes++;}},y={ekSonra:()=>{throw Error('must not notify');}};
 const code=()=>chests.claim(ctx,y).payload.readUInt32BE();assert.notEqual(code(),0);assert.equal(writes,0);assert(!d.palaceChest);
 env.dus(d,14900002,10);const account=read();account.prestij=2000000000;fs.writeFileSync(vf,JSON.stringify(account));assert.notEqual(code(),0);assert.equal(writes,0);
 let c=config.read();c.chests[0].rewards=[];config.write(c,'test');assert.notEqual(code(),0);assert.equal(writes,0);
 ctx.payload=Buffer.alloc(3);assert.equal(code(),4);
});
test('Native tooltip packet uses current configuration; redo journal recovers one complete grant without duplicates',()=>{
 const d=reset();palace.state(d).cleared=Array.from({length:10},(_,i)=>15910001+i);const data=chests.info(d),o=new O(data);assert.equal(o.u32(),0);assert.equal(o.u16(),10);assert.equal(o.u32(),0);const length=o.u32(),cfg=JSON.parse(zlib.inflateSync(data.subarray(o.p,o.p+length)));assert.equal(cfg.chests.length,12);assert.deepEqual(cfg.chests[0].rewards,[]);assert.equal(o.p+length,data.length);
 const account=read();account.prestij=999;const player={palaceChest:{day:gun(),id:15930001},nick:'Recovered'};fs.writeFileSync(path.join(dir,'palace-chest-pending.json'),JSON.stringify({account,player}));chests.recover();chests.recover();assert.equal(read().prestij,999);assert.equal(JSON.parse(fs.readFileSync(pf)).palaceChest.id,15930001);assert(!fs.existsSync(path.join(dir,'palace-chest-pending.json')));
});
test.after(()=>fs.rmSync(dir,{recursive:true,force:true}));
