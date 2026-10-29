'use strict';
const assert=require('node:assert/strict');
const battle=require('../savas'),naruto=require('../naruto-combat'),pain=require('../pain-combat'),obito=require('../obito-combat'),hash=require('../hashirama-combat');
const {CMD}=require('../kodek');
const unit=(id,camp)=>({id,camp,pos:1,hp:1000000,maxHp:1000000,atk:100,magicAtk:10,def:0,resistance:0,speed:100,hitRate:1,critRate:0,anger:0,level:99,quality:7,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
const madara=require('../madara-final-combat');
const minato=require('../minato-new-year-combat');
const sets=[
  {hero:minato.config.heroId,moves:['mystery','standard','standard2','standard3','enhancedMystery','counter','cloneCounter'].map(k=>minato.config[k])},
  {hero:madara.config.heroId,moves:Object.values(madara.config).filter(m=>m&&typeof m==='object'&&m.multiplier>0)},
  {hero:naruto.config.heroId,moves:[naruto.config.mystery,naruto.config.barrage,...naruto.config.chases]},
  {hero:pain.config.heroId,moves:[...['mystery','extremeMystery','finalMystery','standard','laser','superPush'].map(k=>pain.config[k]),...pain.config.chases]},
  {hero:obito.config.heroId,moves:[obito.config.rageMystery,obito.config.standard,obito.config.rageStandard,...obito.config.chases,...obito.config.rageChases]},
  {hero:hash.config.heroId,moves:[...['mystery','burstMystery','standard','sword','severe','burstSevere','additional'].map(k=>hash.config[k]),...hash.config.chases]},
];
sets.push({hero:11121005,moves:Object.values(require('../madara-infinite.json')).filter(m=>m&&typeof m==='object'&&m.multiplier>0)});
sets.push({hero:11121006,moves:Object.values(require('../naruto-final.json')).filter(m=>m&&typeof m==='object'&&m.multiplier>0)});
sets.push({hero:11121007,moves:Object.values(require('../guy-gate.json')).filter(m=>m&&typeof m==='object'&&m.multiplier>0)});
sets.push({hero:11121008,moves:Object.values(require('../asura-guardian.json')).filter(m=>m&&typeof m==='object'&&m.multiplier>0)});
sets.push({hero:11121009,moves:Object.values(require('../orochimaru-new-year.json')).filter(m=>m&&typeof m==='object'&&m.multiplier>0)});
function damage(hero,move,camp,overrides={},targetOverrides={}){
  const actor={...unit(hero,camp),...overrides},target={...unit(200,1-camp),...targetOverrides};
  const teams=camp?[[target],[actor]]:[[actor],[target]],ctx=naruto.create(teams,{random:()=>.5});naruto.startRound(ctx,1);
  // Initialize actual passive state after create() resets per-battle resources.
  Object.assign(actor,overrides);
  const frame=battle.vurus(actor,target,false,[target],()=>.5,false,[actor],naruto.attackSpec(move,!!(move.painChase||move.obitoSpear||move.obitoChaos)));
  return frame.targets.filter(r=>r.cmd===CMD.ATTACK&&r.targetCamp===target.camp).reduce((sum,r)=>sum+Math.max(0,r.result.hurtHp||0),0);
}
let checked=0;
for(const {hero,moves} of sets)for(const move of moves)for(const camp of [0,1]){
  assert.equal(move.attackStat,'atk',move.name);
  assert.equal(move.damageType,'physical',move.name);
  const base=damage(hero,move,camp);
  assert(base>0,move.name+' must deal damage');
  assert.equal(damage(hero,move,camp,{}, {resistance:1000000}),base,move.name+' must ignore Resistance');
  if(move.ignoreDefense===1)assert.equal(damage(hero,move,camp,{}, {def:1000}),base,move.name+' retains explicit full armor penetration');else assert(damage(hero,move,camp,{}, {def:1000})<base,move.name+' must be mitigated by Physical DEF');
  assert.equal(damage(hero,move,camp,{}, {def:1000,resistance:1000000}),damage(hero,move,camp,{}, {def:1000}),move.name+' must never mix DEF and Resistance');
  assert.equal(damage(hero,move,camp,{magicAtk:100000}),base,move.name+' must ignore Magic ATK');
  assert(damage(hero,move,camp,{atk:200})>base,move.name+' must grow with Physical ATK');
  assert(damage(hero,move,camp,{skillBuffs:[{field:'atk',value:.5,remaining:2}]})>base,move.name+' must use buffed Physical ATK');
  assert(damage(hero,move,camp,{skillBuffs:[{field:'atk',value:-.5,remaining:2}]})<base,move.name+' must use reduced Physical ATK');
  // Zero defense and deterministic RNG expose the coefficient without mitigation/rounding noise.
  assert.equal(base,Math.round(100*move.multiplier),move.name+' coefficient must stay unchanged');
  checked++;
}
for(const move of sets[2].moves)for(const camp of [0,1]){
  const base=damage(pain.config.heroId,move,camp);
  const boosted=damage(pain.config.heroId,move,camp,{painTechnique:5});
  assert.equal(boosted,Math.round(160*move.multiplier),move.name+' must use Technique-buffed Physical ATK');
  assert.equal(damage(pain.config.heroId,move,camp,{painTechnique:5,magicAtk:100000}),boosted);
  assert(damage(pain.config.heroId,move,camp,{painDamageStacks:2})>base,move.name+' must use passive Attack growth');
}
for(const move of [pain.config.finalMystery,pain.config.superPush])for(const camp of [0,1]){
  const final={painFinal:true,painTechnique:5};
  assert.equal(damage(pain.config.heroId,move,camp,final),Math.round(200*move.multiplier));
  assert.equal(damage(pain.config.heroId,move,camp,{...final,magicAtk:100000}),Math.round(200*move.multiplier));
}
console.log(`PASS Physical ATK scaling: ${checked} damaging moves/camps across Minato, Madara, Naruto Sage, Obito, Pain, Hashirama; Physical DEF mitigation, Resistance/Magic ATK independence, ATK buffs/debuffs and original coefficients.`);
