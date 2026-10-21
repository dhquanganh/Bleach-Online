'use strict';
const assert=require('assert');
const combat=require('../naruto-combat'),battle=require('../savas'),codec=require('../kodek');
const C=combat.STATE;
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:100000,maxHp:100000,atk:100,magicAtk:200,def:0,anger:100,speed:100,normal:13100114,skill:0,skillId:13100114,level:100,quality:3,hitRate:1,damageBonus:0,damageReduction:0});
const victim=()=>unit(12101003,1,1);
const chase=(requires,causes,extra={})=>({id:13120904,requires,causes,multiplier:1,combo:1,...extra});
const attach=(u,chases)=>{u.naruto={chases};return u;};
const frame=(u,v,hit=true)=>({activeCamp:u.camp,activePos:u.pos,activeType:1,skillEffectId:u.normal,targets:[{cmd:1,targetCamp:v.camp,targetPos:v.pos,reportTargetStatus:(hit?codec.ST.HIT:0)>>>0,result:{hurtHp:hit?100:0}}],reactions:[]});
function run(team,v,opener={causes:C.LOW_FLOAT,combo:1},ctx=null) {
  ctx=ctx||combat.create([team,[v]]);if(!ctx.round)combat.startRound(ctx,1);
  const actors=[];
  const frames=combat.resolve(ctx,team[0],v,frame(team[0],v),opener,(u,t,s)=>{actors.push(u.id);return frame(u,t);});
  return {ctx,actors,frames};
}
// A later move starts; priority is reevaluated from move 1 at EVERY link.
let v=victim(),a=attach(unit(1,3),[chase(C.LOW_FLOAT,C.REPULSE)]),b=attach(unit(2,1),[chase(C.REPULSE,C.HIGH_FLOAT)]),c=attach(unit(3,2),[chase(C.HIGH_FLOAT,C.KNOCKDOWN)]);
let r=run([a,b,c],v);assert.deepStrictEqual(r.actors,[1,2,3]);
assert.deepStrictEqual(r.ctx.trace.map(e=>e.state),[C.LOW_FLOAT,C.REPULSE,C.HIGH_FLOAT,C.KNOCKDOWN]);
// Each successful Chase sends the resulting state + current combo to its victim.
assert.deepStrictEqual(r.frames.map(f=>f.targets.find(t=>t.cmd===codec.CMD.FLOAT).result),[
  {buffId:19000204,buffTurn:2},{buffId:19000202,buffTurn:3},{buffId:19000203,buffTurn:4}
]);
assert(r.frames.every(f=>f.targets.filter(t=>t.cmd===codec.CMD.FLOAT).length===1));
// Competing chases consume the current state; the loser cannot use stale state.
a=attach(unit(1,2),[chase(C.LOW_FLOAT,C.REPULSE)]);b=attach(unit(2,1),[chase(C.LOW_FLOAT,C.KNOCKDOWN)]);
r=run([a,b],v);assert.deepStrictEqual(r.actors,[2]);
// A fresh chain in the SAME round does not replenish chase uses.
assert.deepStrictEqual(run([a,b],v,{causes:C.LOW_FLOAT},r.ctx).actors,[1]);
assert.deepStrictEqual(run([a,b],v,{causes:C.LOW_FLOAT},r.ctx).actors,[]);
combat.startRound(r.ctx,2);assert.deepStrictEqual(run([a,b],v,{causes:C.LOW_FLOAT},r.ctx).actors,[2]);
// 10/20 are hit-count thresholds; 10-combo skills do not need a float state.
a=attach(unit(1,1),[chase(null,null,{minCombo:10,combo:10})]);b=attach(unit(2,2),[chase(null,null,{minCombo:20})]);
assert.deepStrictEqual(run([a,b],v,{combo:9}).actors,[]);
assert.deepStrictEqual(run([a,b],v,{combo:10}).actors,[1,2]);
// Explicit exceptions are bounded even if a chase causes its own input state.
a=attach(unit(1,1),[chase(C.LOW_FLOAT,C.LOW_FLOAT,{maxPerRound:2})]);
assert.deepStrictEqual(run([a],v).actors,[1,1]);
a.paralyzed=true;assert.deepStrictEqual(run([a],v).actors,[]);delete a.paralyzed;
v.superArmor=true;assert.deepStrictEqual(run([a],v).actors,[]);delete v.superArmor;
assert.strictEqual(combat.setState(v,C.IMMOBILE,1),C.IMMOBILE);v.battleRound=1;assert(combat.disabled(v));v.battleRound=2;assert(!combat.disabled(v));
// Dodged openers, dead targets and disabled chasers cannot launch a chain.
let ctx=combat.create([[a],[v]]);combat.startRound(ctx,1);
assert.deepStrictEqual(combat.resolve(ctx,a,v,frame(a,v,false),{causes:C.LOW_FLOAT},()=>{throw Error('miss triggered chase');}),[]);
v.hp=0;assert.deepStrictEqual(run([a],v).actors,[]);
// Sage's shared chakra, opening cooldown and independent Prompt action.
const sage=battle.heroBirim(combat.config.heroId,6,100,null,null,1);assert(sage);
const sageRow=require('../paket').satir('BaseHero',combat.config.heroId);assert.strictEqual(sageRow.profession,2);assert.strictEqual(sageRow.quality,7);
const team=[sage];combat.prepareClones([team,[]]);assert.strictEqual(team.length,2);assert.strictEqual(team[1].cloneOwner,sage);
const sageClone=team[1],cloneProfile=combat.profile(sageClone);
assert(cloneProfile,'Sage clone must have a combat profile');
assert.strictEqual(cloneProfile.cloneId,0,'Clone must not summon another clone');
assert.strictEqual(cloneProfile.standard,combat.config.barrage);
assert.strictEqual(cloneProfile.mystery,combat.config.mystery);
assert.deepStrictEqual(cloneProfile.chases,combat.config.chases);
assert.strictEqual(cloneProfile.chakraPerRound,combat.config.chakraPerRound);
assert.strictEqual(sageClone.speed,sage.speed);assert.strictEqual(sageClone.skill,combat.config.mystery.id);
combat.prepareClones([team,[]]);assert.strictEqual(team.length,2,'Preparing clones twice must not recurse');
assert.strictEqual(combat.standard(sage,team),combat.config.barrage);
assert.strictEqual(combat.standard(sageClone,team),combat.config.barrage);
ctx=combat.create([team,[]]);combat.startRound(ctx,1);assert.strictEqual(ctx.chakra[0],60);assert(!combat.canMystery(ctx,sage));
combat.startRound(ctx,2);assert.strictEqual(ctx.chakra[0],80);assert(combat.useMystery(ctx,sageClone));assert.strictEqual(ctx.chakra[0],40);assert(!combat.useMystery(ctx,sageClone));
combat.startRound(ctx,3);assert(!combat.canMystery(ctx,sageClone));assert(combat.canMystery(ctx,sage));combat.startRound(ctx,4);assert(combat.canMystery(ctx,sageClone));
team[1].hp=0;assert.strictEqual(combat.standard(sage,team),combat.config.standard);
const records=combat.summon(sage,team);assert.strictEqual(records.length,1);assert.strictEqual(records[0].result.hurtHp,-team[1].maxHp);assert.strictEqual(team[1].hp,team[1].maxHp);
// Clones resist Lightning, occupy real free positions, and never replace allies.
const lightning={id:13120903,activeType:1,multiplier:1,element:'lightning'};
a=unit(1,1,1);v=unit(2,2);v.cloneOwner=sage;v.hp=100000;
const hit=battle.vurus(a,v,false,[v],()=>.5,false,[a],lightning);assert.strictEqual(hit.targets[1].result.hurtHp,50);
assert.strictEqual(a.anger,100,'Naruto attacks must not spend/generate Bleach rage');
for(const move of [combat.config.mystery,combat.config.barrage,...combat.config.chases]){
  assert.strictEqual(move.attackStat,'atk');assert.strictEqual(move.damageType,'physical');
}
assert.strictEqual(combat.config.standard.cooldown,0);assert.strictEqual(combat.config.barrage.cooldown,0);assert.strictEqual(combat.config.chases[0].cooldown,0);
// Full battle integration + binary round trip, including AOE and chase ordering.
const player=battle.heroBirim(combat.config.heroId,6,100,null,null,1);
const enemies=[unit(12101003,1,1),unit(12101004,6,1)];for(const e of enemies){e.atk=1;e.hp=e.maxHp=10000000;}
const report=battle.kadroRapor(0,null,{ad:'Naruto regression',birimler:enemies},{playerUnits:[player],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
const decoded=codec.decodeBattleReport(report.payload);assert.strictEqual(decoded._consumed,decoded._total);
const floatRecords=decoded.turns.flatMap(t=>t.actives).flatMap(a=>a.targets).filter(t=>t.cmd===codec.CMD.FLOAT);
assert(floatRecords.some(t=>t.result.buffId===19000104&&t.result.buffTurn===10),'Opening Repulse label survives binary encoding');
assert(floatRecords.some(t=>t.result.buffId===19000203&&t.result.buffTurn===11),'Chase Knockdown label survives binary encoding');
assert(decoded.player1.roles.some(role=>role.roleId===combat.config.heroId));assert(decoded.player1.roles.some(role=>role.roleId===combat.config.cloneId));
assert(!decoded.turns[0].actives.some(act=>act.skillEffectId===combat.config.mystery.id));
assert(decoded.turns[1].actives.some(act=>act.skillEffectId===combat.config.mystery.id));
assert(report.chaseTrace.some(e=>e.kind==='chase'&&e.state===C.KNOCKDOWN));
for(const turn of decoded.turns){assert(turn.actives.filter(act=>act.skillEffectId===combat.config.chases[0].id).length<=2,'Hero and clone may each chase once');}
const cloneRole=decoded.player1.roles.find(role=>role.roleId===combat.config.cloneId);
assert(decoded.turns.some(turn=>turn.actives.some(act=>act.activePos===cloneRole.pos&&[combat.config.mystery.id,combat.config.barrage.id,...combat.config.chases.map(move=>move.id)].includes(act.skillEffectId))),'Clone must execute inherited skills');
const available=require('../herolar').gecerliHerolar().map(h=>h.id);assert(available.includes(combat.config.heroId));assert(!available.includes(combat.config.cloneId));
// Lethal reflection must not kill the native actor while its skill callback is pending.
const reflectedSage=unit(combat.config.heroId,6);reflectedSage.hp=reflectedSage.maxHp=100;
const mirror=victim();mirror.skillBuffs=[{field:'reflect',remaining:3,value:1}];
const reflected=battle.vurus(reflectedSage,mirror,false,[mirror],()=>.5,false,[reflectedSage],combat.attackSpec(combat.config.mystery));
assert.strictEqual(reflectedSage.hp,0,'Reflection remains lethal in server state');
assert(!reflected.targets.some(r=>r.cmd===1&&r.targetCamp===0&&r.targetPos===6&&r.result.hurtHp>0));
assert.strictEqual(reflected.reactions[0].activeType,4);
assert.strictEqual(reflected.reactions[0].targets[0].result.hurtHp,100,'Exactly one deferred HP deduction');
const reflectPacket=codec.encodeBattleReport({version:3,player1:{roles:[]},player2:{roles:[]},turns:[{curTurn:1,actives:[reflected,...reflected.reactions]}]});
const reflectDecoded=codec.decodeBattleReport(reflectPacket);assert.strictEqual(reflectDecoded._consumed,reflectDecoded._total);
assert.strictEqual(reflectDecoded.turns[0].actives[1].targets[0].result.hurtHp,100);
reflectedSage.hp=reflectedSage.maxHp=10000;
const survived=battle.vurus(reflectedSage,mirror,false,[mirror],()=>.5,false,[reflectedSage],combat.attackSpec(combat.config.mystery));
const selfDamage=survived.reactions[0].targets.reduce((sum,r)=>sum+r.result.hurtHp,0);
assert.strictEqual(reflectedSage.hp,10000-selfDamage);assert(reflectedSage.hp>0);
console.log('PASS Naruto: branching/priority, 10/20 hits, round limits/exceptions, misses, armor/control, chakra/cooldowns, clones/Lightning, AOE and native packet round trip.');
