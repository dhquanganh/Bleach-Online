'use strict';
const assert=require('assert'),s=require('../sasuke-combat'),n=require('../naruto-combat'),battle=require('../savas'),skills=require('../hero-skills'),codec=require('../kodek');
const unit=(id,pos=1,camp=0)=>({id,pos,camp,hp:1000000,maxHp:1000000,atk:1000,magicAtk:99999,def:100,resistance:90000,speed:100,critRate:0,hitRate:1,level:100,normal:s.config.standard.id,skill:s.config.mystery.id,anger:0});
// Verify the server's two HP-dependent standards and the native binary client
// agree on movement. Contact must precede damage and retreat follow all hits.
assert.strictEqual(s.config.combatStyle,'melee');
const nativeHero=require('../paket').tablo('BaseHero').liste.find(row=>row._id===s.config.heroId);
const nativeMoves=JSON.parse(nativeHero.attackEffect);
for(const move of [s.config.standard,s.config.blazeStandard]){
 assert.strictEqual(n.attackSpec(move).delivery,'melee');
 const animation=nativeMoves[move.id],hits=Object.keys(animation.appendEffect).map(Number);
 assert.deepStrictEqual(animation.runPoint,{'0':{target:2}});
 assert(move.contactFrame<Math.min(...hits));
 assert(Math.max(...hits)<move.returnFrame);
 assert.deepStrictEqual(animation.backPoint,{[move.returnFrame]:1});
}
assert(!nativeMoves[s.config.mystery.id].runPoint);
let a=unit(s.config.heroId),v=unit(12101003,1,1),ally=unit(11100001,6),ctx=n.create([[a,ally],[v]]);n.startRound(ctx,1);s.roundStart(ctx);
assert(a.superArmor);assert(skills.status(a,'immuneDebuffs'));assert.strictEqual(s.profile(a).standard,s.config.blazeStandard);
a.hp=a.maxHp*.49;assert.strictEqual(s.profile(a).standard,s.config.standard);a.hp=a.maxHp;
assert.strictEqual(s.roundStart(ctx).find(x=>x.move.sasukeDragon).move,s.config.dragon);ctx.round=2;assert.strictEqual(s.roundStart(ctx).find(x=>x.move.sasukeDragon).move,s.config.blazeDragon);
ctx.round=1;ctx.chakra[0]=100;s.roundStart(ctx);assert(n.useMystery(ctx,a));assert.strictEqual(s.profile(a).mystery,s.config.blazeMystery);assert(!n.useMystery(ctx,a),'Mystery cooldown must apply');a.mysteryReadyRound=1;assert(n.useMystery(ctx,a));assert.strictEqual(s.profile(a).mystery,s.config.mystery);a.mysteryReadyRound=1;assert(!n.useMystery(ctx,a),'Two Mystery cap');
assert.strictEqual(s.beforeDamage(ctx,v,a,{prompt:true,element:'fire'},1000),600);assert.strictEqual(s.beforeDamage(ctx,v,a,{prompt:true,element:'fire'},1000),600);assert.strictEqual(s.beforeDamage(ctx,v,a,{prompt:true,element:'fire'},1000),1000);
assert.strictEqual(s.beforeDamage(ctx,v,a,{damageType:'physical',pureTaijutsu:true},1000),0);assert.strictEqual(s.beforeDamage(ctx,v,a,{damageType:'physical',pureTaijutsu:true},1000),0);assert.strictEqual(s.beforeDamage(ctx,v,a,{damageType:'physical',pureTaijutsu:true},1000),1000);
assert(s.triggers(ctx).length<=4);assert.strictEqual(skills.value(ally,'atk'),1180);assert.strictEqual(skills.value(ally,'critRate'),.07);
const f={reactions:[]};s.afterHit(ctx,a,v,[v],s.config.blazeStandard,f);assert(s.active(v,'sasukeBlazeUntil'));const atk=skills.value(v,'atk');s.onDamage(ctx,v,a,100,false);assert(skills.value(v,'atk')<atk);
v.sasukeFearUntil=1;s.beforeAction(ctx,v,s.config.standard);const hp=v.hp;assert(s.endRound(ctx).length);assert(v.hp<hp);
for(const move of Object.values(s.config).filter(x=>x&&typeof x==='object'&&x.id&&x.multiplier>0)){
 assert.strictEqual(move.attackStat,'atk');assert.strictEqual(move.damageType,'physical');assert.strictEqual(move.target,'all');if(!move.prompt)assert.strictEqual(move.cooldown,0);
 const run=(atk,def,magic,res)=>{const actor=unit(s.config.heroId),target=unit(12101003,1,1);actor.atk=atk;actor.magicAtk=magic;target.def=def;target.resistance=res;const f=battle.vurus(actor,target,false,[target],()=>.5,false,[actor],n.attackSpec(move));return f.targets.filter(r=>r.cmd===1&&r.targetCamp===1).reduce((x,r)=>x+r.result.hurtHp,0);};
 assert(run(2000,100,1,1)>run(1000,100,1,1));assert(run(1000,500,1,1)<run(1000,100,1,1));assert.strictEqual(run(1000,100,1,1),run(1000,100,99999,99999));
}
const player=battle.heroBirim(s.config.heroId,6,100,null,null,1);assert(player);const enemies=[unit(12101003,1,1),unit(12101004,6,1),unit(12101005,11,1)];enemies.forEach(u=>{u.atk=1;u.hp=u.maxHp=1000000000;});
const report=battle.kadroRapor(0,null,{ad:'Sasuke regression',birimler:enemies},{playerUnits:[player],playerState:{},scaleEnemy:false,forceWin:false,random:()=>.5});const decoded=codec.decodeBattleReport(report.payload);assert.strictEqual(decoded._consumed,decoded._total);
const damaging=decoded.turns.flatMap(t=>t.actives).filter(x=>x.activeCamp===0&&x.skillEffectId>=13121301&&x.skillEffectId<=13121308);assert(damaging.length);assert(damaging.some(x=>x.skillEffectId===s.config.dragon.id));assert(damaging.some(x=>x.skillEffectId===s.config.blazeDragon.id));assert(decoded.turns.slice(0,2).flatMap(t=>t.actives).filter(x=>x.activeCamp===0&&x.skillEffectId>=13121301&&x.skillEffectId<=13121308).every(x=>new Set(x.targets.filter(r=>r.cmd===1&&r.targetCamp===1).map(r=>r.targetPos)).size===3),'Every Sasuke skill must hit the whole lineup');
console.log('PASS Sasuke: Kirin toggle/cooldown/cap, HP standard, odd/even dragon, mitigation, Taijutsu immunity, 4-trigger cap, aura, Blaze/Fear, physical scaling, AOE and binary battle integration');
