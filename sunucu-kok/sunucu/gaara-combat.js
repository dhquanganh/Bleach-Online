'use strict';
const config=require('./gaara-swimsuit.json'),{CMD,ST,ACTIVE}=require('./kodek');
const skills=()=>require('./hero-skills');
const active=(u,key)=>Number.isFinite(u?.[key])&&u[key]>=Number(u.battleRound||1);
const isGaara=u=>u?.id===config.heroId;
const profile=u=>isGaara(u)?config:null;
const summer=u=>isGaara(u)||u?.swimsuit===true||u?.summer===true||u?.naruto?.swimsuit===true||u?.naruto?.summer===true;
function label(records,u,n,value=1){records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19001600+n,buffTurn:value}});}
function initialize(ctx){for(const u of ctx.teams.flat()){
 for(const k of Object.keys(u))if(k.startsWith('gaara'))delete u[k];
 Object.defineProperty(u,'gaaraContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isGaara(u)){u.superArmor=true;u.gaaraBaseResistance=Number(u.resistance)||0;}
}}
function roundRequests(ctx){return ctx.teams.flat().filter(u=>isGaara(u)&&u.hp>0).map(unit=>({unit,move:config.storm}));}
function targets(move,selected,opponents){return move?.gaaraStorm?opponents.filter(u=>u.hp>0&&!u.auxiliary).sort((a,b)=>a.pos-b.pos).slice(0,4):null;}
function discouraged(u){return active(u,'gaaraDiscourageUntil');}
function blocks(caster,target){return caster!==target&&discouraged(target);}
function allowBuff(u,b){return !discouraged(u)||b.value<=0||b.kind==='dot'||['stun','freeze','silence','chaos','paralysis','noHeal','disarm','fossilize','vulnerability','void'].includes(b.field)||b.source===u.id||u.gaaraAcceptedBuffs?.has(b);}
function prepareMove(ctx,u,target,move){
 if(!isGaara(u)||!move)return move;
 if(move.gaaraMystery&&active(target,'armorSuppressedUntil')){
  u.gaaraArmor2Until=ctx.round;return {...move,critBonus:(move.critBonus||0)+config.mysteryCriticalBonus};
 }
 return move;
}
function mysteryExecuted(u){delete u.gaaraDiscourageUntil;delete u.gaaraAcceptedBuffs;}
function applyDebuff(ctx,target,key,rounds,records,n){if(target.hp<=0||skills().status(target,'immuneDebuffs'))return false;target[key]=Math.max(target[key]||0,ctx.round+rounds);label(records,target,n);return true;}
function onDamage(ctx,actor,target,result,critical,records){
 if(isGaara(actor)&&critical&&(result.damage>0||result.absorbed>0))applyDebuff(ctx,target,'gaaraBlindUntil',0,records,2);
 if(!(result.damage>0||result.absorbed>0)||summer(target)||target.gaaraFirstDamageRound===ctx.round)return;
 target.gaaraFirstDamageRound=ctx.round;
 if(!ctx.teams.flat().some(u=>isGaara(u)&&u.hp>0))return;
 target.gaaraRagingUntil=ctx.round;label(records,target,3);
}
function standardFactor(u,move,skillAt,extra){const standard=move?move.activeType===ACTIVE.NORMAL&&!move.prompt&&!move.trigger&&!move.support:!skillAt&&!extra;return standard&&active(u,'gaaraRagingUntil')?.5:1;}
function healFactor(u){return active(u,'gaaraRagingUntil')?.6:1;}
function criticalLoss(u){return active(u,'gaaraCritLossUntil')?.15*(u.gaaraCritLossStacks||0):0;}
function removeOne(target,records){
 const buffs=target.skillBuffs||[];const b=buffs.find(x=>x.remaining>0&&(x.level||1)<=1&&(x.value<0||x.kind==='dot'||['stun','freeze','silence','chaos','disarm','paralysis','noHeal','fossilize','void'].includes(x.field)));
 if(b){target.skillBuffs=buffs.filter(x=>x!==b);if(b.buffId)records.push({cmd:CMD.CONTROLBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:b.buffId,buffTurn:0}});return true;}
 for(const key of ['immobileUntil','extremeChaosUntil','armorSuppressedUntil','suppressedUntil','immunitySuppressedUntil','sasukeParalysisUntil'])if(active(target,key)){delete target[key];return true;}
 return false;
}
function afterHit(ctx,u,selected,hit,move,frame){if(!isGaara(u)||!move)return;
 const records=[];
 if(move.gaaraGuard){
  const allies=ctx.teams[u.camp].filter(t=>t.hp>0&&!t.auxiliary),count=ctx.random()<.5?2:3,pool=[...allies],chosen=[];
  while(pool.length&&chosen.length<count)chosen.push(pool.splice(Math.min(pool.length-1,Math.floor(ctx.random()*pool.length)),1)[0]);
  for(const t of chosen){if(!blocks(u,t)){
    t.shield=Math.max(t.shield||0,Math.round((u.gaaraBaseResistance??u.resistance??0)*config.shieldRatio));
    records.push({cmd:CMD.SHIELD,targetCamp:t.camp,targetPos:t.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:t.shield}});
   }removeOne(t,records);label(records,t,4);}
 }
 if(move.gaaraStorm)for(const t of hit){
  const accepted=new Set((t.skillBuffs||[]).filter(b=>allowBuff(t,b)));
  if(applyDebuff(ctx,t,'gaaraDiscourageUntil',1,records,1))t.gaaraAcceptedBuffs=accepted;
 }
 if(move.gaaraSurf)for(const t of hit){
  if(!active(t,'gaaraArmor2Until')){t.armorSuppressedUntil=ctx.round;label(records,t,5);}
  if(!skills().status(t,'immuneDebuffs')){t.gaaraCritLossStacks=(active(t,'gaaraCritLossUntil')?t.gaaraCritLossStacks||0:0)+1;t.gaaraCritLossUntil=ctx.round;label(records,t,6,t.gaaraCritLossStacks*15);}
 }
 if(move.gaaraMystery&&active(u,'gaaraArmor2Until'))label(records,u,7);
 // Root shield records provide the allies for the VFX; the native passive
 // command applies support results even though this standard has no damage hit.
 if(move.gaaraGuard)frame.targets.push(...records.filter(r=>r.cmd===CMD.SHIELD));
 if(records.length)frame.reactions.push(require('./pain-combat').passive(u,records));
}
function additional(u,move){return isGaara(u)&&u.hp>0&&move?.gaaraStorm?config.surf:null;}
module.exports={config,isGaara,profile,active,summer,initialize,roundRequests,targets,discouraged,blocks,allowBuff,prepareMove,mysteryExecuted,onDamage,standardFactor,healFactor,criticalLoss,afterHit,additional};
