'use strict';
const config=require('./mecha-naruto.json'),skills=require('./hero-skills'),{CMD,ST}=require('./kodek');
const isMecha=u=>u?.id===config.heroId;
const active=(u,f)=>Number.isFinite(u[f])&&u[f]>=Number(u.battleRound||1);
const beast=u=>isMecha(u)&&u.mechaBeast===true;
const advanced=u=>beast(u)&&active(u,'mechaAdvancedUntil');
const profile=u=>isMecha(u)?beast(u)?{...config,mystery:config.beastRecovery,standard:null,chases:[]}:config:null;
const label=(records,u,index,value=1)=>records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19001000+index,buffTurn:value}});
const passive=(u,records)=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:records});
function initialize(ctx){ctx.mechaTriggers=[];for(const u of ctx.teams.flat()){
  for(const k of Object.keys(u))if(k.startsWith('mecha'))delete u[k];
  u.skillBuffs=(u.skillBuffs||[]).filter(b=>!b.mechaIgnition);
  Object.defineProperty(u,'mechaContext',{value:ctx,writable:true,configurable:true,enumerable:false});
}}
function roundStart(ctx){for(const u of ctx.teams.flat()){u.mechaCostReduction=0;u.mechaGrowthThisRound=0;u.mechaJetTriggers=0;u.mechaExtra=0;u.mechaStandards=0;}}
function factor(u,field){return isMecha(u)&&field==='atk'?(1+config.attackGrowth*(u.mechaGrowth||0))*(1+config.beastGrowth*(u.mechaBeastGrowth||0)):1;}
function critical(u){return isMecha(u)?config.criticalGrowth*(u.mechaGrowth||0):0;}
function available(ctx,u){return isMecha(u)&&!beast(u)&&((u.mechaStandards||0)===0||(u.mechaExtra||0)>0);}
function spendStandard(u){if(u.mechaStandards>0)u.mechaExtra--;u.mechaStandards=(u.mechaStandards||0)+1;}
function selectStandard(ctx,u,move){return beast(u)?null:isMecha(u)?prepareMove(ctx,u,null,ctx.chakra[u.camp]>50?config.beam:move):move;}
function targets(ctx,move,selected,opponents){
  const live=opponents.filter(v=>v.hp>0&&!v.auxiliary).sort((a,b)=>a.pos-b.pos);
  if(move.mechaMystery)return [selected,...live.filter(v=>v!==selected)].slice(0,move.target===9?9:live.length);
  if(move.mechaClaw||move.mechaSweep){
    if(!live.length)return [];
    const front=Math.min(...live.map(v=>Math.floor((v.pos-1)/5)));
    const primary=live.filter(v=>Math.floor((v.pos-1)/5)===front);
    const chosen=primary[Math.min(primary.length-1,Math.floor(ctx.random()*primary.length))];
    const victims=[chosen,...primary.filter(v=>v!==chosen)];
    if(move.mechaSweep){
      const adjacent=(a,b)=>Math.abs(Math.floor((a.pos-1)/5)-Math.floor((b.pos-1)/5))+Math.abs((a.pos-1)%5-(b.pos-1)%5)===1;
      victims.push(...live.filter(v=>!primary.includes(v)&&primary.some(p=>adjacent(p,v))));
      move.mechaSplashWeights=new Map(victims.map(v=>[v,(primary.includes(v)?1:0)+.25*primary.filter(p=>p!==v&&adjacent(p,v)).length]));
    }
    return victims;
  }
  if(move.mechaBeastBomb){const primary=live.slice(0,12);if(!primary.length)return [];const chosen=primary[Math.min(primary.length-1,Math.floor(ctx.random()*primary.length))];return [chosen,...primary.filter(v=>v!==chosen)];}
  if(move.target==='mechaLowest')return live.sort((a,b)=>a.hp-b.hp||a.pos-b.pos).slice(0,1);
  if(move.target==='mechaLine'){
    const rows=[...new Set(live.map(v=>Math.floor((v.pos-1)/5)))];if(!rows.length)return [];
    const row=rows[Math.min(rows.length-1,Math.floor(ctx.random()*rows.length))];return live.filter(v=>Math.floor((v.pos-1)/5)===row);
  }
  return null;
}
function prepareMove(ctx,u,target,move){
  if(!isMecha(u)||!move)return move;
  if(move.mechaChase)return active(target,'suppressedUntil')?config.modifiedChase:move;
  if((move.mechaBeam||move.mechaCombo)&&move.stateChance!=null){const m={...move};const repulse=move.mechaExtreme||ctx.random()<move.stateChance;m.causes=repulse?'repulse':null;delete m.stateChance;if(move.mechaCombo&&!repulse)m.combo=1;return m;}
  return move;
}
function evade(ctx,u,move,random){
  if(!isMecha(u)||beast(u)||u.hp<=0)return false;
  const chase=move?.activeType===require('./kodek').ACTIVE.NORMAL_EX;
  if(!chase&&u.mechaEvasionRound===ctx.round)return false;
  if(random()>=(chase?config.chaseEvasionChance:config.ordinaryEvasionChance))return false;
  if(!chase)u.mechaEvasionRound=ctx.round;
  if((u.mechaJetTriggers||0)<config.maxJetTriggers){
    u.mechaJetTriggers=(u.mechaJetTriggers||0)+1;
    ctx.mechaTriggers.push(u);
  }
  return true;
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!isMecha(u)||!move)return;
  const records=[];
  if(beast(u)){
    if(move.mechaRecovery){
      skills.restore(u,u,u.maxHp*move.healRatio,records);
      u.mechaAdvancedUntil=ctx.round;u.mechaExplosive=true;u.mechaPendingBomb=true;
      label(records,u,11,12);
    }
    if(move.mechaClaw)for(const t of hit){require('./pain-combat').interrupt(ctx,t,records);if(!skills.status(t,'immuneDebuffs')){t.mechaMysteryLockUntil=ctx.round;t.mysteryReadyRound=ctx.round+1;label(records,t,12);}}
    if(move.mechaBeastTrigger){u.mechaBeastGrowth=(u.mechaBeastGrowth||0)+1;label(records,u,13,u.mechaBeastGrowth*20);}
    if(records.length)frame.reactions.push(passive(u,records));
    return;
  }
  if(move.mechaMystery&&hit.includes(selected)){
    require('./pain-combat').interrupt(ctx,selected,records);
    if(!skills.status(selected,'immuneDebuffs')){selected.mechaMysteryLockUntil=ctx.round;selected.mysteryReadyRound=ctx.round+1;label(records,selected,12);}
    label(records,u,1);
  }
  if(move.mechaCombo)for(const t of hit){t.armorSuppressedUntil=ctx.round;label(records,t,2);}
  if(move.mechaBeam){
    u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||1)-1);
    u.mechaCostRound=ctx.round;u.mechaCostReduction=(u.mechaCostReduction||0)+20;
    if(move.causes==='repulse'&&frame.comboTarget&&hit.includes(frame.comboTarget))for(const t of [frame.comboTarget]){t.mysteryReadyRound=Math.max(ctx.round,t.mysteryReadyRound||1)+1;label(records,t,3);}
    label(records,u,4,u.mechaCostReduction);
  }
  if(move.mechaChase&&hit.includes(selected)){
    if(move.mechaModified){require('./naruto-combat').setState(selected,'immobile',ctx.round);label(records,selected,5);}
    else if(!require('./hashirama-combat').burst(selected)){selected.suppressedUntil=ctx.round;label(records,selected,6);}
    // Share the existing lost-standard budget with Sword Crusher.
    const entitlement=isMecha(selected)?Math.max(0,(selected.mechaStandards?0:1)+(selected.mechaExtra||0)):require('./hashirama-combat').isHash(selected)?Math.min(5-(selected.hashStandards||0),(selected.hashStandards?0:1)+(selected.hashExtra||0)):require('./obito-combat').isObito(selected)?Math.max(0,2+(selected.obitoRage?(selected.obitoKillCredits||0):0)-(selected.obitoStandards||0)):ctx.primaryActions.get(selected)===ctx.round?0:1;
    const remaining=Math.max(0,entitlement-(selected.hashStandardLossRound===ctx.round?(selected.hashStandardLoss||0):0));
    selected.hashStandardLoss=(selected.hashStandardLossRound===ctx.round?(selected.hashStandardLoss||0):0)+remaining;selected.hashStandardLossRound=ctx.round;
    u.mechaExtra=(u.mechaExtra||0)+remaining;label(records,u,7,remaining);
  }
  if(u.hp>0&&(u.mechaGrowthThisRound||0)<config.maxGrowthTriggers){u.mechaGrowthThisRound=(u.mechaGrowthThisRound||0)+1;u.mechaGrowth=(u.mechaGrowth||0)+1;label(records,u,8,u.mechaGrowth);}
  if(records.length)frame.reactions.push(passive(u,records));
  if(move.mechaMystery&&u.hp>0){
    u.mechaBeast=true;u.mechaExtra=0;u.mechaStandards=1;
    u.mysteryReadyRound=Math.max(u.mysteryReadyRound||0,ctx.round+config.beastRecovery.cooldown);
    const notices=[];label(notices,u,10);frame.reactions.push(passive(u,notices),require('./pain-combat').visual(u,config.transform));
  }
}
function triggers(ctx){const out=ctx.mechaTriggers.splice(0);return out.filter(u=>u.hp>0&&!beast(u)).map(u=>{ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]||100,ctx.chakra[u.camp]+20);return {unit:u,move:config.extremeBeam};});}
function roundRequests(ctx){return ctx.teams.flat().filter(u=>beast(u)&&u.hp>0&&u.mechaTriggerRound!==ctx.round).map(u=>{u.mechaTriggerRound=ctx.round;return {unit:u,move:ctx.round%2===0?config.beastClaw:config.beastSweep};});}
function additional(u,move){if(beast(u)&&u.hp>0&&move?.mechaRecovery&&u.mechaPendingBomb){delete u.mechaPendingBomb;return config.beastBomb;}return null;}
function onAttacked(ctx,u){if(beast(u)&&u.hp>0)u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);}
function ignitionDamage(source,target){const clamp=v=>Math.max(0,Math.min(1,v)),atk=skills.value(source,'atk'),def=skills.value(target,'def')*(1-clamp(skills.value(source,'ignoreDefense')));return Math.max(0,Math.round(atk*config.ignition.multiplier*atk/Math.max(1,atk+def)*Math.max(0,1+skills.value(source,'damageBonus'))*(1-clamp(skills.value(target,'damageReduction')))*Math.max(0,1+skills.value(target,'vulnerability'))));}
function onDamage(ctx,actor,target,result,move,records){
  if(!beast(target)||target.hp<=0||result.damage<=0||actor===target)return;
  const highImmunity=require('./hashirama-combat').burst(actor)||advanced(actor);
  if(active(target,'mechaAdvancedUntil')&&move?.damageType!=='ninjutsu'&&!highImmunity){
    actor.skillBuffs=actor.skillBuffs||[];
    const entry={kind:'dot',field:'ignite',buffId:13500022,mechaIgnition:true,element:'fire',level:2,source:target.id,sourceCamp:target.camp,sourceSkill:config.beastRecovery.id,amount:ignitionDamage(target,actor),attackStat:'atk',damageType:'physical',remaining:2};
    const old=actor.skillBuffs.find(v=>v.mechaIgnition&&v.source===target.id);if(old)Object.assign(old,entry);else actor.skillBuffs.push(entry);
    records.push({cmd:CMD.ATTRBUFF,targetCamp:actor.camp,targetPos:actor.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:13500022,buffTurn:1}});label(records,actor,14);
  }
  if(target.mechaExplosive&&!skills.status(actor,'immuneDebuffs')){actor.mechaInflammation=Math.min(config.inflammationMaxStacks,(actor.mechaInflammation||0)+1);label(records,actor,15,actor.mechaInflammation);}
}
function beforeAttack(u,move,records){if(u.hp>0&&u.mechaInflammation&&(!move?u.profession!==3:move.damageType==='physical')){const loss=Math.min(u.hp,Math.round(u.maxHp*config.inflammationHpRatio*u.mechaInflammation));u.hp-=loss;records.push(skills.hpRecord(u,loss,false));}}
module.exports={label,config,isMecha,beast,advanced,active,profile,initialize,roundStart,factor,critical,available,spendStandard,selectStandard,targets,prepareMove,evade,afterHit,triggers,roundRequests,additional,onAttacked,onDamage,beforeAttack,ignitionDamage};
