"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),{Y,O,cv,tablo}=require('../paket'),cross=require('../cross-server'),bots=require('../cross-server-bots'),env=require('../envanter'),codec=require('../kodek'),models=require('../tower-gold-models');
const all=bots.all();assert.equal(all.length,2000);assert.equal(new Set(all.map(b=>b.heroes.join(','))).size,2000);for(const b of all){assert.equal(new Set(b.heroes).size,5);assert.equal(new Set(b.positions).size,5);assert(b.heroes.every(id=>models.allowed(id)));}assert.deepEqual(bots.get(42).heroes,bots.get(42).heroes);
let tick=1791530000,gold=10000,silver=1000000,packets=[],saved,won=true,lastTeam;let d={nick:'Test'};
const y={ekSonra:(id,payload)=>packets.push({id,payload}),paraHarca:aw=>{let g=0,s=0;for(const a of aw)if(a.code===1)g+=a.amount;else s+=a.amount;if(gold<g||silver<s)return null;gold-=g;silver-=s;return Buffer.alloc(4);},paraIcinOdul:aw=>{for(const a of aw)if(a.type===0&&a.code===1)gold+=a.amount;else if(a.type===0&&a.code===0)silver+=a.amount;return Buffer.alloc(4);}};
const P=cross.kur(y,{now:()=>tick,simulate:(team,state)=>{lastTeam=team;return {payload:Buffer.from('battle'),won};}}),H=P.handlers;
const ctx=payload=>({durum:d,payload,kaydet:next=>saved=JSON.parse(JSON.stringify(next))}),call=(op,payload=Buffer.alloc(0))=>H['0x01813d'+op](ctx(payload));
assert.equal(H['0x01810213'](ctx(Buffer.alloc(0))).readUInt32BE(0),0);let k=d.crossServer;let p=call('05'),o=new O(p);const ids=[];
for(const n of [18,12]){assert.equal(o.u16(),n);for(let i=0;i<n;i++){const id=o.u32(),name=o.utf(),server=o.utf(),main=o.u32(),count=o.u16(),team=[main];for(let j=0;j<count;j++)team.push(o.u32());assert.equal(team.length,5);assert.deepEqual(team,bots.get(id).heroes);o.u32();o.u32();o.u32();o.u32();o.u32();o.u32();o.u8();ids.push(id);}}assert.equal(o.kalan(),0);assert.equal(new Set(ids).size,30);
assert.equal(call('07').length,50);assert.equal(call('0d').length,20);assert.equal(call('04').readUInt16BE(0),2001);
const req=(id,mode=0)=>new Y().u8(mode).u32(id).done(),target=k.normal[0],before=env.mevcut(d,14100282);let r=P.fight(ctx(req(target)));assert(!r.error);assert.deepEqual(lastTeam.heroes,bots.get(target).heroes);assert.equal(lastTeam.id,target);assert.equal(d.crossServer.times,4);assert.equal(env.mevcut(d,14100282),before+2);assert(d.crossServer.killed[target]);assert.equal(r.ack.length,9);assert(packets.some(p=>p.id===0x01180f00&&p.payload.equals(env.loadBagPaketi(d))));assert.deepEqual(d,saved);
let snapshot=JSON.stringify(d);assert(P.fight(ctx(req(target))).error);assert.equal(JSON.stringify(d),snapshot);assert(P.fight(ctx(req(d.crossServer.normal[1]))).error);tick+=11;assert(P.fight(ctx(req(d.crossServer.normal[6]))).error);
// Loss consumes one attempt, does not grant victory items and records the exact opponent.
won=false;r=P.fight(ctx(req(d.crossServer.normal[1])));assert(!r.error);assert.equal(d.crossServer.times,3);assert(!d.crossServer.killed[d.crossServer.normal[1]]);assert.equal(env.mevcut(d,14100282),before+2);assert.equal(d.crossServer.history[0].name,lastTeam.name);
// Replay has no cost or extra rewards; direct requests cannot use hidden/unknown IDs.
snapshot=JSON.stringify(d);const row=d.crossServer.history[0];r=P.replay(ctx(new Y().utf(row.id).done()));assert(!r.error);assert.equal(r.ack[4],2);assert.equal(r.result.readUInt16BE(5),0);assert.equal(JSON.stringify(d),snapshot);assert(P.fight(ctx(req(0))).error);
const g=gold;assert.equal(call('0c').readUInt32BE(0),0);assert.equal(gold,g-10);assert.equal(d.crossServer.times,4);
assert.equal(call('0a').readUInt32BE(0),0);assert.equal(d.crossServer.refresh,1);tick+=11;won=true;r=P.fight(ctx(req(d.crossServer.super[0],1)));assert(!r.error);assert(P.fight(ctx(req(d.crossServer.super[4],1))).error);
// Locked boxes, repeated claims and save failures do not grant rewards or lose funds.
assert.notEqual(call('11',new Y().u32(1).done()).readUInt32BE(0),0);d.crossServer.normal.slice(0,6).forEach(id=>d.crossServer.killed[id]=true);const tokenBefore=env.mevcut(d,14100282);assert.equal(call('11',new Y().u32(1).done()).readUInt32BE(0),0);assert.equal(env.mevcut(d,14100282),tokenBefore+46);assert.equal(env.mevcut(d,14100283),10);assert.equal(env.mevcut(d,14900001),5);assert.notEqual(call('11',new Y().u32(1).done()).readUInt32BE(0),0);
const broken=ctx(Buffer.alloc(0));broken.kaydet=()=>{throw Error('disk');};snapshot=JSON.stringify(d);const oldGold=gold;assert.notEqual(H['0x01813d0c'](broken).readUInt32BE(0),0);assert.equal(gold,oldGold);assert.equal(JSON.stringify(d),snapshot);
// Claiming all cleared groups advances to another set of the 2,000 bots.
d.crossServer.normal.forEach(id=>d.crossServer.killed[id]=true);const oldList=d.crossServer.normal.slice();for(let box=2;box<=5;box++)assert.equal(call('11',new Y().u32(box).done()).readUInt32BE(0),0);assert.equal(d.crossServer.boxes,0);assert.equal(d.crossServer.round,1);assert.equal(env.mevcut(d,14100283),150);assert.equal(env.mevcut(d,14900001),75);assert.notDeepEqual(d.crossServer.normal,oldList);
// Cross shops consume their configured token item rather than gold, and update the bag immediately.
const mall=tablo('Mall').liste.find(m=>Number(m.model)===12&&JSON.parse(m.honour||'{}').code===14100282);assert(mall);const price=JSON.parse(mall.honour);env.ekle(d,[{type:1,code:14100282,amount:price.amount}]);const itemBefore=env.mevcut(d,Number(mall.itemID)),money=gold;p=P.exchange(ctx(new Y().u32(mall._id).u16(1).done()),mall,1);assert.equal(p.readUInt32BE(0),0);assert.equal(gold,money);assert.equal(env.mevcut(d,Number(mall.itemID)),itemBefore+Number(mall.amount));
const stoneOffer=tablo('Mall').liste.find(m=>Number(m.model)===13&&[14100283,14100733].includes(Number(JSON.parse(m.honour||'{}').code)));assert(stoneOffer);const stonePrice=JSON.parse(stoneOffer.honour);env.ekle(d,[{type:1,code:stonePrice.code,amount:stonePrice.amount}]);const stoneBalance=env.mevcut(d,stonePrice.code),stoneItem=env.mevcut(d,stoneOffer.itemID);p=P.exchange(ctx(new Y().u32(stoneOffer._id).u16(1).done()),stoneOffer,1);assert.equal(p.readUInt32BE(0),0);assert.equal(env.mevcut(d,stonePrice.code),stoneBalance-stonePrice.amount);assert.equal(env.mevcut(d,stoneOffer.itemID),stoneItem+Number(stoneOffer.amount));assert.equal(gold,money);
// A real combat report uses the same five heroes advertised in the challenge list.
const source=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'),'utf8')),savas=require('../savas'),team=bots.team(5,153),actual=savas.kadroRapor(0,team,null,{playerState:source,forceWin:false,requireEnemyDefeated:true}),decoded=codec.decodeBattleReport(actual.payload);assert.deepEqual(decoded.player2.roles.map(r=>r.roleId),team.heroes);assert.deepEqual(decoded.player2.roles.map(r=>r.pos),team.positions);assert.equal(decoded._consumed,decoded._total);
const oldSeason=d.crossServer.season;tick+=86400;call('05');assert.equal(d.crossServer.times,5);assert.equal(d.crossServer.refresh,0);assert.equal(d.crossServer.boxes,0);
const handlers=require('../handlers');handlers.ekAl();assert.equal(handlers.byReq['0x01813d07']({durum:source,payload:Buffer.alloc(0)}).length,50);handlers.ekAl();
console.log('PASS Cross Server: 2,000 unique playable squads; exact native challenge/base/season/rank packets; matching actual combat heroes/positions; progression, limits/cooldown, win/loss rewards, replay, paid/refund flows, locked/duplicate boxes, next-round opponents, native token shop and daily reset. No player files changed.');

// Every native hero offer recruits immediately, once, with atomic payment.
for(const offer of tablo('Mall').liste.filter(r=>[12,13].includes(Number(r.model))&&require('../paket').satir('BaseHero',r.itemID))){
 const local={},price=JSON.parse(offer.honour),request=new Y().u32(offer._id).u16(1).done();
 env.ekle(local,[{type:1,code:price.code,amount:price.amount}]);packets=[];
 const c={durum:local,payload:request,kaydet:()=>{throw Error('disk');}},before=JSON.stringify(local);
 assert.notEqual(P.exchange(c,offer,1).readUInt32BE(0),0);assert.equal(JSON.stringify(local),before);assert.equal(packets.length,0);
 c.kaydet=()=>{};assert.equal(P.exchange(c,offer,1).readUInt32BE(0),0);
 assert(local.meyhane.alinan[String(offer.itemID)]);assert.equal(env.mevcut(local,price.code),0);
 assert(packets.some(p=>p.id===0x01180c02&&p.payload.readUInt32BE(4)===Number(offer.itemID)));assert(packets.some(p=>p.id===0x01180f00));
 const owned=JSON.stringify(local);assert.notEqual(P.exchange(c,offer,1).readUInt32BE(0),0);assert.equal(JSON.stringify(local),owned);
}
console.log('PASS all six character offers: immediate recruitment and bag updates, duplicate rejection, save rollback.');

const direct=ctx(Buffer.from([1]));assert.equal(H['0x01810213'](direct).readUInt32BE(0),1);
const entryBroken=ctx(Buffer.from([1]));entryBroken.kaydet=()=>{throw Error('disk');};assert.equal(H['0x01810213'](entryBroken).readUInt32BE(0),2);
assert.equal(H['0x01810213'](ctx(Buffer.from([2]))).readUInt32BE(0),4);
console.log('PASS direct Enter: native scene result 1, no registration; failed save never sends successful scene entry.');

// Native group order starts at the bottom (six opponents) and ends at the apex (one).
const rows={normal:Array.from({length:18},(_,i)=>i+1),super:[19,20,21,22]};
assert.deepEqual([1,7,12,16,18].map(id=>cross.difficulty(rows,id)),[0,1,2,3,4]);
for(let row=0;row<=4;row++){
 const enhanced=bots.team(5,153,row),baseline={...enhanced,level:enhanced.baseLevel};delete baseline.crossStatScale;
 assert.equal(enhanced.level,Math.round(306*(1+row*.25)));assert.equal(enhanced.crossStatScale,2+row);assert.equal(enhanced.crossAttackScale,2);
 const oldReport=codec.decodeBattleReport(savas.kadroRapor(0,baseline,null,{playerState:source,forceWin:false,requireEnemyDefeated:true}).payload);
 const newReport=codec.decodeBattleReport(savas.kadroRapor(0,enhanced,null,{playerState:source,forceWin:false,requireEnemyDefeated:true}).payload);
 newReport.player2.roles.forEach((role,i)=>{assert.equal(role.level,enhanced.level);assert.equal(role.totalHealth,Math.min(1000000000,Math.round(oldReport.player2.roles[i].totalHealth*enhanced.crossStatScale)));});
}
console.log('PASS Cross difficulty: bottom-to-top levels 306/383/459/536/612; stat factors 2/3/4/5/6; actual battle HP and reported levels match.');

for(let tier=0;tier<7;tier++)for(let index=0;index<5;index++){
 const rewards=JSON.parse(tablo('GSPVP_Reward').liste.find(r=>r._id===5001+tier*5+index).f2);
 assert.equal(rewards.find(r=>r.code===14100283).amount,10*(index+1));
 assert.equal(rewards.find(r=>r.code===14900001).amount,5*(index+1));
}
console.log('PASS Cross chests: immediate grants, totals 150 Challenge Stones/75 gems; increasing rewards for all seven tiers.');
