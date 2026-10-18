"use strict";
const {Y,O,tablo,simdi}=require('./paket'),savas=require('./savas'),codec=require('./kodek'),env=require('./envanter');
const STONE=14100698,CRYSTAL=14100779,BACKGROUND_POINT=15910001,INIT=0x0181f100,FIGHT=0x0181f101,STATE=0x01180a7e,RET=0x01180a7f;
const models=require('./tower-gold-models');
const clamp=n=>Math.max(1,Math.min(1000000000,Math.round(n)));
const heroes=tablo('BaseHero').liste.filter(h=>Number(h.isMain)!==1&&h._id>=11100000&&h._id<11200000&&Number(h.quality)>0&&models.allowed(h._id)&&savas.heroBirim(h._id,6,1,null,null,0,true)).sort((a,b)=>Number(a.quality)-Number(b.quality)||a._id-b._id);
function state(d){if(!d.towerGold)d.towerGold={floor:1,records:{}};const s=d.towerGold;if(!Number.isSafeInteger(s.floor)||s.floor<1)s.floor=1;s.records=s.records||{};return s;}
function rewards(floor){return [{type:0,code:1,amount:Math.min(50000,floor*100)},{type:1,code:STONE,amount:Math.min(500,floor)},{type:1,code:CRYSTAL,amount:Math.min(500,floor)}];}
// Polynomial growth: increasing absolute gaps without exponential doubling.
function statMultiplier(floor){const n=floor-1;return 1+0.5*n+0.1*n*n;}
function lineup(floor){
 if(!Number.isSafeInteger(floor)||floor<1)throw Error('Invalid floor');
 const tier=Math.min(heroes.length-1,Math.floor(Math.log2(floor+1)*heroes.length/12));
 const count=floor<20?1:floor<50?3:5,positions=[6,1,11,7,2],list=[];
 for(let i=0;i<count;i++){
  const index=Math.max(0,Math.min(heroes.length-1,tier-i));const h=heroes[index];
  const u=savas.heroBirim(h._id,positions[i],floor,null,null,0,true);
  // Tower-only progression with progressively wider gaps between floors.
  // Saturate at the existing safe combat limit, without overflowing Number/Flash integers.
  const multiplier=statMultiplier(floor);
  u.camp=1;u.hp=u.maxHp=clamp(600*multiplier);u.atk=clamp(35*multiplier);
  u.def=clamp(10*multiplier);u.speed=clamp(10*multiplier);
  u.level=floor;u.reportLevel=Math.min(32767,floor);
  list.push(u);
 }
 return list;
}
function info(d){const s=state(d),saved=s.records[String(s.floor-1)]||null,last=saved?{first:{name:saved.first.name,time:saved.first.time,turns:saved.first.turns},best:{name:saved.best.name,time:saved.best.time,turns:saved.best.turns}}:null;return {name:'Tower of Gold',floor:s.floor,backgroundPoint:BACKGROUND_POINT,preview:Array.from({length:5},(_,i)=>{const f=s.floor+i,team=lineup(f);return {floor:f,name:team[0].isim,heroId:team[0].id,level:f,rewards:rewards(f),count:team.length};}),lastDefeat:last,recordsFloor:s.floor-1};}
function packet(d){return new Y().utf(JSON.stringify(info(d))).done();}
function fight(d,floor,mode){
 if(!Number.isSafeInteger(floor)||floor<1||floor>state(d).floor||!['first','best',null,undefined].includes(mode))return null;
 if(mode==='first'||mode==='best'){
  const record=state(d).records[String(floor)];
  if(!record||!record[mode]||!record[mode].report)return null;
  let cached;try{cached=codec.decodeBattleReport(Buffer.from(record[mode].report,'base64'));if(cached._consumed!==cached._total)return null;}catch{return null;}
  if(cached.player2.roles.some(role=>!models.allowed(role.roleId)))return null;
  return {floor,won:true,replay:true,turns:record[mode].turns,frames:[{id:codec.OP.REPORT,payload:Buffer.from(record[mode].report,'base64')},{id:codec.OP.RESULT,payload:codec.encodeSingleResult(true,[])}]};
 }

 const s=state(d);if(floor>s.floor||floor<1||(floor<s.floor&&!s.records[String(floor)]))return null;
 const report=savas.kadroRapor(0,null,{ad:'Tower of Gold '+floor,birimler:lineup(floor)},{playerState:d,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,strictSkillTargets:true});
 if(!report)throw Error('Unable to build Tower of Gold battle');
 const turns=codec.decodeBattleReport(report.payload).turns.length;
 return {floor,won:report.won,turns,frames:[{id:codec.OP.REPORT,payload:report.payload},{id:codec.OP.RESULT,payload:codec.encodeSingleResult(report.won,report.won&&floor===s.floor?rewards(floor):[])}]};
}
function complete(d,result){const s=state(d);if(!result||result.replay||!result.won||!Number.isSafeInteger(result.floor)||result.floor<1||result.floor>s.floor)return [];
 const record={name:d.nick||'Shinigami',time:simdi(),turns:result.turns,report:result.frames[0].payload.toString('base64')};
 if(result.floor<s.floor){const old=s.records[String(result.floor)];if(old&&record.turns<old.best.turns)old.best=record;return [];}
 const previous=s.records[String(s.floor-1)];if(previous){delete previous.first.report;delete previous.best.report;}
 s.records[String(s.floor)]={first:{...record},best:{...record}};s.floor++;return rewards(result.floor);}
function readFloor(payload){try{const o=new O(payload),v=JSON.parse(o.utf());return v&&typeof v==='object'&&!Array.isArray(v)&&o.kalan()===0&&Number.isSafeInteger(v.floor)&&v.floor>0&&(v.mode==null||v.mode==='first'||v.mode==='best')?v.floor:0;}catch(e){return 0;}}
function readMode(payload){try{const o=new O(payload),v=JSON.parse(o.utf());return v.mode==='first'||v.mode==='best'?v.mode:null;}catch(e){return null;}}
module.exports={statMultiplier,heroIds:heroes.map(h=>h._id),readMode,STONE,CRYSTAL,BACKGROUND_POINT,INIT,FIGHT,STATE,RET,state,rewards,lineup,info,packet,fight,complete,readFloor};
