'use strict';
const config=require('./naruto-final.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isNaruto=u=>u?.id===config.heroId;
const active=(u,key)=>Number.isFinite(u?.[key])&&u[key]>=(u.battleRound||1);
const tags=u=>require('./statlar').heroById.get(u?.id)?.tags||[];
const jinchuriki=u=>tags(u).includes(13);
const trigger=m=>!!(m?.trigger||m?.kakuzuAdditional||m?.tobiSummit||m?.madaraMove==='complete');
function initialize(ctx){ctx.nfQueue=[];for(const u of ctx.teams.flat()){
 for(const key of Object.keys(u))if(key.startsWith('nf'))delete u[key];
 Object.defineProperty(u,'nfContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isNaruto(u)){u.nfStage=0;u.nfAttackStacks=0;u.nfFinalReady=1;u.nfResonances=[];}
}}
function battleStart(ctx){for(const team of ctx.teams){const owner=team.find(u=>isNaruto(u)&&u.hp>0);if(!owner)continue;
 for(const u of team){if(u.nfKuramaCloak)continue;u.nfKuramaCloak=true;u.skillBuffs||=[];
  for(const [field,value] of [['atk',config.kuramaCloak.attackBonus],['def',config.kuramaCloak.defenseBonus],['speed',config.kuramaCloak.speedBonus],['leechRate',config.kuramaCloak.lifesteal]])u.skillBuffs.push({field,value,kind:'buff',remaining:1000000,source:owner.id,sourceSkill:13221006,nfKuramaCloak:true});
 }
}return [];}
function reset(ctx,u){if(u.nfRound!==ctx.round){u.nfRound=ctx.round;u.nfMysteries=0;u.nfStandardUsed=false;u.nfExtras=0;u.nfExtraGranted=0;u.nfFirstMystery=false;u.nfFirstTrigger=false;}}
function profile(u){if(!isNaruto(u))return null;return {...config,mystery:u.nfStage>=9?config.finalMystery:config['bond'+((u.nfStage||0)+1)]};}
function resonant(u,name){return active(u,'nfResonanceUntil')&&(u.nfResonances||[]).includes(name);}
function queue(ctx,u,move,extra={}){if(u.hp>0)ctx.nfQueue.push({unit:u,move,...extra});}
function canMystery(ctx,u){if(blocksMystery(u))return false;if(!isNaruto(u))return true;reset(ctx,u);return u.nfMysteries<config.maxMysteriesPerRound&&(u.nfStage<9||ctx.round>=u.nfFinalReady);}
function mysterySpent(ctx,u,move){if(!isNaruto(u))return;reset(ctx,u);u.nfMysteries++;u.nfAttackStacks++;
 if(move.nfMove.startsWith('bond'))u.mysteryReadyRound=ctx.round;
 else u.nfFinalReady=ctx.round+2;
}
function available(ctx,u){if(!isNaruto(u))return false;reset(ctx,u);return !u.nfStandardUsed||u.nfExtras>0;}
function spendStandard(ctx,u){if(!isNaruto(u))return;reset(ctx,u);if(u.nfStandardUsed)u.nfExtras--;u.nfStandardUsed=true;}
function loseStandards(ctx,u,count){if(!isNaruto(u))return false;reset(ctx,u);if(!u.nfStandardUsed&&count>0){u.nfStandardUsed=true;count--;ctx.primaryActions.set(u,ctx.round);}const taken=Math.min(count,u.nfExtras);u.nfExtras-=taken;return true;}
function extra(ctx,u){reset(ctx,u);if(u.nfExtraGranted>=config.maxExtraStandardsPerRound)return;u.nfExtraGranted++;u.nfExtras++;require('./tsunade-combat').receiveExtra(ctx,u);}
function selectStandard(ctx,u,move){if(!isNaruto(u))return move;return [config.standard,config.tail,config.bomb][Math.min(2,Math.floor(ctx.random()*3))];}
function factor(u,field){let value=isNaruto(u)&&field==='atk'?1+.12*(u.nfAttackStacks||0):1;
 return value;
}
function blocksBuff(u){return active(u,'nfDiscourageUntil');}
function onDamage(ctx,attacker,target,result,move){if(!attacker||attacker.hp<=0||!(result.damage>0)||!active(target,'nfSlowReflexUntil')||move&&move.damageType!=='physical')return;
 if(attacker.nfReflexRound!==ctx.round){attacker.nfReflexRound=ctx.round;attacker.nfReflexGranted=0;}
 if(attacker.nfReflexGranted<5&&ctx.random()<.6){attacker.nfReflexGranted++;ctx.nfQueue.push({unit:attacker,standardAction:true,granted:true});}
}
function outgoing(u,move){let value=active(u,'nfHaremUntil')?.4:1;if(!move?.prompt&&!move?.chase&&!trigger(move)&&active(u,'nfFriendshipUntil'))value*=1+.15*(u.nfFriendshipStacks||0);return value;}
function standardGuaranteed(u){return jinchuriki(u)&&active(u,'nfFriendshipUntil');}
function blocksMystery(u){return active(u,'nfMagnetUntil')||active(u,'nfMagnetSpecialUntil');}
function blocksAdditional(u,move){return !jinchuriki(u)&&blocksMystery(u)&&!!(move?.additional||trigger(move)&&!move?.support);}
function blocksDeath(u){return !!u?.nfDeathBlocked||!jinchuriki(u)&&blocksMystery(u);}
function noteDeaths(ctx){for(const u of ctx.teams.flat()){if(u.hp>0)delete u.nfDeathBlocked;else if(!jinchuriki(u)&&blocksMystery(u))u.nfDeathBlocked=true;}}
function cleanseBlind(u,records){delete u.nfBlindUntil;delete u.gaaraBlindUntil;skills.removeField(u,'disarm',records);skills.removeField(u,'blind',records);}
function resetActions(ctx,u,enqueue){const spent=u.nfStandardUsed||ctx.primaryActions.get(u)===ctx.round;ctx.primaryActions.delete(u);ctx.skillReady.get(u)?.delete('standard');ctx.used.delete(u);u.nfStandardUsed=false;u.nfExtras=0;require('./buff-notices').touch(u,'actionsReset');if(enqueue&&spent)ctx.nfQueue.push({unit:u,standardAction:true});}
function debuff(ctx,u,key,until=ctx.round,special=false){if(!special&&require('./asura-guardian-combat').blocksKey(u,key))return false;if(u.hp<=0||!special&&skills.status(u,'immuneDebuffs'))return false;u[key]=Math.max(u[key]||0,until);return true;}
function prepareMove(ctx,u,move,selected){if(!move)return move;
 if(!move.prompt&&!move.chase&&!trigger(move)&&standardGuaranteed(u))move={...move,unavoidable:true};
 if(!move.nfMove)return move;
 if(move.nfMove==='final'&&(tags(selected).includes(54)||require('./statlar').heroById.get(selected?.id)?.sex===2))return {...config.harem,nfPaidFinal:true};
 if(move.nfMove==='final'&&ctx.teams[1-u.camp].filter(v=>v.hp>0).length===1)move={...move,multiplier:move.multiplier*2};
 if(move.nfMove==='chase'&&resonant(u,'Shukaku'))move={...move,ignoreDefense:.2,nfSpecialMagnet:true};
 return move;
}
function targets(ctx,u,move,selected,enemies){if(!move?.nfMove)return null;if(move.support)return [];
 return move.target==='all'?enemies.filter(v=>v.hp>0):[selected].filter(v=>v?.hp>0);
}
function onAttacked(ctx,attacker,victims,move){if(!victims.length||move?.support)return;
 for(const camp of new Set(victims.filter(v=>v.hp>0&&v.camp!==attacker.camp).map(v=>v.camp))){
 if(!ctx.teams[camp].some(v=>isNaruto(v)&&v.hp>0))continue;
 for(const v of ctx.teams[camp])if(v.hp>0){delete v.sasukeFearUntil;skills.removeField(v,'fear',[]);if(blocksBuff(v))continue;if(!active(v,'nfFriendshipUntil'))v.nfFriendshipStacks=0;v.nfFriendshipStacks=Math.min(config.maxFriendshipStacks,(v.nfFriendshipStacks||0)+1);v.nfFriendshipUntil=ctx.round;}
 }}
function observe(ctx,u,move){if(!move)return;if(move.prompt)delete u.nfDiscourageUntil;for(const owner of ctx.teams[u.camp].filter(v=>isNaruto(v)&&v.hp>0)){
 reset(ctx,owner);
 if(move.prompt&&!owner.nfFirstMystery){owner.nfFirstMystery=true;queue(ctx,owner,config.additional);}
 if(trigger(move)&&move.nfMove!=='additional'&&!owner.nfFirstTrigger){owner.nfFirstTrigger=true;queue(ctx,owner,config.additional);}
}}
function afterHit(ctx,u,selected,hit,move,frame){if(!move)return;observe(ctx,u,move);if(!move.nfMove)return;const key=move.nfMove;
 if(key.startsWith('bond')){
  u.nfStage=Math.min(9,u.nfStage+1);u.nfResonanceUntil=ctx.round;u.nfResonances||=[];if(!u.nfResonances.includes(move.resonance))u.nfResonances.push(move.resonance);
  cleanseBlind(u,frame.targets);
  if(move.resonance==='Kokuo'){require('./tsunade-combat').cleanseAll(u,frame.targets);u.nfRestoreRound=ctx.round;queue(ctx,u,config.recovery);}
 }
 if(key==='recovery'){const healed=[];skills.restore(u,u,u.maxHp*config.recovery.healRatio,healed);if(healed.length)frame.reactions.push(pain.passive(u,healed));resetActions(ctx,u,true);}
 if(key==='restoration'){require('./tsunade-combat').cleanseAll(u,frame.targets);const healed=[];skills.restore(u,u,u.maxHp*config.restoration.healRatio,healed);if(healed.length)frame.reactions.push(pain.passive(u,healed));resetActions(ctx,u,false);u.nfStage=0;u.nfResonances=[];u.nfResonanceUntil=0;u.mysteryReadyRound=ctx.round+1;}
 if(key==='final'&&selected?.hp>0)debuff(ctx,selected,'nfWeakUntil');
 if(key==='harem'&&selected?.hp>0){frame.targets.push(skills.hpRecord(selected,0));pain.interrupt(ctx,selected,frame.targets);debuff(ctx,selected,'nfHaremUntil');}
 if(key==='chase'&&selected?.hp>0)debuff(ctx,selected,move.nfSpecialMagnet?'nfMagnetSpecialUntil':'nfMagnetUntil',ctx.round,!!move.nfSpecialMagnet);
 if(key==='additional')for(const v of hit){pain.interrupt(ctx,v,frame.targets);v.armorSuppressedUntil=ctx.round;}
 if(['claw','tail','bomb'].includes(key)){
  for(const v of hit){
   if(v.hp<=0)continue;
   v.suppressedUntil=ctx.round+1;
   if(resonant(u,'Shukaku'))debuff(ctx,v,'nfSlowReflexUntil');
   if(resonant(u,'Matatabi')&&debuff(ctx,v,'madaraIgnitionUntil',ctx.round+1))v.madaraIgnitionSource=u;
   if(resonant(u,'Isobu'))debuff(ctx,v,'nfDiscourageUntil',ctx.round+1);
   if(resonant(u,'Son Goku')&&debuff(ctx,v,'madaraInfernoUntil',ctx.round+1)){v.madaraInfernoSource=u;v.madaraInfernoStacks=0;}
   if(resonant(u,'Kokuo'))debuff(ctx,v,'madaraShatterUntil');
   if(resonant(u,'Saiken')){if(debuff(ctx,v,'tsunadeMeltUntil')){delete v.perseverance;delete v.perseveranceUntil;}}
   if(resonant(u,'Chomei'))debuff(ctx,v,'nfBlindUntil');
   if(resonant(u,'Gyuki')&&!skills.armor(v)&&!skills.status(v,'immuneControl'))debuff(ctx,v,'nfInkUntil');
  }
  if(resonant(u,'Kurama'))for(const v of hit)if(v.hp<=0)extra(ctx,u);
 }
}
function roundStart(ctx){for(const u of ctx.teams.flat())if(isNaruto(u)){reset(ctx,u);if(u.nfStage<9)u.mysteryReadyRound=ctx.round;}return [];}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat())if(isNaruto(u)&&u.hp>0&&u.nfRestoreRound===ctx.round){
 const frame=pain.visual(u,config.restoration);frame.reactions=[];afterHit(ctx,u,null,[],config.restoration,frame);out.push(frame,...frame.reactions);
 }return out;}
function triggers(ctx){return ctx.nfQueue.splice(0).filter(r=>r.unit.hp>0);}
module.exports={config,isNaruto,active,jinchuriki,initialize,battleStart,profile,resonant,canMystery,mysterySpent,available,spendStandard,loseStandards,selectStandard,factor,blocksBuff,onDamage,outgoing,standardGuaranteed,blocksMystery,blocksAdditional,blocksDeath,noteDeaths,prepareMove,targets,onAttacked,observe,afterHit,roundStart,endRound,triggers};
