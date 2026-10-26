'use strict';
const assert=require('node:assert/strict');
const tower=require('../tower-gold'),battle=require('../savas'),codec=require('../kodek');

// Floor 68 kills both White Zetsu after Tobi summons them. The report must
// continue through Tobi's two sacrifice revivals into the following round.
const tobi=battle.heroBirim(11120995,1,100,null,null,0,true);
Object.assign(tobi,{hp:1000000,maxHp:1000000,atk:10000,magicAtk:10000,def:2500,resistance:2500,speed:600});
const result=battle.kadroRapor(0,null,{ad:'Tower of Gold 68 Zetsu regression',birimler:tower.lineup(68)},
 {playerUnits:[tobi],playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,strictSkillTargets:true,random:()=>.5});
const report=codec.decodeBattleReport(result.payload);
assert.equal(report._consumed,report._total);
const roles=[report.player1,report.player2].flatMap((player,camp)=>player.roles.map(role=>`${camp}:${role.pos}`));
const known=new Set(roles),events=report.turns.flatMap(turn=>turn.actives.map(active=>({...active,round:turn.curTurn})));
assert.equal(report.player1.roles.filter(role=>role.roleId===11120996).length,2);
assert(events.every(active=>known.has(`${active.activeCamp}:${active.activePos}`)&&active.targets.every(target=>known.has(`${target.targetCamp}:${target.targetPos}`))));
const deaths=events.flatMap(active=>active.targets.filter(target=>target.targetCamp===0&&[2,3].includes(target.targetPos)&&target.cmd===1&&target.result.hurtHp>0).map(target=>({round:active.round,pos:target.targetPos,damage:target.result.hurtHp})));
assert(deaths.some(hit=>hit.pos===2)&&deaths.some(hit=>hit.pos===3));
assert.equal(events.filter(active=>active.skillEffectId===13121807).length,2);
assert(events.some(active=>active.round>Math.max(...deaths.map(hit=>hit.round))),'battle continues after both Zetsu die');
console.log('PASS Tower of Gold floor 68: both White Zetsu die, both revival events decode, all actors resolve, following round plays.');
