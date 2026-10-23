'use strict';
const assert=require('node:assert/strict'),env=require('../envanter'),gear=require('../ekipman');
// A header-only category 20 item between normal stacks must not shift the
// following template/instance IDs. Parse with the game's existing wire reader.
const items=[{code:14100002,amount:99999},{code:14600001,amount:1},{code:14100007,amount:12}];
const packet=env.ntfPaketi(items);
assert.equal(packet.length,3+30+16+30);
const parsed=gear.kayitlariOku(packet,1);
assert.equal(parsed.son,packet.length);
assert.deepEqual(parsed.kayitlar.map(x=>x.tpl),items.map(x=>x.code));
assert.equal(packet.readUInt16BE(12),32767);
assert.equal(packet.readUInt32BE(3+30+16+1),14100007);
console.log('PASS mixed inventory packet: category20 header, following item alignment, bounded visible quantity.');
const damaged={envanter:{esyalar:[{code:14130999,amount:65535},{code:14100002,amount:99999}],dusulen:{}}};
assert(!env.liste(damaged).some(x=>x.code===14130999));
const bag=env.loadBagPaketi(damaged),decoded=gear.kayitlariOku(bag,5);
assert.equal(decoded.son,bag.length);
assert(!decoded.kayitlar.some(x=>x.tpl===14130999));
assert(decoded.kayitlar.some(x=>x.tpl===14100002));
assert(damaged.envanter.esyalar.some(x=>x.code===14130999&&x.amount===65535));
console.log('PASS unknown saved template excluded from wire without deleting saved inventory.');
