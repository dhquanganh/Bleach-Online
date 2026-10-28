'use strict';
const config=require('./madara-infinite.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isMadara=u=>u?.id===config.heroId;
const active=(u,key)=>Number.isFinite(u?.[key])&&u[key]>=(u.battleRound||1);
function profile(u){return isMadara(u)?{...config,mystery:u.infiniteSusanoo?config.susanoo:config.mystery,chases:[u.infiniteContext?.chakra[u.camp]>=60?config.limboChase:config.chase]}:null;}
function initialize(ctx){ctx.infiniteQueue=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'infiniteContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isMadara(u)){u.infiniteStacks=0;u.infiniteReviveRound=0;u.infiniteSusanoo=false;}
}if(ctx.teams.flat().some(isMadara)){
 // Intercept bonus recovery from every kit; the normal round pool is assigned
 // before the round number changes, so it remains available each round.
 const pool=ctx.chakra;ctx.chakra=new Proxy(pool,{set(a,key,value){if((key==='0'||key==='1')&&value>a[key]&&ctx.infiniteChakraLock?.[key]===ctx.round)return true;a[key]=value;return true;}});
}}
function barrier(u){const ctx=u?.infiniteContext;return !!ctx?.infiniteBarrier&&ctx.infiniteBarrier.until>=ctx.round&&ctx.infiniteBarrier.camp===u.camp;}
function immune(u,field){return barrier(u)&&['slumber','paralysis'].includes(field);}
function blocksExplosive(u){const ctx=u?.infiniteContext;return !!ctx?.infiniteBarrier&&ctx.infiniteBarrier.until>=ctx.round&&ctx.infiniteBarrier.camp!==u.camp;}
function healing(u){const ctx=u?.infiniteContext;return ctx&&ctx.infiniteHealLock?.[u.camp]===ctx.round? .2:1;}
function factor(u,field){return isMadara(u)&&field==='atk'?1+.1*(u.infiniteStacks||0):1;}
function reset(ctx,u){if(u.infiniteRound!==ctx.round){u.infiniteRound=ctx.round;u.infiniteActions=0;u.infiniteEvaded=false;u.infiniteMysteries=0;u.infiniteStandard=false;u.infiniteStolen=0;u.infiniteRefund=false;}}
function roundStart(ctx){const out=[];ctx.infiniteChakraLock=[];ctx.infiniteHealLock=[];for(const u of ctx.teams.flat()){
 if(!isMadara(u))continue;reset(ctx,u);
 if(u.hp<=0&&u.infiniteReviveRound&&ctx.round>=u.infiniteReviveRound&&!u.noRevive&&!u.itachiUnrevivable){
  u.hp=Math.max(1,Math.round(u.maxHp*.8));u.infiniteReviveRound=0;require('./tsunade-combat').cleanseAll(u,[]);
  out.push(pain.passive(u,[skills.hpRecord(u,-u.hp,false)]),pain.visual(u,config.revive));
 }
}return out;}
function noteDeaths(ctx){for(const u of ctx.teams.flat())if(isMadara(u)&&u.hp<=0&&!u.noRevive&&!u.itachiUnrevivable&&!u.infiniteReviveRound)u.infiniteReviveRound=ctx.round+config.revivalDelayRounds;}
function canMystery(ctx,u){if(!isMadara(u))return true;reset(ctx,u);return u.infiniteMysteries<(u.infiniteRefund?2:1);}
function mysteryExecuted(ctx,u){if(isMadara(u)){reset(ctx,u);u.infiniteMysteries++;}}
function available(ctx,u){reset(ctx,u);return isMadara(u)&&u.infiniteStolen>0;}
function selectStandard(ctx,u,move){if(!isMadara(u))return move;reset(ctx,u);return !u.infiniteStandard?config.standard:[config.standard2,config.standard3,config.standard4][(u.infiniteDance||0)%3];}
function spendStandard(ctx,u){if(!isMadara(u))return;reset(ctx,u);if(u.infiniteStandard)u.infiniteStolen=Math.max(0,u.infiniteStolen-1);u.infiniteStandard=true;u.infiniteDance=(u.infiniteDance||0)+1;}
function targets(ctx,u,move,selected,enemies){if(!move?.infiniteMove)return null;const living=enemies.filter(v=>v.hp>0);if(!living.length)return [];
 if(move.infiniteMove==='limbo')return living; // one opposing lineup in this 1v1 battle mode
 if(move.infiniteMove.startsWith('standard'))return [living[Math.min(living.length-1,Math.floor(ctx.random()*living.length))]];
 return move.target==='all'?living:[selected||living[0]];
}
function prepareMove(ctx,u,move){if(!move?.infiniteMove)return move;
 if(['standard','standard2','standard3'].includes(move.infiniteMove))return {...move,infiniteParalysis:ctx.random()<.5};
 return move;
}
function evaded(ctx,u){if(!isMadara(u)||u.hp<=0)return;reset(ctx,u);if(u.infiniteEvaded)return;u.infiniteEvaded=true;
 ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]||100,ctx.chakra[u.camp]+100);
 ctx.infiniteQueue.push({unit:u,move:config.evade},{unit:u,move:config.counter});
}
function evade(ctx,u){if(!isMadara(u)||u.hp<=0)return false;reset(ctx,u);if(u.infiniteEvaded||ctx.random()>=config.evadeChance)return false;evaded(ctx,u);return true;}
function afterHit(ctx,u,selected,hit,move,frame){if(!move?.infiniteMove)return;reset(ctx,u);
 const kind=move.infiniteMove;
 if(kind==='mystery'){
  for(const v of ctx.teams[1-u.camp])if(v.hp>0)v.infiniteRestrainedUntil=ctx.round;
  if(selected?.hp>0)pain.interrupt(ctx,selected,frame.targets);
  u.infiniteSusanoo=true;ctx.infiniteQueue.push({unit:u,move:config.barrier});
 }
 if(kind==='barrier'){
  ctx.infiniteBarrier={camp:u.camp,until:ctx.round+1};ctx.infiniteChakraLock||=[];ctx.infiniteHealLock||=[];
  ctx.infiniteChakraLock[1-u.camp]=ctx.round;ctx.infiniteHealLock[1-u.camp]=ctx.round;
  for(const v of ctx.teams[u.camp]){delete v.infiniteSlumberUntil;delete v.kakuzuParalysisUntil;delete v.sasukeParalysisUntil;delete v.infiniteParalysisUntil;v.paralyzed=false;skills.removeField(v,'paralysis',frame.targets);}
  for(const v of ctx.teams[1-u.camp]){delete v.explosiveMode;delete v.hashExplosiveUntil;}
 }
 if(kind==='susanoo'){
  for(const v of hit){if(v.hp>0)v.armorSuppressedUntil=ctx.round+1;delete v.explosiveMode;delete v.hashExplosiveUntil;}
  if(selected?.hp>0)selected.madaraShatterUntil=ctx.round+1;
  u.infiniteSusanoo=false;
 }
 if(kind==='limbo'){
  for(const v of hit)if(v.hp>0&&v.infiniteStandardsStolen!==ctx.round){
   v.infiniteStandardsStolen=ctx.round;let count=ctx.primaryActions.get(v)===ctx.round?0:1;
   if(require('./mecha-combat').isMecha(v))count=Math.max(0,(v.mechaStandards?0:1)+(v.mechaExtra||0));
   if(require('./hashirama-combat').isHash(v))count=Math.max(0,Math.min(5-(v.hashStandards||0),(v.hashStandards?0:1)+(v.hashExtra||0)));
   if(require('./obito-combat').isObito(v))count=Math.max(0,2+(v.obitoRage?(v.obitoKillCredits||0):0)-(v.obitoStandards||0));
   if(isMadara(v))count+=(v.infiniteStolen||0);
   count=Math.max(0,count-(v.hashStandardLossRound===ctx.round?(v.hashStandardLoss||0):0));
   v.hashStandardLossRound=ctx.round;v.hashStandardLoss=(v.hashStandardLoss||0)+count;u.infiniteStolen+=count;
  }
 }
 if(['chase','limboChase','counter'].includes(kind))for(const v of hit){delete v.perseverance;delete v.perseveranceUntil;v.skillBuffs=(v.skillBuffs||[]).filter(b=>b.field!=='perseverance');paralyze(ctx,v);}
 if(kind.startsWith('standard')){frame.comboTarget=hit[0]||selected;for(const v of hit){if(v.hp<=0)v.noRevive=true;else if(move.infiniteParalysis)paralyze(ctx,v);}}
 if(kind==='counter'){u.infiniteRefund=true;u.mysteryReadyRound=ctx.round;}
}
function paralyze(ctx,v){if(v.hp>0&&!skills.status(v,'immuneDebuffs')&&!immune(v,'paralysis'))v.infiniteParalysisUntil=ctx.round;}
function action(ctx,u){for(const v of ctx.teams.flat())if(isMadara(v)&&v.hp>0){reset(ctx,v);if(v.infiniteActions<8){v.infiniteActions++;v.infiniteStacks++;}}
 if(u.hp>0&&active(u,'infiniteRestrainedUntil')&&!immune(u,'slumber'))u.infiniteSlumberUntil=ctx.round;
}
function triggers(ctx){return ctx.infiniteQueue.splice(0).filter(r=>r.unit.hp>0);}
module.exports={config,isMadara,active,profile,initialize,barrier,immune,blocksExplosive,healing,factor,roundStart,noteDeaths,canMystery,mysteryExecuted,available,selectStandard,spendStandard,targets,prepareMove,evaded,evade,afterHit,action,triggers};
