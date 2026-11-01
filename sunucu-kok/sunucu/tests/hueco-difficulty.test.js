'use strict';
const assert=require('assert'),fs=require('fs'),path=require('path'),vm=require('vm'),{createRequire}=require('module');
const root=path.resolve(__dirname,'..'),h=require('../hueco-mundo');
for(const level of [1,30,92,159]){
 let previous=null;
 for(let i=0;i<h.COUNT;i++){
  const row=h.difficulty(i,level);assert(row.level>=1&&row.level<=159);
  if(previous){assert(row.level>=previous.level);assert(row.attackScale>previous.attackScale);}
  previous=row;
 }
}
assert(h.difficulty(0,159).attackScale>h.difficulty(0,1).attackScale);
const player=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));delete player.gunlukSayac;
const state=h.state(player);state.points[0].status=3;state.alinan['0']=1;state.hp['11100001']=42;state.points[1].hp['11140001']=35;
const expected={status:state.points[0].status,reward:state.alinan['0'],hp:JSON.stringify(state.hp),enemyHp:JSON.stringify(state.points[1].hp)};
delete state.level;h.state(player);const level=state.level;
assert.deepStrictEqual({status:state.points[0].status,reward:state.alinan['0'],hp:JSON.stringify(state.hp),enemyHp:JSON.stringify(state.points[1].hp)},expected);
assert.strictEqual(h.state(JSON.parse(JSON.stringify(player))).level,level);
for(let i=0;i<15;i++)assert.strictEqual(state.points[i].opponent.baseLevel,h.difficulty(i,level).level);
let received;
h.battle(player,Buffer.from([1]),(opponent,options)=>{received=options;return {payload:Buffer.from([1]),won:false,remainingHp:[]};});
assert.strictEqual(received.enemyAttackScale,h.difficulty(1,level).attackScale);
// Capture the actual battle setup after balancing, before HP carry-over/passives.
// This checks the arena-opponent branch used by Hueco, not just a formula helper.
const file=path.join(root,'savas.js'),local=createRequire(file),mod={exports:{}};let captured;
const source=fs.readFileSync(file,'utf8'),token='  // Hueco Mundo carries surviving HP between points; other modes start at full HP.';assert(source.includes(token));
const stop=Error('captured');
vm.runInNewContext(source.replace(token,'  __capture(p1,p2);\n'+token),{module:mod,exports:mod.exports,require:local,Buffer,__dirname:root,console,process,__capture:(p1,p2)=>{captured={p1,p2};throw stop;}});
const combat=mod.exports,bot=state.points[0].opponent;
function setup(scale){try{combat.kadroRapor(0,bot,null,{playerState:player,enemyAttackScale:scale});}catch(e){if(e!==stop)throw e;}return captured;}
const base=setup(1),boosted=setup(h.difficulty(0,level).attackScale);
assert(base.p2.length>0);
base.p2.forEach((unit,i)=>{
 assert.strictEqual(boosted.p2[i].atk,Math.round(unit.atk*h.difficulty(0,level).attackScale));
 for(const field of ['maxHp','def','magicAtk','resistance'])assert.strictEqual(boosted.p2[i][field],unit[field]);
});
assert.deepStrictEqual(boosted.p1.map(u=>u.atk),base.p1.map(u=>u.atk));
const defaultResult=setup(undefined);assert.deepStrictEqual(defaultResult.p2.map(u=>u.atk),base.p2.map(u=>u.atk),'other battles retain their original attack');
console.log('PASS Hueco difficulty: monotonic levels/Physical ATK across 15 points, level cap, migration/reload without lost progress, real combat applies ATK scaling, HP/DEF/magic/player stats and default other-mode attack unchanged.');
