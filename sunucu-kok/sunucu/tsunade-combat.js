'use strict';
const config=require('./tsunade-asian.json'),{CMD,ST,ACTIVE}=require('./kodek');
const skills=()=>require('./hero-skills');
const isTsunade=u=>u?.id===config.heroId;
const active=(u,k)=>Number.isFinite(u?.[k])&&u[k]>=Number(u.battleRound||1);
const label=(r,u,n,v=1)=>r.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19001700+n,buffTurn:v}});
const passive=(u,r)=>require('./pain-combat').passive(u,r);
const profile=u=>isTsunade(u)?config:u?.tsunadeSmall?{heroId:u.id,standard:{id:13121609,name:'Small Katsuyu - Healing',support:true,multiplier:0,cooldown:0,tsunadeSmallHeal:true},chases:[]}:null;
const tagMap=new Map(require('../cikarim/veri-json/BaseHero.json').map(h=>[parseInt(h.id,16),h.tags||[]]));
function konoha(u){return (u.tags||tagMap.get(u.id)||[]).includes(1);}
function prepareSummons(teams){for(const team of teams)for(const owner of [...team].filter(isTsunade)){
 for(let i=team.filter(u=>u.tsunadeOwner===owner).length;i<config.smallKatsuyuCount;i++){
  const pos=Array.from({length:15},(_,n)=>n+1).find(p=>!team.some(u=>u.pos===p));if(!pos)break;
  const hp=Math.max(1,Math.round(owner.maxHp*config.smallKatsuyuHpRatio));
  team.push({id:11120993,isim:'Small Katsuyu',pos,camp:owner.camp,hp:0,maxHp:hp,level:owner.level||1,quality:7,profession:1,
   atk:0,magicAtk:0,def:owner.def||0,resistance:owner.resistance||0,speed:owner.speed||0,normal:13121609,skill:0,skillId:13121609,
   anger:0,verdi:0,hitRate:1,tsunadeSmall:true,tsunadeOwner:owner,auxiliary:true,partnerSkills:[],weaponSkills:[]});
 }
}}
function initialize(ctx){ctx.tsunadeExtra=[];for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'tsunadeContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 for(const k of Object.keys(u))if(k.startsWith('tsunade')&&!['tsunadeContext','tsunadeSmall','tsunadeOwner','tsunadeMysteryTargetCamp'].includes(k))delete u[k];
 if(isTsunade(u)){u.tsunadeRevived=false;}
}}
function roundStart(ctx){ctx.tsunadeExtra=[];for(const u of ctx.teams.flat())if(isTsunade(u)){u.tsunadeExtraGranted=0;u.tsunadeExtras=0;}}
function receiveExtra(ctx,unit,count=1){if(!ctx||!konoha(unit))return;for(const u of ctx.teams[unit.camp]){
 if(!isTsunade(u)||u.hp<=0)continue;
 const grant=Math.max(0,Math.min(count,config.extraStandardCap-(u.tsunadeExtraGranted||0)));
 u.tsunadeExtraGranted=(u.tsunadeExtraGranted||0)+grant;u.tsunadeExtras=(u.tsunadeExtras||0)+grant;
 if(grant&&!ctx.tsunadeExtra.includes(u))ctx.tsunadeExtra.push(u);
}}
function beforeDamage(ctx,actor,target,move,damage){
 if(!(damage>0)||target.hp<=0)return damage;
 if((move?.prompt||move?.activeType===ACTIVE.SKILL)&&konoha(target)&&target.tsunadeProtectedRound!==ctx.round&&ctx.teams[target.camp].some(u=>u!==target&&isTsunade(u)&&u.hp>0)){
  target.tsunadeProtectedRound=ctx.round;return Math.min(damage,Math.max(0,target.hp-1));
 }return damage;
}
function debuff(ctx,source,target,field,records,until=ctx.round){
 if(target.hp<=0||skills().status(target,'immuneDebuffs'))return false;
 target[field]=Math.max(target[field]||0,until);return true;
}
function beforeAttack(ctx,actor,target,records){
 if(actor&&actor!==target&&target.hp>0&&active(target,'tsunadeMeltUntil')&&!active(actor,'tsunadeMeltCritUntil')){actor.tsunadeMeltCritUntil=ctx.round;label(records,actor,4,30);}
}
function onDamage(ctx,actor,target,result,move,records){
 if(!(result.damage>0))return;
 if(actor&&active(actor,'tsunadeCorrosionUntil')){
  if(actor.tsunadeCorrosionRound!==ctx.round){actor.tsunadeCorrosionRound=ctx.round;actor.tsunadeCorrosionStacks=0;}
  actor.tsunadeCorrosionStacks=(actor.tsunadeCorrosionStacks||0)+1;label(records,actor,3,actor.tsunadeCorrosionStacks*3);
 }
 if(isTsunade(target)&&actor&&actor.camp!==target.camp&&move?.kind!=='dot'&&!move?.indirect&&(move?.damageType==='physical'||!move)&&ctx.random()<(target.tsunadeRevived?config.revivedRetaliationChance:config.retaliationChance)){
  if(debuff(ctx,target,actor,'tsunadeWeakUntil',records)){
   if(!skills().status(actor,'immuneControl')&&!(actor.shield>0)){
    actor.skillBuffs||=[];const old=actor.skillBuffs.find(b=>b.tsunadeChaos);
    if(old)old.remaining=Math.max(old.remaining,1);else actor.skillBuffs.push({field:'chaos',value:1,remaining:1,source:target.id,tsunadeChaos:true});
   }label(records,actor,5);
  }
 }
 if(target.tsunadeSmall&&target.hp<=0&&!target.tsunadeFatalHealed){target.tsunadeFatalHealed=true;smallHeal(ctx,target,records);}
}
function factor(u,field){if(['def','resistance'].includes(field)&&u.tsunadeCorrosionRound===u.battleRound)return Math.max(0,1-.03*(u.tsunadeCorrosionStacks||0));return 1;}
function critical(u){return active(u,'tsunadeMeltCritUntil')?.3:0;}
function gainChakra(ctx,u,amount,reason='skill'){
 if(active(u,'tsunadeMeltUntil')&&!['round','attacked'].includes(reason))return 0;
 const old=ctx.chakra[u.camp];ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]??100,old+Math.max(0,amount));return ctx.chakra[u.camp]-old;
}
function cleanseOne(u,records){
 if(skills().removeOneDebuff(u,records))return;
 for(const k of negativeTimers)if(active(u,k)){delete u[k];if(k==='itachiParalyzedUntil')u.paralyzed=false;return;}
}
const negativeTimers=['suppressedUntil','extremeChaosUntil','immobileUntil','armorSuppressedUntil','immunitySuppressedUntil','tsunadeMeltUntil','tsunadeCorrosionUntil','tsunadeWeakUntil','sasukeBlazeUntil','sasukeIgnitionUntil','sasukeParalysisUntil','sasukeFearUntil','sasukeElectrocutionUntil','sasukeDisorderUntil','sasukeStaticUntil','gaaraBlindUntil','gaaraCritLossUntil','gaaraDiscourageUntil','gaaraRagingUntil','painAfflictionUntil','painDisruptionUntil','painHorrorUntil','painInterruptedUntil','painChakraLimitUntil','hashWeakUntil','hashEnfeebleUntil','hashRootUntil','hashSealUntil','obitoTagUntil','itachiParalyzedUntil','mechaMysteryLockUntil'];
function cleanseAll(u,records){skills().remove(u,true,records);for(const k of negativeTimers)delete u[k];delete u.tsunadeCorrosionStacks;}
function heal(ctx,u,giant,records){
 const allies=ctx.teams[u.camp].filter(t=>t.hp>0).sort((a,b)=>a.hp/a.maxHp-b.hp/b.maxHp||a.pos-b.pos);
 const limit=giant?9:u.tsunadeRevived?7+Math.min(2,Math.floor(ctx.random()*3)):3+Math.min(2,Math.floor(ctx.random()*3));
 const amount=skills().value(u,config.healingStat)*(giant?config.giantHealRatio:config.standardHealRatio);
 for(const t of allies.slice(0,limit)){
  if(giant)cleanseAll(t,records);else cleanseOne(t,records);
  skills().restore(u,t,amount,records);
 }
 if(giant){skills().removeField(u,'ignite',records);delete u.sasukeIgnitionUntil;}
}
function smallHeal(ctx,u,records){
 const owner=u.tsunadeOwner,allies=ctx.teams[u.camp].filter(t=>t.hp>0&&!t.auxiliary);if(!allies.length||!owner)return;
 const target=allies[Math.min(allies.length-1,Math.floor(ctx.random()*allies.length))];
 skills().restore(owner,target,skills().value(owner,config.healingStat)*config.smallKatsuyuHealRatio,records);
 ctx.chakraLimit[u.camp]=100;label(records,target,7,100);
}
function beforeMystery(ctx,u,move){
 if(!isTsunade(u)||u.hp<=0||!move?.prompt)return [];
 const frames=[];
 if(u.tsunadeRevived){const records=[];
  for(const slug of ctx.teams[u.camp].filter(t=>t.tsunadeOwner===u)){
   const before=slug.hp;slug.hp=slug.maxHp;slug.tsunadeFatalHealed=false;slug.tsunadeSpawned=true;
   records.push(skills().hpRecord(slug,before-slug.hp,false));
  }
  frames.push({...require('./pain-combat').visual(u,config.summoning),targets:records.length?records:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}}]});
 }
 return frames;
}
function selectMystery(u,move){
 if(!isTsunade(u)||!u.tsunadeRevived)return move;
 const allies=u.tsunadeContext?.teams[u.camp]||[];
 const selectedAlly=u.tsunadeMysteryTargetCamp===u.camp;
 const autoAlly=u.tsunadeMysteryTargetCamp==null&&allies.some(t=>t.hp>0&&!t.auxiliary&&t.hp<t.maxHp*.75);
 return selectedAlly||autoAlly?{...config.healingMystery}:move;
}
function afterHit(ctx,u,selected,hit,move,frame){
 const records=[];
 if(move.tsunadeHeal)heal(ctx,u,false,records);
 if(move.tsunadeGiantHeal)heal(ctx,u,true,records);
 if(move.tsunadeSmallHeal)smallHeal(ctx,u,records);
 if(move.tsunadeAcid)for(const t of hit){
  if(t.hp<=0)continue;
  t.suppressedUntil=ctx.round+1;label(records,t,1);
  if(debuff(ctx,u,t,'tsunadeCorrosionUntil',records,ctx.round))label(records,t,2);
  if(debuff(ctx,u,t,'tsunadeMeltUntil',records,ctx.round+1)){delete t.perseveranceUntil;delete t.perseverance;label(records,t,4);}
 }
 frame.targets.push(...records);
}
function revivals(ctx){const out=[];for(const u of ctx.teams.flat()){
 if(!isTsunade(u)||u.hp>0||u.tsunadeRevived||u.itachiUnrevivable)continue;
 u.tsunadeRevived=true;u.hp=Math.max(1,u.maxHp);const records=[];cleanseAll(u,records);
 records.push(skills().hpRecord(u,-u.hp,false));label(records,u,6,100);
 out.push({unit:u,records,animation:config.revival});
}return out;}
function endRound(ctx){const out=[];if(ctx.round<1||ctx.round>3)return out;for(const u of ctx.teams.flat())if(isTsunade(u)&&u.hp>0&&!u.tsunadeRevived){
 const records=[];heal(ctx,u,true,records);out.push({...require('./pain-combat').visual(u,config.healing),targets:records});
}return out;}
function triggers(ctx){const result=[];for(const u of ctx.tsunadeExtra.splice(0)){
 if(u.hp>0&&(require('./naruto-combat').disabled(u)||skills().status(u,'disarm'))){ctx.tsunadeExtra.push(u);continue;}
 while(u.hp>0&&!require('./naruto-combat').disabled(u)&&!skills().status(u,'disarm')&&u.tsunadeExtras>0){u.tsunadeExtras--;result.push({unit:u,move:{...config.standard,trigger:true}});}
}return result;}
function fatalSummons(ctx){const frames=[];for(const u of ctx.teams.flat())if(u.tsunadeSmall&&u.hp<=0&&!u.tsunadeFatalHealed&&u.tsunadeSpawned){
 u.tsunadeFatalHealed=true;const records=[];smallHeal(ctx,u,records);if(records.length)frames.push(passive(u,records));
}return frames;}
module.exports={config,isTsunade,profile,konoha,prepareSummons,initialize,roundStart,receiveExtra,beforeDamage,beforeAttack,onDamage,factor,critical,gainChakra,cleanseOne,cleanseAll,heal,smallHeal,beforeMystery,selectMystery,afterHit,revivals,endRound,triggers,fatalSummons,active};
