'use strict';
const assert=require('node:assert/strict'),m=require('../mecha-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),p=require('../pain-combat'),b=require('../savas'),{CMD,ACTIVE,ST}=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:100000,maxHp:100000,atk:1000,magicAtk:10,def:100,resistance:10,speed:100,hitRate:1,critRate:0,anger:0,level:99,quality:7,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=1){const u=unit(m.config.heroId,pos,camp),enemies=Array.from({length:15},(_,i)=>unit(200,i+1,1-camp)),ally=unit(201,2,camp);const ctx=n.create(camp?[enemies,[u,ally]]:[[u,ally],enemies],{random:()=>.5});n.startRound(ctx,1);m.roundStart(ctx);return {u,enemies,ally,ctx};}
function strike(f,move){const prepared=m.prepareMove(f.ctx,f.u,f.enemies[0],move),frame=b.vurus(f.u,f.enemies[0],false,f.enemies,()=>.5,false,[f.u],n.attackSpec(prepared));const hit=f.enemies.filter(t=>frame.targets.some(r=>r.cmd===CMD.ATTACK&&r.targetCamp===t.camp&&r.targetPos===t.pos&&(r.reportTargetStatus&ST.HIT)));m.afterHit(f.ctx,f.u,frame.comboTarget,hit,prepared,frame);return frame;}
for(const camp of [0,1])for(let pos=1;pos<=15;pos++){
 let f=fixture(camp,pos),{u,ctx,enemies,ally}=f;
 assert.equal(n.profile(u).assess,'SSS');assert(s.status(u,'immuneDebuffs'));
 ctx.chakra[camp]=50;assert.equal(n.useStandard(ctx,u,[u]).id,m.config.standard.id);
 n.startRound(ctx,2);m.roundStart(ctx);ctx.chakra[camp]=51;assert.equal(n.useStandard(ctx,u,[u]).id,m.config.beam.id);
 u.hp=u.maxHp*.6;ctx.chakra[camp]=60;assert.equal(n.useMystery(ctx,u).id,m.config.mystery.id);assert.equal(ctx.chakra[camp],20);assert.equal(n.useMystery(ctx,u),null);
 n.startRound(ctx,4);m.roundStart(ctx);u.hp=u.maxHp*.6+1;ctx.chakra[camp]=40;assert.equal(n.useMystery(ctx,u).id,m.config.highHpMystery.id);
 f=fixture(camp,pos);({u,ctx,enemies,ally}=f);enemies[7].hp=10000;let frame=strike(f,m.config.standard);assert.equal(frame.comboTarget,enemies[7]);assert.equal(enemies[7].kabutoArmorSuppressedUntil,1);
 assert.equal(s.value(u,'atk'),1150);assert.equal(s.value(u,'critRate'),.08);
 for(let i=0;i<8;i++)strike(f,m.config.beam);assert.equal(u.mechaGrowth,6);assert.equal(u.mechaGrowthThisRound,6);assert.equal(p.mysteryCost(ctx,ally,{chakraCost:40}),0);
 n.startRound(ctx,2);m.roundStart(ctx);assert.equal(p.mysteryCost(ctx,ally,{chakraCost:40}),40);assert.equal(u.mechaGrowth,6);
 f=fixture(camp,pos);({u,ctx,enemies}=f);u.mysteryReadyRound=5;for(const e of enemies)e.mysteryReadyRound=5;
 frame=strike(f,m.config.extremeBeam);assert.equal(new Set(frame.targets.filter(t=>t.cmd===1&&t.targetCamp!==camp).map(t=>t.targetPos)).size,5);assert.equal(u.mysteryReadyRound,4);assert.equal(enemies.filter(e=>e.mysteryReadyRound===6).length,1);
 f=fixture(camp,pos);({u,ctx,enemies}=f);frame=strike(f,m.config.mystery);assert.equal(new Set(frame.targets.filter(t=>t.cmd===1&&t.targetCamp!==camp).map(t=>t.targetPos)).size,15);assert.equal(enemies[0].painInterruptedUntil,1);assert.equal(enemies[0].mysteryReadyRound,2);assert(enemies.slice(1).every(e=>e.painInterruptedUntil===undefined));
 frame=strike(f,m.config.highHpMystery);assert.equal(new Set(frame.targets.filter(t=>t.cmd===1&&t.targetCamp!==camp).map(t=>t.targetPos)).size,9);
 f=fixture(camp,pos);({u,ctx,enemies}=f);strike(f,m.config.chases[0]);assert.equal(enemies[0].suppressedUntil,1);assert.equal(u.mechaExtra,1);assert.equal(n.useStandard(ctx,enemies[0],enemies),null); // ordinary units have no ninja profile, verify loss separately below
 assert.equal(m.prepareMove(ctx,u,enemies[0],m.config.chases[0]).id,m.config.modifiedChase.id);strike(f,m.config.chases[0]);assert.equal(enemies[0].immobileUntil,1);assert.equal(u.mechaExtra,1,'cannot steal an already lost standard twice');
 u.immobileUntil=1;u.skillBuffs=[{field:'stun',remaining:1}];assert(m.evade(ctx,u,{activeType:ACTIVE.NORMAL},()=>0));assert(!m.evade(ctx,u,{activeType:ACTIVE.NORMAL},()=>0));for(let i=0;i<4;i++)assert(m.evade(ctx,u,{activeType:ACTIVE.NORMAL_EX},()=>0));const requests=m.triggers(ctx);assert.equal(requests.length,3);assert.equal(ctx.chakra[camp],80);assert(requests.every(r=>r.move.id===m.config.extremeBeam.id));
}
{
 const f=fixture(),target=f.enemies[0];
 const opener=()=>({targets:[{cmd:CMD.ATTACK,targetCamp:1,targetPos:1,reportTargetStatus:ST.HIT,result:{hurtHp:1}}]});
 const run=()=>n.resolve(f.ctx,f.ally,target,opener(),{causes:'knockdown'},()=>strike(f,m.config.chases[0]));
 const first=run(),second=run();assert(first.some(a=>a.skillEffectId===m.config.chases[0].id));assert(second.some(a=>a.skillEffectId===m.config.modifiedChase.id));assert.equal(run().length,0,'base and modified share two per-round charges');
 assert.equal(f.u.mechaExtra,1,'two chases cannot duplicate the same stolen standard');
 const g=fixture();g.ctx.primaryActions.set(g.enemies[0],g.ctx.round);strike(g,m.config.chases[0]);assert.equal(g.u.mechaExtra,0,'already completed standard cannot be stolen');
 const stale=fixture();stale.enemies[0].hashStandardLoss=7;stale.enemies[0].hashStandardLossRound=0;strike(stale,m.config.chases[0]);assert.equal(stale.enemies[0].hashStandardLoss,1,'expired losses do not carry into newly stolen actions');
 const j=fixture();assert(!m.evade(j.ctx,j.u,{activeType:ACTIVE.NORMAL_EX},()=>.45));assert(m.evade(j.ctx,j.u,{activeType:ACTIVE.NORMAL_EX},()=>.449));
}
for(const move of [m.config.mystery,m.config.highHpMystery,m.config.standard,m.config.beam,m.config.extremeBeam,m.config.modifiedChase,...m.config.chases])for(const camp of [0,1]){
 const damage=(a={},t={})=>{const f=fixture(camp);Object.assign(f.u,a);Object.assign(f.enemies[0],t);const x=b.vurus(f.u,f.enemies[0],false,[f.enemies[0]],()=>.5,false,[f.u],n.attackSpec(move));return x.targets.filter(r=>r.cmd===1&&r.targetCamp!==camp).reduce((v,r)=>v+Math.max(0,r.result.hurtHp||0),0);};
 assert.equal(move.attackStat,'atk');assert.equal(move.damageType,'physical');const base=damage();assert(base>0);assert(damage({atk:2000})>base);assert(damage({},{def:1000})<base);assert.equal(damage({magicAtk:999999},{resistance:999999}),base);assert(damage({skillBuffs:[{field:'atk',value:.5,remaining:2}]})>base);assert(damage({skillBuffs:[{field:'atk',value:-.5,remaining:2}]})<base);
}
for(const camp of [0,1]){
 const f=fixture(camp,15);f.u.maxHp=f.u.hp=1000000;f.u.speed=1000;for(const e of f.enemies){e.hp=e.maxHp=1000000;e.atk=500;}
 const result=b.kadroRapor(0,null,{ad:'Mecha native scheduling',birimler:camp?[f.u]:f.enemies},{playerUnits:camp?f.enemies:[f.u],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
 const report=require('../kodek').decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const acts=report.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===camp&&a.activePos===15);
 assert(acts.some(a=>a.skillEffectId===m.config.mystery.id || a.skillEffectId===m.config.highHpMystery.id));
 assert(acts.some(a=>a.skillEffectId===m.config.extremeBeam.id),'Jet must schedule a real encoded Extreme Beam');
 assert(acts.some(a=>a.skillEffectId===m.config.jet.id));
 for(const turn of report.turns)assert(turn.actives.filter(a=>a.activeCamp===camp&&a.activePos===15&&a.skillEffectId===m.config.extremeBeam.id).length<=3);
}
console.log('PASS Mecha: both camps/all 15 slots; thresholds, Mystery target count and cooldown, lowest HP, line targeting, physical scaling, growth limits, round expiry, shared cost, suppression/modified Chase, finite stolen standards and controlled Jet triggers.');
