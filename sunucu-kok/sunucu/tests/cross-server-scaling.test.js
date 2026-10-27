'use strict';
const assert=require('node:assert/strict');
const fs=require('node:fs'),path=require('node:path');
const players=require('../cross-server-players'),battle=require('../savas');
const codec=require('../kodek');
const skillValues=require('../hero-skills');
const snapshot=[{id:11120997,pos:1,level:30,maxHp:800000000,atk:800000000,def:800000000},{id:11120940,pos:6,level:50,maxHp:1,atk:1,def:1}];
players.update([{accountId:'opponent',name:'Real Player',units:snapshot}]);
const team=players.team(players.all()[0].id);
assert.equal(team.level,159);assert.equal(team.units.length,2);
for(const unit of team.units){
  const template=battle.heroBirim(unit.id,unit.pos,159,null,null,0,true);
  const growth=require('../seviye').buyumeTemeli(unit.id,159);
  assert.equal(unit.level,159);assert.equal(unit.maxHp,template.maxHp);assert.equal(unit.atk,template.atk);assert.equal(unit.def,Math.round(growth.combat*.3));
  assert.equal(unit.hp,unit.maxHp);assert.equal(unit.magicAtk,Math.round(growth.intelligence*.6));assert.equal(unit.resistance,Math.round(growth.intelligence*.3));
}
const skillAttacker=players.baseUnit({id:11120997,pos:1,atk:800000000,skillBuffs:[{field:'atk',value:9,remaining:99}]});
assert.equal(skillValues.value(skillAttacker,'atk'),skillAttacker.atk,'saved buffs do not enter Cross Server');
skillAttacker.skillBuffs=[{kind:'buff',field:'atk',value:.5,remaining:2,source:skillAttacker.id}];
assert.equal(skillValues.value(skillAttacker,'atk'),skillAttacker.atk*1.5,'ATK buff cast during combat still applies');
skillAttacker.skillBuffs=[];skillAttacker.kakuzuAttackStacks=1;
assert.equal(skillValues.value(skillAttacker,'atk'),skillAttacker.atk*1.4,'character passive ATK multiplier still applies');
const skillDefender=players.baseUnit({id:11120940,pos:6,def:800000000});
const records=[];
skillValues.apply({id:13121001,effects:[{kind:'buff',scope:'s',field:'atk',value:.25,turns:2},{kind:'buff',scope:'s',field:'def',value:.5,turns:2}]},skillDefender,[skillDefender],[],[],records,()=>.5);
assert.equal(skillValues.value(skillDefender,'atk'),skillDefender.atk*1.25,'skill ATK multiplier remains active');
assert.equal(skillValues.value(skillDefender,'def'),skillDefender.def*1.5,'skill DEF multiplier remains active');
skillDefender.hashTechnique=1;
assert.equal(skillValues.value(skillDefender,'def'),skillDefender.def*1.5*1.2,'character passive DEF multiplier stacks with the skill buff');
players.update([]);assert.equal(players.all().length,0);assert.equal(players.team(team.id),null);
const state=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'),'utf8'));
const knife=require('../paket').tablo('KnifeExpand').liste.find(row=>Number(row.level)===1);
const armedState=structuredClone(state),bareState=structuredClone(state);
armedState.zanpakuto={[knife._id]:{id:knife._id,exp:0,strength:[100,100,100]}};
armedState.bicak={acik:[knife._id],sekil:knife._id,guc:{}};
delete bareState.zanpakuto;bareState.bicak={acik:[],sekil:0,guc:{}};
assert(require('../zanpakuto').selected(armedState),'test account has an equipped Zanpakuto');
const contaminated=snapshot.map(u=>({...u,partnerSkills:[{id:999}],weaponSkills:[{id:999}],zanpakutoId:999,rebirth:{n:9},pvpStats:{hp:900000000,atk:900000000,def:900000000}}));
const report=battle.kadroRapor(0,{name:'Real Player',level:159,units:contaminated},null,{playerState:armedState,playerUnits:contaminated,crossServerBaseOnly:true,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4,random:()=>.5});
const clean=snapshot.map(({id,pos})=>({id,pos}));
const baseline=battle.kadroRapor(0,{name:'Real Player',level:159,units:clean},null,{playerState:bareState,playerUnits:clean,crossServerBaseOnly:true,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4,random:()=>.5});
assert(report.payload.equals(baseline.payload),'equipped Zanpakuto, materialization, equipment, stones, PvP stats and external skills cannot change the combat report');
const decoded=codec.decodeBattleReport(report.payload);
for(const side of [decoded.player1,decoded.player2]){
  assert.equal(side.knifeOfKillSoulID,0);
  for(const role of side.roles){const source=team.units.find(u=>u.id===role.roleId);if(!source)continue;assert.equal(role.level,159);assert.equal(role.rebirthNum,0);assert.equal(role.totalHealth,source.maxHp);}
}
console.log('PASS Cross Server: level 159 character base growth ignores saved equipment stats and has no generated fallback.');
