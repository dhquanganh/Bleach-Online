'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-topup-gift-'));process.env.BLEACH_ACCOUNT_DIR=temp;
for(const f of ['veri.json','oyuncu.json'])fs.copyFileSync(path.join(__dirname,'..',f),path.join(temp,f));
const file=path.join(temp,'veri.json'),player=path.join(temp,'oyuncu.json'),v=JSON.parse(fs.readFileSync(file)),seed=JSON.parse(fs.readFileSync(player));
Object.assign(v,{level:159,altin:1000,vipLevel:0,vipExp:0,kupon:0,purpleSoul:0,goldSoulV:0,askeriEmir:0});seed.topup={gun:{},toplam:0};seed.etkinlik||={};delete seed.etkinlik['12'];fs.writeFileSync(file,JSON.stringify(v));fs.writeFileSync(player,JSON.stringify(seed));
const H=require('../handlers'),S=require('../topup-gift-pack'),event=require('../etkinlik'),env=require('../envanter'),{Y,O}=require('../paket'),state=require('../durum');
const wire=[...event.katalog().keys()].find(S.supports);assert.equal(wire,12);const req=index=>new Y().u32(wire).u32(index).done();
function call(op,payload){H.ekAl();const d=state.yukle(),r=H.byReq[op]({payload,durum:d,kaydet:state.kaydet});return {r,d,notifications:H.ekAl()};}
function decode(b){const o=new O(b);assert.equal(o.u32(),wire);assert.equal(o.u16(),2);assert.equal(o.u32(),2);assert.equal(o.u32(),1);assert.equal(o.u16(),1);const paid=o.u32(),n=o.u16(),states=[];for(let i=0;i<n;i++){const index=o.i32();assert.equal(o.u32(),1);const status=o.i32(),c=o.u16();for(let j=0;j<c;j++)o.u32();states.push({index,status});}assert.equal(o.kalan(),0);return {paid,states};}
try{
 assert(decode(call('0x01812302',new Y().u32(wire).done()).r).states.every(s=>s.status===0),'level 159 and a gold balance must not replace actual top-ups');
 const before=fs.readFileSync(file,'utf8');for(const n of [0,-1,1.5,NaN,Infinity,2000000001])assert.throws(()=>H.topupUygula(n));assert.equal(fs.readFileSync(file,'utf8'),before);
 assert.notEqual(call('0x01812303',req(0)).r.readUInt32BE(),0);
 const credited=H.topupUygula(1);assert.equal(credited.toplam,1);assert(credited.giftPackets.some(p=>p.id===0x01182302&&decode(p.payload).paid===1));
 let current=state.yukle(),vitalityCard=env.mevcut(current,14100028),firstItem=env.mevcut(current,14100045);state.kaydet(current);
 let result=call('0x01812303',req(0));assert.equal(result.r.readUInt32BE(),0);assert.equal(H.sonClaim().ozel,true);assert.equal(env.mevcut(result.d,14100045),firstItem+1);assert.equal(env.mevcut(result.d,14100028),vitalityCard,'Vitality is credited as currency, not a duplicate usable card');assert.equal(JSON.parse(fs.readFileSync(file)).askeriEmir,30);assert(result.notifications.sonra.some(p=>p.id===0x01180f00));assert(result.notifications.sonra.some(p=>p.id===0x01182305));assert.equal(decode(result.notifications.sonra.find(p=>p.id===0x01182302).payload).states[0].status,-1);
 const saved=[fs.readFileSync(file,'utf8'),fs.readFileSync(player,'utf8')];assert.equal(call('0x01812303',req(0)).r.readUInt32BE(),99);assert.deepEqual([fs.readFileSync(file,'utf8'),fs.readFileSync(player,'utf8')],saved);
 H.topupUygula(499999);assert.equal(S.progress(state.yukle()),500000);assert.notEqual(call('0x01812303',req(5)).r.readUInt32BE(),0,'cannot jump over earlier packs');
 for(let index=1;index<=5;index++){result=call('0x01812303',req(index));assert.equal(result.r.readUInt32BE(),0);}
 const money=JSON.parse(fs.readFileSync(file));assert.equal(money.altin,501000);assert.equal(money.kupon,888);assert.equal(money.purpleSoul,50);assert.equal(money.goldSoulV,10);assert.equal(money.topUpGiftPending,undefined);assert(decode(S.init(wire,state.yukle())).states.every(s=>s.status===-1));
 for(const payload of [Buffer.alloc(0),new Y().u32(wire).done(),Buffer.concat([req(0),Buffer.from([0])]),Buffer.concat([req(0),Buffer.from([0,1])]),req(999),Buffer.concat([req(0),Buffer.alloc(6)])])assert.notEqual(call('0x01812303',payload).r.readUInt32BE(),0);
 const open=event.acikMi;event.acikMi=()=>false;try{assert.notEqual(S.operate({payload:req(0),durum:state.yukle(),kaydet:state.kaydet},{ekSonra(){}}).readUInt32BE(),0);}finally{event.acikMi=open;}
 // A valid legacy record with only the final tier claimed must retain the earlier packs.
 const legacy=state.yukle();legacy.etkinlik[wire].alinan=[5];assert.deepEqual(decode(S.init(wire,legacy)).states.map(s=>s.status),[1,1,1,1,1,-1]);
 state.kaydet(legacy);const recovered=S.operate({payload:req(0),durum:legacy,kaydet:()=>{throw Error('interrupted state write');}},{ekSonra(){}});assert.equal(recovered.readUInt32BE(),0);assert(state.yukle().etkinlik[wire].alinan.includes(0));assert.equal(JSON.parse(fs.readFileSync(file)).topUpGiftPending,undefined);assert.equal(S.operate({payload:req(0),durum:state.yukle(),kaydet:state.kaydet},{ekSonra(){}}).readUInt32BE(),99);
 const full=state.yukle();full.etkinlik[wire].alinan=[];env.ekle(full,[{type:1,code:14100045,amount:env.MAX_ADET}]);const currencyBefore=fs.readFileSync(file,'utf8'),fullBefore=JSON.stringify(full);assert.notEqual(S.operate({payload:req(0),durum:full,kaydet:()=>assert.fail('full inventory must not save')},{ekSonra(){}}).readUInt32BE(),0);assert.equal(fs.readFileSync(file,'utf8'),currencyBefore);assert.equal(JSON.stringify(full),fullBefore);
 console.log('PASS Top Up Gift Pack: native progress/tiers, actual recharge only, live packets, strict payloads, sequential unique grants, exact inventory/currencies without proxy duplicates, old final-only claims, journal recovery, bag capacity and real handler routing.');
}finally{fs.rmSync(temp,{recursive:true,force:true});}
