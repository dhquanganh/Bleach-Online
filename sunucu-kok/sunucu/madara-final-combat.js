'use strict';
const config=require('./madara-final.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isMadara=u=>u?.id===config.heroId,isClone=u=>u?.id===config.summonId;
const active=(u,key)=>u&&u[key]>=u.battleRound;
function profile(u){if(isClone(u))return {standard:null,chases:[]};if(!isMadara(u))return null;
  return {...config,mystery:active(u,'madaraBurstUntil')?config.burstMystery:config.mystery,standard:active(u,'madaraBurstUntil')?config.burstStandard:config.standard,chases:[active(u,'madaraBurstUntil')?config.burstChase:config.chase]};}
function prepareSummons(teams){for(const team of teams)for(const owner of [...team].filter(isMadara)){
  if(team.some(v=>v.madaraOwner===owner))continue;
  const pos=Array.from({length:15},(_,i)=>i+1).find(p=>!team.some(v=>v.pos===p));if(!pos)continue;
  team.push({id:config.summonId,isim:'Madara Shadow Clone',pos,camp:owner.camp,hp:0,maxHp:Math.round(owner.maxHp*.6),atk:owner.atk,magicAtk:owner.atk,def:owner.def,resistance:owner.resistance,speed:owner.speed,level:owner.level,quality:7,profession:1,normal:config.cloneCounter.id,skillId:config.cloneCounter.id,skill:0,anger:0,hitRate:1,auxiliary:true,madaraOwner:owner,partnerSkills:[],weaponSkills:[]});
}}
function initialize(ctx){ctx.madaraQueue=[];for(const u of ctx.teams.flat()){
  Object.defineProperty(u,'madaraContext',{value:ctx,writable:true,configurable:true,enumerable:false});
  if(isMadara(u)||isClone(u))u.superArmor=true;
  if(isMadara(u)){u.madaraTechnique=0;u.madaraAttackStacks=0;u.madaraChaseStacks=0;u.madaraEntryRound=1;u.painInterruptImmuneUntil=1;}
}}
function battleStart(ctx){const out=[];for(const u of ctx.teams.flat().filter(isMadara)){
  const clone=ctx.teams[u.camp].find(v=>v.madaraOwner===u);if(!clone)continue;
  clone.hp=clone.maxHp;out.push({...pain.visual(u,config.summon),targets:[skills.hpRecord(clone,-clone.hp,false)]});
}return out;}
function factor(u,field){
  if(isMadara(u)&&field==='atk')return (1+.1*(u.madaraAttackStacks||0))*(1+.15*(u.madaraEvadeStacks||0));
  if(field==='resistance')return (isMadara(u)?1+.2*(u.madaraTechnique||0):1)*Math.max(.1,1-.1*(u.madaraResistanceStacks||0)-.03*(active(u,'madaraInfernoUntil')?u.madaraInfernoStacks||0:0));
  if(field==='critRate'&&active(u,'madaraMentalUntil'))return Math.max(0,1-.15*(u.madaraMentalStacks||0));
  return 1;
}
function critical(u){return isMadara(u)&&active(u,'madaraCritUntil')?.5:0;}
function pureImmune(u,move){return (isMadara(u)||isClone(u))&&!!move?.pureTaijutsu;}
function fatalProtected(ctx,u,damage){return isMadara(u)&&u.madaraEntryRound===ctx.round&&u.madaraFatalRound!==ctx.round&&damage>=u.hp;}
function beforeDamage(ctx,u,damage){if(!fatalProtected(ctx,u,damage))return damage;u.madaraFatalRound=ctx.round;u.madaraRecoverFatal=true;return Math.max(0,u.hp-1);}
function queue(ctx,u,move,target){if(u.hp>0)ctx.madaraQueue.push({unit:u,move,target});}
function onDamage(ctx,attacker,u,result,move,critical,records){
  if(isMadara(attacker)&&critical&&active(attacker,'madaraBurstUntil'))attacker.madaraAttackStacks=(attacker.madaraAttackStacks||0)+1;
  if(!(result.damage>0))return;
  if(attacker&&attacker.madaraInfernoUntil>=ctx.round)attacker.madaraInfernoStacks=(attacker.madaraInfernoStacks||0)+1;
  if(isMadara(u)){
    if(u.madaraFirstDamageRound!==ctx.round){u.madaraFirstDamageRound=ctx.round;u.madaraCritUntil=ctx.round;if(active(u,'madaraBurstUntil'))u.madaraFreeUntil=ctx.round;}
    if(!active(u,'madaraBurstUntil')){u.madaraTechnique=Math.min(2,(u.madaraTechnique||0)+.5);if(u.madaraTechnique>=2){u.madaraTechnique=0;u.madaraBurstUntil=ctx.round;u.madaraChaseStacks++;queue(ctx,u,config.burst);}}
    if(u.madaraRecoverFatal){delete u.madaraRecoverFatal;skills.restore(u,u,Math.max(0,Math.round(u.maxHp*.3)-u.hp),records);}
  }
  if(isClone(u)&&u.hp>0&&(move?.trigger||move?.chase)&&u.madaraCounterRound!==ctx.round){u.madaraCounterRound=ctx.round;queue(ctx,u,config.cloneCounter);}
}
function evade(ctx,u,move){if(!isMadara(u)||!active(u,'madaraBurstUntil')||u.madaraEvadedRound===ctx.round||ctx.random()>=.6)return false;
  u.madaraEvadedRound=ctx.round;u.madaraEvadeStacks=(u.madaraEvadeStacks||0)+1;queue(ctx,u,config.reflection);return true;}
function targets(ctx,u,move,selected,enemies){if(!move?.madaraMove)return null;const living=enemies.filter(v=>v.hp>0);
  if(move.madaraMove==='cloneCounter')return living.sort((a,b)=>a.hp-b.hp||a.pos-b.pos).slice(0,active(u.madaraOwner,'madaraBurstUntil')?2:1);
  if(move.madaraMove==='reflection')return [selected||living[0]].filter(Boolean);
  if(move.madaraMove==='standard')return living.filter(v=>(v.pos-1)%5===(selected.pos-1)%5);
  return living;
}
function prepareMove(ctx,u,move){
  if(move&&u.madaraEngulfUntil>=ctx.round){const tags=require('./statlar').heroById.get(u.id)?.tags||[];if(tags.includes(14)&&(move.prompt||move.chase&&u.madaraMentalUntil>=ctx.round))move={...move,unavoidable:false};}
  if(!move?.madaraMove)return move;
  const key=move.madaraMove;let multiplier=move.multiplier;
  if(key==='chase'||key==='burstChase')multiplier*=1+.1*(u.madaraChaseStacks||0);
  // Requested adaptation: counterattacks and clone splash also scale with ATK.
  return {...move,multiplier,critBonus:key==='burstChase'?.2:0};
}
function debuff(ctx,v,key,until){if(require('./asura-guardian-combat').blocksKey(v,key))return;if(v.hp>0&&!skills.status(v,'immuneDebuffs'))v[key]=until;}
function afterHit(ctx,u,selected,hit,move,frame){if(!move?.madaraMove)return;
  const key=move.madaraMove;
  if(key==='mystery'){debuff(ctx,selected,'madaraCombustionUntil',ctx.round+1);debuff(ctx,selected,'madaraEngulfUntil',ctx.round);selected.madaraCombustionSource=u;pain.interrupt(ctx,selected,frame.targets);queue(ctx,u,config.complete);}
  if(key==='burstMystery'){selected.suppressedUntil=ctx.round+1;selected.immobileUntil=ctx.round+1;}
  if(key==='standard')u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);
  if(key==='burstStandard')for(const v of hit){v.madaraResistanceStacks=(v.madaraResistanceStacks||0)+1;debuff(ctx,v,'madaraShatterUntil',ctx.round);}
  if(key==='complete')for(const v of hit){v.armorSuppressedUntil=ctx.round+1;debuff(ctx,v,'madaraShatterUntil',ctx.round);}
  if(key==='chase'||key==='burstChase')for(const v of hit){if(!(v.madaraInfernoUntil>=ctx.round))v.madaraInfernoStacks=0;debuff(ctx,v,'madaraInfernoUntil',ctx.round+1);v.madaraInfernoSource=u;if(key==='chase'){v.hashStandardLossRound=ctx.round;v.hashStandardLoss=(v.hashStandardLoss||0)+1;}}
  if(key==='reflection'){const records=[];skills.restore(u,u,u.maxHp*config.reflection.healRatio,records);if(records.length)frame.reactions.push(pain.passive(u,records));}
  if(key==='cloneCounter'){for(const v of hit){if(!(v.madaraMentalUntil>=ctx.round))v.madaraMentalStacks=0;debuff(ctx,v,'madaraMentalUntil',ctx.round);v.madaraMentalStacks=Math.min(4,(v.madaraMentalStacks||0)+1);v.perseverance=0;v.skillBuffs=(v.skillBuffs||[]).filter(b=>b.field!=='perseverance');}if(hit.some(v=>v.hp<=0))queue(ctx,u,config.cloneSplash);}
  if(move.trigger&&u.madaraCombustionUntil>=ctx.round&&!require('./asura-guardian-combat').immuneStatus(u,'ignition')){u.madaraIgnitionUntil=ctx.round;u.madaraIgnitionSource=u.madaraCombustionSource;}
  if(move.prompt&&u.madaraCombustionUntil>=ctx.round)for(const ally of ctx.teams[u.camp]){if(require('./asura-guardian-combat').immuneStatus(ally,'ignition'))continue;ally.madaraIgnitionUntil=ctx.round;ally.madaraIgnitionSource=u.madaraCombustionSource;}
}
function triggers(ctx){return ctx.madaraQueue.splice(0).filter(r=>r.unit.hp>0);}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat()){
  if(u.hp<=0)continue;
  if(isMadara(u)&&active(u,'madaraBurstUntil')){u.madaraBurstUntil=0;u.madaraChaseStacks++;out.push(pain.visual(u,config.burst));}
  for(const [field,ratio] of [['madaraInfernoUntil',.4],['madaraIgnitionUntil',.3]])if(u[field]>=ctx.round){
    const source=field==='madaraInfernoUntil'?u.madaraInfernoSource:u.madaraIgnitionSource;
    const attack=source?skills.value(source,'atk'):0,defense=skills.value(u,'def');
    let amount=Math.min(u.hp,Math.max(1,Math.round(attack*ratio*attack/Math.max(1,attack+defense))));
    const redirected=[];amount=require('./guy-gate-combat').indirect(ctx,source,u,amount,redirected);u.hp-=amount;out.push(pain.passive(u,[...redirected,skills.hpRecord(u,amount)]));
  }
}return out;}
module.exports={config,isMadara,isClone,active,profile,prepareSummons,initialize,battleStart,factor,critical,pureImmune,beforeDamage,fatalProtected,onDamage,evade,targets,prepareMove,afterHit,triggers,endRound};
