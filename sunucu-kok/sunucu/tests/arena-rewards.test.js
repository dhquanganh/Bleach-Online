'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-arena-reward-'));process.env.BLEACH_ACCOUNT_DIR=temp;process.env.BLEACH_ACCOUNT_ID='self';
const R=require('../arena-rewards'),real=require('../arena-real'),inv=require('../envanter'),{cutoff}=require('../arena-clock'),{tablo,Y}=require('../paket');
const vf=path.join(temp,'veri.json'),pf=path.join(temp,'oyuncu.json');
let d,pushes=[];
const now=new Date(2026,9,19,19,30,0).getTime();
const settlement={period:'2026-10-19',releasedAt:now,ranking:1,level:99};
function setup(){d={};fs.writeFileSync(vf,JSON.stringify({gumus:1000,gumusHigh:0,prestij:50}));fs.writeFileSync(pf,JSON.stringify(d));pushes=[];}
const save=state=>fs.writeFileSync(pf,JSON.stringify(state));
const y={ekSonra:(id,payload)=>pushes.push({id,payload})};
const call=(settled=settlement,time=now,kaydet=save,payload=Buffer.alloc(0))=>R.claim({durum:d,payload,kaydet},y,{settlement:settled,now:time});
async function test(){try{
 assert.equal(cutoff(new Date(now)).releasedAt,now);
 for(const rank of [1,2,3,10,11,40,41,100,101,200,201,600,601,800,801,1000]){
  for(const level of [1,24,49,50,69,70,99,100,120,159]){
   const a=R.rewards(rank,level);assert.equal(a[2].amount,tablo('RankMoney').byId.get(rank).prestige);
   assert(a[1].amount>0);assert(inv.articleSet().has(a[0].code));assert(a[0].amount>0);
  }
 }
 assert.equal(R.rewards(0,99),null);assert.equal(R.rewards(1001,99),null);
 assert.equal(R.rewards(1,160),null);
 setup();assert.equal(R.info(d,settlement,now-1).type,0);assert.equal(call(settlement,now-1).readUInt32BE(),1);assert.equal(pushes.length,0);
 const awards=R.rewards(1,99);assert.deepEqual(awards[0],{type:1,code:14800022,amount:14});assert.equal(awards[2].amount,20000);
 const before=inv.mevcut(d,awards[0].code);const reply=call();assert.equal(reply.readUInt32BE(),0);assert.equal(reply.readUInt16BE(4),3);assert.equal(reply.length,36);
 const account=JSON.parse(fs.readFileSync(vf));assert.equal(account.gumus,1000+awards[1].amount);assert.equal(account.prestij,20050);
 assert.equal(inv.mevcut(JSON.parse(fs.readFileSync(pf)),awards[0].code),before+14);
 assert(pushes.some(p=>p.id===0x01180105));assert(pushes.some(p=>p.id===inv.OP_NTF));
 d=JSON.parse(fs.readFileSync(pf));assert.equal(R.info(d,settlement,now).type,2);assert.equal(call().readUInt32BE(),1);
 // Midnight is not a new Arena release, and a live rank change cannot increase the chest.
 assert.equal(call(settlement,now+5*3600000).readUInt32BE(),1);
 real.update([{accountId:'self',ranking:200}],settlement);assert.equal(real.rank(),200);assert.equal(real.reward().ranking,1);
 // A second day's settlement is claimable once.
 const tomorrow={...settlement,period:'2026-10-20',releasedAt:now+86400000,ranking:100};
 assert.equal(call(tomorrow,now+86400000).readUInt32BE(),0);assert.equal(d.arenaReward.ranking,100);
 setup();const state=JSON.stringify(d),oldV=fs.readFileSync(vf),oldP=fs.readFileSync(pf);
 assert.equal(call(settlement,now,next=>{save(next);throw Error('simulated failed save');}).readUInt32BE(),1);
 assert.equal(JSON.stringify(d),state);assert.deepEqual(fs.readFileSync(vf),oldV);assert.deepEqual(fs.readFileSync(pf),oldP);assert.equal(pushes.length,0);assert.equal(call().readUInt32BE(),0);
 setup();assert.equal(call(null).readUInt32BE(),1);assert.equal(call(settlement,now,save,Buffer.alloc(1)).readUInt32BE(),1);
 // Full inventory must not consume the chest or lose items silently.
 d.envanter={esyalar:Array.from({length:2048},(_,i)=>({code:14000000+i,amount:1})),dusulen:{}};
 assert.equal(call().readUInt32BE(),1);assert.equal(d.arenaReward,undefined);assert.equal(JSON.parse(fs.readFileSync(vf)).prestij,50);
 setup();fs.writeFileSync(vf,JSON.stringify({gumus:0xffffffff-10,gumusHigh:2,prestij:0}));assert.equal(call().readUInt32BE(),0);assert.equal(JSON.parse(fs.readFileSync(vf)).gumusHigh,3);assert.equal(JSON.parse(fs.readFileSync(vf)).gumus,awards[1].amount-11);
 // A process interruption is recovered before player loading, with the claim marker intact.
 const target={account:{gumus:777,prestij:88},player:{arenaReward:{period:settlement.period}}};
 fs.writeFileSync(path.join(temp,'arena-reward-pending.json'),JSON.stringify(target));
 const loaded=require('../durum').yukle();assert.equal(loaded.arenaReward.period,settlement.period);assert.equal(loaded.gumus,777);assert(!fs.existsSync(path.join(temp,'arena-reward-pending.json')));
 // Native Enter_Arena must advertise the entitlement instead of hardcoded BoxType=0.
 setup();real.update([{accountId:'self',ranking:200}],{...settlement,releasedAt:0});const h=require('../handlers');
 let packet=h.byReq['0x01810206']({durum:d});assert.equal(packet[4],1);assert.equal(packet.readUInt16BE(5),1);assert.equal(packet.readUInt32BE(7),99);
 assert.equal(packet.readUInt16BE(19),200,'Native CurRanking uses the shared live rank');
 real.update([{accountId:'self',ranking:2}],{...settlement,releasedAt:0});
 packet=h.byReq['0x01810206']({durum:d});assert.equal(packet.readUInt16BE(19),2);
 assert.equal(packet.readUInt16BE(5),1,'Live rank changes must not rewrite the released chest rank');
 assert.equal(h.byReq['0x01811901']({durum:d,payload:Buffer.alloc(0),kaydet:save}).readUInt32BE(),0);
 packet=h.byReq['0x01810206']({durum:d});assert.equal(packet[4],2);
 await settlementTests();
 console.log('PASS Arena rewards: tier/level/Prestige, native packets, cutoff, immutable daily snapshot, offline/restart recovery, duplicate and midnight checks, real inventory/currency persistence, full bag, save rollback and silver carry.');
}finally{assert(path.resolve(temp).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(temp,{recursive:true,force:true});}}
async function settlementTests(){
 const docs=new Map(),collection={
  async updateOne(q,u){if(!docs.has(q._id))docs.set(q._id,{_id:q._id,...structuredClone(u.$setOnInsert)});},
  async findOne(q){return q._id?docs.get(q._id)||null:[...docs.values()].filter(d=>d.releasedAt<=q.releasedAt.$lte).sort((a,b)=>b.releasedAt-a.releasedAt)[0]||null;}
 };
 const create=()=>require('../../arena-settlement.cjs').createSettlement({collection:()=>collection});
 const rows=[{accountId:'self',ranking:1,level:99},{accountId:'offline',ranking:2,level:80}];
 const settle=create();assert.equal(await settle(rows,new Date(now-1)),null);
 const first=await settle(rows,new Date(now));assert.equal(first.rewards.length,2);
 rows[0].ranking=5;assert.equal((await settle(rows,new Date(now+1))).rewards[0].ranking,1);
 assert.equal((await create()(rows,new Date(now+1))).rewards[0].ranking,1);
 assert.equal((await create()(rows,new Date(now+5*3600000)))._id,settlement.period);
 const next=await settle(rows,new Date(now+86400000));assert.equal(next._id,'2026-10-20');assert.equal(next.rewards[0].ranking,5);
 assert(!next.rewards.some(r=>r.accountId==='new-account'));
}
test().catch(e=>{console.error(e);process.exitCode=1;});
