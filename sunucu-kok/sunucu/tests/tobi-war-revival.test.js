'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),battle=require('../savas'),k=require('../tobi-war-combat'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:500,resistance:500,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
const cases=[];
for(const camp of [0,1]){
 const u=unit(k.config.heroId,1,camp),enemy=unit(12101003,1,1-camp);u.hp=5000;enemy.atk=4000;enemy.speed=1000;enemy.hp=enemy.maxHp=1000000;enemy.immuneDebuffs=true;
 const result=battle.kadroRapor(0,null,{ad:'Tobi fatal-hit summon replay',birimler:camp?[u]:[enemy]},{playerUnits:camp?[enemy]:[u],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const roles=[report.player1,report.player2].flatMap((player,c)=>player.roles.map(r=>({...r,camp:c}))),events=report.turns.flatMap(turn=>turn.actives.map(a=>({...a,turn:turn.curTurn})));
 const summons=roles.filter(r=>r.roleId===k.config.summonId);assert.equal(summons.length,2);assert(summons.every(r=>r.curHealth===0));
 const liveKeys=new Set(roles.filter(r=>r.curHealth>0).map(r=>`${r.camp}:${r.pos}`)),allKeys=new Set(roles.map(r=>`${r.camp}:${r.pos}`));
 const missing=events.findIndex(a=>a.targets.some(r=>!liveKeys.has(`${r.targetCamp}:${r.targetPos}`)));assert(missing>=0);
 assert(events.every(a=>allKeys.has(`${a.activeCamp}:${a.activePos}`)&&a.targets.every(r=>allKeys.has(`${r.targetCamp}:${r.targetPos}`))));
 const revives=events.map((e,i)=>[e,i]).filter(([e])=>e.skillEffectId===13121807);assert(revives.length>=2,'actual battle repeatedly revives using Zetsu');
 for(const [e,i]of revives){const before=events[i-1];assert.equal(before.activeType,4);assert(before.targets.some(r=>r.targetCamp===camp&&r.targetPos===u.pos&&r.result.hurtHp===-4000));assert(before.targets.some(r=>r.targetCamp===camp&&r.targetPos!==u.pos&&r.result.hurtHp>0));}
 assert(events.some(e=>e.turn>revives[0][0].turn),'battle must continue after the first revival');
 cases.push({camp,roles,events,oldQueued:missing,fullQueued:events.length,revivals:revives.length});
}
const dir=path.resolve(__dirname,'../../cikarim/tobi-war/validation');fs.mkdirSync(dir,{recursive:true});fs.writeFileSync(path.join(dir,'revival-cases.json'),JSON.stringify(cases,null,2)+'\n');
console.log('PASS Tobi encoded reports: both camps, repeated 40% HP resurrection, consumed Zetsu HP, HP-before-animation ordering, reserved actor references and subsequent rounds.');
