"use strict";
const assert=require('assert'),env=require('../envanter'),{Y,O}=require('../paket'),shop=require('../mystic-shop');
const C=shop.config.currencyID,offer=shop.config.offers[0];let sent=[],saved;
const y={ekSonra:(id,payload)=>sent.push({id,payload}),paraHarca:()=>{throw Error('Mystic must not charge gold/coupons');}};
const account={herolar:[offer.heroID]};const H=shop.kur(y,{account:()=>account});let d={nick:'Test'};
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
// A newly recruited partner appears on the next request, without restart.
const other=shop.config.offers.find(o=>o.heroID!==offer.heroID);assert(other);
assert.equal(shop.offers(d,account).length,1);account.herolar.push(other.heroID);
assert.equal(shop.offers(d,account).length,2);account.herolar.pop();
assert.notEqual(H['0x01817a02'](ctx(req(other.id))).readUInt32BE(0),0);
assert.equal(JSON.stringify(d),snap);
d.meyhane={alinan:{[other.heroID]:1}};assert.equal(shop.offers(d,account).length,2);
// Real routing filters the actual account roster rather than a fixed offer list.
const handlers=require('../handlers');handlers.ekAl();p=handlers.byReq['0x01817a00'](ctx(new Y().u32(1).done()));assert.equal(p.readUInt32BE(4),1);assert.equal(p.readUInt16BE(20),shop.offers(d).length);handlers.ekAl();
console.log('PASS Mystic Shop: owned-partner filtering, automatic recruitment updates, unowned purchase rejection, unlimited 100-gem exchanges, exact inventory balances and atomic rollback.');

// Every configured owned fragment is purchasable at the same gem price.
const everyAccount={herolar:shop.config.offers.map(o=>o.heroID)},everyH=shop.kur(y,{account:()=>everyAccount});let everyState={};const eligible=shop.offers(everyState,everyAccount);env.ekle(everyState,[{type:1,code:C,amount:eligible.length*100}]);
for(const row of eligible){const before=env.mevcut(everyState,row.itemID),response=everyH['0x01817a02']({payload:req(row.id),durum:everyState,kaydet:()=>{}});assert.equal(response.readUInt32BE(0),0);assert.equal(env.mevcut(everyState,row.itemID),before+1);}
assert.equal(env.mevcut(everyState,C),0);console.log('PASS all '+eligible.length+' eligible fragment offers: exact 100-gem price, actual item delivery, no gold charge.');
