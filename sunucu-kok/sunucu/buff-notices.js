'use strict';
// Observe real effective increases; never change stats, RNG or action budgets.
const config=require('./buff-notices.json'),{CMD,ST}=require('./kodek');
const fields=[...Object.keys(config.stats),...Object.keys(config.states)];
const ids=Object.fromEntries(fields.map((key,i)=>[key,config.baseId+i+1]));
const touches=new WeakMap();
function touch(unit,field){if(!ids[field])return;if(!touches.has(unit))touches.set(unit,new Set());touches.get(unit).add(field);}
function active(u,key){return Number.isFinite(u[key])&&u[key]>=(u.battleRound||1)?u[key]:0;}
function snapshot(u){
 const skills=require('./hero-skills'),values={},raw={};
 const core=new Set(['atk','magicAtk','def','resistance','speed','critRate']);
 const buffFields=new Set((u.skillBuffs||[]).filter(b=>b.remaining>0).map(b=>b.field));
 for(const field of Object.keys(config.stats)){raw[field]=Number(u[field])||0;values[field]=core.has(field)||raw[field]||buffFields.has(field)?Number(skills.value(u,field))||0:0;}
 for(const field of ['immuneDebuffs','immuneControl','invincible','reflect','immuneHealBlock'])values[field]=Number(skills.status(u,field));
 values.superArmor=Number(skills.armor(u));values.shield=Math.max(0,u.shield||0);
 values.regeneration=(u.skillBuffs||[]).filter(b=>b.kind==='regen'&&b.remaining>0).reduce((sum,b)=>sum+Math.max(0,b.amount||b.value||0),0);
 values.standardDamage=active(u,'nfFriendshipUntil')?(u.nfFriendshipStacks||0):0;
 values.chaseDamage=(u.madaraChaseStacks||0);values.triggerDamage=(u.minatoCounterStacks||0);
 values.extraStandard=(u.mechaExtra||0)+(u.hashExtra||0)+(u.tsunadeExtras||0)+(u.nfExtras||0)+(u.nfExtraGranted||0)+(u.nfReflexRound===u.battleRound?u.nfReflexGranted||0:0)+(u.obitoKillCredits||0);
 values.chaseBonus=(u.nfContext?.chaseBonus?.[u.camp]||0);
 values.freeMystery=active(u,'madaraFreeUntil');values.interruptImmune=active(u,'painInterruptImmuneUntil');
 values.madaraBurst=active(u,'madaraBurstUntil');values.hashBurst=active(u,'hashBurstUntil');values.excited=active(u,'hashExcitedUntil');
 values.mechaBeast=Number(!!u.mechaBeast);values.minatoProwess=Number(!!u.minatoProwess);
 values.armor2=Math.max(active(u,'gaaraArmor2Until'),active(u,'tobiArmorUntil'),active(u,'madaraBurstUntil'));
 values.advancedImmunity=active(u,'mechaAdvancedUntil');values.explosive=active(u,'hashExplosiveUntil');
 values.triggerEvasion=active(u,'minatoTriggerEvadeUntil');values.unavoidable=active(u,'painUnavoidableUntil');values.hiding=active(u,'itachiHidingUntil');
 values.mysteryCostReduction=(u.mechaCostReduction||0)+(u.tobiCostRound===u.battleRound?u.tobiCostReduction||0:0);
 values.mysteryCooldown=Number.isFinite(u.mysteryReadyRound)?-u.mysteryReadyRound:0;
 values.chakraLimit=u.nfContext?.chakraLimit?.[u.camp]??100;
 const beasts=['Shukaku','Matatabi','Isobu','Son Goku','Kokuo','Saiken','Chomei','Gyuki','Kurama'];
 for(const beast of beasts)values[beast==='Son Goku'?'sonGoku':beast.toLowerCase()]=active(u,'nfResonanceUntil')&&(u.nfResonances||[]).includes(beast)?u.nfResonanceUntil:0;
 // Reapplications of ordinary timed buffs count too, even at the same strength.
 const stamps={};for(const buff of u.skillBuffs||[])if(buff.remaining>0&&buff.value>=0&&buff.kind!=='dot'&&ids[buff.field]){
  const key=buff.field+'|'+buff.source+'|'+buff.sourceSkill;stamps[key]={field:buff.field,remaining:buff.remaining,value:buff.value};
 }
 return {values,stamps,raw};
}
function initialize(ctx){ctx.buffNoticeState=new Map(ctx.teams.flat().map(u=>[u,snapshot(u)]));for(const u of ctx.teams.flat())touches.delete(u);}
function collect(ctx){if(!ctx.buffNoticeState)initialize(ctx);const out=[];
 for(const u of ctx.teams.flat()){
  const before=ctx.buffNoticeState.get(u)||{values:{},stamps:{}},after=snapshot(u),changed=new Set(touches.get(u)||[]);touches.delete(u);
  for(const [field,value] of Object.entries(after.values))if(value>(before.values[field]||0)+1e-8){
   if(field in config.stats&&value<=Math.max(0,Number(u[field])||0)+1e-8&&after.raw[field]<=(before.raw?.[field]||0))continue;
   changed.add(field);
  }
  for(const [key,buff] of Object.entries(after.stamps)){const old=before.stamps[key];if(!old||buff.remaining>old.remaining||buff.value>old.value)changed.add(buff.field);}
  ctx.buffNoticeState.set(u,after);
  if(u.hp<=0||!changed.size)continue;
  const records=[...changed].filter(field=>ids[field]).map(field=>({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:ids[field],buffTurn:0}}));
  if(records.length)out.push({activeCamp:u.camp,activePos:u.pos,activeType:4,skillEffectId:0,targets:records});
 }return out;
}
module.exports={config,ids,fields,touch,snapshot,initialize,collect};
