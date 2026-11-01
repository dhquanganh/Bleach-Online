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
assert.strictEqual(shop.readUInt32BE(22),h.FORTUNE_OFFER);
const id=shop.readUInt32BE(30),row=packet.satir('BlackMarket',id);env.ekle(d,[{code:h.COIN,amount:1000}]);const coins=env.mevcut(d,h.COIN),items=env.mevcut(d,row.itemID);
assert.strictEqual(request('0x01817a02',id).readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,h.COIN),coins-JSON.parse(row.price).amount);assert.strictEqual(env.mevcut(d,row.itemID),items+Number(row.number));assert.strictEqual(request('0x01817a02',id).readUInt32BE(0),1);
assert.strictEqual(request('0x01817a02',0xffffffff).readUInt32BE(0),1);
// Fortune Coins stay in saved/random shops and exchange at exactly 10:1.
const fortune=packet.satir('BlackMarket',h.FORTUNE_OFFER);assert.strictEqual(fortune.itemID,14900002);assert.strictEqual(JSON.parse(fortune.price).amount,10);
const balance=env.mevcut(d,h.COIN),fortuneBefore=env.mevcut(d,14900002);
for(let i=0;i<2;i++)assert.strictEqual(request('0x01817a02',h.FORTUNE_OFFER).readUInt32BE(0),0);
assert.strictEqual(env.mevcut(d,h.COIN),balance-20);assert.strictEqual(env.mevcut(d,14900002),fortuneBefore+2);
const refreshed=request('0x01817a01');assert.strictEqual(refreshed.readUInt32BE(0),0);
assert.strictEqual(refreshed.length,22+4*refreshed.readUInt16BE(20),'refresh uses IDs only, unlike init pairs');
assert.strictEqual(refreshed.readUInt32BE(22),h.FORTUNE_OFFER);
// Save errors cannot mutate the caller or send inventory updates before commit.
const stable=JSON.stringify(d),pushCount=pushes.length;
const fortuneRequest=Buffer.alloc(8);fortuneRequest.writeUInt32BE(2);fortuneRequest.writeUInt32BE(h.FORTUNE_OFFER,4);
assert.throws(()=>handlers['0x01817a02']({...ctx,payload:fortuneRequest,kaydet:()=>{throw Error('disk full');}}));
assert.strictEqual(JSON.stringify(d),stable);assert.strictEqual(pushes.length,pushCount);
// Invalid/underfunded/full-stack exchanges leave balance, usage and packets unchanged.
const empty={vipLevel:15};h.shopPacket(empty);const emptySaved=JSON.stringify(empty),emptyPush=pushes.length;
assert.strictEqual(handlers['0x01817a02']({durum:empty,payload:fortuneRequest,kaydet:()=>{throw Error('must not save');}}).readUInt32BE(0),21);
assert.strictEqual(JSON.stringify(empty),emptySaved);assert.strictEqual(pushes.length,emptyPush);
env.ekle(empty,[{code:h.COIN,amount:100},{code:14900002,amount:env.MAX_ADET}]);const fullSaved=JSON.stringify(empty);
assert.strictEqual(handlers['0x01817a02']({durum:empty,payload:fortuneRequest,kaydet:()=>{throw Error('must not save');}}).readUInt32BE(0),1);
assert.strictEqual(JSON.stringify(empty),fullSaved);
for(const op of ['0x01817a00','0x01817a01'])assert.strictEqual(handlers[op]({...ctx,payload:fortuneRequest}).readUInt32BE(0),4);
// Failed refresh emits no coin reduction; successful refresh has a parseable ID-only body.
const refreshRequest=Buffer.from([0,0,0,2]),beforeRefresh=JSON.stringify(d),beforePush=pushes.length;
assert.throws(()=>handlers['0x01817a01']({...ctx,payload:refreshRequest,kaydet:()=>{throw Error('disk full');}}));
assert.strictEqual(JSON.stringify(d),beforeRefresh);assert.strictEqual(pushes.length,beforePush);
const dead={vipLevel:15},deadState=h.state(dead);deadState.hp['11100001']=0;deadState.relive=5;
assert(!h.canFight(dead,Buffer.from([0])));
assert.strictEqual(handlers['0x01817608']({durum:dead,kaydet:()=>{}}).readUInt32BE(0),0);
assert.strictEqual(h.state(dead).hp['11100001'],100);assert.strictEqual(h.state(dead).relive,6);assert(h.canFight(dead,Buffer.from([0])));
const summoned={};h.battle(summoned,Buffer.from([0]),()=>({...simulate(true),remainingHp:simulate(true).remainingHp.concat([{camp:0,id:11120996,rate:1}])}));
assert.strictEqual(h.state(summoned).hp['11120996'],undefined,'summon HP must not become persistent formation members');
const reload=JSON.parse(JSON.stringify(d));assert.strictEqual(h.state(reload).reset,2);reload.gunlukSayac.gun='2000-01-01';assert.strictEqual(h.state(reload).reset,0);assert.strictEqual(env.mevcut(reload,h.COIN),env.mevcut(d,h.COIN));
// Real combat must use this point's persisted opponent, and produce a complete Flash report.
const real=local('./hueco-mundo'),savas=local('./savas'),kodek=local('./kodek');
const actual=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));delete actual.gunlukSayac;
const point=real.state(actual).points[0];
const battle=real.battle(actual,Buffer.from([0]),(bot,options)=>savas.kadroRapor(0,bot,null,options));
assert(battle.report);const decoded=kodek.decodeBattleReport(battle.report);assert.strictEqual(decoded._consumed,decoded._total);
assert.deepStrictEqual(decoded.player2.roles.slice(0,point.opponent.heroes.length).map(r=>r.roleId),point.opponent.heroes);
assert.strictEqual(battle.ret[5],0);assert.strictEqual(battle.rewards.length,battle.won?1:0);
for(const f of fs.readdirSync(root).filter(f=>f.endsWith('.js')))new vm.Script(fs.readFileSync(path.join(root,f),'utf8'),{filename:f});
console.log('PASS: progression for all 15 points, protocol parser, rewards, duplicate/invalid requests, reload/day rollover, loss/revive, VIP reset limits, exchange, actual combat opponent IDs and all backend syntax.');
