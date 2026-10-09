"use strict";
const assert=require('assert'),env=require('../envanter'),{Y,O}=require('../paket'),shop=require('../mystic-shop');
const C=shop.config.currencyID,offer=shop.config.offers[0];let sent=[],saved;
const y={ekSonra:(id,payload)=>sent.push({id,payload}),paraHarca:()=>{throw Error('Mystic must not charge gold/coupons');}};
const H=shop.kur(y);let d={nick:'Test'};
const req=id=>new Y().u32(1).u32(id).done();
const ctx=payload=>({payload,durum:d,kaydet:next=>{saved=JSON.parse(JSON.stringify(next));}});
const readBag=b=>{assert.equal(b.readUInt32BE(0),0);assert.equal(b[4],0);const m=new Map(),n=b.readUInt16BE(5);assert.equal(b.length,7+30*n);for(let p=7;p<b.length;p+=30)m.set(b.readUInt32BE(p+1),b.readUInt16BE(p+9));return m;};
let p=H['0x01817a00'](ctx(new Y().u32(1).done())),o=new O(p);assert.equal(o.u32(),0);assert.equal(o.u32(),1);o.u32();o.u32();o.u32();assert.equal(o.u16(),1);assert.equal(o.u32(),offer.id);assert.equal(o.u32(),0);assert.equal(o.kalan(),0);
assert.equal(env.article(C).majorType,1);assert(!env.article(C).usable);assert.equal(offer.itemID,14130055);assert.equal(offer.price.amount,100);assert.equal(offer.number,1);
env.ekle(d,[{type:1,code:C,amount:500}]);const before=env.mevcut(d,offer.itemID);
for(let i=1;i<=5;i++){
 sent=[];p=H['0x01817a02'](ctx(req(offer.id)));assert.equal(p.readUInt32BE(0),0);assert.equal(p.readUInt32BE(4),1);assert.equal(p.readUInt32BE(8),offer.id);assert.equal(p.readUInt32BE(12),0);
 assert.equal(env.mevcut(d,C),500-i*100);assert.equal(env.mevcut(d,offer.itemID),before+i);assert.deepEqual(d,saved);
 assert.equal(sent.length,1);assert.equal(sent[0].id,0x01180f00);const bag=readBag(sent[0].payload);assert.equal(bag.get(C)||0,500-i*100);assert.equal(bag.get(offer.itemID),before+i);
}
let snap=JSON.stringify(d);sent=[];assert.equal(H['0x01817a02'](ctx(req(offer.id))).readUInt32BE(0),21);assert.equal(JSON.stringify(d),snap);assert.equal(sent.length,0);
for(const payload of [Buffer.alloc(0),Buffer.alloc(7),req(999),new Y().u32(0).u32(offer.id).done(),Buffer.concat([req(offer.id),Buffer.from([0])])]){assert.notEqual(H['0x01817a02'](ctx(payload)).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snap);}
// Save failure does not deduct payment, grant reward or emit inventory.
env.ekle(d,[{type:1,code:C,amount:100}]);snap=JSON.stringify(d);sent=[];const broken=ctx(req(offer.id));broken.kaydet=()=>{throw Error('disk');};assert.equal(H['0x01817a02'](broken).readUInt32BE(0),1);assert.equal(JSON.stringify(d),snap);assert.equal(sent.length,0);
// Saturated reward stack must reject before spending currency.
env.ekle(d,[{type:1,code:offer.itemID,amount:65535}]);snap=JSON.stringify(d);assert.equal(H['0x01817a02'](ctx(req(offer.id))).readUInt32BE(0),1);assert.equal(JSON.stringify(d),snap);
// Native refresh format contains IDs without bought-count fields and costs nothing.
p=H['0x01817a01'](ctx(new Y().u32(1).done()));o=new O(p);assert.equal(o.u32(),0);assert.equal(o.u32(),1);o.u32();o.u32();o.u32();assert.equal(o.u16(),1);assert.equal(o.u32(),offer.id);assert.equal(o.kalan(),0);assert.equal(JSON.stringify(d),snap);
// Exercise the real TimeMall routing alongside existing markets.
const handlers=require('../handlers');handlers.ekAl();p=handlers.byReq['0x01817a00'](ctx(new Y().u32(1).done()));assert.equal(p.readUInt32BE(4),1);assert.equal(p.readUInt16BE(20),1);assert.equal(p.readUInt32BE(22),offer.id);handlers.ekAl();
console.log('PASS Mystic Shop: native init/refresh packets, actual routing, five repeat exchanges, exactly 100 gems for 1 fragment, no gold/coupons, persisted balances and immediate inventory at zero, insufficient/invalid requests, saturated stack and save failure rollback. No player files changed.');
