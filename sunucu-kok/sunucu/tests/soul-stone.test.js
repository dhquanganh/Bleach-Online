'use strict';
// Real stone tables, equipment handlers, stat packets and combat; all state stays in memory.
const fs=require('fs'),path=require('path'),assert=require('assert');
const root=path.resolve(__dirname,'..'),gear=require(path.join(root,'ekipman')),env=require(path.join(root,'envanter')),level=require(path.join(root,'seviye')),stats=require(path.join(root,'statlar')),p=require(path.join(root,'paket'));
const source=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
const hero=11150057,inst=source.ekipman.takili[String(hero)]['1'],equipment=source.ekipman.esyalar[String(inst)];assert(equipment);
function fixture(){const d=JSON.parse(JSON.stringify(source));for(const x of Object.values(d.ekipman.esyalar))x.gems=[];level.heroKayit(d,hero,159).lv=159;return d;}
const value=(packet,index,block=0)=>{let offset=4;for(let i=0;i<block;i++)offset+=2+packet.readUInt16BE(offset)*4;return stats.TIP[index]===1?packet.readFloatBE(offset+2+index*4):packet.readUInt32BE(offset+2+index*4);};
const base=gear.statPaketi(fixture(),hero,159);
for(const [stone,primary,derived] of [[14500011,0,[6,8]],[14500111,2,[4]],[14500211,1,[7,9]],[14500311,3,[5]]]){
 const d=fixture();d.ekipman.esyalar[String(inst)].gems=[stone];const embedded=gear.statPaketi(d,hero,159);
 assert(value(embedded,primary)>value(base,primary));
 for(const idx of derived)for(let block=0;block<2;block++)assert(value(embedded,idx,block)>value(base,idx,block),`${stone}: attribute ${idx} did not increase`);
 for(const idx of [10,11,12,20])assert.strictEqual(value(embedded,idx),value(base,idx));
 const reload=gear.statPaketi(JSON.parse(JSON.stringify(d)),hero,159);assert(reload.equals(embedded));
}
const d=fixture(),stone=14500311;env.ekle(d,[{code:stone,amount:1}]);
const beforeQuantity=env.mevcut(d,stone),pushes=[];let saves=0;
const handlers=gear.kur({seviye:level,ekSonra:(...args)=>pushes.push(args),ekOnce:(...args)=>pushes.push(args),paraHarca:()=>Buffer.from([1])});
const embed=new p.Y().u32(hero).u32(1).u32(equipment.tpl).u32(env.instanceOf(stone)).u32(stone).done();
const ctx={durum:d,kaydet:()=>saves++};
const ret=handlers['0x01811101']({...ctx,payload:embed});assert.strictEqual(ret.readUInt32BE(0),0);assert.strictEqual(saves,1);
assert.strictEqual(env.mevcut(d,stone),beforeQuantity-1);assert.deepStrictEqual(d.ekipman.esyalar[String(inst)].gems,[stone]);
const embedded=gear.statPaketi(d,hero,159);assert(value(embedded,5)>value(base,5));
const attr=pushes.find(([id])=>id===0x01180104);assert(attr);assert(attr[1].equals(embedded));
const second=handlers['0x01811101']({...ctx,payload:embed});assert.notStrictEqual(second.readUInt32BE(0),0);assert.strictEqual(saves,1);
// A second equipped Stamina stone stacks once; backpack stones grant no stat bonus.
const stacked=JSON.parse(JSON.stringify(d));stacked.ekipman.esyalar[String(stacked.ekipman.takili[String(hero)]['2'])].gems=[stone];assert(value(gear.statPaketi(stacked,hero,159),5)>value(embedded,5));
const backpack=fixture();env.ekle(backpack,[{code:stone,amount:5}]);assert(gear.statPaketi(backpack,hero,159).equals(base));
const remove=new p.Y().u32(hero).u32(1).u32(equipment.tpl).u8(0).u32(stone).done();
pushes.length=0;assert.strictEqual(handlers['0x01811102']({...ctx,payload:remove}).readUInt32BE(0),0);
assert.strictEqual(env.mevcut(d,stone),beforeQuantity);assert(gear.statPaketi(d,hero,159).equals(base));assert(pushes.some(([id,payload])=>id===0x01180104&&payload.equals(base)));
const invalid=Buffer.from(embed);invalid.writeUInt32BE(equipment.tpl,16);assert.strictEqual(handlers['0x01811101']({...ctx,payload:invalid}).readUInt32BE(0),4);
// Combat reads the exact updated max HP sent to Flash, without applying the gem twice.
const savas=require(path.join(root,'savas')),kodek=require(path.join(root,'kodek'));
d.ekipman.esyalar[String(inst)].gems=[stone];const battle=savas.kadroRapor(0,null,null,{playerState:d,forceWin:false});assert(battle);
const decoded=kodek.decodeBattleReport(battle.payload),role=decoded.player1.roles.find(r=>r.roleId===hero);assert(role);assert.strictEqual(role.totalHealth,value(embedded,5));assert.strictEqual(role.curHealth,value(embedded,5));
console.log('PASS: real level-11 primary stones, PvE/PvP stats, stacking, immediate embed/remove packets, reload, consumption/refund, invalid gems and matching combat HP. Player files unchanged.');
