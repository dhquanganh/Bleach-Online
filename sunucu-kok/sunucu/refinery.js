'use strict';
const {Y,cv,satir,tablo}=require('./paket');
const env=require('./envanter'),levels=require('./seviye');
const STONE=14100779;
const error=n=>new Y().u32(n).done();
const maximum=()=>Math.max(...tablo('ProfessionRefine').ids);
function state(d){const old=Array.isArray(d.meslekAritma)?d.meslekAritma:[];return Array.from({length:4},(_,i)=>Math.max(0,Math.min(maximum(),Math.floor(Number(old[i])||0))));}
function rates(d,hero){const row=satir('BaseHero',hero),type=Number(row&&row.profession);return type>=1&&type<=4?satir('ProfessionRefine',state(d)[type-1]):null;}
function info(d){const w=new Y().u16(4);for(const n of state(d))w.u32(n);return w.done();}
function recipients(d,type){
 const v=levels.veriOku(),ids=new Set([levels.anaId(),...(Array.isArray(v.herolar)?v.herolar:[]),...Object.keys((d.seviye||{}).herolar||{}),...Object.keys((d.meyhane||{}).alinan||{}),...Object.keys(d.kadro||{})].map(Number));
 return [...ids].filter(id=>Number((satir('BaseHero',id)||{}).profession)===type);
}
function kur(y){
 const H={};
 const notice=(d,tpl,instance)=>{const p=env.guncellemePaketi(d,tpl,instance);y.ekOnce(p.id,p.payload,'REFINERY-inventory');};
 H['0x01818d00']=({durum})=>info(durum);
 H['0x01818d02']=({payload,durum,kaydet})=>{
  if(!Buffer.isBuffer(payload)||payload.length!==4)return error(4);
  const type=payload.readUInt32BE(0);if(type<1||type>4)return error(4);
  const current=state(durum),next=satir('ProfessionRefine',current[type-1]+1);if(!next)return error(1);
  const cost=Number(next.cost);if(!Number.isSafeInteger(cost)||cost<=0)return error(4);
  if(env.mevcut(durum,STONE)<cost)return error(18);
  const working=JSON.parse(JSON.stringify(durum));if(!env.dus(working,STONE,cost))return error(18);
  current[type-1]=next._id;working.meslekAritma=current;
  try{kaydet(working);}catch(e){return error(1);}
  Object.assign(durum,working);notice(durum,STONE);
  for(const id of recipients(durum,type)){const p=require('./ekipman').statPaketi(durum,id,levels.heroSeviye(durum,id));if(p)y.ekSonra(0x01180104,p,'REFINERY-stats');}
  y.ekSonra(0x01188d00,info(durum),'REFINERY-levels');
  return new Y().u32(0).u32(type).u32(next._id).done();
 };
 H['0x01818d01']=({payload,durum,kaydet})=>{
  if(!Buffer.isBuffer(payload)||payload.length<2)return error(4);
  const n=payload.readUInt16BE(0);if(!n||n>250||payload.length!==2+8*n)return error(4);
  const bag=new Map(env.liste(durum).map(item=>[item.instance,item])),seen=new Set(),selected=[];
  const products=cv(62200001,[]),costs=cv(62200002,[]);let quantity=0,silver=0;
  for(let i=0;i<n;i++){
   const instance=payload.readUInt32BE(2+8*i),tpl=payload.readUInt32BE(6+8*i),item=bag.get(instance),article=env.article(tpl),row=satir('Article',tpl);
   if(seen.has(instance)||!item||item.code!==tpl||!article||article.majorType!==3||!row)return error(4);
   const index=Number(row.level)-1,product=Number(products[index]),cost=Number(costs[index]);
   if(!Number.isSafeInteger(product)||product<=0||!Number.isSafeInteger(cost)||cost<0)return error(4);
   seen.add(instance);selected.push(item);quantity+=product*item.amount;silver+=cost*item.amount;
  }
  if(!Number.isSafeInteger(quantity)||!Number.isSafeInteger(silver))return error(4);
  const working=JSON.parse(JSON.stringify(durum));
  for(const item of selected)if(!env.dus(working,item.code,item.amount,item.instance))return error(18);
  const before=env.mevcut(working,STONE),added=env.ekle(working,[{type:1,code:STONE,amount:quantity}]);
  if(env.mevcut(working,STONE)!==before+quantity)return error(1);
  const money=y.paraHarca([{type:0,code:0,amount:silver}]);if(!money)return error(13);
  try{kaydet(working);}catch(e){if(typeof y.paraIcinOdul==='function')y.paraIcinOdul([{type:0,code:0,amount:silver}]);return error(1);}
  Object.assign(durum,working);y.ekOnce(0x01180105,money,'REFINERY-silver');
  for(const item of selected)notice(durum,item.code,item.instance);
  y.ekOnce(env.OP_NTF,env.kazancPaketi(durum,added),'REFINERY-product');
  return error(0);
 };
 return H;
}
module.exports={STONE,state,rates,info,recipients,kur};
