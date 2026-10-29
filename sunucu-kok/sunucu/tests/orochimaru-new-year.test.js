'use strict';
const assert=require('node:assert/strict'),o=require('../orochimaru-new-year-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),b=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:100000,maxHp:100000,atk:5000,magicAtk:9000,def:5000,resistance:8000,speed:180,level:159,hitRate:1,critRate:0,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp,random=()=>.25){const u=unit(o.config.heroId,6,camp),ally=unit(11100001,1,camp),v=unit(12101003,6,1-camp),v2=unit(12101003,1,1-camp);const ctx=n.create(camp?[[v,v2],[u,ally]]:[[u,ally],[v,v2]],{random});n.startRound(ctx,1);return {u,ally,v,v2,ctx};}
function frame(){return {targets:[],reactions:[]};}
for(const camp of [0,1]){
 const {u,ally,v,v2,ctx}=fixture(camp);
 assert(s.status(u,'immuneDebuffs'));assert.equal(o.profile(u).mystery.cooldown,2);assert.equal(o.config.baseSpeed,180);
 u.hp=40000;let records=[];o.onDamage(ctx,v,u,{damage:10000,before:50000},{},records);assert.equal(u.hp,50500);assert.equal(records[0].result.hurtHp,-10500);
 u.hp=0;records=[];o.onDamage(ctx,v,u,{damage:1000,before:1000},{},records);assert.equal(u.hp,1050,'50% recovery can rescue a fatal wound');
 u.hp=40000;records=[];ctx.random=()=>.5;o.onDamage(ctx,v,u,{damage:10000},{},records);assert.equal(u.hp,40000);assert.equal(records.length,0);
 ctx.random=()=>.25;u.hp=40000;o.onDamage(ctx,u,u,{damage:10000},{},[]);assert.equal(u.hp,40000,'self costs do not proc');o.onDamage(ctx,v,u,{damage:0},{},[]);assert.equal(u.hp,40000);
 u.hp=99999;o.onDamage(ctx,v,u,{damage:20000},{},[]);assert.equal(u.hp,u.maxHp);
 u.hp=50000;records=[];assert.equal(o.indirect(ctx,v,u,10000,records),0);assert.equal(u.hp,50500);assert.equal(records[0].result.hurtHp,10000);assert.equal(records[1].result.hurtHp,-10500);
 o.afterHit(ctx,u,v,[v,v2],o.config.mystery,frame());assert(o.active(v,'oroLacerationUntil'));assert(o.profile(u).mystery===o.config.serpent);o.afterHit(ctx,u,v,[v,v2],o.config.serpent,frame());assert(!u.oroSerpent);assert(o.nonfatal(u));
 ctx.random=()=>.9;u.hp=1;o.onDamage(ctx,v,u,{damage:0},{},[]);assert.equal(u.hp,4001,'Explosive Mode heals 4% even for a zero-damage incoming attack');
 assert.equal(o.targetDamage(u,v,o.config.serpent),1);v.immuneDebuffs=true;v.superArmor=true;assert.equal(o.targetDamage(u,v,o.config.serpent),1.6);
 u.hp=50000;ctx.random=()=>.25;for(let i=0;i<10;i++)o.evaded(ctx,u);assert.equal(u.oroCritical,.4);assert.equal(u.oroEvades,5);assert.equal(u.hp,100000);
 n.startRound(ctx,2);u.oroSerpent=false;u.mysteryReadyRound=2;ctx.chakra[camp]=100;assert(n.useMystery(ctx,u));assert.equal(u.mysteryReadyRound,4);assert(!n.useMystery(ctx,u));
 let f=frame();o.afterHit(ctx,u,v,[v],o.config.seal,f);assert.equal(u.mysteryReadyRound,3);assert(!o.sealed(v));assert(s.status(v,'silence')===false,'immune enemy rejects seal');delete v.immuneDebuffs;v.superArmor=false;o.afterHit(ctx,u,v,[v],o.config.additionalSeal,frame());assert(o.sealed(v));assert(s.status(v,'silence'));assert.equal(s.value(v,'atk'),3500);assert.equal(s.value(v,'magicAtk'),9000);assert.equal(o.cost(ctx,u),40);
 for(let i=0;i<8;i++)o.triggerExecuted(ctx,v,{trigger:true});assert.equal(s.value(v2,'def'),2000);assert.equal(s.value(v2,'resistance'),3200);let chakra=ctx.chakra[v.camp];require('../tsunade-combat').gainChakra(ctx,v,20);assert.equal(ctx.chakra[v.camp],chakra);
 u.hp=100000;u.oroCounters=0;o.triggers(ctx);for(let i=0;i<10;i++)o.onDamage(ctx,v,u,{damage:1},{trigger:true},[]);assert.equal(o.triggers(ctx).filter(r=>r.move?.oroMove==='additionalSeal').length,5);
 for(let i=0;i<3;i++)o.afterHit(ctx,u,v,[v],o.config.chase,frame());assert.deepEqual(o.profile(u).chases[0].requiresAny,['lowFloat','highFloat','knockdown','repulse']);assert(o.profile(u).chases[0].unavoidable);
 u.hp=0;o.noteDeaths(ctx);assert.equal(u.oroReviveRound,4);n.startRound(ctx,3);assert.equal(o.roundStart(ctx).length,0);n.startRound(ctx,4);assert.equal(o.roundStart(ctx).length,2);assert.equal(u.hp,50000);
 u.hp=0;ally.hp=0;o.noteDeaths(ctx);n.startRound(ctx,6);assert.equal(o.roundStart(ctx).length,0,'wipe ends battle instead of waiting for a revive');
}
for(const camp of [0,1]){
 const {u,v,ctx}=fixture(camp);u.hp=1000;u.maxHp=10000;u.def=0;v.atk=1000000;
 const move={id:13100114,multiplier:1,attackStat:'atk',damageType:'physical',target:1,unavoidable:true};
 const attack=b.vurus(v,u,false,[u],()=>.25,false,[v],n.attackSpec(move));
 let hp=1000;for(const event of [attack,...attack.reactions])for(const row of event.targets)if(row.targetCamp===u.camp&&row.targetPos===u.pos&&row.cmd===codec.CMD.ATTACK)hp=Math.max(0,Math.min(u.maxHp,hp-(row.result.hurtHp||0)));
 assert.equal(hp,u.hp,'fatal damage and recovery records exactly match server HP');assert.equal(hp,1050);
 u.hp=1000;u.skillBuffs=[{kind:'debuff',field:'noHeal',value:1,remaining:2}];const records=[];u.hp=0;o.onDamage(ctx,v,u,{damage:1000},{},records);assert.equal(u.hp,0,'healing denial prevents fatal recovery');
}
for(const camp of [0,1]){
 const {u,ally,ctx}=fixture(camp);ally.hp=0;
 assert.equal(o.allyRevivals(ctx).length,0,'no revival on round 1');n.startRound(ctx,2);
 let frames=o.allyRevivals(ctx);assert.equal(frames.length,2);assert.equal(ally.hp,ally.maxHp);assert.equal(frames[0].activeType,4);assert.equal(frames[0].targets[0].result.hurtHp,-ally.maxHp);assert.equal(frames[1].activePos,u.pos);
 ally.hp=0;assert.equal(o.allyRevivals(ctx).length,0,'one revival per interval even if called twice');n.startRound(ctx,3);assert.equal(o.allyRevivals(ctx).length,0);
 n.startRound(ctx,4);ally.noRevive=true;assert.equal(o.allyRevivals(ctx).length,0);assert.equal(ally.hp,0);
 n.startRound(ctx,6);ally.noRevive=false;ally.auxiliary=true;assert.equal(o.allyRevivals(ctx).length,0);
 n.startRound(ctx,8);ally.auxiliary=false;u.hp=0;assert.equal(o.allyRevivals(ctx).length,0,'dead owner cannot revive allies');
 n.startRound(ctx,10);u.hp=1;assert.equal(o.allyRevivals(ctx).length,2);assert.equal(ally.hp,ally.maxHp);
}
for(const camp of [0,1]){
 const owner={...unit(o.config.heroId,6,camp),hp:5000,maxHp:5000,atk:1,def:1},ally={...unit(11100001,1,camp),hp:300,maxHp:300,atk:1,def:1};
 const enemy={...unit(12101003,6,1-camp),hp:1000000000,maxHp:1000000000,atk:1000000000,def:1000000000,speed:9999,naruto:{standard:{id:13100114,target:'all',attackStat:'atk',damageType:'physical',multiplier:1,unavoidable:true,cooldown:0},chases:[]}};
 const report=codec.decodeBattleReport(b.kadroRapor(0,{name:'Periodic Orochimaru ally revival',level:159,units:camp?[owner,ally]:[enemy]},null,{playerUnits:camp?[enemy]:[owner,ally],playerState:{},scaleEnemy:false,battleDataVersion:4,random:()=>.25}).payload);
 const revivals=report.turns.flatMap(t=>t.actives.flatMap(e=>e.targets.filter(row=>row.cmd===codec.CMD.ATTACK&&row.targetCamp===camp&&row.targetPos===1&&row.result.hurtHp===-300).map(()=>t.curTurn)));
 assert(revivals.length>0,'actual combat report contains the full-HP ally revival');assert(revivals.every(round=>round%2===0),revivals.join(','));assert.equal(new Set(revivals).size,revivals.length);
}
for(let pos=1;pos<=15;pos++){const u=b.heroBirim(o.config.heroId,pos,1,null,null,0,true);assert.equal(u.pos,pos);assert.equal(u.speed,180);}
const own=[unit(o.config.heroId,6,0),unit(11100001,1,0)],foes=[unit(o.config.heroId,6,1),unit(11100002,1,1)];const report=codec.decodeBattleReport(b.kadroRapor(0,{name:'Orochimaru finite report',level:159,units:foes},null,{playerUnits:own,playerState:{},scaleEnemy:false,battleDataVersion:4,random:()=>.7}).payload);assert(report.turns.length<100);assert.equal(report._consumed,report._total);
console.log('PASS Orochimaru: both camps/15 slots, base speed 180, alternating CD2 forms, 50%/105% fatal and indirect recovery, limits/no self costs, seal/cost/chase progression, Explosive Mode, delayed revival and finite binary report');
