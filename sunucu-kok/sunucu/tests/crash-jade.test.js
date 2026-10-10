"use strict";
const assert=require('assert'),{Y,O,satir,cv,tablo}=require('../paket'),jade=require('../crash-jade'),env=require('../envanter'),equip=require('../ekipman');
let gold=10000,silver=1000000,packets=[],stats=[],saved;const y={paraHarca:aw=>{let g=0,s=0;for(const a of aw){if(a.code===1)g+=a.amount;else s+=a.amount;}if(gold<g||silver<s)return null;gold-=g;silver-=s;return Buffer.alloc(4);},paraIcinOdul:aw=>{for(const a of aw)if(a.code===1)gold+=a.amount;else silver+=a.amount;return Buffer.alloc(4);},ekSonra:(id,payload)=>packets.push({id,payload})};
let d={gumus:silver,vipLevel:10};const P=jade.kur(y,{rng:()=>0.99,owned:(d,id)=>id===11100005,level:()=>153,statPush:(d,id)=>stats.push(id)}),H=P.handlers;
const ctx=payload=>{d.gumus=silver;return {durum:d,payload,kaydet:n=>{saved=JSON.parse(JSON.stringify(n));}};},empty=Buffer.alloc(0),call=(op,p=empty)=>H['0x01816c'+op](ctx(p));
const good=tablo('CrashJade').liste.filter(r=>env.article(r._id)&&env.article(r._id).majorType===20&&env.article(r._id).quality>0&&r._id%100===1&&r.nextID);
const tpl=good.find(r=>JSON.parse(r.addType).includes(16))._id;
let info=call('00'),o=new O(info);assert.equal(o.u8(),1);o.i32();o.u32();o.u32();o.u32();assert.equal(o.u32(),25);o.u32();assert.equal(o.u16(),0);o.u32();assert.equal(o.kalan(),0);
// One draw creates one jade, charges exactly the native stage price and reports a zero-based button index.
const before=silver;let p=call('01',Buffer.from([1]));assert.equal(p.readUInt32BE(0),0);assert.equal(silver,before-5000);assert.equal(d.hogyoku.tahta.length,1);assert.equal(p.readUInt16BE(17),1);assert.equal(p[19],0);assert(packets.some(x=>x.id===jade.SYNC));
let snapshot=(d.gumus=silver,JSON.stringify(d));assert.notEqual(call('01',Buffer.from([5])).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);
// Exact funds work; zero/locked/malformed requests do not spend money.
silver=5000;p=call('01',Buffer.from([1]));assert.equal(p.readUInt32BE(0),0);assert.equal(silver,0);
assert.notEqual(call('01',Buffer.from([0])).readUInt32BE(0),0);assert.notEqual(call('01',Buffer.alloc(2)).readUInt32BE(0),0);
silver=1000000;const h=jade.state(d);h.tahta=[{hi:1,lo:200,tpl,exp:0}];h.canta=[];
p=call('03',new Y().u32(1).u32(200).done());assert.equal(p.readUInt16BE(4),1);assert.equal(h.canta.length,0);assert.equal(d.hogyoku.canta.length,1);assert.equal(d.hogyoku.tahta.length,0);
assert.notEqual(call('03',new Y().u32(1).u32(200).done()).readUInt32BE(0),0);
// Only gray temporary items may be sold; the reward is a correctly counted native reward list.
d.hogyoku.tahta=[{hi:1,lo:201,tpl:14600001,exp:0},{hi:1,lo:202,tpl,exp:0}];const balance=silver;p=call('06');assert.equal(p.readUInt16BE(4),1);assert.equal(p.readUInt16BE(6),0);assert.equal(silver,balance+env.article(14600001).sellPrice);assert.equal(d.hogyoku.tahta.length,1);assert.equal(d.hogyoku.tahta[0].tpl,tpl);
const actor=11100005;p=call('12',new Y().u32(actor).u8(1).u32(1).u32(200).done());assert.equal(p.readUInt32BE(0),0);assert(d.hogyoku.takili[actor][1]);assert(stats.includes(actor));assert(equip.hogyokuBonuses(d,actor).some(x=>x>0));
assert.notEqual(call('12',new Y().u32(99999999).u8(1).u32(1).u32(202).done()).readUInt32BE(0),0);
// Occupied/locked slots cannot consume or replace the source.
d.hogyoku.canta.push({hi:1,lo:203,tpl,exp:0});snapshot=(d.gumus=silver,JSON.stringify(d));assert.notEqual(call('12',new Y().u32(actor).u8(1).u32(1).u32(203).done()).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);
const first=equip.hogyokuBonuses(d,actor).slice();d.hogyoku.pelet=10;p=call('0a',new Y().u32(1).u32(200).u32(actor).u32(1).done());assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.pelet,9);
assert.notEqual(call('0a',new Y().u32(1).u32(200).u32(0).u32(1).done()).readUInt32BE(0),0);
// Duplicate sources, self-consumption and forged ownership reject the whole request.
const swallow=(list,hero=actor)=>new Y().u32(1).u32(200).u32(hero).u16(list.length).raw(Buffer.concat(list.map(x=>new Y().u32(1).u32(x[0]).u32(x[1]).done()))).done();
for(const ids of [[[203,0],[203,0]],[[200,actor]],[[203,actor]]]){snapshot=(d.gumus=silver,JSON.stringify(d));assert.notEqual(call('10',swallow(ids)).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);}
d.hogyoku.canta.find(j=>j.lo===203).exp=100;const target=d.hogyoku.takili[actor][1],expected=target.exp+Number(satir('CrashJade',tpl).crashedExp)+100;const preview={...target,exp:expected};jade.levelUp(preview);p=call('10',swallow([[203,0]]));assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.takili[actor][1].tpl,preview.tpl);assert.equal(d.hogyoku.takili[actor][1].exp,preview.exp);assert(!d.hogyoku.canta.some(j=>j.lo===203));
p=call('14',new Y().u32(actor).u8(1).done());assert.equal(p.readUInt32BE(0),0);assert(!d.hogyoku.takili[actor][1]);assert(equip.hogyokuBonuses(d,actor).every(x=>x===0));
d.hogyoku.cip=20;p=call('11',new Y().u32(2).done());assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.cip,0);assert.equal(d.hogyoku.pelet,11);assert.notEqual(call('11',new Y().u32(1).done()).readUInt32BE(0),0);
// Correct paid unlock and direct-open rewards/bitmask.
const g=gold;assert.equal(call('0b').readUInt32BE(0),0);assert.equal(gold,g-2);assert.equal(d.hogyoku.slot,26);assert.equal(call('07').readUInt32BE(0),0);assert(d.hogyoku.bayrak&8);assert.equal(d.hogyoku.coin,2);assert.equal(d.hogyoku.cip,5);assert.notEqual(call('07').readUInt32BE(0),0);
assert.equal(call('08').readUInt32BE(0),0);assert.equal(d.hogyoku.satin,1);
// A batch uses the actual highest enabled stage, remaining funds, free slots and daily limits.
d.hogyoku.tahta=[];d.hogyoku.bayrak=1;d.hogyoku.yapim=0;silver=15000;p=call('02');assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.tahta.length,3);assert.equal(silver,0);assert.equal(d.hogyoku.yapim,3);
// Save failure refunds charges and does not publish state/item/stat changes.
silver=100000;d.gumus=silver;snapshot=(d.gumus=silver,JSON.stringify(d));packets=[];const broken=ctx(Buffer.from([1]));broken.kaydet=()=>{throw Error('disk');};assert.notEqual(H['0x01816c01'](broken).readUInt32BE(0),0);assert.equal(silver,100000);assert.equal(JSON.stringify(d),snapshot);assert.equal(packets.length,0);
// Real Hollow shop: correct currency, capacity, quantity, immediate receipt and rollback.
const row=tablo('Mall').liste.find(m=>Number(m.model)===15&&Number(m.itemID)!==14620000);d.hogyoku.coin=700;const req=new Y().u32(row._id).u16(1).done();p=P.exchange(ctx(req),row,1);assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.coin,0);assert(d.hogyoku.canta.some(j=>j.tpl===Number(row.itemID)));assert(packets.some(x=>x.id===0x01186c16));assert.notEqual(P.exchange(ctx(req),row,1).readUInt32BE(0),0);
const pellet=tablo('Mall').liste.find(m=>Number(m.model)===15&&Number(m.itemID)===14620000);d.hogyoku.coin=5;const pp=d.hogyoku.pelet;p=P.exchange(ctx(new Y().u32(pellet._id).u16(1).done()),pellet,1);assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.pelet,pp+1);

// Generation must never confuse required hero level with the jade's actual level.
let grayD={gumus:5000,vipLevel:0},graySilver=5000;const gray=jade.kur({...y,paraHarca:aw=>{graySilver-=aw[0].amount;return Buffer.alloc(1);},ekSonra:()=>{}},{rng:()=>0});const gp=gray.handlers['0x01816c01']({durum:grayD,payload:Buffer.from([1]),kaydet:()=>{}});assert.equal(gp.readUInt32BE(0),0);assert.equal(env.article(grayD.hogyoku.tahta[0].tpl).quality,0);assert.equal(grayD.hogyoku.tahta[0].tpl%100,1);
assert(d.hogyoku.tahta.every(j=>j.tpl%100===1));
// Max-level upgrade consumes only the necessary pellets, leaving the rest available.
const nearMax={hi:1,lo:300,tpl:14600149,exp:0};const maxReq=Math.ceil(Number(satir('CrashJade',nearMax.tpl).levelExp)/300);d.hogyoku.canta.push(nearMax);d.hogyoku.pelet=maxReq+100;p=call('0a',new Y().u32(1).u32(300).u32(0).u32(maxReq+100).done());assert.equal(p.readUInt32BE(0),0);assert.equal(d.hogyoku.canta.find(j=>j.lo===300).tpl,14600150);assert.equal(d.hogyoku.pelet,100);assert.notEqual(call('0a',new Y().u32(1).u32(300).u32(0).u32(1).done()).readUInt32BE(0),0);assert.equal(d.hogyoku.pelet,100);


// The authoritative attribute packets used by Partners and combat really increase/decrease.
const plain={};const noJade=equip.statPaketi(plain,actor,153);const withJade=JSON.parse(JSON.stringify(plain));withJade.hogyoku={takili:{[actor]:{1:{hi:1,lo:900,tpl:14600101,exp:0}}}};const boosted=equip.statPaketi(withJade,actor,153);const physical=p=>p.readUInt32BE(4+2+6*4);assert(physical(boosted)>physical(noJade));delete withJade.hogyoku.takili[actor][1];assert.equal(physical(equip.statPaketi(withJade,actor,153)),physical(noJade));
// Full board, exhausted daily draws and locked hero slots cannot charge currency.
const limits=jade.state(d);limits.tahta=Array.from({length:39},(_,i)=>({hi:1,lo:1000+i,tpl,exp:0}));const money=silver;assert.notEqual(call('01',Buffer.from([1])).readUInt32BE(0),0);assert.equal(silver,money);limits.tahta=[];limits.yapim=cv(60360001,200)*(limits.satin+1);assert.notEqual(call('02').readUInt32BE(0),0);assert.equal(silver,money);
const low=jade.kur(y,{owned:()=>true,level:()=>1}).handlers;const ownerContext=ctx(new Y().u32(actor).u8(8).u32(1).u32(300).done());assert.notEqual(low['0x01816c12'](ownerContext).readUInt32BE(0),0);

const handlers=require('../handlers');handlers.ekAl();assert(handlers.byReq['0x01816c10']);const read=handlers.byReq['0x01816c00']({durum:d,payload:empty,kaydet:()=>{}});assert(read.length>=31);handlers.ekAl();
console.log('PASS Hollow Soul King: actual native packet layouts, costs/limits/bitmasks, single/batch production, pickup/gray sale, EXP including invested EXP, duplicate/self/owner checks, equip/unload real stat contribution, compose/pellets, correct shop currency/receipt and save failure rollback. No player files changed.');
