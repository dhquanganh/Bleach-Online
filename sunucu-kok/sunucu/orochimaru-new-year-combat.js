'use strict';
const config=require('./orochimaru-new-year.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isOro=u=>u?.id===config.heroId;
const active=(u,k)=>Number.isFinite(u?.[k])&&u[k]>=(u.battleRound||1);
function profile(u){if(!isOro(u))return null;const conditions=['lowFloat','highFloat','knockdown','repulse'].slice(0,1+(u.oroChaseUnlocks||0));return {...config,mystery:u.oroSerpent?config.serpent:config.mystery,chases:[{...config.chase,requiresAny:conditions,unavoidable:conditions.length===4}]};}
function initialize(ctx){ctx.oroQueue=[];ctx.oroCost=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'oroContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isOro(u)){for(const k of Object.keys(u))if(k.startsWith('oro'))delete u[k];u.oroAttack=0;u.oroCritical=0;u.oroChaseUnlocks=0;u.oroSerpent=false;}
}}
function reset(ctx,u){if(u.oroRound!==ctx.round){u.oroRound=ctx.round;u.oroEvades=0;u.oroCounters=0;}}
function factor(u,f){let out=1;if(isOro(u)&&f==='atk')out*=1+.15*(u.oroAttack||0);if(['def','resistance'].includes(f)&&active(u,'oroDefenseLossUntil'))out*=Math.max(.4,1-.2*(u.oroDefenseLoss||0));return out;}
function critical(u){return isOro(u)?u.oroCritical||0:0;}
function sealed(u){return active(u,'oroSealUntil');}
function lacerated(u){return active(u,'oroLacerationUntil');}
function healing(u){return lacerated(u)?.5:1;}
function cost(ctx,u){return (ctx?.oroCost||[]).filter(b=>b.camp===u.camp&&b.until>=(u.battleRound||ctx.round||1)).reduce((max,b)=>Math.max(max,20*b.stacks),0);}
function triggerMove(move){return !!(move?.trigger||move?.tobiSummit||move?.kakuzuAdditional);}
function triggerExecuted(ctx,u,move){if(!ctx||!triggerMove(move))return;if(isOro(u))u.oroAttack++;
 if(sealed(u)){for(const v of ctx.teams[u.camp])if(v.hp>0){if(!active(v,'oroDefenseLossUntil'))v.oroDefenseLoss=0;v.oroDefenseLoss=Math.min(3,(v.oroDefenseLoss||0)+1);v.oroDefenseLossUntil=ctx.round;}}
}
function queue(ctx,u,move,target=null){if(u.hp>0)ctx.oroQueue.push({unit:u,move,target});}
function evaded(ctx,u){if(!ctx||!isOro(u)||u.hp<=0)return;reset(ctx,u);const records=[];if(u.oroEvades<5){u.oroEvades++;u.oroCritical=(u.oroCritical||0)+.08;}skills.restore(u,u,u.maxHp*.15,records);queue(ctx,u,config.evade);if(records.length)ctx.oroQueue.push({frame:pain.passive(u,records)});}
function evade(ctx,u,move){if(!isOro(u)||u.hp<=0||!move?.prompt||ctx.random()>=config.mysteryEvadeChance)return false;evaded(ctx,u);return true;}
function nonfatal(u){return isOro(u)&&active(u,'oroExplosiveUntil');}
function onDamage(ctx,source,u,result,move,records){if(!ctx||!isOro(u)||!source||source===u||source.camp===u.camp)return;reset(ctx,u);
 if(result.damage>0&&ctx.random()<config.damageHealChance)skills.restore(u,u,result.damage*config.damageHealRatio,records,true);
 if(u.hp>0&&nonfatal(u))skills.restore(u,u,u.maxHp*.04,records);
 if(u.hp>0&&result.damage>0&&triggerMove(move)&&u.oroCounters<5){u.oroCounters++;queue(ctx,u,config.additionalSeal);}
}
function indirect(ctx,source,u,damage,records){if(!isOro(u)||!source||source===u||source.camp===u.camp)return null;const before=u.hp;damage=Math.min(Math.max(0,before-(nonfatal(u)?1:0)),Math.max(0,Math.round(damage)));u.hp-=damage;records.push(skills.hpRecord(u,damage,false));onDamage(ctx,source,u,{damage,before},null,records);return 0;}
function noteDeaths(ctx){for(const u of ctx.teams.flat())if(isOro(u)&&u.hp<=0&&!u.noRevive&&!u.itachiUnrevivable&&!u.oroReviveRound)u.oroReviveRound=ctx.round+2;}
function roundStart(ctx){ctx.oroCost=ctx.oroCost.filter(b=>b.until>=ctx.round);const out=[];for(const u of ctx.teams.flat())if(isOro(u)){
 reset(ctx,u);if(u.hp<=0&&u.oroReviveRound&&ctx.round>=u.oroReviveRound&&!u.noRevive&&!u.itachiUnrevivable&&ctx.teams[u.camp].some(v=>v.hp>0&&!v.auxiliary)){
 u.hp=Math.max(1,Math.round(u.maxHp*.5));u.oroReviveRound=0;require('./tsunade-combat').cleanseAll(u,[]);delete u.oroBlindUntil;ctx.primaryActions.set(u,ctx.round);out.push(pain.passive(u,[skills.hpRecord(u,-u.hp,false)]),pain.visual(u,config.revive));}
 }return out;}
function allyRevivals(ctx){const out=[];if(ctx.round<config.allyReviveInterval||ctx.round%config.allyReviveInterval!==0)return out;
 for(const owner of ctx.teams.flat())if(isOro(owner)&&owner.hp>0&&owner.oroAllyRevivedRound!==ctx.round){
  owner.oroAllyRevivedRound=ctx.round;
  const candidates=ctx.teams[owner.camp].filter(v=>v!==owner&&v.hp<=0&&!v.auxiliary&&!v.noRevive&&!v.itachiUnrevivable);
  if(!candidates.length)continue;
  const target=candidates[Math.min(candidates.length-1,Math.floor(ctx.random()*candidates.length))];
  target.hp=Math.max(1,Math.round(target.maxHp*config.allyReviveHpRatio));require('./tsunade-combat').cleanseAll(target,[]);delete target.asuraBanishedUntil;delete target.guyPendingDeath;target.oroReviveRound=0;ctx.primaryActions.set(target,ctx.round);
  const show={cmd:9,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:33554432,result:{buffId:19002101,buffTurn:0}};
  out.push(pain.passive(target,[skills.hpRecord(target,-target.hp,false),show]),pain.visual(owner,config.revive));
 }return out;
}
function targets(ctx,u,move,selected,enemies){if(!move?.oroMove)return null;const alive=enemies.filter(v=>v.hp>0&&!require('./asura-guardian-combat').active(v,'asuraBanishedUntil'));
 if(move.oroMove.startsWith('standard'))return alive.sort((a,b)=>a.hp-b.hp||a.pos-b.pos).slice(0,1);
 if(['seal','additionalSeal'].includes(move.oroMove))return alive.length?[alive[Math.min(alive.length-1,Math.floor(ctx.random()*alive.length))]]:[];
 if(['manda','serpent','additionalSerpent','chase'].includes(move.oroMove))return [selected,...alive.filter(v=>v!==selected)].filter(v=>v?.hp>0);
 return [];
}
function selectStandard(ctx,u,move){return isOro(u)?[config.standard,config.standard2,config.standard3][Math.min(2,Math.floor(ctx.random()*3))]:move;}
function prepareMove(ctx,u,move){if(!move?.oroMove)return move;return move;}
function targetDamage(u,target,move){if(!['serpent','additionalSerpent'].includes(move?.oroMove))return 1;return 1+(skills.status(target,'immuneDebuffs')?.3:0)+(skills.armor(target)?.3:0);}
function debuff(ctx,target,key,until){if(target?.hp>0&&!skills.status(target,'immuneDebuffs'))target[key]=until;}
function afterHit(ctx,u,selected,hit,move,frame){triggerExecuted(ctx,u,move);if(!move?.oroMove)return;const key=move.oroMove;
 if(key==='manda'){for(const v of hit)debuff(ctx,v,'oroLacerationUntil',ctx.round+1);if(selected?.hp>0)pain.interrupt(ctx,selected,frame.targets);u.oroSerpent=true;if(hit.some(v=>v.hp<=0))queue(ctx,u,config.additionalSerpent);}
 if(key==='serpent')u.oroSerpent=false;
 if(['serpent','additionalSerpent'].includes(key))u.oroExplosiveUntil=ctx.round;
 if(key.startsWith('standard')){
  u.oroBlindUntil=ctx.round;
  for(const v of hit)if(lacerated(v)&&v.hp>0){let amount=Math.min(v.hp,Math.round(v.maxHp*.1));const records=[];amount=require('./guy-gate-combat').indirect(ctx,u,v,amount,records);v.hp-=amount;records.push(skills.hpRecord(v,amount,false));frame.reactions.push(pain.passive(v,records));u.oroBlindUntil=ctx.round;}
 }
 if(key==='chase'){u.oroChaseUnlocks=Math.min(3,(u.oroChaseUnlocks||0)+1);if(u.oroChaseUnlocks>=3)for(const v of hit){delete v.perseverance;delete v.perseveranceUntil;v.skillBuffs=(v.skillBuffs||[]).filter(b=>b.field!=='perseverance');}}
 if(['seal','additionalSeal'].includes(key)){
  for(const v of hit){debuff(ctx,v,'oroAcupunctureUntil',ctx.round);debuff(ctx,v,'oroSealUntil',ctx.round);}
  u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);
  let buff=ctx.oroCost.find(b=>b.camp===u.camp&&b.until>=ctx.round);if(!buff){buff={camp:u.camp,stacks:0,until:ctx.round+1};ctx.oroCost.push(buff);}buff.stacks=Math.min(2,buff.stacks+1);buff.until=ctx.round+1;
 }
}
function endRound(ctx){return ctx.teams.flat().filter(u=>isOro(u)&&u.hp>0).map(unit=>({unit,move:config.seal}));}
function triggers(ctx){return ctx.oroQueue.splice(0).filter(r=>r.frame||r.unit.hp>0);}
module.exports={config,isOro,active,profile,initialize,reset,factor,critical,sealed,lacerated,healing,cost,triggerMove,triggerExecuted,evaded,evade,nonfatal,onDamage,indirect,noteDeaths,roundStart,allyRevivals,targets,selectStandard,prepareMove,targetDamage,afterHit,endRound,triggers};
