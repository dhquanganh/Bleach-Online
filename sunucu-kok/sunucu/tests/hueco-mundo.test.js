'use strict';
// Runs in memory; never saves player files or starts a server.
const assert=require('assert'),fs=require('fs'),path=require('path'),vm=require('vm'),{createRequire}=require('module');
const root=path.resolve(__dirname,'..'),file=path.join(root,'hueco-mundo.js'),local=createRequire(file);
const env=local('./envanter'),packet=local('./paket');
const fakeArena={playerHeroes:()=>[11100001],build:()=>[{id0:1,id1:2,heroes:[11140001],positions:[6],name:'Bot',level:30,power:1}]};
const mock={exports:{}};
vm.runInNewContext(fs.readFileSync(file,'utf8'),{module:mock,exports:mock.exports,Buffer,require:name=>name==='./arena-bot'?fakeArena:name==='./seviye'?{anaId:()=>11100001,anaDurum:()=>({lv:30})}:local(name)});
const h=mock.exports,d={nick:'Test',vipLevel:15};
const simulate=won=>({payload:Buffer.from([1]),won,remainingHp:[{camp:0,id:11100001,rate:won?.8:0},{camp:1,id:11140001,rate:won?0:.5}]});
const before=env.mevcut(d,h.COIN),snapshot=JSON.stringify(h.state(d).points);
assert.strictEqual(JSON.stringify(h.state(JSON.parse(JSON.stringify(d))).points),snapshot);
for(const bad of [Buffer.alloc(0),Buffer.from([15]),Buffer.from([255]),Buffer.from([0,1])])assert(!h.canFight(d,bad));
assert(!h.canFight(d,Buffer.from([1])));assert(!h.claim(d,Buffer.from([0])).rewards.length);
for(let i=0;i<15;i++){
 const p=Buffer.from([i]),r=h.battle(d,p,()=>simulate(true));
 assert.strictEqual(r.ret[5],i);assert.strictEqual(r.claimRet[4],i);
 const added=env.ekle(d,r.rewards),ntf=env.kazancPaketi(d,added);
 assert.strictEqual(ntf.readUInt32BE(4),h.COIN);assert.strictEqual(ntf.readUInt16BE(12),before+(i+1)*10);
 assert(!h.canFight(d,p));assert(!h.claim(d,p).rewards.length);
}
const decoder=new packet.O(h.initPacket(d));assert.strictEqual(decoder.u32(),0);
for(let i=0;i<4;i++)decoder.i32();assert.strictEqual(decoder.u16(),15);
for(let index=0;index<15;index++){
 assert.strictEqual(decoder.u8(),index);decoder.u32();decoder.u32();assert.strictEqual(decoder.i32(),3);decoder.i32();decoder.i32();decoder.utf();decoder.utf();for(let i=0;i<4;i++)decoder.i32();
 const n=decoder.u16();for(let i=0;i<n;i++){decoder.i32();decoder.i32();decoder.i32();decoder.u8();decoder.u8();decoder.i32();decoder.i32();decoder.i32();}
}
const players=decoder.u16();for(let i=0;i<players;i++){decoder.u32();decoder.u8();}
const reports=decoder.u16();assert.strictEqual(reports,15);for(let i=0;i<reports;i++){decoder.i32();decoder.u8();decoder.u8();decoder.utf();decoder.utf();decoder.utf();}assert.strictEqual(decoder.kalan(),0);
const losing={};assert(!h.battle(losing,Buffer.from([0]),()=>simulate(false)).rewards.length);
assert.strictEqual(h.state(losing).relive,1);assert.strictEqual(h.state(losing).hp['11100001'],100);
h.state(losing).relive=100;h.battle(losing,Buffer.from([0]),()=>simulate(false));assert(!h.canFight(losing,Buffer.from([0])));
const pushes=[],handlers=h.kur({ekSonra:(...args)=>pushes.push(args),paraHarca:()=>Buffer.from([1]),odulVer:(d,r)=>env.ekle(d,r)}),ctx={durum:d,kaydet:()=>{}};
assert.strictEqual(handlers['0x01817602'](ctx).readUInt32BE(0),0);assert.strictEqual(handlers['0x01817602'](ctx).readUInt32BE(0),0);assert.strictEqual(handlers['0x01817602'](ctx).readUInt32BE(0),1);
assert.strictEqual(handlers['0x01817608'](ctx).readUInt32BE(0),0);
const request=(op,id)=>{const payload=Buffer.alloc(id===undefined?4:8);payload.writeUInt32BE(2);if(id!==undefined)payload.writeUInt32BE(id,4);return handlers[op]({...ctx,payload});};
const shop=request('0x01817a00');assert.strictEqual(shop.readUInt32BE(4),2);assert.strictEqual(shop.readUInt32BE(16),env.mevcut(d,h.COIN));assert(shop.readUInt16BE(20)>0);
const id=shop.readUInt32BE(22),row=packet.satir('BlackMarket',id);env.ekle(d,[{code:h.COIN,amount:1000}]);const coins=env.mevcut(d,h.COIN),items=env.mevcut(d,row.itemID);
assert.strictEqual(request('0x01817a02',id).readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,h.COIN),coins-JSON.parse(row.price).amount);assert.strictEqual(env.mevcut(d,row.itemID),items+Number(row.number));assert.strictEqual(request('0x01817a02',id).readUInt32BE(0),1);
assert.strictEqual(request('0x01817a02',0xffffffff).readUInt32BE(0),1);assert.strictEqual(request('0x01817a01').readUInt32BE(0),0);
const reload=JSON.parse(JSON.stringify(d));assert.strictEqual(h.state(reload).reset,2);reload.gunlukSayac.gun='2000-01-01';assert.strictEqual(h.state(reload).reset,0);assert.strictEqual(env.mevcut(reload,h.COIN),env.mevcut(d,h.COIN));
// Real combat must use this point's persisted opponent, and produce a complete Flash report.
const real=local('./hueco-mundo'),savas=local('./savas'),kodek=local('./kodek');
const actual=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));delete actual.gunlukSayac;
const point=real.state(actual).points[0];
const battle=real.battle(actual,Buffer.from([0]),(bot,options)=>savas.kadroRapor(0,bot,null,options));
assert(battle.report);const decoded=kodek.decodeBattleReport(battle.report);assert.strictEqual(decoded._consumed,decoded._total);
assert.deepStrictEqual(decoded.player2.roles.map(r=>r.roleId),point.opponent.heroes);
assert.strictEqual(battle.ret[5],0);assert.strictEqual(battle.rewards.length,battle.won?1:0);
for(const f of fs.readdirSync(root).filter(f=>f.endsWith('.js')))new vm.Script(fs.readFileSync(path.join(root,f),'utf8'),{filename:f});
console.log('PASS: progression for all 15 points, protocol parser, rewards, duplicate/invalid requests, reload/day rollover, loss/revive, VIP reset limits, exchange, actual combat opponent IDs and all backend syntax.');
