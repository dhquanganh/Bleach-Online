'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path');
test('Spirit Stones from shop purchases and box openings persist with correct inventory notifications',()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-spirit-stone-'));process.env.BLEACH_ACCOUNT_DIR=dir;
 fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify({altin:1000000,level:159,vipLevel:15,herolar:[]}));
 const h=require('../handlers'),inv=require('../envanter'),{Y,tablo}=require('../paket');
 let d={karakter:{anaId:11100004},backpack:{capacity:1000,count:0}},saved;
 const kaydet=v=>{saved=JSON.parse(JSON.stringify(v));fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(v));};
 try{
  const offer=tablo('Mall').liste.find(x=>x.itemID===14500001&&x.model===2);assert.ok(offer);
  const before=inv.mevcut(d,14500001),gold=JSON.parse(fs.readFileSync(path.join(dir,'veri.json'))).altin;
  const ret=h.byReq['0x01811a00']({payload:new Y().u32(offer._id).u16(2).done(),durum:d,kaydet});assert.equal(ret.readUInt32BE(),0);
  assert.equal(inv.mevcut(saved,14500001),before+2);assert.ok(JSON.parse(fs.readFileSync(path.join(dir,'veri.json'))).altin<gold);
  assert.ok(h.ekAl().sonra.some(x=>x.id===0x01180f02));
  for(const tpl of [14800001,14800020,14800021,14800022]){
   const plan=require('../usable-items').resolve(tpl);if(!plan||plan.source!=='stone-table')continue;
   const previousBoxes=inv.mevcut(d,tpl);inv.ekle(d,[{type:1,code:tpl,amount:2}]);
   const existing=new Map(inv.liste(d).filter(x=>inv.article(x.code)?.majorType===3).map(x=>[x.code,x.amount]));
   const r=require('../canta').kullan(d,new Y().i16(1).u32(inv.instanceOf(tpl)).u32(tpl).i16(2).u32(0).done(),{random:()=>0});
   assert.equal(r.hata,0,'open '+tpl);assert.equal(inv.mevcut(d,tpl),previousBoxes);
   const reward=plan.choices[0];assert.equal(inv.mevcut(d,reward.code),(existing.get(reward.code)||0)+2);
   assert.ok(r.once.some(x=>x.id===0x01180f02));kaydet(d);
   const reload=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json')));assert.equal(inv.mevcut(reload,reward.code),inv.mevcut(d,reward.code));
  }
 }finally{delete process.env.BLEACH_ACCOUNT_DIR;for(const entry of fs.readdirSync(dir)){const file=path.join(dir,entry);if(fs.statSync(file).isFile())fs.unlinkSync(file);}if(!fs.readdirSync(dir).length)fs.rmdirSync(dir);}
});
