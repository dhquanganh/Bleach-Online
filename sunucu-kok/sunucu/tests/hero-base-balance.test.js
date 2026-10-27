'use strict';
const assert=require('node:assert/strict');
const balance=require('../hero-base-balance'),level=require('../seviye'),stats=require('../statlar');
const source=stats.anaKaynakHam();
let count=0;
for(const [id,h] of stats.heroById){
  if(!balance.policy.ranks.includes(h.assess))continue;
  const first=balance.stats(level.buyumeTemeli(id,1)),last=balance.stats(level.buyumeTemeli(id,159));
  // Integer primary attributes introduce up to 2 HP / 0.2 ATK of rounding.
  assert(first.hp>=4998&&first.hp<=6002,`${h.name}: LV1 HP`);
  for(const key of ['atk','def'])assert(first[key]>=1000&&first[key]<=1500,`${h.name}: LV1 ${key}`);
  assert(last.hp>=19999&&last.hp<=23001,`${h.name}: LV159 HP`);
  for(const key of ['atk','def'])assert(last[key]>=5000&&last[key]<=6000,`${h.name}: LV159 ${key}`);
  let previous=first;
  for(let lv=2;lv<=159;lv++){
    const current=balance.stats(level.buyumeTemeli(id,lv));
    for(const key of ['hp','atk','def'])assert(current[key]>previous[key],`${h.name}: ${key} growth at ${lv}`);
    previous=current;
  }
  const packet=stats.blokOku(stats.blokOlcekle(source.blok,stats.olcekler(id,1,source.id,source.lv)));
  const talent=require('../hero-talents').effect(id);
  assert.equal(packet.hp,Math.round(Math.round(first.hp*(1+(talent.life||0)))*(1+(talent.hp||0))));
  assert.equal(packet.def,Math.round(first.def*(1+(talent.defense||0))));
  assert(level.buyumeTemeli(id,159,2).life>level.buyumeTemeli(id,159,0).life,'quality progression remains');
  count++;
}
assert(count>=166);
console.log(`PASS ${count} heroes: balanced LV1/LV159, every level grows, packet DEF/HP and intrinsic bonuses preserved.`);
