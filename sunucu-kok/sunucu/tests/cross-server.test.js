'use strict';
const assert=require('node:assert/strict');
const fs=require('node:fs'),path=require('node:path');
const {Y,O}=require('../paket'),cross=require('../cross-server'),players=require('../cross-server-players'),battle=require('../savas'),codec=require('../kodek');
let tick=1791530000,won=true,lastTeam,lastOwn,saved;
const source=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'),'utf8'));
const d=structuredClone(source);d.nick='Cross Tester';delete d.crossServer;
const packet={ekSonra(){},paraHarca(){return Buffer.alloc(4)},paraIcinOdul(){return Buffer.alloc(4)}};
const engine=cross.kur(packet,{now:()=>tick,simulate:(team,state,own)=>{lastTeam=team;lastOwn=own;return {payload:Buffer.from('battle'),won};}});
const ctx=payload=>({durum:d,payload,kaydet:next=>{saved=structuredClone(next);}});
const call=(op,payload=Buffer.alloc(0))=>engine.handlers['0x01813d'+op](ctx(payload));
players.update([]);
assert.equal(new O(call('05')).u16(),0,'no player accounts means no generated opponents');
const ids=[11120997,11120940,11120995,11120950,11120996],positions=[1,2,6,7,11];
const units=ids.map((id,i)=>({id,pos:positions[i],level:12,hp:999999999,maxHp:999999999,atk:999999999,def:999999999,quality:7}));
players.update([{accountId:'account-alice',name:'Alice',units},{accountId:'account-bob',name:'Bob',units:units.slice(0,3),crossScore:80}]);
assert.equal(players.accounts().length,2);assert.equal(players.all().length,90);
const all=players.all();assert.equal(new Set(all.map(row=>row.id)).size,90);
players.update([{accountId:'account-bob',name:'Bob',units:units.slice(0,3),crossScore:80},{accountId:'account-alice',name:'Alice',units}]);
assert.deepEqual(players.all().map(row=>row.id),all.map(row=>row.id),'opponent IDs stay stable when Arena ranking reorders accounts');
for(const row of all){assert(['Alice','Bob'].includes(row.name));assert.equal(row.level,159);}
const normalized=players.team(all.find(row=>row.name==='Alice').id);
assert.deepEqual(normalized.units.map(u=>u.level),[159,159,159,159,159]);
for(const unit of normalized.units){const base=battle.heroBirim(unit.id,unit.pos,159,null,null,0,true),growth=require('../seviye').buyumeTemeli(unit.id,159);assert.equal(unit.atk,base.atk);assert.equal(unit.def,Math.round(growth.combat*.3));assert.equal(unit.maxHp,base.maxHp);assert(unit.atk<999999999);}
let reader=new O(call('05'));const challengeIds=[];
for(const count of [18,12]){assert.equal(reader.u16(),count);for(let i=0;i<count;i++){const id=reader.u32(),name=reader.utf();assert(['Alice','Bob'].includes(name));reader.utf();reader.u32();const more=reader.u16();for(let j=0;j<more;j++)reader.u32();assert.equal(reader.u32(),159);for(let j=0;j<5;j++)reader.u32();reader.u8();challengeIds.push(id);}}
assert.equal(reader.kalan(),0);assert.equal(new Set(challengeIds).size,30);
const req=(id,mode=0)=>new Y().u8(mode).u32(id).done();const id=d.crossServer.normal[0];
let result=engine.fight(ctx(req(id)));assert(!result.error);assert.equal(lastTeam.id,id);assert.equal(lastTeam.level,159);assert(lastOwn.length);assert(lastOwn.every(u=>u.level===159));assert(lastOwn.every(u=>u.maxHp<999999999));assert.deepEqual(d,saved);
assert.equal(d.crossServer.times,4);assert(d.crossServer.killed[id]);assert.equal(engine.fight(ctx(req(id))).error,1);
tick+=11;won=false;result=engine.fight(ctx(req(d.crossServer.normal[1])));assert(!result.error);assert.equal(d.crossServer.times,3);assert.equal(d.crossServer.history[0].name,lastTeam.name);
const replay=engine.replay(ctx(new Y().utf(d.crossServer.history[0].id).done()));assert(!replay.error);assert.equal(replay.ack[4],2);
assert.equal(call('04').readUInt16BE(0),3,'rank shows two account holders and the player');
assert.equal(call('0a').readUInt32BE(0),0,'refresh chooses real player accounts');
const real=players.team(d.crossServer.normal[2]);const own=players.ownUnits(d);
const report=battle.kadroRapor(0,real,null,{playerState:d,playerUnits:own,crossServerBaseOnly:true,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
const decoded=codec.decodeBattleReport(report.payload);assert(decoded.player1.roles.every(u=>u.level===159));assert(decoded.player2.roles.every(u=>u.level===159));assert.equal(decoded._consumed,decoded._total);
players.update([]);assert.equal(cross.rank(d.crossServer),1);assert.equal(new O(call('05')).u16(),0);
console.log('PASS Cross Server: account-only opponents, real lineups, both camps at level 159 with base stats, no bot fallback, challenge/replay/refresh packets.');
