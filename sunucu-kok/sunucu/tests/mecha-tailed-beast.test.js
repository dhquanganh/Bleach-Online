'use strict';
const assert=require('node:assert/strict'),m=require('../mecha-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),p=require('../pain-combat'),k=require('../kabuto-combat'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:1000000,maxHp:1000000,atk:1000,magicAtk:1,def:100,resistance:1,speed:100,hitRate:1,critRate:0,anger:0,level:99,quality:7,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=1){const u=unit(m.config.heroId,pos,camp),enemies=Array.from({length:15},(_,i)=>unit(200,i+1,1-camp));const ctx=n.create(camp?[enemies,[u]]:[[u],enemies],{random:()=>.5});n.startRound(ctx,2);m.roundStart(ctx);return {u,enemies,ctx};}
function strike(f,move){const spec=m.prepareMove(f.ctx,f.u,f.enemies[0],move),frame=battle.vurus(f.u,f.enemies[0],false,f.enemies,()=>.5,false,[f.u],n.attackSpec(spec));const hit=f.enemies.filter(t=>frame.targets.some(r=>r.cmd===1&&r.targetCamp===t.camp&&r.targetPos===t.pos&&(r.reportTargetStatus&codec.ST.HIT)));m.afterHit(f.ctx,f.u,frame.comboTarget,hit,spec,frame);return frame;}
for(const camp of [0,1])for(let pos=1;pos<=15;pos++){
 const f=fixture(camp,pos),{u,ctx,enemies}=f;ctx.chakra[camp]=60;u.hp=u.maxHp*.6;
 const bomb=n.useMystery(ctx,u);assert.equal(bomb.id,13121101);assert.equal(u.mysteryReadyRound,4);
 const frame=strike(f,bomb);assert(m.beast(u));assert(frame.reactions.some(r=>r.skillEffectId===m.config.transform.id));
 assert.equal(n.profile(u).mystery.id,m.config.beastRecovery.id);assert.equal(n.profile(u).standard,null);assert.deepEqual(n.profile(u).chases,[]);assert(!m.available(ctx,u));assert.equal(n.useStandard(ctx,u,[u]),null);assert(!m.evade(ctx,u,{},()=>0));assert(k.armor(u));assert(s.status(u,'immuneDebuffs'));
 assert.equal(u.mysteryReadyRound,5,'new Mystery starts a real three-round cooldown');assert.equal(n.useMystery(ctx,u),null);
 n.startRound(ctx,3);m.roundStart(ctx);assert(m.beast(u));let req=m.roundRequests(ctx);assert.equal(req.length,1);assert.equal(req[0].move.id,m.config.beastSweep.id);assert.equal(m.roundRequests(ctx).length,0);
 const sweep=strike(f,req[0].move);assert.equal(new Set(sweep.targets.filter(r=>r.cmd===1&&r.targetCamp!==camp).map(r=>r.targetPos)).size,10);assert.equal(u.mechaBeastGrowth,1);assert.equal(u.mechaGrowth,1,'old Technology no longer triggers');
 n.startRound(ctx,4);m.roundStart(ctx);req=m.roundRequests(ctx);assert.equal(req[0].move.id,m.config.beastClaw.id);strike(f,req[0].move);assert(enemies.slice(0,5).every(t=>t.mechaMysteryLockUntil===4));enemies[0].mysteryReadyRound=1;assert(!p.canMystery(ctx,enemies[0],{}),'lock survives external cooldown reduction');
 assert.equal(n.useMystery(ctx,u),null);m.onAttacked(ctx,u);assert.equal(u.mysteryReadyRound,4);u.hp=400000;
 const recovery=n.useMystery(ctx,u);assert.equal(recovery.id,m.config.beastRecovery.id);assert.equal(u.mysteryReadyRound,7);strike(f,recovery);assert.equal(u.hp,520000);assert(m.advanced(u));assert(u.mechaExplosive);assert(k.armor({...u,kabutoArmorSuppressedUntil:4}));
 assert.equal(m.additional(u,recovery).id,m.config.beastBomb.id);assert.equal(m.additional(u,recovery),null);const additional=strike(f,m.config.beastBomb);assert.equal(new Set(additional.targets.filter(r=>r.cmd===1&&r.targetCamp!==camp).map(r=>r.targetPos)).size,12);
 const records=[];enemies[0].immuneDebuffs=true;m.onDamage(ctx,enemies[0],u,{damage:10},{damageType:'physical'},records);assert(enemies[0].skillBuffs.some(b=>b.mechaIgnition&&b.attackStat==='atk'&&b.damageType==='physical'),'Level 2 Ignition bypasses ordinary immunity');assert.equal(enemies[0].mechaInflammation,undefined,'ordinary immunity still resists plain Inflammation');
 assert(s.status(enemies[0],'noHeal'));
 delete enemies[0].immuneDebuffs;for(let i=0;i<8;i++)m.onDamage(ctx,enemies[0],u,{damage:10},{damageType:'physical'},records);assert.equal(enemies[0].mechaInflammation,4);const hp=enemies[0].hp;m.beforeAttack(enemies[0],{damageType:'physical'},records);assert.equal(hp-enemies[0].hp,40000,'explicit Inflammation uses 1% max HP per layer');
 const burn=m.ignitionDamage(u,enemies[0]);enemies[0].resistance=999999;u.magicAtk=999999;assert.equal(m.ignitionDamage(u,enemies[0]),burn);enemies[0].def=100000;assert(m.ignitionDamage(u,enemies[0])<burn);
 n.startRound(ctx,5);m.roundStart(ctx);assert(m.beast(u));assert(!m.advanced(u));assert(p.canMystery(ctx,enemies[0],{}));
 const fresh=n.create(ctx.teams);n.startRound(fresh,1);assert(!m.beast(u));assert.equal(n.profile(u).standard.id,m.config.standard.id);assert.equal(enemies[0].mechaInflammation,undefined);assert(!enemies[0].skillBuffs.some(b=>b.mechaIgnition),'Ignition cannot leak into a fresh battle');
}
for(const move of [m.config.beastBomb,m.config.beastClaw,m.config.beastSweep])for(const camp of [0,1]){
 const damage=(a={},t={})=>{const f=fixture(camp);f.u.mechaBeast=true;Object.assign(f.u,a);Object.assign(f.enemies[0],t);const frame=battle.vurus(f.u,f.enemies[0],false,[f.enemies[0]],()=>.5,false,[f.u],n.attackSpec(move));return frame.targets.filter(r=>r.cmd===1&&r.targetCamp!==camp).reduce((v,r)=>v+Math.max(0,r.result.hurtHp||0),0);};
 assert.equal(move.attackStat,'atk');assert.equal(move.damageType,'physical');const base=damage();assert(base>0);assert(damage({atk:2000})>base);assert(damage({},{def:10000})<base);assert.equal(damage({magicAtk:999999},{resistance:999999}),base);
}
for(const camp of [0,1]){
 const f=fixture(camp,15);f.u.speed=1000;for(const t of f.enemies)t.atk=500;
 const result=battle.kadroRapor(0,null,{ad:'Permanent Mecha Kurama',birimler:camp?[f.u]:f.enemies},{playerUnits:camp?f.enemies:[f.u],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);const acts=report.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===camp&&a.activePos===15);const at=acts.findIndex(a=>a.skillEffectId===m.config.transform.id);assert(at>=0);assert.equal(acts.filter(a=>a.skillEffectId===m.config.transform.id).length,1);
 const after=acts.slice(at+1);assert(!after.some(a=>[13121101,13121102,13121103,13121104,13121105,13121106,13121107,13121108].includes(a.skillEffectId)));assert(after.some(a=>a.skillEffectId===m.config.beastRecovery.id));assert(after.some(a=>a.skillEffectId===m.config.beastBomb.id));assert(after.some(a=>a.skillEffectId===m.config.beastClaw.id));assert(after.some(a=>a.skillEffectId===m.config.beastSweep.id));
}
console.log('PASS permanent Tailed Beast Mode: all slots/both camps, true skill replacement, base CD2/new Mystery CD3, attack reductions, odd/even triggers, splash, 12% heal, Advanced/Super Armor II, physical attacks/Ignition, Inflammation HP formula, fresh battles and real encoded scheduling.');
