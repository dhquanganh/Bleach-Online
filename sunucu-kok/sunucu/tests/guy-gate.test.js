'use strict';
const assert=require('node:assert/strict'),g=require('../guy-gate-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),b=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({...b.heroBirim(id,pos,159,null,null,0,true),camp,hp:1000000,maxHp:1000000,atk:1000,magicAtk:200,def:500,resistance:500,critRate:0});
const frame=()=>({targets:[],reactions:[]});
for(const camp of [0,1]){
 const u=unit(g.config.heroId,1,camp),ally=unit(11100001,6,camp),naruto=unit(11121006,11,camp),v=unit(11100002,1,1-camp);
 const teams=camp?[[v],[u,ally,naruto]]:[[u,ally,naruto],[v]],ctx=n.create(teams,{random:()=>.8});n.startRound(ctx,1);
 assert.equal(s.value(u,'def'),1500);assert(s.status(u,'immuneDebuffs'));u.suppressedUntil=99;assert(s.status(u,'immuneDebuffs'));assert.equal(s.restore(naruto,u,10000,[]),0);
 const aHp=ally.hp,gHp=u.hp;const hit=b.vurus(v,ally,false,teams[camp],()=>.8,false,teams[1-camp],n.attackSpec({id:1,multiplier:1,target:1,attackStat:'atk',damageType:'physical',unavoidable:true}));
 assert.equal(ally.hp,aHp);assert(u.hp<gHp);assert(hit.targets.some(t=>t.targetPos===u.pos&&t.targetCamp===camp&&t.result.hurtHp>0));
 n.startRound(ctx,3);assert.equal(s.value(u,'def'),500);const old=u.hp;b.vurus(v,ally,false,teams[camp],()=>.8,false,teams[1-camp],n.attackSpec({id:1,multiplier:1,target:1,attackStat:'atk',damageType:'physical',unavoidable:true}));assert(ally.hp<aHp);assert.equal(u.hp,old);
 n.startRound(ctx,2);u.hp=u.maxHp;const notices=g.beforeAction(ctx,u,g.config.mystery);assert.equal(u.hp,u.maxHp*.8);assert.equal(u.guySteamStacks,1);assert.equal(u.guySpeedStacks,1);assert(notices[0].targets.some(t=>t.result.hurtHp===u.maxHp*.2));assert(s.armor(u));
 assert.equal(s.value(ally,'atk'),1400);assert(Math.abs(s.value(ally,'critRate')-.2)<1e-8);assert(Math.abs(s.value(u,'atk')-2240)<1e-8);
 for(let i=0;i<15;i++)g.beforeAction(ctx,u,g.config.night);assert.equal(u.guySteamStacks,10);assert.equal(u.guySpeedStacks,3);assert(u.hp>=1);
 u.hp=10;u.shield=1000;assert(!g.protectFatal(ctx,u,100));assert(!u.guyPendingDeath);u.shield=0;assert(g.protectFatal(ctx,u,100));g.protectFatal(ctx,u,100);assert.equal(g.triggers(ctx).length,1,'one Night Guy queued per fatal sequence');
 const f=frame();g.afterHit(ctx,u,v,[v],g.config.night,f);assert.equal(u.hp,u.maxHp*.5);assert(u.guyRevived);assert(f.reactions.some(e=>e.targets.some(t=>t.result.hurtHp===-u.maxHp*.5)));
 assert(g.protectFatal(ctx,u,u.hp));g.triggers(ctx);g.afterHit(ctx,u,v,[v],g.config.night,frame());assert.equal(u.hp,0);assert(u.noRevive,'second death cannot revive');
 const other=unit(g.config.heroId,1,camp),c=n.create(camp?[[v],[other]]:[[other],[v]],{random:()=>.8});n.startRound(c,1);other.hp=1;assert(g.protectFatal(c,other,2));g.afterHit(c,other,v,[{...v,hp:0}],g.config.night,frame());assert.equal(other.hp,0);
 const sealed=unit(g.config.heroId,1,camp),sc=n.create(camp?[[v],[sealed,naruto]]:[[sealed,naruto],[v]],{random:()=>.8});n.startRound(sc,1);sealed.nfMagnetSpecialUntil=1;sealed.hp=1;g.protectFatal(sc,sealed,2);assert.equal(g.triggers(sc).length,0);assert.equal(sealed.hp,1);g.endRound(sc);assert.equal(sealed.hp,sealed.maxHp*.5,'Naruto rescue is external and bypasses a disabled self death skill');sealed.noRevive=true;sealed.hp=1;g.protectFatal(sc,sealed,2);g.endRound(sc);assert.equal(sealed.hp,0);
}
for(const camp of [0,1]){
 const own=[unit(g.config.heroId,1,camp),unit(11121006,6,camp)],enemy=[unit(11100001,1,1-camp),unit(11100002,6,1-camp),unit(11100003,11,1-camp)];
 own[0].hp=own[0].maxHp=10000;own[0].atk=100;own[1].naruto={standard:null,mystery:null,chases:[]};for(const v of enemy){v.atk=10000000;v.hp=v.maxHp=1000000000;v.speed=10000;}
 const result=b.kadroRapor(0,null,{ad:'Guy fatal redirect revival report',birimler:camp?own:enemy},{playerUnits:camp?enemy:own,playerState:{},scaleEnemy:false,forceWin:false,random:()=>.8});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);const events=report.turns.flatMap(t=>t.actives).filter(e=>e.activeCamp===camp&&e.activePos===1);
 assert(events.some(e=>e.skillEffectId===g.config.night.id),'fatal damage executes Night Guy');assert.equal(events.filter(e=>e.skillEffectId===g.config.revive.id).length,1);
 assert(report.turns.length<=25);for(const t of report.turns)assert(t.actives.length<300);
}
for(let pos=1;pos<=15;pos++)assert.equal(b.heroBirim(g.config.heroId,pos,159,null,null,0,true).pos,pos);
{
 const u=unit(g.config.heroId,1,0),v=unit(11100001,1,1),neighbor=unit(11100002,2,1),ctx=n.create([[u],[v,neighbor]],{random:()=>.1});n.startRound(ctx,1);assert.equal(n.useMystery(ctx,u),null,'battlefield cooldown one');n.startRound(ctx,2);
 assert(n.useMystery(ctx,u));const f=frame();g.afterHit(ctx,u,v,[v],g.config.mystery,f);assert(n.disabled(u));assert(n.disabled(v));n.startRound(ctx,3);assert(!n.disabled(u));
 g.afterHit(ctx,u,v,[v],g.config.standard,frame());assert(s.status(u,'disarm'));const splash=g.triggers(ctx).find(r=>r.move.guyMove==='splash');assert(splash&&splash.move.guySplashTargets.includes(neighbor));
 u.hp=u.maxHp;v.hp=v.maxHp;const records=[];ctx.round=1;u.battleRound=1;assert.equal(g.indirect(ctx,neighbor,v,10000,records),10000,'enemy team without Guy remains unaffected');
 const ally=unit(11100002,6,0);ctx.teams[0].push(ally);Object.defineProperty(ally,'guyContext',{value:ctx});ally.battleRound=1;assert.equal(g.indirect(ctx,v,ally,10000,records),0);assert(u.hp<u.maxHp);assert.equal(ally.hp,ally.maxHp);
 u.mysteryReadyRound=20;require('../pain-combat').interrupt(ctx,u,[]);assert.equal(u.mysteryReadyRound,ctx.round);assert(!u.painInterruptedUntil);
}
console.log('PASS Guy: both camps/15 slots, two-round DEF/interception, no healing, Steam costs/caps, lost-HP team buffs, shield-safe fatal queue, Night Guy and one Naruto revival, blocked death skill, bounded real reports.');
