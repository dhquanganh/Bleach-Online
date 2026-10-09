"use strict";
const {Y,tablo}=require('./paket'),levels=require('./seviye'),reb=require('./reincarnation'),env=require('./envanter');
const MAX=50,INIT=0x0181f200,UP=0x0181f201,RET=0x01186f7e;
function count(d,id){if(Number(id)===levels.anaId())return 0;return Math.max(0,Math.min(MAX,Math.floor(Number((d.heroStars||{})[String(id)])||0)));}
function multiplier(d,id){return 1+0.2*count(d,id);}
function cost(current){return current+1>=25?100:50;}
function supported(d,id,v=levels.veriOku()){return id!==levels.anaId()&&reb.owned(d,id,v)&&reb.fragmentId(id)>0;}
function info(d,error=0){const v=levels.veriOku(),heroes=tablo('BaseHero').liste.filter(h=>supported(d,h._id,v)).map(h=>{const stars=count(d,h._id),fragment=reb.fragmentId(h._id);return {id:h._id,name:h.name,stars,fragment,owned:env.mevcut(d,fragment),cost:stars>=MAX?0:cost(stars)};});return {error,max:MAX,heroes,stars:Object.fromEntries(heroes.map(h=>[h.id,h.stars]))};}
function reply(d,error=0){return {id:RET,payload:new Y().utf(JSON.stringify(info(d,error))).done()};}
function kur(y){return {
 ['0x0181f200']:({durum})=>reply(durum),
 ['0x0181f201']:({durum,payload,kaydet})=>{
  if(!Buffer.isBuffer(payload)||payload.length!==8)return reply(durum,4);
  const id=payload.readUInt32BE(0),expected=payload.readUInt32BE(4),stars=count(durum,id);
  if(!supported(durum,id))return reply(durum,4);
  if(stars>=MAX||expected!==stars)return reply(durum,1);
  const fragment=reb.fragmentId(id),amount=cost(stars);
  if(env.mevcut(durum,fragment)<amount)return reply(durum,18);
  const next=JSON.parse(JSON.stringify(durum));if(!env.dus(next,fragment,amount))return reply(durum,18);
  next.heroStars=next.heroStars||{};next.heroStars[String(id)]=stars+1;
  try{kaydet(next);}catch(e){return reply(durum,1);}
  Object.assign(durum,next);
  const update=env.guncellemePaketi(durum,fragment);if(update)y.ekSonra(update.id,update.payload,'STARS-fragments');
  const stat=require('./ekipman').statPaketi(durum,id,levels.heroSeviye(durum,id));if(stat)y.ekSonra(0x01180104,stat,'STARS-stats');
  y.ekSonra(0x01180f00,env.loadBagPaketi(durum),'STARS-bag');
  return reply(durum);
 }
};}
module.exports={MAX,INIT,UP,RET,count,cost,multiplier,supported,info,kur};
