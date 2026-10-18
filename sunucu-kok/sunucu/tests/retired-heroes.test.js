'use strict';
const assert=require('node:assert/strict'),p=require('../retired-heroes'),tables=require('../paket'),heroes=require('../herolar'),battle=require('../savas'),tower=require('../tower-gold'),bots=require('../cross-server-bots'),reb=require('../reincarnation');
for(const id of p.heroIds){
 assert.equal(tables.satir('BaseHero',id),null);assert(!heroes.gecerliHerolar().some(h=>h.id===id));
 assert.equal(battle.heroBirim(id,1,100),null);assert(!tower.heroIds.includes(id));
 assert(!reb.owned({kadro:{[id]:1}},id,{tumKarakterler:true}));
}
assert(tables.satir('BaseHero',11120920));assert(battle.heroBirim(11120920,1,100));
assert(tower.heroIds.includes(11120920));
assert(bots.all().every(b=>b.heroes.every(p.allowed)));
for(const level of [1,100,159])assert(require('../arena-bot').build(level,[]).every(b=>b.heroes.every(p.allowed)));
const cfg=require('../mystic-shop-config.json');assert(cfg.offers.every(o=>p.allowed(o.heroID)));assert(cfg.offers.some(o=>o.heroID===11120920));
const before={herolar:[11120901,11120903,11120910,11120920],kadro:{11120901:1,11120920:2},heroStars:{11120903:40,11120920:4},seviye:{herolar:{11120910:{lv:100},11120920:{lv:150}}},meyhane:{alinan:{11120901:1}},altin:12345};
const clean=p.clean(before);assert.deepEqual(clean.herolar,[11120920]);assert.deepEqual(clean.kadro,{11120920:2});assert.equal(clean.altin,12345);assert.equal(clean.heroStars[11120920],4);assert.equal(clean.seviye.herolar[11120920].lv,150);assert(!clean.seviye.herolar[11120910]);
assert.equal(before.herolar.length,4,'Migration does not mutate input');assert.deepEqual(p.clean(clean),clean);
assert.deepEqual(p.clean({herolar:['11120901','11120903','11120910','11120920']}).herolar,['11120920']);
console.log('PASS removed Naruto/Jiraiya/Kabuto and summons from ownership, recruitment, character packets, combat, Tower and all Cross Server bots; Obito and unrelated currency/progression preserved.');
