'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'alliance-rewards-')),previous=process.env.BLEACH_ACCOUNT_DIR;process.env.BLEACH_ACCOUNT_DIR=dir;
fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify({level:80,herolar:[],tumKarakterler:false}));fs.writeFileSync(path.join(dir,'oyuncu.json'),'{}');
const rules=require('./sunucu/alliance-war'),{satir,tablo,Y,O}=require('./sunucu/paket'),native=require('./sunucu/alliance-war-playback');
after(()=>{if(previous===undefined)delete process.env.BLEACH_ACCOUNT_DIR;else process.env.BLEACH_ACCOUNT_DIR=previous;assert.ok(path.resolve(dir).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(dir,{recursive:true,force:true});});
const now=Date.parse('2026-10-26T13:00:00+07:00');
function outcome(d,id='reward',mode='pve',won=true){const k=rules.state(d,now);return {id,at:now,mode,model:16100101,won,...rules.battleReward(mode,16100101,won,mode==='pve'?k.pveLeft:k.pvpLeft,()=>0),remaining:mode==='pve'?k.pveLeft:k.pvpLeft,window:mode==='pve'?k.pveSlot:k.pvpDay};}
test('every configured Campaign awards exactly one listed item; losses and exhausted attempts give nothing',()=>{
 for(const row of tablo('LeagueMapPve').liste){const r=rules.battleReward('pve',row._id,true,1,()=>0);assert.equal(r.honor,JSON.parse(row.f11)[0]);assert.equal(r.items.length,1);assert.ok(JSON.parse(row.f8).includes(r.items[0].id));assert.equal(r.items[0].amount,1);}
 for(const [mode,won,left]of [['pve',false,10],['pve',true,0],['pvp',true,0],['pvp',false,0]])assert.deepEqual(rules.battleReward(mode,16100101,won,left),{reward:false,honor:0,items:[]});
 assert.equal(rules.battleReward('pvp',0,true,10,()=>0).honor,30);assert.equal(rules.battleReward('pvp',0,false,10,()=>0).honor,10);
});
test('zero Honor configuration stays zero; invalid loot cannot consume a reward attempt',()=>{
 const row=satir('LeagueMapPve',16100101),before={f11:row.f11,f8:row.f8};
 try{row.f11='[0,2,2]';assert.equal(rules.battleReward('pve',row._id,true,1,()=>0).honor,0);row.f8='[99999999]';assert.throws(()=>rules.battleReward('pve',row._id,true,1,()=>0),/Cấu hình/);}finally{Object.assign(row,before);}
});
test('settlement and collecting an actual accessory mail are idempotent through native claim packets',()=>{
 const d={},r=outcome(d);rules.settle(d,r,now);assert.equal(rules.honor(d),20);assert.equal(d.allianceWar.pveLeft,9);assert.equal(d.posta.gelen.length,1);assert.equal(rules.settle(d,r,now),false);
 require('./sunucu/ekipman');const env=require('./sunucu/envanter'),before=env.mevcut(d,r.items[0].id),pushes=[];
 const handlers=require('./sunucu/sosyal').kur({ekSonra:(id,payload)=>pushes.push({id,payload}),bossRewardMail:{claim:()=>({updates:[]})},odulVer:()=>assert.fail('Alliance mail must not also use the generic reward path')});
 const mail=d.posta.gelen[0],payload=new Y().u16(2).u32(mail.hi).u32(mail.lo).u32(mail.hi).u32(mail.lo).done(),ctx={durum:d,kaydet(){},payload};
 assert.equal(handlers['0x01811603'](ctx).readUInt32BE(),0);assert.equal(env.mevcut(d,r.items[0].id),before+1);assert.equal(mail.ek.length,1,'claim replaces state only after successful save');assert.equal(d.posta.gelen[0].ek.length,0);assert.ok(pushes.some(p=>p.id===0x01180f00));
 assert.equal(handlers['0x01811603'](ctx).readUInt32BE(),0);assert.equal(env.mevcut(d,r.items[0].id),before+1);assert.equal(rules.honor(d),20);assert.equal(d.allianceWar.pveLeft,9);
});
test('a full bag or failed save retains the mail attachment for a retry',()=>{
 const mail=require('./sunucu/admin-item-mail'),env=require('./sunucu/envanter'),d={};rules.settle(d,outcome(d,'stone','pvp'),now);const m=d.posta.gelen[0];d.envanter={esyalar:[{code:14860010,amount:env.MAX_ADET}],dusulen:{}};const before=JSON.stringify(d);let saved=false;
 assert.ok(mail.claim({durum:d,kaydet(){saved=true;}},[[m.hi,m.lo]]).error);assert.equal(saved,false);assert.equal(JSON.stringify(d),before);
 d.envanter.esyalar[0].amount=0;const retry=JSON.stringify(d);assert.throws(()=>mail.claim({durum:d,kaydet(){throw Error('disk failure');}},[[m.hi,m.lo]]),/disk failure/);assert.equal(JSON.stringify(d),retry);assert.equal(d.posta.gelen[0].ek.length,1);
});
test('invalid settlement payloads never debit attempts or mint Honor or mail',()=>{
 for(const bad of [{items:[{id:99999999,amount:1}]},{items:[{id:14860010,amount:0}]},{remaining:0},{won:false},{reward:false}]){const d={},r=outcome(d),before=JSON.stringify(d);assert.throws(()=>rules.settle(d,{...r,...bad},now),/Invalid Alliance/);assert.equal(JSON.stringify(d),before);}
});
function parseResult(payload){const r=new O(payload),won=r.u8()===0,count=r.u16(),players=[];const rewards=()=>Array.from({length:r.u16()},()=>({type:r.u16(),code:r.u32(),amount:r.u32()}));for(let i=0;i<count;i++){const p={name:r.utf(),hero:r.u32(),kills:r.u32()};r.u8();r.u8();p.added=rewards();p.rewards=rewards();players.push(p);}assert.equal(r.kalan(),0);return {won,players};}
test('native PvP uses its actual item slot, counts right-side kills and safely omits no-reward players',()=>{
 const p={name:'RightPlayer',heroId:11100005,honor:30,items:[{id:14860010,amount:1}]},data={id:'pvp',eventId:'pvp',mode:'pvp',model:16200001,side:1,won:true,battles:[],players:[p]};
 // Result-only fixture tests native reward layout independently of fight data.
 let r=parseResult(native.frames(data).at(-1).payload);assert.deepEqual(r.players[0].added,[{type:1,code:14860010,amount:1}]);assert.deepEqual(r.players[0].rewards,[{type:0,code:99,amount:30}]);
 data.players=[{...p,honor:0,items:[]}];assert.equal(parseResult(native.frames(data).at(-1).payload).players.length,0);
 const codec=require('./sunucu/kodek'),report=codec.encodeBattleReport({version:4,player1:{roles:[]},player2:{roles:[]},turns:[]}).toString('base64');data.players=[p];data.battles=[{round:1,index:0,left:'LeftPlayer',right:'RightPlayer',won:false,draw:false,report}];r=parseResult(native.frames(data).at(-1).payload);assert.equal(r.players[0].kills,1);
});
