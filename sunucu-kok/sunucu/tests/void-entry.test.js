'use strict';
const fs=require('fs'),path=require('path'),assert=require('assert');
const root=path.resolve(__dirname,'..'),event=require(path.join(root,'savas-etkinlik')),levels=require(path.join(root,'seviye')),battle=require(path.join(root,'savas')),codec=require(path.join(root,'kodek'));
const d=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
const main=levels.anaId();d.kadro={[main]:6,11120920:7,11120950:11};delete d.bosDunya;
const form=event.voidForm(d,main);
assert(form.some(h=>h.battlePos===7));assert(form.some(h=>h.battlePos===11));assert(form.some(h=>h.heroId===main));
assert(new Set(form.map(h=>h.battlePos)).size===form.length);assert(form.every((h,i)=>h.pos===i+1&&h.pos<=7));
const seven={...d,kadro:{[main]:1,11120920:2,11120950:3,11120960:4,11120970:5,11120980:6,11120990:7,11120991:8}};
const sevenForm=event.voidForm(seven,main);assert.equal(sevenForm.length,7);assert(sevenForm.some(h=>h.heroId===main));assert.equal(new Set(sevenForm.map(h=>h.battlePos)).size,7);
// Initialize the real event and submit the normalized snapshot without touching disk.
const H=event.kur({seviye:levels,ekSonra:()=>{},paraHarca:()=>Buffer.alloc(1),odulVer:()=>{},olay:{say:()=>{}},awardOf:()=>[]});
H['0x01818b00']({durum:d,kaydet:()=>{}});H['0x01818b01']({durum:d,kaydet:()=>{}});
const stored=d.bosDunya.form.map(h=>({...h}));
const ret=event.voidFightEnter(d,Buffer.from([0]),main);assert.strictEqual(ret.readUInt32BE(0),0);
assert.strictEqual(event.voidFightEnter(d,Buffer.from([0]),main).readUInt32BE(0),1);
const frames=battle.voidFightFrames(d),report=codec.decodeBattleReport(frames[0].payload);
assert.strictEqual(report._consumed,report._total);
for(const h of stored){const role=report.player1.roles.find(r=>r.roleId===h.heroId);assert(role,'missing submitted hero');assert.strictEqual(role.pos,h.battlePos);assert(role.totalHealth>0);}
assert.strictEqual(report.player2.roles.length,1);assert.strictEqual(report.player2.roles[0].roleId,event.voidBossEnemyId());assert(report.player2.roles[0].totalHealth>0);
const damage=event.voidDamageFromStatistics(battle.sonIstatistik());assert(Number.isFinite(damage)&&damage>=0);
const hp=d.bosDunya.hp,dead=event.voidFinishFight(d,d.roleIdHi,d.roleIdLo,damage);assert(dead);assert.strictEqual(d.bosDunya.hp,hp-Number(dead.readBigInt64BE(8)));
assert.strictEqual(d.bosDunya.players.length,0);
for(const input of [Buffer.alloc(0),Buffer.from([4]),Buffer.from([0,1])])assert.strictEqual(event.voidFightEnter(d,input,main).readUInt32BE(0),1);
d.bosDunya.hp=0;assert.strictEqual(event.voidFightEnter(d,Buffer.from([0]),main).readUInt32BE(0),1);
console.log('PASS: full formation including lanes 7/11 and main hero, submitted combat snapshot, fight entry/rejection, real Ulquiorra report, damage and HP resolution. No player files changed.');
