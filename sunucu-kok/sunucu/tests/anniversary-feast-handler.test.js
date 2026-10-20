'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
test('Native handlers persist the board, deduct gold, grant the configured hero and reject malformed requests',()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-feast-handler-'));const old=process.env.BLEACH_ACCOUNT_DIR;process.env.BLEACH_ACCOUNT_DIR=dir;process.env.BLEACH_FEAST_CONFIG=path.join(dir,'feast.json');
 fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify({altin:100000,herolar:[],level:20}));
 const h=require('../handlers'),{Y,O}=require('../paket');const wire=h.etkinlik.acikListe().find(id=>h.etkinlik.katalog().get(id)?.kategori===970000);assert.ok(wire);
 let d={karakter:{anaId:11100004}},saved;const kaydet=state=>{saved=JSON.parse(JSON.stringify(state));fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(state));};
 try{
  const packet=h.byReq['0x01812302']({payload:new Y().u32(wire).done(),durum:d,kaydet}),o=new O(packet);assert.equal(o.u32(),wire);assert.equal(o.u16(),1);assert.equal(o.u32(),1);assert.ok(o.u16()>20);assert.equal(o.i32(),62000001);assert.equal(saved.anniversaryFeast[wire].cards.length,16);
  const request=(idx,extra)=>{const w=new Y().u32(wire).u32(idx);if(extra){w.i16(extra.length);extra.forEach(x=>w.i32(x));}return h.byReq['0x01812303']({payload:w.done(),durum:d,kaydet});};
  assert.equal(request(18).readUInt32BE(),0);assert.equal(JSON.parse(fs.readFileSync(path.join(dir,'veri.json'))).altin,99990);assert.equal(saved.anniversaryFeast[wire].score,10);
  // Exercise every configured shell and shop reward through the actual inventory
  // handlers, not a mocked resolver: visible reward, saved balance, notification
  // and a subsequent bag reload must all agree.
  const feast=require('../anniversary-feast'),inv=require('../envanter');
  for(const item of [...feast.repository,...feast.shop]){
   const expected=h.etkinlik.odulCoz(item.awardId),before=expected.map(a=>inv.mevcut(d,inv.odulTemplate(a.type,a.code)));
   const s=d.anniversaryFeast[wire];
   h.ekAl();
   let response;
   if(item.index!==undefined){s.score=1000000;response=request(item.index);}
   else{s.cards=Array(16).fill(item.awardId);s.states=Array(16).fill(0);s.used=0;const first=request(0);assert.equal(first.readUInt32BE(),0);assert.equal(first.readInt16BE(12),0,'one shell is not a matching pair');for(const [i,a] of expected.entries())assert.equal(inv.mevcut(d,inv.odulTemplate(a.type,a.code)),before[i]);response=request(1);}
   assert.equal(response.readUInt32BE(),0,'reward '+item.awardId);
   assert.equal(response.readInt16BE(12),expected.length);
   const notifications=h.ekAl().sonra;
   assert.ok(notifications.some(p=>p.id===0x01180f02),'bag notification '+item.awardId);
   for(const [i,a] of expected.entries()){
    const code=inv.odulTemplate(a.type,a.code),balance=before[i]+a.amount;
    assert.equal(inv.mevcut(d,code),balance,'live reward '+item.awardId);
    assert.equal(inv.mevcut(saved,code),balance,'saved reward '+item.awardId);
    const reload=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json'),'utf8'));
    assert.equal(inv.mevcut(reload,code),balance,'reloaded reward '+item.awardId);
    const encoded=Buffer.alloc(4);encoded.writeUInt32BE(code);
    assert.ok(inv.loadBagPaketi(reload,0).includes(encoded),'bag reload '+item.awardId);
   }
  }
  d.anniversaryFeast[wire].score=40000;assert.equal(request(61,[1]).readUInt32BE(),0);assert.ok(JSON.parse(fs.readFileSync(path.join(dir,'veri.json'))).herolar.includes(11150045));assert.equal(saved.anniversaryFeast[wire].score,0);assert.equal(saved.seviye.herolar[11150045].lv,1);assert.notEqual(request(61,[1]).readUInt32BE(),0);
  const bad=new Y().u32(wire).u32(19).i16(2).i32(21406090).done();assert.notEqual(h.byReq['0x01812303']({payload:bad,durum:d,kaydet}).readUInt32BE(),0);assert.equal(h.sonClaim().ozel,true);
  const queue=h.ekAl().sonra;assert.ok(queue.some(p=>p.id===0x01180c02));assert.ok(queue.some(p=>p.id===0x01182305));
 }finally{if(old===undefined)delete process.env.BLEACH_ACCOUNT_DIR;else process.env.BLEACH_ACCOUNT_DIR=old;delete process.env.BLEACH_FEAST_CONFIG;for(const file of fs.readdirSync(dir)){const p=path.join(dir,file);if(fs.statSync(p).isFile())fs.unlinkSync(p);}if(!fs.readdirSync(dir).length)fs.rmdirSync(dir);}
});
