const assert=require('assert'),{tablo,satir}=require('../paket'),s=require('../savas');
let stages=0;
for(const city of tablo('City').liste.filter(c=>Number(c.type)===1)){
 const low=Number(satir('BlockPoint',city.start).level),high=Number(satir('BlockPoint',city.last).level);let previous=low;
 assert.equal(s.worldMapLevel(city.start),low);assert.equal(s.worldMapLevel(city.last),high);
 for(let id=city.start;id<=city.last;id++){const level=s.worldMapLevel(id);assert(level>=low&&level<=high&&level>=previous);previous=level;const team=s.stageDusmanlari(id);assert(team&&team.birimler.length);assert(team.birimler.every(u=>u.level===level&&u.hp===u.maxHp&&u.maxHp>=100));stages++;}
}
const base={level:50,maxHp:100000,atk:10000,def:1000,speed:500};const a=s.worldMapScale({...base},1),b=s.worldMapScale({...base},10);for(const key of ['maxHp','atk','def','speed'])assert(b[key]>a[key]);assert.equal(a.maxHp,100);assert.equal(b.maxHp,4000);assert.equal(b.atk,400);
assert.equal(s.worldMapLevel(15000001),0);assert.equal(s.worldMapLevel(15301001),0);
console.log('PASS world maps:',stages,'stages across 32 maps; exact displayed range, increasing levels, quadratic stats including downward scaling, other events excluded.');

const fs=require('fs'),codec=require('../kodek'),d=JSON.parse(fs.readFileSync(require('path').join(__dirname,'../oyuncu.json')));
for(const id of [15101001,15101015,15102014]){
 const team=s.stageDusmanlari(id),r=s.kadroRapor(id,null,null,{playerState:d,requireEnemyDefeated:true,forceWin:false}),report=codec.decodeBattleReport(r.payload);
 for(const role of report.player2.roles){const unit=team.birimler.find(u=>u.id===role.roleId);assert.equal(role.level,s.worldMapLevel(id));assert.equal(role.totalHealth,unit.maxHp);}
}
console.log('PASS real Flash battle reports preserve mapped levels and scaled HP; player-power balancing does not override world maps.');
