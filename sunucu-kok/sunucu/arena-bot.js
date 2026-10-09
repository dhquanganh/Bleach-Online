'use strict';

const fs = require('fs');
const path = require('path');

const DATA = path.join(__dirname, '..', 'cikarim', 'veri-json');
const read = name => JSON.parse(fs.readFileSync(path.join(DATA, name + '.json'), 'utf8'));
const idNum = value => parseInt(value, 16) >>> 0;
const heroes = read('BaseHero');
const enemies = read('Enemy');
const roles = new Map(read('RoleModel').map(x => [idNum(x.id), x]));
const skills = new Set(read('SkillConfig').map(x => idNum(x.id)));
const militaries = read('Military').map(x => idNum(x.id));
const enemyArmies = read('EnemyArmy');
const stagePoints = [...read('BlockPoint'), ...read('SinglePointPath')];
const localModels = new Set();
try {
  const textureDir = path.join(__dirname, '..', 'kaynak', 'login.gogames.me', 'public',
    '2017112917', 'Resources', 'Textures', 'Model');
  for (const file of fs.readdirSync(textureDir)) {
    const match = /^([0-9A-Fa-f]{8})\.TexClient$/.exec(file);
    if (match) localModels.add(parseInt(match[1], 16) >>> 0);
  }
} catch (error) {
  console.warn(`[arena] local character models unavailable: ${error.message}`);
}
function validRole(id) {
  const role = roles.get(id);
  return !!role && localModels.has(Number(role.model) >>> 0);
}
const botHeroes = heroes.filter(h => {
  const id = idNum(h.id);
  let effects;
  try { effects = JSON.parse(h.attackEffect); } catch (e) { return false; }
  const normal = Number(h.normalAttack) || 0;
  const active = Number(h.active) || 0;
  return validRole(id) && effects[String(normal)] != null &&
    effects[String(active)] != null && skills.has(active);
}).map(h => idNum(h.id));
const botEnemies = enemies.filter(e => {
  const id = idNum(e.id);
  const normal = Number(e.normal) || 0;
  const active = Number(e.skill) || 0;
  let effects;
  try { effects = JSON.parse(e.effects); } catch (error) { return false; }
  return Number(e.level) <= 120 && validRole(id) && effects[String(normal)] != null &&
    effects[String(active)] != null && skills.has(active);
}).map(e => idNum(e.id));
const botCandidates = Array.from(new Set([...botHeroes, ...botEnemies]));
if (botCandidates.length < 5) {
  console.warn(`[arena] only ${botCandidates.length} bot units have cached character models`);
} else {
  console.log(`[arena] ${botCandidates.length} bot units have cached character models`);
}
const profiles = [
  { name: 'Bot Kenpachi', levelOffset: -8, power: 0.68 },
  { name: 'Bot Byakuya', levelOffset: -4, power: 0.84 },
  { name: 'Bot Rukia', levelOffset: 0, power: 1 },
  { name: 'Bot Urahara', levelOffset: 4, power: 1.18 },
  { name: 'Bot Aizen', levelOffset: 8, power: 1.38 },
];
const teamsByLevel = new Map();
const armyById = new Map(enemyArmies.map(army => [idNum(army.id), army]));

function parseList(value, key) {
  if (!value) return [];
  try {
    const parsed = JSON.parse(value);
    const list = Array.isArray(parsed) ? parsed : parsed[key];
    return Array.isArray(list) ? list.map(Number).filter(id => id > 0) : [];
  } catch (error) {
    return [];
  }
}

function stageFormations() {
  const unique = new Map();
  for (const point of stagePoints) {
    const positions = [];
    const seen = new Set();
    for (const armyId of parseList(point.army, 'army')) {
      const army = armyById.get(armyId);
      if (!army) continue;
      for (const [lane, start] of [['front', 1], ['middle', 6], ['back', 11]]) {
        const ids = parseList(army[lane], lane);
        ids.forEach((id, index) => {
          if (!seen.has(id) && positions.length < 9) {
            positions.push(start + index);
            seen.add(id);
          }
        });
      }
    }
    if (positions.length < 3 || positions.length > botCandidates.length) continue;
    const key = positions.join(',');
    if (!unique.has(key)) unique.set(key, { name: point.name || 'Dungeon formation', positions });
  }
  return Array.from(unique.values());
}

const formations = stageFormations();
if (!formations.length) throw new Error('No usable 3+ unit dungeon formations found for Arena bots');
console.log(`[arena] ${formations.length} dungeon formation layouts available`);

function clampLevel(level) {
  return Math.max(1, Math.min(159, Math.floor(Number(level) || 1)));
}

function playerHeroes(durum, mainId) {
  const ids = new Set();
  if ((Number(mainId) || 0) > 0) ids.add(Number(mainId) >>> 0);
  for (const [id, position] of Object.entries((durum && durum.kadro) || {})) {
    if (Number(position) > 0 && Number(id) > 0) ids.add(Number(id) >>> 0);
  }
  return Array.from(ids);
}

function shuffled(values) {
  const result = values.slice();
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

function build(level, excludedHeroes) {
  const playerLevel = clampLevel(level);
  if (botCandidates.length < 3 || !militaries.length) throw new Error('Arena bot data has fewer than three units with cached character models or no military ranks');
  const excluded = Array.from(new Set((excludedHeroes || []).map(id => Number(id) >>> 0))).sort((a, b) => a - b);
  const key = playerLevel + ':' + excluded.join(',');
  let squads = teamsByLevel.get(key);
  if (!squads) {
    const available = botCandidates.filter(id => !excluded.includes(id));
    const largestFormation = Math.max(...formations.map(formation => formation.positions.length));
    const pool = available.length >= largestFormation ? available : botCandidates;
    const layouts = shuffled(formations);
    squads = profiles.map((profile, index) => {
      const layout = layouts[index % layouts.length];
      if (layout.positions.length > pool.length) {
        throw new Error(`Dungeon formation "${layout.name}" needs ${layout.positions.length} distinct bot units; only ${pool.length} available`);
      }
      const units = shuffled(pool).slice(0, layout.positions.length);
      return {
        heroes: units,
        positions: layout.positions.slice(),
        formation: layout.name,
      };
    });
    teamsByLevel.set(key, squads);
    if (teamsByLevel.size > 256) teamsByLevel.delete(teamsByLevel.keys().next().value);
  }
  return profiles.map((profile, index) => {
    const botLevel = clampLevel(playerLevel + profile.levelOffset);
    return {
      id0: 0x00000167 + index,
      id1: 0x04d18923 + index,
      country: 1,
      ranking: 1 + index,
      military: militaries[Math.min(militaries.length - 1, Math.floor((botLevel - 1) / 5))],
      level: botLevel,
      name: profile.name,
      power: profile.power,
      heroes: squads[index].heroes,
      positions: squads[index].positions,
      formation: squads[index].formation,
    };
  });
}

function selected(payload, level, excludedHeroes) {
  if (!payload || payload.length < 8) return null;
  const id0 = payload.readUInt32BE(0);
  const id1 = payload.readUInt32BE(4);
  return build(level, excludedHeroes).find(bot => bot.id0 === id0 && bot.id1 === id1) || null;
}

module.exports = { build, selected, playerHeroes };
