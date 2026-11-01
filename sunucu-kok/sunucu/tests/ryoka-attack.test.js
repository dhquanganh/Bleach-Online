'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path');
const ryoka=require('../ryoka-attack'),{Y,O}=require('../paket'),env=require('../envanter');
test('Ryoka native run: entry, partial damage, cooldown, loss, paid revive, waves and expiry',()=>{
 let now=10000,d={},damage=1000,won=false,saved,failSave=false,paid=0;const notices=[];
 const service=ryoka.kur({ekSonra:(id,payload)=>notices.push({id,payload}),olay:{say:()=>{}}},{now:()=>now,simulate:()=>({payload:Buffer.from('report'),won,damage}),commit:(ctx,next,rewards,cost=0)=>{if(failSave)throw Error('disk');paid+=cost;ctx.kaydet(next);Object.assign(ctx.durum,next);return Buffer.alloc(4);}});
 const ctx=payload=>({durum:d,payload,kaydet:next=>{if(failSave)throw Error('disk');saved=JSON.parse(JSON.stringify(next));}}),empty=Buffer.alloc(0),req=id=>new Y().u32(id).done();
 assert(service.fight(ctx(req(12500101))).error);assert(!d.ryokaAttack);
 assert.equal(service.handlers['0x0181020c'](ctx(Buffer.from([1]))).readUInt32BE(),4);
 const entry=service.handlers['0x0181020c'](ctx(empty)),o=new O(entry);assert.equal(o.u32(),0);assert.equal(o.u32(),1);assert.equal(o.u32(),1800);assert.equal(o.u32(),1);assert.equal(o.u32(),0);assert.equal(o.u16(),5);for(let i=0;i<5;i++){assert.equal(o.u32(),12500101+i);assert(o.u32()>0);}assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.u16(),0);assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.u32(),1);assert.equal(o.u32(),0);assert.equal(o.u32(),0);assert.equal(o.kalan(),0);
 const snap=JSON.stringify(d);assert(service.fight(ctx(req(12500101))).error);assert.equal(JSON.stringify(d),snap);
 now++;let result=service.fight(ctx(req(12500101)));assert(!result.error);assert.equal(d.ryokaAttack.monsters[0].hp,4500000-1000);assert.equal(d.ryokaAttack.damage,1000);assert.equal(d.ryokaAttack.battles,1);assert.equal(d.ryokaAttack.deadUntil,now+59);assert(result.updates.some(p=>p.id===ryoka.OP.DEATH));assert.deepEqual(d,saved);
 assert(service.fight(ctx(req(12500101))).error);service.handlers['0x0181020c'](ctx(empty));assert.equal(d.ryokaAttack.damage,1000);assert(service.fight(ctx(req(12500101))).error);
 failSave=true;const before=JSON.stringify(d);assert(service.handlers['0x01813400'](ctx(empty)).readUInt32BE());assert.equal(JSON.stringify(d),before);assert.equal(paid,0);failSave=false;
 assert.equal(service.handlers['0x01813400'](ctx(empty)).readUInt32BE(),0);assert.equal(paid,6);assert.equal(d.ryokaAttack.revives,1);assert.equal(d.ryokaAttack.deadUntil,0);assert(service.handlers['0x01813400'](ctx(empty)).readUInt32BE());assert.equal(paid,6);
 now+=3;won=true;damage=Number.MAX_SAFE_INTEGER;
 for(let i=0;i<5;i++){
  const badSnapshot=JSON.stringify(d);for(const payload of [empty,Buffer.alloc(3),Buffer.alloc(5),req(12500201)])assert(service.fight(ctx(payload)).error);assert.equal(JSON.stringify(d),badSnapshot);
  if(i===0){failSave=true;assert(service.fight(ctx(req(12500101))).error);assert.equal(JSON.stringify(d),badSnapshot);failSave=false;}
  result=service.fight(ctx(req(12500101+i)));assert(!result.error);assert.equal(env.mevcut(d,14800020),i+1);assert(service.fight(ctx(req(12500101+i))).error);now+=3;
 }
 assert.equal(d.ryokaAttack.wave,2);assert.equal(d.ryokaAttack.kills,5);assert(result.updates.some(p=>p.id===ryoka.OP.ROUND));assert.equal(result.updates.filter(p=>p.id===ryoka.OP.MONSTERS).length,2);
 assert(service.fight(ctx(req(12500201))).error);now=d.ryokaAttack.ready;assert(!service.fight(ctx(req(12500201))).error);
 now+=3;d.ryokaAttack.present=false;assert(service.fight(ctx(req(12500202))).error);service.handlers['0x0181020c'](ctx(empty));assert.equal(d.ryokaAttack.wave,2);
 now=d.ryokaAttack.end;assert(service.fight(ctx(req(12500202))).error);service.handlers['0x0181020c'](ctx(empty));assert.equal(d.ryokaAttack.wave,1);assert.equal(d.ryokaAttack.damage,0);assert.equal(env.mevcut(d,14800020),6);
 assert.equal(require('../lonca').aktiviteDurumPaketi()[5],2);
});
test('Ryoka real currency/EXP persistence rolls back on save failure, without touching player files',()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-ryoka-')),old=process.env.BLEACH_ACCOUNT_DIR;process.env.BLEACH_ACCOUNT_DIR=dir;
 try{
  const file=path.join(dir,'veri.json'),original=JSON.stringify({altin:10,gumus:100,generalsSoul:20,level:32,deneyim:0});fs.writeFileSync(file,original);
  let d={},saved;const ctx={durum:d,kaydet:next=>{saved=JSON.parse(JSON.stringify(next));}},next={ryokaAttack:ryoka.create(100)};
  const reward=[{type:0,code:0,amount:100},{type:6,code:0,amount:5},{type:2,code:0,amount:20}];
  ctx.kaydet=()=>{throw Error('disk');};assert.throws(()=>ryoka.commit(ctx,next,reward));assert.equal(fs.readFileSync(file,'utf8'),original);assert.deepEqual(d,{});
  ctx.kaydet=next=>{saved=JSON.parse(JSON.stringify(next));};ryoka.commit(ctx,next,reward);let v=JSON.parse(fs.readFileSync(file));assert.equal(v.gumus,200);assert.equal(v.generalsSoul,25);assert.deepEqual(d,saved);
  assert.throws(()=>ryoka.commit(ctx,next,[],11));v=JSON.parse(fs.readFileSync(file));assert.equal(v.altin,10);ryoka.commit(ctx,next,[],1);assert.equal(JSON.parse(fs.readFileSync(file)).altin,9);
 }finally{if(old===undefined)delete process.env.BLEACH_ACCOUNT_DIR;else process.env.BLEACH_ACCOUNT_DIR=old;fs.rmSync(dir,{recursive:true,force:true});}
});
test('Ryoka uses a real decoded battle report and current native handlers',()=>{
 const d=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'))),battle=require('../savas').ryokaBattle(12500101,12345,d),report=require('../kodek').decodeBattleReport(battle.payload);
 assert.equal(report._consumed,report._total);assert.equal(report.version,4);assert.equal(report.player2.roles[0].roleId,12500101);assert.equal(report.player2.roles[0].totalHealth,12345);assert(Number.isSafeInteger(battle.damage));
 const h=require('../handlers');assert(h.byReq['0x0181020c']);assert(h.byReq['0x01813400']);h.ekAl();
});
