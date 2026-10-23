'use strict';
const assert=require('node:assert/strict');
const event=require('../savas-etkinlik');
const granted=[];
const sent=[];
const H=event.kur({
  seviye:require('../seviye'),
  ekSonra:(id,payload,label)=>sent.push({id,payload,label}),
  paraHarca:()=>Buffer.alloc(1),
  odulVer:(d,rewards)=>granted.push(...rewards),
  olay:{say:()=>{}},awardOf:()=>[]
});
const d=JSON.parse(require('node:fs').readFileSync(require('node:path').join(__dirname,'..','oyuncu.json'),'utf8'));
 event.voidState(d);
 d.bosDunya.submit=1;d.bosDunya.award=0;d.bosDunya.hurt=1;d.bosDunya.participated=1;
const first=H['0x01818b07']({durum:d,kaydet:()=>{}});
assert.equal(first.readUInt32BE(0),0);
assert.equal(granted.length,2);
assert.equal(granted.find(x=>x.code===14900001).type,1,'Primogem must be the existing Mystic Shop inventory item');
assert.equal(granted.find(x=>x.code===14900001).amount,10,'attendance gems match the frontend tooltip');
assert.equal(granted.some(x=>x.type===0),false,'Void reward must not grant Gold currency');
assert.deepEqual(granted.find(x=>x.code!==14900001),{type:1,code:14100592,amount:40},'attendance soul reward matches the frontend, not ranking chests');
assert.equal(require('../envanter').article(14900001).ad,'Nguyên thạch','reward uses the existing inventory Article');
assert.equal(d.bosDunya.award,1);
assert.equal(H['0x01818b07']({durum:d,kaydet:()=>{}}).readUInt32BE(0),1,'claim retry must not duplicate rewards');
assert.equal(granted.length,2);
assert(sent.some(x=>x.label==='VOID-status'),'claim refreshes Void reward state');
console.log('PASS Void reward currency replacement, doubled payouts and idempotent claim.');
