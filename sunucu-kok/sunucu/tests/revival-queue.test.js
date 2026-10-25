'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const battle=require('../savas'),t=require('../tsunade-combat'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:1000,resistance:1000,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
const cases=[];
for(const camp of [0,1]){
 const u=unit(t.config.heroId,1,camp),enemy=unit(12101003,1,1-camp);
 u.hp=1;enemy.atk=300;enemy.speed=1000;enemy.hp=enemy.maxHp=1000000;enemy.immuneDebuffs=true;
 const result=battle.kadroRapor(0,null,{ad:'Revival summon queue regression',birimler:camp?[u]:[enemy]},
  {playerUnits:camp?[enemy]:[u],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const players=[report.player1,report.player2];
 // Read decoder field names rather than hand-building a summon-only fixture.
 const roles=players.flatMap((player,c)=>player.roles.map(r=>({...r,camp:c})));
 const events=report.turns.flatMap(turn=>turn.actives.map(a=>({...a,turn:turn.curTurn})));
 const summon=events.findIndex(a=>a.activeCamp===camp&&a.skillEffectId===t.config.summoning.id);
 assert(summon>=0,'battle must actually summon after revival');
 const slugs=roles.filter(r=>r.roleId===11120993);assert.equal(slugs.length,3);assert(slugs.every(r=>r.curHealth===0));
 function queued(includeReserved){
  const keys=new Set(roles.filter(r=>r.curHealth>0||includeReserved&&r.roleId===11120993).map(r=>`${r.camp}:${r.pos}`));
  const missing=events.findIndex(a=>!keys.has(`${a.activeCamp}:${a.activePos}`)||a.targets.some(r=>!keys.has(`${r.targetCamp}:${r.targetPos}`)));
  return missing<0?events.length:missing;
 }
 const old=queued(false);assert(old<events.length,'old client truncation reproduced');assert(old<=summon);
 assert.equal(queued(true),events.length,'all remaining rounds must remain addressable');
 assert(events.slice(summon+1).some(a=>a.turn>events[summon].turn),'fixture continues past summon round');
 cases.push({camp,roles,events,oldQueued:old,fullQueued:events.length});
}
const output=path.resolve(__dirname,'../../cikarim/tsunade-asian/revival-queue/cases.json');
fs.writeFileSync(output,JSON.stringify(cases,null,2)+'\n');
console.log('PASS both camps: real encoded resurrection/summon reports reproduce early queue truncation; reserved actor registration preserves every subsequent round.');
