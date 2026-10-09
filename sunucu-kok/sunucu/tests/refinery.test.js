'use strict';
const fs=require('fs'),path=require('path'),assert=require('assert');
const root=path.resolve(__dirname,'..'),p=require(path.join(root,'paket')),env=require(path.join(root,'envanter')),gear=require(path.join(root,'ekipman')),level=require(path.join(root,'seviye')),ref=require(path.join(root,'refinery')),stats=require(path.join(root,'statlar'));
const original=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
function fixture(){const d=JSON.parse(JSON.stringify(original));d.meslekAritma=[0,0,0,0];const n=env.mevcut(d,ref.STONE);if(n)env.dus(d,ref.STONE,n);return d;}
let money=1000000,saved=0,pushes=[],failSave=false;
const H=ref.kur({ekOnce:(...x)=>pushes.push(x),ekSonra:(...x)=>pushes.push(x),paraHarca:awards=>{const cost=awards.reduce((n,a)=>n+a.amount,0);if(money<cost)return null;money-=cost;return Buffer.alloc(2);},paraIcinOdul:awards=>{money+=awards.reduce((n,a)=>n+a.amount,0);return Buffer.alloc(2);}});
const call=(op,d,payload)=>H[op]({durum:d,payload,kaydet:()=>{if(failSave)throw Error('save failed');saved++;}}),req=type=>new p.Y().u32(type).done();
const value=(buf,index,block=0)=>{let off=4;for(let i=0;i<block;i++)off+=2+4*buf.readUInt16BE(off);return buf.readUInt32BE(off+2+4*index);};
for(let type=1;type<=4;type++){
 const hero=p.tablo('BaseHero').liste.find(x=>Number(x.profession)===type&&p.satir('RoleModel',x._id))._id;
 const d=fixture();level.heroKayit(d,hero,159).lv=159;env.ekle(d,[{code:ref.STONE,amount:100}]);const before=gear.statPaketi(d,hero,159);
 const ret=call('0x01818d02',d,req(type));assert.strictEqual(ret.readUInt32BE(0),0);assert.strictEqual(ret.readUInt32BE(8),1);assert.strictEqual(env.mevcut(d,ref.STONE),0);
 const after=gear.statPaketi(d,hero,159);
 for(const index of [4,5,6,7,8,9])for(let b=0;b<2;b++)assert.strictEqual(value(after,index,b),value(before,index,b)+Math.round(value(before,index,b)*p.satir('ProfessionRefine',1).hp));
 const other=p.tablo('BaseHero').liste.find(x=>Number(x.profession)!==type&&x.profession>0&&p.satir('RoleModel',x._id))._id;
 const plain=fixture();assert(gear.statPaketi(d,other,159).equals(gear.statPaketi(plain,other,159)));
 assert(pushes.some(([op,packet])=>op===0x01180104&&packet.readUInt32BE(0)===hero));
 assert(gear.statPaketi(JSON.parse(JSON.stringify(d)),hero,159).equals(after));
}
let d=fixture();assert.strictEqual(call('0x01818d02',d,req(0)).readUInt32BE(0),4);assert.strictEqual(call('0x01818d02',d,Buffer.alloc(3)).readUInt32BE(0),4);assert.strictEqual(call('0x01818d02',d,req(1)).readUInt32BE(0),18);assert.strictEqual(ref.state(d)[0],0);
env.ekle(d,[{code:ref.STONE,amount:100}]);failSave=true;assert.strictEqual(call('0x01818d02',d,req(1)).readUInt32BE(0),1);assert.strictEqual(env.mevcut(d,ref.STONE),100);assert.strictEqual(ref.state(d)[0],0);failSave=false;
d.meslekAritma=[100,0,0,0];assert.strictEqual(call('0x01818d02',d,req(1)).readUInt32BE(0),1);assert.strictEqual(env.mevcut(d,ref.STONE),100);
// Breakdown consumes the selected stacks in full, matching the Flash preview.
d=fixture();const gems=[14500001,14500102];for(const id of gems){const n=env.mevcut(d,id);if(n)env.dus(d,id,n);}env.ekle(d,[{code:gems[0],amount:3},{code:gems[1],amount:2}]);
const breakdown=new p.Y().u16(2).u32(env.instanceOf(gems[0])).u32(gems[0]).u32(env.instanceOf(gems[1])).u32(gems[1]).done();
money=0;assert.strictEqual(call('0x01818d01',d,breakdown).readUInt32BE(0),13);assert.strictEqual(env.mevcut(d,gems[0]),3);assert.strictEqual(env.mevcut(d,gems[1]),2);assert.strictEqual(env.mevcut(d,ref.STONE),0);
const duplicate=Buffer.from(breakdown);duplicate.copy(duplicate,10,2,10);assert.strictEqual(call('0x01818d01',d,duplicate).readUInt32BE(0),4);assert.strictEqual(call('0x01818d01',d,breakdown.subarray(0,10)).readUInt32BE(0),4);
money=100000;failSave=true;assert.strictEqual(call('0x01818d01',d,breakdown).readUInt32BE(0),1);assert.strictEqual(money,100000);assert.strictEqual(env.mevcut(d,gems[0]),3);failSave=false;
assert.strictEqual(call('0x01818d01',d,breakdown).readUInt32BE(0),0);assert.strictEqual(money,65000);assert.strictEqual(env.mevcut(d,gems[0]),0);assert.strictEqual(env.mevcut(d,gems[1]),0);assert.strictEqual(env.mevcut(d,ref.STONE),7);
assert.strictEqual(call('0x01818d01',d,breakdown).readUInt32BE(0),4);assert.strictEqual(money,65000);
// Real battle max HP is the same value delivered to Flash after refining.
const savas=require(path.join(root,'savas')),kodek=require(path.join(root,'kodek')),battleState=fixture();battleState.meslekAritma=[1,1,1,1];
const battle=savas.kadroRapor(0,null,null,{playerState:battleState,forceWin:false});assert(battle);const report=kodek.decodeBattleReport(battle.payload);assert.strictEqual(report._consumed,report._total);
for(const role of report.player1.roles){const stat=gear.statPaketi(battleState,role.roleId,level.heroSeviye(battleState,role.roleId));assert.strictEqual(role.totalHealth,value(stat,5));}
// A speed increase can change who acts first, rather than just changing displayed stats.
const slow={camp:0,pos:1,speed:100},fast={camp:1,pos:6,speed:101};
assert.strictEqual(savas.initiative([slow,fast])[0],fast);
slow.speed=102;assert.strictEqual(savas.initiative([slow,fast])[0],slow);
assert.strictEqual(stats.blokOku(gear.statPaketi(battleState,level.anaId(),level.anaDurum().lv).subarray(4)).speed,
 value(gear.statPaketi(battleState,level.anaId(),level.anaDurum().lv),4));
console.log('PASS: four profession bonuses and PvE/PvP packets, exact material costs, max/invalid requests, full-stack breakdown yields/silver, no loss on failure, duplicate records, save rollback, persistence and combat HP. Player files unchanged.');
