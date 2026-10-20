'use strict';
const assert=require('assert'),event=require('../infinite-illusion'),codec=require('../kodek');
require('./illusion-real-players.test');
 // Wire uses exact 64-bit health and the bot's actual formation and level.
 const engine=require('../savas'),botTeam=require('../cross-server-bots').all()[0];
 engine.illusionBattle({kadro:{}},null);
 const lastStats=engine.sonIstatistik(),lastDamage=engine.sonOyuncuHasari();
 assert(Buffer.isBuffer(lastStats));
 for(let i=0;i<2;i++){
  const fight=engine.illusionBattle({kadro:{}},botTeam),report=codec.decodeBattleReport(fight.payload);
  assert.equal(report._consumed,report._total);assert.equal(report.version,4);
  assert.equal(report.player2.roles[0].roleId,event.config.bossHeroId);
  assert.equal(report.player2.roles[0].curHealth,10000000000);assert.equal(report.player2.roles[0].totalHealth,10000000000);
  assert.deepEqual(report.player1.roles.map(r=>r.roleId),botTeam.heroes);
  assert(report.player1.roles.every(r=>r.level===100+botTeam.levelOffset));
  assert(fight.damage>0&&fight.damage<=10000000000);assert.equal(fight.won,false);
  assert.strictEqual(engine.sonIstatistik(),lastStats);assert.equal(engine.sonOyuncuHasari(),lastDamage);
 }
 const attacker={maxHitDamage:0x7fffffff,rebirth:{n:100,ae:8}},target={hp:10000000000,maxHp:10000000000};
 const hit=require('../reincarnation').hit(attacker,target,9000000000,()=>0);
 assert.equal(hit.damage,0x7fffffff);assert.equal(target.hp,10000000000-0x7fffffff);

console.log('PASS boss engine: exact 10B HP, valid battle report and damage caps.');
