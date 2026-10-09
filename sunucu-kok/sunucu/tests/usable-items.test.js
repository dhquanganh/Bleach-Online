'use strict';
const fs=require('fs'),path=require('path'),assert=require('assert'),vm=require('vm'),{createRequire}=require('module');
const root=path.resolve(__dirname,'..'),local=createRequire(path.join(root,'canta.js')),env=local('./envanter'),gear=local('./ekipman'),levels=local('./seviye'),items=local('./usable-items'),packet=local('./paket');
const source=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8')),accountSource=JSON.parse(fs.readFileSync(path.join(root,'veri.json'),'utf8'));
let account={...accountSource};
const moduleObj={exports:{}};
vm.runInNewContext(fs.readFileSync(path.join(root,'canta.js'),'utf8'),{module:moduleObj,exports:moduleObj.exports,Buffer,console,require:name=>name==='./seviye'?{...levels,veriOku:()=>({...account}),veriYaz:v=>account={...v}}:local(name)});
const use=moduleObj.exports.kullan,hero=11150057;
function fixture(tpl,n=1){const d=JSON.parse(JSON.stringify(source));const old=env.mevcut(d,tpl);if(old)env.dus(d,tpl,old);env.ekle(d,[{code:tpl,amount:n}]);return d;}
const request=(tpl,n=1,target=0)=>new packet.Y().i16(1).u32(env.instanceOf(tpl)).u32(tpl).i16(n).u32(target).done();
function context(){return {random:()=>.1,para:(awards,d)=>{for(const a of awards){const field={'0:0':'gumus','0:1':'altin','0:2':'kupon','3:0':'askeriEmir','5:0':'prestij','6:0':'generalsSoul','7:3':'blueSoul','7:4':'purpleSoul','7:5':'goldSoulV','7:6':'orangeSoul'}[a.type+':'+a.code];if(field)account[field]=(Number(account[field])||0)+a.amount;if(a.type===2)levels.expEkle(d,a.amount,account);}return Buffer.alloc(2);},harca:costs=>{const gold=costs.reduce((s,x)=>s+x.amount,0);if(account.altin<gold)return null;account.altin-=gold;return Buffer.alloc(2);}};}
assert.strictEqual(env.article(14100002).functionValue,4000);assert.strictEqual(env.article(14100701).functionValue,1000000);
let d=fixture(14100002,2);const before=levels.heroDurum(d,hero);const predicted=levels.ilerlet(before.lv,before.exp+8000);let result=use(d,request(14100002,2,hero),context());assert.strictEqual(result.hata,0);assert.strictEqual(levels.heroDurum(d,hero).exp,predicted.exp);assert.strictEqual(env.mevcut(d,14100002),0);
d=fixture(14100701);assert.notStrictEqual(use(d,request(14100701,1,levels.anaId()),context()).hata,0);assert.strictEqual(env.mevcut(d,14100701),1);
d=fixture(14100007,3);const silver=account.gumus;assert.strictEqual(use(d,request(14100007,3),context()).hata,0);assert.strictEqual(account.gumus,silver+6000);
for(const tpl of [14100327,14100328,14800001,14800020,14100581,14100065,14100200]){
 d=fixture(tpl,2);account={...accountSource};const owned=Object.keys(gear.depo(d).esyalar).length;
 result=use(d,request(tpl,2),context());assert.strictEqual(result.hata,0,'cannot open '+tpl);assert.strictEqual(env.mevcut(d,tpl),0);assert(result.once.some(p=>p.id===env.OP_NTF));
 if([14100327,14100328].includes(tpl))assert.strictEqual(Object.keys(gear.depo(d).esyalar).length,owned+2);
 if(tpl===14100581)assert.strictEqual(Object.keys(gear.depo(d).esyalar).length,owned+12);
 const reload=JSON.parse(JSON.stringify(d));assert(env.loadBagPaketi(reload).equals(env.loadBagPaketi(d)));
}
d=fixture(14100327);const malformed=request(14100327);malformed.writeUInt32BE(123,2);assert.notStrictEqual(use(d,malformed,context()).hata,0);assert.strictEqual(env.mevcut(d,14100327),1);
for(const bad of [Buffer.alloc(1),request(14100327,0),request(14100327,-1),request(14100327,2)])assert.notStrictEqual(use(d,bad,context()).hata,0);
// Storage overflow and missing currency handlers do not burn the item.
d=fixture(14100007);account.gumus=2000000000;assert.notStrictEqual(use(d,request(14100007),context()).hata,0);assert.strictEqual(env.mevcut(d,14100007),1);account={...accountSource};assert.notStrictEqual(use(d,request(14100007),{}).hata,0);
// Every package resolves to valid inventory rewards rather than returning an empty result.
let packs=0;
for(const row of items.audit())if(['choice','fixed','set'].includes(row.kind)){
 const rewards=items.roll(row,1,3,()=>.1);assert(rewards.length,'empty recipe '+row.id);for(const x of rewards){assert(Number.isSafeInteger(x.amount)&&x.amount>0);if(x.type===1)assert(env.article(x.code),'invalid reward '+x.code);}packs++;
}
const fruit=14190004;d=fixture(fruit,2);const stat=gear.statPaketi(d,hero,levels.heroSeviye(d,hero));result=use(d,request(fruit,2,hero),context());assert.strictEqual(result.hata,0);const after=gear.statPaketi(d,hero,levels.heroSeviye(d,hero));assert(after.readUInt32BE(6+3*4)>stat.readUInt32BE(6+3*4));assert(after.readUInt32BE(6+5*4)>stat.readUInt32BE(6+5*4));
// Top-up cards increase charge/VIP progress without granting Gold.
d=fixture(14100755);const gold=account.altin,vip=account.vipExp;assert.strictEqual(use(d,request(14100755),context()).hata,0);assert.strictEqual(account.altin,gold);assert.strictEqual(account.vipExp,vip+200);
d=fixture(14100751);assert.strictEqual(use(d,request(14100751),context()).hata,0);assert.strictEqual(d.heroAddSlotNum,(Number(source.heroAddSlotNum)||0)+1);
d=fixture(14100016,3);d.backpack={capacity:160,count:0};assert.strictEqual(use(d,request(14100016,3),context()).hata,0);assert.strictEqual(d.backpack.capacity,170);assert.strictEqual(d.backpack.count,1);assert.strictEqual(env.mevcut(d,14100016),0);
console.log(`PASS: normalized EXP/Silver, chest/set loot, ${packs} valid package recipes, independent bulk grants, inventory notifications/persistence, malformed inputs, no loss on failure, fruits, top-up and expansion. Player files unchanged.`);
