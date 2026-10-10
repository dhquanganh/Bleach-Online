'use strict';
const assert=require('assert'),fs=require('fs'),os=require('os'),path=require('path'),mail=require('../boss-reward-mail'),env=require('../envanter'),{Y,O}=require('../paket');
const tmp=fs.mkdtempSync(path.join(os.tmpdir(),'boss-mail-'));
try{
 const file=path.join(tmp,'currency.json');fs.writeFileSync(file,JSON.stringify({altin:100}));
 const d={infiniteIllusion:{payouts:[{id:'test-day',day:20000,rank:2,gold:7000,stones:700,itemsDelivered:false,goldDelivered:false}]}};
 let durable,failAt=0,saves=0;
 const ctx={durum:d,kaydet:next=>{if(++saves===failAt)throw Error('disk');durable=JSON.parse(JSON.stringify(next));}};
 failAt=1;assert.throws(()=>mail.enqueue(ctx,1000,file),/disk/);assert(!d.posta);assert(!d.infiniteIllusion.payouts[0].mailSent);
 failAt=0;const letters=mail.enqueue(ctx,1000,file);assert.equal(letters.length,1);assert.equal(mail.enqueue(ctx,1001,file),false);
 assert.equal(env.mevcut(d,14900001),0);assert.equal(JSON.parse(fs.readFileSync(file)).altin,100);
 const m=d.posta.gelen[0],ids=[[m.hi,m.lo]],wire=new O(mail.notification(m));
 assert.equal(wire.u32(),0);assert.equal(wire.u32(),0);assert.equal(wire.u32(),m.lo);assert.equal(wire.utf(),'Ảo Cảnh Vô Hạn');assert(wire.utf().includes('Hạng 2'));assert(wire.utf().includes('Nhấn nhận'));wire.u32();wire.u8();wire.u32();assert.equal(wire.u16(),2);assert.equal(wire.u32(),3);assert.equal(wire.u32(),7000);assert.equal(wire.u32(),14900001);assert.equal(wire.u32(),700);assert.equal(wire.kalan(),0);
 const snapshot=JSON.stringify(d);failAt=saves+1;assert.throws(()=>mail.claim(ctx,ids,file),/disk/);assert.equal(JSON.stringify(d),snapshot);assert.equal(JSON.parse(fs.readFileSync(file)).altin,100);
 // Failure after currency write: reload the saved first phase, then retry.
 failAt=saves+2;assert.throws(()=>mail.claim(ctx,ids,file),/disk/);assert.equal(JSON.parse(fs.readFileSync(file)).altin,7100);
 Object.keys(d).forEach(k=>delete d[k]);Object.assign(d,durable);failAt=0;
 assert(!mail.claim(ctx,ids,file).error);assert.equal(JSON.parse(fs.readFileSync(file)).altin,7100);assert.equal(env.mevcut(d,14900001),700);assert.equal(d.posta.gelen[0].ek.length,0);
 mail.claim(ctx,ids,file);assert.equal(JSON.parse(fs.readFileSync(file)).altin,7100);assert.equal(env.mevcut(d,14900001),700);
 // Already-paid legacy gold is omitted from a migrated mail.
 d.infiniteIllusion.payouts.push({id:'old-paid',day:19999,rank:1,gold:8000,stones:800,itemsDelivered:false,goldDelivered:false});
 const v=JSON.parse(fs.readFileSync(file));v.illusionCredits['old-paid']=true;fs.writeFileSync(file,JSON.stringify(v));
 const migrated=mail.enqueue(ctx,1002,file)[0];assert.deepEqual(migrated.ek,[[14900001,800]]);
 let pushes=[];const handlers=require('../sosyal').kur({ekSonra:(id,payload)=>pushes.push({id,payload}),odulVer:()=>{},bossRewardMail:{claim:(c,keys)=>mail.claim(c,keys,file)}});
 const claimRequest=new Y().u16(1).u32(migrated.hi).u32(migrated.lo).done(),deleteRequest=new Y().u8(1).u16(1).u32(migrated.hi).u32(migrated.lo).done();
 assert.equal(handlers['0x01811602']({...ctx,payload:deleteRequest}).readUInt32BE(0),1);
 assert.equal(handlers['0x01811603']({...ctx,payload:Buffer.from([0,1])}).readUInt32BE(0),4);
 assert.equal(handlers['0x01811603']({...ctx,payload:claimRequest}).readUInt32BE(0),0);
 assert.equal(JSON.parse(fs.readFileSync(file)).altin,7100);assert.equal(env.mevcut(d,14900001),1500);assert(pushes.some(p=>p.id===0x01180f00));assert(pushes.some(p=>p.id===0x01180105));
 assert.equal(handlers['0x01811602']({...ctx,payload:deleteRequest}).readUInt32BE(0),0);assert.equal(mail.enqueue(ctx,1003,file),false);
 console.log('PASS boss reward mail: daily enqueue only, native notification/claim packets, no duplicate sending or collection, rollback/restart recovery, legacy migration and attachment protection. No player files changed.');
}finally{fs.rmSync(tmp,{recursive:true,force:true});}
