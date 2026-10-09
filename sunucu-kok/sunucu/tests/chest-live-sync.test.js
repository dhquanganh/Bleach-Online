'use strict';
const assert=require('assert'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'..'),handlers=require(path.join(root,'handlers')),env=require(path.join(root,'envanter')),gear=require(path.join(root,'ekipman')),p=require(path.join(root,'paket'));
for(const chest of [14100327,14100328,14800001]){
 const d=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
 const amount=env.mevcut(d,chest);if(amount)env.dus(d,chest,amount);env.ekle(d,[{code:chest,amount:1}]);
 const before=env.loadBagPaketi(d),req=new p.Y().i16(1).u32(env.instanceOf(chest)).u32(chest).i16(1).u32(0).done();
 let saved=false;handlers.ekAl();assert.strictEqual(handlers.byReq['0x01810f01']({payload:req,durum:d,kaydet:()=>saved=true}),false);assert(saved);
 const packets=handlers.ekAl().sonra,receipt=packets.findIndex(x=>x.id===0x01180f08),sync=packets.findIndex(x=>x.kaynak==='KULLAN-bag-sync');
 assert(receipt>=0&&sync>receipt,'full bag must arrive after the chest receipt');
 assert.strictEqual(packets[sync].id,0x01180f00);assert(packets[sync].payload.equals(env.loadBagPaketi(d)));assert(!packets[sync].payload.equals(before));
 const records=gear.kayitlariOku(packets[sync].payload,5);assert.strictEqual(records.son,packets[sync].payload.length);assert.strictEqual(env.mevcut(d,chest),0);
}
console.log('PASS: real chest handlers save state, then send receipt followed by a complete parseable bag update. No player files changed.');
