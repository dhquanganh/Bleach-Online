'use strict';
const assert = require('assert');
const fs = require('fs');
const path = require('path');
const vm = require('vm');
const savas = require('../savas');
const { tablo, satir } = require('../paket');
const request = (city, stage, count) => {
  const b = Buffer.alloc(10);
  b.writeUInt32BE(city, 0); b.writeUInt32BE(stage, 4); b.writeUInt16BE(count, 8);
  return b;
};
const sum = (items, type) => items.filter(x => x.type === type && x.code === 0).reduce((n, x) => n + x.amount, 0);
let stages = 0;
for (const city of tablo('City').liste.filter(c => Number(c.type) === 1)) {
  for (let id = Number(city.start); id <= Number(city.last); id++) {
    const point = satir('BlockPoint', id);
    const army = satir('EnemyArmy', JSON.parse(point.army).army[0]);
    const fixed = JSON.parse(satir('Award', army.awardId).fixed).fixed;
    const actual = savas.stageOdulleri(id);
    for (const type of [0, 2]) assert.equal(sum(actual, type), sum(fixed, type));
    stages++;
  }
}
const payload = request(15100004, 15106006, 10);
const sweep = savas.autoBattleFrames(0x01810504, payload)[0];
assert.equal(sum(sweep.odul, 2), 11710);
assert.equal(sum(sweep.odul, 0), 9450);
assert.equal(sweep.odul.filter(x => x.type === 2).length, 1);
assert.equal(sweep.count, 10); assert.equal(sweep.vitalityCost, 10);
for (const count of [1, 50]) {
  const frame = savas.autoBattleFrames(0x01810504, request(15100004, 15106006, count))[0];
  assert.equal(sum(frame.odul, 2), 1171 * count);
  assert.equal(sum(frame.odul, 0), 945 * count);
  assert.equal(frame.vitalityCost, count);
}
const boss = savas.autoBattleFrames(0x01810504, request(15100001, 15101001, 10))[0];
assert.equal(boss.vitalityCost, 20);
// Decode every displayed turn independently of the encoder.
const packet = sweep.payload;
assert.equal(packet.readInt32BE(4), 0, 'instant settlement has no remaining cooldown');
assert.equal(savas.isFight(0x01810506), false, 'Gold Speed Up must never start a normal battle');
assert.equal(packet.readUInt32BE(0), 0); assert.equal(packet.readInt16BE(9), 10);
let offset = 11;
function rewards() {
  const count = packet.readInt16BE(offset); offset += 2;
  const out = [];
  for (let i = 0; i < count; i++) {
    out.push({ type: packet.readInt16BE(offset), code: packet.readUInt32BE(offset + 2), amount: packet.readInt32BE(offset + 6) });
    offset += 10;
  }
  return out;
}
for (let i = 0; i < 10; i++) {
  assert.equal(packet.readInt16BE(offset), 1); offset += 2;
  const turn = rewards(); assert.equal(sum(turn, 2), 1171); assert.equal(sum(turn, 0), 945);
  assert.deepEqual(rewards(), []);
}
assert.equal(offset, packet.length);
for (const bad of [Buffer.alloc(0), payload.subarray(0, 8), request(15100004, 15106006, 0), request(15100004, 15106006, 51), request(15100001, 15106006, 10), request(0, 15106006, 10), request(15100004, 0, 10)]) {
  assert.throws(() => savas.autoBattleFrames(0x01810504, bad));
}
// Execute the actual server sweep branch with in-memory account dependencies.
const source = fs.readFileSync(path.join(__dirname, '../oyun-sunucu.js'), 'utf8');
assert(source.includes('0x01810505, 0x01810506'), 'stop and speed-up controls cannot grant duplicate rewards');
const start = source.indexOf('      if (savas.isAutoBattle(pk.id)) {');
const end = source.indexOf('      if ((pk.id >>> 0) === 0x01818b02)', start);
function run(body, vitality) {
  const events = [], account = { vitality, exp: 0, silver: 0, wins: 0 };
  const ctx = {
    Buffer, savas, pk: { id: 0x01810504, payload: body }, reqHex: 'sweep', cid: 1,
    send: (id, data, label) => events.push(label), LOG: { note() {} },
    durumMod: { yukle: () => account, kaydet() {} },
    gorev: { savasKazanildi: (d, id, n) => { d.wins += n; return []; } },
    handlers: {
      paraEksik: costs => account.vitality < costs[0].amount,
      paraHarca: costs => { account.vitality -= costs[0].amount; return Buffer.alloc(1); },
      envanterEkleOdul: () => [], envanterPaketiEkleme: () => null,
      paraIcinOdul: items => { account.exp += sum(items, 2); account.silver += sum(items, 0); events.push('saved'); return Buffer.alloc(1); },
    },
  };
  vm.runInNewContext(`for (let once = 0; once < 1; once++) { ${source.slice(start, end)} }`, ctx);
  return { account, events };
}
const success = run(payload, 20);
assert.deepEqual(success.account, { vitality: 10, exp: 11710, silver: 9450, wins: 10 });
assert(success.events.indexOf('saved') < success.events.indexOf('OTO-SAVAS'));
for (const [body, vitality] of [[payload, 9], [request(15100004, 0, 10), 20]]) {
  const failed = run(body, vitality);
  assert.deepEqual(failed.account, { vitality, exp: 0, silver: 0, wins: 0 });
  assert.deepEqual(failed.events, ['OTO-error']);
}
console.log(`PASS world-map sweep: ${stages} stage rewards, 10 displayed turns, exact aggregate grants, vitality charge, invalid/insufficient requests leave account unchanged.`);
