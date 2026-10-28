'use strict';
const config=require('./pain-tendo.json'),skills=require('./hero-skills'),{CMD,ST}=require('./kodek');
const isPain=u=>u?.id===config.heroId;
const isRinnegan=u=>isPain(u)||u.rinnegan===true||u.id===11120920;
const active=(u,field)=>Number.isFinite(u[field])&&u[field]>=Number(u.battleRound||1);
const label=(records,u,index,value=1)=>records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19000800+index,buffTurn:value}});
const passive=(u,records)=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:records});
const visual=(u,move)=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:move.id,activeType:1,targets:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}}]});
function points(u,amount,records=[]){if(!isPain(u))return;u.painTechnique=Math.max(0,Math.min(5,(u.painTechnique||0)+amount));label(records,u,1,Math.round(u.painTechnique*10));}
function profile(u){
  if(!isPain(u))return null;
  return u.painFinal?{...config,standard:null,chases:[],mystery:config.finalMystery}:{...config,mystery:u.hp<u.maxHp*.6?config.extremeMystery:config.mystery};
}
function initialize(ctx){for(const u of ctx.teams.flat()){Object.defineProperty(u,'painContext',{value:ctx,writable:true,configurable:true,enumerable:false});if(isPain(u)){delete u.painLaserRound;u.rinnegan=true;u.painTechnique=0;u.painMysteries=0;}}}
function factor(u,field){
  let result=1;
  if(isPain(u)){
    if(['atk','magicAtk'].includes(field))result*=1+(u.painTechnique||0)*(u.painFinal ? .20 : .12);
    if(field==='atk'&&!u.painFinal)result*=1+.12*(u.painDamageStacks||0);
    if(field==='speed'&&!u.painFinal)result*=1+.02*(u.painInitiativeStacks||0);
  }
  if(['atk','magicAtk'].includes(field)&&active(u,'painDisruptionUntil')){
    const count=u.painContext ? u.painContext.teams[1-u.camp].filter(v=>v.hp>0&&!v.auxiliary&&isRinnegan(v)).length : u.painDisruptionCount||0;
    result*=Math.max(0,1-.1*count);
  }
  return result;
}
function rejectBuff(caster,target,rule,records){
  const negative=rule.value<0||rule.kind==='dot'||rule.negative===true||rule.debuff===true||['stun','freeze','fossilize','void','chaos','silence','disarm','paralysis','noHeal','noFury','vulnerability'].includes(rule.field);
  if(!negative)return caster!==target&&active(target,'painHorrorUntil');
  if(isPain(target)&&target.painFinal&&skills.status(target,'immuneDebuffs'))return true;
  if(!isPain(target)||target.painFinal||rule.level===2)return false;
  target.painInitiativeStacks=Math.min(5,(target.painInitiativeStacks||0)+1);label(records,target,7,target.painInitiativeStacks*2);return true;
}
function debuff(ctx,u,target,field,records,duration=1){
  if(target.hp<=0||skills.status(target,'immuneDebuffs'))return false;
  target[field]=ctx.round+duration;label(records,target,field==='painHorrorUntil'?2:field==='painDisruptionUntil'?3:4);
  if(field==='painDisruptionUntil')target.painDisruptionCount=ctx.teams[u.camp].filter(v=>v.hp>0&&isRinnegan(v)).length;
  return true;
}
function increaseCost(ctx,target,records){
  if(target.hp<=0||skills.status(target,'immuneDebuffs'))return;
  if(target.painCostRound!==ctx.round)target.painCost=0;
  target.painCostRound=ctx.round;target.painCost=(target.painCost||0)+20;label(records,target,5,target.painCost);
}
function interrupt(ctx,target,records){
  if(target.hp<=0||active(target,'painInterruptImmuneUntil')||skills.status(target,'immuneDebuffs')&&!require('./guy-gate-combat').isGuy(target))return;
  // The non-Level-2 cancellation passive also cancels Interruption.
  if(rejectBuff(null,target,{field:'silence',value:1},records))return;
  target.painInterruptedUntil=ctx.round;label(records,target,6);require('./guy-gate-combat').interrupted(ctx,target);
}
function canMystery(ctx,u,move){return !active(u,'mechaMysteryLockUntil')&&(!isPain(u)||((u.painMysteries||0)<(u.painFinal?2:1)&&(move.consumeAllTechnique||(u.painTechnique||0)>=(move.techniqueCost||0))))&&(!active(u,'painInterruptedUntil')||active(u,'painInterruptImmuneUntil'));}
function mysteryReady(ctx,u){return ctx.round>=(u.mysteryReadyRound||1)||(isPain(u)&&u.painFinal&&u.painMysteryWindow===ctx.round&&(u.painMysteries||0)<2);}
function mysteryCost(ctx,u,move){if(u.madaraFreeUntil>=ctx.round)return 0;if(require('./nagato-combat').isNagato(u)&&u.nagatoLeadRound===ctx.round)return 0;return Math.max(0,(Number(move.chakraCost)||0)-(u.tobiCostRound===ctx.round?u.tobiCostReduction||0:0)+(u.painCostRound===ctx.round?(u.painCost||0):0)-(u.mechaContext?u.mechaContext.teams[u.camp].filter(v=>v.mechaCostRound===ctx.round).reduce((s,v)=>s+(v.mechaCostReduction||0),0):0));}
function spendMystery(ctx,u,move){
  // Executing a Mystery clears Fear/Horror even if the resulting attack misses.
  if(active(u,'painHorrorUntil')){delete u.painHorrorUntil;}
  if(!isPain(u))return;
  u.painMysteries=(u.painMysteries||0)+1;
  u.painMysteryWindow=ctx.round;
  points(u,move.consumeAllTechnique?-(u.painTechnique||0):-(move.techniqueCost||0));
}
function targetList(move,target,opponents){
  const live=opponents.filter(u=>u.hp>0&&!u.auxiliary);
  if(move.painLaser)return live;
  if(move.painChase)return [target,...live.filter(u=>u!==target&&Math.abs(Math.floor((u.pos-1)/5)-Math.floor((target.pos-1)/5))+Math.abs((u.pos-1)%5-(target.pos-1)%5)===1)];
  return null;
}
function beforeStandard(u){
  const records=[];
  if(active(u,'painAfflictionUntil')&&u.hp>0){const amount=Math.round(u.hp*.1);u.hp-=amount;if(amount)records.push(skills.hpRecord(u,amount,false));}
  return records;
}
function onHit(ctx,u,target,result,critical,records){
  if(isPain(target)&&result.before>0&&!result.painTechniqueCredited){points(target,target.painFinal?1:.5,records);}
  if(!isPain(u))return;
  if(!u.painFinal&&(result.damage>0||result.absorbed>0)){u.painDamageStacks=(u.painDamageStacks||0)+1;label(records,u,8,u.painDamageStacks*12);}
  if(critical){if(u.painFinal)increaseCost(ctx,target,records);else debuff(ctx,u,target,'painDisruptionUntil',records);}
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!isPain(u)||!move)return;
  const records=[];
  if(move.painStandard){points(u,1,records);u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||1)-1);}
  if(move.painMystery||move.painSuper){
    label(records,u,1,Math.round((u.painTechnique||0)*10));
    for(const target of hit){interrupt(ctx,target,records);if(move.painSuper)increaseCost(ctx,target,records);}
    if(hit.includes(selected)&&!move.painSuper){debuff(ctx,u,selected,'painHorrorUntil',records);increaseCost(ctx,selected,records);}
    if(move.lifeSteal){const damage=frame.targets.filter(r=>r.cmd===CMD.ATTACK&&r.targetCamp!==u.camp).reduce((n,r)=>n+Math.max(0,r.result.hurtHp||0),0);const healed=skills.restore(u,u,damage*move.lifeSteal,records);if(healed)label(records,u,9,healed);}
  }
  if(move.painChase&&hit.includes(selected)){
    debuff(ctx,u,selected,'painDisruptionUntil',records);debuff(ctx,u,selected,'painAfflictionUntil',records);
    if(debuff(ctx,u,selected,'painChakraLimitUntil',records,0)){ctx.chakraLimit=ctx.chakraLimit||[100,100];ctx.chakraLimit[selected.camp]=20;ctx.chakra[selected.camp]=Math.min(20,ctx.chakra[selected.camp]);label(records,selected,10,20);}
  }
  if(move.painLaser){
    u.painLaserRound=ctx.round;
    for(const target of hit){const amount=Math.min(10,ctx.chakra[target.camp]);ctx.chakra[target.camp]-=amount;if(amount)label(records,target,11,amount);}
    points(u,1,records);u.painInterruptImmuneUntil=ctx.round;label(records,u,12);
    for(const ally of ctx.teams[u.camp].filter(v=>v.hp>0&&isRinnegan(v)))ally.painUnavoidableUntil=ctx.round;
  }
  if(records.length)frame.reactions.push(passive(u,records));
}
function roundStart(ctx){
  const requests=[];
  for(const u of ctx.teams.flat()){
    if(isPain(u)){u.painMysteries=0;if(u.hp>0&&!u.painFinal&&u.painLaserRound!==ctx.round)requests.push({unit:u,move:config.laser});}
  }
  return requests.sort((a,b)=>skills.value(b.unit,'speed')-skills.value(a.unit,'speed')||a.unit.camp-b.unit.camp||a.unit.pos-b.unit.pos);
}
function revivals(ctx){
  const out=[];
  for(const u of ctx.teams.flat()){
    if(require('./naruto-final-combat').blocksDeath(u)||!isPain(u)||u.hp>0||u.noRevive||u.itachiUnrevivable)continue;
    const records=[];
    if(!u.painFinal){
      u.painFinal=true;u.hp=u.maxHp;u.painDamageStacks=0;u.painInitiativeStacks=0;
      u.skillBuffs=(u.skillBuffs||[]).filter(b=>b.level!==2&&b.value>=0&&!['stun','freeze','silence','disarm','chaos','noHeal','noFury'].includes(b.field));
      for(const field of ['painHorrorUntil','painDisruptionUntil','painAfflictionUntil','painCost','painCostRound','painChakraLimitUntil','painInterruptedUntil','immobileUntil','suppressedUntil','extremeChaosUntil'])delete u[field];
      // Transformation retains the active Mystery recovery and action budget.
      delete u.painMysteryWindow;
      records.push(skills.hpRecord(u,-u.hp,false));label(records,u,13,100);
      out.push({unit:u,animation:config.transformation,records});
    }else if(!u.painFinalDeathChecked){
      u.painFinalDeathChecked=true;
      if(!u.painFinalRevived&&ctx.teams[u.camp].some(v=>v!==u&&v.hp<=0&&!v.auxiliary&&!v.cloneOwner)){
        u.painFinalRevived=true;u.hp=Math.max(1,Math.round(u.maxHp*.4));records.push(skills.hpRecord(u,-u.hp,false));label(records,u,14,40);
        out.push({unit:u,animation:config.finalRevival,records,move:config.superPush});
      }
    }
  }
  return out;
}
function prepareMove(ctx,u,move){return move&&active(u,'painUnavoidableUntil')&&(move.prompt||move.painMystery)?{...move,unavoidable:true}:move;}
module.exports={interrupt,config,isPain,isRinnegan,active,label,passive,visual,points,profile,initialize,factor,rejectBuff,canMystery,mysteryReady,mysteryCost,spendMystery,targetList,beforeStandard,onHit,afterHit,roundStart,revivals,prepareMove};
