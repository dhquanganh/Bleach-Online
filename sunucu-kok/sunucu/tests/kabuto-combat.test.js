'use strict';
const assert=require('assert'),k=require('../kabuto-combat'),n=require('../naruto-combat'),skills=require('../hero-skills'),j=require('../jiraiya-combat'),rebirth=require('../reincarnation'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,normal:13100114,skill:0,skillId:13100114,level:100,quality:7,anger:100,partnerSkills:[],weaponSkills:[]});
const kabuto=(pos=11,camp=0)=>unit(k.config.heroId,pos,camp);
let a=kabuto(),enemy=unit(100,1,1),ctx=n.create([[a],[enemy]],{random:()=>.5});
k.prepare(ctx.teams,ctx);n.startRound(ctx,1);let frames=[];let requests=k.roundStart(ctx,frames);
const mu=ctx.teams[0].find(k.isMu);
assert(frames.find(f=>f.skillEffectId===k.config.summon.id).targets.some(r=>r.cmd===codec.CMD.NONE&&r.targetCamp===mu.camp&&r.targetPos===mu.pos),'Mu summon must identify its real spawn slot');
assert.strictEqual(mu.maxHp,a.maxHp);assert.strictEqual(mu.hp,a.maxHp);assert.strictEqual(requests[0].kind,'pakura');
assert(k.activeBarrier(ctx));assert(!k.canStandard(ctx,enemy));assert(k.canStandard(ctx,a));assert(k.canStandard(ctx,mu));
enemy.edoTensei=true;assert(k.canStandard(ctx,enemy));delete enemy.edoTensei;
assert(skills.status(a,'immuneDebuffs'));assert(skills.status(a,'immuneControl'));
skills.apply({id:1,effects:[{kind:'buff',field:'stun',value:1,scope:'t',turns:2},{kind:'dot',field:'poison',value:.1,scope:'t',turns:2}]},enemy,[enemy],[a],[a],[],()=>0);
assert(!skills.status(a,'stun'));assert(!k.hasPoison(a));
// Two shared fatal escapes per barrier round; native HP never reaches zero during an escape.
for(let i=0;i<2;i++){a.hp=10;const result=rebirth.hit(enemy,a,100000,()=>.5);assert.strictEqual(result.damage,9);assert.strictEqual(result.recovered,4999);assert.strictEqual(a.hp,5000);}
a.hp=10;assert.strictEqual(rebirth.hit(enemy,a,100000,()=>.5).damage,10);assert.strictEqual(a.hp,0);
k.noteDeaths(ctx);assert.strictEqual(a.kabutoReviveRound,2);assert(mu.hp>0,'Mu stays when Kabuto dies');
mu.skillBuffs=[{field:'freeze',remaining:5,value:1},{field:'reflect',remaining:5,value:1}];mu.kabutoCurseUntil=5;mu.shield=999;
n.startRound(ctx,2);frames=[];requests=k.roundStart(ctx,frames);
assert.strictEqual(a.hp,2500);assert.strictEqual(a.mysteryReadyRound,2);assert.strictEqual(requests[0].kind,'dan');assert.strictEqual(mu.hp,a.maxHp);
assert(frames.some(f=>f.skillEffectId===k.config.revival.id));
assert(!skills.status(mu,'freeze')&&!skills.status(mu,'reflect')&&!k.cursed(mu));assert.strictEqual(mu.shield,0);
// Self healing precedes cost; Mystery consumes primary and healing has a cooldown.
a.hp=4000;ctx.chakra[0]=40;ctx.chakraLimit=[20,20];a.kabutoHealUses=0;
const myst=n.useMystery(ctx,a,()=>frames.push(...k.beforeAction(ctx,a)));
assert(myst);assert.strictEqual(a.hp,5200);assert.strictEqual(ctx.chakra[0],40);assert.strictEqual(ctx.chakraLimit[0],100);
assert.strictEqual(n.useStandard(ctx,a,ctx.teams[0]),null);assert.strictEqual(k.beforeAction(ctx,a).length,0);assert.strictEqual(a.hp,5200);
n.startRound(ctx,3);assert.strictEqual(k.beforeAction(ctx,a).length,0);assert(!n.canMystery(ctx,a));
n.startRound(ctx,4);k.roundStart(ctx,[]);assert(n.useStandard(ctx,a,ctx.teams[0]));assert.strictEqual(k.beforeAction(ctx,a).length,2);
n.startRound(ctx,2); // Remaining status-boundary cases use round 2.
// Suppression overrides immunity but does not remove invulnerability; end-of-round boundary is exact.
let v=unit(200,6,1);v.battleRound=2;v.immuneDebuffs=true;v.skillBuffs=[{field:'invincible',remaining:5}];
k.afterHit(ctx,a,v,[v],k.config.chases[0],{targets:[]});assert(!skills.status(v,'immuneDebuffs'));assert(skills.status(v,'invincible'));assert(k.blind(v));
v.battleRound=3;assert(skills.status(v,'immuneDebuffs'));assert(!k.blind(v));
v=unit(200,6,1);v.edoTensei=true;v.battleRound=2;v.superArmor=true;
k.afterHit(ctx,a,v,[v],{...k.config.standard,target:'line'},{targets:[]});assert.strictEqual(v.kabutoDefenseStacks,1);assert.strictEqual(skills.value(v,'def'),88);assert(!k.armor(v));assert(k.cursed(v));
assert(!k.canChase(v));assert(!k.canMystery(ctx,v));
v.naruto={standard:{target:'all'}};assert.strictEqual(k.selectStandard(ctx,v,v.naruto.standard),null);
v.battleRound=3;assert(k.cursed(v));assert(k.armor(v));v.battleRound=4;assert(!k.cursed(v));
// Legacy Bleach actors must not re-select a blocked Mystery inside vurus.
let legacy=unit(11110001,1,1);legacy.battleRound=2;legacy.kabutoCurseUntil=3;legacy.skill=13100001;
let legacyHit=battle.vurus(legacy,a,false,[a],()=>.5,false,[legacy]);assert.strictEqual(legacyHit.skillEffectId,legacy.normal);
delete legacy.kabutoCurseUntil;legacy.kabutoInterruptedRound=2;
legacyHit=battle.vurus(legacy,a,false,[a],()=>.5,false,[legacy]);assert.strictEqual(legacyHit.skillEffectId,legacy.normal);
// Low OR High Float can start White Extreme Attack, once each round, never on Knockdown.
a=kabuto();v=unit(200,1,1);ctx=n.create([[a],[v]],{random:()=>.5});n.startRound(ctx,1);
const hit=()=>({targets:[{cmd:1,targetCamp:1,targetPos:1,reportTargetStatus:codec.ST.HIT>>>0,result:{hurtHp:1}}],reactions:[]});
const strike=()=>hit();assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:1,causes:'lowFloat'},strike).length,1);
assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:1,causes:'highFloat'},strike).length,0);
n.startRound(ctx,2);assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:1,causes:'highFloat'},strike).length,0);
n.startRound(ctx,3);assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:1,causes:'highFloat'},strike).length,1);
n.startRound(ctx,4);assert.strictEqual(n.resolve(ctx,a,v,hit(),{combo:1,causes:'knockdown'},strike).length,0);
const single=k.selectStandard(ctx,a,k.config.standard);assert.strictEqual(single.target,1);assert.strictEqual(single.causes,null);
const line=k.selectStandard({...ctx,random:()=>.1},a,k.config.standard);assert.strictEqual(line.target,'line');assert.strictEqual(line.combo,6);assert.strictEqual(line.causes,'lowFloat');
// 9/12 limits, selected-line attacks, poison precondition and 80% armor bonus use real damage.
const opponents=Array.from({length:15},(_,i)=>unit(400+i,i+1,1));
v=opponents[0];v.skillBuffs=[{field:'poison',remaining:2}];
let move=k.prepareMove(ctx,a,v,k.config.mystery);assert(move.unavoidable&&move.strongPoison);
let f=battle.vurus(a,v,false,opponents,()=>.5,false,[a],n.attackSpec(move));
assert.strictEqual(f.targets.filter(r=>r.cmd===1).length,9);
k.afterHit(ctx,a,v,opponents.slice(0,9),move,f);assert(opponents.slice(0,9).every(u=>(u.skillBuffs||[]).some(b=>b.field==='strongPoison')));
f=battle.vurus(a,opponents[6],false,opponents,()=>.5,false,[a],n.attackSpec(k.config.chases[0]));
assert.deepStrictEqual(f.targets.filter(r=>r.cmd===1).map(r=>r.targetPos),[7,6,8,9,10]);
f=battle.vurus(a,v,false,opponents,()=>.5,false,[a],n.attackSpec(k.config.deidara.standard));assert.strictEqual(f.targets.filter(r=>r.cmd===1).length,12);
const armored=unit(999,1,1),plain=unit(998,1,1);armored.superArmor=true;
const damage=t=>battle.vurus(a,t,false,[t],()=>.5,false,[a],n.attackSpec(k.config.pakura.standard)).targets.find(r=>r.cmd===1).result.hurtHp;
assert(Math.abs(damage(armored)/damage(plain)-1.8)<.03);
// Dan drains all opposing chakra; a Deidara kill forbids both Kabuto and Jiraiya revival.
ctx.chakra=[10,80];v=unit(201,1,1);v.battleRound=3;k.afterHit(ctx,a,v,[v],k.config.dan.standard,{targets:[]});
assert.deepStrictEqual(ctx.chakra,[90,0]);assert.strictEqual(v.kabutoSuppressedUntil,ctx.round+2);
const fallen=kabuto(11,1);fallen.hp=0;fallen.kabutoReviveRound=4;
k.afterHit(ctx,a,fallen,[fallen],k.config.deidara.standard,{targets:[]});assert(fallen.noRevive);assert.strictEqual(fallen.kabutoReviveRound,undefined);
const fallenJ=unit(j.config.heroId,6,1);fallenJ.hp=0;fallenJ.noRevive=true;fallenJ.jiraiyaDeathCount=0;ctx.teams[1].push(fallenJ);ctx.mysteryCounts=[10,10];assert.strictEqual(j.revivals(ctx).length,0);
// Summon limits and alternating round triggers.
a=kabuto();ctx=n.create([[a],[enemy]],{random:()=>.5});k.prepare(ctx.teams,ctx);n.startRound(ctx,1);frames=[];requests=k.roundStart(ctx,frames);
const m=ctx.teams[0].find(k.isMu);assert.strictEqual(k.afterAction(ctx,m,k.config.mu.standard).length,1);assert.strictEqual(k.afterAction(ctx,m,k.config.mu.standard).length,0);
n.startRound(ctx,2);assert.strictEqual(k.roundStart(ctx,[])[0].kind,'dan');n.startRound(ctx,3);assert.strictEqual(k.roundStart(ctx,[])[0].kind,'pakura');assert(!k.activeBarrier(ctx));
// Recruitment and actual report scheduler: supports must be melee and guests never become roster heroes.
const K=battle.heroBirim(k.config.heroId,11,100,null,{hp:100000,atk:100,def:100,speed:100,hitRate:1},1);
assert(K);assert.strictEqual(K.profession,3);assert.strictEqual(K.quality,7);
const team=Array.from({length:6},(_,i)=>unit(12101003,i+1,1));for(const u of team){u.hp=u.maxHp=1000000;u.atk=30;u.speed=1;}
const report=battle.kadroRapor(0,null,{ad:'Kabuto regression',birimler:team},{playerUnits:[K],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.2});
const decoded=codec.decodeBattleReport(report.payload);assert.strictEqual(decoded._consumed,decoded._total);
const moves=decoded.turns.flatMap(t=>t.actives).map(f=>f.skillEffectId);
for(const frame of decoded.turns.flatMap(t=>t.actives).filter(f=>[13120936,13120938].includes(f.skillEffectId))){
 assert(frame.targets.some(r=>r.cmd===codec.CMD.NONE&&r.targetCamp===frame.activeCamp&&r.targetPos!==frame.activePos),'Summon animation must carry the actual spawned role position');
}
for(const [sid,cooldown] of [[13120931,3],[13120932,2],[13120933,2],[13120934,2],[13120939,3],[13120940,3],[13120941,3]]){
 const rounds=decoded.turns.filter(t=>t.actives.some(f=>f.skillEffectId===sid)).map(t=>t.curTurn);
 for(let i=1;i<rounds.length;i++)assert(rounds[i]-rounds[i-1]>=cooldown,'Cooldown violated for '+sid);
}
for(const turn of decoded.turns){
 assert(turn.actives.filter(f=>f.skillEffectId===13120934).length<=1,'Healing spam');
 assert(!(turn.actives.some(f=>f.skillEffectId===13120931)&&turn.actives.some(f=>f.skillEffectId===13120932)),'Mystery must consume primary');
}
for(const id of [13120931,13120932,13120933,13120934,13120936,13120937,13120938,13120939,13120940,13120941,13120942])assert(moves.includes(id),'Missing Kabuto move '+id);
const available=require('../herolar').gecerliHerolar();assert(available.some(h=>h.id===k.config.heroId));assert(!available.some(h=>[11120911,11120912,11120913,11120914].includes(h.id)));
// Rule-accurate engine deaths/revival, including the fatal-protection pool being exhausted.
function lethalReport(seal){
 const owner=battle.heroBirim(k.config.heroId,11,100,null,{hp:1000,atk:1,magicAtk:1,def:0,speed:100,hitRate:1},1);
 const killers=[1,6].map(pos=>{const u=unit(12101003,pos,1);u.hp=u.maxHp=10000000;u.atk=u.magicAtk=100000;u.speed=1;u.edoTensei=true;
  u.naruto={standard:seal?{...k.config.deidara.standard,multiplier:100}:{id:13100114,target:'all',multiplier:100,combo:1}};return u;});
 return codec.decodeBattleReport(battle.kadroRapor(0,null,{ad:'Kabuto lethal regression',birimler:killers},{playerUnits:[owner],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5}).payload);
}
const revived=lethalReport(false);assert(revived.turns.flatMap(t=>t.actives).some(f=>f.skillEffectId===k.config.revival.id));
assert(revived.turns.flatMap(t=>t.actives).flatMap(f=>f.targets).some(r=>r.targetCamp===0&&r.targetPos===11&&r.result.hurtHp===-250));
const sealed=lethalReport(true);assert(!sealed.turns.flatMap(t=>t.actives).some(f=>f.skillEffectId===k.config.revival.id));
assert.strictEqual(revived.turns.flatMap(t=>t.actives).filter(f=>f.skillEffectId===k.config.revival.id).length,1,'Repeated lethal rounds must not create immortality');
// Revival cooldown starts on revival. Death during it is final, even with Mu alive.
{
 const owner=kabuto(),c=n.create([[owner],[unit(901,1,1)]]);
 k.prepare(c.teams,c);n.startRound(c,1);k.roundStart(c,[]);
 owner.hp=0;k.noteDeaths(c);assert(k.pendingRevival(c,0));
 n.startRound(c,2);k.roundStart(c,[]);assert(owner.hp>0);assert.strictEqual(owner.kabutoRevivalReadyRound,6);
 owner.hp=0;k.noteDeaths(c);assert(!k.pendingRevival(c,0));assert.strictEqual(owner.kabutoReviveRound,undefined);
 for(let round=3;round<=8;round++){n.startRound(c,round);k.noteDeaths(c);const out=[];k.roundStart(c,out);assert.strictEqual(owner.hp,0);assert(!out.some(f=>f.skillEffectId===k.config.revival.id));}
 // A surviving Kabuto can revive again if the next death happens at the ready boundary.
 const fresh=kabuto(),d=n.create([[fresh],[unit(902,1,1)]]);
 n.startRound(d,1);fresh.hp=0;k.noteDeaths(d);n.startRound(d,2);k.roundStart(d,[]);
 n.startRound(d,6);fresh.hp=0;k.noteDeaths(d);assert.strictEqual(fresh.kabutoReviveRound,7);
 n.startRound(d,7);k.roundStart(d,[]);assert.strictEqual(fresh.hp,2500);assert.strictEqual(fresh.kabutoRevivalReadyRound,11);
}
// Revival and resummoning cannot reset cooldowns or guest budgets.
{
 const owner=kabuto(),victim=unit(900,1,1),c=n.create([[owner],[victim]],{random:()=>.5});
 k.prepare(c.teams,c);n.startRound(c,1);k.roundStart(c,[]);
 const summon=c.teams[0].find(k.isMu);
 assert(k.useGuest(c,summon,'deidara'));assert(!k.useGuest(c,summon,'deidara'));assert(k.useGuest(c,summon,'dan'));
 c.skillReady.set(summon,new Map([['standard',7]]));k.resetSummon(c,summon,[]);
 assert.strictEqual(c.skillReady.get(summon).get('standard'),7);
 n.startRound(c,2);c.chakra[0]=100;assert(n.useMystery(c,owner));assert.strictEqual(owner.mysteryReadyRound,5);
 owner.hp=0;k.noteDeaths(c);n.startRound(c,3);k.roundStart(c,[]);
 assert.strictEqual(owner.mysteryReadyRound,5);assert(!n.canMystery(c,owner));assert(!k.useGuest(c,summon,'deidara'));
 assert(!c.barrier,'Revival cannot immediately refresh Mu barrier');
 n.startRound(c,4);assert(k.useGuest(c,summon,'deidara'));
 n.startRound(c,5);c.chakra[0]=100;assert(n.useMystery(c,owner));
}
console.log('PASS Kabuto: damage/status/target rules, revival, native reports; cooldowns 3/2/2/2, primary action, per-guest cooldowns and no reset through revival/resummoning.');
