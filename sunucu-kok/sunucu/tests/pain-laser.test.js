'use strict';
const assert=require('node:assert/strict'),p=require('../pain-combat'),n=require('../naruto-combat'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:1,magicAtk:1,def:0,resistance:0,speed:1,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
const pain=camp=>({...unit(p.config.heroId,6,camp),hp:1000000,maxHp:1000000,atk:20000,magicAtk:1,speed:1000,normal:p.config.standard.id,skill:p.config.mystery.id,skillId:p.config.mystery.id});
assert.equal(p.config.laser.target,'all');assert.equal(p.config.laser.attackStat,'atk');
for(const camp of [0,1]){
  const actor=pain(camp),opponents=Array.from({length:15},(_,i)=>unit(12101003,i+1,1-camp));
  const dead={...unit(200,16,1-camp),hp:0},auxiliary={...unit(201,17,1-camp),auxiliary:true};
  assert.deepEqual(p.targetList(p.config.laser,opponents[0],[...opponents,dead,auxiliary]),opponents);
  assert.deepEqual(p.targetList(p.config.laser,opponents[5],opponents.slice(5)),opponents.slice(5),'No front row required to fire at middle/back rows');
  const teams=camp?[opponents,[actor]]:[[actor],opponents],ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);ctx.chakra[1-camp]=100;
  const frame=battle.vurus(actor,opponents[0],false,opponents,()=>.5,false,[actor],n.attackSpec(p.config.laser));
  const attacked=frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp===1-camp);
  assert.equal(attacked.length,15);assert.equal(new Set(attacked.map(r=>r.targetPos)).size,15);
  assert(attacked.every(r=>r.result.hurtHp>0));
  p.afterHit(ctx,actor,opponents[0],opponents,p.config.laser,frame);
  assert.equal(actor.painTechnique,1,'One Technique Point per cast, not per target');
  assert.equal(ctx.chakra[1-camp],0,'Chakra drain must never make the shared pool negative');
  assert.equal(actor.painLaserRound,1);assert(p.active(actor,'painUnavoidableUntil'));assert(p.active(actor,'painInterruptImmuneUntil'));
  n.startRound(ctx,2);assert.equal(p.roundStart(ctx).length,1);n.startRound(ctx,3);assert.equal(p.roundStart(ctx).length,1);

  // Check the actual report scheduler, including when the defending camp owns Pain.
  const nativeActor=pain(camp),nativeTargets=Array.from({length:15},(_,i)=>unit(12101003,i+1,1-camp));
  const own=camp?nativeTargets:[nativeActor],enemy=camp?[nativeActor]:nativeTargets;
  const result=battle.kadroRapor(0,null,{ad:'Pain all-enemy laser',birimler:enemy},{playerUnits:own,playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
  const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
  const laser=report.turns.flatMap(t=>t.actives).find(a=>a.activeCamp===camp&&a.skillEffectId===p.config.laser.id);
  assert(laser,'Round-start Laser must execute');
  const hits=laser.targets.filter(t=>t.cmd===codec.CMD.ATTACK&&t.targetCamp===1-camp&&t.result.hurtHp>0);
  assert.deepEqual(hits.map(h=>h.targetPos).sort((a,b)=>a-b),Array.from({length:15},(_,i)=>i+1));
}
console.log('PASS Pain Laser: all 15 enemy slots/both camps, middle/back-only formations, excludes dead/auxiliary units, one hit per victim, one TP per cast, bounded Chakra drain, unchanged recovery and actual encoded round-start reports.');
