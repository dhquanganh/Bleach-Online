'use strict';
const assert=require('node:assert/strict'),i=require('../itachi-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),{ACTIVE,CMD,ST}=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:100000,maxHp:100000,atk:1000,magicAtk:5,def:100,resistance:5,speed:100,hitRate:1,critRate:0,anger:0,level:99,quality:7,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=1){const u=unit(i.config.heroId,pos,camp),enemies=Array.from({length:15},(_,p)=>unit(200,p+1,1-camp));const ctx=n.create(camp?[enemies,[u]]:[[u],enemies],{random:()=>.5});n.startRound(ctx,1);i.roundStart(ctx);return {u,enemies,ctx};}
function strike(f,move){const frame=battle.vurus(f.u,f.enemies[0],false,f.enemies,()=>.5,false,[f.u],n.attackSpec(move));const hit=f.enemies.filter(t=>frame.targets.some(r=>r.cmd===CMD.ATTACK&&r.targetCamp===t.camp&&r.targetPos===t.pos&&(r.reportTargetStatus&ST.HIT)));i.afterHit(f.ctx,f.u,f.enemies[0],hit,move,frame);return frame;}
for(const camp of [0,1])for(let pos=1;pos<=15;pos++){
 let f=fixture(camp,pos),{u,ctx,enemies}=f;assert.equal(n.profile(u).assess,'SSS');ctx.chakra[camp]=20;ctx.chakra[1-camp]=80;assert.equal(n.useMystery(ctx,u).id,i.config.mystery.id);strike(f,i.config.mystery);assert.equal(ctx.chakra[1-camp],0);assert.equal(ctx.chakra[camp],80);assert.equal(ctx.chakraLimit[1-camp],10);assert.equal(n.profile(u).mystery.id,i.config.modifiedMystery.id);assert.equal(n.useMystery(ctx,u),null);
 n.startRound(ctx,2);i.roundStart(ctx);assert.equal(ctx.chakra[1-camp],10);n.startRound(ctx,3);i.roundStart(ctx);assert.equal(ctx.chakraLimit[1-camp],100);ctx.chakra[camp]=40;assert.equal(n.useMystery(ctx,u).id,i.config.modifiedMystery.id);strike(f,i.config.modifiedMystery);assert.equal(ctx.chakraLimit[1-camp],40);assert.equal(enemies[0].extremeChaosUntil,3);
 f=fixture(camp,pos);({u,ctx,enemies}=f);strike(f,i.config.standard);assert.equal(enemies.filter(t=>t.suppressedUntil===1).length,3);strike(f,i.config.standard);assert.equal(enemies[0].extremeChaosUntil,1);
 for(const [kind,move] of [['mystery',{prompt:true}],['chase',{activeType:ACTIVE.NORMAL_EX}],['standard',{}]]){const a=i.beforeDamage(ctx,enemies[0],u,move,100);assert.equal(a,50,kind);assert.equal(i.beforeDamage(ctx,enemies[0],u,move,100),50);assert.equal(i.beforeDamage(ctx,enemies[0],u,move,100),100);}
 assert.equal(i.triggers(ctx).length,6);i.beforeAction(ctx,u);assert.equal(i.triggers(ctx)[0].move.id,i.config.crow.id);assert(i.evade(ctx,u,{activeType:ACTIVE.NORMAL_EX},()=>0));assert(s.value(u,'atk')>1000);
 for(let k=0;k<10;k++)i.evaded(u);assert.equal(u.itachiEvades,7);const records=[];assert(i.debuff(u,{kind:'control',field:'stun',level:2,value:1},records));assert.equal(u.itachiHidingUntil,1);
}
const damage=change=>{const f=fixture();change?.(f);return strike(f,i.config.modifiedMystery).targets.filter(r=>r.cmd===CMD.ATTACK).reduce((sum,r)=>sum+Math.max(0,r.result.hurtHp||0),0);};
const base=damage();assert(damage(f=>f.u.atk*=2)>base);assert(damage(f=>f.enemies.forEach(e=>e.def*=20))<base);assert.equal(damage(f=>f.u.magicAtk*=10000),base);assert.equal(damage(f=>f.enemies.forEach(e=>e.resistance*=10000)),base);
for(const key of ['mystery','modifiedMystery','standard','deidara','pain','hidan']){assert.equal(i.config[key].attackStat,'atk');assert.equal(i.config[key].damageType,'physical');}
{
 const f=fixture();f.u.hp=1;
 for(let k=0;k<8;k++)i.onDamage(f.ctx,f.u,f.enemies[0],{damage:100},i.config.hidan,[],true);
 assert.equal(f.u.itachiCriticalTriggers,5);assert.equal(f.u.hp,75001);assert.equal(f.u.itachiCritical,.4);
 strike(f,i.config.deidara);assert(f.enemies.every(t=>t.hp>0));assert.equal(f.enemies.filter(t=>t.paralyzed).length,9);assert(s.status(f.enemies[0],'noHeal'));
 const hp=f.enemies[0].hp;s.endRound(f.enemies);s.startRound(f.enemies);assert(f.enemies[0].hp<hp,'physical ignition ticks');
 const p=f.enemies.map((t,k)=>({...t,hp:1000+k*10}));f.enemies=p;const chosen=i.targets(f.ctx,f.u,i.config.hidan,p[12],p);assert.deepEqual(chosen.map(t=>t.pos),[1,2,3]);
 f.enemies[0].hp=1;strike(f,i.config.pain);assert(f.enemies[0].itachiUnrevivable);assert(!f.enemies[1].itachiUnrevivable,'survivors are not permanently marked');
}
{
 const f=fixture();f.u.speed=1000;const result=battle.kadroRapor(0,null,{ad:'Itachi encoded scheduling',birimler:[{...f.enemies[0],id:11120950}]},{playerUnits:[{...f.u,pos:15}],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});const codec=require('../kodek'),report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);const actions=report.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===0&&a.activePos===15);for(const skill of [i.config.mystery.id,i.config.modifiedMystery.id,i.config.standard.id,i.config.crow.id,i.config.hidan.id])assert(actions.some(a=>a.skillEffectId===skill),'scheduled '+skill);
}
console.log('PASS Itachi: every position/both camps, base/modified Mystery and CD2, Chakra drain/cap expiry, standard suppression, separate twice-per-round reductions/counters, Crow/evasion growth, Level 2 debuff cancellation/Hiding, physical ATK/DEF independence.');
