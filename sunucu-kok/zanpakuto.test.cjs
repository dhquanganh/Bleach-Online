'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'zanpakuto-')),previous=process.env.BLEACH_ACCOUNT_DIR;process.env.BLEACH_ACCOUNT_DIR=dir;
const hero=11100005,account={level:80,altin:100000,gumus:0,kupon:0,generalsSoul:100000,herolar:[],tumKarakterler:false};
const accountFile=path.join(dir,'veri.json'),stateFile=path.join(dir,'oyuncu.json');fs.writeFileSync(accountFile,JSON.stringify(account));fs.writeFileSync(stateFile,'{}');
const z=require('./sunucu/zanpakuto'),p=require('./sunucu/paket'),env=require('./sunucu/envanter'),gear=require('./sunucu/ekipman'),stats=require('./sunucu/statlar');stats.anaIdAyarla(hero);
const handlers=require('./sunucu/handlers');
after(()=>{if(previous===undefined)delete process.env.BLEACH_ACCOUNT_DIR;else process.env.BLEACH_ACCOUNT_DIR=previous;assert.equal(path.dirname(path.resolve(dir)),path.resolve(os.tmpdir()));fs.rmSync(dir,{recursive:true,force:true});});
const state=()=>({nick:'Blade Test',karakter:{anaId:hero,nick:'Blade Test'},kadro:{[hero]:8},knifeSoul:{id:18100080,exp:0},envanter:{esyalar:[],dusulen:{}},ekipman:{goc:1,esyalar:{},takili:{[hero]:{}}}});
const reset=()=>{fs.writeFileSync(accountFile,JSON.stringify(account));handlers.ekAl();};
function invoke(d,op,w,fail=false){handlers.ekAl();return handlers.byReq['0x'+op.toString(16).padStart(8,'0')]({durum:d,payload:w?w.done():Buffer.alloc(0),kaydet:next=>{if(fail)throw Error('write failure');fs.writeFileSync(stateFile,JSON.stringify(next));}});}
const ok=r=>assert.equal(r.readUInt32BE(0),0),bad=r=>assert.notEqual(r.readUInt32BE(0),0);
function own(d,id){const base=z.baseOf(id),knife=p.satir('Knife',base.relationID);env.ekle(d,[{type:1,code:knife.handBookID,amount:1}]);ok(invoke(d,0x01814102,new p.Y().u32(base._id)));}
function value(packet,index,pvp=false){const offset=pvp?6+2+packet.readUInt16BE(4)*4:6;return stats.TIP[index]?packet.readFloatBE(offset+4*index):packet.readUInt32BE(offset+4*index);}
test('fresh accounts own no swords; unlock consumes the correct handbook once and rejects forged IDs',()=>{
 reset();const d=state(),empty=z.info(d);assert.equal(empty.length,4);assert.equal(empty.readUInt16BE(),0);bad(invoke(d,0x01814102,new p.Y().u32(2000209)));bad(invoke(d,0x01814102,new p.Y().u32(1000024)));
 own(d,2000209);assert.equal(env.mevcut(d,p.satir('Knife',1000024).handBookID),0);bad(invoke(d,0x01814102,new p.Y().u32(2000209)));assert.equal(Object.keys(z.state(d)).length,1);assert.equal(z.info(d).readUInt16BE(),1);
});
test('normal and gold training charge actual currencies, carry EXP, update selected stage and reject stale requests',()=>{
 reset();const d=state();own(d,2000001);ok(invoke(d,0x01814104,new p.Y().u8(1).u32(2000001)));const before=JSON.parse(fs.readFileSync(accountFile));
 ok(invoke(d,0x01814103,new p.Y().u8(1).u32(50).u32(2000001)));let a=JSON.parse(fs.readFileSync(accountFile));assert.equal(a.generalsSoul,before.generalsSoul-110*50);assert.equal(d.zanpakuto[2000001].exp,500);
 ok(invoke(d,0x01814103,new p.Y().u8(2).u32(50).u32(2000001)));a=JSON.parse(fs.readFileSync(accountFile));assert.equal(a.altin,before.altin-500);assert.equal(d.zanpakuto[2000001].id,2000002);assert.equal(d.bicak.sekil,2000002);assert.equal(d.zanpakuto[2000001].exp,200);
 const unchanged=JSON.stringify(d);bad(invoke(d,0x01814103,new p.Y().u8(1).u32(1).u32(2000001)));bad(invoke(d,0x01814103,new p.Y().u8(3).u32(50).u32(2000002)));bad(invoke(d,0x01814103,new p.Y().u8(1).u32(0).u32(2000002)));assert.equal(JSON.stringify(d),unchanged);
});
test('unlock and training follow native Reiatsu requirements; missing funds or failed saves grant nothing',()=>{
 reset();const d=state();d.knifeSoul.id=18100001;const base=z.baseOf(2000205),book=p.satir('Knife',base.relationID).handBookID;env.ekle(d,[{type:1,code:book,amount:1}]);bad(invoke(d,0x01814102,new p.Y().u32(base._id)));assert.equal(env.mevcut(d,book),1);
 d.knifeSoul.id=18100010;ok(invoke(d,0x01814102,new p.Y().u32(base._id)));bad(invoke(d,0x01814103,new p.Y().u8(1).u32(1).u32(base._id)));d.knifeSoul.id=18100080;
 let a={...account,altin:0,generalsSoul:0};fs.writeFileSync(accountFile,JSON.stringify(a));const unchanged=JSON.stringify(d);bad(invoke(d,0x01814103,new p.Y().u8(2).u32(1).u32(base._id)));bad(invoke(d,0x01814103,new p.Y().u8(1).u32(1).u32(base._id)));assert.equal(JSON.stringify(d),unchanged);
 reset();const before=JSON.parse(fs.readFileSync(accountFile));bad(invoke(d,0x01814103,new p.Y().u8(2).u32(1).u32(base._id),true));assert.deepEqual(JSON.parse(fs.readFileSync(accountFile)),before,'gold, spending crystals and ledgers roll back together');assert.equal(JSON.stringify(d),unchanged);
});
test('fortify consumes catalog fossils and enforces level, current cost, attribute range, node balance and persistence',()=>{
 reset();const d=state();own(d,2000001);env.ekle(d,[{type:1,code:14100592,amount:1000}]);let before=env.mevcut(d,14100592);
 ok(invoke(d,0x01814105,new p.Y().u32(2000001).i32(0).i32(3)));assert.equal(env.mevcut(d,14100592),before-3);assert.equal(d.zanpakuto[2000001].strength[0],2);assert.deepEqual(z.state(JSON.parse(fs.readFileSync(stateFile))),z.state(d));
 bad(invoke(d,0x01814105,new p.Y().u32(2000001).i32(0).i32(3)));bad(invoke(d,0x01814105,new p.Y().u32(2000001).i32(-1).i32(5)));
 d.zanpakuto[2000001].strength=[10,9,10];before=env.mevcut(d,14100592);bad(invoke(d,0x01814105,new p.Y().u32(2000001).i32(0).i32(21)));assert.equal(env.mevcut(d,14100592),before);
 d.zanpakuto[2000001].strength=[10,10,10];ok(invoke(d,0x01814105,new p.Y().u32(2000001).i32(0).i32(21)));
 fs.writeFileSync(accountFile,JSON.stringify({...account,level:44}));bad(invoke(d,0x01814105,new p.Y().u32(2000001).i32(1).i32(21)));
});
test('materialization and fortify change shared displayed and real combat stats, cancellation removes only materialization',()=>{
 reset();const d=state(),base=gear.statPaketi(d,hero,80);own(d,2000209);const unlocked=gear.statPaketi(d,hero,80);assert.equal(value(unlocked,7),value(base,7),'Fortify does not increase PvE stats');assert.ok(value(unlocked,7,true)>value(base,7,true),'Fortify increases the separate PvP block');
 ok(invoke(d,0x01814104,new p.Y().u8(1).u32(2000209)));const active=gear.statPaketi(d,hero,80);assert.ok(value(active,4)>value(unlocked,4));const team=require('./sunucu/savas').playerTeam({playerState:d});const main=team.find(u=>u.id===hero);assert.equal(main.atk,value(active,6));assert.equal(main.maxHp,value(active,5));assert.equal(main.speed,value(active,4));assert.equal(main.zanpakutoId,2000209);
 ok(invoke(d,0x01814104,new p.Y().u8(0).u32(2000209)));assert.ok(gear.statPaketi(d,hero,80).equals(unlocked));bad(invoke(d,0x01814104,new p.Y().u8(1).u32(2000001)));
});
test('canonical info keeps legacy training and purchased blades without unlocking unrelated swords',()=>{
 const d={zanpakuto:{2000206:{id:2000206,exp:15}},bicak:{acik:[1000001],sekil:2000206,guc:{2000001:[3,2,1]}}};const owned=z.state(d);assert.deepEqual(Object.keys(owned).sort(),['2000001','2000205']);assert.equal(owned[2000205].id,2000206);assert.equal(d.bicak.sekil,2000206);assert.deepEqual(owned[2000001].strength,[4,3,2]);const r=new p.O(z.info(d)),n=r.u16();assert.equal(n,2);for(let i=0;i<n;i++){r.u32();r.u32();}assert.equal(r.u16(),2);for(let i=0;i<16;i++)r.i32();assert.equal(r.kalan(),0);
});
test('96 native sword forms have working schedules, targets and scaling; damage reports include the selected sword',()=>{
 reset();const combat=require('./sunucu/savas'),zc=require('./sunucu/zanpakuto-combat'),engine=require('./sunucu/hero-skills');assert.equal(zc.rules.size,96);for(const r of zc.rules.values()){assert.ok(r.turns.length);assert.ok(r.multiplier>0);}
 const d=state();own(d,2000209);ok(invoke(d,0x01814104,new p.Y().u8(1).u32(2000209)));const team=combat.playerTeam({playerState:d}),enemy={...team[0],id:13000003,pos:6,camp:1,hp:1000000,maxHp:1000000,atk:1,def:0,zanpakutoId:0,skill:0,skillBuffs:[]};
 const result=combat.kadroRapor(0,null,{ad:'Blade target',birimler:[enemy]},{playerState:d,scaleEnemy:false,forceWin:false,battleDataVersion:4,random:()=>.5});const decoded=require('./sunucu/kodek').decodeBattleReport(result.payload);assert.equal(decoded.player1.knifeOfKillSoulID,2000209);const strikes=decoded.turns.flatMap(t=>t.actives.filter(a=>a.activePos===100).map(a=>({turn:t.curTurn,a})));assert.ok(strikes.length);assert.ok(strikes.every(s=>[1,3,5].includes(s.turn)));assert.ok(strikes.some(s=>s.a.skillEffectId===13310093));assert.ok(strikes.some(s=>s.a.targets.some(t=>t.result.hurtHp>0)));
 const units=[{id:1,camp:0,pos:6,hp:1000,maxHp:1000,atk:100,skillBuffs:[]}];engine.apply({sourceId:1,effects:[{kind:'buff',scope:'a',field:'invincible',value:1,turns:2,unclearable:true}]},units[0],units,[],[],[]);engine.remove(units[0],false,[]);assert.equal(engine.status(units[0],'invincible'),true);
});

test('Fortify node passives apply to their named hero and scale with actual lost HP',()=>{
 reset();const d=state();own(d,2000001);d.zanpakuto[2000001].strength=[10,10,10];const skills=require('./sunucu/partner-skills'),engine=require('./sunucu/hero-skills');const ids=skills.unlocked(d,11100102,{pvp:true});assert.ok(ids.includes(14100001));assert.ok(!skills.unlocked(d,11100005,{pvp:true}).includes(14100001));
 const unit={id:11100102,camp:0,pos:1,hp:500,maxHp:1000,atk:100,skillBuffs:[],partnerSkills:ids},records=[];skills.trigger('start',unit,[unit],[],[],records);assert.equal(engine.value(unit,'atk'),125);unit.hp=1000;assert.equal(engine.value(unit,'atk'),100);
});
test('login patches sword and Reiatsu after the variable-length guide string without corrupting initialization',()=>{
 const raw=fs.readFileSync(path.join(__dirname,'sunucu/cevaplar/0x01180102.bin')),end=require('./sunucu/harita').basicEnd;let offset=end(raw)+2;for(let i=0;i<raw.readUInt16BE(end(raw));i++)offset=require('./sunucu/herolar').girisSonu(raw,offset);const soulOffset=offset+2+raw.readUInt16BE(offset);
 const d=state();d.zanpakuto={2000209:{id:2000209,exp:0}};d.bicak={sekil:2000209};const patched=z.charPatch(raw,d,end);assert.ok(patched.subarray(0,soulOffset).equals(raw.subarray(0,soulOffset)));assert.equal(patched.readUInt32BE(soulOffset),18100080);assert.equal(patched.readUInt32BE(soulOffset+4),2000209);assert.ok(patched.subarray(soulOffset+8).equals(raw.subarray(soulOffset+8)));
});
test('Fortify changes PvP only, including teams received from other workers',()=>{
 reset();const d=state(),combat=require('./sunucu/savas');own(d,2000209);const packet=gear.statPaketi(d,hero,80),base=combat.playerTeam({playerState:d}),pvp=combat.playerTeam({playerState:d,pvp:true});assert.equal(base[0].magicAtk,value(packet,7));assert.equal(pvp[0].magicAtk,value(packet,7,true));assert.ok(pvp[0].magicAtk>base[0].magicAtk);
 const enemy={...base[0],id:13000003,camp:1,hp:100000,maxHp:100000,atk:1,skill:0,zanpakutoId:0,pvpStats:null};const snapshot=JSON.parse(JSON.stringify(base));const result=combat.kadroRapor(0,null,{ad:'PvP target',birimler:[enemy]},{playerState:d,playerUnits:snapshot,pvp:true,scaleEnemy:false,battleDataVersion:4,random:()=>.5});const decoded=require('./sunucu/kodek').decodeBattleReport(result.payload);assert.equal(decoded.player1.roles[0].totalHealth,value(packet,5,true));
});
test('Cross Server sword purchases send only owned swords and reject duplicate relation IDs',()=>{
 reset();fs.writeFileSync(accountFile,JSON.stringify({...account,level:159}));const row=p.tablo('Mall').liste.find(r=>[12,13].includes(Number(r.model))&&p.satir('KnifeExpand',r.itemID)&&JSON.parse(r.honour).amount<=32767);assert.ok(row);const price=JSON.parse(row.honour),d=state(),packets=[];env.ekle(d,[{type:1,code:price.code,amount:price.amount}]);const request=new p.Y().u32(row._id).u16(1).done(),cross=require('./sunucu/cross-server').kur({ekSonra:(id,payload)=>packets.push({id,payload})});const ctx={durum:d,payload:request,kaydet:next=>fs.writeFileSync(stateFile,JSON.stringify(next))};ok(cross.exchange(ctx,row,1));assert.equal(Object.keys(z.state(d)).length,1);assert.equal(env.mevcut(d,price.code),0);const info=packets.find(r=>r.id===0x01184101);assert.ok(info);assert.equal(info.payload.readUInt16BE(0),1);bad(cross.exchange(ctx,row,1));
});
test('compiled Fortify success decoder accepts the backend layout and an absent optional power callback',()=>{
 const source=fs.readFileSync(path.join(__dirname,'cikarim/zanpakuto-audit/verify/scripts/Processors/Game/Lobby/KnifeOfKillSoul/TProcessorKnifeOfKillSoul.as'),'utf8');const start=source.indexOf('function PerformPacket_SC_KnifeStrengRet('),brace=source.indexOf('{',start);let depth=1,end=brace+1;while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}const method=require('node:vm').runInNewContext('('+source.slice(start,end).replace(/:\s*[\w.]+/g,'')+')',{uint:v=>Number(v)>>>0,int:v=>Number(v)|0,EffectGenerateText(){},TUtilityLobby:{GetStringByIdentifier(){}},CONST_SYSTEMLANGUAGE:{KnifeOfKillSoul_STRING_38:1}});
 const reader=new p.O(new p.Y().u32(0).i32(2000209).i32(0).i32(2).i32(0).done());let values,updates=0;method.call({FUpdateHeroPower:null,UpdateStrengthenAttribute(...args){values=args;},UpdateStrengthenAdvance(){},FWindowKnifeOfkillSoul:{StrengthenUpdate(){updates++;}}},{Data:{readUnsignedInt:()=>reader.u32(),readInt:()=>reader.i32()}});assert.deepEqual(Array.from(values),[2000209,0,2,0]);assert.equal(updates,1);assert.equal(reader.kalan(),0);
});
