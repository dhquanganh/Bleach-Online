'use strict';
const assert=require('node:assert/strict');
const k=require('../kakuzu-edo-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:1000,magicAtk:700,def:500,resistance:700,speed:100,level:99,quality:7,profession:1,hitRate:1,anger:0,normal:13100114,skill:0,skillId:13100114,verdi:0,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=1){const u=unit(k.config.heroId,pos,camp),enemies=[1,2,6,7,11].map(p=>unit(12101003,p,1-camp));const teams=camp?[enemies,[u]]:[[u],enemies];k.prepareSummons(teams);const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);return {u,enemies,ctx,clone:teams[camp].find(k.isClone)};}
const strike=(u,v,m)=>battle.vurus(u,v,false,[v],()=>.5,false,[u],n.attackSpec(m));
for(const camp of [0,1])for(let pos=1;pos<=15;pos++){
  const {u,ctx,clone}=fixture(camp,pos);assert(n.profile(u));assert(s.status(u,'immuneDebuffs'));assert(clone&&clone.hp===0&&clone.maxHp===9000);
  assert.equal(k.battleStart(ctx).length,1);assert.equal(clone.hp,9000);
  assert.equal(n.useMystery(ctx,u).id,13121901);assert.equal(n.useMystery(ctx,u),null);
  n.startRound(ctx,2);assert.equal(n.useMystery(ctx,u),null);n.startRound(ctx,4);assert.equal(n.useMystery(ctx,u).id,13121901);
}
for(const camp of [0,1]){
  const {u,enemies,ctx,clone}=fixture(camp);k.battleStart(ctx);const v=enemies[0];
  const damage=move=>{v.hp=v.maxHp=1000000;return strike(u,v,move).targets.find(r=>r.cmd===1&&r.targetCamp!==camp).result.hurtHp;};
  for(const move of [k.config.mystery,k.config.standard,k.config.pressure,k.config.darkness,k.config.migraine]){
    const base=damage(move);assert(base>0);u.atk*=2;assert(damage(move)>base);u.atk/=2;
    u.magicAtk*=100;v.resistance*=100;assert.equal(damage(move),base);u.magicAtk/=100;v.resistance/=100;
    v.def*=100;assert(damage(move)<base);v.def/=100;
    assert.equal(move.attackStat,'atk');assert.equal(move.damageType,'physical');
  }
  const cloneDamage=()=>{v.hp=v.maxHp=1000000;return strike(clone,v,k.config.cloneStandard).targets.find(r=>r.cmd===1&&r.targetCamp!==camp).result.hurtHp;};
  const baseClone=cloneDamage();clone.atk*=2;assert(cloneDamage()>baseClone);clone.atk/=2;v.def*=100;assert(cloneDamage()<baseClone);v.def/=100;
  assert.deepEqual(k.targets(k.config.pressure,v,enemies,ctx).map(x=>x.pos),[6,7]);
  u.hp=100;assert.equal(k.beforeDamage(ctx,u,{prompt:true},99999),99,'living clone protects from fatal Mystery');clone.hp=0;assert.equal(k.beforeDamage(ctx,u,{prompt:true},99999),99999);
  clone.hp=1000;enemies[0].rebirth={n:100,ae:8};enemies[0].skill=k.config.mystery.id;
  battle.vurus(enemies[0],u,false,[u],()=>.5,false,[enemies[0]],n.attackSpec({...k.config.mystery,multiplier:100}));assert(u.hp>=1,'living clone also blocks legacy fatal Mystery effects');delete enemies[0].rebirth;clone.hp=0;
  u.hp=0;k.noteDeaths(ctx);assert.equal(u.kakuzuReviveRound,2);n.startRound(ctx,2);let revival=k.roundStart(ctx);assert(revival.some(x=>x.skillEffectId===k.config.reincarnation.id));assert.equal(u.hp,2500);assert.equal(u.mysteryReadyRound,2);assert.equal(clone.hp,9000);
  u.hp=0;k.noteDeaths(ctx);assert.equal(u.kakuzuReviveRound,3,'reincarnation remains active after revival');
  const ally=unit(11100001,15,camp);ctx.teams[camp].push(ally);ally.hp=0;clone.hp=1000;
  const heals=k.endRound(ctx);assert(heals.some(x=>x.targets.some(r=>r.targetPos===ally.pos&&r.result.hurtHp<0)));
}
{
  const {u,enemies,ctx,clone}=fixture();k.battleStart(ctx);const v=enemies[0],frame={targets:[],reactions:[]};
  k.afterHit(ctx,u,v,[v],k.config.standard,frame);assert.equal(v.armorSuppressedUntil,1);const extra=k.triggers(ctx);assert.equal(extra.length,1);assert([k.config.pressure.id,k.config.darkness.id,k.config.migraine.id].includes(extra[0].move.id));
  k.afterHit(ctx,u,v,[v],k.config.pressure,frame);assert.equal(u.kakuzuInitiativeUntil,2);assert.equal(v.kakuzuDiscouragementUntil,2);
  u.mysteryReadyRound=5;k.afterHit(ctx,u,v,[v],k.config.darkness,frame);assert.equal(u.mysteryReadyRound,4);assert(v.paralyzed);
  k.afterHit(ctx,u,v,[v],k.config.migraine,frame);assert.equal(v.suppressedUntil,1);
  u.hp=1000;v.hp=0;k.afterHit(ctx,u,v,[v],k.config.mystery,frame);assert.equal(u.hp,3000);assert.equal(u.kakuzuAttackStacks,1);assert(s.value(u,'atk')>u.atk);
  const pending=k.prepareMove(ctx,u,k.config.mystery,enemies[1]);assert(pending.kakuzuMystery);enemies[1].shield=1000;k.prepareMove(ctx,u,k.config.mystery,enemies[1]);assert.equal(enemies[1].shield,0);
  clone.immobileUntil=1;const ally=unit(11100001,15,0);ally.hp=0;ctx.teams[0].push(ally);k.endRound(ctx);assert(ally.hp>0,'clone Reattachment remains active while controlled');
}
for(const camp of [0,1]){
  const {u,enemies}=fixture(camp);enemies.forEach(e=>{e.hp=e.maxHp=1000000;e.atk=20;});
  const result=battle.kadroRapor(0,null,{ad:'Kakuzu integration',birimler:camp?[u]:enemies},{playerUnits:camp?enemies:[u],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
  const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
  const events=report.turns.flatMap(t=>t.actives);assert(events.some(e=>e.skillEffectId===k.config.cloneCall.id));assert(events.some(e=>e.skillEffectId===k.config.standard.id));
}
console.log('PASS Kakuzu Edo: both camps/all positions, Physical ATK/DEF, Water Clone summon/protection, next-round revival, ally rescue and encoded battle reports.');
