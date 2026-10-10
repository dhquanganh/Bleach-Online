'use strict';
const assert=require('assert'),R=require('../reiatsu'),levels=require('../seviye'),stats=require('../statlar'),gear=require('../ekipman'),{Y,tablo}=require('../paket');
const account={level:99,vipLevel:6,herolar:[11150031],generalsSoul:100,altin:10000,kupon:0};
let d={knifeSoul:{id:18100001,exp:0},kadro:{11150031:7}},pushes=[],saved;
const cost=(kind,count)=>({hata:account[kind===1?'generalsSoul':'altin']<(kind===1?count:count*10)?1:0,oduller:[{type:kind===1?6:0,code:kind===1?0:1,amount:kind===1?count:count*10}]});
const y={ekOnce:(id,payload)=>pushes.push({id,payload}),paraHarca:aw=>{for(const a of aw)account[a.type===6?'generalsSoul':'altin']-=a.amount;return Buffer.alloc(2);},paraIcinOdul:aw=>{for(const a of aw)account[a.type===6?'generalsSoul':'altin']+=a.amount;},olay:{say:()=>{}}};
function ctx(payload){return {durum:d,payload,kaydet:next=>saved=JSON.parse(JSON.stringify(next))};}
const request=(n,kind)=>new Y().i16(n).i8(kind).done();
const before=gear.statPaketi(d,11150031,99);
const reply=R.train(ctx(request(1,1)),y,{account,cost});assert.equal(reply.length,18);assert.equal(reply.readUInt32BE(0),0);assert.equal(d.knifeSoul.id,18100002);assert.equal(account.generalsSoul,99);
assert(pushes.some(p=>p.id===0x01180104&&p.payload.readUInt32BE(0)===11150031));assert(pushes.some(p=>p.id===0x01180104&&p.payload.readUInt32BE(0)===levels.anaId()));
const after=gear.statPaketi(d,11150031,99),low=stats.blokOku(before.subarray(4)),high=stats.blokOku(after.subarray(4));
assert(high.hp>low.hp);assert(high.atk>low.atk);assert(high.def>low.def);
for(let offset=4,pass=0;pass<2;pass++){const count=after.readUInt16BE(offset);offset+=2;for(const index of [0,1,2,3,5,6,7,8,9,26])assert(after.readUInt32BE(offset+index*4)>before.readUInt32BE(offset+index*4));offset+=count*4;}
assert.equal(gear.statPaketi(saved,11150031,99).toString('hex'),after.toString('hex'));
let snapshot=JSON.stringify(d),money=account.altin;pushes=[];const failed=ctx(request(1,2));failed.kaydet=()=>{throw Error('disk');};assert.equal(R.train(failed,y,{account,cost}).readUInt32BE(0),1);assert.equal(JSON.stringify(d),snapshot);assert.equal(account.altin,money);assert.equal(pushes.length,0);
assert.equal(R.train(ctx(Buffer.alloc(2)),y,{account,cost}).readUInt32BE(0),4);assert.equal(R.train(ctx(request(0,1)),y,{account,cost}).readUInt32BE(0),4);
assert.equal(R.train(ctx(new Y().u32(1).u32(2).done()),y,{account,cost}).readUInt32BE(0),0);
const row=tablo('KnifeSoul').byId.get(d.knifeSoul.id);assert.deepEqual(stats.knifeSoulBonuses(d),{power:Number(row.power),agile:Number(row.agile),intelligence:Number(row.intelligence),life:Number(row.life)});
console.log('PASS Reiatsu: real primary/combat gains in both stat groups, all owned heroes refreshed, relog persistence, both native request layouts, exact costs and save-failure refund. No player files changed.');
