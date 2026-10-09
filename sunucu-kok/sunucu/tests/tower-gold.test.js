"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),vm=require('vm'),tower=require('../tower-gold'),codec=require('../kodek');
const d=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json')));delete d.towerGold;
assert.equal(tower.info(d).preview.length,5);assert.deepEqual(tower.info(d).preview.map(x=>x.floor),[1,2,3,4,5]);
assert.equal(tower.rewards(1)[0].amount,100);assert.equal(tower.rewards(1)[1].amount,1);
for(const floor of [500,1000,1000000]){assert.equal(tower.rewards(floor)[0].amount,50000);assert.equal(tower.rewards(floor)[1].amount,500);}
const a=tower.lineup(100),b=tower.lineup(1000);assert(a.every(u=>u.level===100));assert(b.every(u=>u.level===1000));assert(b[0].maxHp>a[0].maxHp);assert(b[0].atk>a[0].atk);assert.equal(tower.lineup(1).length,1);assert.equal(a.length,5);
assert.equal(tower.fight(d,2),null);
const battle=tower.fight(d,1);assert(battle&&battle.frames.length===2);const report=codec.decodeBattleReport(battle.frames[0].payload);assert(report.player2.roles.length===1);assert.equal(report.player2.roles[0].level,1);assert(battle.won);
assert.equal(tower.complete(d,battle).length,3);assert.equal(d.towerGold.floor,2);assert.equal(tower.complete(d,battle).length,0);assert.equal(d.towerGold.floor,2);
const record=d.towerGold.records['1'];assert(record.first&&record.best);assert.equal(tower.complete(d,{floor:2,won:false,turns:1}).length,0);assert.equal(d.towerGold.floor,2);
const replay=tower.fight(d,1);assert(replay);assert.equal(tower.complete(d,replay).length,0);assert.equal(d.towerGold.floor,2);
d.towerGold.floor=1000000;assert.deepEqual(tower.info(d).preview.map(x=>x.floor),[1000000,1000001,1000002,1000003,1000004]);
for(const f of fs.readdirSync(path.join(__dirname,'..')).filter(x=>x.endsWith('.js')))new vm.Script(fs.readFileSync(path.join(__dirname,'..',f),'utf8'),{filename:f});
console.log('PASS: separate persistent floors, five previews, real battle report, level/stat growth, 500/50000 reward caps, future-floor rejection, no rewards on loss/replays, first/best clear records and all backend syntax. No player files changed.');

const saved=tower.fight(d,1,'first');assert(saved&&saved.replay);assert.equal(tower.complete(d,saved).length,0);assert(saved.frames[0].payload.equals(battle.frames[0].payload));assert.equal(tower.fight(d,9999,'best'),null);
console.log('PASS: First/Best Defeat play saved native reports, grant no rewards and preserve floor progression.');

assert.equal(tower.lineup(1000000)[0].level,1000000);assert.equal(tower.lineup(1000000)[0].reportLevel,32767);

const inventory=require('../envanter');
for(const floor of [1,9,100,500,1000,1000000]){
 const awards=tower.rewards(floor),stone=awards.find(x=>x.code===tower.STONE),crystal=awards.find(x=>x.code===tower.CRYSTAL);
 assert.equal(crystal.amount,stone.amount);assert.equal(crystal.amount,Math.min(500,floor));
 const trial=JSON.parse(JSON.stringify(d)),before=inventory.mevcut(trial,tower.CRYSTAL);
 inventory.ekle(trial,awards);assert.equal(inventory.mevcut(trial,tower.CRYSTAL),before+crystal.amount);
}
assert.equal(require('../paket').satir('TemplePoint',tower.BACKGROUND_POINT).akeyPrice,30000);
assert(fs.existsSync(path.resolve(__dirname,'../../kaynak/login.gogames.me/public/2017112917/Resources/Textures/BackgroundIcon/00007530.TexClient')));
console.log('PASS: Blood War Crystal delivery equals Reincarnation Stone at all tested floors, cap 500; selected Trial Tower background exists locally.');

const models=require('../tower-gold-models');
assert(!tower.heroIds.includes(11160008));assert(!tower.heroIds.includes(11140002));
assert(tower.heroIds.length>0);assert(tower.heroIds.every(models.allowed));
for(const floor of [1,10,50,100,500,1000,1000000])assert(tower.lineup(floor).every(u=>models.allowed(u.id)));
console.log('PASS: reported invisible Nelliel excluded; every eligible Tower hero has all five local combat/showcase animations.');

let previousGap=0;
for(let floor=2;floor<=100;floor++){
 const previous=tower.lineup(floor-1)[0],next=tower.lineup(floor)[0];
 for(const stat of ['maxHp','atk','def','speed'])assert(next[stat]>previous[stat]);
 const gap=next.maxHp-previous.maxHp;assert(gap>previousGap);previousGap=gap;
 assert.equal(next.maxHp,Math.round(600*tower.statMultiplier(floor)));
}
assert.equal(tower.statMultiplier(1),1);
assert(tower.statMultiplier(10)<Math.pow(2,9));
for(const floor of [100,1000000])assert(tower.lineup(floor).every(u=>['maxHp','atk','def','speed'].every(k=>Number.isFinite(u[k])&&u[k]<=1000000000)));
console.log('PASS: polynomial Tower-only stats increase each floor with widening HP gaps; no exponential doubling, high-floor cap preserved.');
