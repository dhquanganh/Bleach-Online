'use strict';
const assert=require('node:assert/strict'),event=require('../infinite-illusion');
const d={infiniteIllusion:{day:0,entries:{'bot:42':{id:'bot:42',bot:true,damage:500}},nextBot:123,payouts:[]}};
const s=event.state(d,1791700000);
assert.deepEqual(s.entries,{});assert.equal(s.schema,2);assert(!('nextBot' in s));assert.deepEqual(s.payouts,[]);
const rows={entries:{}};event.record(rows,{id:'bot:42',bot:true,damage:500,at:1});assert.deepEqual(event.ranks(rows),[]);
assert.deepEqual(event.info(d,1791700000).rows,[]);
console.log('PASS legacy bot ranking removed without fabricated replacement scores or rewards.');
