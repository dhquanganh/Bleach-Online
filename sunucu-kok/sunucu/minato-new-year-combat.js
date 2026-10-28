'use strict';
const config=require('./minato-new-year.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isMinato=u=>u?.id===config.heroId,isClone=u=>u?.id===config.summonId;
const active=(u,key,round=u?.battleRound)=>!!u&&Number.isFinite(u[key])&&u[key]>=(round||1);
const trigger=move=>!!(move?.trigger||move?.kakuzuAdditional||move?.tobiSummit||move?.madaraMove==='complete');
function profile(u){if(isClone(u))return {standard:null,chases:[]};if(!isMinato(u))return null;return {...config,mystery:u.minatoProwess?config.enhancedMystery:config.mystery};}
function owners(ctx,camp){return ctx.teams[camp].filter(u=>isMinato(u)&&u.hp>0);}
function immuneAura(u){return isClone(u)||!!u?.minatoContext&&owners(u.minatoContext,u.camp).length>0;}
function tags(u){return require('./statlar').heroById.get(u.id)?.tags||[];}
function marked(ctx,u){return active(u,'minatoMarkUntil',ctx.round);}
function mark(ctx,source,u){if(!u||u.hp<=0||isMinato(u)||isClone(u)||skills.status(u,'immuneDebuffs'))return false;u.minatoMarkUntil=ctx.round+1;u.minatoMarkSource=source;return true;}
function prepareSummons(teams){for(const team of teams){
 const owner=team.find(u=>isMinato(u)&&u.hp>0);if(!owner||team.some(isClone))continue;
 const pos=Array.from({length:15},(_,i)=>i+1).find(p=>!team.some(v=>v.pos===p));if(!pos)continue;
 team.push({id:config.summonId,isim:'Yellow Flash Clone',pos,camp:owner.camp,hp:0,maxHp:owner.maxHp,atk:owner.atk,magicAtk:owner.atk,def:owner.def,resistance:owner.resistance,speed:owner.speed,level:owner.level,quality:7,profession:1,normal:config.cloneCounter.id,skillId:config.cloneCounter.id,skill:0,anger:0,hitRate:1,auxiliary:true,minatoOwner:owner,partnerSkills:[],weaponSkills:[]});
}}
function initialize(ctx){ctx.minatoQueue=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'minatoContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isMinato(u)||isClone(u)){u.minatoCounterStacks=0;u.minatoEvades=0;}
 if(isMinato(u)){u.minatoProwess=false;u.minatoAttackStacks=0;u.minatoStandards=0;}
}}
function summon(ctx,u){const clone=ctx.teams[u.camp].find(isClone);if(!clone||clone.hp>0||u.hp<=0)return [];
 clone.minatoOwner=u;clone.maxHp=u.maxHp;clone.hp=clone.maxHp;clone.atk=u.atk;clone.def=u.def;clone.resistance=u.resistance;
 clone.minatoCounterStacks=0;clone.minatoEvades=0;
 return [skills.hpRecord(clone,-clone.hp,false)];
}
function battleStart(ctx){const out=[];for(const team of ctx.teams){const u=team.find(v=>isMinato(v)&&v.hp>0);if(!u)continue;const records=summon(ctx,u);if(records.length){out.push({...pain.visual(u,config.summon),targets:records});triggerExecuted(ctx,u);}}return out;}
function roundStart(ctx){for(const u of ctx.teams.flat()){
 if(isMinato(u))resetRound(ctx,u);
 if(u.minatoMarkUntil<ctx.round){delete u.minatoMarkUntil;delete u.minatoMarkSource;}
}}
function resetRound(ctx,u){if(u.minatoCountRound!==ctx.round){u.minatoCountRound=ctx.round;u.minatoResets=0;u.minatoMysteries=0;u.minatoTriggerBuffs=0;}}
function canMystery(ctx,u){if(!isMinato(u))return true;resetRound(ctx,u);return u.minatoMysteries<3;}
function mysteryExecuted(ctx,u){if(!isMinato(u))return;resetRound(ctx,u);u.minatoMysteries++;u.minatoTriggerEvadeUntil=ctx.round;}
function selectStandard(ctx,u,move){if(!isMinato(u))return move;const choices=[config.standard,config.standard2,config.standard3];return choices[(u.minatoStandards||0)%choices.length];}
function factor(u,field){return isMinato(u)&&['atk','magicAtk'].includes(field)?1+.2*(u.minatoAttackStacks||0):1;}
function critical(u){return (isMinato(u)||isClone(u))?.15*(u.minatoEvades||0):0;}
function queue(ctx,u,move,target){if(u.hp>0)ctx.minatoQueue.push({unit:u,move,target});}
function evaded(ctx,u,attacker){if(!isMinato(u)&&!isClone(u)||u.hp<=0)return;
 u.minatoEvades=(u.minatoEvades||0)+1;u.minatoCounterStacks=Math.min(10,(u.minatoCounterStacks||0)+1);
 const enemies=ctx.teams[1-u.camp].filter(v=>v.hp>0);if(!enemies.length)return;
 const target=enemies[Math.min(enemies.length-1,Math.floor(ctx.random()*enemies.length))];
 queue(ctx,u,config.evade);queue(ctx,u,isClone(u)?config.cloneCounter:config.counter,target);
}
function evade(ctx,u,move,attacker,chase=false){if(!isMinato(u)&&!isClone(u)||u.hp<=0)return false;
 const eligible=chase||move?.chase||trigger(move)&&(isClone(u)||active(u,'minatoTriggerEvadeUntil',ctx.round));
 if(!eligible||ctx.random()>=config.evadeChance)return false;
 evaded(ctx,u,attacker);return true;
}
function prepareMove(ctx,u,move,selected){if(!move)return move;
 if(trigger(move)){triggerExecuted(ctx,u);move={...move,minatoTriggerCredited:true};}
 if(marked(ctx,u)){const attributes=tags(u);if(move.prompt&&attributes.includes(18)||trigger(move)&&attributes.includes(48))move={...move,unavoidable:false};}
 if(!move.minatoMove)return move;
 let multiplier=move.multiplier,critBonus=move.critBonus||0;
 const hasMark=selected&&marked(ctx,selected);
 if(move.prompt&&hasMark)multiplier*=1.4;

 if(move.minatoMove==='counter'||move.minatoMove==='cloneCounter')multiplier*=1+.1*(u.minatoCounterStacks||0);
 return {...move,multiplier,critBonus,minatoSelectedMarked:hasMark};
}
function criticalBonus(u,target,move){return move?.minatoMove?.startsWith('standard')&&active(target,'minatoMarkUntil')?.3:0;}
function targets(ctx,u,move,selected,enemies){if(!move?.minatoMove)return null;const living=enemies.filter(v=>v.hp>0);
 if(move.minatoMove.startsWith('standard')){if(!living.length)return [];const pivot=living[Math.min(living.length-1,Math.floor(ctx.random()*living.length))];const row=Math.floor((pivot.pos-1)/5);return living.filter(v=>Math.floor((v.pos-1)/5)===row);}
 if(move.minatoMove==='counter'||move.minatoMove==='cloneCounter')return [selected||living[0]].filter(v=>v&&v.hp>0);
 return living;
}
function outgoing(ctx,u,move){let scale=1;
 if(move?.prompt&&u.minatoMysteryPenalty){scale*=.25;delete u.minatoMysteryPenalty;}
 if(trigger(move))scale*=Math.max(.25,1-(u.minatoTriggerPenalty||0));
 return scale;
}
function onDamage(ctx,attacker,u,result,move,records){
 if(u.hp>0&&move?.prompt&&active(u,'minatoTriggerPenaltyWindow',ctx.round))u.minatoTriggerPenalty=Math.min(.75,(u.minatoTriggerPenalty||0)+.15);
 if(!(result.damage>0)||u.hp<=0)return;
 if(!isMinato(u))return;
 if(move?.prompt&&u.minatoSummonDamageRound!==ctx.round){u.minatoSummonDamageRound=ctx.round;queue(ctx,u,config.summon);}
 if(!u.minatoProwess&&u.hp<=u.maxHp*.5){
  u.minatoProwess=true;require('./tsunade-combat').cleanseAll(u,records);delete u.minatoMysteryPenalty;delete u.minatoTriggerPenalty;delete u.minatoTriggerPenaltyWindow;
  skills.restore(u,u,u.maxHp*.7,records);const alreadyActed=ctx.primaryActions.get(u)===ctx.round;ctx.primaryActions.delete(u);ctx.skillReady.get(u)?.delete('standard');queue(ctx,u,config.prowess);if(alreadyActed)ctx.minatoQueue.push({unit:u,standardAction:true});
 }
}
function afterHit(ctx,u,selected,hit,move,frame){if(!move)return;
 if(move.prompt){
  if(isMinato(u)){
   for(const v of hit)pain.interrupt(ctx,v,frame.targets);
   if(move.minatoSelectedMarked&&selected?.hp>0){selected.minatoMysteryPenalty=true;if(move.minatoMove==='enhancedMystery')selected.minatoTriggerPenaltyWindow=ctx.round;}
  }
  const owner=owners(ctx,u.camp)[0];if(owner)mark(ctx,owner,selected);
 }
 if(move.minatoMove?.startsWith('standard')){u.minatoStandards=(u.minatoStandards||0)+1;for(const v of hit)mark(ctx,u,v);}
 if(move.minatoMove==='summon'){const records=summon(ctx,u);if(records.length)frame.reactions.push(pain.passive(u,records));}
 if(move.minatoMove==='counter'||move.minatoMove==='cloneCounter'){
  for(const v of hit)if(v.hp>0)v.armorSuppressedUntil=ctx.round;
  if(isClone(u)){const owner=u.minatoOwner;if(owner?.hp>0){resetRound(ctx,owner);if(owner.minatoResets<config.maxMysteryResetsPerRound){owner.minatoResets++;owner.mysteryReadyRound=ctx.round;}}}
 }
 if(trigger(move)&&!move.minatoTriggerCredited)triggerExecuted(ctx,u);
}
function triggerExecuted(ctx,u){if(!ctx?.teams||!u)return;for(const owner of owners(ctx,u.camp)){
 resetRound({round:Math.max(1,ctx.round)},owner);if(owner.minatoTriggerBuffs<config.maxTeamTriggerBuffsPerRound){owner.minatoTriggerBuffs++;owner.minatoAttackStacks++;}
}}
function triggers(ctx){return ctx.minatoQueue.splice(0).filter(r=>r.unit.hp>0);}
module.exports={config,isMinato,isClone,active,profile,immuneAura,mark,marked,prepareSummons,initialize,summon,battleStart,roundStart,canMystery,mysteryExecuted,selectStandard,factor,critical,criticalBonus,evaded,evade,prepareMove,targets,outgoing,onDamage,afterHit,triggerExecuted,triggers};
