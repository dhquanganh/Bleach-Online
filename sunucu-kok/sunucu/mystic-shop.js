"use strict";
const {Y,simdi}=require('./paket'),env=require('./envanter'),config=require('./mystic-shop-config.json');
const fail=n=>new Y().u32(n).u32(1).done();
function packet(refresh=false){const w=new Y().u32(0).u32(1).u32(0).u32(simdi()).u32(0).u16(config.offers.length);
 for(const o of config.offers){w.u32(o.id);if(!refresh)w.u32(0);}return w.done();}
function kur(y){const H={};
 H['0x01817a00']=ctx=>ctx.payload.length===4&&ctx.payload.readUInt32BE(0)===1?packet():fail(4);
 H['0x01817a01']=ctx=>ctx.payload.length===4&&ctx.payload.readUInt32BE(0)===1?packet(true):fail(4);
 H['0x01817a02']=ctx=>{
  if(ctx.payload.length!==8||ctx.payload.readUInt32BE(0)!==1)return fail(4);
  const offer=config.offers.find(o=>o.id===ctx.payload.readUInt32BE(4));if(!offer)return fail(4);
  const cost=offer.price.amount;
  if(offer.price.type!==1||offer.price.code!==config.currencyID||!Number.isSafeInteger(cost)||cost<=0)return fail(4);
  const next=JSON.parse(JSON.stringify(ctx.durum));
  if(env.mevcut(next,config.currencyID)<cost)return fail(21);
  if(!env.dus(next,config.currencyID,cost))return fail(21);
  const before=env.mevcut(next,offer.itemID);
  if(!Number.isSafeInteger(offer.number)||offer.number<=0||before+offer.number>env.MAX_ADET)return fail(1);
  env.ekle(next,[{type:1,code:offer.itemID,amount:offer.number}]);
  if(env.mevcut(next,offer.itemID)!==before+offer.number||!env.liste(next).some(x=>x.code===offer.itemID&&x.amount===before+offer.number))return fail(1);
  try{ctx.kaydet(next);}catch(e){return fail(1);}
  Object.assign(ctx.durum,next);
  // One authoritative snapshot updates both payment and received item, including removal at zero.
  y.ekSonra(0x01180f00,env.loadBagPaketi(ctx.durum),'MYSTIC-exchange-bag-sync');
  return new Y().u32(0).u32(1).u32(offer.id).u32(0).done();
 };return H;
}
module.exports={kur,packet,config};
