'use strict';
const config=require('./naruto-nine-tails.json'),{CMD,ST}=require('./kodek');
const skills=()=>require('./hero-skills'),isNaruto=u=>u?.id===config.heroId;
const profile=u=>isNaruto(u)?config:null;
function targets(move,opponents){
 if(!move?.ntcStandard)return null;
 const alive=opponents.filter(v=>v.hp>0),row=Math.min(...alive.map(v=>Math.floor((v.pos-1)/5)));
 return alive.filter(v=>Math.floor((v.pos-1)/5)===row);
}
function selectStandard(ctx,u,move){return isNaruto(u)?{...(ctx.random()<config.comboChance?config.comboStandard:config.standard)}:move;}
function damage(source,target,multiplier){
 const s=skills(),clamp=v=>Math.max(0,Math.min(1,v)),atk=s.value(source,'atk'),def=s.value(target,'def')*(1-clamp(s.value(source,'ignoreDefense')));
 return Math.max(0,Math.round(atk*multiplier*atk/Math.max(1,atk+def)*Math.max(0,1+s.value(source,'damageBonus'))*(1-clamp(s.value(target,'damageReduction')))*Math.max(0,1+s.value(target,'vulnerability'))));
}
function ignite(ctx,source,target,records){if(require('./asura-guardian-combat').immuneStatus(target,'ignition'))return;
 if(!target||target.hp<=0||skills().status(target,'immuneDebuffs')||require('./hashirama-combat').fireImmune(target,{element:'fire'},null))return;
 target.skillBuffs||=[];
 const buff={kind:'dot',field:'ignite',buffId:13500022,ntcIgnition:true,element:'fire',level:1,remaining:1,source:source.id,sourceCamp:source.camp,sourcePos:source.pos,attackStat:'atk',damageType:'physical',amount:damage(source,target,config.ignitionMultiplier)};
 const old=target.skillBuffs.find(b=>b.ntcIgnition&&b.source===source.id&&b.sourceCamp===source.camp&&b.sourcePos===source.pos);
 if(old)Object.assign(old,buff);else target.skillBuffs.push(buff);
 records.push({cmd:CMD.ATTRBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:13500022,buffTurn:1}});
 records.push({cmd:CMD.FLOAT,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19001801,buffTurn:1}});
}
function onDamage(ctx,actor,target,result,move,records){
 if(isNaruto(target)&&actor&&actor!==target&&actor.camp!==target.camp&&result.damage>0&&move?.kind!=='dot'&&!move?.indirect&&(!move?actor.profession!==3:move.damageType==='physical'))ignite(ctx,target,actor,records);
}
function afterHit(ctx,u,selected,hit,move,frame){
 if(!isNaruto(u))return;
 if(move.ntcMystery||move.ntcIgnition)for(const victim of hit)ignite(ctx,u,victim,frame.targets);
 if(move.ntcMystery&&hit.includes(selected)&&require('./naruto-combat').setState(selected,'repulse',ctx.round)){
  const row=Math.floor((selected.pos-1)/5)+1;if(row>2)return;
  for(const victim of ctx.teams[1-u.camp].filter(v=>v.hp>0&&Math.floor((v.pos-1)/5)===row)){
   const splash={id:config.mystery.id,target:1,attackStat:'atk',damageType:'physical',multiplier:config.splashMultiplier,indirect:true};
   const extra=require('./savas').vurus(u,victim,false,[victim],ctx.random,true,ctx.teams[u.camp],require('./naruto-combat').attackSpec(splash,true));
   frame.targets.push(...extra.targets);frame.reactions.push(...extra.reactions);
  }
 }
}
function roundStart(ctx){const out=[];for(const u of ctx.teams.flat())if(isNaruto(u)&&u.hp>0){
 const records=[];skills().restore(u,u,skills().value(u,'atk')*config.healRatio,records);
 out.push({...require('./pain-combat').visual(u,config.healing),targets:records});
}return out;}
function endRound(ctx){const out=[];for(const unit of ctx.teams.flat()){
 const records=[];
 for(const buff of (unit.skillBuffs||[]).filter(b=>b.ntcIgnition&&b.remaining>0)){
  if(unit.hp<=0||skills().status(unit,'invincible')||require('./hashirama-combat').fireImmune(unit,buff,null))continue;
  const source=ctx.teams[buff.sourceCamp].find(v=>v.id===buff.source&&v.pos===buff.sourcePos);
  const amount=Math.min(unit.hp,source?damage(source,unit,config.ignitionMultiplier):buff.amount);unit.hp-=amount;records.push(skills().hpRecord(unit,amount,false));
  require('./tsunade-combat').onDamage(ctx,source,unit,{damage:amount},buff,records);
  require('./gaara-combat').onDamage(ctx,source,unit,{damage:amount},false,records);
 }
 out.push(...skills().eventFrames(unit,records));
}return out;}
module.exports={config,isNaruto,profile,targets,selectStandard,damage,ignite,onDamage,afterHit,roundStart,endRound};
