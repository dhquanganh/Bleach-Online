'use strict';
const {Y,cv,tablo,satir,json}=require('./paket'),C=require('./guild'),{deny,exact}=C;
function slot(now){const t=new Date((now+25200)*1000),hours=cv(60800014,[12,18,21]),hour=t.getUTCHours(),last=hours.filter(h=>h<=hour).pop();return `${C.day(now)}:${last??0}`;}
function state(x,type){if(![3,4].includes(type))deny(4);x.m.shops||={};let s=x.m.shops[type];const stamp=slot(x.now);if(!s||s.slot!==stamp){s=x.m.shops[type]={slot:stamp,refresh:0,bought:{},ids:[],born:x.now};}
 if(!s.ids.length){const pool=tablo('BlackMarket').liste.filter(r=>r.model===type&&satir('Article',r.itemID));while(pool.length&&s.ids.length<6){const i=require('node:crypto').randomInt(pool.length);s.ids.push(pool.splice(i,1)[0]._id);}}
 return s;
}
function packet(x,type){const s=state(x,type),w=new Y().u32(0).i32(type).i32(s.refresh).i32(s.born).i32(x.m.groupMoney).i16(s.ids.length);for(const id of s.ids)w.i32(id).i32(s.bought[id]||0);return w.done();}
function handlers(service){const H={};for(const [op,size]of [['0x01817a00',4],['0x01817a01',4],['0x01817a02',8]])H[op]=ctx=>service.run(ctx,x=>{
 exact(ctx.payload,size);x.requireMember();const type=ctx.payload.readUInt32BE(),s=state(x,type);
 if(op==='0x01817a00')return packet(x,type);
 if(op==='0x01817a01'){const prices=cv(60800016,[]),cost=Number(prices[s.refresh]);if(s.refresh>=prices.length||!(cost>0)||x.m.groupMoney<cost)deny();x.m.groupMoney-=cost;s.refresh++;s.ids=[];s.bought={};s.born=x.now;return packet(x,type);}
 const id=ctx.payload.readUInt32BE(4),row=satir('BlackMarket',id);if(!row||row.model!==type||!s.ids.includes(id)||(s.bought[id]||0)>=row.totalTimes)deny();const price=json(row.price,{});if(price.type!==25||price.code!==29||!Number.isSafeInteger(price.amount)||price.amount<=0||x.m.groupMoney<price.amount)deny();x.award([{type:1,code:row.itemID,amount:row.number}]);x.m.groupMoney-=price.amount;s.bought[id]=(s.bought[id]||0)+1;return new Y().u32(0).i32(type).i32(id).i32(x.m.groupMoney).done();
 },code=>new Y().u32(code).i32(ctx.payload.length>=4?ctx.payload.readUInt32BE():3).done());return H;}
module.exports={handlers,packet,state};
