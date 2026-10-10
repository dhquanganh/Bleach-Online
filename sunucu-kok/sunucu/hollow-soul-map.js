"use strict";
const {Y,satir,tablo,json}=require('./paket'),levels=require('./seviye'),heroDB=require('./herolar'),tavern=require('./meyhane');
function roster(d,v=levels.veriOku()){
 const valid=new Set(heroDB.gecerliHerolar().map(h=>h.id));
 const partners=v.tumKarakterler===true||v.tumKarakterler==='true'?[...valid]:[...(Array.isArray(v.herolar)?v.herolar:[]),...tavern.alinanlar(d)];
 return [...new Set([levels.anaId(),...partners.map(Number).filter(id=>valid.has(id))])];
}
function packet(d,ids=roster(d)){
 const states=(d.yildiz||{}).hero||{},w=new Y().u16(ids.length);
 for(const id of ids){w.u32(id);const slots=states[String(id)]||[];for(let i=0;i<7;i++){const point=Number(slots[i])||0,row=satir('SevenHeroLittleStar',point);w.i32(row&&Number(row.bigStar)%10===i+1?point:0);}}
 return w.done();
}
function read(d,payload){if(payload.length!==4)return new Y().u16(0).done();const all=roster(d),id=payload.readUInt32BE(0);return packet(d,id===0?all:all.filter(x=>x===id));}
function bonuses(d,hero){const slots=((d.yildiz||{}).hero||{})[String(hero)]||[],out=new Map();
 const add=row=>{for(const a of json(row&&row.addValue,[])){const type=Number(a.addType),amount=Number(a.addValue);if(type&&Number.isFinite(amount))out.set(type,(out.get(type)||0)+amount);}};
 for(let index=0;index<7;index++){const current=Number(slots[index])||0,last=satir('SevenHeroLittleStar',current);if(!last||Number(last.bigStar)%10!==index+1)continue;
  for(const point of tablo('SevenHeroLittleStar').liste)if(Number(point.bigStar)===Number(last.bigStar)&&point._id<=current){add(point);if(Number(point.isLast))add(satir('SevenHeroStar',point.bigStar));}
 }
 return out;
}
function souls(d){const w=new Y(),a=(d.yildiz||{}).ruh||[];for(let i=0;i<8;i++)w.u32(a[i]||0);return w.done();}
function kur(y,opt={}){const owns=opt.owned||((d,id)=>roster(d).includes(id));
 const push=(d,ids)=>{y.ekOnce(0x01183904,packet(d,ids),'HOLLOWMAP-progress');y.ekOnce(0x01183901,souls(d),'HOLLOWMAP-souls');for(const id of ids)if(opt.statPush)opt.statPush(d,id);};
 return {
 ['0x01813902']:ctx=>{
  if(ctx.payload.length!==8)return new Y().u32(4).done();const hero=ctx.payload.readUInt32BE(0),pointID=ctx.payload.readUInt32BE(4),point=satir('SevenHeroLittleStar',pointID);
  if(!owns(ctx.durum,hero)||!point)return new Y().u32(4).done();const next=JSON.parse(JSON.stringify(ctx.durum)),z=next.yildiz||(next.yildiz={});z.hero=z.hero||{};z.ruh=z.ruh||Array(8).fill(0);
  const branch=Number(point.bigStar)%10-1,kind=Number(point.costSoulId)-82400000,slots=z.hero[hero]||Array(7).fill(0),cost=Number(point.costSoul);
  if(branch<0||branch>=7||kind<1||kind>7||!Number.isSafeInteger(cost)||cost<0||Number(slots[branch]||0)!==Number(point.preLittleStar))return new Y().u32(4).done();
  if((Number(z.ruh[kind])||0)<cost)return new Y().u32(1).done();z.ruh[kind]-=cost;slots[branch]=pointID;z.hero[hero]=slots;
  try{ctx.kaydet(next);}catch(e){return new Y().u32(1).done();}Object.assign(ctx.durum,next);push(next,[hero]);return new Y().u32(0).done();
 },
 ['0x01813903']:ctx=>{
  if(ctx.payload.length!==8)return new Y().u32(4).done();const a=ctx.payload.readUInt32BE(0),b=ctx.payload.readUInt32BE(4);if(a===b||!owns(ctx.durum,a)||!owns(ctx.durum,b))return new Y().u32(4).done();
  const next=JSON.parse(JSON.stringify(ctx.durum)),z=next.yildiz||(next.yildiz={});z.hero=z.hero||{};const old=z.hero[a]||Array(7).fill(0);z.hero[a]=z.hero[b]||Array(7).fill(0);z.hero[b]=old;
  try{ctx.kaydet(next);}catch(e){return new Y().u32(1).done();}Object.assign(ctx.durum,next);push(next,[a,b]);return new Y().u32(0).done();
 }
 };}
module.exports={roster,packet,read,bonuses,souls,kur};
