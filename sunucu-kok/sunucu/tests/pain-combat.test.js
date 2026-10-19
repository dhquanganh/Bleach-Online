'use strict';
const assert=require('node:assert/strict'),p=require('../pain-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),{ST,CMD}=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
const pain=(camp=0)=>({...unit(p.config.heroId,6,camp),normal:p.config.standard.id,skill:p.config.mystery.id,skillId:p.config.mystery.id});
function fixture(camp=0){const u=pain(camp),enemy=unit(200,1,1-camp),ally=unit(300,7,camp);const teams=camp?[[enemy],[u,ally]]:[[u,ally],[enemy]];const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);return {u,enemy,ally,ctx};}
for(const camp of [0,1]){
 let {u,enemy,ally,ctx}=fixture(camp);assert(n.profile(u));assert.equal(n.canMystery(ctx,u),false);
 assert.deepEqual(p.roundStart(ctx).map(r=>r.move.id),[p.config.laser.id]);
 let f=battle.vurus(u,enemy,false,ctx.teams[1-camp],()=>.5,false,ctx.teams[camp],n.attackSpec(p.config.laser));p.afterHit(ctx,u,enemy,[enemy],p.config.laser,f);
 assert.equal(u.painTechnique,1);assert.equal(ctx.chakra[1-camp],10);assert(p.active(u,'painInterruptImmuneUntil'));assert(p.active(u,'painUnavoidableUntil'));
 assert(n.canMystery(ctx,u));let move=n.useMystery(ctx,u);assert.equal(move.id,p.config.mystery.id);assert.equal(ctx.chakra[camp],0);assert.equal(u.painTechnique,0);assert.equal(u.mysteryReadyRound,3);
 f={targets:[],reactions:[]};p.afterHit(ctx,u,enemy,[enemy],move,f);assert.equal(enemy.painHorrorUntil,2);assert.equal(enemy.painCost,20);assert.equal(enemy.painInterruptedUntil,1);
 assert.equal(n.useStandard(ctx,enemy,[enemy]),null);
 const rec=[];s.apply({id:1,effects:[{kind:'buff',scope:'a',field:'atk',value:.5,turns:2},{kind:'shield',scope:'a',value:10}]},ally,[enemy],[],[],rec,()=>.5);assert.equal(enemy.shield||0,0);assert(!enemy.skillBuffs?.length);
 enemy.naruto={mystery:{...p.config.mystery,chakraCost:0,techniqueCost:0},standard:p.config.standard};delete enemy.painInterruptedUntil;ctx.chakra[1-camp]=100;
 assert(n.useMystery(ctx,enemy));assert(!p.active(enemy,'painHorrorUntil'));
 f={targets:[],reactions:[]};p.afterHit(ctx,u,enemy,[enemy],p.config.standard,f);assert.equal(u.painTechnique,1);assert.equal(u.mysteryReadyRound,2);
 // TP supports half points and caps at five; each landed incoming attack grants .5.
 p.onHit(ctx,enemy,u,{before:u.hp,damage:10},false,[]);assert.equal(u.painTechnique,1.5);p.points(u,50);assert.equal(u.painTechnique,5);
 assert.equal(s.value(u,'magicAtk'),160);
 const stacks=u.painDamageStacks||0;p.onHit(ctx,u,enemy,{before:enemy.hp,damage:10},true,[]);assert.equal(u.painDamageStacks,stacks+1);assert.equal(enemy.painDisruptionUntil,2);
 // Non-Level-2 debuffs are canceled and Initiative is capped at +10%.
 for(let i=0;i<8;i++)s.apply({id:2,effects:[{kind:'buff',scope:'t',field:'stun',value:1,turns:2}]},enemy,[enemy],[u],[u],[],()=>.5);
 assert(!s.status(u,'stun'));assert.equal(u.painInitiativeStacks,5);assert.equal(s.value(u,'speed'),110.00000000000001);
 // Extreme uses all TP, keeps chakra cost 20, five combo and 7% actual-damage life steal.
 u.hp=5999;ctx.chakra[camp]=100;u.mysteryReadyRound=1;u.painMysteries=0;move=n.useMystery(ctx,u);assert.equal(move.id,p.config.extremeMystery.id);assert.equal(move.combo,5);assert.equal(u.painTechnique,0);assert.equal(u.mysteryReadyRound,4);
 f={targets:[{cmd:CMD.ATTACK,targetCamp:1-camp,result:{hurtHp:1000}}],reactions:[]};p.afterHit(ctx,u,enemy,[enemy],move,f);assert.equal(u.hp,6069);
 // Chase includes orthogonal neighbors only and applies all three Level-2 debuffs.
 const adjacent=unit(201,2,1-camp),diagonal=unit(202,7,1-camp);ctx.teams[1-camp].push(adjacent,diagonal);
 assert.deepEqual(p.targetList(p.config.chases[0],enemy,ctx.teams[1-camp]).map(x=>x.id),[200,201]);
 f={targets:[],reactions:[]};p.afterHit(ctx,u,enemy,[enemy,adjacent],p.config.chases[0],f);assert.equal(enemy.painAfflictionUntil,2);assert.equal(ctx.chakraLimit[1-camp],20);assert.equal(ctx.chakra[1-camp],20);
 assert.equal(s.value(enemy,'def'),75);assert.equal(s.value(enemy,'resistance'),75);const hp=enemy.hp;p.beforeStandard(enemy);assert.equal(enemy.hp,hp-Math.round(hp*.1));
 assert.equal(s.value(enemy,'atk'),90);n.startRound(ctx,2);assert(p.active(enemy,'painAfflictionUntil'));n.startRound(ctx,3);assert(!p.active(enemy,'painAfflictionUntil'));assert.equal(ctx.chakraLimit[1-camp],100);
 // First revival is 100%, final form has ONLY the two stated skills.
 u.hp=0;let revived=p.revivals(ctx);assert.equal(revived.length,1);assert.equal(u.hp,u.maxHp);assert(u.painFinal);assert.equal(n.standard(u,[u,ally]),null);assert.deepEqual(n.profile(u).chases,[]);assert.equal(p.roundStart(ctx).length,0);assert(s.status(u,'immuneDebuffs'));assert.equal(n.setState(u,'repulse',3),null);
 p.points(u,5);assert.equal(s.value(u,'atk'),200);assert.equal(s.value(u,'magicAtk'),200);u.painTechnique=0;p.onHit(ctx,enemy,u,{before:u.hp,damage:10},false,[]);assert.equal(u.painTechnique,1);
 p.points(u,4);u.painMysteries=0;u.mysteryReadyRound=3;ctx.chakra[camp]=0;
 assert.equal(n.useMystery(ctx,u).id,p.config.finalMystery.id);assert.equal(n.useMystery(ctx,u).id,p.config.finalMystery.id);assert.equal(n.useMystery(ctx,u),null);assert.equal(u.painTechnique,1);
 const cost=enemy.painCostRound===3?enemy.painCost:0;p.onHit(ctx,u,enemy,{before:enemy.hp,damage:10},true,[]);assert.equal(enemy.painCost,cost+20);
 ally.hp=0;u.hp=0;revived=p.revivals(ctx);assert.equal(u.hp,4000);assert.equal(revived[0].move.id,p.config.superPush.id);
 u.hp=0;assert.equal(p.revivals(ctx).length,0);assert.equal(u.hp,0);
 ({u,enemy,ally,ctx}=fixture(camp));u.hp=0;p.revivals(ctx);u.hp=0;assert.equal(p.revivals(ctx).length,0);ally.hp=0;assert.equal(p.revivals(ctx).length,0,'a later ally death cannot retroactively satisfy the revival condition');
}
// Actual encoded scheduling must retain all bytes and remove old skills after revival.
const codec=require('../kodek');
const team=camp=>[pain(camp),unit(12101003,1,camp)];
const report=battle.kadroRapor(0,null,{ad:'Pain scheduling regression',birimler:team(1)},{playerUnits:team(0),playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const decoded=codec.decodeBattleReport(report.payload);assert.equal(decoded._consumed,decoded._total);
// Verify the real report scheduler obeys passive/chase recovery, not just helper calls.
for(const camp of [0,1]) for(const move of [p.config.laser,p.config.chases[0]]){
 let last=-Infinity;
 decoded.turns.forEach((turn,index)=>{
  for(const action of turn.actives)if(action.activeCamp===camp&&action.skillEffectId===move.id){
   assert(index-last>=Math.max(1,move.cooldown),`encoded skill ${move.id} bypassed recovery`);last=index;
  }
 });
}
const finalCamps=new Set();
for(const turn of decoded.turns){
 for(const camp of [0,1])assert(turn.actives.filter(a=>a.activeCamp===camp&&a.skillEffectId===p.config.finalMystery.id).length<=2);
 for(const act of turn.actives){
  if(act.skillEffectId===p.config.transformation.id)finalCamps.add(act.activeCamp);
  else if(finalCamps.has(act.activeCamp))assert(![p.config.standard.id,p.config.laser.id,p.config.mystery.id,p.config.extremeMystery.id,p.config.chases[0].id].includes(act.skillEffectId));
 }
}
assert(finalCamps.size>0);assert(decoded.turns.some(t=>t.actives.some(a=>a.skillEffectId===p.config.extremeMystery.id)));
const first=pain(),dead=unit(12101003,1,0);dead.hp=0;
const killer=unit(12101003,1,1);killer.atk=50000;killer.hp=killer.maxHp=100000;killer.immuneDebuffs=true;
const revivalReport=battle.kadroRapor(0,null,{ad:'Pain revival regression',birimler:[killer]},{playerUnits:[first,dead],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
const revDecoded=codec.decodeBattleReport(revivalReport.payload);assert.equal(revDecoded._consumed,revDecoded._total);
const acts=revDecoded.turns.flatMap(t=>t.actives);
for(const move of [p.config.transformation,p.config.finalRevival,p.config.superPush])assert.equal(acts.filter(a=>a.skillEffectId===move.id).length,1);
for(const move of [p.config.transformation,p.config.finalRevival]){
 const index=acts.findIndex(a=>a.skillEffectId===move.id);assert(acts[index-1].targets.some(t=>t.result.hurtHp<0),'revival HP must be restored before the native animation starts');
}
// Chakra surcharges and Fear apply to ordinary Bleach Mysteries too.
let f=fixture();f.enemy.skill=13100001;f.enemy.skillId=13100001;f.enemy.anger=100;f.enemy.painCostRound=1;f.enemy.painCost=20;f.enemy.painHorrorUntil=2;
f.ctx.chakra[1]=10;let action=battle.vurus(f.enemy,f.u,false,[f.u],()=>.5,false,[f.enemy]);assert.equal(action.activeType,codec.ACTIVE.NORMAL);assert.equal(f.ctx.chakra[1],10);
f.enemy.anger=100;f.ctx.chakra[1]=20;action=battle.vurus(f.enemy,f.u,false,[f.u],()=>.5,false,[f.enemy]);assert.equal(action.activeType,codec.ACTIVE.SKILL);assert.equal(f.ctx.chakra[1],0);assert(!p.active(f.enemy,'painHorrorUntil'));
console.log('PASS Pain encoded reports: both camps, cooldown/phase scheduling, final skill loss, both revivals, native healing-before-animation and generic Mystery surcharges.');
// Being attacked gives a point credit even when the hit is dodged, without doubling on a landed hit.
f=fixture();f.u.dodgeRate=1;f.enemy.hitRate=0;battle.vurus(f.enemy,f.u,false,[f.u],()=>.5,false,[f.enemy]);assert.equal(f.u.painTechnique,.5);assert.equal(f.u.hp,10000);
f.u.dodgeRate=0;f.enemy.hitRate=1;battle.vurus(f.enemy,f.u,false,[f.u],()=>.5,false,[f.enemy]);assert.equal(f.u.painTechnique,1);
// Unavoidable Final/Chase damage also bypasses a next-attack evasion such as Kamui.
const obito=require('../obito-combat');f=fixture();const guarded={...unit(obito.config.heroId,1,1),obitoKamui:{chance:1,round:1}};f.ctx.teams[1]=[guarded];guarded.battleRound=1;
action=battle.vurus(f.u,guarded,false,[guarded],()=>.5,false,[f.u],n.attackSpec(p.config.finalMystery));assert(action.targets.some(t=>t.cmd===CMD.ATTACK&&t.result.hurtHp>0));
console.log('PASS Pain: both camps, TP/half-points/cap, all base/extreme/final/super moves, costs/cooldowns, two Final Mysteries, Horror/external buffs/shields, Disruption/Pain/chakra cap and durations, growth/cancel/Initiative, both revivals and final skill loss.');

// Recovery survives HP transitions and resurrection; Final retains its two-cast window.
for(const camp of [0,1]){
 const {u,enemy,ctx}=fixture(camp);p.points(u,5);ctx.chakra[camp]=100;
 assert(n.useMystery(ctx,u));u.hp=5000;
 assert.equal(n.canMystery(ctx,u),false,'HP threshold cannot reset Mystery recovery');
 u.hp=0;p.revivals(ctx);assert.equal(u.mysteryReadyRound,3);
 assert.equal(n.canMystery(ctx,u),false,'revival cannot reset Mystery recovery');
 n.startRound(ctx,2);p.roundStart(ctx);assert.equal(n.canMystery(ctx,u),false);
 n.startRound(ctx,3);p.roundStart(ctx);p.points(u,5);
 assert(n.useMystery(ctx,u));assert(n.useMystery(ctx,u));assert.equal(n.useMystery(ctx,u),null);
 assert.equal(u.mysteryReadyRound,5);
 n.startRound(ctx,4);p.roundStart(ctx);p.points(u,5);assert.equal(n.canMystery(ctx,u),false);
 n.startRound(ctx,5);p.roundStart(ctx);assert(n.useMystery(ctx,u));
 const f=fixture(camp);const frame={targets:[],reactions:[]};
 p.afterHit(f.ctx,f.u,f.enemy,[f.enemy],p.config.laser,frame);
 assert.equal(p.roundStart(f.ctx).length,0);
 n.startRound(f.ctx,2);assert.equal(p.roundStart(f.ctx).length,1);
 n.startRound(f.ctx,3);assert.equal(p.roundStart(f.ctx).length,1);
 // Chase budgets reset next round without a cooldown gap.
 const open=()=>({targets:[{cmd:CMD.ATTACK,targetCamp:1-camp,targetPos:f.enemy.pos,reportTargetStatus:ST.HIT,result:{hurtHp:1}}]});
 const strike=()=>open();const spec={combo:1,causes:'repulse'};
 assert.equal(n.resolve(f.ctx,f.u,f.enemy,open(),spec,strike).length,1);
 n.startRound(f.ctx,4);assert.equal(n.resolve(f.ctx,f.u,f.enemy,open(),spec,strike).length,1);
 n.startRound(f.ctx,5);assert.equal(n.resolve(f.ctx,f.u,f.enemy,open(),spec,strike).length,1);
}
console.log('PASS Pain recovery: form changes, resurrection, Final double-cast windows, Laser and Chase across rounds in both camps.');
