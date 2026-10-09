"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),{Y,O}=require('../paket'),env=require('../envanter'),protect=require('../protect-seireitei'),codec=require('../kodek');
let tick=1791530000,win=true,damage=123,sent=[],saved,gold=100,charges=0;
const y={ekSonra:(id,payload)=>sent.push({id,payload}),paraHarca:aw=>{charges++;const n=aw[0].amount;if(gold<n)return null;gold-=n;return Buffer.alloc(4);},paraIcinOdul:aw=>{gold+=aw[0].amount;},olay:{say:()=>{}}};
const simulate=(id,hp,d)=>{assert([12810159,12820159].includes(id));assert(hp>0);return {payload:Buffer.from('report'),won:win,damage};};
const P=protect.kur(y,{now:()=>tick,level:()=>159,simulate}),H=P.handlers;let d={nick:'Tester',roleIdHi:359,roleIdLo:80840994};
const ctx=payload=>({durum:d,payload,kaydet:next=>{saved=JSON.parse(JSON.stringify(next));}}),empty=Buffer.alloc(0),request=Buffer.alloc(8),currency=protect.config.rewardItem;
assert(P.fight(ctx(request)).error);assert(!d.protectSeireitei);
let raw=H['0x01810208'](ctx(empty)),o=new O(raw);assert.equal(o.u32(),0);assert.equal(o.u8(),1);assert.equal(o.u32(),tick);assert.equal(o.utf(),'Seireitei');assert.equal(o.u8(),0);assert.equal(o.u32(),159);o.p+=4;assert.equal(o.u8(),0);assert.equal(o.u32(),0);assert.equal(o.u16(),1);assert.equal(o.u32(),359);assert.equal(o.u32(),80840994);assert.equal(o.i8(),1);assert.equal(o.utf(),'Tester');o.u8();o.u32();o.u8();o.u32();o.u32();assert.equal(o.u8(),1);assert.equal(o.u16(),159);o.u32();o.u8();assert.equal(o.u16(),0);assert.equal(o.u16(),0);assert.equal(o.kalan(),0);
assert(P.fight(ctx(request)).error);H['0x01812400'](ctx(Buffer.from([1])));
let hp=d.protectSeireitei.hp,r=P.fight(ctx(request));assert(!r.error);assert.equal(d.protectSeireitei.hp,hp-123);assert.equal(d.protectSeireitei.damage,123);assert.equal(env.mevcut(d,currency),10);assert.deepEqual(d,saved);
assert.equal(r.result.readUInt16BE(5),1);assert.equal(r.result.readUInt16BE(7),1);assert.equal(r.result.readUInt32BE(9),currency);assert.equal(r.result.readUInt32BE(13),10);
const bag=r.updates.find(x=>x.id===0x01180f00);assert(bag&&bag.payload.equals(env.loadBagPaketi(d)));
let snap=JSON.stringify(d);assert(P.fight(ctx(request)).error);assert.equal(JSON.stringify(d),snap);
H['0x01810208'](ctx(empty));H['0x01812400'](ctx(Buffer.from([1])));assert(P.fight(ctx(request)).error);assert.equal(env.mevcut(d,currency),10);
for(const payload of [Buffer.alloc(0),Buffer.alloc(7),new Y().u32(1).u32(2).done(),Buffer.concat([request,Buffer.from([0])])])assert(P.fight(ctx(payload)).error);
// Local replay neither grants reward nor mutates HP, cooldown or inventory.
snap=JSON.stringify(d);r=P.replay(ctx(new Y().utf(d.protectSeireitei.reports[0].id).done()));assert(!r.error);assert.equal(r.result.readUInt16BE(5),0);assert.equal(JSON.stringify(d),snap);assert.equal(r.updates.length,0);
assert(P.replay(ctx(new Y().utf('unknown').done())).error);
// Losing still grants participation currency, while retaining the real death deadline.
tick+=20;win=false;damage=10;r=P.fight(ctx(request));assert(!r.error);assert.equal(env.mevcut(d,currency),20);assert.equal(d.protectSeireitei.deadUntil,tick+59);assert.equal(r.result[4],0);assert.equal(r.result.readUInt32BE(13),10);
assert(P.fight(ctx(request)).error);let s=H['0x01812400'](ctx(Buffer.from([1])));assert.equal(s.payload[8],0);assert.equal(s.payload.readUInt32BE(9),tick+59);
// Revival charges the same native tiered gold cost and refunds on persistence failure.
snap=JSON.stringify(d);const broken=ctx(empty);broken.kaydet=()=>{throw Error('disk');};assert.equal(H['0x01812402'](broken).readUInt32BE(0),1);assert.equal(JSON.stringify(d),snap);assert.equal(gold,100);
assert.equal(H['0x01812402'](ctx(empty)).readUInt32BE(0),0);assert.equal(gold,99);assert.equal(d.protectSeireitei.deadUntil,0);assert.equal(d.protectSeireitei.revives,1);
assert.notEqual(H['0x01812402'](ctx(empty)).readUInt32BE(0),0);assert.equal(gold,99);
s=H['0x01812400'](ctx(Buffer.from([0])));assert.equal(s.payload[8],2);assert.equal(d.protectSeireitei.atDoor,false);
H['0x01812400'](ctx(Buffer.from([1])));tick+=20;win=true;snap=JSON.stringify(d);const bad=ctx(request);bad.kaydet=()=>{throw Error('disk');};assert(P.fight(bad).error);assert.equal(JSON.stringify(d),snap);
// Clearing each gate transitions exactly once, finishes only this round and allows re-entry.
damage=d.protectSeireitei.hp;r=P.fight(ctx(request));assert(!r.error);assert.equal(d.protectSeireitei.doorIndex,1);assert.equal(d.protectSeireitei.hp,Number(protect.enemy(d.protectSeireitei).hp));assert(!r.updates.some(x=>x.id===protect.OP.END));assert.equal(r.updates.find(x=>x.id===protect.OP.HP).payload.readFloatBE(0),0);
tick+=20;H['0x01812400'](ctx(Buffer.from([1])));damage=d.protectSeireitei.hp;r=P.fight(ctx(request));assert(!r.error);assert(r.updates.some(x=>x.id===protect.OP.END));assert(d.protectSeireitei.finished);assert(!d.protectSeireitei.active);assert.equal(env.mevcut(d,currency),40);assert(P.fight(ctx(request)).error);
H['0x01810208'](ctx(empty));assert(d.protectSeireitei.active);assert.equal(d.protectSeireitei.doorIndex,0);assert.equal(env.mevcut(d,currency),40);
// Overflow is rejected without consuming a battle or awarding a partial stack.
env.ekle(d,[{type:1,code:currency,amount:65535}]);tick+=20;H['0x01812400'](ctx(Buffer.from([1])));snap=JSON.stringify(d);assert(P.fight(ctx(request)).error);assert.equal(JSON.stringify(d),snap);
const old=d.protectSeireitei.nextFight,oldHp=d.protectSeireitei.hp;const midnight=protect.state(JSON.parse(JSON.stringify(d)),tick+86400,159);assert(midnight.active&&midnight.atDoor);assert.equal(midnight.hp,oldHp);assert.equal(midnight.nextFight,old);
tick+=86400;H['0x01810208'](ctx(empty));assert.equal(d.protectSeireitei.damage,0);assert.equal(d.protectSeireitei.battles,0);assert.equal(d.protectSeireitei.revives,0);assert.equal(d.protectSeireitei.reports.length,0);assert.equal(d.protectSeireitei.nextFight,old);
assert.equal(require('../lonca').aktiviteDurumPaketi()[0],2);
// Exercise a real, decoded battle above the old model table limit, without saving player files.
const real=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'),'utf8'));const battle=require('../savas').cityDefendBattle(12810159,12345,real);const report=codec.decodeBattleReport(battle.payload);assert.equal(report._consumed,report._total);assert.equal(report.player2.roles[0].roleId,12810001);assert.equal(report.player2.roles[0].totalHealth,12345);assert.equal(report.player2.roles[0].level,159);assert(Number.isFinite(battle.damage));
const handlers=require('../handlers');handlers.ekAl();const packet=handlers.byReq['0x01810208']({durum:real,payload:empty,kaydet:()=>{}});assert.equal(packet.readUInt32BE(0),0);assert.equal(packet[4],1);assert(handlers.byReq['0x01812400']);handlers.ekAl();
console.log('PASS Protect Seireitei: native entry/door/rank/reward packets, real level-159 gate report, two-stage progression, all-day status, 10 gems on win/loss, immediate bag, no rewards on entry/replay, cooldown across re-entry, accurate death/revive/refund, malformed requests, overflow, save rollback and day rollover. No player files changed.');
