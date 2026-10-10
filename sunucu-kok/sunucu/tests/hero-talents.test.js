'use strict';
const assert = require('assert');
const talents = require('../hero-talents');
const stats = require('../statlar');
const gear = require('../ekipman');
const battle = require('../savas');
const codec = require('../kodek');
const source = stats.anaKaynakHam();
assert(source);
let checked = 0;
for (const [id, hero] of talents.heroes) {
  assert(talents.talents.has(Number(hero.talent)), `${id}: missing talent`);
  const packet = gear.statPaketi({}, id, 100);
  assert(packet, `${id}: missing stat packet`);
  const block = packet.subarray(4), stat = stats.blokOku(block);
  const unit = battle.heroBirim(id, 6, 100, null, stat, 1);
  assert(unit, `${id}: missing battle unit`);
  for (const field of ['hp','atk','def','speed','anger','critRate','dodgeRate','blockRate','punchRate','damageBonus','damageReduction']) {
    assert.strictEqual(unit[field], stat[field], `${id}: client/combat ${field}`);
    assert(Number.isFinite(unit[field]), `${id}: non-finite ${field}`);
  }
  const bare = stats.blokOlcekle(source.blok, stats.olcekler(id,100,source.id,source.lv));
  let p = 0;
  for (let b = 0; b < 2; b++) {
    const n = bare.readUInt16BE(p); p += 2;
    for (const [field,index] of Object.entries(talents.RATE_SLOTS)) if (index < n) {
      const expected = talents.rates(id)[field];
      assert(Math.abs(bare.readFloatBE(p + index * 4) - expected) < 1e-6, `${hero.name}: ${field}`);
    }
    p += n * 4;
  }
  checked++;
}
const unit = (id,camp,pos=6) => ({id,camp,pos,hp:10000,maxHp:10000,atk:100,def:0,anger:0,normal:13100114,skill:13100001,skillId:13100001,hitRate:1,critRate:0,damageBonus:0,damageReduction:0});
const heroFor = suffix => [...talents.heroes].find(([,h]) => h.talent === 13200000 + suffix)[0];
function strike(a,b,rng=()=>.5,opponents=[b]) { return battle.vurus(a,b,false,opponents,rng); }
let a=unit(source.id,0),b=unit(12101003,1);
a.skill=0;b.dodgeRate=1;
let act=strike(a,b);assert.strictEqual(b.hp,10000);assert.strictEqual(act.targets[1].reportTargetStatus&codec.ST.HIT,0);
b=unit(12101003,1);a.critRate=1;act=strike(a,b);assert(act.targets[1].reportTargetStatus&codec.ST.CRIT);assert.strictEqual(act.targets[1].result.hurtHp,150);
a.critRate=0;b=unit(12101003,1);b.blockRate=1;act=strike(a,b);assert(act.targets[1].reportTargetStatus&codec.ST.BLOCK);assert.strictEqual(act.targets[1].result.hurtHp,50);
assert.strictEqual(act.reactions[0].activeType,3);assert.strictEqual(act.reactions[0].activePos,b.pos);
b=unit(12101003,1);b.blockRate=b.antiknockRate=1;a.hp=10000;act=strike(a,b);assert.strictEqual(a.hp,9900);assert.strictEqual(act.reactions[0].targets[0].result.hurtHp,100);
b=unit(12101003,1);const helper=unit(12101004,1,11);helper.helpRate=1;act=strike(a,b,()=>.5,[b,helper]);assert.strictEqual(b.hp,9950);assert.strictEqual(helper.hp,9950);assert(act.targets.some(t=>t.targetPos===11&&(t.reportTargetStatus&codec.ST.HELP)));
b=unit(12101003,1);b.damageReduction=2;assert.strictEqual(strike(a,b).targets[1].result.hurtHp,0);
a=unit(heroFor(196),0);b=unit(12101003,1);assert.strictEqual(strike(a,b).targets[1].result.hurtHp,200);
for(const suffix of [187,202]) {
 a=unit(heroFor(suffix),0);b=unit(12101003,1);act=strike(a,b);
 assert.strictEqual(act.activeType,codec.ACTIVE.SKILL);assert.strictEqual(act.skillEffectId,a.skill);assert.strictEqual(a.anger,0);
}
a=unit(heroFor(190),0);b=unit(12101003,1,1);const c=unit(12101004,1,6),d=unit(12101005,1,11);
b.atk=50;c.atk=200;d.atk=150;c.dodgeRate=d.dodgeRate=1;
act=strike(a,b,()=>.5,[b,c,d]);assert.deepStrictEqual(act.targets.filter(t=>t.targetCamp===1).map(t=>t.targetPos),[6,11]);assert(c.hp<10000&&d.hp<10000);assert.strictEqual(b.hp,10000);
a=unit(heroFor(201),0);assert.strictEqual(talents.selectTargets(a,[b,d,c])[0],c);
a=unit(source.id,0);a.anger=0;a.skill=0;b=unit(12101003,1);
act=battle.vurus(a,b,false,[b],()=>.5,true);assert.strictEqual(a.anger,0);assert.strictEqual(act.activeType,codec.ACTIVE.NORMAL_EX);
b=unit(12101003,1);b.blockRate=1;
act=battle.vurus(a,b,false,[b],()=>.5,true);assert.strictEqual(act.reactions[0].activeType,3,'a blocked combo needs a native block record too');
const encoded=codec.encodeBattleReport({version:3,player1:{roles:[]},player2:{roles:[]},turns:[{curTurn:1,actives:[act,...act.reactions]}]});
const decoded=codec.decodeBattleReport(encoded);assert.strictEqual(decoded._consumed,decoded._total);
// Explicit bonuses must be applied once, in both PvE and PvP blocks, before gear.
const id=heroFor(203),raw=stats.blokOlcekle(source.blok, require('../seviye').statCarpanlari(id,100,source.id,source.lv));
const enhanced=stats.blokOlcekle(source.blok,stats.olcekler(id,100,source.id,source.lv));
assert.strictEqual(enhanced.readUInt32BE(6),Math.round(raw.readUInt32BE(6)*1.4));
assert.strictEqual(stats.blokOku(enhanced).damageReduction,.5);
const zero=Buffer.from(enhanced);zero.writeUInt32BE(0,2+20*4);assert.strictEqual(stats.blokOku(zero).anger,0);
// Talent writes must preserve the native control/fury resistance fields (22..25).
for(const index of [22,23,24,25])assert.strictEqual(enhanced.readFloatBE(2+index*4),raw.readFloatBE(2+index*4));
const level=require('../seviye'),recruit={};const starter=heroFor(198);
assert.strictEqual(level.heroKayit(recruit,starter,32).lv,159);
recruit.seviye.herolar[starter].lv=158;assert.strictEqual(level.heroKayit(recruit,starter,32).lv,158,'initial talent must not undo reincarnation');
// Equipment ATK/DEF percentages must boost combat, not overwrite control slots.
const school=stats.spiritSchoolBonuses,plain=gear.statPaketi({},id,100);
try {
 stats.spiritSchoolBonuses=()=>({32:.2,33:.3});
 const enhancedGear=gear.statPaketi({},id,100);
 for(const [index,rate]of [[6,.2],[7,.2],[8,.3],[9,.3]]) {
  const before=plain.readUInt32BE(6+index*4);
  assert.strictEqual(enhancedGear.readUInt32BE(6+index*4),before+Math.round(before*rate));
 }
 for(const index of [22,23])assert.strictEqual(enhancedGear.readFloatBE(6+index*4),plain.readFloatBE(6+index*4));
} finally { stats.spiritSchoolBonuses=school; }
console.log(`PASS: ${checked} heroes, PvE/PvP talent rates, client/combat stats, zero rage, dodge/crit/block, damage reduction, normal skills, 200% normal damage, highest-ATK targets with guaranteed hits, assaulter priority, extra-attack rage, packet round trip.`);
