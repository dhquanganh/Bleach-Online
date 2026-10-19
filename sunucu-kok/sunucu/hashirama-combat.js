'use strict';
const config=require('./hashirama-final.json'),skills=require('./hero-skills'),{CMD,ST}=require('./kodek');
const isHash=u=>u?.id===config.heroId;
const active=(u,f)=>Number.isFinite(u[f])&&u[f]>=Number(u.battleRound||1);
const burst=u=>isHash(u)&&active(u,'hashBurstUntil');
const high=u=>u.hp>=u.maxHp*.6;
const label=(records,u,index,value=1)=>records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19000900+index,buffTurn:value}});
const passive=(u,targets)=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets});
const visual=(u,move,records=[])=>({activeCamp:u.camp,activePos:u.pos,skillEffectId:move.id,activeType:1,targets:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}},...records]});
function profile(u){if(!isHash(u))return null;return {...config,mystery:burst(u)?config.burstMystery:config.mystery,standard:high(u)?config.sword:config.standard,chases:[high(u)?(burst(u)?config.burstSevere:config.severe):config.chases[0]]};}
function initialize(ctx){
  for(const u of ctx.teams.flat()){
    // These fields belong to one battle, including growth/debuffs on other heroes.
    for(const key of Object.keys(u))if(key.startsWith('hash'))delete u[key];
    Object.defineProperty(u,'hashContext',{value:ctx,writable:true,configurable:true,enumerable:false});
    if(isHash(u)){u.senjutsu=true;u.hashTechnique=0;u.hashStandards=0;}
  }
}
function forest(ctx,u){
  ctx.hashForest={owner:u.camp,source:u,until:Math.max(1,ctx.round)+1};
  u.hashExplosiveUntil=Math.max(1,ctx.round)+1;
  const records=[];label(records,u,3,2);return visual(u,config.forest,records);
}
function roundStart(ctx){const out=[];for(const u of ctx.teams.flat())if(isHash(u)&&u.hp>0){u.hashStandards=0;u.hashExtra=0;u.hashMysteries=0;if(!u.hashStarted){u.hashStarted=true;out.push(forest(ctx,u));}}return out;}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat())if(isHash(u)&&u.hp>0&&burst(u)){
  delete u.hashBurstUntil;u.hashMysteryStacks=(u.hashMysteryStacks||0)+1;
  const records=[];label(records,u,4,u.hashMysteryStacks*10);out.push(passive(u,records),forest(ctx,u));
}return out;}
function factor(u,field){
  let v=1;
  if(isHash(u)){
    if(field==='def')v*=1+.2*(u.hashTechnique||0);
    if(active(u,'hashExcitedUntil')){if(['atk','magicAtk'].includes(field))v*=1.6;if(['def','resistance'].includes(field))v*=.7;}
  }
  if(field==='atk')v*=1+.03*(u.hashAttackStacks||0);
  if(field==='magicAtk')v*=1+.03*(u.hashNinjutsuStacks||0);
  return v;
}
function canStandard(u){return !active(u,'hashRootUntil');}
// Burst expires at round end: spending Deity Gates must not discard an earned
// Burst cast. Keep shared cooldown, but reserve one separate cast for each form.
function canMystery(ctx,u){return !active(u,'hashSealUntil')&&(!isHash(u)||((u.hashMysteries||0)<2&&u[burst(u)?'hashBurstMysteryRound':'hashBaseMysteryRound']!==ctx.round));}
function available(ctx,u){return isHash(u)&&u.hashStandards<config.maxStandards&&(u.hashStandards===0||u.hashExtra>0);}
function spendStandard(u){if(u.hashStandards>0)u.hashExtra--;u.hashStandards++;}
function spendMystery(ctx,u){if(isHash(u)){u.hashMysteries=(u.hashMysteries||0)+1;u[burst(u)?'hashBurstMysteryRound':'hashBaseMysteryRound']=ctx.round;}}

function debuff(ctx,u,target,field,records,until=ctx.round,force=false){
  if(target.hp<=0||!force&&skills.status(target,'immuneDebuffs'))return false;
  target[field]=Math.max(target[field]||0,until);label(records,target,field==='hashSealUntil'?5:field==='hashWeakUntil'?6:field==='hashEnfeebleUntil'?7:field==='hashRootUntil'?8:9);return true;
}
function onDamage(ctx,actor,target,result,move,records,events){
  if(result.damage<=0)return;
  if(target.hp<=0)delete target.hashEvasionUntil;
  // A living Burst Hashirama grants growth to the unit that dealt the damage.
  if(actor!==target&&ctx.teams[actor.camp].some(u=>u.hp>0&&burst(u))){
    if((move?move.damageType!=='ninjutsu':actor.profession!==3))actor.hashAttackStacks=(actor.hashAttackStacks||0)+1;
    if(move?.damageType==='mixed'||move?.damageType==='ninjutsu'||!move&&actor.profession===3)actor.hashNinjutsuStacks=(actor.hashNinjutsuStacks||0)+1;
    label(records,actor,10,3);
  }
  if(!isHash(target)||target.hp<=0)return;
  if(target.hashFirstDamageRound!==ctx.round){target.hashFirstDamageRound=ctx.round;target.hashExcitedUntil=ctx.round;label(records,target,2);}
  const wasBurst=burst(target);
  target.hashTechnique=Math.min(2,(target.hashTechnique||0)+.5);label(records,target,1,Math.round(target.hashTechnique*10));
  if(!wasBurst){const healed=skills.restore(target,target,target.maxHp*config.senjutsuHealRatio,records);if(healed)label(records,target,11,healed);target.mysteryReadyRound=Math.max(ctx.round,(target.mysteryReadyRound||1)-1);}
  if(target.hashTechnique>=2){target.hashTechnique=0;ctx.chakra[target.camp]=Math.min(ctx.chakraLimit?.[target.camp]||100,ctx.chakra[target.camp]+40);if(!wasBurst){target.hashBurstUntil=ctx.round;target.hashMysteryStacks=(target.hashMysteryStacks||0)+1;label(records,target,4,target.hashMysteryStacks*10);events.push(visual(target,config.burst));}label(records,target,1,0);label(records,target,12,40);}
}
function targets(ctx,move,target,opponents){
  const live=opponents.filter(v=>v.hp>0&&!v.auxiliary).sort((a,b)=>a.pos-b.pos);
  if(move.hashSword){if(!live.length)return [];const rows=[...new Set(live.map(v=>Math.floor((v.pos-1)/5)))];const row=rows[Math.min(rows.length-1,Math.floor(ctx.random()*rows.length))];return live.filter(v=>Math.floor((v.pos-1)/5)===row);}
  if(move.id===config.standard.id)return live.slice(0,1);
  if(move.hashGolem){const primary=[target,...live.filter(v=>v!==target)].filter(v=>v.hp>0).slice(0,12);const victims=[...primary,...live.filter(v=>!primary.includes(v)&&primary.some(p=>adjacent(p,v)))];move.hashSplashWeights=new Map(victims.map(v=>[v,(primary.includes(v)?1:0)+.25*primary.filter(p=>p!==v&&adjacent(p,v)).length]));return victims;}
  return null;
}
const adjacent=(a,b)=>Math.abs(Math.floor((a.pos-1)/5)-Math.floor((b.pos-1)/5))+Math.abs((a.pos-1)%5-(b.pos-1)%5)===1;
function prepareMove(ctx,u,move){
  if(!isHash(u)||!move)return move;
  let m={...move};
  if(m.hashMystery)m.multiplier*=1+.1*(u.hashMysteryStacks||0);
  if(burst(u)){m.multiplier*=1+config.burstDamageBonus;if(m.id===config.chases[0].id)m.ignoreDefense=.3;}
  return m;
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!move)return;
  const records=[];
  if(move.prompt&&ctx.hashForest&&ctx.round<=ctx.hashForest.until&&active(u,'hashExplosiveUntil'))for(const t of hit)debuff(ctx,u,t,'hashRootUntil',records);
  if(!isHash(u)){if(records.length)frame.reactions.push(passive(u,records));return;}
  if(move.lifeSteal){const amount=frame.targets.filter(r=>r.cmd===CMD.ATTACK&&r.targetCamp!==u.camp).reduce((s,r)=>s+Math.max(0,r.result.hurtHp||0),0)*move.lifeSteal;const heal=skills.restore(u,u,amount,records);if(heal)label(records,u,11,heal);}
  if(move.hashSword){for(const t of hit){t.hashStandardLoss=(t.hashStandardLoss||0)+1;t.hashStandardLossRound=ctx.round;label(records,t,13);}
    if(u.hashStandards<5&&ctx.random()<move.extraChance){u.hashExtra=(u.hashExtra||0)+1;label(records,u,14);}}
  if(move.id===config.mystery.id||move.hashChase){for(const t of hit){if(!skills.status(t,'immuneDebuffs')){t.painInterruptedUntil=ctx.round;label(records,t,9);}}}
  if(move.hashMystery&&!move.hashBurstMystery&&hit.includes(selected))debuff(ctx,u,selected,'hashSealUntil',records);
  if(move.hashBurstMystery){
    // Suppression precedes the Level-2 Weakness check, including otherwise immune targets.
    for(const t of hit){if(t.hp>0&&!burst(t)){t.suppressedUntil=ctx.round;label(records,t,15);}}
    if(hit.length){const amount=ctx.chakra[1-u.camp];ctx.chakra[1-u.camp]=0;ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]||100,ctx.chakra[u.camp]+amount);label(records,u,12,amount);}
    if(hit.includes(selected))debuff(ctx,u,selected,'hashWeakUntil',records,ctx.round+1);
  }
  if(move.hashSevere){u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||1)-1);if(move.hashBurstChase&&active(selected,'hashWeakUntil')){selected.hashEvasionUntil=Number.MAX_SAFE_INTEGER;label(records,selected,16,20);}
    if(hit.includes(selected))debuff(ctx,u,selected,move.hashBurstChase?'hashWeakUntil':'hashEnfeebleUntil',records,ctx.round,!move.hashBurstChase);}
  if(ctx.hashPending?.length)records.push(...ctx.hashPending.splice(0));
  if(records.length)frame.reactions.push(passive(u,records));
}
function additional(ctx,u,move){if(isHash(u)&&move?.id===config.mystery.id&&u.hp>0&&high(u)&&u.hashGolemRound!==ctx.round){u.hashGolemRound=ctx.round;return config.additional;}return null;}
function fireImmune(u,move,actor){return burst(u)&&(move?.element||actor?.element)==='fire';}
module.exports={config,isHash,active,burst,profile,initialize,roundStart,endRound,factor,canStandard,canMystery,available,spendStandard,spendMystery,onDamage,targets,prepareMove,afterHit,additional,fireImmune,passive,label,adjacent};
