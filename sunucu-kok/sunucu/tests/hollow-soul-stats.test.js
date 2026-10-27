"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),{Y,tablo,satir}=require('../paket'),map=require('../hollow-soul-map'),gear=require('../ekipman'),levels=require('../seviye'),codec=require('../kodek');
const hero=levels.anaId(),partner=11150057,points=tablo('SevenHeroLittleStar').liste.filter(p=>Number(p.bigStar)===82200002).sort((a,b)=>a.sort-b.sort);
let d={yildiz:{hero:{},ruh:Array(8).fill(100000)}};let sent=[],updates=[],saved;
const H=map.kur({ekOnce:(id,payload)=>sent.push({id,payload})},{owned:(d,id)=>[hero,partner].includes(id),statPush:(d,id)=>updates.push({id,packet:gear.statPaketi(d,id,153)})});
const ctx=p=>({durum:d,payload:p,kaydet:n=>{saved=JSON.parse(JSON.stringify(n));}}),req=p=>new Y().u32(hero).u32(p._id).done();
assert.equal(map.bonuses(d,hero).size,0);assert.notEqual(H['0x01813902'](ctx(req(points[2]))).readUInt32BE(0),0);assert.equal(d.yildiz.ruh[2],100000);
for(const p of points.slice(0,3)){const before=d.yildiz.ruh[2];sent=[];updates=[];assert.equal(H['0x01813902'](ctx(req(p))).readUInt32BE(0),0);assert.equal(d.yildiz.ruh[2],before-Number(p.costSoul));assert.deepEqual(d,saved);assert(sent.some(p=>p.id===0x01183904));assert(sent.some(p=>p.id===0x01183901));assert.equal(updates[0].id,hero);}
const expected=new Map();for(const p of points.slice(0,3))for(const a of JSON.parse(p.addValue))expected.set(a.addType,(expected.get(a.addType)||0)+a.addValue);
assert.deepEqual(map.bonuses(d,hero),expected);assert.equal(JSON.parse(points[2].addValue).find(a=>a.addType===16).addValue,660);
let snapshot=JSON.stringify(d);assert.notEqual(H['0x01813902'](ctx(req(points[2]))).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);
d.yildiz.ruh[2]=0;snapshot=JSON.stringify(d);assert.notEqual(H['0x01813902'](ctx(req(points[3]))).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);
d.yildiz.ruh[2]=100000;const broken=ctx(req(points[3]));broken.kaydet=()=>{throw Error('disk');};snapshot=JSON.stringify(d);sent=[];updates=[];assert.notEqual(H['0x01813902'](broken).readUInt32BE(0),0);assert.equal(JSON.stringify(d),snapshot);assert.equal(sent.length,0);assert.equal(updates.length,0);
for(const p of points.slice(3))assert.equal(H['0x01813902'](ctx(req(p))).readUInt32BE(0),0);
const total=new Map();for(const p of points)for(const a of JSON.parse(p.addValue))total.set(a.addType,(total.get(a.addType)||0)+a.addValue);for(const a of JSON.parse(satir('SevenHeroStar',82200002).addValue))total.set(a.addType,total.get(a.addType)+a.addValue);assert.deepEqual(map.bonuses(d,hero),total);
// Real authoritative PvE/PvP packets and combat HP include activated points.
const fixture=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json'),'utf8'));fixture.yenidenDogus={hero:{}};fixture.heroStars={};fixture.meslekAritma=[0,0,0,0];fixture.yildiz={hero:{},ruh:Array(8).fill(0)};
const base=gear.statPaketi(fixture,hero,153);fixture.yildiz.hero[hero]=[0,points[2]._id,0,0,0,0,0];const boosted=gear.statPaketi(fixture,hero,153);
const value=(packet,index,block=0)=>{let p=4;for(let i=0;i<block;i++)p+=2+packet.readUInt16BE(p)*4;return packet.readUInt32BE(p+2+index*4);};
for(const [type,index] of [[16,6],[20,7],[17,8],[21,9],[101,5],[11,4]])for(const block of [0,1])assert.equal(value(boosted,index,block)-value(base,index,block),expected.get(type));
assert(gear.statPaketi(JSON.parse(JSON.stringify(fixture)),hero,153).equals(boosted));const actualLevel=Number(JSON.parse(fs.readFileSync(require('../runtime-path')('veri.json'),'utf8')).level)||99;const actualPacket=gear.statPaketi(fixture,hero,actualLevel);const battle=require('../savas').kadroRapor(0,null,null,{playerState:fixture,forceWin:false,scaleEnemy:false});const parsed=codec.decodeBattleReport(battle.payload);assert.equal(parsed.player1.roles.find(r=>r.roleId===hero).totalHealth,value(actualPacket,5));
const before=map.bonuses(d,hero);sent=[];updates=[];assert.equal(H['0x01813903'](ctx(new Y().u32(hero).u32(partner).done())).readUInt32BE(0),0);assert.equal(map.bonuses(d,hero).size,0);assert.deepEqual(map.bonuses(d,partner),before);assert.deepEqual(new Set(updates.map(u=>u.id)),new Set([hero,partner]));
console.log('PASS Hollow Soul stats: exact cumulative node bonuses including screenshot +660, completed-branch bonus once, real PvE/PvP and combat HP, sequential activation, exact souls, duplicate/skip/insufficient checks, save rollback, immediate notifications, persistence and inheritance on both heroes. No player files changed.');
