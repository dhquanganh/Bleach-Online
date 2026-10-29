'use strict';
const assert=require('node:assert/strict'),a=require('../asura-guardian-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),b=require('../savas'),r=require('../reincarnation');
const unit=(id,pos,camp)=>({id,pos,camp,hp:100000,maxHp:100000,atk:5000,magicAtk:10000,def:5000,resistance:8000,speed:100,level:159,hitRate:1,critRate:0,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp){const u=unit(a.config.heroId,6,camp),ally=unit(11100001,1,camp),enemy=unit(12101003,6,1-camp),e2=unit(12101003,1,1-camp);const ctx=n.create(camp?[[enemy,e2],[u,ally]]:[[u,ally],[enemy,e2]],{random:()=>.9});n.startRound(ctx,1);return {u,ally,enemy,e2,ctx};}
for(const camp of [0,1]){
 const {u,ally,enemy,e2,ctx}=fixture(camp);
 for(let round=1;round<=3;round++){n.startRound(ctx,round);const before=u.hp;const result=r.hit(enemy,u,20000,()=>.9,true,false,true);assert.equal(result.damage,round<=2?0:20000);assert.equal(u.hp,before-result.damage);}
 u.hp=50000;ally.hp=50000;const frames=a.battleStart(ctx);assert(frames.length);assert.equal(ally.hp,51250);assert.equal(u.hp,51250);assert.equal(u.asuraHealBonus,.25);
 ally.hp=0;let rev=a.revivals(ctx);assert.equal(rev.length,1);assert.equal(ally.hp,100000);ally.hp=0;assert.equal(a.revivals(ctx).length,0);n.startRound(ctx,4);assert.equal(a.revivals(ctx).length,1);
 ally.hp=0;ally.noRevive=true;n.startRound(ctx,5);assert.equal(a.revivals(ctx).length,0);ally.noRevive=false;ally.hp=100000;
 u.hp=0;a.noteDeaths(ctx);assert.equal(u.asuraReviveRound,7);n.startRound(ctx,6);assert.equal(a.roundStart(ctx).length,0);n.startRound(ctx,7);assert(a.roundStart(ctx).length);assert(u.hp>=40000);
 u.hp=0;ally.hp=0;a.noteDeaths(ctx);n.startRound(ctx,9);assert.equal(a.roundStart(ctx).length,0,'no resurrection after full wipe');
 u.hp=100000;ally.hp=100000;n.startRound(ctx,10);a.roundStart(ctx);
 for(let i=0;i<12;i++){a.observe(ctx,ally,{chase:true});a.evaded(ctx,ally);}assert.equal(u.asuraAttack,8);assert.equal(u.asuraEvadeCrit,8);assert.equal(s.value(u,'atk'),9800);assert.equal(s.value(u,'magicAtk'),10000);
 const frame={targets:[],reactions:[]};ctx.chakra=[60,60];a.afterHit(ctx,u,enemy,[enemy,e2],a.config.mystery,frame);assert.equal(enemy.armorSuppressedUntil,11);assert.equal(enemy.mysteryReadyRound,12);assert.equal(s.value(ally,'critRate'),.2);assert(a.barrier(ally));assert(a.immuneStatus(ally,'ignition'));assert(!require('../pain-combat').mysteryReady(ctx,enemy));
 a.onDamage(ctx,u,{damage:100});assert.equal(s.value(u,'atk'),9800*1.08);assert.equal(s.value(u,'def'),5250);
 a.afterHit(ctx,u,enemy,[enemy],a.config.modified,frame);assert.equal(ctx.chakra[1-camp],0);assert.equal(u.mysteryReadyRound,10);assert(a.active(enemy,'asuraBanishedUntil'));assert(n.disabled(enemy));
 a.afterHit(ctx,u,ally,[],a.config.protection,frame);assert.equal(ctx.chakraLimit[camp],100);for(let i=0;i<6;i++)assert.equal(a.pureProtection(ally,{pureTaijutsu:true}),i<5);
 n.startRound(ctx,11);assert(!a.immune(u));assert(!a.active(enemy,'asuraBanishedUntil'));
 e2.hp=1;a.afterHit(ctx,u,e2,[e2],a.config.standard,frame);e2.hp=0;a.afterHit(ctx,u,e2,[e2],a.config.standard,frame);assert(e2.noRevive);
 assert.equal(a.beforeMove(ctx,u,a.config.mystery,ally).id,a.config.protection.id);
}
for(let pos=1;pos<=15;pos++)assert.equal(b.heroBirim(a.config.heroId,pos,159,null,null,0,true).pos,pos);
const f=fixture(0);f.u.hp=1;f.ally.hp=0;assert.equal(a.revivals(f.ctx)[0].records[0].result.hurtHp,-100000);
const report=b.kadroRapor(0,{name:'Asura regression',level:159,units:[unit(12101003,6,1)]},null,{playerUnits:[unit(a.config.heroId,6,0),unit(11100001,1,0)],scaleEnemy:false,battleDataVersion:4,random:()=>.7});assert(report.payload.length);assert(require('../kodek').decodeBattleReport(report.payload).turns.length<100);
console.log('PASS Asura: both camps, two-round full immunity, ally cooldown/no-revive, delayed self-revival/no wipe stall, cleansing/healing, caps, physical scaling, barrier, banishment, protection and finite report');
