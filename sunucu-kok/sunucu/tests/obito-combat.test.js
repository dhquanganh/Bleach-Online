'use strict';
const assert=require('node:assert/strict'),o=require('../obito-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,normal:13100114,skill:0,skillId:13100114,level:100,quality:7,anger:0,partnerSkills:[],weaponSkills:[]});
const obito=(camp=0)=>({...unit(o.config.heroId,1,camp),normal:o.config.standard.id,skill:o.config.mystery.id,skillId:o.config.mystery.id});
const start=(ctx,round)=>{n.startRound(ctx,round);return o.roundStart(ctx);};
// Every damaging Obito move uses Physical ATK, even its Ninjutsu/mixed moves.
for(const move of [o.config.rageMystery,o.config.standard,o.config.rageStandard,...o.config.chases,...o.config.rageChases]){
  const damage=(atk,magicAtk,buffed=false)=>{
    const actor={...obito(),atk,magicAtk},target=unit(200,1,1);
    if(buffed)actor.skillBuffs=[{field:'atk',value:.5,remaining:2}];
    const frame=battle.vurus(actor,target,false,[target],()=>.5,false,[actor],n.attackSpec(move));
    return frame.targets.filter(r=>r.cmd===1&&r.targetCamp===1).reduce((sum,r)=>sum+r.result.hurtHp,0);
  };
  const base=damage(100,10);
  assert.equal(damage(100,10000),base,move.name+' must ignore Magic ATK');
  assert(damage(200,10)>base,move.name+' must scale with Physical ATK');
  assert(damage(100,10,true)>base,move.name+' must use buffed Physical ATK');
}
let u=obito(),v=unit(200,1,1),ctx=n.create([[u],[v]],{random:()=>.5});
start(ctx,1);assert(n.canMystery(ctx,u));let move=n.useMystery(ctx,u);assert.equal(ctx.chakra[0],20);
let frame=battle.vurus(u,v,false,[v],()=>.5,false,[u],n.attackSpec(move));o.afterHit(ctx,u,v,[],move,frame);
assert.equal(u.hp,9000,'Kamui costs 10% once');assert(n.useStandard(ctx,u,[u]));assert(n.useStandard(ctx,u,[u]));assert.equal(n.useStandard(ctx,u,[u]),null);
assert(o.evade(u,()=>.5));assert(!o.evade(u,()=>0));
for(let i=0;i<5;i++)assert(o.fatalLimit(u,true));assert(!o.fatalLimit(u,true));
start(ctx,2);assert(!o.fatalLimit(u,true));
u.hp=4900;let frames=o.checkRage(u);assert(u.obitoRage);assert.equal(u.hp,9900);assert.equal(frames[0].skillEffectId,13120959);assert.equal(o.checkRage(u).length,0);
start(ctx,3);assert(o.evade(u,()=>.999));assert.equal(u.hp,9900,'Enhanced Kamui is free');
assert.equal(o.profile(u).mystery.chakraCost,40);move=n.useMystery(ctx,u);assert(move&&move.obitoRoots);frame={targets:[],reactions:[]};o.afterHit(ctx,u,v,[],move,frame);assert.equal(o.profile(u).mystery.chakraCost,20);assert.equal(o.prepareMove(ctx,u,v,o.config.rageChases[0]).multiplier,1.15*1.4);
start(ctx,4);assert.equal(n.canMystery(ctx,u),false);start(ctx,6);move=n.useMystery(ctx,u);o.afterHit(ctx,u,v,[],move,{targets:[],reactions:[]});assert.equal(o.profile(u).mystery.chakraCost,0);
// Lowest absolute HP, same-line selection and defensive-skill bypass.
u=obito();v=unit(200,1,1);const lower=unit(201,6,1),other=unit(202,2,1);lower.hp=1000;
assert.deepEqual(o.targets(o.config.standard,v,[v,lower,other]),[lower]);assert.deepEqual(o.targets(o.config.chases[1],v,[v,lower,other]),[v,lower]);
lower.skillBuffs=[{field:'invincible',remaining:2},{field:'reflect',remaining:2}];lower.dodgeRate=1;lower.blockRate=1;lower.shield=99999;
frame=battle.vurus(u,v,false,[v,lower,other],()=>.5,false,[u],n.attackSpec(o.config.standard));assert(lower.hp<1000);assert.equal(lower.shield,99999);assert.equal(frame.comboTarget,lower);assert.equal(frame.reactions.length,0);
// Tag lasts to the end of the next round; Suppress Immunity precedes control checks.
ctx=n.create([[u],[v]],{random:()=>.5});start(ctx,1);frame={targets:[],reactions:[]};o.afterHit(ctx,u,v,[v],o.config.standard,frame);
v.dodgeRate=.9;assert.equal(s.value(v,'def'),85);assert.equal(s.value(v,'resistance'),85);assert.equal(s.value(v,'dodgeRate'),.35);
n.startRound(ctx,2);assert.equal(s.value(v,'def'),85);n.startRound(ctx,3);assert.equal(s.value(v,'def'),100);
v.immuneDebuffs=true;u.obitoRage=true;ctx.chakra=[0,100];o.afterHit(ctx,u,v,[v],o.config.rageChases[0],{targets:[],reactions:[]});assert(!s.status(v,'immuneDebuffs'));assert.equal(ctx.chakra[0],20);assert.equal(ctx.chakra[1],80);
o.afterHit(ctx,u,v,[v],o.config.rageChases[1],{targets:[],reactions:[]});assert.equal(v.immobileUntil,3);assert(n.disabled(v));
// Life steal is 12% actual damage and a kill grants one credit per Standard.
u.hp=5000;v.hp=0;frame={targets:[{targetCamp:1,result:{hurtHp:100}}],reactions:[]};o.afterHit(ctx,u,v,[v],o.config.rageStandard,frame);assert.equal(u.hp,5012);assert.equal(u.obitoKillCredits,1);
// Native scheduling in both camps: two Standards each round, Prompt separate.
const team=camp=>[obito(camp),unit(12101003,6,camp)];
const result=battle.kadroRapor(0,null,{ad:'Obito regression',birimler:team(1)},{playerUnits:team(0),playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const decoded=codec.decodeBattleReport(result.payload);assert.equal(decoded._consumed,decoded._total);
for(const turn of decoded.turns.filter(t=>t.curTurn<=3))for(const camp of [0,1]){
  const acts=turn.actives.filter(a=>a.activeCamp===camp&&a.activePos===1);
  const standards=acts.filter(a=>[13120953,13120954].includes(a.skillEffectId));
  assert.equal(standards.length,2,'Two Standards round '+turn.curTurn+' camp '+camp+' actions '+acts.map(a=>a.skillEffectId).join(','));
  assert.equal(acts.some(a=>a.skillEffectId===13120951),turn.curTurn%2===1,'Kamui cooldown 2 rounds');
}
assert(decoded.turns.length>=3);
// Rage scheduling: threshold animation once, per-round Kamui and decreasing Roots costs.
const rageTeam=team(0);rageTeam[0].hp=4900;
const rageResult=battle.kadroRapor(0,null,{ad:'Obito Rage regression',birimler:team(1)},{playerUnits:rageTeam,playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const rageReport=codec.decodeBattleReport(rageResult.payload);
assert.equal(rageReport.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===0&&a.skillEffectId===13120959).length,1);
assert(rageReport.turns.flatMap(t=>t.actives).some(a=>a.activeCamp===0&&a.skillEffectId===13120952));
assert(rageReport.turns.flatMap(t=>t.actives).some(a=>a.activeCamp===0&&a.skillEffectId===13120954));
// Displacement and 20-hit Chase budgets are independent and persist across chains.
u=obito();v=unit(200,1,1);u.obitoRage=true;ctx=n.create([[u],[v]],{random:()=>.5});start(ctx,1);
const hit=()=>({targets:[{cmd:1,targetCamp:1,targetPos:1,reportTargetStatus:codec.ST.HIT>>>0,result:{hurtHp:1}}],reactions:[]});
assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,2);
assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,1);
assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,0);
n.startRound(ctx,2);assert.equal(n.resolve(ctx,u,v,hit(),{combo:1,causes:'lowFloat'},hit).length,0);
n.startRound(ctx,3);assert.equal(n.resolve(ctx,u,v,hit(),{combo:1,causes:'lowFloat'},hit).length,1);
console.log('PASS Obito: Rage threshold/recovery, Kamui costs/evasion/5 fatal protections, 2 Standards, kill credits, life steal, Roots cost reduction, line/lowest targets, immunity suppression, Tag duration and native scheduling in both camps.');

// Base/Rage share chase recovery and transformation cannot bypass a spent cooldown.
u=obito();v=unit(200,1,1);ctx=n.create([[u],[v]],{random:()=>.5});start(ctx,1);
assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,2);
u.hp=4900;o.checkRage(u);start(ctx,2);assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,0);
start(ctx,3);assert.equal(n.resolve(ctx,u,v,hit(),{combo:20,causes:'lowFloat'},hit).length,2);
// Passive Kamui also recovers instead of replaying every round.
u=obito();u.obitoRage=true;ctx=n.create([[u],[v]]);
assert(start(ctx,1).some(f=>f.skillEffectId===13120951));
assert(!start(ctx,2).some(f=>f.skillEffectId===13120951));
assert(start(ctx,3).some(f=>f.skillEffectId===13120951));
// Actual report spacing includes automatic Kamui and Roots on both camps.
for(const skill of [13120951,13120952,13120955,13120956,13120957,13120958]){
 const last=new Map();
 for(const turn of rageReport.turns)for(const act of turn.actives){
  if(act.skillEffectId!==skill)continue;const key=act.activeCamp+':'+act.activePos;
  if(last.has(key)&&last.get(key)!==turn.curTurn)assert(turn.curTurn-last.get(key)>=(skill===13120952?3:2));
  last.set(key,turn.curTurn);
 }
}
console.log('PASS Obito cooldowns: Kamui 2, Roots 3, Chase families 2; shared form recovery, two Rage Spear charges in eligible round, passive recovery and encoded report scheduling.');
// Float notifications include values for the actual effect, without adding HP changes.
u=obito();u.obitoRage=true;u.hp=5000;v=unit(200,1,1);ctx=n.create([[u],[v]],{random:()=>.5});start(ctx,1);
frame={targets:[{targetCamp:1,result:{hurtHp:100}}],reactions:[]};
o.afterHit(ctx,u,v,[v],o.config.rageMystery,frame);
let notices=frame.reactions.flatMap(f=>f.targets).filter(r=>r.cmd===codec.CMD.FLOAT);
assert(notices.some(r=>r.result.buffId===19000507));
assert(notices.some(r=>r.result.buffId===19000510&&r.result.buffTurn===20));
assert(notices.some(r=>r.result.buffId===19000508&&r.result.buffTurn===12));
v.hp=0;frame={targets:[],reactions:[]};o.afterHit(ctx,u,v,[v],o.config.rageStandard,frame);
assert(frame.reactions.flatMap(f=>f.targets).some(r=>r.result.buffId===19000509));
console.log('PASS Obito float notices: Chase bonus, remaining chakra cost, exact healed HP and extra Standard.');
