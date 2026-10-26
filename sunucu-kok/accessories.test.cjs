'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'accessory-stats-')),previous=process.env.BLEACH_ACCOUNT_DIR;process.env.BLEACH_ACCOUNT_DIR=dir;
const hero=11100005;fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify({level:80,herolar:[],tumKarakterler:false}));fs.writeFileSync(path.join(dir,'oyuncu.json'),'{}');
const gear=require('./sunucu/ekipman'),stats=require('./sunucu/statlar'),p=require('./sunucu/paket');stats.anaIdAyarla(hero);
after(()=>{if(previous===undefined)delete process.env.BLEACH_ACCOUNT_DIR;else process.env.BLEACH_ACCOUNT_DIR=previous;assert.ok(path.resolve(dir).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(dir,{recursive:true,force:true});});
const state=()=>({nick:'Accessory Test',karakter:{anaId:hero,nick:'Accessory Test'},kadro:{[hero]:6},ekipman:{goc:1,esyalar:{},takili:{[hero]:{}}}});
function equip(d,tpl,lvl=0){const inst=gear.yeniEsya(gear.depo(d),tpl);d.ekipman.esyalar[inst].lvl=lvl;d.ekipman.takili[hero][p.satir('Article',tpl).minorType]=inst;return inst;}
function value(packet,index,block=0){let offset=4;for(let b=0;b<block;b++)offset+=2+packet.readUInt16BE(offset)*4;return stats.TIP[index]?packet.readFloatBE(offset+2+4*index):packet.readUInt32BE(offset+2+4*index);}
test('each accessory primary increases its own real combat fields and both PvE/PvP packets',()=>{
 for(const [tpl,primary,derived,unaffected]of [[15850001,0,[6,8],[7,9]],[15850002,1,[7,9],[6,8]],[15850003,2,[4],[6,7]],[15850004,3,[5],[6,7]]]){
  const d=state(),before=gear.statPaketi(d,hero,80);equip(d,tpl);const actual=gear.statPaketi(d,hero,80);
  for(let block=0;block<2;block++){assert.equal(value(actual,primary,block)-value(before,primary,block),primary===3?600:170);for(const index of derived)assert.ok(value(actual,index,block)>value(before,index,block),tpl+' must improve '+index);for(const index of unaffected)assert.equal(value(actual,index,block),value(before,index,block));}
 }
});
test('Rock Bracelets +600 Stamina and level-one +54 match the stat update, persisted instance and battle HP',()=>{
 const d=state(),base=gear.statPaketi(d,hero,80),inst=equip(d,15850004),worn=gear.statPaketi(d,hero,80);assert.equal(value(worn,3)-value(base,3),600);
 const env=require('./sunucu/envanter');env.ekle(d,[{code:14860001,amount:1}]);const updates=[],handlers=gear.kur({ekSonra:(id,payload)=>updates.push({id,payload}),ekOnce(){},paraHarca:()=>assert.fail('wrong currency'),seviye:require('./sunucu/seviye'),olay:require('./sunucu/olay')});
 const payload=new p.Y().u32(hero).u32(17).done(),ret=handlers['0x01816400']({payload,durum:d,kaydet:next=>fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(next))});assert.equal(ret.readUInt32BE(),0);assert.equal(d.ekipman.esyalar[inst].lvl,1);
 const upgraded=gear.statPaketi(d,hero,80);assert.equal(value(upgraded,3)-value(base,3),654);assert.ok(value(upgraded,5)>value(worn,5));assert.ok(updates.some(u=>u.id===0x01180104&&u.payload.equals(upgraded)));
 const reload=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json'),'utf8'));assert.ok(gear.statPaketi(reload,hero,80).equals(upgraded));
 const combat=require('./sunucu/savas'),team=combat.playerTeam({playerState:reload}),main=team.find(u=>u.id===hero);assert.equal(main.maxHp,value(upgraded,5));assert.equal(main.atk,value(upgraded,6));assert.equal(main.magicAtk,value(upgraded,7));assert.equal(main.def,value(upgraded,8));assert.equal(main.resistance,value(upgraded,9));
 const report=combat.kadroRapor(0,null,{ad:'Target',birimler:[{...main,id:13000003,camp:1,hp:1,maxHp:1}]},{playerState:reload,scaleEnemy:false,forceWin:false,battleDataVersion:4});const role=require('./sunucu/kodek').decodeBattleReport(report.payload).player1.roles.find(r=>r.roleId===hero);assert.equal(role.totalHealth,value(upgraded,5));
});
test('accessories in the bag or on another hero add nothing; two matching pieces add 5% Fury resistance once',()=>{
 const d=state(),base=gear.statPaketi(d,hero,80);gear.yeniEsya(gear.depo(d),15850004);assert.ok(gear.statPaketi(d,hero,80).equals(base));
 const bracelet=equip(d,15850004);const one=gear.statPaketi(d,hero,80);assert.equal(value(one,25),value(base,25));equip(d,15850008);const two=gear.statPaketi(d,hero,80);assert.ok(Math.abs(value(two,25)-value(base,25)-.05)<1e-6);assert.equal(value(two,3)-value(base,3),1200);
 assert.ok(gear.statPaketi(d,11130001,80).equals(gear.statPaketi(state(),11130001,80)));
 delete d.ekipman.takili[hero][17];assert.equal(value(gear.statPaketi(d,hero,80),25),value(base,25));assert.equal(d.ekipman.esyalar[bracelet].tpl,15850004);
});
test('physical stats stay independent from higher magic stats in the shared decoder',()=>{
 const block=new p.Y().u16(27);for(let i=0;i<27;i++)stats.TIP[i]?block.f32(0):block.u32(({5:1000,6:100,7:900,8:50,9:700})[i]||0);const decoded=stats.blokOku(block.done());assert.equal(decoded.atk,100);assert.equal(decoded.magicAtk,900);assert.equal(decoded.def,50);assert.equal(decoded.resistance,700);
});
test('compiled native tooltip upgrade values agree with backend totals at multiple grades',()=>{
 const source=fs.readFileSync(path.join(__dirname,'cikarim/accessories-audit/verify/scripts/Logics/Streamization/Inventories/TUnstreamizerEquipment.as'),'utf8');
 const ornament=source.slice(source.indexOf('case CATEGORY_Ornament:')),match=ornament.match(/\.UpgradingBasisProperty\.push\((.+)\);/);assert.ok(match);
 const evaluate=require('node:vm');
 for(const tpl of [15850001,15850002,15850003,15850004])for(const grade of [1,10,50,100]){
  const base=p.satir('BaseEquip',tpl),type=JSON.parse(base.mainAdditionalType)[0],amount=JSON.parse(base.maxAdditionalCount)[0],upgrade=p.tablo('OrnamentValue').liste.find(r=>r.level===tpl+':'+grade);assert.ok(upgrade);
  const native=evaluate.runInNewContext(match[1],{_loc25_:{AddValue:Number(upgrade.f3)},_loc21_:{BasisPropertyCategory:[type]}}),d=state(),before=gear.statPaketi(d,hero,80);equip(d,tpl,grade);const after=gear.statPaketi(d,hero,80),index=({1:0,3:1,2:2,4:3})[type];
  assert.equal(value(after,index)-value(before,index),amount+native,tpl+' grade '+grade+' tooltip must agree with server');
 }
});
test('Fury set bonuses resist hostile reduction, offensive Fury offsets resistance, but skill costs are always paid',()=>{
 const engine=require('./sunucu/hero-skills'),unit=()=>({id:hero,camp:0,pos:6,hp:1000,maxHp:1000,anger:100,furyResist:.05,skillBuffs:[]});let u=unit();engine.changeFury(u,-20,[],false,()=>.01);assert.equal(u.anger,100);engine.changeFury(u,-20,[],false,()=>.01,{furyEffect:.05});assert.equal(u.anger,80);
 u=unit();engine.changeFury(u,-100,[],true,()=>0);assert.equal(u.anger,0);
 const battle=require('./sunucu/savas'),caster=battle.heroBirim(11130001,6,80,null,{hp:100000,atk:100,magicAtk:100,def:10,resistance:10,anger:100,speed:100,hitRate:1,critRate:0,furyResist:1},1),enemy={...caster,id:13000003,camp:1,pos:6,hp:100000,skillBuffs:[],partnerSkills:[],weaponSkills:[]};caster.skillBuffs=[];caster.partnerSkills=[];caster.weaponSkills=[];
 const act=battle.vurus(caster,enemy,false,[enemy],()=>0,false,[caster]);assert.ok([act,...act.reactions].flatMap(a=>a.targets).some(t=>t.targetCamp===0&&t.result.hurtAnger===100),'a 100% resistance must not provide free Mystery casts');
});
