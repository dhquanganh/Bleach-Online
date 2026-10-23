'use strict';
const assert=require('node:assert/strict'),env=require('../envanter'),limits=require('../admin-item-limits');
const rows=require('../../cikarim/veri-json/Article.json');
const books=[14100001,14100002,14100003,14100004,14100005,14100701];
for(const id of books){
 assert.equal(limits.maxAdd(env.article(id)),99999);
 assert.equal(limits.maxAdd(rows.find(a=>parseInt(a.id,16)===id)),99999);
 const d={};const baseline=env.mevcut(d,id);if(baseline)env.dus(d,id,baseline);
 env.ekle(d,[{code:id,amount:99999}]);assert.equal(env.mevcut(d,id),99999);
 const reloaded=JSON.parse(JSON.stringify(d));assert.equal(env.mevcut(reloaded,id),99999);
 assert.equal(env.liste(reloaded).find(x=>x.code===id).amount,32767);
 assert(env.dus(reloaded,id,10000));assert.equal(env.mevcut(reloaded,id),89999);
 assert.equal(env.guncellemePaketi(reloaded,id).payload.readUInt16BE(12),32767);
 assert(env.dus(reloaded,id,30000));assert.equal(env.mevcut(reloaded,id),59999);
 assert.equal(env.liste(reloaded).find(x=>x.code===id).amount,32767);
 assert.equal(env.guncellemePaketi(reloaded,id).payload.readUInt16BE(12),32767);
}
for(const id of [14100161,14100266,14130950])assert.equal(limits.maxAdd(env.article(id)),999);
assert.equal(limits.maxAdd(null),999);
console.log('PASS admin item limits: only six EXP books allow 99999; full stored quantity survives reload and replenishes native stacks on use; materials remain at 999.');
