'use strict';
const assert=require('assert'),j=require('../jiraiya-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),codec=require('../kodek'),battle=require('../savas');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:100000,maxHp:100000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,normal:13100114,skill:0,skillId:13100114,level:100,quality:7,anger:100,partnerSkills:[],weaponSkills:[]});
const sage=(pos,camp=0)=>unit(j.config.heroId,pos,camp);
let a=sage(6),b=sage(6,1),naruto=unit(n.config.heroId,7),other=unit(100,8);other.senjutsu=true;
let ctx=n.create([[a,naruto,other],[b]],{random:()=>.5});n.startRound(ctx,1);
a.skillBuffs=[{field:'stun',remaining:3,kind:'buff'}];naruto.immobileUntil=2;
ctx.chakraLimit=[40,40];j.roundStart(ctx);
assert.deepStrictEqual(ctx.chakraLimit,[100,100]);assert.strictEqual(ctx.chakra[0],100);
assert(!s.status(a,'stun'));assert.strictEqual(naruto.immobileUntil,undefined);
assert.strictEqual(s.value(a,'speed'),102);
for(let round=2;round<=8;round++){n.startRound(ctx,round);j.roundStart(ctx);}
assert(Math.abs(s.value(other,'speed')-110)<1e-9);
ctx.round=1;ctx.chakra=[100,100];
assert(n.canMystery(ctx,a));const mystery=n.useMystery(ctx,a);assert.strictEqual(ctx.chakra[0],80);
assert.strictEqual(j.mysteryUsed(ctx,a,mystery),j.config.additional);
assert(!n.canMystery(ctx,b),'Enemy barrier creator is sealed too');
ctx.round=2;assert(j.activeBarrier(ctx));ctx.round=3;assert(!j.activeBarrier(ctx));assert(n.canMystery(ctx,b));
// Suppress immunity precedes Extreme Chaos, ignoring shield/control immunity.
let v=unit(200,1,1);v.battleRound=3;v.shield=500;v.skillBuffs=[{field:'immuneControl',remaining:5},{field:'invincible',remaining:5}];
j.afterHit(ctx,a,[v],j.config.additional,[]);assert(s.status(v,'chaos'));assert(!s.status(v,'immuneControl'));assert(!s.status(v,'invincible'));
v.battleRound=4;assert(s.status(v,'chaos'));v.battleRound=5;assert(!s.status(v,'chaos'));assert(s.status(v,'immuneControl'));
j.afterHit(ctx,a,[v],j.config.standard,[]);j.afterHit(ctx,a,[v],j.config.standard,[]);assert.strictEqual(v.jiraiyaResistanceStacks,2);
// 15-hit gate and non-stacking +1 budget, including own Chase; bounded cycles.
a=sage(6);v=unit(200,1,1);ctx=n.create([[a],[v]],{random:()=>.5});n.startRound(ctx,1);j.roundStart(ctx);
const hit=()=>({targets:[{cmd:1,targetCamp:1,targetPos:1,reportTargetStatus:codec.ST.HIT>>>0,result:{hurtHp:1}}],reactions:[]});
const strike=(u,t,move)=>{const f=hit();j.afterHit(ctx,u,[t],move,f.targets);return f;};
assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:14},strike).length,0);
assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:15},strike).length,2);
assert.strictEqual(ctx.chaseBonus[0],1);
assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:15},strike).length,0);
n.startRound(ctx,2);j.roundStart(ctx);assert.strictEqual(ctx.chaseBonus[0],0);
// Revival counts Mysteries AFTER defeat, per camp, not rounds or additional skills.
a.hp=0;j.noteDeaths(ctx);assert.strictEqual(j.revivals(ctx).length,0);
let ally=unit(300,7);j.mysteryUsed(ctx,ally,{});j.mysteryUsed(ctx,unit(301,7,1),{});j.mysteryUsed(ctx,ally,{});
assert.strictEqual(j.revivals(ctx).length,0);j.mysteryUsed(ctx,ally,{});
const revival=j.revivals(ctx);assert.strictEqual(revival.length,1);assert.strictEqual(a.hp,30000);assert.strictEqual(revival[0].record.result.hurtHp,-30000);assert.strictEqual(a.jiraiyaCooldownReduction,1);
assert.strictEqual(j.revivals(ctx).length,0);
// Real damage targeting: guaranteed normal hits all, additional <=2, Chase <=4.
a=sage(6);const enemies=Array.from({length:5},(_,i)=>unit(400+i,i+1,1));for(const e of enemies)e.dodgeRate=1;
for(const [move,count] of [[j.config.standard,5],[{...j.config.additional,unavoidable:true},2],[{...j.config.chases[0],unavoidable:true},4]]){
 const frame=battle.vurus(a,enemies[0],false,enemies,()=>.5,false,[a],n.attackSpec(move));
 assert.strictEqual(frame.targets.filter(r=>r.cmd===1&&(r.reportTargetStatus&codec.ST.HIT)).length,count);
}
// Native report and recruitment, with both new and existing ninja.
const J=battle.heroBirim(j.config.heroId,6,100,null,{hp:100000,atk:100,def:100,speed:100,hitRate:1},1);
assert(J);assert.strictEqual(J.profession,4);assert.strictEqual(J.quality,7);
const E=enemies.slice(0,2);for(const e of E){e.hp=e.maxHp=1000000;e.atk=1;e.dodgeRate=0;}
const report=battle.kadroRapor(0,null,{ad:'Jiraiya regression',birimler:E},{playerUnits:[J],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const decoded=codec.decodeBattleReport(report.payload);assert.strictEqual(decoded._consumed,decoded._total);
const moves=decoded.turns.flatMap(t=>t.actives).map(f=>f.skillEffectId);
for(const id of [13120911,13120912,13120913,13120915])assert(moves.includes(id),`Missing skill ${id}`);
const casts=decoded.turns.filter(t=>t.actives.some(f=>f.skillEffectId===13120911)).map(t=>t.curTurn);
assert(casts.every((r,i)=>i===0||r-casts[i-1]>=2));
assert(require('../herolar').gecerliHerolar().some(h=>h.id===j.config.heroId&&h.profession===4));
const fallen=battle.heroBirim(j.config.heroId,1,100,null,{hp:100,atk:100,def:0,speed:200,hitRate:1},1);
const rescuer=battle.heroBirim(n.config.heroId,11,100,null,{hp:10000000,atk:100,def:0,speed:100,hitRate:1},1);
const killers=Array.from({length:3},(_,i)=>unit(12101003,i+1,1));for(const e of killers){e.atk=5000;e.hp=e.maxHp=10000000;e.speed=1;}
const revivedReport=battle.kadroRapor(0,null,{ad:'Jiraiya revival regression',birimler:killers},{playerUnits:[fallen,rescuer],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const revivedNative=codec.decodeBattleReport(revivedReport.payload);
assert(revivedNative.turns.flatMap(t=>t.actives).some(f=>f.skillEffectId===j.config.revival.id),'Real battle must schedule the revival animation');
assert(revivedNative.turns.flatMap(t=>t.actives).flatMap(f=>f.targets).some(r=>r.targetCamp===0&&r.targetPos===1&&r.result.hurtHp===-30),'Native revival HP must equal 30% max HP');
console.log('PASS Jiraiya: SSS Assaulter, 2-round bilateral barrier, immediate Chant, immunity/Chaos lifetime, Senjutsu cleanse/chakra/initiative cap, 15-hit Chase/bonus reset, 3-Mystery revival, AOE limits and native report.');
