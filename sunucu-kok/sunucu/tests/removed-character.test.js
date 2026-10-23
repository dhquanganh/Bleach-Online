'use strict';
const test=require('node:test'),assert=require('node:assert/strict');
const policy=require('../retired-heroes'),tables=require('../paket'),battle=require('../savas');
const ids=[...Array.from({length:5},(_,i)=>11120910+i),...Array.from({length:5},(_,i)=>11120980+i)];
test('removed character and summons cannot load, recruit, or enter battle',()=>{
 for(const id of ids){assert(!policy.allowed(id));assert.equal(tables.satir('BaseHero',id),null);assert.equal(battle.heroBirim(id,1,100),null);}
 for(const id of [14130910,14130980])assert.equal(tables.satir('Article',id),null);
});
test('ownership and fragments are removed while other progression survives',()=>{
 const input={herolar:[11120920,...ids],kadro:{11120920:2,11120980:6},heroStars:{11120920:4,11120980:5},envanter:{esyalar:{14130980:{adet:100},14130920:{adet:50}}},altin:12345};
 const clean=policy.clean(input);
 assert.deepEqual(clean.herolar,[11120920]);assert.deepEqual(clean.kadro,{11120920:2});assert.deepEqual(clean.heroStars,{11120920:4});
 assert.deepEqual(clean.envanter.esyalar,{14130920:{adet:50}});assert.equal(clean.altin,12345);
 assert.deepEqual(policy.clean(clean),clean);assert.equal(input.herolar.length,11);
});
test('shared armor suppression continues to support other characters',()=>{
 const skills=require('../hero-skills'),u={id:200,battleRound:1,superArmor:true,armorSuppressedUntil:1};
 assert(!skills.armor(u));u.armorSuppressedUntil=0;assert(skills.armor(u));
});
