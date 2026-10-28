'use strict';
const assert=require('node:assert/strict'),m=require('../naruto-final-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),b=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({...b.heroBirim(id,pos,159,null,null,0,true),camp,hp:1000000,maxHp:1000000,atk:1000,magicAtk:200,def:500,resistance:500,critRate:0});
const frame=()=>({targets:[],reactions:[]});
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),ally=unit(11120901,6,camp),v=unit(11100001,1,1-camp),v2=unit(11100002,6,1-camp);
 const teams=camp?[[v,v2],[u,ally]]:[[u,ally],[v,v2]],ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);m.roundStart(ctx);
 ctx.chakra[camp]=20;u.suppressedUntil=10;assert(s.status(u,'immuneDebuffs'));assert(s.status(u,'immuneControl'));
 u.nfBlindUntil=1;u.skillBuffs=[{field:'disarm',value:1,remaining:2}];
 for(let stage=1;stage<=9;stage++){
  const move=n.useMystery(ctx,u);assert(move,'bond '+stage);assert.equal(move.id,m.config['bond'+stage].id);assert.equal(move.chakraCost,0);m.afterHit(ctx,u,v,[],move,frame());
  assert.equal(u.nfStage,stage);assert(!s.status(u,'disarm'));
  for(const q of m.triggers(ctx))if(q.move?.support)m.afterHit(ctx,q.unit,v,[],q.move,frame());
 }
 assert.equal(u.nfResonances.length,9);assert.equal(m.profile(u).mystery.id,m.config.finalMystery.id);assert.equal(ctx.chakra[camp],20);assert.equal(n.useMystery(ctx,u),null,'final costs 40');
 assert(Math.abs(s.value(u,'atk')-2080)<1e-8);assert.equal(s.value(u,'magicAtk'),u.magicAtk);
 ctx.chakra[camp]=40;const final=n.useMystery(ctx,u);assert.equal(final.id,m.config.finalMystery.id);assert(!n.useMystery(ctx,u));assert.equal(u.nfFinalReady,3);
 const one=m.prepareMove({...ctx,teams:camp?[[v],[u]]:[[u],[v]]},u,final,v);assert.equal(one.multiplier,final.multiplier*2);
 const female=unit(11120992,11,1-camp);assert.equal(m.prepareMove(ctx,u,final,female).id,m.config.harem.id);
 m.afterHit(ctx,u,v,[v],final,frame());assert.equal(s.value(v,'atk'),v.atk*.75);assert.equal(s.value(v,'magicAtk'),v.magicAtk);
 m.afterHit(ctx,u,v,[v],m.config.standard,frame());assert.equal(v.suppressedUntil,2);assert.equal(v.nfDiscourageUntil,2);assert.equal(v.nfBlindUntil,1);assert.equal(v.nfInkUntil,1);assert(!n.canChase(v));assert.equal(n.useStandard(ctx,v,teams[1-camp]),null);
 assert(v.madaraIgnitionUntil===2&&v.madaraInfernoUntil===2&&v.tsunadeMeltUntil===1&&v.madaraShatterUntil===1);
 assert(m.blocksBuff(v));m.observe(ctx,v,{prompt:true});assert(!m.blocksBuff(v));
 const special=m.prepareMove(ctx,u,m.config.chase,v);assert.equal(special.ignoreDefense,.2);m.afterHit(ctx,u,v,[v],special,frame());assert(m.blocksMystery(v));require('../tsunade-combat').cleanseAll(v,[]);assert(m.blocksMystery(v),'special Magnet Seal survives debuff cleanse');
 assert(!m.blocksAdditional(ally,{trigger:true}), 'unsealed ally allowed');ally.nfMagnetUntil=1;assert(m.blocksMystery(ally));assert(!m.blocksAdditional(ally,{additional:true}),'Jinchuriki may execute additional skills');
 v.nfMagnetUntil=1;assert(m.blocksAdditional(v,{additional:true}));v.hp=0;m.noteDeaths(ctx);assert(m.blocksDeath(v));v.hp=1;m.noteDeaths(ctx);delete v.nfMagnetSpecialUntil;delete v.nfMagnetUntil;assert(!m.blocksDeath(v));
 const h=frame();female.battleRound=1;female.suppressedUntil=1;m.afterHit(ctx,u,female,[],m.config.harem,h);assert.equal(m.outgoing(female,{prompt:true}),.4);assert.equal(female.nfHaremUntil,1);
 for(let i=0;i<10;i++)m.onAttacked(ctx,v,[u,ally],{damageType:'physical'});assert.equal(u.nfFriendshipStacks,6);assert.equal(ally.nfFriendshipStacks,6);assert(m.standardGuaranteed(ally));assert.equal(m.outgoing(u,m.config.standard),1.9);
 u.nfSlowReflexUntil=1;m.triggers(ctx);for(let i=0;i<20;i++)m.onDamage(ctx,v,u,{damage:10},{damageType:'physical'});assert.equal(m.triggers(ctx).filter(r=>r.granted).length,5);
 u.nfStandardUsed=true;m.afterHit(ctx,u,v,[{...v,hp:0}],m.config.standard,frame());assert.equal(u.nfExtras,1);assert(n.useStandard(ctx,u,teams[camp]));assert.equal(u.nfExtras,0);
 u.nfBlindUntil=1;m.endRound(ctx);assert.equal(u.nfStage,0);assert(!u.nfBlindUntil);assert.equal(u.nfResonances.length,0);n.startRound(ctx,2);m.roundStart(ctx);assert.equal(m.profile(u).mystery.id,m.config.bond1.id);assert(!m.standardGuaranteed(ally));
 // A fresh round permits exactly one Mystery-triggered and one Trigger-triggered additional attack.
 m.triggers(ctx);m.observe(ctx,u,{prompt:true});m.observe(ctx,u,{prompt:true});m.observe(ctx,u,{trigger:true});m.observe(ctx,u,m.config.additional);assert.equal(m.triggers(ctx).length,2);
}
for(const camp of [0,1]){
 const own=[unit(m.config.heroId,1,camp)],enemy=[unit(11100001,1,1-camp),unit(11100002,6,1-camp),unit(11100003,11,1-camp)];
 const result=b.kadroRapor(0,null,{ad:'Naruto Final full resonance report',birimler:camp?own:enemy},{playerUnits:camp?enemy:own,playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,random:()=>.8});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);const events=report.turns.flatMap(t=>t.actives).filter(e=>e.activeCamp===camp&&e.activePos===1);
 for(let i=1;i<=9;i++)assert(events.some(e=>e.skillEffectId===m.config['bond'+i].id),'missing resonance '+i);
 assert(events.some(e=>e.skillEffectId===m.config.restoration.id));const final=events.find(e=>e.skillEffectId===m.config.finalMystery.id);assert(final);assert.equal(new Set(final.targets.filter(t=>t.targetCamp!==camp&&t.result.hurtHp>0).map(t=>t.targetPos)).size,3);
 assert(events.some(e=>e.skillEffectId===m.config.chase.id));
 for(const t of report.turns){assert(t.actives.length<250);assert(t.actives.filter(e=>e.activeCamp===camp&&e.activePos===1&&e.skillEffectId>=13122301&&e.skillEffectId<=13122309).length<=9);assert(t.actives.filter(e=>e.activeCamp===camp&&e.skillEffectId===m.config.additional.id).length<=2);}
 assert(report.turns.length<=25);
}
for(let pos=1;pos<=15;pos++)assert.equal(b.heroBirim(m.config.heroId,pos,159,null,null,0,true).pos,pos);
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),ally=unit(11100001,6,camp),duplicate=unit(m.config.heroId,11,camp),enemy=unit(11100002,1,1-camp);
 const ctx=n.create(camp?[[enemy],[u,ally,duplicate]]:[[u,ally,duplicate],[enemy]],{random:()=>.5});n.startRound(ctx,1);m.roundStart(ctx);m.battleStart(ctx);m.battleStart(ctx);
 for(const v of [u,ally,duplicate]){assert.equal(s.value(v,'atk'),v.atk*1.5);assert.equal(s.value(v,'def'),v.def*1.5);assert.equal(s.value(v,'speed'),v.speed*1.1);assert.equal(s.value(v,'magicAtk'),v.magicAtk);assert.equal(s.value(v,'leechRate'),.5);assert.equal(v.skillBuffs.filter(x=>x.nfKuramaCloak).length,4);}
 assert.equal(s.value(enemy,'atk'),enemy.atk);assert.equal(s.value(enemy,'leechRate'),0);
 ally.hp=ally.maxHp*.5;const before=ally.hp;const hit=b.vurus(ally,enemy,false,[enemy],()=>.5,false,[u,ally,duplicate],n.attackSpec({id:m.config.standard.id,multiplier:1,attackStat:'atk',damageType:'physical',target:1}));
 const damage=hit.targets.filter(t=>t.cmd===codec.CMD.ATTACK&&t.targetCamp!==camp).reduce((sum,t)=>sum+Math.max(0,t.result.hurtHp||0),0);assert(damage>0);assert.equal(ally.hp-before,Math.round(damage*.5),'life steal uses actual HP damage');assert(hit.reactions.some(f=>f.targets.some(t=>t.targetCamp===camp&&t.targetPos===ally.pos&&t.result.hurtHp<0)));
 ally.skillBuffs.push({field:'noHeal',value:1,remaining:2});const blocked=ally.hp;b.vurus(ally,enemy,false,[enemy],()=>.5,false,[u,ally],n.attackSpec({id:m.config.standard.id,multiplier:1,attackStat:'atk',damageType:'physical',target:1}));assert.equal(ally.hp,blocked,'life steal respects healing prevention');
}
for(const camp of [0,1]){
 const u=unit(m.config.heroId,1,camp),v=unit(11100001,1,1-camp),ctx=n.create(camp?[[v],[u]]:[[u],[v]]);n.startRound(ctx,1);m.roundStart(ctx);u.nfRestoreRound=1;u.hp=u.maxHp*.5;
 const recovered=frame();m.afterHit(ctx,u,v,[],m.config.recovery,recovered);assert.equal(u.hp,u.maxHp*.6,'Recovery heals 10% max HP');assert.equal(recovered.reactions.flatMap(e=>e.targets).filter(t=>t.result.hurtHp===-u.maxHp*.1).length,1,'Recovery emits one heal');
 const events=m.endRound(ctx);assert.equal(u.hp,u.maxHp*.7,'Restoration separately heals 10% max HP');assert.equal(events.flatMap(e=>e.targets).filter(t=>t.targetCamp===camp&&t.result.hurtHp===-u.maxHp*.1).length,1,'Restoration emits one heal');
 u.hp=u.maxHp-1;m.endRound(ctx);assert.equal(u.hp,u.maxHp,'healing capped at max HP');u.hp=0;assert.deepEqual(m.endRound(ctx),[],'Restoration cannot revive a dead Naruto');
}
console.log('PASS Naruto Final: both camps, nine finite resonances, cooldown/chakra/reset, Physical ATK growth, all-enemy attacks, female replacement, all resonance effects, first Mystery/Trigger, Magnet Seal, friendship, capped extras and binary reports.');
