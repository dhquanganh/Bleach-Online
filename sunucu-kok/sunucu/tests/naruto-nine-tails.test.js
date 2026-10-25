'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
const k=require('../naruto-nine-tails-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:1000,magicAtk:777,def:500,resistance:777,speed:100,level:99,quality:5,profession:1,hitRate:1,critRate:0,anger:0,normal:13100114,skill:0,skillId:13100114,verdi:0,partnerSkills:[],weaponSkills:[]});
function fixture(camp=0,pos=1){const u=unit(k.config.heroId,pos,camp),enemies=[1,2,6,7,11].map(p=>unit(12101003,p,1-camp));const ctx=n.create(camp?[enemies,[u]]:[[u],enemies],{random:()=>.5});n.startRound(ctx,1);return {u,enemies,ctx};}
for(const camp of [0,1])for(let pos=1;pos<=15;pos++){
 const {u,enemies,ctx}=fixture(camp,pos);assert(n.profile(u));assert(s.status(u,'immuneDebuffs'));
 assert.equal(n.useMystery(ctx,u),null);n.startRound(ctx,2);const mystery=n.useMystery(ctx,u);assert.equal(mystery.id,13121701);assert.equal(ctx.chakra[camp],0);assert(n.useStandard(ctx,u,[u]));
 assert.equal(n.useMystery(ctx,u),null);n.startRound(ctx,3);assert.equal(n.useMystery(ctx,u),null);n.startRound(ctx,4);assert(n.useMystery(ctx,u));
 const frame=battle.vurus(u,enemies[0],false,enemies,()=>.5,false,[u],n.attackSpec(k.config.standard));assert.deepEqual(frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp!==camp).map(r=>r.targetPos),[1,2]);
}
for(const camp of [0,1]){
 const f=fixture(camp),{u,enemies,ctx}=f;ctx.random=()=>.59;assert.equal(k.selectStandard(ctx,u,k.config.standard).combo,3);ctx.random=()=>.6;assert.equal(k.selectStandard(ctx,u,k.config.standard).combo,1);
 u.hp=100;u.skillBuffs=[{field:'atk',value:.5,remaining:2}];k.roundStart(ctx);assert.equal(u.hp,400);u.hp=100;u.magicAtk=999999;u.def=999999;u.resistance=999999;k.roundStart(ctx);assert.equal(u.hp,400);
 const enemy=enemies[0];enemy.hp=100;s.restore(u,enemy,100,[]);assert.equal(enemy.hp,200);
 const records=[];k.ignite(ctx,u,enemy,records);assert(s.status(enemy,'noHeal'));s.restore(u,enemy,100,[]);assert.equal(enemy.hp,200);
 s.startRound([enemy]);assert.equal(enemy.hp,200,'Ignition must not tick at round start');
 const before=enemy.hp;k.endRound(ctx);assert(enemy.hp<before);const after=enemy.hp;s.endRound(ctx.teams.flat());k.endRound(ctx);assert.equal(enemy.hp,after,'one round only');assert(!s.status(enemy,'noHeal'));
 enemy.hp=10000;enemy.skillBuffs=[];k.onDamage(ctx,enemy,u,{damage:10},{damageType:'physical'},[]);assert(enemy.skillBuffs.some(b=>b.ntcIgnition));enemy.skillBuffs=[];
 k.onDamage(ctx,enemy,u,{damage:10},{damageType:'ninjutsu'},[]);assert(!enemy.skillBuffs.length);
 k.onDamage(ctx,enemy,u,{damage:10},{damageType:'physical',kind:'dot'},[]);assert(!enemy.skillBuffs.length);
 k.onDamage(ctx,enemy,u,{damage:0},{damageType:'physical'},[]);assert(!enemy.skillBuffs.length);
 enemy.immuneDebuffs=true;k.ignite(ctx,u,enemy,[]);assert(!enemy.skillBuffs.length);delete enemy.immuneDebuffs;
 enemy.hp=10000;const frame={targets:[],reactions:[]};k.afterHit(ctx,u,enemy,[enemy],k.config.mystery,frame);assert(frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK).every(r=>[6,7].includes(r.targetPos)));assert.equal(frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK).length,2);
 enemy.superArmor=true;const noSplash={targets:[],reactions:[]};k.afterHit(ctx,u,enemy,[enemy],k.config.mystery,noSplash);assert(!noSplash.targets.some(r=>r.cmd===codec.CMD.ATTACK));
}
function damage(atk=1000,def=500,magic=777,res=777,move=k.config.mystery){const f=fixture();f.u.atk=atk;f.u.magicAtk=magic;f.enemies[0].def=def;f.enemies[0].resistance=res;const frame=battle.vurus(f.u,f.enemies[0],false,f.enemies,()=>.5,false,[f.u],n.attackSpec(move));return frame.targets.find(r=>r.cmd===codec.CMD.ATTACK).result.hurtHp;}
for(const move of [k.config.mystery,k.config.standard,k.config.comboStandard]){const base=damage(1000,500,777,777,move);assert(damage(2000,500,777,777,move)>base);assert(damage(1000,2000,777,777,move)<base);assert.equal(damage(1000,500,999999,999999,move),base);}
{const f=fixture(),base=k.damage(f.u,f.enemies[0],.3);f.u.magicAtk=999999;f.enemies[0].resistance=999999;assert.equal(k.damage(f.u,f.enemies[0],.3),base);f.u.atk*=2;assert(k.damage(f.u,f.enemies[0],.3)>base);f.enemies[0].def*=100;assert(k.damage(f.u,f.enemies[0],.3)<base);}
for(const camp of [0,1]){
 const f=fixture(camp);f.enemies.forEach(e=>{e.hp=e.maxHp=1000000;e.atk=1;e.immuneDebuffs=true;});
 const result=battle.kadroRapor(0,null,{ad:'Nine-Tails scheduling',birimler:camp?[f.u]:f.enemies},{playerUnits:camp?f.enemies:[f.u],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
 const r=codec.decodeBattleReport(result.payload);assert.equal(r._consumed,r._total);const moves=r.turns.flatMap(turn=>turn.actives.map(a=>({...a,round:turn.curTurn})));
 assert(moves.some(a=>a.activeCamp===camp&&a.skillEffectId===13121706));assert(moves.some(a=>a.activeCamp===camp&&a.skillEffectId===13121704));assert(moves.some(a=>a.activeCamp===camp&&a.skillEffectId===13121701&&a.round>=2));
 assert(!moves.some(a=>a.activeCamp===camp&&[13121702,13121704].includes(a.skillEffectId)&&a.round===1&&a.activeType===codec.ACTIVE.SKILL));
}
const base=JSON.parse(fs.readFileSync(path.resolve(__dirname,'../../cikarim/veri-json/BaseHero.json'),'utf8')).find(r=>parseInt(r.id,16)===k.config.heroId);assert.equal(base.assess,'S+');assert.equal(base.quality,5);assert.deepEqual(base.tags,k.config.tags);
console.log('PASS Naruto Nine-Tails: both camps/all 15 positions, costs/cooldown, front row/3 combo, Repulse splash, physical-only scaling, ATK healing, immunity, retaliation, one-round end-round Ignition and encoded scheduling.');
