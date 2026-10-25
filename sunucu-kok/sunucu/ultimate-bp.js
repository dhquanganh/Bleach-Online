'use strict';
const fs=require('fs'),runtime=require('./runtime-path'),config=require('./ultimate-bp-config'),env=require('./envanter');
const MAGIC=62000450;
function atomic(file,value){const tmp=file+'.ultimate.tmp';fs.writeFileSync(tmp,JSON.stringify(value,null,2));fs.renameSync(tmp,file);}
function account(){return JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));}
function recover(){if(!fs.existsSync(runtime('veri.json')))return;const v=account();if(!v.ultimateBPPending)return;atomic(runtime('oyuncu.json'),v.ultimateBPPending);delete v.ultimateBPPending;atomic(runtime('veri.json'),v);}
function state(d){return d.ultimateBP||{claims:[0,0,0,0,0],heroes:[]};}
function pieces(v){return Math.max(0,Number(v.ultimateBP?.pieces)||0);}
function boxes(d,v,c=config.read()){
 const s=state(d),n=pieces(v),owned=require('./reincarnation').owned(d,c.heroId,v);
 return [{idx:0,acq:1,st:owned||s.heroes.includes(c.heroId)?-1:n>=c.price?1:0},{idx:1,acq:1,st:-1},...c.rewards.map((r,i)=>({idx:i+2,acq:1,st:n>=Math.min(2147483647,r.condition+(s.claims[i]||0)*c.cycleStep)?1:0})),{idx:7,acq:2,st:-1},{idx:8,acq:2,st:-1}];
}
function parameters(d,v,c=config.read()){const s=state(d);return [pieces(v),0,MAGIC,c.revision,c.heroId,c.price,...c.rewards.flatMap((r,i)=>[Math.min(2147483647,r.condition+(s.claims[i]||0)*c.cycleStep),r.items.length,...r.items.flatMap(a=>[a.type,a.code,a.amount])])];}
function init(wire,d){const v=account();const {Y}=require('./paket'),c=config.read(),b=boxes(d,v,c),p=parameters(d,v,c);const w=new Y().u32(wire).u16(3).u32(2).u32(1).u32(9).u16(p.length);for(const n of p)w.u32(n);w.u16(b.length);for(const x of b)w.i32(x.idx).u32(x.acq).i32(x.st).u16(0);return require('./ultimate-bp-ranking').write(w).done();}
function operate(wire,index,args,d,save){
 const fail=n=>({hata:n,oduller:[]});
 if(!Number.isInteger(index)||![0,2,3,4,5,6].includes(index))return fail(80);
 const c=config.read();if(args.length!==1||args[0]!==c.revision)return fail(80);
 const v=account(),next=structuredClone(d),s=next.ultimateBP=structuredClone(state(d));
 if(boxes(next,v,c).find(b=>b.idx===index).st!==1)return fail(80);
 let rewards=[];
 if(index===0){s.heroes.push(c.heroId);v.herolar=[...new Set([...(v.herolar||[]).map(Number),c.heroId])];require('./seviye').heroKayit(next,c.heroId,1);next.meyhane||={};next.meyhane.alinan||={};next.meyhane.alinan[c.heroId]=1;}
 else{
  rewards=c.rewards[index-2].items;
  const counts=new Map();for(const a of rewards){if([0,2,3,5,6,7].includes(a.type))continue;const id=env.odulTemplate(a.type,a.code);counts.set(id,(counts.get(id)||0)+a.amount);}
  if([...counts].some(([id,n])=>env.mevcut(next,id)+n>env.MAX_ADET))return fail(80);
  const itemRewards=rewards.filter(a=>![0,2,3,5,6,7].includes(a.type));env.ekle(next,itemRewards);
  if([...counts].some(([id,n])=>env.mevcut(next,id)!==env.mevcut(d,id)+n))return fail(80);
  const fields={'0:0':'gumus','0:1':'altin','0:2':'kupon','3:0':'askeriEmir','5:0':'prestij','6:0':'generalsSoul','7:3':'blueSoul','7:4':'purpleSoul','7:5':'goldSoulV','7:6':'orangeSoul'};
  for(const a of rewards){const field=fields[a.type+':'+a.code];if(field){v[field]=Math.min(2000000000,(Number(v[field])||0)+a.amount);next[field]=v[field];}else if(a.type===2)require('./seviye').expEkle(next,a.amount,v);}
  s.claims[index-2]=(s.claims[index-2]||0)+1;
 }
 v.ultimateBPPending=next;atomic(runtime('veri.json'),v);
 try{save(next);delete v.ultimateBPPending;atomic(runtime('veri.json'),v);}catch(e){recover();}
 Object.assign(d,next);return {hata:0,oduller:rewards,hero:index===0?c.heroId:0};
}
function reset(id,d,save){
 const v=account();if(!require('./ultimate-bp-ranking').reset(d,v,id))return;
 v.ultimateBPPending=d;atomic(runtime('veri.json'),v);
 try{save(d);delete v.ultimateBPPending;atomic(runtime('veri.json'),v);}catch(e){recover();}
}
module.exports={init,operate,recover,reset,boxes,parameters,pieces,MAGIC};
