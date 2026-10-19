'use strict';
const assert=require('node:assert/strict'),h=require('../hashirama-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:100000,maxHp:100000,atk:1000,magicAtk:1,def:100,resistance:100,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=6){const u={...unit(h.config.heroId,pos,camp),hp:10000,maxHp:10000,normal:h.config.standard.id,skill:h.config.mystery.id,skillId:h.config.mystery.id};const enemies=Array.from({length:15},(_,i)=>unit(12101003,i+1,1-camp)),ally=unit(500,7,camp);const ctx=n.create(camp?[enemies,[u,ally]]:[[u,ally],enemies],{random:()=>.5});n.startRound(ctx,1);h.roundStart(ctx);return {ctx,u,enemies,ally};}
function strike(f,move,actor=f.u,target=f.enemies[0]){move=h.prepareMove(f.ctx,actor,move);const frame=battle.vurus(actor,target,false,f.ctx.teams[1-actor.camp],()=>.5,false,f.ctx.teams[actor.camp],n.attackSpec(move));const hit=f.ctx.teams[1-actor.camp].filter(t=>frame.targets.some(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp===t.camp&&r.targetPos===t.pos&&(r.reportTargetStatus&codec.ST.HIT)));h.afterHit(f.ctx,actor,target,hit,move,frame);return frame;}
for(const camp of [0,1]){
 for(let pos=1;pos<=15;pos++){const f=fixture(camp,pos);assert(n.profile(f.u));assert.equal(f.u.pos,pos);assert.equal(n.profile(f.u).quality,7);}
 let f=fixture(camp),{u,ctx,enemies,ally}=f;
 assert.equal(n.profile(u).standard.id,h.config.sword.id);assert.equal(n.profile(u).chases[0].id,h.config.severe.id);
 u.hp=5999;assert.equal(n.profile(u).standard.id,h.config.standard.id);assert.equal(n.profile(u).chases[0].id,h.config.chases[0].id);
 u.hp=6000;assert.equal(n.profile(u).standard.id,h.config.sword.id);
 assert(s.status(u,'immuneDebuffs'));s.apply({id:1,effects:[{kind:'buff',scope:'t',field:'stun',value:1,turns:2}]},enemies[0],enemies,[u],[u],[],()=>0);assert(!s.status(u,'stun'));
 // Four real damage events: excited once, heal/CD reduction before Burst, consume 2 TP, bounded Chakra.
 u.hp=5000;u.mysteryReadyRound=10;ctx.chakra[camp]=80;let events=[];
 for(let i=0;i<4;i++){u.hp-=100;h.onDamage(ctx,enemies[0],u,{damage:100},null,[],events);}
 assert(h.burst(u));assert.equal(u.hashTechnique,0);assert.equal(ctx.chakra[camp],100);assert.equal(u.hp,6600);assert.equal(u.mysteryReadyRound,6);assert.equal(events.length,1);assert.equal(u.hashMysteryStacks,1);
 assert.equal(n.profile(u).mystery.id,h.config.burstMystery.id);assert.equal(n.profile(u).chases[0].id,h.config.burstSevere.id);
 assert.equal(s.value(u,'atk'),1600);assert.equal(s.value(u,'resistance'),70);u.hp-=100;const before=u.hp;h.onDamage(ctx,enemies[0],u,{damage:100},null,[],[]);assert.equal(u.hp,before);assert.equal(u.hashTechnique,.5);
 u.suppressedUntil=ctx.round;assert(s.status(u,'immuneDebuffs'),'Advanced immunity resists lower-level suppression');assert(h.fireImmune(u,{element:'fire'},enemies[0]));
 // Team growth applies only while a living Hashirama is in Burst; physical and Ninjutsu grow independently.
 const atk=ally.hashAttackStacks||0;h.onDamage(ctx,ally,enemies[0],{damage:100},{damageType:'taijutsu'},[],[]);assert.equal(ally.hashAttackStacks,atk+1);assert.equal(ally.hashNinjutsuStacks||0,0);
 h.onDamage(ctx,ally,enemies[0],{damage:100},{damageType:'ninjutsu'},[],[]);assert.equal(ally.hashNinjutsuStacks,1);
 h.endRound(ctx);assert(!h.burst(u));assert.equal(u.hashMysteryStacks,2);assert.equal(u.hashExplosiveUntil,2);assert.equal(ctx.hashForest.until,2);
 const old=ally.hashAttackStacks;h.onDamage(ctx,ally,enemies[0],{damage:100},{damageType:'taijutsu'},[],[]);assert.equal(ally.hashAttackStacks,old);
 // Mysteries retain recovery across HP/Burst changes; each form has one cast per round.
 f=fixture(camp);({u,ctx,enemies}=f);ctx.chakra[camp]=100;let move=n.useMystery(ctx,u);assert.equal(move.id,h.config.mystery.id);assert.equal(ctx.chakra[camp],80);assert.equal(u.mysteryReadyRound,4);assert.equal(n.useMystery(ctx,u),null);
 assert.equal(h.additional(ctx,u,move).id,h.config.additional.id);assert.equal(h.additional(ctx,u,move),null);
 const frame=strike(f,move);assert.equal(enemies[0].hashSealUntil,1);assert.equal(enemies[0].hashRootUntil,1);assert(!u.hashRootUntil,'Explosive Mysteries root their victims, never the caster');assert(!h.canMystery(ctx,enemies[0]));assert(!h.canStandard(enemies[0]));
 enemies[0].def=300;enemies[0].skillBuffs=[{field:'def',value:2,remaining:3}];assert.equal(s.value(enemies[0],'def'),300);
 u.hashBurstUntil=1;assert.equal(n.canMystery(ctx,u),false,'Changing form must not reset recovery/action budget');n.startRound(ctx,2);h.roundStart(ctx);assert(!h.active(enemies[0],'hashSealUntil'));
 // Unavoidable Rumbling hits 12 units, suppresses immunity then applies Weakness, and drains the shared pool exactly once.
 f=fixture(camp);({u,ctx,enemies}=f);u.hashBurstUntil=1;ctx.chakra[camp]=40;ctx.chakra[1-camp]=100;move=n.useMystery(ctx,u);assert.equal(move.id,h.config.burstMystery.id);assert.equal(ctx.chakra[camp],0);enemies[0].immuneDebuffs=true;
 let report=strike(f,move);assert.equal(report.targets.filter(r=>r.cmd===1&&r.targetCamp===1-camp).length,12);assert.equal(ctx.chakra[1-camp],0);assert.equal(ctx.chakra[camp],100);assert.equal(enemies[0].hashWeakUntil,2);assert.equal(enemies[0].suppressedUntil,1);assert.equal(s.value(enemies[0],'atk'),750);assert.equal(s.value(enemies[0],'magicAtk'),.75);
 // Both chase variants share one index and a hard budget of two per round, even as HP changes.
 f=fixture(camp);({u,ctx,enemies}=f);u.mysteryReadyRound=5;
 const opener={targets:[{cmd:1,targetCamp:1-camp,targetPos:1,reportTargetStatus:codec.ST.HIT,result:{hurtHp:1}}]};
 const chased=n.resolve(ctx,u,enemies[0],opener,{combo:1,causes:'lowFloat'},(actor,target,chase)=>strike(f,chase,actor,target));
 assert.equal(chased.filter(a=>a.skillEffectId===h.config.severe.id).length,2);assert.equal(u.mysteryReadyRound,3);assert.equal(enemies[0].hashEnfeebleUntil,1);
 assert.equal(n.resolve(ctx,u,enemies[0],opener,{causes:'lowFloat'},(a,t,c)=>strike(f,c,a,t)).length,0);
 assert.equal(s.value(enemies[0],'atk'),750);const rec=[];s.remove(enemies[0],true,rec);assert(h.active(enemies[0],'hashEnfeebleUntil'),'Irremovable Enfeeble survives cleansing');
 u.hashBurstUntil=1;enemies[0].hashWeakUntil=2;strike(f,h.config.burstSevere);enemies[0].dodgeRate=.9;assert.equal(s.value(enemies[0],'dodgeRate'),.2);
 // Sword selects a random occupied line, reduces attacks, grants at most 5 standards; no cross-row duplication.
 f=fixture(camp);({u,ctx,enemies}=f);const sword=n.useStandard(ctx,u,[u]);assert.equal(sword.id,h.config.sword.id);report=strike(f,sword);assert.deepEqual(report.targets.filter(r=>r.cmd===1&&r.targetCamp===1-camp).map(r=>r.targetPos),[6,7,8,9,10]);assert(enemies.slice(5,10).every(e=>e.hashStandardLoss===1));
 ctx.random=()=>0;for(let i=1;i<5;i++){u.hashExtra=1;assert(n.useStandard(ctx,u,[u]));}u.hashExtra=9;assert.equal(n.useStandard(ctx,u,[u]),null);
 // Low-HP Taijutsu and Adamantine heal 35% of actual damage, not nominal damage or splash.
 f=fixture(camp);({u,ctx,enemies}=f);u.hp=1000;report=strike(f,h.config.standard);let dealt=report.targets.filter(r=>r.cmd===1&&r.targetCamp===1-camp).reduce((a,r)=>a+r.result.hurtHp,0);assert.equal(u.hp,1000+Math.round(dealt*.35));
 // Golem's splash includes the 13th-15th slots at orthogonal distance one from its 12 primary hits.
 f=fixture(camp);report=strike(f,h.config.additional);assert.equal(new Set(report.targets.filter(r=>r.cmd===1&&r.targetCamp===1-camp).map(r=>r.targetPos)).size,15);
}
// A lost Standard removes one attempt, including multi-attack Obito, rather than skipping its whole turn.
{
 const obito=require('../obito-combat'),f=fixture();const u={...unit(obito.config.heroId,2),obitoStandards:0,obitoRage:true,hashStandardLoss:1,hashStandardLossRound:1};
 f.ctx.teams[0].push(u);u.battleRound=1;assert(n.useStandard(f.ctx,u,[u]));assert.equal(u.obitoStandards,2);assert.equal(n.useStandard(f.ctx,u,[u]),null);
 const target=f.enemies[0];target.hashSealUntil=1;target.critDamage=20;const dmg=battle.vurus(target,f.ally,false,[f.ally],()=>.5,false,[target],n.attackSpec({id:1,multiplier:1,attackStat:'atk',damageType:'taijutsu',unavoidable:true}));
 assert(dmg.targets.some(t=>(t.reportTargetStatus&codec.ST.CRIT)!==0));
 const hunit=f.u;hunit.hp=5000;hunit.hashTechnique=1.5;hunit.hashBurstUntil=1;hunit.hashMysteryStacks=1;h.onDamage(f.ctx,target,hunit,{damage:10},null,[],[]);assert.equal(hunit.hashMysteryStacks,1,'Recovering points inside Burst must not count as entering a new state');
}
// Every damage variant uses Physical ATK independently of Ninjutsu stats.
for(const move of [h.config.mystery,h.config.burstMystery,...h.config.chases,h.config.severe,h.config.burstSevere,h.config.standard,h.config.sword,h.config.additional]){
 const damage=(atk,magicAtk)=>{const f=fixture();f.u.atk=atk;f.u.magicAtk=magicAtk;const frame=battle.vurus(f.u,f.enemies[0],false,f.enemies,()=>.5,false,[f.u],n.attackSpec(move));return frame.targets.filter(t=>t.cmd===1&&t.targetCamp===1).reduce((a,t)=>a+t.result.hurtHp,0);};
 assert.equal(damage(1000,1),damage(1000,99999));assert(damage(2000,1)>damage(1000,1));
}
// The real scheduler must encode supported skill IDs, damage, two Chase charges and no repeated Mystery flood.
for(const camp of [0,1]){
 const f=fixture(camp,15);f.u.maxHp=f.u.hp=1000000;f.u.atk=10000;f.u.speed=1000;
 const own=camp?f.enemies:[f.u],enemy=camp?[f.u]:f.enemies;
 const result=battle.kadroRapor(0,null,{ad:'Hashirama native scheduling',birimler:enemy},{playerUnits:own,playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const acts=report.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===camp&&a.activePos===15);
 assert(acts.some(a=>a.skillEffectId===h.config.forest.id));assert(acts.some(a=>a.skillEffectId===h.config.mystery.id));assert(acts.some(a=>a.skillEffectId===h.config.additional.id));
 assert(report.turns[0].actives.some(a=>a.activeCamp===camp&&a.skillEffectId===h.config.forest.id),'A reused unit still activates the forest at the start of a fresh battle');
 assert(acts.some(a=>a.skillEffectId===h.config.burstMystery.id),'Real AI must cast the Burst Mystery after taking damage, not only select it in helper tests');
 for(const turn of report.turns){const cast=turn.actives.filter(a=>a.activeCamp===camp&&a.activePos===15&&[13121001,13121002].includes(a.skillEffectId));assert(cast.length<=2);assert.equal(new Set(cast.map(a=>a.skillEffectId)).size,cast.length,'Each form may cast only once per round');}
}
{
 const f=fixture();f.u.hashBurstUntil=999;f.u.hashMysteryStacks=99;f.ally.hashAttackStacks=99;
 const fresh=n.create(f.ctx.teams);n.startRound(fresh,1);assert.equal(f.u.hashMysteryStacks,undefined);assert(!h.burst(f.u));assert.equal(f.ally.hashAttackStacks,undefined);assert.equal(h.roundStart(fresh).length,1);
}
console.log('PASS Hashirama: 15 positions/both camps, exact HP boundary, all forms, TP/Excited/Burst/Advanced and Fire immunity, growth, both cooldowns, gate/root/weakness/enfeeble, chase budget, sword line/extra limit, life steal, 12-target Golem+splash, bounded Chakra and actual encoded scheduling.');
