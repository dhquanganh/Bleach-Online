'use strict';
const assert=require('node:assert/strict'),gear=require('../ekipman'),env=require('../envanter'),{Y}=require('../paket');
const packets=[];let saves=0;
const fn=gear.kur({ekOnce:(id,payload)=>packets.push({id,payload}),ekSonra:(id,payload)=>packets.push({id,payload})})['0x01811100'];
function state(){const d={};for(const id of [14500004,14500005,14500006]){const n=env.mevcut(d,id);if(n)env.dus(d,id,n);}return d;}
const req=(tpl,n,mode=0)=>new Y().i8(mode).u32(env.instanceOf(tpl)).u32(tpl).u16(n).i8(0).done();
function craft(d,tpl,n,mode=0){packets.length=0;return fn({durum:d,payload:req(tpl,n,mode),kaydet(){saves++;}}).readUInt8(0);}
const d=state();env.ekle(d,[{code:14500004,amount:8}]);assert.equal(craft(d,14500004,3),0);assert.equal(env.mevcut(d,14500004),2);assert.equal(env.mevcut(d,14500005),3);assert(packets.some(x=>x.id===0x01180f00),'Full inventory refresh inserts the new output stack before result');
const capped=state();env.ekle(capped,[{code:14500004,amount:8},{code:14500005,amount:65535}]);const before=JSON.stringify(capped),oldSaves=saves;
assert.notEqual(craft(capped,14500004,2),0);assert.equal(JSON.stringify(capped),before);assert.equal(saves,oldSaves);assert.equal(packets.length,0);
for(const [tpl,n,mode] of [[14500004,0,0],[14100698,1,0],[14500004,1,2],[14500004,13,1]]){const snapshot=JSON.stringify(d);assert.notEqual(craft(d,tpl,n,mode),0);assert.equal(JSON.stringify(d),snapshot);}
const auto=state();env.ekle(auto,[{code:14500004,amount:8}]);assert.equal(craft(auto,0,6,1),0);assert.equal(env.mevcut(auto,14500006),2);assert.equal(env.mevcut(auto,14500004),0);
console.log('PASS Soul Stone synthesis: BaseStone upgrade chain, bulk/auto craft, result inventory refresh, no ingredient loss on full output, invalid mode/count/items. No save writes.');
