'use strict';
const assert=require('node:assert/strict'),m=require('../madara-infinite-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({...battle.heroBirim(id,pos,159,null,null,0,true),camp,hp:100000,maxHp:100000,atk:1000,def:500,resistance:500,critRate:0});
const frame=()=>({targets:[],reactions:[]});
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),ally=unit(11100001,6,camp),v=unit(11100002,1,1-camp),v2=unit(11100003,6,1-camp),teams=camp?[[v,v2],[u,ally]]:[[u,ally],[v,v2]];
 const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);m.roundStart(ctx);
 u.suppressedUntil=100;assert(s.status(u,'immuneDebuffs'));assert(s.status(u,'immuneControl'),'lower Suppress Immunity cannot bypass advanced immunity');
 let move=n.useMystery(ctx,u);assert.equal(move.id,m.config.mystery.id);m.afterHit(ctx,u,v,[],move,frame());assert.equal(m.profile(u).mystery.id,m.config.susanoo.id);assert.equal(v.infiniteRestrainedUntil,1);
 m.action(ctx,v);assert(n.disabled(v));assert(!n.disabled(v2));
 require('../tsunade-combat').cleanseAll(v,[]);assert(n.disabled(v),'Slumber is a special effect, not a cleansable debuff');
 m.afterHit(ctx,u,v,[],m.config.barrier,frame());assert.equal(ctx.infiniteBarrier.until,2);assert(!m.immune(v,'paralysis'));assert(m.immune(ally,'paralysis'));
 ally.infiniteSlumberUntil=1;m.afterHit(ctx,u,v,[],m.config.barrier,frame());assert(!n.disabled(ally));
 ally.paralyzed=true;assert(n.canChase(ally),'barrier protects against all paralysis implementations');ally.paralyzed=false;
 const chakra=ctx.chakra[1-camp];ctx.chakra[1-camp]+=40;assert.equal(ctx.chakra[1-camp],chakra);ctx.chakra[1-camp]-=10;assert.equal(ctx.chakra[1-camp],chakra-10);
 v.hp=1000;const records=[];assert.equal(s.restore(v,v,1000,records),200);assert.equal(s.restore(u,ally,1000,[]),0);
 assert.equal(n.useStandard(ctx,u,teams[camp]).id,m.config.standard.id);m.afterHit(ctx,u,v,[v,v2],m.config.standard,frame());assert.equal(u.infiniteStolen,2);assert.equal(v.hashStandardLoss,1);
 assert(n.useStandard(ctx,u,teams[camp]));assert(n.useStandard(ctx,u,teams[camp]));assert.equal(n.useStandard(ctx,u,teams[camp]),null);assert.equal(u.infiniteStolen,0);
 for(let i=0;i<20;i++)m.action(ctx,ally);assert.equal(u.infiniteActions,8);assert.equal(s.value(u,'atk'),1800);
 assert.equal(s.value(u,'magicAtk'),u.magicAtk,'Ten-Tails growth is Physical ATK only');
 assert(m.evade(ctx,u));assert(!m.evade(ctx,u));assert.equal(ctx.chakra[camp],100);const q=m.triggers(ctx);assert(q.some(r=>r.move.id===m.config.counter.id));
 m.afterHit(ctx,u,v,[v],m.config.counter,frame());assert.equal(v.infiniteParalysisUntil,1);assert(!n.canChase(v));assert.equal(u.mysteryReadyRound,1);assert(m.canMystery(ctx,u));
 assert.equal(n.useMystery(ctx,u).id,m.config.susanoo.id);m.afterHit(ctx,u,v,[v,v2],m.config.susanoo,frame());assert.equal(m.profile(u).mystery.id,m.config.mystery.id);assert(!n.useMystery(ctx,u),'two casts per round is finite');assert.equal(v.madaraShatterUntil,2);
 v.hp=0;m.afterHit(ctx,u,v,[v],m.config.standard2,frame());assert(v.noRevive);
 u.hp=0;m.noteDeaths(ctx);assert.equal(u.infiniteReviveRound,4);m.noteDeaths(ctx);assert.equal(u.infiniteReviveRound,4);
 for(const round of [2,3]){n.startRound(ctx,round);m.roundStart(ctx);assert.equal(u.hp,0);}
 n.startRound(ctx,4);const revived=m.roundStart(ctx);assert.equal(u.hp,80000);assert(revived.some(e=>e.targets.some(r=>r.result.hurtHp===-80000)));assert.equal(m.healing(v2),1);assert.equal(ctx.chakra[1-camp],80);
 assert.equal(n.useStandard(ctx,u,teams[camp]).id,m.config.standard.id,'first standard resets each round');
 ctx.chakra[camp]=59;assert.equal(m.profile(u).chases[0].id,m.config.chase.id);ctx.chakra[camp]=60;assert.equal(m.profile(u).chases[0].id,m.config.limboChase.id);
 const hash=require('../hashirama-combat'),hashUnit=unit(hash.config.heroId,11,1-camp);teams[1-camp].push(hashUnit);Object.defineProperty(hashUnit,'infiniteContext',{value:ctx});
 m.afterHit(ctx,u,v,[],m.config.barrier,frame());hash.roundStart(ctx);assert(!hashUnit.hashExplosiveUntil,'enemy cannot receive Explosive Mode under the barrier');
 m.afterHit(ctx,u,v,[],m.config.susanoo,frame());assert(!hashUnit.hashExplosiveUntil);
}
for(const camp of [0,1]){
 const own=[unit(m.config.heroId,1,camp),unit(11100001,6,camp)],enemy=[unit(11100001,1,1-camp),unit(11100002,6,1-camp),unit(11100003,11,1-camp)];
 const result=battle.kadroRapor(0,null,{ad:'Infinite Tsukuyomi regression',birimler:camp?own:enemy},{playerUnits:camp?enemy:own,playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.8});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);const events=report.turns.flatMap(t=>t.actives);
 assert(events.some(e=>e.activeCamp===camp&&e.skillEffectId===m.config.mystery.id));assert(events.some(e=>e.activeCamp===camp&&e.skillEffectId===m.config.barrier.id));
 const damage=events.find(e=>e.activeCamp===camp&&e.skillEffectId===m.config.susanoo.id);assert(damage);assert.equal(new Set(damage.targets.filter(t=>t.targetCamp!==camp&&t.result.hurtHp>0).map(t=>t.targetPos)).size,3);
 for(const t of report.turns){assert(t.actives.length<250);assert(t.actives.filter(e=>e.activeCamp===camp&&e.activePos===1&&[m.config.mystery.id,m.config.susanoo.id].includes(e.skillEffectId)).length<=2);}
 const victim=unit(m.config.heroId,1,camp),killer=unit(11100001,1,1-camp);victim.hp=1;victim.speed=1;killer.atk=1e9;killer.hp=killer.maxHp=1e9;killer.speed=10000;
 const ended=battle.kadroRapor(0,null,{ad:'Infinite wipe regression',birimler:camp?[victim]:[killer]},{playerUnits:camp?[killer]:[victim],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.8});
 assert.equal(codec.decodeBattleReport(ended.payload).turns.at(-1).curTurn,1,'wipe must end without waiting for revival');
}
for(let pos=1;pos<=15;pos++)assert.equal(battle.heroBirim(m.config.heroId,pos,159,null,null,0,true).pos,pos);
console.log('PASS Infinite Tsukuyomi: both camps, alternating full-field Mysteries, action theft/caps, barrier/chakra/healing, advanced immunity, paralysis, counter refund, three-round revival, team wipe and binary reports.');
