'use strict';
const assert=require('node:assert/strict'),a=require('../asuma-wind-combat'),n=require('../naruto-combat'),s=require('../hero-skills'),battle=require('../savas'),p=require('../paket'),codec=require('../kodek');
const unit=(id,pos,camp)=>({id,pos,camp,hp:100000,maxHp:100000,atk:5000,magicAtk:9000,def:5000,resistance:8000,speed:180,level:159,hitRate:1,critRate:0,anger:0,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
for(const camp of [0,1]){
 const asuma=unit(a.config.heroId,6,camp),ally=unit(11100001,1,camp),injured={...unit(11100005,11,camp),hp:99999},helper={...unit(12101003,12,camp),auxiliary:true,isSummon:true};
 const enemies=[1,2,3,4,6,11].map(pos=>unit(12101003,pos,1-camp));const ctx=n.create(camp?[enemies,[asuma,ally,injured,helper]]:[[asuma,ally,injured,helper],enemies],{random:()=>.2});n.startRound(ctx,1);
 assert.equal(a.roundStart(ctx).length,1);assert.equal(ctx.chakra[camp],40);assert.equal(a.roundStart(ctx).length,0);assert.equal(ctx.chakra[camp],40);assert(!n.canMystery(ctx,asuma));
 assert.equal(s.value(ally,'atk'),6500);assert.equal(s.value(injured,'atk'),5000);assert.equal(s.value(helper,'atk'),5000);assert.equal(s.value(asuma,'atk'),6500);assert.equal(s.value(ally,'magicAtk'),9000);
 ally.hp--;assert.equal(s.value(ally,'atk'),5000);ally.hp=ally.maxHp;assert.equal(s.value(ally,'atk'),6500);
 asuma.hp=0;assert.equal(s.value(ally,'atk'),5000);asuma.hp=asuma.maxHp;assert.equal(s.value(ally,'atk'),6500);
 const duplicate=unit(a.config.heroId,14,camp);ctx.teams[camp].push(duplicate);assert.equal(s.value(ally,'atk'),6500,'aura does not stack from multiple Asumas');ctx.teams[camp].pop();
 assert.deepEqual(a.targets(ctx,asuma,a.config.standard,enemies[4],enemies).map(v=>v.pos),[1,2,3]);
 const selected=enemies[4],targets=a.targets(ctx,asuma,a.config.mystery,selected,enemies);assert.equal(targets.length,3);assert.equal(targets[0],selected);
 enemies.slice(0,4).forEach(v=>v.hp=0);assert.deepEqual(a.targets(ctx,asuma,a.config.standard,selected,enemies).map(v=>v.pos),[6]);enemies.forEach(v=>v.hp=v.maxHp);
 const frame={targets:[]};a.afterHit(ctx,asuma,selected,[selected],a.config.chase,frame);assert(s.status(selected,'disarm'));assert.equal(n.useStandard(ctx,selected,[selected]),null);s.endRound([selected]);s.endRound([selected]);assert(!s.status(selected,'disarm'));
 selected.immuneDebuffs=true;a.afterHit(ctx,asuma,selected,[selected],a.config.chase,{targets:[]});assert(!s.status(selected,'disarm'));delete selected.immuneDebuffs;
 n.startRound(ctx,2);assert.equal(a.roundStart(ctx).length,0);assert.equal(ctx.chakra[camp],40);assert(n.canMystery(ctx,asuma));assert(n.useMystery(ctx,asuma));assert.equal(ctx.chakra[camp],0);assert(!n.canMystery(ctx,asuma));
 n.startRound(ctx,4);assert(!n.canMystery(ctx,asuma));n.startRound(ctx,5);assert(n.canMystery(ctx,asuma));
 const opener={targets:[{cmd:1,targetCamp:selected.camp,targetPos:selected.pos,reportTargetStatus:codec.ST.HIT,result:{hurtHp:1}}]};let chains=0;
 const result=n.resolve(ctx,ally,selected,opener,{combo:1,causes:'repulse'},(actor,target,move)=>{chains++;assert.equal(actor,asuma);assert.equal(move.id,a.config.chase.id);return {targets:[{cmd:1,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:codec.ST.HIT,result:{hurtHp:1}}]};});assert.equal(chains,1);assert(result.length>=1);assert.equal(ctx.trace.filter(t=>t.kind==='chase'&&t.actor===asuma.id).length,1);
 n.resolve(ctx,ally,selected,opener,{combo:1,causes:'repulse'},()=>{throw Error('chase repeated in one round');});
}
for(const move of [a.config.mystery,a.config.standard,a.config.chase])for(const camp of [0,1]){
 assert.equal(move.attackStat,'atk');assert.equal(move.damageType,'physical');
 function damage(atk,def,magicAtk,resistance,buffs=[]){const u={...unit(a.config.heroId,1,camp),atk,magicAtk,skillBuffs:buffs},v={...unit(12101003,1,1-camp),def,resistance};const r=battle.vurus(u,v,false,[v],()=>.5,false,[u],n.attackSpec(move));return r.targets.filter(t=>t.cmd===1&&t.targetCamp!==camp).reduce((sum,t)=>sum+(t.result.hurtHp||0),0);}
 const base=damage(5000,5000,1,1);assert(base>0);assert(damage(10000,5000,1,1)>base);assert(damage(5000,10000,1,1)<base);assert.equal(damage(5000,5000,999999,999999),base);assert(damage(5000,5000,1,1,[{field:'atk',value:.5,remaining:2}])>base);assert(damage(5000,5000,1,1,[{field:'atk',value:-.5,remaining:2}])<base);
}
const entry=require('../naruto-recruit-items.json').find(r=>r.heroId===a.config.heroId);assert(entry);assert.equal(entry.fragmentId,14131011);assert.equal(entry.itemId,14141011);assert.equal(p.satir('HeroChangeAttr',a.config.heroId).chipValue,entry.fragmentId);assert.equal(p.satir('BaseHero',a.config.heroId).assess,'S+');assert(envUsable(entry.itemId));function envUsable(id){return require('../envanter').article(id).usable;}
for(let pos=1;pos<=15;pos++){const u=battle.heroBirim(a.config.heroId,pos,1,null,null,0,true);assert(u&&u.pos===pos&&u.maxHp>=5000&&u.maxHp<=6000);}
for(const camp of [0,1]){
 const u=unit(a.config.heroId,6,camp),ally=unit(11100001,1,camp),enemies=[1,2,3,6,11].map(pos=>({...unit(12101003,pos,1-camp),hp:10000000,maxHp:10000000,atk:50,def:10000,speed:1}));
 const r=battle.kadroRapor(0,{name:'Asuma finite battle',level:159,units:camp?[u,ally]:enemies},null,{playerUnits:camp?enemies:[u,ally],playerState:{},scaleEnemy:false,battleDataVersion:4,random:()=>.2,strictSkillTargets:true});const report=codec.decodeBattleReport(r.payload);assert.equal(report._consumed,report._total);assert(report.turns.length<100);
 const acts=report.turns.flatMap(t=>t.actives).filter(v=>v.activeCamp===camp&&v.activePos===6);assert.equal(acts.filter(v=>v.skillEffectId===a.config.courage.id).length,1);const mysteries=acts.filter(v=>v.skillEffectId===a.config.mystery.id);assert(mysteries.length>0);for(const m of mysteries)assert.equal(m.targets.filter(t=>t.cmd===1&&t.targetCamp!==camp).length,3);assert(report.turns[0].actives.every(v=>v.skillEffectId!==a.config.mystery.id));
}
assert.equal(a.profile(unit(11100001,1,0)),null);console.log('PASS Asuma: both camps, first-round Chakra once, 3-target Mystery/CD, front-row attack, Repulse chase/Blindness, dynamic full-HP nonstacking aura, physical-only damage, 15 positions, items and finite real reports.');
