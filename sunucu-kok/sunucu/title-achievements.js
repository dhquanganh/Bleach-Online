'use strict';
const fs=require('fs'),runtime=require('./runtime-path'),{Y,satir,tablo,json}=require('./paket'),titles=require('./titles'),env=require('./envanter');
function progress(d,a,v){const conditions=json(a.conditonString,[]),needs=json(a.f6,[]);return conditions.map((c,i)=>{const need=Number(needs[i])||1;let value=Number(d.achievementProgress?.[a._id]?.[c.type])||0;
 if(c.type===12)value=Number(v.level)||1;
 if(c.type===8)value=require('./military-rank').id(d,v)>=Number(c.value1)?need:0;
 if(c.type===2)value=Object.entries(d.instanceProgress||{}).some(([key,stage])=>{const campaign=satir('Single',Number(key.split(':')[1]));return campaign&&Number(c.value1)>=Number(campaign.startId)&&Number(c.value1)<=Number(campaign.endId)&&Number(stage)>Number(c.value1);})?need:0;
 if(c.type===26)value=Number(d.ev?.level)>=Number(c.value1)?need:0;
 if(c.type===27)value=Number(d.ev?.kiz)||0;
 if(c.type===29)value=Number(d.olay?.sayac?.summon)||0;
 if(c.type===35)value=Number(v.altin)||0;
 if(c.type===36)value=Number(v.achievementGoldSpent??v.ultimateBP?.spent)||0;
 if(c.type===34)value=require('./reincarnation').owned(d,Number(c.value1),v)?need:0;
 if(d.basari?.[a._id]||a.f8&&titles.state(d).owned[a.f8])value=need;
 return {type:Number(c.type),need,value:Math.max(0,Math.min(need,Math.floor(value)))};});}
function account(){return JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));}
function write(file,data){const tmp=file+'.title.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file);}
function recover(){if(!fs.existsSync(runtime('veri.json')))return;const v=account();if(!v.titlePending)return;write(runtime('oyuncu.json'),v.titlePending);delete v.titlePending;write(runtime('veri.json'),v);}
function row(w,d,a,v){const p=progress(d,a,v);w.u32(a._id).u32(d.basari?.[a._id]?1:0).u16(p.length);for(const x of p)w.u32(x.type).u32(x.value);return w;}
function info(d,v=account()){const rows=tablo('Achievement').liste,w=new Y().u16(rows.length);for(const a of rows)row(w,d,a,v);return w.done();}
function claim({payload,durum:d,kaydet:save},push){const id=payload?.length===4?payload.readUInt32BE():0,ret=n=>new Y().u32(n).u32(id).done(),a=satir('Achievement',id);if(!a||d.basari?.[id])return ret(4);const v=account(),p=progress(d,a,v);if(!p.length||p.some(x=>x.value<x.need))return ret(4);
 const next=structuredClone(d),awards=json(a.titleID,[]),counts=new Map();const fields={'0:0':'gumus','0:1':'altin','0:2':'kupon','3:0':'askeriEmir','5:0':'prestij','6:0':'generalsSoul','7:3':'blueSoul','7:4':'purpleSoul','7:5':'goldSoulV','7:6':'orangeSoul'};
 for(const x of awards){if(fields[x.type+':'+x.code]||x.type===2)continue;const code=env.odulTemplate(x.type,x.code);if(!code||!env.article(code))return ret(4);counts.set(code,(counts.get(code)||0)+x.amount);}
 for(const [code,n]of counts)if(env.mevcut(next,code)+n>env.MAX_ADET)return ret(4);
 env.ekle(next,awards.filter(x=>!fields[x.type+':'+x.code]&&x.type!==2));for(const [code,n]of counts)if(env.mevcut(next,code)!==env.mevcut(d,code)+n)return ret(4);
 for(const x of awards){const field=fields[x.type+':'+x.code];if(field){if((Number(v[field])||0)+x.amount>2000000000)return ret(4);v[field]=(Number(v[field])||0)+x.amount;next[field]=v[field];}else if(x.type===2)require('./seviye').expEkle(next,x.amount,v);}
 next.basari||={};next.basari[id]=1;if(a.f8&&!titles.state(next).owned[a.f8])titles.grant(next,Number(a.f8),'achievement');
 v.titlePending=next;write(runtime('veri.json'),v);try{save(next);delete v.titlePending;write(runtime('veri.json'),v);}catch(error){recover();}Object.assign(d,next);
 push(0x01180f00,env.loadBagPaketi(next),'TITLE-achievement-bag');push(0x01185202,row(new Y(),next,a,v).done(),'TITLE-achievement');push(0x01185203,titles.info(next),'TITLE-owned');push(0x01185204,titles.change(next),'TITLE-equip');titles.stats(next,push);
 const updates=Object.entries(fields).filter(([key])=>awards.some(x=>x.type+':'+x.code===key)).map(([key,field])=>({index:{'0:0':0,'0:1':3,'0:2':1,'3:0':2,'5:0':5,'6:0':4,'7:3':7,'7:4':8,'7:5':9,'7:6':10}[key],v:key==='0:0'?Number(v.gumusHigh)||0:v[field],...(key==='0:0'?{a:v[field]}:{})}));const exp=awards.filter(x=>x.type===2).reduce((n,x)=>n+x.amount,0);if(exp)updates.push({index:11,v:exp});if(updates.length)push(0x01180105,require('./harita').baseInfoUpdate(updates),'TITLE-achievement-currency');return ret(0);
}
module.exports={progress,info,claim,recover};
