'use strict';
const config=require('./hoichi.json'),{CMD,ST}=require('./kodek');
const skills=()=>require('./hero-skills'),isHoichi=u=>u?.id===config.heroId;
const active=(u,k)=>Number.isFinite(u?.[k])&&u[k]>=(u.battleRound||1);
const tagMap=new Map(require('../cikarim/veri-json/BaseHero.json').map(h=>[parseInt(h.id,16),h.tags||[]]));
const secret=u=>(u?.tags||tagMap.get(u?.id)||[]).includes(48);
const profile=u=>isHoichi(u)?{...config,chases:[]}:null;
const label=(out,u,index)=>out.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19002500+index,buffTurn:1}});
function initialize(ctx){ctx.hoichiQueue=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'hoichiContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 for(const k of Object.keys(u))if(k.startsWith('hoichi'))delete u[k];
}}
const aura=u=>u?.hoichiContext?.teams[u.camp]?.some(v=>isHoichi(v)&&v.hp>0);
const ignoreShield=u=>u?.hp>0&&secret(u)&&!!aura(u);
const cost=u=>u?.hp>0?u.hoichiCostReduction||0:0;
const acupunctured=u=>active(u,'hoichiAcupunctureUntil')||active(u,'oroAcupunctureUntil')||(u.skillBuffs||[]).some(b=>['silence','acupuncture'].includes(b.field)&&b.remaining>0);
function advanced(u){return u.advancedImmunity||require('./asura-guardian-combat').isAsura(u)||require('./naruto-final-combat').isNaruto(u)||require('./madara-infinite-combat').isMadara(u)||require('./guy-gate-combat').isGuy(u)||require('./mecha-combat').advanced(u);}
function acupuncture(ctx,u,until,records){if(!u||u.hp<=0||advanced(u)||require('./asura-guardian-combat').blocksKey(u,'acupuncture'))return false;u.hoichiAcupunctureUntil=Math.max(u.hoichiAcupunctureUntil||0,until);label(records,u,1);return true;}
function triggerExecuted(ctx,u,move,records=[]){if(!ctx||!u||!(move?.trigger||move?.tobiSummit||move?.kakuzuAdditional))return;
 if(active(u,'hoichiSealUntil'))acupuncture(ctx,u,ctx.round,records);
 if(isHoichi(u)){
  delete u.hoichiAcupunctureUntil;delete u.oroAcupunctureUntil;delete u.immobileUntil;delete u.guyImmobileUntil;
  skills().removeField(u,'silence',records);skills().removeField(u,'immobile',records);
 }
}
function evaded(ctx,u){if(!ctx||u.hp<=0)return;if(active(u,'hoichiSealUntil'))u.hoichiSealEvades=(u.hoichiSealEvades||0)+1;
 if(secret(u)&&aura(u)){u.hoichiCostReduction=Math.min(10000,(u.hoichiCostReduction||0)+10);require('./buff-notices').touch(u,'mysteryCostReduction');}
}
function mysteryExecuted(ctx,u,move){delete u.hoichiEnduranceUntil;if(isHoichi(u)&&move?.hoichiMove==='mystery')u.hoichiMysteryRound=ctx.round;}
function defend(u,damage){if(!(damage>0))return 0;if(active(u,'perseveranceUntil'))return Math.min(1,damage);return active(u,'hoichiEnduranceUntil')?Math.max(0,Math.round(damage*.55)):damage;}
function onDamage(ctx,u,result){if(!ctx||!u)return;if(u.hp<=0){u.hoichiCostReduction=0;return;}if(!isHoichi(u)||!(result.damage>0))return;
 u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);require('./buff-notices').touch(u,'mysteryCooldown');
 if(u.hp>=u.maxHp*.5||u.hoichiPillarsRound===ctx.round)return;
 u.hoichiPillarsRound=ctx.round;const first=!u.hoichiPillarsUsed;u.hoichiPillarsUsed=true;u.mysteryReadyRound=ctx.round;const records=[];
 let spent=false;if(first){
  require('./tsunade-combat').cleanseAll(u,records);
  spent=ctx.primaryActions.get(u)===ctx.round;ctx.primaryActions.delete(u);
  require('./buff-notices').touch(u,'actionsReset');
 }
 for(const ally of ctx.teams[u.camp])if(ally.hp>0){
  if(first){ally.perseveranceUntil=ctx.round;delete ally.tsunadeMeltUntil;for(const f of ['pollenPoison','pollen'])skills().removeField(ally,f,records);label(records,ally,4);}
  else{ally.hoichiEnduranceUntil=Math.max(ally.hoichiEnduranceUntil||0,ctx.round+1);label(records,ally,3);}
 }
 const visual=require('./pain-combat').visual(u,config.pillars);visual.targets.push(...records);ctx.hoichiQueue.push({frame:visual});
 if(spent)ctx.hoichiQueue.push({unit:u,standardAction:true});
}
function indirect(ctx,source,u,damage,records){damage=defend(u,damage);if(!isHoichi(u)||!ctx)return damage;
 const amount=skills().status(u,'invincible')?0:Math.min(Math.max(0,u.hp),Math.max(0,Math.round(damage)));u.hp-=amount;records.push(skills().hpRecord(u,amount,false));onDamage(ctx,u,{damage:amount});return 0;
}
function prepareMove(ctx,u,move,selected){if(!isHoichi(u)||!move?.hoichiMove)return move;
 if(move.hoichiMove==='mystery')return {...move,hoichiWasAcupuncture:acupunctured(selected)};
 if(move.hoichiMove==='barrage'){
  const alive=ctx.teams[1-u.camp].filter(v=>v.hp>0).sort((a,b)=>a.hp-b.hp||a.pos-b.pos);return {...move,hoichiLowest:alive[0]?.pos};
 }return move;
}
function targets(ctx,u,move,target,enemies){if(!isHoichi(u)||!move?.hoichiMove)return null;const alive=enemies.filter(v=>v.hp>0);
 if(move.hoichiMove==='standard'){const rows=[...new Set(alive.map(v=>Math.floor((v.pos-1)/5)))];if(!rows.length)return [];const row=rows[Math.min(rows.length-1,Math.floor(ctx.random()*rows.length))];return alive.filter(v=>Math.floor((v.pos-1)/5)===row).sort((a,b)=>a.pos-b.pos);}
 if(move.hoichiMove==='barrage')return alive.sort((a,b)=>a.hp-b.hp||a.pos-b.pos).slice(0,9);
 return [target,...alive.filter(v=>v!==target)].filter(v=>v?.hp>0).slice(0,move.target||1);
}
function afterHit(ctx,u,selected,hit,move,frame){triggerExecuted(ctx,u,move,frame.targets);if(!isHoichi(u)||!move?.hoichiMove)return;
 if(move.hoichiMove==='mystery'&&hit.includes(selected)&&selected.hp>0){
  if(acupuncture(ctx,selected,ctx.round+1,frame.targets)&&move.hoichiWasAcupuncture){selected.hoichiSealUntil=ctx.round+1;selected.hoichiSealEvades=0;selected.hoichiSealSource=u.id;selected.hoichiSealCamp=u.camp;label(frame.targets,selected,2);}
 }
 if(move.hoichiMove==='standard'){
  for(const v of hit){if(v.hp>0&&!advanced(v)){v.suppressedUntil=ctx.round;label(frame.targets,v,5);}const amount=Math.min(20,ctx.chakra[v.camp]);ctx.chakra[v.camp]-=amount;ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]??100,ctx.chakra[u.camp]+amount);}
  const candidates=hit.filter(v=>v.hp>0);if(candidates.length&&ctx.random()<config.standardAcupunctureChance)acupuncture(ctx,candidates[Math.min(candidates.length-1,Math.floor(ctx.random()*candidates.length))],ctx.round,frame.targets);
 }
 if(move.hoichiMove==='barrage'){
  for(const v of hit){skills().remove(v,false,frame.targets);if(v.shield>0){v.shield=0;frame.targets.push({cmd:CMD.SHIELD,targetCamp:v.camp,targetPos:v.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});}}
  const lowest=hit.find(v=>v.pos===move.hoichiLowest)||hit.slice().sort((a,b)=>a.hp-b.hp||a.pos-b.pos)[0];if(lowest)acupuncture(ctx,lowest,ctx.round+1,frame.targets);
 }
}
function endRequests(ctx){const out=[];for(const u of ctx.teams.flat())if(isHoichi(u)&&u.hp>0&&u.hoichiMysteryRound===ctx.round&&u.hoichiBarrageRound!==ctx.round){u.hoichiBarrageRound=ctx.round;out.push({unit:u,move:config.barrage});}return out;}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat()){
 if(u.hp<=0){u.hoichiCostReduction=0;continue;}
 if(active(u,'hoichiSealUntil')&&u.hoichiSealEvades>0){const records=[],source=ctx.teams.flat().find(v=>v.id===u.hoichiSealSource&&v.camp===u.hoichiSealCamp)||u;for(let i=0;i<u.hoichiSealEvades&&u.hp>0&&active(u,'hoichiSealUntil');i++){
  const amount=Math.min(25000,Math.round(u.hp*.08));let damage=require('./guy-gate-combat').indirect(ctx,source,u,amount,records);u.hp-=damage;if(damage>0)records.push(skills().hpRecord(u,damage,false));
 }if(records.length)out.push(require('./pain-combat').passive(source,records));}u.hoichiSealEvades=0;
 }return out;
}
function noteDeaths(ctx){for(const u of ctx.teams.flat())if(u.hp<=0)u.hoichiCostReduction=0;}
function triggers(ctx){return ctx.hoichiQueue.splice(0).filter(r=>r.frame||r.unit.hp>0);}
module.exports={config,isHoichi,profile,initialize,active,secret,aura,ignoreShield,cost,acupunctured,acupuncture,triggerExecuted,evaded,mysteryExecuted,defend,onDamage,indirect,prepareMove,targets,afterHit,endRequests,endRound,noteDeaths,triggers,label};
