'use strict';
const fs=require('node:fs'),runtime=require('./runtime-path'),{Y,tablo}=require('./paket');
const inventory=require('./envanter'),bands=require('./arena-materials.json');
const journal=()=>runtime('arena-reward-pending.json');
function recover(){
  if(!fs.existsSync(journal()))return;
  const pending=JSON.parse(fs.readFileSync(journal(),'utf8'));
  if(!pending.account||!pending.player)throw Error('Invalid Arena reward journal');
  fs.writeFileSync(runtime('veri.json'),JSON.stringify(pending.account,null,2));
  fs.writeFileSync(runtime('oyuncu.json'),JSON.stringify(pending.player,null,2));
  fs.unlinkSync(journal());
}
// Redo a transaction interrupted between the account and player writes.
recover();
function rewards(ranking,level){
  const quality=tablo('RankComposeQuality').liste.find(r=>ranking>=r.from&&ranking<=r.to&&r.from>0)?.quality;
  const money=tablo('RankMoney').byId.get(ranking);
  const band=bands.find(b=>level>=b.from&&level<=b.to);
  if(!Number.isInteger(ranking)||!Number.isInteger(level)||!quality||!money||!band)return null;
  const [code,amount]=band.rewards[quality-1];
  return [{type:1,code,amount},{type:0,code:0,amount:Math.floor(2000*Math.pow(2,level/20)*Math.log(6561/(ranking+8))/Math.log(3))},{type:5,code:0,amount:Number(money.prestige)}];
}
function info(d,settlement=require('./arena-real').reward(),now=Date.now()){
  const valid=settlement&&settlement.releasedAt<=now&&settlement.ranking>=1&&settlement.ranking<=1000&&rewards(settlement.ranking,settlement.level);
  if(!valid)return {type:0,ranking:0,level:0};
  const claimed=String(d.arenaReward?.period||'')>=settlement.period;
  return {type:claimed?2:1,ranking:settlement.ranking,level:settlement.level};
}
function commit(d,next,account,save){
  const vf=runtime('veri.json'),pf=runtime('oyuncu.json');
  const oldV=fs.readFileSync(vf),oldP=fs.existsSync(pf)?fs.readFileSync(pf):null;
  try{
    fs.writeFileSync(journal()+'.tmp',JSON.stringify({account,player:next}));
    fs.renameSync(journal()+'.tmp',journal());
    fs.writeFileSync(vf,JSON.stringify(account,null,2));
    save(next);
    fs.unlinkSync(journal());
  }catch(e){
    fs.writeFileSync(vf,oldV);
    if(oldP)fs.writeFileSync(pf,oldP);else if(fs.existsSync(pf))fs.unlinkSync(pf);
    if(fs.existsSync(journal()))fs.unlinkSync(journal());
    throw e;
  }
  for(const key of Object.keys(d))delete d[key];Object.assign(d,next);
}
function claim({payload,durum:d,kaydet},y,{settlement=require('./arena-real').reward(),now=Date.now()}={}){
  const error=()=>new Y().u32(1).done();
  if(payload?.length||info(d,settlement,now).type!==1)return error();
  const awards=rewards(settlement.ranking,settlement.level),next=structuredClone(d);
  let account,items,ntf;
  try{
    account=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));
    const item=awards[0],before=inventory.mevcut(next,item.code);
    items=inventory.ekle(next,[item]);
    if(inventory.mevcut(next,item.code)!==before+item.amount||items.length!==1)return error();
    ntf=inventory.kazancPaketi(next,items);
    const silver=(BigInt(account.gumusHigh||0)<<32n)+BigInt(account.gumus||0)+BigInt(awards[1].amount);
    const prestige=require('./military-rank').prestige(d,account)+awards[2].amount;
    if(silver>0xffffffffffffffffn||prestige>0xffffffff)return error();
    account.gumusHigh=Number(silver>>32n);account.gumus=Number(silver&0xffffffffn);account.prestij=prestige;
    next.gumusHigh=account.gumusHigh;next.gumus=account.gumus;next.prestige=prestige;
    next.arenaReward={period:settlement.period,ranking:settlement.ranking,level:settlement.level,claimedAt:now,awards};
    commit(d,next,account,kaydet);
  }catch(e){console.error('[Arena reward] claim failed:',e.message);return error();}
  if(ntf)y.ekSonra(inventory.OP_NTF,ntf,'ARENA-reward-items');
  y.ekSonra(0x01180105,require('./harita').baseInfoUpdate([
    {index:0,v:account.gumusHigh,a:account.gumus},{index:5,v:account.prestij}
  ]),'ARENA-reward-currencies');
  const w=new Y().u32(0).u16(awards.length);
  for(const a of awards)w.i16(a.type).i32(a.code).i32(a.amount);
  return w.done();
}
module.exports={info,claim,rewards,recover};
