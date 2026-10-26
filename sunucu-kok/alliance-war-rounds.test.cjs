'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict');
const rules=require('./sunucu/alliance-war'),codec=require('./sunucu/kodek'),playback=require('./sunucu/alliance-war-playback');
function unit(id,hp=1000){return {id,pos:6,hp,maxHp:hp,camp:0,name:String(id),level:80};}
function withCombat(resolve,action){
 const combat=require('./sunucu/savas'),original={kadroRapor:combat.kadroRapor,stageArmyDusmanlari:combat.stageArmyDusmanlari};
 combat.stageArmyDusmanlari=ids=>[unit(ids[0],100)];
 combat.kadroRapor=(id,opponent,enemy,options)=>{
  const left=options.playerUnits,right=enemy.birimler;
  const roles=team=>team.map(u=>({roleId:u.id,pos:u.pos,name:u.name,level:u.level,curHealth:u.hp,totalHealth:u.maxHp}));
  const player1={roles:roles(left)},player2={roles:roles(right)};resolve(left,right);
  return {won:left.some(u=>u.hp>0)&&right.every(u=>u.hp<=0),payload:codec.encodeBattleReport({version:4,player1,player2,turns:[{curTurn:1,actives:[{activeCamp:0,activePos:6,targets:[]}]}]})};
 };
 try{return action();}finally{Object.assign(combat,original);}
}
const request=()=>({mode:'pve',model:16100101,left:[{name:'Player',units:[unit(11100005)]}]});
test('solo Campaign continues after a fourth victory and clears all six real enemy armies',()=>withCombat((left,right)=>{left[0].hp-=7;right.forEach(u=>u.hp=0);},()=>{
 const result=rules.simulate(request(),{});assert.equal(result.won,true);assert.equal(result.rightWon,false);assert.equal(result.battles.length,6);assert.deepEqual(result.battles.map(b=>b.round),[1,2,3,4,5,6]);assert.deepEqual(result.battles.map(b=>b.enemyId),[30001001,30001002,30001003,30001004,30001005,30001006]);assert.deepEqual(result.battles.map(b=>b.leftHp),[993,986,979,972,965,958]);
 const event={_id:'six-armies',players:[{accountId:'player',name:'Player',mode:'pve',model:16100101,won:result.won,side:0,heroId:11100005,honor:20,items:[]}],battles:result.battles.map(({report,...b})=>b),reports:result.battles.map(b=>b.report)};
 const frames=playback.frames(playback.playback(event,'player'));assert.equal(frames.filter(f=>f.id===playback.OP.WAVE).length,6);assert.equal(frames.at(-1).payload.readUInt8(),0,'native final result is a victory only after all six armies');
}));
test('winning four armies does not grant victory if the player is defeated by the fifth',()=>{
 let fights=0;withCombat((left,right)=>{if(++fights===5)left.forEach(u=>u.hp=0);else right.forEach(u=>u.hp=0);},()=>{const result=rules.simulate(request(),{});assert.equal(result.won,false);assert.equal(result.rightWon,true);assert.equal(result.battles.length,5);assert.deepEqual(result.battles.map(b=>b.won),[true,true,true,true,false]);});
});
test('a three-player Campaign ends when all six armies are defeated in two waves',()=>withCombat((left,right)=>right.forEach(u=>u.hp=0),()=>{
 const r=request();r.left.push({name:'Player2',units:[unit(11100006)]},{name:'Player3',units:[unit(11100007)]});const result=rules.simulate(r,{});assert.equal(result.won,true);assert.deepEqual(result.battles.map(b=>b.round),[1,1,1,2,2,2]);
}));
test('a drawn duel terminates without an infinite relay or a false victory',()=>withCombat(()=>{},()=>{const result=rules.simulate(request(),{});assert.equal(result.won,false);assert.equal(result.battles.length,1);assert.equal(result.battles[0].draw,true);}));
