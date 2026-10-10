'use strict';
const {Y,tablo}=require('./paket'),levels=require('./seviye');
const clone=d=>JSON.parse(JSON.stringify(d)),error=n=>new Y().u32(n).done();
function train(ctx,y,opt={}){
 if(!Buffer.isBuffer(ctx.payload)||![3,8].includes(ctx.payload.length))return error(4);
 const count=ctx.payload.length===3?ctx.payload.readInt16BE(0):ctx.payload.readUInt32BE(0),kind=ctx.payload.length===3?ctx.payload.readInt8(2):ctx.payload.readUInt32BE(4);
 if(count<1||count>500||![1,2].includes(kind))return error(4);
 const account=opt.account||levels.veriOku(),cost=opt.cost(kind,count,account);
 if(cost.hata)return error(cost.hata);
 const next=clone(ctx.durum),table=tablo('KnifeSoul').byId;
 let soul=next.knifeSoul;if(!soul||!table.has(Number(soul.id)))soul=next.knifeSoul={id:18100001,exp:0};
 soul.id=Number(soul.id);
 const paid=y.paraHarca(cost.oduller);if(!paid)return error(kind===1?0x69:0x10);
 soul.exp=Math.max(0,Number(soul.exp)||0)+count*50;
 for(let i=0;i<200;i++){const row=table.get(soul.id),need=Number(row.needExp)||0,id=Number(row.nextID);if(!need||soul.exp<need||!table.has(id))break;soul.exp-=need;soul.id=id;}
 if(y.olay){y.olay.say(next,'cultivate',count);if(kind===2)y.olay.say(next,'cultivateGold',count);if(count>=50)y.olay.say(next,'cultivateOneKey',1);}
 try{ctx.kaydet(next);}catch(e){y.paraIcinOdul(cost.oduller);return error(1);}
 Object.assign(ctx.durum,next);y.ekOnce(0x01180105,paid,'REIATSU-cost');
 const ids=new Set([...require('./hollow-soul-map').roster(next,account),...Object.keys(next.kadro||{}),...Object.keys((next.seviye||{}).herolar||{})].map(Number));
 for(const id of ids){if(!tablo('BaseHero').byId.has(id))continue;const lv=id===levels.anaId()?levels.anaDurum(account).lv:levels.heroDurum(next,id,account).lv;
  const packet=require('./ekipman').statPaketi(next,id,lv);if(packet)y.ekOnce(0x01180104,packet,'REIATSU-stat');
 }
 return new Y().u32(0).u32(soul.id).u32(soul.exp).u8(0).u8(0).u32(count*50).done();
}
module.exports={train};
