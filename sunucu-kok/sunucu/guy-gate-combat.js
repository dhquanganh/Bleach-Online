'use strict';
const config=require('./guy-gate.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isGuy=u=>u?.id===config.heroId;
const active=(u,key)=>Number.isFinite(u?.[key])&&u[key]>=(u.battleRound||1);
function profile(u){return isGuy(u)?config:null;}
function initialize(ctx){ctx.guyQueue=[];for(const u of ctx.teams.flat()){
 for(const k of Object.keys(u))if(k.startsWith('guy'))delete u[k];
 Object.defineProperty(u,'guyContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isGuy(u)){u.guySteamStacks=0;u.guySpeedStacks=0;u.guyRevived=false;u.guyNarutoRescue=ctx.teams[u.camp].some(v=>v.id===11121006&&!v.auxiliary);}
}}
function battleStart(ctx){for(const u of ctx.teams.flat())if(isGuy(u)&&u.hp>0)require('./buff-notices').touch(u,'def');return [];}
function owner(u){return u.guyContext?.teams[u.camp].find(v=>isGuy(v)&&v.hp>0);}
function loss(u){return Math.max(0,Math.min(100,Math.floor((1-u.hp/u.maxHp)*100+1e-8)));}
function factor(u,field){let f=1;if(isGuy(u)){
 if(field==='atk')f*=1+.6*(u.guySteamStacks||0);
 if(field==='speed')f*=1+.05*(u.guySpeedStacks||0);
 if(field==='def'&&(u.battleRound||1)<=config.guardRounds)f*=1+config.defenseBonus;
 }const g=owner(u);if(g&&field==='atk')f*=1+.02*loss(g);return f;}
function critical(u){const g=owner(u);return g?.hp>0?.01*loss(g):0;}
function guard(ctx,u){if(!ctx||ctx.round>config.guardRounds)return null;return ctx.teams[u.camp].find(v=>isGuy(v)&&v!==u&&v.hp>0)||null;}
function queueDeath(ctx,u){if(u.guyPendingDeath||u.hp<=0)return;u.guyPendingDeath=true;u.guyDeathDisabled=require('./naruto-final-combat').blocksDeath(u);if(!u.guyDeathDisabled)ctx.guyQueue.push({unit:u,move:config.night});}
function protectFatal(ctx,u,damage,ignoreShield=false){if(!isGuy(u)||u.hp<=0||Math.max(0,damage-(ignoreShield?0:u.shield||0))<u.hp)return false;queueDeath(ctx,u);return true;}
function beforeAction(ctx,u,move){if(!isGuy(u)||!move||['steam','revive','splash'].includes(move.guyMove)||u.hp<=0)return [];
 const amount=Math.min(Math.max(0,u.hp-1),Math.round(u.maxHp*config.hpCostRatio)*(move.prompt?2:1));u.hp-=amount;
 u.guySteamStacks=Math.min(10,u.guySteamStacks+1);u.guySpeedStacks=Math.min(3,u.guySpeedStacks+1);u.guyArmorUntil=ctx.round;u.guyEvadeUntil=ctx.round;
 require('./minato-new-year-combat').triggerExecuted(ctx,u,config.steam);
 return [{...pain.visual(u,config.steam),targets:amount?[skills.hpRecord(u,amount,false)]:[]}];
}
function disabled(u){return isGuy(u)&&u.guyPendingDeath||active(u,'guyImmobileUntil');}
function restrained(u){return active(u,'guyRestraintUntil');}
function evade(ctx,u,move,extra=false){return isGuy(u)&&!u.guyPendingDeath&&active(u,'guyEvadeUntil')&&!extra&&!move?.prompt&&!move?.trigger&&!move?.chase&&ctx.random()<config.evadeChance;}
function selectStandard(ctx,u,move){return isGuy(u)?(ctx.random()<.5?config.standard:config.standard2):move;}
function line(u){return (u.pos-1)%5;}
function targets(ctx,u,move,selected,enemies){if(!move?.guyMove)return null;const alive=enemies.filter(v=>v.hp>0);if(!alive.length)return [];
 if(move.guyMove==='splash')return (move.guySplashTargets||[selected]).filter(v=>v?.hp>0);
 if(move.guyMove==='mystery')return alive;
 if(move.guyMove==='night'){const first=alive.slice().sort((a,b)=>Math.floor((a.pos-1)/5)-Math.floor((b.pos-1)/5)||a.pos-b.pos)[0];return alive.filter(v=>line(v)===line(first));}
 if(move.guyMove.startsWith('standard')){const pivot=alive[Math.min(alive.length-1,Math.floor(ctx.random()*alive.length))];return alive.filter(v=>line(v)===line(pivot));}
 return [];
}
function debuff(ctx,u,key,self=false){if(u?.hp>0&&(self||!skills.status(u,'immuneDebuffs')))u[key]=ctx.round;}
function finishDeath(ctx,u){const before=u.hp;u.hp=0;u.guyPendingDeath=false;u.guyDeathDisabled=false;const out=[pain.passive(u,[skills.hpRecord(u,before,false)])];
 if(u.guyNarutoRescue&&!u.guyRevived&&!u.noRevive&&!u.itachiUnrevivable){
  u.guyRevived=true;u.hp=Math.max(1,Math.round(u.maxHp*config.reviveHpRatio));require('./tsunade-combat').cleanseAll(u,[]);delete u.guyImmobileUntil;delete u.guyRestraintUntil;ctx.primaryActions.set(u,ctx.round);
  out.push(pain.passive(u,[skills.hpRecord(u,-u.hp,false)]),pain.visual(u,config.revive));
 }else u.noRevive=true;
 return out;
}
function afterHit(ctx,u,selected,hit,move,frame){if(!move?.guyMove)return;const key=move.guyMove;
 if(key==='mystery'){debuff(ctx,u,'guyImmobileUntil',true);debuff(ctx,selected,'guyImmobileUntil');}
 if(key.startsWith('standard')){
  debuff(ctx,u,'guyRestraintUntil',true);for(const v of hit){v.armorSuppressedUntil=ctx.round;debuff(ctx,v,'guyRestraintUntil');}
  if(ctx.random()<config.splashChance){const splash=ctx.teams[1-u.camp].filter(v=>v.hp>0&&!hit.includes(v)&&hit.some(t=>Math.abs(Math.floor((v.pos-1)/5)-Math.floor((t.pos-1)/5))+Math.abs(line(v)-line(t))===1));if(splash.length)ctx.guyQueue.push({unit:u,move:{...config.splash,guySplashTargets:splash}});}
 }
 if(key==='night'){for(const v of hit)if(v.hp<=0)v.noRevive=true;frame.reactions.push(...finishDeath(ctx,u));}
}
function interrupted(ctx,u){if(isGuy(u)){u.mysteryReadyRound=ctx.round;delete u.painInterruptedUntil;require('./buff-notices').touch(u,'mysteryCooldown');}}
function indirect(ctx,source,target,damage,records){if(require('./asura-guardian-combat').immune(target))return 0;if(!ctx)return damage;const g=isGuy(target)?target:guard(ctx,target);if(!g&&damage>0){const result=require('./orochimaru-new-year-combat').indirect(ctx,source,target,damage,records);if(result!==null)return result;}if(!g||!(damage>0))return damage;
 const attack=source?Math.max(1,skills.value(source,'atk')):0;const amount=source?Math.round(damage*(attack+skills.value(target,'def'))/(attack+skills.value(g,'def'))):damage;
 const protectedHit=protectFatal(ctx,g,amount);const r=require('./reincarnation').hit(source||target,g,amount,ctx.random,false,protectedHit);
 records.push(skills.hpRecord(g,r.damage,false));return 0;
}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat())if(isGuy(u)&&u.hp>0&&u.guyPendingDeath&&u.guyDeathDisabled)out.push(...finishDeath(ctx,u));return out;}
function triggers(ctx){return ctx.guyQueue.splice(0).filter(r=>r.unit.hp>0);}
module.exports={config,isGuy,active,profile,initialize,battleStart,factor,critical,guard,protectFatal,beforeAction,disabled,restrained,evade,selectStandard,targets,afterHit,finishDeath,interrupted,indirect,endRound,triggers};
