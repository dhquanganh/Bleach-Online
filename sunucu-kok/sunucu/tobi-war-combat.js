'use strict';
const config=require('./tobi-war.json'),{CMD,ST}=require('./kodek');
const skills=()=>require('./hero-skills'),isTobi=u=>u?.id===config.heroId,isZetsu=u=>u?.id===config.summonId;
const profile=u=>isTobi(u)?config:isZetsu(u)?{heroId:u.id,standard:{id:13121808,name:'White Zetsu Attack',attackStat:'maxHp',damageType:'physical',target:1,multiplier:.05,cooldown:0},chases:[]}:null;
function prepareSummons(teams){for(const team of teams)for(const owner of [...team].filter(isTobi))for(let i=team.filter(u=>u.tobiOwner===owner).length;i<2;i++){
 const pos=Array.from({length:15},(_,n)=>n+1).find(p=>!team.some(u=>u.pos===p));if(!pos)break;
 team.push({id:config.summonId,isim:'White Zetsu',pos,camp:owner.camp,hp:0,maxHp:Math.max(1,Math.round(owner.maxHp*.6)),level:owner.level,quality:7,profession:1,atk:owner.atk,magicAtk:owner.magicAtk,def:owner.def,resistance:owner.resistance,speed:owner.speed,normal:13121808,skill:0,skillId:13121808,anger:0,verdi:0,hitRate:1,tobiOwner:owner,auxiliary:true,partnerSkills:[],weaponSkills:[]});
}}
function initialize(ctx){ctx.tobiQueue=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'tobiContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 for(const key of ['tobiSummitRound','tobiArmorUntil','tobiKillStacks','tobiCostRound','tobiCostReduction','tobiSporeRound'])delete u[key];
}}
function selectStandard(ctx,u,move){return isTobi(u)?{...(ctx.random()<config.lineChance?config.lineStandard:config.standard)}:move;}
function targets(move,selected,enemies,ctx){if(!move?.tobiStandard)return null;const alive=enemies.filter(u=>u.hp>0);if(!alive.length)return [];
 const picked=alive[Math.min(alive.length-1,Math.floor(ctx.random()*alive.length))];return move.tobiLine?alive.filter(u=>Math.floor((u.pos-1)/5)===Math.floor((picked.pos-1)/5)):[picked];
}
function prepareMove(ctx,u,move,selected){if(!isTobi(u)||!move?.tobiMystery)return move;
 const alive=ctx.teams[1-u.camp].filter(v=>v.hp>0),enemies=(selected&&selected.hp>0?[selected,...alive.filter(v=>v!==selected)]:alive).slice(0,9);const records=[];
 for(const v of enemies){
  skills().remove(v,false,records);
  if(v.shield>0)records.push({cmd:CMD.SHIELD,targetCamp:v.camp,targetPos:v.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});
  v.shield=0;
 }
 return {...move,tobiBefore:records.length?[require('./pain-combat').passive(u,records)]:[]};
}
function factor(u,field){return isTobi(u)&&['atk','magicAtk'].includes(field)?1+.4*(u.tobiKillStacks||0):1;}
function attacked(ctx,target,move){if(target.hp<=0||target.auxiliary||target.cloneOwner||target.isSummon||target.tobiSporeRound===ctx.round||!ctx.teams[target.camp].some(u=>isZetsu(u)&&u.hp>0))return;
 target.tobiSporeRound=ctx.round;for(const ally of ctx.teams[target.camp]){ally.tobiCostReduction=Math.min(40,(ally.tobiCostRound===ctx.round?ally.tobiCostReduction||0:0)+(move?.prompt?20:10));ally.tobiCostRound=ctx.round;}
}
function beforeDamage(ctx,target,move,damage){return isZetsu(target)&&move?.prompt?Math.min(damage,Math.max(0,target.hp-1)):damage;}
function chakra(ctx,u,amount){return require('./tsunade-combat').gainChakra(ctx,u,amount);}
function summon(ctx,u){const records=[];for(const z of ctx.teams[u.camp].filter(v=>v.tobiOwner===u&&v.hp<=0).slice(0,2)){z.maxHp=Math.max(1,Math.round(u.maxHp*.6));z.hp=z.maxHp;records.push(skills().hpRecord(z,-z.hp,false));}
 return records.length?[{...require('./pain-combat').visual(u,config.summoning),targets:records}]:[];
}
function afterHit(ctx,u,selected,hit,move,frame){if(!isTobi(u))return;
 if(move.tobiStandard){for(const v of hit)if(v.hp>0)v.suppressedUntil=ctx.round;if(hit.length)frame.comboTarget=hit[0];}
 if(move.tobiMystery){
  u.tobiSummitRound=ctx.round+1;const kills=hit.filter(v=>v.hp<=0).length;
  if(kills){u.tobiKillStacks=(u.tobiKillStacks||0)+kills;ctx.tobiQueue.push({unit:u,move:{...config.summit}});}
  frame.reactions.push(...summon(ctx,u));
 }
 if(move.tobiChase&&hit.includes(selected)){
  require('./naruto-combat').setState(selected,'immobile',ctx.round);
  const stolen=Math.min(40,ctx.chakra[1-u.camp]);ctx.chakra[1-u.camp]-=stolen;chakra(ctx,u,stolen);
  const alive=ctx.teams[1-u.camp].filter(v=>v.hp>0);
  if(alive.length){
   const splash={...move,tobiChase:false,indirect:true,multiplier:config.chaseSplashRatio,target:'all'};
   const f=require('./savas').vurus(u,alive[0],false,alive,ctx.random,true,ctx.teams[u.camp],require('./naruto-combat').attackSpec(splash,true));
   // One chase animation carries the primary strike and lineup splash. Replaying
   // the full chase once per target would multiply its animation duration.
   for(const record of f.targets){
    const existing=record.cmd===CMD.ATTACK&&frame.targets.find(r=>r.cmd===CMD.ATTACK&&r.targetCamp===record.targetCamp&&r.targetPos===record.targetPos);
    if(existing){existing.result.hurtHp=(existing.result.hurtHp||0)+(record.result.hurtHp||0);existing.result.hurtAnger=(existing.result.hurtAnger||0)+(record.result.hurtAnger||0);existing.reportTargetStatus=(existing.reportTargetStatus|record.reportTargetStatus)>>>0;}
    else frame.targets.push(record);
   }
   frame.reactions.push(...f.reactions);
  }
 }
 if(move.tobiSummit){
  for(const v of hit)require('./pain-combat').interrupt(ctx,v,frame.targets);
  frame.comboTarget=hit.filter(v=>v.hp>0).sort((a,b)=>a.hp-b.hp||a.pos-b.pos)[0]||selected;
  u.tobiArmorUntil=ctx.round;u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);chakra(ctx,u,20);
 }
}
function roundRequests(ctx){const out=[];for(const u of ctx.teams.flat())if(isTobi(u)&&u.tobiSummitRound<=ctx.round){delete u.tobiSummitRound;if(u.hp>0&&!require('./naruto-combat').disabled(u))out.push({unit:u,move:{...config.summit}});}return out;}
function triggers(ctx){return ctx.tobiQueue.splice(0).filter(r=>r.unit.hp>0&&!require('./naruto-combat').disabled(r.unit));}
function revivals(ctx){const out=[];for(const u of ctx.teams.flat()){
 if(!isTobi(u)||u.hp>0||u.noRevive||u.itachiUnrevivable)continue;
 const z=ctx.teams[u.camp].filter(v=>isZetsu(v)&&v.hp>0).sort((a,b)=>a.hp-b.hp||a.pos-b.pos)[0];if(!z)continue;
 const old=z.hp;z.hp=0;u.hp=Math.max(1,Math.round(u.maxHp*.4));require('./tsunade-combat').cleanseAll(u,[]);
 out.push({unit:u,records:[skills().hpRecord(z,old,false),skills().hpRecord(u,-u.hp,false)],animation:config.revival});
}return out;}
function endRound(ctx){const out=[];for(const z of ctx.teams.flat().filter(u=>isZetsu(u)&&u.hp>0)){const records=[];skills().restore(z,z,z.maxHp*.5,records);if(records.length)out.push({...require('./pain-combat').visual(z,{id:13121809}),targets:records});}return out;}
module.exports={config,isTobi,isZetsu,profile,prepareSummons,initialize,selectStandard,targets,prepareMove,factor,attacked,beforeDamage,afterHit,roundRequests,triggers,revivals,endRound,summon};
