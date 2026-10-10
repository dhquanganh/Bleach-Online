const assert=require('assert'),A=require('../academy'),env=require('../envanter'),{Y,tablo}=require('../paket');
const account={level:153,vipLevel:3,herolar:[]},date='2026-10-10';let d={},packets=[],saved;const y={ekOnce:(id,p)=>packets.push({id,p}),ekSonra:(id,p)=>packets.push({id,p})},ctx=n=>({durum:d,payload:new Y().u32(n).done(),kaydet:next=>saved=JSON.parse(JSON.stringify(next))}),run=n=>A.train(ctx(n),y,{account,date});
for(let i=0;i<3;i++)assert.equal(run(1).readUInt32BE(0),0);assert.equal(d.spiritSchool.free,3);assert.equal(run(1).readUInt32BE(0),18);assert(packets.some(p=>p.id===0x01180104));
d={};env.ekle(d,[{type:1,code:14100322,amount:20}]);let r=run(50);assert.equal(r.readUInt32BE(0),0);assert.equal(r.readInt32BE(16),500);assert.equal(env.mevcut(d,14100322),0);assert.equal(d.spiritSchool.free,3);assert.deepEqual(d,saved);assert(packets.some(p=>p.id===0x01180f00));
env.ekle(d,[{type:1,code:14100322,amount:10}]);const before=JSON.stringify(d),broken=ctx(1);broken.kaydet=()=>{throw Error('disk')};assert.notEqual(A.train(broken,y,{account,date}).readUInt32BE(0),0);assert.equal(JSON.stringify(d),before);
assert.equal(A.train(ctx(50),y,{account:{...account,vipLevel:0},date}).readUInt32BE(0),1);assert.equal(A.train(ctx(1),y,{account:{...account,level:20},date}).readUInt32BE(0),1);
assert.equal(A.info(ctx(1),{date:'2026-10-11'}).length,12);assert.equal(d.spiritSchool.free,0);
const last=tablo('SpiritSchoolExp').liste.find(r=>r.monsterId===18301000&&r.monsterLevel===499);assert(last);d.spiritSchool.expId=last._id;d.spiritSchool.exp=0;const bag=env.mevcut(d,14100322);assert.equal(run(1).readUInt32BE(0),95);assert.equal(env.mevcut(d,14100322),bag);
assert.notEqual(run(0).readUInt32BE(0),0);assert.notEqual(run(51).readUInt32BE(0),0);
console.log('PASS Academy: daily free turns, affordable batch, exact pill costs/XP, strict level/VIP/cap gates, save rollback, live inventory and attribute packets.');

let partnerState={},partnerPackets=[];const partnerAccount={...account,herolar:[11150031]};const partnerCtx={durum:partnerState,payload:new Y().u32(1).done(),kaydet:()=>{}};assert.equal(A.train(partnerCtx,{ekOnce:(id,p)=>partnerPackets.push({id,p}),ekSonra:(id,p)=>partnerPackets.push({id,p})},{account:partnerAccount,date}).readUInt32BE(0),0);assert(partnerPackets.some(p=>p.id===0x01180104&&p.p.readUInt32BE(0)===11150031));
console.log('PASS Academy refreshes partner attributes as well as the main character.');
