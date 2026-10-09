"use strict";
const {Y,simdi}=require('./paket'),env=require('./envanter'),config=require('./black-market-config.json');
function state(d){
 const now=simdi();let s=d.blackMarket;
 if(!s||s.revision!==config.revision||now-s.born>=config.refreshSeconds){s=d.blackMarket={revision:config.revision,born:now,refresh:0,bought:{}};}
 return s;
}
function packet(d){const s=state(d),w=new Y().u32(0).u32(0).u32(s.refresh).u32(s.born).u32(0).u16(config.offers.length);
 for(const o of config.offers)w.u32(o.id).u32(s.bought[o.id]||0);
 return w.utf(JSON.stringify(config)).done();}
function kur(y){
 const fail=n=>new Y().u32(n).u32(0).done();
 const H={};
 H['0x01817a00']=ctx=>{if(ctx.payload.length!==4)return fail(4);const p=packet(ctx.durum);ctx.kaydet(ctx.durum);return p;};
 H['0x01817a01']=ctx=>{
 if(ctx.payload.length!==4)return fail(4);
 const next=JSON.parse(JSON.stringify(ctx.durum));const s=state(next);s.refresh++;s.born=simdi();s.bought={};
 const charge=y.paraHarca([{type:0,code:1,amount:config.refreshGold}]);if(!charge)return fail(16);
 try{ctx.kaydet(next);}catch(e){y.paraIcinOdul([{type:0,code:1,amount:config.refreshGold}]);return fail(1);}
 Object.assign(ctx.durum,next);y.ekSonra(0x01180105,charge,'BLACKMARKET-refresh-gold');return packet(next);
 };
 H['0x01817a02']=ctx=>{
 if(ctx.payload.length!==8)return fail(4);
 const id=ctx.payload.readUInt32BE(4),o=config.offers.find(o=>o.id===id);if(!o)return fail(4);
 const next=JSON.parse(JSON.stringify(ctx.durum)),s=state(next);
 if((s.bought[id]||0)>=o.totalTimes)return fail(1);
 const before=env.mevcut(next,o.itemID),added=env.ekle(next,[{type:1,code:o.itemID,amount:o.number}]);
 if(env.mevcut(next,o.itemID)!==before+o.number)return fail(1);
 const charge=y.paraHarca([o.price]);if(!charge)return fail(16);
 s.bought[id]=(s.bought[id]||0)+1;
 try{ctx.kaydet(next);}catch(e){y.paraIcinOdul([o.price]);return fail(1);}
 Object.assign(ctx.durum,next);
 y.ekSonra(0x01180105,charge,'BLACKMARKET-gold');
 const ntf=env.kazancPaketi(next,added);if(ntf)y.ekSonra(env.OP_NTF,ntf,'BLACKMARKET-items');
 y.ekSonra(0x01180f00,env.loadBagPaketi(next),'BLACKMARKET-bag-sync');
 return new Y().u32(0).u32(0).u32(id).u32(s.bought[id]).done();
 };return H;
}
module.exports={kur,state,packet,config};
