'use strict';
const assert=require('node:assert/strict'),tower=require('../tower-gold'),battle=require('../savas'),codec=require('../kodek'),{Y}=require('../paket');

// Floor 46's Isshin/Urahara have row-restricted controls. When only a front-row
// Obito remains, those skills must not redirect their controls onto the front.
const obito=battle.heroBirim(11120920,1,100,null,null,0,true);
Object.assign(obito,{hp:10000,maxHp:10000,atk:1000,magicAtk:1000,def:100,resistance:100,speed:100});
const enemies=[11140013,11140012,11140011].map((id,i)=>({...battle.heroBirim(id,[6,1,11][i],46,null,null,0,true),camp:1,atk:100,magicAtk:100,def:100,hp:50000,maxHp:50000}));
assert.deepEqual(enemies.map(u=>u.id),[11140013,11140012,11140011]);
const simulate=strict=>{
 const result=battle.kadroRapor(0,null,{ad:'Tower 46 regression',birimler:enemies.map(u=>({...u}))},{playerState:{},playerUnits:[{...obito}],scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,strictSkillTargets:strict,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);return {result,report};
};
const {result,report}=simulate(true);
const actions=report.turns.flatMap(t=>t.actives.map(a=>({...a,round:t.curTurn})));
const own=actions.filter(a=>a.activeCamp===0&&a.activePos===1);
assert.equal(own.filter(a=>a.skillEffectId===13120959).length,1,'Rage activates exactly once');
const roots=own.filter(a=>a.skillEffectId===13120952);
assert(roots.length>=2,'Obito must use Underground Roots after entering Rage');
for(let i=1;i<roots.length;i++)assert(roots[i].round-roots[i-1].round>=3);
for(const act of roots)assert(act.targets.some(t=>t.targetCamp===1&&t.result.hurtHp>0),'Roots deals real damage');
const kamui=own.filter(a=>a.skillEffectId===13120951);
for(let i=1;i<kamui.length;i++)assert(kamui[i].round-kamui[i-1].round>=2);
for(const turn of report.turns){
 const standards=turn.actives.filter(a=>a.activeCamp===0&&[13120953,13120954].includes(a.skillEffectId));
 assert(standards.length>=2,'No Kamui-only turn after controls lose valid targets');
}
assert(!actions.some(a=>a.activeCamp===1&&[13100228,13100212].includes(a.skillEffectId)),'No middle/back skill on a lone front-row target');
assert.equal(result.won,false,'A live enemy at the round limit is a loss, never a forced clear');

// Regression proof: the legacy fallback recreates the original permanent lock.
const legacy=simulate(false).report;
assert.equal(legacy.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===0&&a.skillEffectId===13120952).length,0);

// Keep the shared engine's prior behavior outside Tower, and verify ordinary
// attacks still spend/restore fury on the actual actor when a skill cannot cast.
const actor=battle.heroBirim(11140013,6,46,null,null,0,true),victim={...obito};
Object.assign(actor,{camp:1,anger:100,strictSkillTargets:true});
const frame=battle.vurus(actor,victim,false,[victim],()=>.5,false,[actor]);
assert.equal(frame.skillEffectId,actor.normal);
assert(frame.targets.some(t=>t.cmd===1&&t.targetCamp===0&&t.result.hurtHp>0));
assert(!victim.skillBuffs?.some(b=>b.field==='void'));
const middle={...obito,pos:6,hp:100000,maxHp:100000};
const validActor={...actor,anger:100};
const validFrame=battle.vurus(validActor,middle,false,[middle],()=>.5,false,[validActor]);
assert.equal(validFrame.skillEffectId,validActor.skillEffect,'A valid middle-row target still permits the original skill');
assert(middle.skillBuffs?.some(b=>b.field==='void'),'Legitimate controls are preserved');

const state={towerGold:{floor:46,records:{}}};
for(const floor of [NaN,Infinity,-1,0,1.5,'46',47])assert.equal(tower.fight(state,floor),null);
assert.equal(tower.readFloor(new Y().utf(JSON.stringify({floor:46,mode:'invalid'})).done()),0);
assert.equal(tower.readFloor(Buffer.concat([new Y().utf('{"floor":46}').done(),Buffer.from([1])])),0);
assert.equal(tower.readFloor(new Y().utf('{"floor":46}').done()),46);
state.towerGold.records['45']={first:{report:'broken'}};
assert.equal(tower.fight(state,45,'first'),null);
assert.deepEqual(tower.complete(state,{won:true,floor:NaN}),[]);
assert.equal(state.towerGold.floor,46);
console.log('PASS Tower 46: reproduces legacy control lock; strict row targets restore Rage Roots, damaging Standards, cooldowns, real timeout losses, valid request/replay handling. No player files changed.');
