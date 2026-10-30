'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-cultivation-'));process.env.BLEACH_ACCOUNT_DIR=temp;
for(const f of ['veri.json','oyuncu.json'])fs.copyFileSync(path.join(__dirname,'..',f),path.join(temp,f));
const S=require('../soul-cultivation'),env=require('../envanter'),{Y,tablo,json}=require('../paket');
let now=Date.parse('2026-10-30T10:00:00+07:00')/1000,d={},saved,broken=false,gold=100000,silver=100000000,packets=[];
const y={paraHarca(costs){for(const c of costs)if((c.code===1?gold:silver)<c.amount)return null;for(const c of costs)if(c.code===1)gold-=c.amount;else silver-=c.amount;return Buffer.from([1]);},paraIcinOdul(costs){for(const c of costs)if(c.code===1)gold+=c.amount;else silver+=c.amount;},ekSonra(id,payload){packets.push({id,payload});}};
const H=S.kur(y,{now:()=>now,random:()=>0,account:()=>({vipLevel:0})}),u=n=>new Y().u32(n).done();
function call(op,p=Buffer.alloc(0)){packets=[];return H['0x018188'+op]({payload:p,durum:d,kaydet:state=>{if(broken)throw Error('disk failure');saved=structuredClone(state);}});}
try{
 let init=call('00');assert.equal(init.readUInt32BE(),0);assert.equal(init.readUInt16BE(36),4);const preview=d.ruhTopla.preview.slice();call('00');assert.deepEqual(d.ruhTopla.preview,preview);assert.equal(new Set(preview).size,4);
 let r=call('01',u(0));assert.equal(r.readUInt32BE(),0);assert.equal(silver,100000000);assert.equal(d.ruhTopla.free,1);assert.equal(d.ruhTopla.used,1);assert.equal(r.readUInt32BE(8),1);
 call('01',u(0));assert.equal(silver,99700000,'paid junior uses native 300000 silver');
 r=call('01',u(1));assert.equal(silver,97300000,'ten junior uses native 20% discount');assert.equal(r.readUInt16BE(28),10);assert.equal(d.ruhTopla.used,12);assert.equal(env.mevcut(d,14100690),2,'ten draws grant the stated exclusive fragment bonus');
 const firstGold=gold;call('01',u(2));assert.equal(gold,firstGold);call('01',u(2));assert.equal(gold,firstGold-100);
 r=call('01',u(3));assert.equal(r.readUInt16BE(28),10);assert.equal(gold,firstGold-100);call('01',u(3));assert.equal(gold,firstGold-900,'paid senior ten costs 800 gold');
 r=call('01',u(4));assert.equal(gold,firstGold-1000);assert(preview.includes(r.readUInt32BE(30)),'super draw must match one of the four preview rewards');
 assert(packets.some(p=>p.id===0x01180f00),'reward inventory updates immediately');assert.deepEqual(d,saved,'inventory and counters saved together');
 for(const payload of [Buffer.alloc(0),Buffer.alloc(3),Buffer.alloc(5),u(5),u(0xffffffff)]){const before=JSON.stringify(d),money=[gold,silver];assert.notEqual(call('01',payload).readUInt32BE(),0);assert.equal(JSON.stringify(d),before);assert.deepEqual([gold,silver],money);}
 d.ruhTopla.used=99;assert.notEqual(call('01',u(1)).readUInt32BE(),0);call('01',u(4));assert.equal(d.ruhTopla.used,100);assert.notEqual(call('01',u(4)).readUInt32BE(),0);
 const beforeBuy=gold;r=call('03');assert.equal(r.readUInt32BE(),0);assert.equal(gold,beforeBuy-200);assert.equal(r.readUInt32BE(12),200);assert.equal(r.readUInt32BE(8),100);assert.notEqual(call('03').readUInt32BE(),0,'VIP0 purchase limit is enforced');
 d.ruhTopla.enerji=9999;call('01',u(0));assert.equal(d.ruhTopla.enerji,10000,'energy cannot exceed its cap');
 const row=tablo('SoulCollectionShop').liste.find(r=>r.frequency===1);r=call('02',u(row._id));assert.equal(r.readUInt32BE(),0);assert.equal(d.ruhTopla.enerji,0);assert(d.ruhTopla.alinan[row._id]);d.ruhTopla.enerji=10000;assert.notEqual(call('02',u(row._id)).readUInt32BE(),0,'no repeated one-time claims');
 const snapshot=JSON.stringify(d),money=[gold,silver];broken=true;assert.notEqual(call('01',u(4)).readUInt32BE(),0);assert.equal(JSON.stringify(d),snapshot);assert.deepEqual([gold,silver],money,'failed persistence refunds charge');broken=false;
 now+=86400;call('00');assert.equal(d.ruhTopla.used,0);assert.equal(d.ruhTopla.vip,0);assert.equal(d.ruhTopla.free,0);assert(d.ruhTopla.alinan[row._id],'lifetime limited purchases remain claimed');assert.deepEqual(d.ruhTopla.preview,preview);
 d.ruhTopla.t[0]=now+3600;const item=json(tablo('SoulCollectionRnd').liste.find(r=>r.type===0).reward,{});env.ekle(d,[{...item,amount:env.MAX_ADET}]);const full=JSON.stringify(d),balances=[gold,silver];assert.notEqual(call('01',u(0)).readUInt32BE(),0);assert.equal(JSON.stringify(d),full);assert.deepEqual([gold,silver],balances);
 // Actual handler wiring must resolve this implementation, not the old fallback.
 const handlers=require('../handlers');handlers.ekAl();const packet=handlers.byReq['0x01818800']({payload:Buffer.alloc(0),durum:{},kaydet:()=>{}});assert.equal(packet.readUInt16BE(36),4);handlers.ekAl();
 const currencyFile=path.join(temp,'veri.json'),currency=JSON.parse(fs.readFileSync(currencyFile));currency.gumus=100000000;currency.altin=10000;fs.writeFileSync(currencyFile,JSON.stringify(currency));
 const realState={},saveReal=state=>fs.writeFileSync(path.join(temp,'oyuncu.json'),JSON.stringify(state));
 const real=handlers.byReq['0x01818801']({payload:u(1),durum:realState,kaydet:saveReal});assert.equal(real.readUInt32BE(),0);assert.equal(real.readUInt16BE(28),10);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).gumus,97600000);assert.equal(env.mevcut(realState,14100690),2);assert.equal(JSON.parse(fs.readFileSync(path.join(temp,'oyuncu.json'))).ruhTopla.used,10);const notifications=handlers.ekAl();assert(notifications.sonra.some(p=>p.id===0x01180f00));assert(notifications.sonra.some(p=>p.id===0x01180105));
 // Alias reward types (boxes and Modify Fragments) must grant their real inventory template too.
 const juniorPool=tablo('SoulCollectionRnd').liste.filter(r=>r.type===0&&env.article(env.odulTemplate(json(r.reward,{}).type,json(r.reward,{}).code)));
 for(const type of [6,7,13,21]){const index=juniorPool.findIndex(r=>json(r.reward,{}).type===type);assert(index>=0);const reward=json(juniorPool[index].reward,{}),template=env.odulTemplate(reward.type,reward.code),state={},before=env.mevcut(state,template),h=S.kur(y,{now:()=>now,random:()=>(index+.1)/juniorPool.length});const ret=h['0x01818801']({payload:u(0),durum:state,kaydet:()=>{}});assert.equal(ret.readUInt32BE(),0);assert.equal(ret.readUInt32BE(30),juniorPool[index]._id);assert.equal(env.mevcut(state,template),before+reward.amount);}
 console.log('PASS Soul Cultivation: native pricing, 10-draw batches, typed pools, preview agreement, bonus fragments, quotas/VIP gates, UTC+7 reset, capped energy, one-time exchange, atomic inventory/refunds and real handler wiring.');
}finally{fs.rmSync(temp,{recursive:true,force:true});}
