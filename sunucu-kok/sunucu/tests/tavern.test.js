'use strict';
const assert = require('assert');
const fs = require('fs');
const path = require('path');
const tavern = require('../meyhane');
const levels = require('../seviye');
const inventory = require('../envanter');
const heroes = require('../herolar');
const gear = require('../ekipman');
const stats = require('../statlar');
const playerFiles = ['veri.json', 'oyuncu.json', 'oyun.db'].map(f => path.join(__dirname, '..', f));
const snapshots = playerFiles.map(f => fs.readFileSync(f));
const code = p => p.readUInt32BE(0);
const account = () => ({level: 80, vipLevel: 10, gumus: 10000000, kupon: 10000, altin: 0,
  blueSoul: 500, purpleSoul: 500, goldSoulV: 500, orangeSoul: 700, herolar: []});
const grade = 30130001;
const warrior = tavern.savascilar()[0];
let d = {}, v = account();
const originalRandom = Math.random;
try {
  Math.random = () => 0;
  let p = tavern.moraPaketi(0, grade, d, v);
  assert.equal(code(p), 0);
  assert.equal(p.readUInt16BE(5), 3);
  assert.equal(p.length, 34);
  assert.equal(new Set(d.meyhane.pending).size, 3);
  assert(d.meyhane.pending.every(id => tavern.savascilar().find(s => s.id === id).soul.type === 3));
  assert.equal(v.gumus, 9900000);
  const state = JSON.stringify(d), balance = JSON.stringify(v);
  assert.notEqual(code(tavern.moraPaketi(0, grade, d, v)), 0);
  assert.equal(JSON.stringify(d), state); assert.equal(JSON.stringify(v), balance);
  const opponents = d.meyhane.pending.slice();
  for (const id of opponents) {
    const before = v.blueSoul, coupons = v.kupon;
    p = tavern.normalMoraPaketi(d, 1, v);
    assert.equal(code(p), 0); assert.equal(p.length, 13); assert.equal(p.readUInt32BE(4), id);
    assert.equal(p[8], 1); assert.equal(v.kupon, coupons - 50);
    assert.equal(v.blueSoul, before + tavern.savascilar().find(s => s.id === id).soul.value);
  }
  assert.notEqual(code(tavern.normalMoraPaketi(d, 1, v)), 0);
  tavern.moraPaketi(1, grade, d, v);
  assert(d.meyhane.pending.every(id => tavern.savascilar().find(s => s.id === id).soul.type === 4));
  const loser = tavern.savascilar().find(s => s.id === d.meyhane.pending[0]), silver = v.gumus;
  Math.random = () => 0.99;
  assert.equal(tavern.normalMoraPaketi(d, 0, v)[8], 0);
  assert.equal(v.gumus, silver + loser.returnValue); assert.equal(d.meyhane.pending.length, 0);
  assert.notEqual(code(tavern.normalMoraPaketi(d, 0, v)), 0);
  Math.random = () => 0;
  const coupons = v.kupon, purple = v.purpleSoul;
  p = tavern.moraPaketi(3, grade, d, v);
  assert.equal(code(p), 0); assert.equal(p.readUInt16BE(5), 30); assert.equal(p.length, 277);
  assert.equal(v.kupon, coupons - 1500); assert(v.purpleSoul > purple);
  Math.random = () => 0.99;
  p = tavern.moraPaketi(2, grade, {}, account());
  assert.equal(code(p), 0); assert.equal(p.readUInt16BE(5), 10);
  for (let i = 0; i < 10; i++) assert.equal(p[7 + i * 9 + 4], 0);
  Math.random = () => 0;
  for (const [id, g] of tavern.kademeler()) {
    const local = {}, a = account(); a.level = g.level;
    p = tavern.moraPaketi(0, id, local, a);
    assert.equal(code(p), 0); assert.equal(p.readUInt16BE(5), 3);
    assert(local.meyhane.pending.every(w => tavern.savascilar().find(s => s.id === w).grade === g.page));
  }
  for (const [mode, id, patch] of [[4, grade, {}], [0, 0, {}], [0, 30130007, {level: 1}],
    [2, grade, {vipLevel: 0}], [0, grade, {gumus: 0}], [3, grade, {kupon: 0, altin: 0}]]) {
    const a = {...account(), ...patch}, before = JSON.stringify(a);
    assert.notEqual(code(tavern.moraPaketi(mode, id, {}, a)), 0); assert.equal(JSON.stringify(a), before);
  }
  d = {}; v = account();
  p = tavern.recruitPaketi(warrior.id, d, 80, v);
  assert.equal(code(p), 0); assert.equal(p.length, 20); assert.equal(p.readUInt32BE(4), warrior.heroId);
  assert.equal(v.blueSoul, 450); assert(d.meyhane.alinan[warrior.heroId]);
  assert.equal(code(tavern.recruitPaketi(warrior.id, d, 80, v)), 45); assert.equal(v.blueSoul, 450);
  assert.equal(code(tavern.recruitPaketi(warrior.id, {}, 1, {...account(), blueSoul: 0})), 43);
  const full = {meyhane: {alinan: Object.fromEntries(tavern.savascilar().slice(1, 18).map(w => [w.heroId, 1]))}};
  assert.equal(code(tavern.recruitPaketi(warrior.id, full, 80, account())), 46);
  assert.notEqual(code(tavern.addQualityPaketi(warrior.heroId, {}, account())), 0);
  assert.equal(code(tavern.addQualityPaketi(warrior.heroId, d, v)), 0); assert.equal(v.orangeSoul, 500);
  assert.equal(code(tavern.addQualityPaketi(warrior.heroId, d, v)), 0); assert.equal(v.orangeSoul, 0);
  assert.notEqual(code(tavern.addQualityPaketi(warrior.heroId, d, v)), 0);
  const source = stats.anaKaynakHam(); assert(source);
  const base = stats.blokOku(gear.statPaketi({}, warrior.heroId, 80).subarray(4));
  const advanced = stats.blokOku(gear.statPaketi(d, warrior.heroId, 80).subarray(4));
  assert(advanced.hp > base.hp); assert(advanced.atk > base.atk);
  const entry = heroes.heroGirisi(heroes.gecerliHerolar().find(h => h.id === warrior.heroId), 80, source.blok);
  const packet = Buffer.concat([Buffer.from([0, 1]), entry]);
  const restored = tavern.charYama(packet, JSON.parse(JSON.stringify(d)), () => 0);
  assert.equal(restored[2 + 63], 2); assert.equal(restored.length, packet.length);
  const variableEntry = Buffer.concat([entry.subarray(0, 24), Buffer.alloc(9), entry.subarray(24)]);
  variableEntry.writeInt16BE(1, 22);
  const variablePacket = Buffer.concat([Buffer.from([0, 1]), variableEntry]);
  assert.equal(tavern.charYama(variablePacket, d, () => 0)[2 + 63 + 9], 2);
  v = account(); d = {};
  const countBefore = inventory.mevcut(d, 14100003);
  assert.equal(code(tavern.changeCardPaketi(14100003, 2, d, v)), 0);
  assert.equal(v.blueSoul, 494); assert.equal(inventory.mevcut(d, 14100003), countBefore + 2);
  for (const [item, count] of [[11110001, 1], [14100003, 0], [14100003, -1], [14100003, 32768]]) {
    const before = JSON.stringify(v), saved = JSON.stringify(d);
    assert.notEqual(code(tavern.changeCardPaketi(item, count, d, v)), 0);
    assert.equal(JSON.stringify(v), before); assert.equal(JSON.stringify(d), saved);
  }
  assert.equal(code(tavern.changeCardPaketi(14100003, 1, {}, {...account(), blueSoul: 0})), 43);
  tavern.moraPaketi(0, grade, d, v); assert.equal(tavern.enterPaketi(d).length, 7);
  assert.equal(d.meyhane.pending.length, 0);
} finally {
  Math.random = originalRandom;
  playerFiles.forEach((f, i) => assert(fs.readFileSync(f).equals(snapshots[i]), 'Test changed player data: ' + f));
}
console.log('Tavern protocol, economy, round lifecycle, recruitment, cards and Advance passed.');
