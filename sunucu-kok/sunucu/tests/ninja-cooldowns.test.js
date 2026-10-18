'use strict';
const assert=require('assert'),n=require('../naruto-combat'),j=require('../jiraiya-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:1e8,maxHp:1e8,atk:100,magicAtk:100,def:0,resistance:0,speed:100,hitRate:1,normal:13100114,skill:0,skillId:13100114,level:100,quality:7,anger:100,partnerSkills:[],weaponSkills:[]});
const start=(ctx,round)=>{n.startRound(ctx,round);j.roundStart(ctx);ctx.chakra=[100,100];};
for(const hero of [n.config,j.config])for(const camp of [0,1]){
 const u=unit(hero.heroId,6,camp),target=unit(200,1,1-camp),teams=[[],[]];teams[camp]=[u];teams[1-camp]=[target];
 const ctx=n.create(teams);start(ctx,2);
 assert(n.useMystery(ctx,u));const chakra=ctx.chakra[camp];
 assert.strictEqual(n.useMystery(ctx,u),null,'Duplicate Mystery must not execute');
 assert.strictEqual(ctx.chakra[camp],chakra,'Rejected cast must not spend chakra');
 assert.strictEqual(n.useStandard(ctx,u,teams[camp]),null,'Mystery consumes the primary action');
 start(ctx,3);assert(!n.canMystery(ctx,u));assert(n.useStandard(ctx,u,teams[camp]));
 assert.strictEqual(n.useStandard(ctx,u,teams[camp]),null,'One primary action per round');
 start(ctx,4);assert(!n.canMystery(ctx,u));assert.strictEqual(n.useStandard(ctx,u,teams[camp]),null,'Standard needs a complete recovery round');
 start(ctx,5);assert(n.useMystery(ctx,u));
 // Failed casts do not spend an action or start cooldowns.
 start(ctx,8);ctx.chakra[camp]=0;assert.strictEqual(n.useMystery(ctx,u),null);assert(n.useStandard(ctx,u,teams[camp]));
}
// Clone death/revival cannot switch from Barrage to Summon to evade recovery.
{
 const u=unit(n.config.heroId,6),team=[u];n.prepareClones([team,[]]);const ctx=n.create([team,[]]);
 start(ctx,1);assert.strictEqual(n.useStandard(ctx,u,team).id,n.config.barrage.id);
 team[1].hp=0;start(ctx,2);assert.strictEqual(n.useStandard(ctx,u,team),null);
 start(ctx,3);assert.strictEqual(n.useStandard(ctx,u,team).id,n.config.standard.id);
 n.summon(u,team);assert.strictEqual(n.useStandard(ctx,u,team),null);
}
// Chase limits survive new chains and round boundaries; team bonus cannot bypass them.
for(const hero of [n.config,j.config]){
 const u=unit(hero.heroId,6),v=unit(200,1,1),ctx=n.create([[u],[v]],{random:()=>.5});
 const hit=()=>({targets:[{cmd:1,targetCamp:1,targetPos:1,reportTargetStatus:codec.ST.HIT>>>0,result:{hurtHp:1}}],reactions:[]});
 const strike=(actor,target,move)=>{const f=hit();j.afterHit(ctx,actor,[target],move,f.targets);return f;};
 const opener={combo:15,causes:'repulse'};
 start(ctx,1);ctx.chaseBonus[0]=1;
 assert.strictEqual(n.resolve(ctx,u,v,hit(),opener,strike).length,1);
 assert.strictEqual(n.resolve(ctx,u,v,hit(),opener,strike).length,0);
 start(ctx,2);assert.strictEqual(n.resolve(ctx,u,v,hit(),opener,strike).length,0);
 start(ctx,3);assert.strictEqual(n.resolve(ctx,u,v,hit(),opener,strike).length,1);
}
// Stacked Jiraiyas cannot chain control through the protected recovery round.
{
 const a=unit(j.config.heroId,6),b=unit(j.config.heroId,7),v=unit(200,1,1),ctx=n.create([[a,b],[v]]);
 start(ctx,1);j.afterHit(ctx,a,[v],j.config.additional,[]);assert(s.status(v,'chaos'));
 const records=[];j.afterHit(ctx,b,[v],j.config.additional,records);assert.strictEqual(records.length,0);
 start(ctx,2);assert(!s.status(v,'chaos'));j.afterHit(ctx,b,[v],j.config.additional,records);assert(!s.status(v,'chaos'));
 start(ctx,3);j.afterHit(ctx,b,[v],j.config.additional,[]);assert(s.status(v,'chaos'));
}
// Revival keeps Mystery/standard/Chase cooldowns; old reduction stacks do not shorten new casts.
{
 const u=unit(j.config.heroId,6),v=unit(200,1,1),ctx=n.create([[u],[v]]);
 start(ctx,1);n.useMystery(ctx,u);u.jiraiyaCooldownReduction=100;
 const hit=()=>({targets:[{cmd:1,targetCamp:1,targetPos:1,reportTargetStatus:codec.ST.HIT>>>0,result:{hurtHp:1}}],reactions:[]});
 start(ctx,2);n.useStandard(ctx,u,[u]);assert.strictEqual(n.resolve(ctx,u,v,hit(),{combo:15},hit).length,1);u.hp=0;j.noteDeaths(ctx);
 ctx.mysteryCounts[0]+=3;assert.strictEqual(j.revivals(ctx).length,1);
 assert.strictEqual(u.mysteryReadyRound,4);assert.strictEqual(n.useStandard(ctx,u,[u]),null);
 start(ctx,3);assert.strictEqual(n.useStandard(ctx,u,[u]),null);assert(!n.canMystery(ctx,u));
 assert.strictEqual(n.resolve(ctx,u,v,hit(),{combo:15},hit).length,0,'Revival must not clear Chase recovery');
 start(ctx,4);assert(n.useMystery(ctx,u));assert.strictEqual(u.mysteryReadyRound,7);
}
// Real scheduling + native packet: mirrored ninja squads remain bounded and opponents act.
{
 const team=camp=>[unit(n.config.heroId,6,camp),unit(j.config.heroId,7,camp),unit(12101003,8,camp)];
 const report=battle.kadroRapor(0,null,{ad:'Ninja cooldown regression',birimler:team(1)},{playerUnits:team(0),playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
 const decoded=codec.decodeBattleReport(report.payload);assert.strictEqual(decoded._consumed,decoded._total);
 assert(decoded.turns.length>=8,'Fixture must survive enough rounds to exercise recovery');
 const primary=new Set([13120901,13120902,13120903,13120911,13120913]);
 const cooldowns=new Map([[13120901,3],[13120911,3],[13120902,2],[13120903,2],[13120913,2],[13120904,2],[13120914,2]]);
 const last=new Map(),enemyTurns=new Set();
 for(const turn of decoded.turns){
  const actions=new Map();
  for(const act of turn.actives){
   const actor=act.activeCamp+':'+act.activePos;
   if(primary.has(act.skillEffectId)){actions.set(actor,(actions.get(actor)||0)+1);assert(actions.get(actor)<=1,'Mystery + standard in one round');}
   if(cooldowns.has(act.skillEffectId)){
    const family=[13120902,13120903].includes(act.skillEffectId)?'naruto-standard':act.skillEffectId;
    const key=actor+':'+family;
    if(last.has(key))assert(turn.curTurn-last.get(key)>=cooldowns.get(act.skillEffectId),'Cooldown bypass in native report');
    last.set(key,turn.curTurn);
   }
   if(act.activeCamp===1&&act.activePos===8&&act.targets.some(r=>r.cmd===1))enemyTurns.add(turn.curTurn);
  }
 }
 assert.strictEqual(enemyTurns.size,decoded.turns.length,'Ordinary opponent must retain an action in every round');
}
console.log('PASS ninja anti-spam: 3-round Mysteries, primary-action budget, 2-round standards/shared summon and Chase recovery, protected control window, revival persistence, both camps and native scheduling.');
