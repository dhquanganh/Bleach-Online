'use strict';
const fs=require('node:fs'),runtime=require('./runtime-path'),env=require('./envanter'),{Y,cv,satir,json}=require('./paket');
const fail=n=>new Y().u32(n).done(),limit=2000000000;
function atomic(file,value){const tmp=file+'.evolution.tmp';fs.writeFileSync(tmp,JSON.stringify(value,null,2));fs.renameSync(tmp,file);}
function recover(d){const file=runtime('veri.json');if(!fs.existsSync(file))return;const v=JSON.parse(fs.readFileSync(file,'utf8')),pending=v.itemEvolutionPending;if(!pending)return;atomic(runtime('oyuncu.json'),pending);delete v.itemEvolutionPending;atomic(file,v);if(d){for(const k of Object.keys(d))delete d[k];Object.assign(d,pending);}}
function persist(ctx,d,v){v.itemEvolutionPending=d;atomic(runtime('veri.json'),v);try{ctx.kaydet(d);delete v.itemEvolutionPending;atomic(runtime('veri.json'),v);}catch(e){recover();}for(const k of Object.keys(ctx.durum))delete ctx.durum[k];Object.assign(ctx.durum,d);}
const date=t=>new Date((t+25200)*1000).toISOString().slice(0,10),uint=n=>Number.isSafeInteger(n)&&n>=0&&n<=limit;
function state(d,now){let f=d.ocak;if(!f)f=d.ocak={enerji:Number(cv(62100002,60)),satin:0,is:0,hazir:0,version:2,gun:date(now)};
 if(f.version!==2){f.satin=Math.min(Number(cv(62100001,1)),Math.max(0,3-(Number(f.satin)||0)));f.enerji=!f.is&&!f.hazir&&Number(f.enerji)>0?Number(cv(62100002,60)):0;f.hazir=Math.min(1,Math.max(0,Number(f.hazir)||0));f.version=2;f.gun=date(now);}
 if(f.gun!==date(now)){f.gun=date(now);f.satin=0;f.enerji=Number(cv(62100002,60));}
 for(const key of ['enerji','satin','is','hazir'])if(!uint(f[key]))throw Error('Invalid Item Evolutions state');
 if(f.is&&f.is<=now){f.is=0;f.hazir++;}return f;}
function packet(f){return new Y().u32(0).u32(f.enerji).u32(f.satin).u32(f.is).u32(f.hazir).done();}
function rewards(id){const row=satir('Award',id);if(!row)throw Error('Missing forge award');return json(row.fixed,{}).fixed||[];}
function kur(y,opt={}){const H={},now=opt.now||(()=>Math.floor(Date.now()/1000)),random=opt.random||Math.random;
 function run(ctx,size,fn){if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==size)return fail(4);try{recover(ctx.durum);const d=structuredClone(ctx.durum),v=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8')),e=require('./ekipman'),stamp=now(),x={d,v,e,stamp,bag:false,stats:[],money:false,cost(code,n){if(!Number.isSafeInteger(n)||n<=0||!env.dus(d,code,n))throw Object.assign(Error('Materials'),{code:18});this.bag=true;},award(rows){const totals=new Map();for(const r of rows){const code=env.odulTemplate(r.type,r.code);if(!env.article(code)||!Number.isSafeInteger(r.amount)||r.amount<=0)throw Error('Invalid forge reward');totals.set(code,(totals.get(code)||0)+r.amount);}const before=new Map([...totals].map(([id])=>[id,env.mevcut(d,id)]));if([...totals].some(([id,n])=>before.get(id)+n>env.MAX_ADET))throw Object.assign(Error('Bag full'),{code:1});env.ekle(d,[...totals].map(([code,amount])=>({code,amount})));if([...totals].some(([id,n])=>env.mevcut(d,id)!==before.get(id)+n))throw Error('Reward insertion failed');this.bag=true;},gold(n){if(!Number.isSafeInteger(n)||n<=0||!uint(Number(v.altin))||Number(v.altin)<n)throw Object.assign(Error('Gold'),{code:16});v.altin-=n;d.altin=v.altin;require('./ultimate-bp-spending').earn(v,n);this.money=true;}};
 const result=fn(x);if(result.readUInt32BE()!==0)return result;if(x.bag&&env.liste(d).length+e.cantaKayitlari(d).length>env.MAX_GIRIS)throw Error('Inventory entry limit');persist(ctx,d,v);
 if(x.bag)(y.ekOnce||y.ekSonra)(0x01180f00,env.loadBagPaketi(d),'EVOLUTION-bag');
 if(x.money)y.ekSonra(0x01180105,require('./harita').baseInfoUpdate([{index:3,v:v.altin}]),'EVOLUTION-gold');
 for(const hero of x.stats)if(opt.statPush)try{opt.statPush(d,hero);}catch(e){console.error('[Item Evolutions stats]',e.message);}
 if(x.sync)y.ekSonra(0x01188c00,packet(state(d,stamp)),'EVOLUTION-work');return result;
 }catch(e){if(!e.code||typeof e.code!=='number')console.error('[Item Evolutions]',e.message);return fail(typeof e.code==='number'?e.code:1);}}
 function transform(x,inst,tpl,table){const item=x.e.esya(x.d,inst);if(!item||item.tpl!==tpl||x.e.takiliMi(x.e.depo(x.d),inst))throw Object.assign(Error('Invalid equipment instance'),{code:4});const row=satir(table,item.tpl),source=satir('Article',item.tpl),target=satir('Article',Number(row?.itemId));if(!row||!source||!target||!satir('BaseEquip',target._id)||source.majorType!==target.majorType||source.minorType!==target.minorType)throw Object.assign(Error('Invalid evolution'),{code:4});
 if(table==='EquipAdvance')x.cost(Number(cv(62100010,14100723)),Number(row.needCount));
 else x.award([{type:1,code:Number(cv(62100010,14100723)),amount:Number(row.retCount)}]);
 item.tpl=target._id;item.kat=target.majorType;item.slot=target.minorType;x.bag=true;return fail(0);}
 H['0x01818c01']=ctx=>run(ctx,8,x=>transform(x,ctx.payload.readUInt32BE(4),ctx.payload.readUInt32BE(),'EquipForge'));
 H['0x01818c02']=ctx=>run(ctx,8,x=>transform(x,ctx.payload.readUInt32BE(4),ctx.payload.readUInt32BE(),'EquipAdvance'));
 H['0x01818c00']=ctx=>run(ctx,0,x=>packet(state(x.d,x.stamp)));
 H['0x01818c03']=ctx=>run(ctx,0,x=>{const f=state(x.d,x.stamp),cost=Number(cv(62100009,60));if(f.is||f.hazir||f.enerji<cost)return fail(1);f.enerji-=cost;f.is=x.stamp+Number(cv(62100008,60))*60;return new Y().u32(0).u32(f.enerji).u32(f.is).u32(f.hazir).done();});
 H['0x01818c04']=ctx=>run(ctx,0,x=>{const f=state(x.d,x.stamp);if(f.is||f.satin>=Number(cv(62100001,1)))return fail(1);x.gold(Number(cv(62100005,50)));f.satin++;f.enerji+=Number(cv(62100006,60));return new Y().u32(0).u32(f.enerji).u32(f.satin).done();});
 H['0x01818c05']=ctx=>run(ctx,0,x=>{const f=state(x.d,x.stamp);if(!f.is&&!f.hazir)return fail(1);if(f.is){x.gold(Number(cv(62100007,20)));f.is=0;f.hazir++;}x.sync=true;return fail(0);});
 H['0x01818c06']=ctx=>run(ctx,0,x=>{const f=state(x.d,x.stamp);if(f.is||!f.hazir)return fail(1);const awards=[...rewards(Number(cv(62100003)))],pool=cv(62100004,[]),total=pool.reduce((n,r)=>n+Number(r.rate),0);if(total<=0)throw Error('Invalid bonus reward pool');let roll=random()*total;for(const r of pool){roll-=Number(r.rate);if(roll<0){awards.push(...rewards(Number(r.awardId)));break;}}x.award(awards);f.hazir--;return new Y().u32(0).u32(f.hazir).odul(awards).done();});
 // Smithy progression shares the same inventory instances and must be atomic too.
 H['0x01810e05']=ctx=>run(ctx,8,x=>{const hero=ctx.payload.readUInt32BE(),selector=ctx.payload.readUInt32BE(4),depot=x.e.depo(x.d),inst=hero?Number(depot.takili[hero]?.[selector]):selector,item=x.e.esya(x.d,inst);if(!item||(!hero&&x.e.takiliMi(depot,inst)))return fail(4);const row=satir('EquipUpgrade',item.tpl),a=satir('Article',Number(row?.gotEquipId));if(!row||!a||!satir('BaseEquip',a._id)||a.majorType!==item.kat||a.minorType!==item.slot)return fail(4);const counts=new Map();for(const part of String(row.datum||'').split('|').filter(Boolean)){const [code,n]=part.split('_').map(Number);if(!Number.isSafeInteger(code)||!Number.isSafeInteger(n)||n<=0)throw Error('Invalid upgrade material');counts.set(code,(counts.get(code)||0)+n);}for(const [code,n]of counts)x.cost(code,n);item.tpl=a._id;item.kat=a.majorType;item.slot=a.minorType;
 if(hero){x.stats.push(hero);return new Y().u32(0).u32(hero).raw(x.e.kayitBufInst(x.d,inst)).done();}x.bag=true;return new Y().u32(0).u32(0).done();});
 return H;}
module.exports={kur,state,packet,recover,rewards};
