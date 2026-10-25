'use strict';
const assert=require('node:assert/strict');
const n=require('../naruto-combat'),j=require('../jiraiya-combat'),p=require('../pain-combat'),t=require('../tsunade-combat');
const battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function fixture(module,camp){
 const u=unit(module.config.heroId,1,camp),ally=unit(300,2,camp),enemy=unit(400,1,1-camp);
 const ctx=n.create(camp?[[enemy],[u,ally]]:[[u,ally],[enemy]],{random:()=>.5});n.startRound(ctx,1);
 return {u,ally,enemy,ctx};
}
for(const camp of [0,1]){
 for(const module of [j,p,t])for(const flag of ['noRevive','itachiUnrevivable']){
  const {u,ctx}=fixture(module,camp);u.hp=0;u[flag]=true;
  if(module===j){j.noteDeaths(ctx);ctx.mysteryCounts[camp]+=3;}
  assert.deepEqual(module.revivals(ctx),[],`${module.config.name}: ${flag}`);
  assert.equal(u.hp,0,'blocked revival must not change HP');
  assert(!u.painFinal&&!u.tsunadeRevived,'blocked revival must not consume the form');
 }
 // The final-form conditional revival is blocked too, without spending its check.
 for(const flag of ['noRevive','itachiUnrevivable']){
  const {u,ally,ctx}=fixture(p,camp);u.hp=0;p.revivals(ctx);ally.hp=0;u.hp=0;u[flag]=true;
  assert.equal(p.revivals(ctx).length,0);assert(!u.painFinalDeathChecked);assert(!u.painFinalRevived);
 }
 // Jiraiya's second defeat starts a new three-Mystery countdown, preserving action recovery.
 {
  const {u,ally,enemy,ctx}=fixture(j,camp);u.hp=0;j.noteDeaths(ctx);
  for(let k=0;k<3;k++)j.mysteryUsed(ctx,enemy,{});
  assert.equal(j.revivals(ctx).length,0,'enemy Mysteries cannot revive Jiraiya');
  for(let k=0;k<3;k++)j.mysteryUsed(ctx,ally,{});
  u.mysteryReadyRound=9;assert.equal(j.revivals(ctx).length,1);assert.equal(u.hp,3000);
  assert.equal(u.mysteryReadyRound,9);assert.equal(ctx.primaryActions.get(u),ctx.round);
  u.hp=0;j.noteDeaths(ctx);assert.equal(j.revivals(ctx).length,0);
  for(let k=0;k<2;k++)j.mysteryUsed(ctx,ally,{});
  assert.equal(j.revivals(ctx).length,0);j.mysteryUsed(ctx,ally,{});assert.equal(j.revivals(ctx).length,1);
 }
 // Encoded battles must resolve a last standing ninja's immediate revival before defeat.
 for(const module of [p,t]){
  const u=unit(module.config.heroId,1,camp),killer=unit(12101003,1,1-camp);
  u.hp=10;u.speed=1;killer.hp=killer.maxHp=1000000;killer.atk=50000;killer.speed=1000;killer.immuneDebuffs=true;
  const result=battle.kadroRapor(0,null,{ad:'Last ninja revival audit',birimler:camp?[u]:[killer]},
   {playerUnits:camp?[killer]:[u],playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.5});
  const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
  const moves=report.turns.flatMap(turn=>turn.actives);
  const id=module===p?p.config.transformation.id:t.config.revival.id;
  const index=moves.findIndex(a=>a.activeCamp===camp&&a.skillEffectId===id);
  assert(index>0,'last ninja gets revival animation before battle ends');
  assert(moves[index-1].targets.some(r=>r.targetCamp===camp&&r.targetPos===1&&r.result.hurtHp===-10000),'HP restored before animation');
  assert.equal(moves.filter(a=>a.activeCamp===camp&&a.skillEffectId===id).length,1);
 }
 // Inject a fatal reaction at the Mystery completion boundary. This isolates
 // the scheduler guard: dead casters must not emit the queued additional move.
 {
  const u=unit(j.config.heroId,1,camp),enemy=unit(12101003,1,1-camp);
  enemy.hp=enemy.maxHp=1000000;enemy.atk=1;u.speed=1000;
  const original=j.mysteryUsed;let injected=false,result;
  try{
   j.mysteryUsed=(ctx,actor,move)=>{
    const extra=original(ctx,actor,move);
    if(actor.id===j.config.heroId&&extra&&!injected){actor.hp=0;injected=true;}
    return extra;
   };
   result=battle.kadroRapor(0,null,{ad:'Fatal Mystery reaction scheduler',birimler:camp?[u]:[enemy]},
    {playerUnits:camp?[enemy]:[u],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});
  }finally{j.mysteryUsed=original;}
  assert(injected);
  const moves=codec.decodeBattleReport(result.payload).turns.flatMap(turn=>turn.actives);
  assert(moves.some(a=>a.activeCamp===camp&&a.skillEffectId===j.config.mystery.id));
  assert(!moves.some(a=>a.activeCamp===camp&&a.skillEffectId===j.config.additional.id),'dead caster cannot execute queued additional');
 }
}
console.log('PASS revival audit: both camps, all revival blocks/forms, Jiraiya repeated death/countdown/action budget, last ninja encoded HP-before-animation.');
