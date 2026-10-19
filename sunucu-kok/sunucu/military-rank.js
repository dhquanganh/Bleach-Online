'use strict';
// One account-scoped source for login, rank packets, roster limits and combat stats.
const fs=require('node:fs'),runtime=require('./runtime-path'),{tablo,json,Y,gunluk}=require('./paket');
const FIRST=40100001,MAX=40100036;
const valid=n=>Number.isInteger(Number(n))&&Number(n)>=FIRST&&Number(n)<=MAX;
const read=()=>{try{return JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));}catch{return {};}};
function id(d={},v=read()){return valid(v.rutbe)?Number(v.rutbe):valid(d.militaryRank)?Number(d.militaryRank):FIRST;}
function prestige(d={},v=read()){const n=Object.hasOwn(v,'prestij')?v.prestij:d.prestige;return Math.max(0,Math.min(0xffffffff,Math.floor(Number(n)||0)));}
function row(d={},v=read()){return tablo('Military').byId.get(id(d,v));}
function patchLogin(payload,d={},v=read()){
  const b=Buffer.from(payload);let p=8;p+=2+b.readUInt16BE(p);p+=8;p+=2+b.readUInt16BE(p);p+=4;
  b.writeUInt32BE(id(d||{},v),p);b.writeUInt32BE(prestige(d||{},v),p+4);return b;
}
function inFormation(d,heroId){
  const main=Number(d?.karakter?.anaId)||require('./seviye').anaId();
  return Number(d?.kadro?.[String(heroId)])>0||Number(heroId)===main&&!Object.hasOwn(d?.kadro||{},String(main));
}
function bonuses(d,heroId){return inFormation(d,heroId)?json(row(d).addOther,{}).addOther||[]:[];}
function refresh(y,d,ids){
  const v=read(),owned=new Set(ids||[require('./seviye').anaId(),...(v.herolar||[]),...Object.keys(d.kadro||{}),...require('./meyhane').alinanlar(d)]);
  for(const hero of owned){const hid=Number(hero);if(!require('./statlar').heroById.has(hid)||!require('./retired-heroes').allowed(hid))continue;
    const packet=require('./ekipman').statPaketi(d,hid,require('./seviye').heroSeviye(d,hid,v));
    if(packet)y.ekSonra(0x01180104,packet,'MILITARY-stat');
  }
}
function commit(d,next,v,kaydet){
  const account=runtime('veri.json'),player=runtime('oyuncu.json');
  const oldAccount=fs.existsSync(account)?fs.readFileSync(account):null,oldPlayer=fs.existsSync(player)?fs.readFileSync(player):null;
  try{
    fs.writeFileSync(account,JSON.stringify(v,null,2));kaydet(next);
    for(const k of Object.keys(d))delete d[k];Object.assign(d,next);
  }catch(e){
    if(oldAccount)fs.writeFileSync(account,oldAccount);else if(fs.existsSync(account))fs.unlinkSync(account);
    if(oldPlayer)fs.writeFileSync(player,oldPlayer);else if(fs.existsSync(player))fs.unlinkSync(player);
    throw e;
  }
}
function kur(y){
  const packet=(d,error)=>{const v=read();return new Y().u8(error).u32(id(d,v)).u32(prestige(d,v)).u8(gunluk(d).maas?1:0).done();};
  const init=(d,kaydet)=>{
    const v=read(),rank=id(d,v),credit=prestige(d,v);
    if(v.rutbe!==rank||v.prestij!==credit||d.militaryRank!==rank||d.prestige!==credit){
      const next=JSON.parse(JSON.stringify(d));next.militaryRank=rank;next.prestige=credit;v.rutbe=rank;v.prestij=credit;
      commit(d,next,v,kaydet);
    }
  };
  return {
    '0x01810800':({durum:d,kaydet})=>{
      init(d,kaydet);return packet(d,0).subarray(1);
    },
    '0x01810801':({payload,durum:d,kaydet})=>{
      if(payload&&payload.length)return packet(d,1);
      const v=read(),current=id(d,v),nextRow=tablo('Military').byId.get(current+1);
      if(!nextRow||prestige(d,v)<Number(nextRow.needCredit))return packet(d,1);
      const next=JSON.parse(JSON.stringify(d));next.militaryRank=current+1;next.prestige=prestige(d,v);
      v.rutbe=next.militaryRank;v.prestij=next.prestige;
      // costCredit is DAILY upkeep, not the price of promotion.
      if(y.olay?.ayarla)y.olay.ayarla(next,'militaryRank',next.militaryRank);
      try{commit(d,next,v,kaydet);}catch{return packet(d,1);}
      refresh(y,d);return packet(d,0);
    },
    '0x01810802':({payload,durum:d,kaydet})=>{
      const error=()=>new Y().u8(1).u32(0).u32(0).u32(0).done();
      if(payload&&payload.length)return error();
      const next=JSON.parse(JSON.stringify(d)),g=gunluk(next),v=read(),m=row(d,v),cost=Number(m.costCredit)||0;
      if(g.maas||prestige(d,v)<cost)return error();
      const awards=json(m.salary,{}).award||[];
      const silver=awards.filter(a=>a.type===0&&a.code===0).reduce((sum,a)=>sum+BigInt(a.amount),0n);
      const souls=awards.filter(a=>a.type===6&&a.code===0).reduce((sum,a)=>sum+Number(a.amount),0);
      const total=(BigInt(Number(v.gumusHigh)||0)<<32n)+BigInt(Number(v.gumus)||0)+silver;
      if(total>0xffffffffffffffffn||(Number(v.generalsSoul)||0)+souls>0xffffffff)return error();
      v.gumusHigh=Number(total>>32n);v.gumus=Number(total&0xffffffffn);v.generalsSoul=(Number(v.generalsSoul)||0)+souls;
      v.rutbe=id(d,v);v.prestij=prestige(d,v)-cost;next.militaryRank=v.rutbe;next.prestige=v.prestij;g.maas=1;
      for(const key of ['gumusHigh','gumus','generalsSoul'])next[key]=v[key];
      try{commit(d,next,v,kaydet);}catch{return error();}
      y.ekSonra(0x01180105,require('./harita').baseInfoUpdate([{index:5,v:v.prestij},{index:0,v:v.gumusHigh,a:v.gumus},{index:4,v:v.generalsSoul}]),'MILITARY-salary');
      return new Y().u8(0).u32(v.gumusHigh).u32(v.gumus).u32(v.generalsSoul).done();
    }
  };
}
module.exports={FIRST,MAX,id,prestige,row,patchLogin,inFormation,bonuses,refresh,kur};
