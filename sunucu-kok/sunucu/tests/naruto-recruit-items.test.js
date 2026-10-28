'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const root=path.resolve(__dirname,'..'),dir=fs.mkdtempSync(path.join(os.tmpdir(),'naruto-tokens-'));
process.env.BLEACH_ACCOUNT_DIR=dir;
const base=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
const originalAccount=JSON.parse(fs.readFileSync(path.join(root,'veri-varsayilan.json'),'utf8'));
function account(extra={}){fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify({...originalAccount,level:99,herolar:[],tumKarakterler:false,...extra}));}
account();fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(base));
const env=require('../envanter'),items=require('../usable-items'),use=require('../canta').kullan,recruit=require('../meyhane').itemRecruitPaketi,{Y}=require('../paket');
const catalog=require('../naruto-recruit-items.json'),articles=JSON.parse(fs.readFileSync(path.join(root,'../cikarim/veri-json/Article.json'),'utf8'));
const request=(item,n=1,instance=env.instanceOf(item))=>new Y().i16(1).u32(instance).u32(item).i16(n).u32(0).done();
const context={nhanNhanVat:(id,d)=>recruit(id,d,99)};
function fixture(item,n=2){account();const d=structuredClone(base);d.meyhane={alinan:{}};const old=env.mevcut(d,item);if(old)env.dus(d,item,old);if(n>0)env.ekle(d,[{type:1,code:item,amount:n}]);return d;}
after(()=>fs.rmSync(dir,{recursive:true,force:true}));
test('all active Naruto heroes have usable recruit tokens with their existing Modify Fragment icons',()=>{
 assert.equal(catalog.length,18);assert.equal(new Set(catalog.map(r=>r.itemId)).size,18);
 for(const row of catalog){
  const a=articles.find(a=>parseInt(a.id,16)===row.itemId),fragment=articles.find(a=>parseInt(a.id,16)===row.fragmentId);
  assert.ok(env.article(row.itemId).usable);assert.equal(a.picture,fragment.picture);assert.equal(a.functionValue,9);assert.equal(a.f16,row.heroId);
  assert.equal(items.resolve(row.itemId).hero,row.heroId);assert.ok(require('../retired-heroes').allowed(row.heroId));
 }
});
test('using one token recruits the matching hero, sends native recruit/update packets and persists; duplicate use keeps token',()=>{
 for(const row of catalog){
  const d=fixture(row.itemId),result=use(d,request(row.itemId),context);assert.equal(result.hata,0,row.name);
  assert.equal(env.mevcut(d,row.itemId),1);assert.equal(d.meyhane.alinan[row.heroId],1);
  const notify=result.once.find(p=>p.id===0x01180c02);assert.ok(notify);assert.equal(notify.payload.readUInt32BE(4),row.heroId);
  assert.ok(result.once.some(p=>[env.OP_NTF,env.OP_REDUCE].includes(p.id)));
  fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(d));const reload=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json'),'utf8'));
  const before=JSON.stringify(reload);assert.notEqual(use(reload,request(row.itemId),context).hata,0);assert.equal(JSON.stringify(reload),before);
 }
});
test('bulk use, forged instance, missing token, account-owned and all-unlocked heroes never consume a token',()=>{
 const row=catalog[0];
 for(const setup of [()=>({payload:request(row.itemId,2)}),()=>({payload:request(row.itemId,1,123)}),()=>{account({herolar:[row.heroId]});return {};},()=>{account({tumKarakterler:true});return {};}]){
  const d=fixture(row.itemId),options=setup(),before=JSON.stringify(d);assert.notEqual(use(d,options.payload||request(row.itemId),context).hata,0);assert.equal(JSON.stringify(d),before);
 }
 const d=fixture(row.itemId,0),before=JSON.stringify(d);assert.notEqual(use(d,request(row.itemId),context).hata,0);assert.equal(JSON.stringify(d),before);
});
