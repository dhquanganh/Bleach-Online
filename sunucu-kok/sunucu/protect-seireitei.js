"use strict";
const {Y,O,satir,cv,simdi}=require('./paket'),env=require('./envanter'),levels=require('./seviye'),codec=require('./kodek'),crypto=require('crypto'),config=require('./protect-seireitei-config.json');
const OP={ENTER:0x01180208,FIGHT:0x01182401,RANK:0x01182403,HP:0x01182404,STATUS:0x01182406,REPORT:0x01182407,END:0x01182408,REPLAY:0x0181247d};
const day=t=>Math.floor((t+7*3600)/86400),clone=d=>JSON.parse(JSON.stringify(d));
function level(){return Math.max(1,Math.min(159,levels.anaDurum(levels.veriOku()).lv));}
function enemy(s){return satir('Enemy',(s.doorIndex?config.innerEnemyBase:config.outerEnemyBase)+s.worldLevel);}
function state(d,now=simdi(),lv=level()){
 let s=d.protectSeireitei;
 if(!s||s.day!==day(now)){
  const previous=s;
  s=d.protectSeireitei={day:day(now),active:!!(previous&&previous.active),atDoor:!!(previous&&previous.atDoor),worldLevel:previous?previous.worldLevel:lv,doorIndex:previous?previous.doorIndex:0,hp:0,damage:0,battles:0,revives:0,deadUntil:previous?previous.deadUntil:0,nextFight:previous?Number(previous.nextFight)||0:0,finished:!!(previous&&previous.finished),reports:[]};
  s.hp=previous?previous.hp:Number(enemy(s).hp);
 }
 s.reports=Array.isArray(s.reports)?s.reports:[];return s;
}
function ranks(d,s){const w=new Y().u16(0).u16(s.damage>0?1:0);if(s.damage>0)w.utf(d.nick||'Shinigami').u32(s.damage);return w.done();}
function status(d,value){return new Y().u32(d.roleIdHi||0).u32(d.roleIdLo||1).u8(value).u32((d.protectSeireitei||{}).deadUntil||0).u32((d.protectSeireitei||{}).nextFight||0).done();}
function entry(d,s,now){const w=new Y().u32(0).u8(1).u32(now).utf('Seireitei').u8(s.doorIndex).u32(s.worldLevel).f32(s.hp).u8(0).u32(s.revives);
 w.u16(1).u32(d.roleIdHi||0).u32(d.roleIdLo||1).i8(s.deadUntil>now?0:1).utf(d.nick||'Shinigami').u8(3).u32(40100001).u8(0).u32(0).u32(levels.anaId()).u8(1).u16(s.worldLevel).u32(1000).u8(0);
 return w.raw(ranks(d,s)).done();}
function logPacket(d,row){return new Y().utf(d.nick||'Shinigami').u8(1).u8(row.won?1:0).utf(row.id).f32(row.hp).done();}
function fail(code,ready=0){return {error:code,ack:new Y().u32(code).u32(ready).done()};}
function kur(y,options={}){
 const now=options.now||simdi,lv=options.level||level,simulate=options.simulate||((id,hp,d)=>require('./savas').cityDefendBattle(id,hp,d));const H={};
 H['0x01810208']=ctx=>{
  if(ctx.payload&&ctx.payload.length)return new Y().u32(4).done();
  const next=clone(ctx.durum),s=state(next,now(),lv());
  if(s.finished){s.doorIndex=0;s.worldLevel=lv();s.hp=Number(enemy(s).hp);s.finished=false;}
  s.active=true;s.atDoor=false;
  try{ctx.kaydet(next);}catch(e){return new Y().u32(1).done();}Object.assign(ctx.durum,next);
  for(const row of s.reports)y.ekSonra(OP.REPORT,logPacket(next,row),'PROTECT-history');
  return entry(next,s,now());
 };
 H['0x01812400']=ctx=>{
  if(ctx.payload.length!==1||ctx.payload[0]>1)return {id:OP.STATUS,payload:status(ctx.durum,2)};
  const next=clone(ctx.durum),s=state(next,now(),lv());
  if(!s.active||s.finished)return {id:OP.STATUS,payload:status(next,2)};
  s.atDoor=ctx.payload[0]===1&&s.deadUntil<=now();
  try{ctx.kaydet(next);}catch(e){return {id:OP.STATUS,payload:status(ctx.durum,2)};}Object.assign(ctx.durum,next);
  return {id:OP.STATUS,payload:status(next,s.deadUntil>now()?0:s.atDoor?1:2)};
 };
 H['0x01812402']=ctx=>{
  if(ctx.payload.length)return new Y().u32(4).done();
  const next=clone(ctx.durum),s=state(next,now(),lv());if(!s.active||s.deadUntil<=now())return new Y().u32(1).done();
  const thresholds=cv(60230022,{'10000':10}),key=Object.keys(thresholds).map(Number).filter(n=>n>s.revives).sort((a,b)=>a-b)[0];
  const cost=Number(cv(60230006,1))*Number(thresholds[String(key)]||1),award=[{type:0,code:1,amount:cost}];
  const charged=y.paraHarca(award);if(!charged)return new Y().u32(16).done();s.deadUntil=0;s.atDoor=false;s.revives++;
  try{ctx.kaydet(next);}catch(e){y.paraIcinOdul(award);return new Y().u32(1).done();}Object.assign(ctx.durum,next);
  y.ekSonra(0x01180105,charged,'PROTECT-revive-cost');return new Y().u32(0).done();
 };
 function fight(ctx){
  if(ctx.payload.length!==8||ctx.payload.readUInt32BE(0)!==0||ctx.payload.readUInt32BE(4)!==0)return fail(4);
  const next=clone(ctx.durum),s=state(next,now(),lv()),time=now();
  if(!s.active||!s.atDoor||s.finished||s.deadUntil>time)return fail(1,s.deadUntil);
  if(time<s.nextFight)return fail(1,s.nextFight);
  const rewards=[{type:1,code:config.rewardItem,amount:config.rewardAmount}],owned=env.mevcut(next,config.rewardItem);
  env.ekle(next,rewards);
  if(owned+config.rewardAmount>env.MAX_ADET||env.mevcut(next,config.rewardItem)!==owned+config.rewardAmount||!env.liste(next).some(x=>x.code===config.rewardItem&&x.amount===owned+config.rewardAmount))return fail(1);
  const mob=enemy(s),battle=simulate(mob._id||parseInt(mob.id,16),s.hp,next);
  if(!battle||!Buffer.isBuffer(battle.payload)||!Number.isFinite(battle.damage)||battle.damage<0)throw Error('Invalid Protect Seireitei battle report');
  const damage=Math.min(s.hp,Math.max(0,Math.floor(battle.damage))),remaining=Math.max(0,s.hp-damage);
  s.hp=remaining;s.damage=Math.min(0xffffffff,s.damage+damage);s.battles++;s.nextFight=time+config.fightCooldownSeconds;
  s.deadUntil=battle.won?0:time+config.deathSeconds;if(!battle.won)s.atDoor=false;
  const row={id:crypto.randomUUID(),won:!!battle.won,hp:remaining,report:battle.payload.toString('base64')};s.reports.push(row);s.reports=s.reports.slice(-config.historyLimit);
  const updates=[{id:OP.RANK,payload:ranks(next,s)},{id:OP.REPORT,payload:logPacket(next,row)},{id:OP.HP,payload:new Y().f32(remaining).done()}];
  if(remaining===0){
   s.deadUntil=0;s.atDoor=false;
   if(s.doorIndex===0){s.doorIndex=1;s.hp=Number(enemy(s).hp);}
   else{s.finished=true;s.active=false;updates.push({id:OP.END,payload:Buffer.alloc(0)});}
  }
  updates.push({id:OP.STATUS,payload:status(next,s.deadUntil>time?0:1)},{id:0x01180f00,payload:env.loadBagPaketi(next)});
  if(y.olay)y.olay.say(next,'dailyActivityProtect',1);
  try{ctx.kaydet(next);}catch(e){return fail(1);}Object.assign(ctx.durum,next);
  return {ack:new Y().u32(0).u32(s.nextFight).done(),report:battle.payload,result:codec.encodeSingleResult(!!battle.won,rewards),updates};
 }
 function replay(ctx){
  if(ctx.payload.length<2||ctx.payload.readUInt16BE(0)+2!==ctx.payload.length)return fail(4);
  const s=state(clone(ctx.durum),now(),lv()),id=new O(ctx.payload).utf(),row=s.reports.find(x=>x.id===id);
  if(!s.active||!row)return fail(4);
  return {ack:new Y().u32(0).u32(s.nextFight).done(),report:Buffer.from(row.report,'base64'),result:codec.encodeSingleResult(row.won,[]),updates:[]};
 }
 return {handlers:H,fight,replay};
}
module.exports={OP,config,state,enemy,entry,kur};
