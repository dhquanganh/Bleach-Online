'use strict';
const fs=require('node:fs'),runtime=require('./runtime-path'),env=require('./envanter'),event=require('./etkinlik'),{Y}=require('./paket');
const fields={'0:0':['gumus',0],'0:1':['altin',3],'0:2':['kupon',1],'3:0':['askeriEmir',2],'5:0':['prestij',5],'6:0':['generalsSoul',4],'7:3':['blueSoul',7],'7:4':['purpleSoul',8],'7:5':['goldSoulV',9],'7:6':['orangeSoul',10]};
function supports(wire){return event.katalog().get(wire)?.kategori===130000;}
function progress(d){return Math.min(2000000000,Math.max(0,Math.floor(Number(d.topup?.toplam)||0)));}
function atomic(file,value){const tmp=file+'.topup-gift.tmp';fs.writeFileSync(tmp,JSON.stringify(value,null,2));fs.renameSync(tmp,file);}
function recover(d){
 const file=runtime('veri.json');if(!fs.existsSync(file))return;const v=JSON.parse(fs.readFileSync(file,'utf8'));if(!v.topUpGiftPending)return;
 const pending=v.topUpGiftPending;atomic(runtime('oyuncu.json'),pending);delete v.topUpGiftPending;atomic(file,v);if(d){for(const k of Object.keys(d))delete d[k];Object.assign(d,pending);}
}
function persist(v,next,save){v.topUpGiftPending=next;atomic(runtime('veri.json'),v);try{save(next);delete v.topUpGiftPending;atomic(runtime('veri.json'),v);}catch(e){recover();}}
function init(wire,d){
 recover(d);const tiers=event.kademeler(wire),paid=progress(d),w=new Y().u32(wire).u16(2).u32(2).u32(1).u16(1).u32(paid).u16(tiers.length);
 for(const tier of tiers)w.i32(tier.index).u32(1).i32(event.alinmisMi(d,wire,tier.index)?-1:paid>=tier.sart?1:0).u16(1).u32(tier.sart);
 return w.done();
}
function updates(d){return [...event.katalog().keys()].filter(wire=>supports(wire)&&event.acikMi(wire)).map(wire=>({id:0x01182302,payload:init(wire,d)}));}
function operate(ctx,y){
 const p=ctx.payload,wire=p.length>=4?p.readUInt32BE():0,fail=n=>event.operateRet(n,wire,[]);
 if(!supports(wire)||!event.acikMi(wire)||(p.length!==8&&!(p.length===10&&p.readUInt16BE(8)===0)))return fail(80);
 recover(ctx.durum);const index=p.readUInt32BE(4),tiers=event.kademeler(wire),tier=tiers.find(t=>t.index===index);if(!tier)return fail(80);
 if(event.alinmisMi(ctx.durum,wire,index))return fail(99);if(progress(ctx.durum)<tier.sart)return fail(80);
 if(tiers.some(t=>t.index<index&&!event.alinmisMi(ctx.durum,wire,t.index)))return fail(80);
 const rewards=event.kademeOdulleri(tier);if(!rewards.length)return fail(1);
 const next=structuredClone(ctx.durum),file=runtime('veri.json'),v=JSON.parse(fs.readFileSync(file,'utf8')),items=[],counts=new Map(),updated=[];
 for(const r of rewards){
  if(!Number.isSafeInteger(r.amount)||r.amount<=0)return fail(1);const field=fields[r.type+':'+r.code];
  if(field){const [key,idx]=field;v[key]=Math.min(2000000000,(Number(v[key])||0)+r.amount);next[key]=v[key];updated.push(idx===0?{index:idx,v:Number(v.gumusHigh)||0,a:v[key]}:{index:idx,v:v[key]});}
  else{const code=env.odulTemplate(r.type,r.code);if(!env.article(code))return fail(1);counts.set(code,(counts.get(code)||0)+r.amount);items.push(r);}
 }
 if([...counts].some(([code,n])=>env.mevcut(next,code)+n>env.MAX_ADET))return fail(1);
 const before=new Map([...counts].map(([code])=>[code,env.mevcut(next,code)]));env.ekle(next,items);if([...counts].some(([code,n])=>env.mevcut(next,code)!==before.get(code)+n))return fail(1);
 event.etkinlikDurum(next,wire).alinan.push(index);
 // A durable currency journal completes both files after interruption; retries see the claim.
 persist(v,next,ctx.kaydet);
 Object.assign(ctx.durum,next);
 if(items.length)y.ekSonra(0x01180f00,env.loadBagPaketi(next),'TOPUPGIFT-bag');
 if(updated.length)y.ekSonra(0x01180105,require('./harita').baseInfoUpdate(updated),'TOPUPGIFT-money');
 y.ekSonra(0x01182305,event.bildirimPaketi(wire,index,-1,[tier.sart]),'TOPUPGIFT-claimed');
 y.ekSonra(0x01182302,init(wire,next),'TOPUPGIFT-refresh');return event.operateRet(0,wire,rewards);
}
module.exports={supports,progress,init,operate,recover,updates,persist};
