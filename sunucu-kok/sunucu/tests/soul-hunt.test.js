"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),hunt=require('../soul-hunt'),p=require('../paket'),env=require('../envanter'),gear=require('../ekipman'),codec=require('../kodek');
let time=Math.floor(Date.now()/1000),money={level:159,vipLevel:15,gumus:10000000,altin:10000,kupon:10000},packets=[],fail=false;
const fields={0:'gumus',1:'altin',2:'kupon'};
const y={ekSonra:(id,payload,name)=>packets.push({id,payload,name}),paraHarca:costs=>{if(costs.some(a=>money[fields[a.code]]<a.amount))return null;for(const a of costs)money[fields[a.code]]-=a.amount;return Buffer.alloc(1);},paraIcinOdul:awards=>{for(const a of awards)money[fields[a.code]]+=a.amount;return awards.length?Buffer.alloc(1):null;}};
const api=hunt.kur(y,{now:()=>time,rng:()=>0.99,account:()=>money});
function fixture(){const d=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json')));delete d.hazine;d.gunlukSayac={};return d;}
function ctx(d,payload=Buffer.alloc(0)){return {durum:d,payload,kaydet:()=>{if(fail)throw Error('disk');}};}
const H=api.handlers,err=b=>b.readUInt32BE(0),u32=n=>new p.Y().u32(n).done();
function parseInfo(buf){const o=new p.O(buf);assert.equal(o.u32(),0);const enter=o.u8(),refresh=o.u8(),quality=o.u32(),status=o.u8(),rob=o.u8(),vip=o.u8(),blue=o.u32(),red=o.u32(),times=o.u8(),n=o.u16();const actors=[];for(let i=0;i<n;i++){const id0=o.u32(),id1=o.u32(),index=o.u8(),hero=o.u32(),name=o.utf(),rank=o.u32(),level=o.u16(),union=o.utf(),won=o.u8(),start=o.u32(),robbed=o.u8(),q=o.u32();actors.push({id0,id1,index,hero,name,level,start,q});}assert.equal(o.kalan(),0);return {enter,refresh,quality,status,rob,vip,blue,red,times,actors};}
let d=fixture();let info=parseInfo(H['0x01810207'](ctx(d)));assert.equal(info.times,5);assert.equal(info.actors.length,5);
for(const [q,blue,red] of [[101,12,0],[102,16,0],[103,10,5],[104,0,17],[105,0,25]]){
 d=fixture();const k=hunt.state(d,time);k.quality=q;const bagBefore=env.mevcut(d,14100021),silverBefore=money.gumus;
 assert.equal(err(H['0x01811f00'](ctx(d,Buffer.from([0])))),0);assert.equal(k.g.times,5);assert.equal(hunt.state(d,time).g.times,4);
 info=parseInfo(hunt.infoPacket(d,time));assert.equal(info.actors.find(a=>a.index===0).start,time);
 assert.equal(err(api.finish(ctx(d),false)),1);time+=1200;
 const expectedSilver=hunt.silver(d,p.satir('Digging',q));assert.equal(err(api.finish(ctx(d),false)),0);const s=hunt.state(d,time);assert.equal(s.blue,blue);assert.equal(s.red,red);assert.equal(money.gumus,silverBefore+expectedSilver);assert(env.mevcut(d,14100021)>bagBefore);
 assert.equal(err(api.finish(ctx(d),false)),1);const pushes=packets.filter(x=>x.id===hunt.OP.STAR).slice(-2);assert.deepEqual(pushes.map(x=>[x.payload.readUInt32BE(0),x.payload.readUInt32BE(4)]),[[8,blue],[9,red]]);
 assert(packets.some(x=>x.name==='SOULHUNT-bag'&&gear.kayitlariOku(x.payload,5).son===x.payload.length));
}
d=fixture();hunt.state(d,time).quality=105;H['0x01811f00'](ctx(d,Buffer.from([0])));const gold=money.altin;assert.equal(err(H['0x01811f03'](ctx(d))),0);assert.equal(money.altin,gold-20);
d=fixture();hunt.state(d,time);for(let i=0;i<15;i++)assert.equal(err(H['0x01811f01'](ctx(d))),0);assert.notEqual(err(H['0x01811f01'](ctx(d))),0);assert.equal(hunt.state(d,time).g.refresh,15);
d=fixture();hunt.state(d,time);const coupons=money.kupon;assert.equal(err(H['0x01811f02'](ctx(d,u32(104)))),0);assert.equal(money.kupon,coupons-150);assert.equal(hunt.state(d,time).quality,104);assert.notEqual(err(H['0x01811f02'](ctx(d,u32(104)))),0);
const buyGold=money.altin;assert.equal(err(H['0x01811f05'](ctx(d)).payload),0);assert.equal(money.altin,buyGold-20);assert.equal(hunt.state(d,time).g.times,6);
const row=p.tablo('Mall').liste.find(m=>m.model===3&&JSON.parse(m.type)[0]===9);const state=hunt.state(d,time);state.red=1000;const red=state.red,owned=env.mevcut(d,row.itemID),goldBefore=money.altin;assert.equal(err(api.exchange(ctx(d),row,2)),0);assert.equal(hunt.state(d,time).red,red-row.integration*2);assert.equal(env.mevcut(d,row.itemID),owned+row.amount*2);assert.equal(money.altin,goldBefore);
state.red=0;hunt.state(d,time).red=0;assert.equal(err(api.exchange(ctx(d),row,1)),18);assert.equal(err(api.exchange(ctx(d),row,-1)),4);
d=fixture();hunt.state(d,time);const snapshot=JSON.stringify(d),cash={...money};fail=true;assert.notEqual(err(H['0x01811f01'](ctx(d))),0);assert.deepEqual(money,cash);assert.equal(JSON.stringify(d),snapshot);fail=false;
d=fixture();const k=hunt.state(d,time);const bot=k.bots[0],rob=api.rob(ctx(d,new p.Y().u32(bot.id0).u32(bot.id1).done()));assert.equal(rob.error,0);assert(rob.report.payload);assert.equal(codec.decodeBattleReport(rob.report.payload)._consumed,rob.report.payload.length);assert.equal(hunt.state(d,time).g.robbery,1);assert.equal(api.rob(ctx(d,new p.Y().u32(bot.id0).u32(bot.id1).done())).error,1);assert.equal(api.rob(ctx(d,new p.Y().u32(d.roleIdHi||0).u32(d.roleIdLo||1).done())).error,1);
const oldBlue=hunt.state(d,time).blue;time+=86400;assert.equal(hunt.state(d,time).g.times,5);assert.equal(hunt.state(d,time).g.robbery,0);assert.equal(hunt.state(d,time).blue,oldBlue);
assert(require('../handlers').byReq['0x01811f7e']);
console.log('PASS: all five target rewards/blue-red points, silver formula, timer/start timestamp, free/fast completion, duplicate prevention, refresh tiers/limits, direct activation/cost, VIP buys, point exchange without gold, save refund/rollback, robbery/cooldown/self rejection, daily reset, native packet parsing and immediate bag updates. No player files changed.');
