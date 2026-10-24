'use strict';
const config=require('./obito-rage.json'),skills=require('./hero-skills'),{CMD,ST}=require('./kodek');
const isObito=u=>u.id===config.heroId;
const profile=u=>isObito(u)?{...config,mystery:u.obitoRage?{...config.rageMystery,chakraCost:u.obitoRootsCost??40}:config.mystery,standard:u.obitoRage?config.rageStandard:config.standard,chases:u.obitoRage?config.rageChases:config.chases}:null;
const label=(records,u,index,value=1)=>records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19000500+index,buffTurn:value}});
const passive=(u,records)=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:records});
function visual(u,move,records=[]){return {activeCamp:u.camp,activePos:u.pos,skillEffectId:move.id,activeType:1,targets:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}},...records]};}
function cost(u,ratio,records){if(!ratio||u.hp<=0)return;const amount=Math.min(u.hp-1,Math.round(u.maxHp*ratio));u.hp-=amount;if(amount)records.push(skills.hpRecord(u,amount,false));}
function transform(u,records){
  if(!isObito(u)||u.obitoRage||u.hp<=0||u.hp>=u.maxHp*.5)return false;
  u.obitoRage=true;u.obitoRootsCost=40;
  label(records,u,1);skills.restore(u,u,u.maxHp*config.rageHeal,records);return true;
}
function checkRage(u){const records=[];return transform(u,records)?[visual(u,config.transformation),passive(u,records)]:[];}
function kamui(ctx,u,enhanced,records){
  if(!enhanced)cost(u,config.mystery.hpCost,records);
  u.obitoKamui={chance:enhanced?1:config.kamuiChance,round:ctx.round};label(records,u,2);
  u.obitoFatalRound=ctx.round;u.obitoFatalHits=0;
  u.obitoKamuiRound=ctx.round;
}
function roundStart(ctx){const frames=[];for(const u of ctx.teams.flat()){
  if(!isObito(u)||u.hp<=0)continue;
  u.obitoStandards=0;u.obitoKillCredits=0;u.obitoChaseBoostRound=0;
  frames.push(...checkRage(u));
  if(u.obitoRage&&u.obitoKamuiRound!==ctx.round){const records=[];kamui(ctx,u,true,records);frames.push(visual(u,config.mystery),passive(u,records));}
}return frames;}
function prepareMove(ctx,u,target,move){
  if(!isObito(u)||!move)return move;
  // Costs precede the attack; threshold recovery is emitted before its animation.
  const records=[];if(!move.obitoKamui)cost(u,move.hpCost,records);const changed=transform(u,records);
  const before=[];if(changed)before.push(visual(u,config.transformation));if(records.length)before.push(passive(u,records));
  return {...move,obitoBefore:before,multiplier:move.multiplier*((move.obitoSpear||move.obitoChaos)&&u.obitoChaseBoostRound===ctx.round?1.4:1)};
}
function targets(move,target,opponents){
  const live=opponents.filter(u=>u.hp>0&&!u.auxiliary);
  if(move.target==='low')return live.sort((a,b)=>a.hp-b.hp||a.pos-b.pos).slice(0,1);
  if(move.obitoSpear)return live.filter(u=>(u.pos-1)%5===(target.pos-1)%5);
  return null;
}
function tag(ctx,u,target,records){
  if(target.hp<=0||skills.status(target,'immuneDebuffs'))return;
  target.obitoTagUntil=ctx.round+1;label(records,target,3);
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!isObito(u)||!move)return;
  const records=[];
  if(move.obitoKamui){kamui(ctx,u,u.obitoRage,records);}
  if(move.obitoRoots){u.obitoChaseBoostRound=ctx.round;u.obitoRootsCost=Math.max(0,(u.obitoRootsCost??40)-20);label(records,u,7);label(records,u,10,u.obitoRootsCost);}
  for(const target of hit){
    if(move.obitoChaos){
      if(u.obitoRage){target.suppressedUntil=ctx.round;label(records,target,4);}
      const amount=Math.min(20,ctx.chakra[target.camp]);ctx.chakra[target.camp]-=amount;require('./tsunade-combat').gainChakra(ctx,u,amount);
      label(records,target,5);
      if(amount>0)label(records,u,5);
    }
    if(move.obitoSpear){tag(ctx,u,target,records);if(target.hp>0&&!skills.status(target,'immuneControl')){target.immobileUntil=ctx.round;label(records,target,6);}}
    if(move.obitoStandard&&ctx.random()<config.tagChance)tag(ctx,u,target,records);
  }
  if(move.obitoStandard&&hit.some(t=>t.hp<=0)){u.obitoKillCredits=(u.obitoKillCredits||0)+1;if(u.obitoRage){label(records,u,9);require('./tsunade-combat').receiveExtra(ctx,u);}}
  if(u.obitoRage&&u.hp>0){const damage=frame.targets.filter(r=>r.targetCamp!==u.camp).reduce((sum,r)=>sum+Math.max(0,r.result.hurtHp||0),0);if(damage){const healed=skills.restore(u,u,damage*config.lifeSteal,records);if(healed>0)label(records,u,8,healed);}}
  if(records.length)frame.reactions.push(passive(u,records));
  frame.reactions.push(...checkRage(u));
}
function evade(u,random){const effect=u.obitoKamui;if(!effect||u.hp<=0||u.battleRound>effect.round)return false;delete u.obitoKamui;return random()<effect.chance;}
function fatalLimit(u,isStandardOrChase){
  if(!isStandardOrChase||u.obitoFatalRound!==u.battleRound)return false;
  u.obitoFatalHits=(u.obitoFatalHits||0)+1;return u.obitoFatalHits<=config.fatalProtectionHits;
}
function available(ctx,u){return (u.obitoStandards||0)<2+(u.obitoRage?(u.obitoKillCredits||0):0);}
const chaseKey=move=>move.obitoSpear?'obito:spear':'obito:chaos';
function chaseReady(ctx,u,move){if(!move.cooldown)return true;const key=chaseKey(move);return u.obitoChaseRounds?.[key]===ctx.round||ctx.round>=(ctx.skillReady.get(u)?.get(key)||1);}
function spendChase(ctx,u,move){
  const key=chaseKey(move);u.obitoChaseRounds=u.obitoChaseRounds||{};
  if(u.obitoChaseRounds[key]===ctx.round)return;
  u.obitoChaseRounds[key]=ctx.round;
  if(!ctx.skillReady.has(u))ctx.skillReady.set(u,new Map());
  ctx.skillReady.get(u).set(key,ctx.round+move.cooldown);
}
module.exports={config,isObito,profile,label,passive,visual,roundStart,prepareMove,targets,afterHit,evade,fatalLimit,available,checkRage,chaseReady,spendChase};
