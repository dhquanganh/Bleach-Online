'use strict';
const crypto=require('node:crypto');
const LEVEL=159, HP=100000, SLOTS=90;
let roster=[],scoreboard=null;
function updateScores(board){if(!board||!board.scores)return;if(scoreboard&&(board.season<scoreboard.season||(board.season===scoreboard.season&&board.revision<=scoreboard.revision)))return;scoreboard=board;return true;}
function score(accountId,season){return scoreboard?.season===season&&Object.hasOwn(scoreboard.scores,accountId)?scoreboard.scores[accountId]:null;}
function ownScore(season){return score(self(),season);}
const self=()=>process.env.BLEACH_ACCOUNT_ID||'';
function update(rows){
  roster=(Array.isArray(rows)?rows:[]).filter(row=>row.accountId&&row.accountId!==self()&&Array.isArray(row.units)&&row.units.length)
    .map(row=>{const units=row.units.filter(u=>Number.isInteger(Number(u.pos))&&Number(u.pos)>0&&Number(u.pos)<=15&&baseUnit(u));return {accountId:row.accountId,name:row.name||'Player',server:'Local',score:Math.max(0,Number(row.crossScore)||0),quality:Math.max(1,Number(units[0]?.quality)||3),heroes:units.map(u=>u.id),positions:units.map(u=>u.pos),units};})
    .filter(row=>row.units.length).sort((a,b)=>a.accountId.localeCompare(b.accountId));
}
function code(id,slot){return (crypto.createHash('sha256').update(id+':'+slot).digest().readUInt32BE(0)||1)>>>0;}
function accounts(){return roster.map(row=>({...row,score:scoreboard&&Object.hasOwn(scoreboard.scores,row.accountId)?scoreboard.scores[row.accountId]:row.score}));}
function all(){
  if(!roster.length)return [];
  const out=[],used=new Set();
  for(let slot=0;slot<Math.max(SLOTS,roster.length);slot++){
    const source=accounts()[slot%roster.length];let id=code(source.accountId,Math.floor(slot/roster.length));
    while(used.has(id))id=(id+1)>>>0||1;
    used.add(id);out.push({...source,id,slot,level:LEVEL});
  }
  return out;
}
function get(id){return all().find(row=>row.id===(Number(id)>>>0))||null;}
function baseUnit(unit){
  const built=require('./savas').heroBirim(Number(unit.id),Number(unit.pos),LEVEL,null,null,0,true);
  if(!built)return null;
  // Cross Server alone uses fixed starting HP; combat skills retain their normal effects.
  built.level=LEVEL;built.hp=built.maxHp=HP;built.partnerSkills=[];built.weaponSkills=[];built.zanpakutoId=0;
  return built;
}
function units(row){return row.units.map(baseUnit).filter(Boolean);}
function ownUnits(state){
  const main=Number(state?.karakter?.anaId)||require('./seviye').anaId();
  if(!main)return [];
  const formation=state?.kadro||{};
  const fallback=Number(require('./statlar').anaKaynak()?.pos)||6;
  const mainPos=Number(formation[String(main)])>0?Number(formation[String(main)]):fallback;
  const entries=[{id:main,pos:mainPos}];
  for(const [id,pos] of Object.entries(formation))if(Number(id)!==main&&Number(pos)>0)entries.push({id:Number(id),pos:Number(pos)});
  return entries.map(baseUnit).filter(Boolean);
}
function team(id){const row=get(id);if(!row)return null;return {...row,baseLevel:LEVEL,level:LEVEL,units:units(row)};}
module.exports={updateScores,ownScore,LEVEL,HP,update,accounts,all,get,team,units,ownUnits,baseUnit};
