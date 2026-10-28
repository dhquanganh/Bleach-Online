'use strict';
const assert=require('node:assert/strict'),notices=require('../buff-notices'),n=require('../naruto-combat'),skills=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,camp=0,pos=1)=>({...battle.heroBirim(id,pos,159,null,null,0,true),camp,hp:1000000,maxHp:1000000,atk:1000,magicAtk:200,def:500,resistance:300,critRate:0});
const markers=frames=>frames.flatMap(f=>f.targets).map(t=>t.result.buffId);
for(const camp of [0,1]){
 const u=unit(11121001,camp),v=unit(11100001,1-camp),ctx=n.create(camp?[[v],[u]]:[[u],[v]],{random:()=>.5});n.startRound(ctx,1);notices.initialize(ctx);
 assert.deepEqual(notices.collect(ctx),[]);
 const before=skills.value(u,'atk');u.madaraBurstUntil=1;u.madaraAttackStacks=1;
 const output=notices.collect(ctx);assert(markers(output).includes(notices.ids.atk));assert(markers(output).includes(notices.ids.madaraBurst));assert(output.every(f=>f.activeCamp===camp&&f.activePos===u.pos));assert.equal(skills.value(u,'atk'),before*1.1);
 assert.deepEqual(notices.collect(ctx),[],'unchanged buffs cannot flood labels');
 u.madaraAttackStacks++;assert(markers(notices.collect(ctx)).includes(notices.ids.atk),'stack growth is announced');
 u.atk-=500;assert(!markers(notices.collect(ctx)).includes(notices.ids.atk),'stat losses are not announced as buffs');
 u.shield=1000;assert(markers(notices.collect(ctx)).includes(notices.ids.shield));u.shield=500;assert.deepEqual(notices.collect(ctx),[]);
 u.skillBuffs=[{field:'damageReduction',value:.2,remaining:2,source:u.id,sourceSkill:1}];assert(markers(notices.collect(ctx)).includes(notices.ids.damageReduction));
 u.skillBuffs[0].remaining=1;assert.deepEqual(notices.collect(ctx),[]);u.skillBuffs[0].remaining=2;assert(markers(notices.collect(ctx)).includes(notices.ids.damageReduction),'same-strength refresh announced');
 u.hp=0;u.madaraAttackStacks++;assert.deepEqual(notices.collect(ctx),[],'dead recipients cannot emit buff notices');
}
for(const [id,mutate,expected] of [
 [11121003,u=>u.minatoAttackStacks++,['atk']],
 [11121005,u=>u.infiniteStacks++,['atk']],
 [11121006,u=>{u.nfAttackStacks++;u.nfResonanceUntil=1;u.nfResonances=['Shukaku'];},['atk','shukaku']],
 [11120940,u=>u.hashTechnique++,['def']],
 [11120997,u=>u.kakuzuAttackStacks++,['atk']],
 [11100001,u=>{u.skillBuffs=[{field:'speed',value:.2,remaining:2}];},['speed']],
 ]){
 const u=unit(id),v=unit(11100001,1),ctx=n.create([[u],[v]]);n.startRound(ctx,1);notices.initialize(ctx);mutate(u);
 const keys=markers(notices.collect(ctx));for(const field of expected)assert(keys.includes(notices.ids[field]),id+': '+field);
}
// Verify the markers survive real report encoding, without altering the winner
// or the finite Naruto action/chase scheduler in either camp.
for(const camp of [0,1]){
 const own=[unit(11121006,camp)],enemy=[unit(11100001,1-camp)];
 const result=battle.kadroRapor(0,null,{ad:'Generic buff floats report',birimler:camp?own:enemy},{playerUnits:camp?enemy:own,playerState:{},scaleEnemy:false,forceWin:false,random:()=>.8});
 const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
 const labels=report.turns.flatMap(t=>t.actives).flatMap(f=>f.targets).filter(t=>t.cmd===codec.CMD.FLOAT&&t.result.buffId>notices.config.baseId&&t.result.buffId<=notices.config.baseId+notices.fields.length);
 assert(labels.some(t=>t.targetCamp===camp&&t.targetPos===1&&t.result.buffId===notices.ids.atk));assert(labels.some(t=>t.result.buffId===notices.ids.shukaku));
 assert(report.turns.length<=25);
}
assert.equal(new Set(Object.values(notices.ids)).size,notices.fields.length);assert.equal(notices.config.durationMs,4000);
console.log('PASS buff notices: both camps, ordinary buffs/refreshes, private stat stacks, transformations/resonances/shields, no losses/dead spam, no stat mutation and real binary reports.');
