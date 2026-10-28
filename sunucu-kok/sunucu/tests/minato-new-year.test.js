'use strict';
const assert=require('node:assert/strict'),m=require('../minato-new-year-combat'),n=require('../naruto-combat'),skills=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({...battle.heroBirim(id,pos,159,null,null,0,true),camp,hp:100000,maxHp:100000,atk:1000,def:500,resistance:500,critRate:0});
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),ally=unit(11100001,6,camp),enemy=unit(11100002,1,1-camp);
 const teams=camp?[[enemy],[u,ally]]:[[u,ally],[enemy]];m.prepareSummons(teams);m.prepareSummons(teams);
 const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);m.roundStart(ctx);
 const clone=teams[camp].find(m.isClone);assert.equal(teams[camp].filter(m.isClone).length,1);assert.equal(clone.hp,0);
 const start=m.battleStart(ctx);assert.equal(clone.hp,u.maxHp);assert.equal(start[0].targets[0].result.hurtHp,-u.maxHp);
 assert(skills.status(ally,'immuneDebuffs'));u.hp=0;assert(!skills.status(ally,'immuneDebuffs'));assert(skills.status(clone,'immuneDebuffs'));u.hp=u.maxHp;
 assert(!m.mark(ctx,enemy,u));assert(!m.mark(ctx,enemy,clone));assert(m.mark(ctx,u,enemy));
 const prepared=m.prepareMove(ctx,u,m.config.mystery,enemy);assert.equal(prepared.multiplier,m.config.mystery.multiplier*1.4);
 const frame={targets:[],reactions:[]};m.afterHit(ctx,u,enemy,[enemy],prepared,frame);assert(enemy.minatoMysteryPenalty);
 assert.equal(m.outgoing(ctx,enemy,{prompt:true}),.25);assert.equal(m.outgoing(ctx,enemy,{prompt:true}),1,'Mystery penalty consumed once');
 enemy.skillBuffs=[];enemy.minatoMarkUntil=2;const move=m.prepareMove(ctx,enemy,{prompt:true,unavoidable:true},u);assert.equal(move.unavoidable,true,'non-Kage retains unavoidable');
 for(let i=0;i<10;i++)m.afterHit(ctx,clone,enemy,[enemy],m.config.cloneCounter,{targets:[],reactions:[]});
 assert.equal(u.minatoResets,2);assert.equal(u.minatoTriggerBuffs,6);assert.equal(u.minatoAttackStacks,6);assert.equal(skills.value(u,'atk'),2200);
 u.minatoMysteries=3;assert(!m.canMystery(ctx,u),'base cast plus two resets is a finite round budget');
 ctx.round=2;n.startRound(ctx,2);m.roundStart(ctx);assert(m.canMystery(ctx,u));assert.equal(u.minatoResets,0);assert.equal(u.minatoTriggerBuffs,0);
 const before=skills.value(u,'critRate');assert(m.evade(ctx,u,{chase:true},enemy));assert(skills.value(u,'critRate')>before);
 const queue=m.triggers(ctx);assert(queue.some(r=>r.move.id===m.config.counter.id));assert(queue.some(r=>r.move.id===m.config.evade.id));
 u.hp=50000;u.skillBuffs=[{field:'silence',remaining:2,value:1}];ctx.primaryActions.set(u,2);ctx.skillReady.set(u,new Map([['standard',3]]));const records=[];
 m.onDamage(ctx,enemy,u,{damage:1},{prompt:true},records);assert(u.minatoProwess);assert.equal(u.hp,u.maxHp);assert(!skills.status(u,'silence'));assert(!ctx.primaryActions.has(u));assert(!ctx.skillReady.get(u).has('standard'));
 assert.equal(m.profile(u).mystery.chakraCost,0);assert.equal(m.profile(u).mystery.cooldown,2);
 u.hp=40000;m.onDamage(ctx,enemy,u,{damage:1},{},records);assert.equal(u.hp,40000,'Prowess only once per battle');
 clone.hp=0;assert.equal(m.summon(ctx,u).length,1);assert.equal(teams[camp].filter(m.isClone).length,1);assert.equal(m.summon(ctx,u).length,0,'cannot create or heal a second live clone');
 const many=Array.from({length:9},(_,i)=>unit(11100001,i+1,1-camp));assert.equal(m.targets(ctx,u,m.config.mystery,many[0],many).length,9);
 const row=m.targets(ctx,u,m.config.standard,many[0],many);assert(row.length>0&&row.every(v=>Math.floor((v.pos-1)/5)===Math.floor((row[0].pos-1)/5)));
 const markedMove=m.prepareMove(ctx,u,m.config.enhancedMystery,enemy);m.afterHit(ctx,u,enemy,[enemy],markedMove,{targets:[],reactions:[]});
 for(let i=0;i<9;i++)m.onDamage(ctx,u,enemy,{damage:1},{prompt:true},[]);assert.equal(enemy.minatoTriggerPenalty,.75);assert.equal(m.outgoing(ctx,enemy,{trigger:true}),.25);
}
for(const camp of [0,1]){
 const own=[unit(m.config.heroId,1,camp)],enemies=[unit(11100001,1,1-camp),unit(11100002,6,1-camp),unit(11100003,11,1-camp)];
 const result=battle.kadroRapor(0,null,{ad:'Minato New Year regression',birimler:camp?own:enemies},{playerUnits:camp?enemies:own,playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const side=camp?report.player2:report.player1,clones=side.roles.filter(r=>r.roleId===m.config.summonId);assert.equal(clones.length,1);assert.equal(clones[0].curHealth,0);
 const events=report.turns.flatMap(t=>t.actives);assert(events.some(e=>e.activeCamp===camp&&e.skillEffectId===m.config.summon.id));
 const mystery=events.find(e=>e.activeCamp===camp&&e.skillEffectId===m.config.mystery.id);assert(mystery);assert.equal(new Set(mystery.targets.filter(t=>t.targetCamp!==camp&&t.result.hurtHp>0).map(t=>t.targetPos)).size,3);
 assert(report.turns.length<=25&&report.turns.every(t=>t.curTurn<=24));
 for(const turn of report.turns)assert(turn.actives.filter(e=>e.activeCamp===camp&&e.activePos===1&&[m.config.mystery.id,m.config.enhancedMystery.id].includes(e.skillEffectId)).length<=3);
}
// A living auxiliary must not keep a defeated Minato in battle or revive him.
for(const camp of [0,1]){
 const victim=unit(m.config.heroId,1,camp),killer=unit(11100001,1,1-camp);
 victim.hp=1;victim.speed=1;killer.hp=killer.maxHp=1000000000;killer.atk=1000000000;killer.speed=10000;
 const result=battle.kadroRapor(0,null,{ad:'Minato final defeat regression',birimler:camp?[victim]:[killer]},{playerUnits:camp?[killer]:[victim],playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(result.won,camp===1);assert.equal(report.turns.at(-1).curTurn,1);
 assert(!report.turns.flatMap(t=>t.actives).some(e=>e.skillEffectId===m.config.prowess.id),'fatal damage cannot resurrect Minato via Prowess');
}
for(let pos=1;pos<=15;pos++)assert.equal(battle.heroBirim(m.config.heroId,pos,159,null,null,0,true).pos,pos);
console.log('PASS Minato: both camps, full-team Mystery, single 100% clone, aura, mark, 40% bonus, penalties/caps, finite counters/resets, once-only Prowess and encoded actor lifecycle.');
