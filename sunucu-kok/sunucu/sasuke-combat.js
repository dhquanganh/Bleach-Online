'use strict';
const config=require('./sasuke-shinden.json'),{CMD,ST,ACTIVE}=require('./kodek');
const skills=()=>require('./hero-skills');
const isSasuke=u=>u?.id===config.heroId;
const active=(u,key)=>Number.isFinite(u?.[key])&&u[key]>=Number(u.battleRound||1);
const label=(r,u,n,v=1)=>r.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19001400+n,buffTurn:v}});
function profile(u){return isSasuke(u)?{...config,mystery:u.sasukeBlazeMystery?config.blazeMystery:config.mystery,standard:u.hp>=u.maxHp*.5?config.blazeStandard:config.standard}:null;}
function initialize(ctx){ctx.sasukeTriggers=[];for(const u of ctx.teams.flat()){Object.defineProperty(u,'sasukeContext',{value:ctx,writable:true,configurable:true,enumerable:false});if(isSasuke(u)){for(const key of Object.keys(u))if(key.startsWith('sasuke')&&key!=='sasukeContext')delete u[key];u.superArmor=true;}}}
function roundStart(ctx){const requests=[];for(const u of ctx.teams.flat()){if(!isSasuke(u)||u.hp<=0)continue;u.sasukeMysteries=0;u.sasukeMysteryDamage=0;u.sasukeTaijutsuDamage=0;u.sasukeVisuals=0;u.sasukeTriggerReceived=false;if(ctx.round===1)requests.push({unit:u,move:config.susanoo});requests.push({unit:u,move:ctx.round%2?config.dragon:config.blazeDragon});}return requests;}
function canMystery(u){return !isSasuke(u)||(u.sasukeMysteries||0)<2;}
function spendMystery(ctx,u){if(!isSasuke(u))return;u.sasukeMysteries=(u.sasukeMysteries||0)+1;u.sasukeBlazeMystery=!u.sasukeBlazeMystery;u.sasukeTriggerGrowth=Math.min(1,(u.sasukeTriggerGrowth||0)+.2);}
function factor(u,field){let f=1;if(['atk','magicAtk'].includes(field)&&active(u,'sasukeBlazeUntil'))f*=Math.max(0,1-(u.sasukeBlazeAtkLoss||0));if(['def','resistance'].includes(field)&&active(u,'sasukeBlazeUntil'))f*=Math.max(0,1-(u.sasukeBlazeDefLoss||0));if(field==='resistance'&&active(u,'sasukeElectrocutionUntil'))f*=.25;return f;}
function beforeDamage(ctx,actor,target,move,damage){if(damage<=0)return damage;
 if(active(target,'sasukeBlazeUntil'))target.sasukeBlazeDefLoss=(target.sasukeBlazeDefLoss||0)+.02;
 if(isSasuke(target)){
  const trigger=move?.activeType===ACTIVE.NORMAL_EX||move?.trigger;
  if((trigger&&!target.sasukeTriggerReceived)||move?.prompt){if(trigger)target.sasukeTriggerReceived=true;if((target.sasukeVisuals||0)<4){target.sasukeVisuals=(target.sasukeVisuals||0)+1;ctx.sasukeTriggers.push({unit:target,move:move?.prompt?config.rinnegan:config.mangekyo});}}
  if(move?.prompt&&(target.sasukeMysteryDamage=(target.sasukeMysteryDamage||0)+1)<=2)damage=Math.round(damage*.6);
  const pure=move?.pureTaijutsu||(!move?.element&&!move?.prompt&&!move?.trigger&&move?.damageType!=='ninjutsu');
  if(pure&&(target.sasukeTaijutsuDamage=(target.sasukeTaijutsuDamage||0)+1)<=2)return 0;
 }
 return damage;
}
function onDamage(ctx,actor,target,damage,critical){if(damage<=0)return;
 if(active(actor,'sasukeBlazeUntil'))actor.sasukeBlazeAtkLoss=(actor.sasukeBlazeAtkLoss||0)+.01;
 if(critical&&active(target,'sasukeDisorderUntil')&&target.sasukeDisorderCriticalRound!==ctx.round){target.sasukeDisorderCriticalRound=ctx.round;actor.skillBuffs||=[];actor.skillBuffs.push({field:'critRate',value:-.15,remaining:2,source:target.id,sasukeDisorder:true});target.sasukeDisorderDamage=target.maxHp*.1;}
}
function apply(ctx,target,key,records,rounds=0){if(require('./asura-guardian-combat').blocksKey(target,key))return false;if(target.hp<=0||skills().status(target,'immuneDebuffs'))return false;target[key]=ctx.round+rounds;label(records,target,{sasukeBlazeUntil:1,sasukeElectrocutionUntil:2,sasukeStaticUntil:3,sasukeDisorderUntil:4,sasukeFearUntil:5,sasukeIgnitionUntil:6}[key]||1);return true;}
function afterHit(ctx,u,selected,hit,move,frame){if(!isSasuke(u)||!move)return;const records=[];
 for(const t of hit){
  if(move.sasukeStandard){if(move.sasukeBlaze)apply(ctx,t,'sasukeBlazeUntil',records,1);if(move.causes==='knockdown')apply(ctx,t,'sasukeStaticUntil',records,1);}
  if(move.sasukeMystery){require('./pain-combat').interrupt(ctx,t,records);apply(ctx,t,move.sasukeBlaze?'sasukeBlazeUntil':'sasukeElectrocutionUntil',records,move.sasukeBlaze?1:0);if(move.sasukeBlaze&&t===selected)t.mysteryReadyRound=Math.max(ctx.round+1,t.mysteryReadyRound||1);}
  if(move.sasukeDragon){apply(ctx,t,'sasukeIgnitionUntil',records);t.sasukeIgnitionSource=u;if(move.sasukeBlaze)apply(ctx,t,'sasukeBlazeUntil',records,1);}
  if(move.sasukeMangekyo&&active(t,'sasukeBlazeUntil'))apply(ctx,t,'sasukeDisorderUntil',records,1);
  if(move.sasukeRinnegan&&active(t,'sasukeBlazeUntil')){apply(ctx,t,'sasukeFearUntil',records,1);u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||1)-1);}
 }
 if(move.sasukeMangekyo||move.sasukeRinnegan)label(records,u,7);
 if(records.length)frame.reactions.push(require('./pain-combat').passive(u,records));
}
function beforeAction(ctx,u,move){if(active(u,'sasukeFearUntil'))u.sasukeFearDamage=(u.sasukeFearDamage||0)+Math.min(3000,u.hp*.05);
 if(active(u,'sasukeStaticUntil')){if(move?.prompt){for(const ally of ctx.teams[u.camp])if(ally.hp>0&&!skills().status(ally,'immuneDebuffs'))ally.sasukeParalysisUntil=ctx.round;}else if(move?.trigger&&!skills().status(u,'immuneDebuffs'))u.sasukeParalysisUntil=ctx.round;}}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat()){let damage=(u.sasukeFearDamage||0)+(u.sasukeDisorderDamage||0);u.sasukeFearDamage=0;u.sasukeDisorderDamage=0;if(active(u,'sasukeIgnitionUntil')&&u.sasukeIgnitionSource){const a=skills().value(u.sasukeIgnitionSource,'atk'),d=skills().value(u,'def');damage+=a*.3*a/Math.max(1,a+d);}damage=Math.min(u.hp,Math.max(0,Math.round(damage)));if(damage){const records=[];damage=require('./guy-gate-combat').indirect(ctx,u.sasukeIgnitionSource,u,damage,records);u.hp-=damage;out.push(require('./pain-combat').passive(u,[...records,skills().hpRecord(u,damage,false)]));}}return out;}
function prepareMove(u,move){return isSasuke(u)&&move?.trigger?{...move,multiplier:move.multiplier*(1+(u.sasukeTriggerGrowth||0))}:move;}
function selectStandard(ctx,u,move){return isSasuke(u)&&move?.sasukeStandard?{...move,causes:ctx.random()<.5?'knockdown':null,combo:move.hitCount}:move;}
function triggers(ctx){return ctx.sasukeTriggers.splice(0).filter(x=>x.unit.hp>0);}
module.exports={config,isSasuke,active,profile,initialize,roundStart,canMystery,spendMystery,factor,beforeDamage,onDamage,afterHit,beforeAction,endRound,prepareMove,selectStandard,triggers};
