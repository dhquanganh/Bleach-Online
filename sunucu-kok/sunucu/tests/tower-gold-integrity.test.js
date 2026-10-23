'use strict';
const assert=require('node:assert/strict'),tower=require('../tower-gold'),battle=require('../savas');
for(const value of [true,1,'broken',[]]){
 const d={towerGold:value};assert.equal(tower.info(d).floor,1);assert.equal(tower.info(d).preview.length,5);
}
for(const value of [true,1,'broken',[]]){
 const d={towerGold:{floor:2,records:value}};assert.equal(tower.info(d).floor,2);assert.equal(tower.info(d).lastDefeat,null);
}
for(const record of [{},{first:{}},{best:{}},{first:{name:'A',time:1,turns:1}},true]){
 const d={towerGold:{floor:2,records:{1:record}}};
 assert.equal(tower.info(d).lastDefeat,null);assert.equal(tower.fight(d,1,'first'),null);
 // A new clear must tolerate incomplete previous record metadata.
 const result={floor:2,won:true,turns:1,frames:[{payload:Buffer.from('fixture')}]};
 assert.equal(tower.complete(d,result).length,3);assert.equal(d.towerGold.floor,3);
 assert.deepEqual(tower.complete(d,result),[]);
}
const edge={towerGold:{floor:Number.MAX_SAFE_INTEGER,records:{}}};
assert.deepEqual(tower.info(edge).preview.map(p=>p.floor),[Number.MAX_SAFE_INTEGER]);
assert.equal(tower.fight(edge,Number.MAX_SAFE_INTEGER),null);

// Supplied battle randomness must govern combo chance and damage too. A global
// random change cannot alter a seeded replay, including on the ordinary heroes
// used by Tower's enemy roster.
const original=Math.random;
function simulate(globalRandom){
 Math.random=()=>globalRandom;
 const own=battle.heroBirim(11100001,1,1,null,null,0,true);
 const enemy=battle.heroBirim(tower.heroIds[0],6,1,null,null,0,true);
 Object.assign(own,{hp:100000,maxHp:100000,atk:100,magicAtk:100,def:100,punchRate:.5});
 Object.assign(enemy,{camp:1,hp:100000,maxHp:100000,atk:100,magicAtk:100,def:100,punchRate:.5});
 return battle.kadroRapor(0,null,{ad:'Tower seeded combos',birimler:[enemy]},
  {playerState:{},playerUnits:[own],random:()=>.25,forceWin:false,scaleEnemy:false,requireEnemyDefeated:true,strictSkillTargets:true}).payload;
}
try{assert.deepEqual(simulate(0),simulate(.999));}finally{Math.random=original;}
console.log('PASS Tower integrity: malformed state/records, safe floor bounds, clear/retry recovery, seeded combo report consistency. No account writes.');
