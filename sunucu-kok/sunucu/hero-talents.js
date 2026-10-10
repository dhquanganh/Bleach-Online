'use strict';
// HeroTalent contains display text only. These are the explicit numeric effects in
// that text; unspecified percentages stay in BaseHero's existing base/growth data.
// Never parse English descriptions while running combat.
const fs = require('fs');
const path = require('path');
const dir = path.join(__dirname, '..', 'cikarim', 'veri-json');
const heroes = new Map(JSON.parse(fs.readFileSync(path.join(dir, 'BaseHero.json'), 'utf8')).map(h => [parseInt(h.id, 16), h]));
const talents = new Map(JSON.parse(fs.readFileSync(path.join(dir, 'HeroTalent.json'), 'utf8')).map(t => [parseInt(t.id, 16), t]));
const effects = new Map();
function add(ids, patch) {
  for (const suffix of ids) {
    const id = 13200000 + suffix;
    effects.set(id, Object.freeze({ ...effects.get(id), ...patch }));
  }
}
add([21,73], { hurtRate: .50 });
add([50,51,93,94], { avoidHurtRate: .05 });
add([52,54,55,56,95,116], { hurtRate: .05 });
add([60,63,96,119], { hurtRate: .07 });
add([35,36,61,99,100,101], { avoidHurtRate: .08 });
add([62,64,97,98,118,123,124,127,130,137,142], { avoidHurtRate: .07 });
add([59,65,68,69,106,107,108,111,112,113,117,125,143,161,168,169,170], { avoidHurtRate: .10 });
add([66,109,110,117,129,141,143,159,167,180], { hurtRate: .10 });
add([69,105,113,135,161,164,179,181,187,196], { hurtRate: .20 });
add([140], { hurtRate: .08 });
add([131,146,148,150], { hurtRate: .12 });
add([134,151,156,173], { hurtRate: .15 });
add([150], { avoidHurtRate: .12 });
add([163,174,183,186], { avoidHurtRate: .15 });
add([178,182,185,188,189,194,195,197], { avoidHurtRate: .20 });
add([198,203], { avoidHurtRate: .50 });
add([199], { avoidHurtRate: .30 });
add([65], { punchRate: .18 });
add([111,123,128,130,144], { punchRate: .07 });
add([122], { punchRate: .15 });
add([126,129,145], { punchRate: .10 });
add([135], { punchRate: .05 });
add([147,149], { punchRate: .12 });
add([139,145], { helpRate: .10 });
add([144], { helpRate: .07 });
add([152], { dodgeRate: .30, wreckRate: .30 });
add([153], { critRate: .15 });
add([155], { speed: .10 });
add([171], { speed: .12 });
add([162], { defense: .15, hp: .15, blockRate: .35 });
add([164], { power: .18, agile: .15 });
add([165], { defense: .20, life: .30 });
add([172], { agile: .25 });
add([175], { life: .25 });
add([176,179,204], { life: .20 });
add([177], { agile: .30 });
add([178,185], { defense: .20, life: .20 });
add([179], { power: .20 });
add([186], { agile: .25, intelligence: .25 });
add([187,196], { power: .30, agile: .20 });
add([187,202], { normalSkill: true });
add([190], { highestAttackTargets: 2, guaranteedHit: true });
add([194,195,197], { intelligence: .30, agile: .30 });
add([196], { normalMultiplier: 2 });
add([198,199], { intelligence: .35, agile: .30 });
add([198], { initialLevel: 159 });
add([200], { power: .20, life: .40 });
add([201], { power: .30, hurtRate: .30, assaultersFirst: true });
add([202], { power: .35, attack: .40 });
add([203,204], { intelligence: .40, agile: .40 });

const RATE_SLOTS = { hitRate: 10, dodgeRate: 11, critRate: 12, blockRate: 13,
  punchRate: 14, helpRate: 15, wreckRate: 16, antiknockRate: 17,
  hurtRate: 18, avoidHurtRate: 19, recoverRate: 21 };
function effect(heroId) { const h = heroes.get(Number(heroId)); return h ? effects.get(Number(h.talent)) || {} : {}; }
function rates(heroId) {
  const h = heroes.get(Number(heroId));
  if (!h) return {};
  const e = effect(heroId), out = {};
  for (const field of Object.keys(RATE_SLOTS)) out[field] = (Number(h[field]) || 0) + (e[field] || 0);
  return out;
}
function applyBlock(block, heroId, level) {
  const h = heroes.get(Number(heroId));
  if (!h) return block;
  const e = effect(heroId), r = rates(heroId);
  const growth = require('./seviye').buyumeTemeli(heroId, level);
  const combat = growth && Math.max(growth.power * (1 + (e.power || 0)), growth.agile * (1 + (e.agile || 0)), growth.intelligence * (1 + (e.intelligence || 0)));
  // Preserve the existing server's combat conversion; talent primary bonuses
  // change the same growth ratio used by both the stat packet and battle unit.
  const attack = (growth && growth.combat > 0 ? combat / growth.combat : 1) * (1 + (e.attack || 0));
  const factors = { 0: 1 + (e.power || 0), 1: 1 + (e.intelligence || 0), 2: 1 + (e.agile || 0),
    3: 1 + (e.life || 0), 5: (1 + (e.life || 0)) * (1 + (e.hp || 0)),
    6: attack, 7: attack, 8: 1 + (e.defense || 0), 9: 1 + (e.defense || 0) };
  let p = 0;
  for (let b = 0; b < 2; b++) {
    if (p + 2 > block.length) break;
    const n = block.readUInt16BE(p); p += 2;
    if (p + n * 4 > block.length) break;
    let extraPower = 0;
    for (const [index, factor] of Object.entries(factors)) if (Number(index) < n) {
      const off = p + Number(index) * 4;
      const before = block.readUInt32BE(off), after = Math.min(0x7fffffff, Math.round(before * factor));
      block.writeUInt32BE(after, off); extraPower += after - before;
    }
    // A copied protagonist block must not give every partner the same rates/speed.
    for (const [field, index] of Object.entries(RATE_SLOTS)) if (index < n) block.writeFloatBE(r[field], p + index * 4);
    if (n > 4) block.writeUInt32BE(Math.min(0x7fffffff, Math.max(0, Math.round(((Number(h.speed) || 0) + (Number(h.speedGrow) || 0) * Math.max(0, (Number(level) || 1) - 1)) * (1 + (e.speed || 0))))), p + 16);
    if (n > 26) block.writeUInt32BE(Math.min(0x7fffffff,block.readUInt32BE(p+26*4)+extraPower),p+26*4);
    p += n * 4;
  }
  return block;
}
function selectTargets(unit, opponents) {
  const alive = opponents.filter(t => t.hp > 0), e = effect(unit.id);
  const normal = !unit.skill || unit.anger < 100;
  if (normal && e.highestAttackTargets) return alive.slice().sort((a,b) => b.atk - a.atk || a.pos - b.pos).slice(0, e.highestAttackTargets);
  if (normal && e.assaultersFirst) {
    const middle = alive.filter(t => t.pos >= 6 && t.pos <= 10);
    if (middle.length) return middle.slice().sort((a,b) => a.pos - b.pos).slice(0,1);
  }
  return alive.slice().sort((a,b) => a.pos - b.pos).slice(0,1);
}
module.exports = { effect, rates, applyBlock, selectTargets, heroes, talents, effects, RATE_SLOTS };
