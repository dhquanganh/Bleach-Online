'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),codec=require('../kodek');

// Sanitized report captured from the actual floor-68 formation. It includes
// both White Zetsu deaths and the buff-only ID-0 action that froze the client.
const binary=fs.readFileSync(path.join(__dirname,'fixtures/tower-gold-floor68-tobi.report.bin'));
const report=codec.decodeBattleReport(binary);
assert.equal(report._consumed,report._total);
assert.equal(report.turns.length,8);
const zetsu=report.player1.roles.filter(role=>role.roleId===11120996);
assert.equal(zetsu.length,2);
const positions=new Set(zetsu.map(role=>role.pos));
const deaths=new Set();
for(const turn of report.turns)for(const action of turn.actives)for(const target of action.targets)
 if(target.targetCamp===0&&positions.has(target.targetPos)&&target.cmd===1&&target.result.hurtHp>0)
  deaths.add(target.targetPos);
assert.equal(deaths.size,2);
const buffOnly=report.turns[3].actives.find(action=>action.activeCamp===0&&action.activePos===7&&action.skillEffectId===0&&action.targets.length>0&&action.targets.every(target=>target.cmd!==1));
assert(buffOnly,'round four must contain the buff-only Tobi event that froze Flash');
assert(report.turns.slice(4).some(turn=>turn.actives.some(action=>action.activeCamp===0&&action.activePos===7&&action.skillEffectId===13121807)));
console.log('PASS exact Tower of Gold 68 report: both Zetsu deaths, round-four buff-only action, later Tobi revival and eight encoded rounds.');
