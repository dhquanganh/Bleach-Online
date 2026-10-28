'use strict';
const assert=require('node:assert/strict'),m=require('../madara-final-combat'),n=require('../naruto-combat'),skills=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({...battle.heroBirim(id,pos,159,null,null,0,true),camp,hp:500000,maxHp:500000,critRate:0});
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),enemy=unit(11100001,1,1-camp),teams=camp?[[enemy],[u]]:[[u],[enemy]];
 m.prepareSummons(teams);const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);
 const clone=teams[camp].find(v=>v.madaraOwner===u);assert(clone&&clone.hp===0);
 const entry=m.battleStart(ctx);assert.equal(clone.hp,Math.round(u.maxHp*.6));assert.equal(entry[0].targets[0].result.hurtHp,-clone.hp);
 assert.equal(m.profile(u).mystery.id,m.config.mystery.id);
 assert(m.pureImmune(u,{pureTaijutsu:true}));assert(!m.pureImmune(u,{damageType:'physical'}),'physical conversion does not make elemental moves pure Taijutsu');
 for(let i=0;i<4;i++)m.onDamage(ctx,enemy,u,{damage:1},m.config.chase,false,[]);
 assert.equal(u.madaraTechnique,0);assert.equal(m.profile(u).mystery.id,m.config.burstMystery.id);assert.equal(m.profile(u).standard.id,m.config.burstStandard.id);
 assert.equal(skills.armor(u),true);u.armorSuppressedUntil=1;assert.equal(skills.armor(u),true,'Level 2 Super Armor survives lower-level suppression');
 const afflicted=unit(11100001,2,1-camp);afflicted.madaraInfernoUntil=2;afflicted.battleRound=1;
 m.onDamage(ctx,afflicted,u,{damage:1},{},false,[]);assert.equal(afflicted.madaraInfernoStacks,1);assert.equal(m.factor(afflicted,'resistance'),.97);
 afflicted.battleRound=3;assert.equal(m.factor(afflicted,'resistance'),1,'Inferno shred expires with Inferno');
 const before=skills.value(u,'atk');m.onDamage(ctx,u,enemy,{damage:1},m.config.burstMystery,true,[]);assert(skills.value(u,'atk')>before);
 const magic=skills.value(u,'magicAtk'),attack=skills.value(u,'atk');assert(m.evade(ctx,u,{}));assert(skills.value(u,'atk')>attack);assert.equal(skills.value(u,'magicAtk'),magic);
 u.hp=u.maxHp*.1;const reflected={targets:[],reactions:[]};m.afterHit(ctx,u,enemy,[enemy],m.config.reflection,reflected);assert.equal(u.hp,u.maxHp*.6,'Reflection heals 50% max HP');
 const damage=m.beforeDamage(ctx,u,u.hp+100);assert.equal(damage,u.hp-1);u.hp=1;const healed=[];m.onDamage(ctx,enemy,u,{damage},m.config.chase,false,healed);assert.equal(u.hp,Math.round(u.maxHp*.3));assert(healed.length);
 assert.equal(m.beforeDamage(ctx,u,u.hp+1),u.hp+1,'entry protection is consumed exactly once');
 ctx.madaraQueue=[];m.onDamage(ctx,enemy,clone,{damage:1},{trigger:true},false,[]);m.onDamage(ctx,enemy,clone,{damage:1},{trigger:true},false,[]);assert.equal(m.triggers(ctx).length,1,'clone counter has a finite per-round budget');
 const victims=Array.from({length:9},(_,i)=>unit(11100001,i+1,1-camp));
 for(const move of [m.config.mystery,m.config.burstMystery,m.config.chase,m.config.burstChase,m.config.complete])assert.equal(m.targets(ctx,u,move,victims[0],victims).length,9);
 const frame={targets:[],reactions:[]};m.afterHit(ctx,u,enemy,[enemy],m.config.mystery,frame);assert(m.triggers(ctx).some(r=>r.move.id===m.config.complete.id));assert.equal(enemy.madaraCombustionUntil,2);
 m.endRound(ctx);assert.equal(m.profile(u).mystery.id,m.config.mystery.id);assert(u.madaraChaseStacks>=2);
}
for(const move of Object.values(m.config).filter(x=>x&&typeof x==='object'&&x.multiplier>0)){assert.equal(move.attackStat,'atk');assert.equal(move.damageType,'physical');}
// Exercise the actual scheduler, summoned actor registration, multi-hit combo,
// both camps, full-team damage and finite completion in the binary report.
for(const camp of [0,1]){
 const own=[unit(m.config.heroId,1,camp)],enemies=[unit(11100001,1,1-camp),unit(11100002,6,1-camp),unit(11100003,11,1-camp)];
 for(const u of [...own,...enemies]){u.hp=u.maxHp=200000;u.atk=10000;u.def=5000;u.resistance=5000;}
 const result=battle.kadroRapor(0,null,{ad:'Madara isolated regression',birimler:camp?own:enemies},{playerUnits:camp?enemies:own,playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const all=report.turns.flatMap(t=>t.actives),moves=all.filter(e=>e.activeCamp===camp&&e.activePos===1);
 assert(moves.some(e=>e.skillEffectId===m.config.summon.id));assert(moves.some(e=>e.skillEffectId===m.config.mystery.id));assert(moves.some(e=>e.skillEffectId===m.config.complete.id));
 assert(moves.some(e=>e.skillEffectId===m.config.chase.id),'20 combo must execute Madara chase');
 const hit=moves.find(e=>e.skillEffectId===m.config.mystery.id);assert.equal(new Set(hit.targets.filter(t=>t.targetCamp!==camp&&t.result.hurtHp>0).map(t=>t.targetPos)).size,3);
 assert((camp?report.player2:report.player1).roles.some(r=>r.roleId===m.config.summonId));
 assert(report.turns.length<=20);
}
{
 const actor=unit(m.config.heroId,1,0),target=unit(11100001,1,1);target.shield=10000000;
 const teams=[[actor],[target]],ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);
 const frame=battle.vurus(actor,target,false,[target],()=>.5,false,[actor],n.attackSpec(m.config.burstMystery));
 assert(frame.targets.some(r=>r.targetCamp===1&&r.result.hurtHp>0),'burst Mystery bypasses shield');
 assert.equal(target.shield,10000000,'neglecting Shields does not dispel them');
}
console.log('PASS Madara: physical moves, 2-state kit, 20-combo chase, all-enemy Mystery, reserved 60% clone, finite counter, first-fatal protection, buffs and binary reports in both camps.');
