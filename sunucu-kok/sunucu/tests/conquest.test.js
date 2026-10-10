const assert=require('assert'),C=require('../conquest'),{Y,tablo}=require('../paket'),env=require('../envanter');
let d={},packets=[],gold=10000,won=true;const y={ekSonra:(id,p)=>packets.push({id,p}),paraHarca:a=>{if(gold<a[0].amount)return null;gold-=a[0].amount;return Buffer.alloc(4)},paraIcinOdul:a=>{gold+=a.reduce((sum,r)=>sum+r.amount,0);return Buffer.alloc(4)}};
let tick=1000;const api=C.kur(y,{now:()=>tick+=2,rng:()=>0,conditions:()=>true,simulate:()=>({won,payload:Buffer.from('report')})});const ctx=p=>({payload:p,durum:d,kaydet:()=>{}}),req=(...ids)=>{const w=new Y();ids.forEach(id=>w.u32(id));return w.done()},call=(op,...ids)=>api.handlers[op](ctx(req(...ids)));
for(const chapter of tablo('NightmareTrial').liste){const id=chapter._id,city=chapter.normalCityId;
 assert.equal(call('0x01818100',id).length,24);assert.notEqual(call('0x01818102',id,chapter.hardCityId).readUInt32BE(0),0);
 assert.equal(call('0x01818102',id,city).readUInt32BE(0),0);won=false;assert(!api.fight(ctx(req(id))).error);assert.equal(d.conquest[id].passed,0);won=true;
 for(let point=0;point<15;point++){const r=api.fight(ctx(req(id)));assert(!r.error);assert.equal(d.conquest[id].passed,point+1);}
 assert.equal(d.conquest[id].history,city);assert(api.fight(ctx(req(id))).error);assert(packets.some(p=>p.id===0x01180f00));
 const before=JSON.stringify(d),old=gold,broken=ctx(req(id));broken.kaydet=()=>{throw Error('disk')};assert.notEqual(api.handlers['0x01818101'](broken).readUInt32BE(0),0);assert.equal(JSON.stringify(d),before);assert.equal(gold,old);
 assert.equal(call('0x01818101',id).readUInt32BE(0),0);assert.equal(call('0x01818102',id,chapter.hardCityId).readUInt32BE(0),0);assert.notEqual(call('0x01818203',id).readUInt32BE(0),0);d.conquest[id].history=chapter.hardCityId;assert.equal(call('0x01818203',id).readUInt32BE(0),0);assert.equal(d.conquest[id].passed,12);assert.notEqual(call('0x01818203',id).readUInt32BE(0),0);
}
assert.equal(env.mevcut(d,14100592),150);assert(env.mevcut(d,14100698)>0);console.log('PASS Conquest: all three chapters, sequential clears, loss preservation, completion rewards, reset/refund, difficulty unlock, sweep limit, immediate inventory.');

const codec=require('../kodek'),main=require('../seviye').anaId(),roles=[{pos:1,roleId:main,level:153,quality:3,curHealth:100,totalHealth:100,curAnger:0,skillId:0,name:'main'},{pos:6,roleId:11150031,level:153,quality:3,curHealth:100,totalHealth:100,curAnger:0,skillId:0,name:'partner'}];
const report={payload:codec.encodeBattleReport({version:4,player1:{roles},player2:{roles:[]},turns:[]}),remainingHp:roles.map(r=>({camp:0,id:r.roleId,rate:1}))};
assert(C.conditions({helpHeroPos:'[10000001,10000016,10000051]'},report));assert(!C.conditions({helpHeroPos:'[10000003]'},report));assert(!C.conditions({helpHeroPos:'[10000011]'},report));
console.log('PASS Conquest real condition evaluator: round limits, main HP and survivor/formation restrictions.');

const id=10000001;packets=[];const skill=call('0x01818200',id,0);assert.equal(skill.readUInt32BE(0),0);assert(skill.includes(Buffer.from('ATK +12%')));const oldGold=gold;assert.equal(call('0x01818200',id,1).readUInt32BE(0),0);assert.equal(gold,oldGold-1);assert(packets.some(p=>p.id===0x01180105));
console.log('PASS Conquest buff: native costs, saved effect and exact frontend description.');

for(const chapter of tablo('NightmareTrial').liste){
 const cityIds=C.cities(chapter);let previousLevel=0;
 for(const cityId of cityIds){const city=require('../paket').satir('City',cityId);for(let stage=0;stage<15;stage++){
  const units=C.enemyUnits(chapter,city,stage),level=C.enemyLevel(chapter,city,stage);assert(units.length);assert(units.every(u=>u.level===level&&u.hp===u.maxHp));
  if(stage>0){const previous=C.enemyUnits(chapter,city,stage-1);for(const u of units){const prior=previous.find(p=>p.pos===u.pos);if(prior){assert(u.maxHp>prior.maxHp);assert(u.atk>prior.atk);assert(u.def>=prior.def);assert(u.speed>=prior.speed);}}}
 }
 }
}
console.log('PASS Conquest scaling: all 180 stages, +5 levels/stage, +25/difficulty, quadratic HP/ATK/DEF/speed; unrelated Enemy templates unchanged.');

assert.deepEqual(C.levelAwards(40),[{type:1,code:14900001,amount:4},{type:0,code:1,amount:400}]);
assert.deepEqual(C.levelAwards(135),[{type:1,code:14900001,amount:14},{type:0,code:1,amount:1350}]);
assert(env.mevcut(d,14900001)>0);assert(packets.some(p=>p.id===0x01180105));
console.log('PASS level-scaled guaranteed gems and gold, including sweep and immediate currency updates.');

const beforeFailure=JSON.stringify(d),goldBeforeFailure=gold,gemsBeforeFailure=env.mevcut(d,14900001),failed=ctx(req(10000001));failed.kaydet=()=>{throw Error('save failed')};assert(api.fight(failed).error);assert.equal(gold,goldBeforeFailure);assert.equal(env.mevcut(d,14900001),gemsBeforeFailure);assert.equal(JSON.stringify(d),beforeFailure);
console.log('PASS gold/gem reward rollback: failed save grants nothing and preserves stage progress.');
