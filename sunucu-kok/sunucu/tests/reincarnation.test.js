'use strict';
// All operations use in-memory copies. No player files or currencies on disk are changed.
const fs=require('fs'),path=require('path'),assert=require('assert'),vm=require('vm'),{createRequire}=require('module');
const root=path.resolve(__dirname,'..'),file=path.join(root,'reincarnation.js'),local=createRequire(file);
const level=local('./seviye'),env=local('./envanter'),packet=local('./paket'),gear=local('./ekipman'),stats=local('./statlar');
const main=level.anaId(),partner=11150057,source=JSON.parse(fs.readFileSync(path.join(root,'oyuncu.json'),'utf8'));
let account={level:159,deneyim:0,altin:10000,herolar:[partner]},saves=0,paid=0,pushes=[];
const mockLevel={...level,veriOku:()=>({...account}),veriYaz:v=>account={...v},heroDurum:(d,id,v)=>id===main?{lv:(v||account).level,exp:(v||account).deneyim}:level.heroDurum(d,id,v),heroSeviye:(d,id)=>id===main?account.level:level.heroSeviye(d,id)};
const mod={exports:{}};vm.runInNewContext(fs.readFileSync(file,'utf8'),{module:mod,exports:mod.exports,Buffer,console,require:name=>name==='./seviye'?mockLevel:local(name)});
const r=mod.exports;
const handlers=r.kur({paraIcinOdul:aw=>{account.altin+=aw.reduce((n,a)=>n+a.amount,0);return Buffer.alloc(2);},ekOnce:(...p)=>pushes.push(p),ekSonra:(...p)=>pushes.push(p),paraHarca:awards=>{const n=awards.reduce((s,a)=>s+a.amount,0);if(account.altin<n)return null;account.altin-=n;paid+=n;return Buffer.alloc(2);},odulVer:(d,awards)=>{const added=env.ekle(d,awards);const ntf=env.kazancPaketi(d,added);if(ntf)pushes.push([env.OP_NTF,ntf]);}});
function fixture(){const d=JSON.parse(JSON.stringify(source));d.yenidenDogus={hero:{}};d.gunlukSayac={gun:packet.gun(),reb:{book:0}};level.heroKayit(d,partner,159).lv=159;level.heroKayit(d,partner,159).exp=0;for(const id of [14100698,14100699,14100700,14100701]){const n=env.mevcut(d,id);if(n)env.dus(d,id,n);}return d;}
const req=id=>new packet.Y().u32(id).done(),ctx=d=>({durum:d,kaydet:()=>saves++}),call=(op,d,payload)=>handlers[op]({...ctx(d),payload});
let d=fixture();
assert.strictEqual(call('0x01818500',d,Buffer.alloc(0)).readUInt32BE(0),4);
assert.strictEqual(call('0x01818500',d,req(123)).readUInt32BE(0),4);
assert.strictEqual(call('0x01818500',d,req(partner)).readUInt32BE(0),1);
account.level=109;env.ekle(d,[{code:14100698,amount:500}]);assert.strictEqual(call('0x01818500',d,req(main)).readUInt32BE(0),1);assert.strictEqual(env.mevcut(d,14100698),500);
account.level=159;const expected=r.afterLevel(159,0,0),result=call('0x01818500',d,req(main));assert.strictEqual(result.length,33);assert.strictEqual(result.readUInt32BE(0),0);assert.strictEqual(result[16],1);assert.strictEqual(result.readUInt32BE(17),158);assert.strictEqual(result.readUInt32BE(25),expected.exp);assert.strictEqual(result.readUInt32BE(29),159);
assert.strictEqual(account.level,158);assert.strictEqual(account.deneyim,1217095208);assert.strictEqual(env.mevcut(d,14100698),0);assert(pushes.some(p=>p[0]===0x01180104));
assert(r.record(d,main).pp>=1&&r.record(d,main).pp<=3);assert(r.attackPool(1).includes(r.record(d,main).ae));
assert.strictEqual(call('0x01818500',d,req(main)).readUInt32BE(0),18);
env.ekle(d,[{code:14100698,amount:16000}]);const first=r.record(d,main);
for(let n=2;n<=5;n++){account.level=159;account.deneyim=0;const ret=call('0x01818500',d,req(main));assert.strictEqual(ret.readUInt32BE(0),0);assert.strictEqual(ret[16],n);assert.strictEqual(r.record(d,main).pp,first.pp);assert.strictEqual(r.record(d,main).ae,first.ae);const predicted=r.afterLevel(159,0,n-1);assert.strictEqual(ret.readUInt32BE(17),predicted.lv);assert.strictEqual(ret.readUInt32BE(25),predicted.exp);}
const stones=env.mevcut(d,14100698);assert.strictEqual(call('0x01818500',d,req(main)).readUInt32BE(0),1);assert.strictEqual(env.mevcut(d,14100698),stones);
const fragment=r.fragmentId(partner);assert.strictEqual(fragment,14130055);
const beforeMissingStone=env.mevcut(d,14100698),beforeMissingLevel=level.heroSeviye(d,partner);
const fragmentBalance=env.mevcut(d,fragment);if(fragmentBalance)env.dus(d,fragment,fragmentBalance);
assert.strictEqual(call('0x01818500',d,req(partner)).readUInt32BE(0),18);
assert.strictEqual(env.mevcut(d,14100698),beforeMissingStone);assert.strictEqual(level.heroSeviye(d,partner),beforeMissingLevel);
env.ekle(d,[{code:fragment,amount:50}]);assert.strictEqual(call('0x01818500',d,req(partner)).readUInt32BE(0),18);assert.strictEqual(env.mevcut(d,fragment),50);
env.ekle(d,[{code:fragment,amount:49}]);assert.strictEqual(call('0x01818500',d,req(partner)).readUInt32BE(0),18);assert.strictEqual(env.mevcut(d,fragment),99);
env.ekle(d,[{code:fragment,amount:1}]);
const partnerRet=call('0x01818500',d,req(partner));assert.strictEqual(partnerRet.readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,fragment),0);assert.strictEqual(level.heroSeviye(d,partner),158);assert.strictEqual(level.heroDurum(d,partner).exp,1217095208);
const reset=(a,s,e)=>new packet.Y().u32(partner).u8(a).u8(s).u8(e).done();
assert.strictEqual(call('0x01818501',d,reset(0,1,0)).readUInt32BE(0),4);
env.ekle(d,[{code:14100700,amount:10}]);const costBefore=env.mevcut(d,14100700),goldBefore=account.altin;
assert.strictEqual(call('0x01818501',d,reset(1,1,1)).readUInt32BE(0),18);assert.strictEqual(env.mevcut(d,14100700),costBefore);assert.strictEqual(account.altin,goldBefore);
env.ekle(d,[{code:14100699,amount:10}]);account.altin=199;assert.strictEqual(call('0x01818501',d,reset(1,1,1)).readUInt32BE(0),16);assert.strictEqual(env.mevcut(d,14100700),10);assert.strictEqual(env.mevcut(d,14100699),10);
account.altin=10000;const resetRet=call('0x01818501',d,reset(1,1,1));assert.strictEqual(resetRet.length,18);assert.strictEqual(resetRet.readUInt32BE(0),0);assert([4,5].includes(r.record(d,partner).pp));assert(r.attackPool(1).includes(r.record(d,partner).ae));assert.strictEqual(account.altin,9800);assert.strictEqual(env.mevcut(d,14100700),0);assert.strictEqual(env.mevcut(d,14100699),0);
const epic=14100701,books=env.mevcut(d,epic),gold=account.altin;
assert.strictEqual(call('0x01818502',d,Buffer.from([0])).readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,epic),books+10);assert.strictEqual(account.altin,gold);
assert.strictEqual(call('0x01818502',d,Buffer.from([0])).readUInt32BE(0),1);assert.strictEqual(env.mevcut(d,epic),books+10);
assert.strictEqual(call('0x01818502',d,Buffer.from([1])).readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,epic),books+110);assert.strictEqual(account.altin,gold-120);
assert.strictEqual(handlers['0x01818503'](ctx(d))[0],1);d.gunlukSayac.gun='2000-01-01';assert.strictEqual(handlers['0x01818503'](ctx(d))[0],0);
assert.strictEqual(call('0x01818502',fixture(),Buffer.from([0])).readUInt32BE(0),1);
// A relog preserves reincarnation fields, current EXP/level, history and the exact stat block.
const raw=fs.readFileSync(path.join(root,'zaman',JSON.parse(fs.readFileSync(path.join(root,'zaman/timeline.json'))).find(x=>x.dir==='s2c'&&/01180102/i.test(x.id)).file));
const h=local('./harita'),patched=gear.charYama(raw,d,h.basicEnd),start=h.basicEnd(patched)+2,adv=patched.readInt16BE(start+22),field=start+24+9*adv+32;
assert.strictEqual(patched[field],5);assert.strictEqual(patched[field+1],first.pp);assert.strictEqual(patched[field+2],first.ae);assert(patched.readUInt32BE(field+3)>=159);
const [a,b]=stats.attrAralik(patched,start);assert(patched.subarray(a,b).equals(gear.statPaketi(d,main,level.heroSeviye(d,main)).subarray(4)));
const actual=local('./reincarnation'),savas=local('./savas'),kodek=local('./kodek');
function unit(camp,ae=0,n=0,pp=0){return {id:camp?12101003:main,camp,pos:camp?6:1,hp:1000,maxHp:1000,atk:100,def:100,anger:0,normal:13100114,skill:0,skillId:13100114,critRate:.15,rebirth:{n,ae,pp},damageBonus:0,damageReduction:0};}
assert.strictEqual(actual.restriction({n:1,pp:2},{n:1,pp:1}),.7);assert.strictEqual(actual.restriction({n:0,pp:0},{n:1,pp:5}),.7);assert.strictEqual(actual.bonuses({n:5,pp:4}).reduction,.4);
for(const effect of [1,3,6,7,8]){
 const a=unit(0,[3,6].includes(effect)?0:effect,[3,6].includes(effect)?0:1),b=unit(1,[3,6].includes(effect)?effect:0,[3,6].includes(effect)?1:0);b.shield=50;b.activeBuffs={1:true};
 const out=actual.hit(a,b,100,()=>0);
 if(effect===1)assert.strictEqual(b.shield,0);if(effect===3)assert.strictEqual(out.damage,0);if(effect===6)assert.strictEqual(b.hp,b.maxHp);if(effect===7)assert.deepStrictEqual(b.activeBuffs,{});if(effect===8)assert.strictEqual(b.hp,0);
}
for(const effect of [2,4,5,9,10]){
 const a=unit(0,effect===9?0:effect,effect===9?0:5),b=unit(1,effect===9?9:0,effect===9?3:0),c=unit(1);c.pos=11;
 const act=savas.vurus(a,b,false,[b,c],()=>0);
 if(effect===2)assert(act.targets[1].result.hurtHp>150);if(effect===4)assert(act.targets.some(t=>t.targetPos===11&&t.result.hurtHp>0));if(effect===5)assert(act.targets[1].result.hurtHp>100);if(effect===9)assert.strictEqual(act.targets[1].reportTargetStatus&kodek.ST.CRIT,0);if(effect===10){assert.strictEqual(b.pos,11);assert.strictEqual(c.pos,6);assert.strictEqual(act.targets.filter(t=>t.cmd===kodek.CMD.POSITION).length,2);}
 const encoded=kodek.encodeBattleReport({version:3,player1:{roles:[]},player2:{roles:[]},turns:[{curTurn:1,actives:[act]}]}),decoded=kodek.decodeBattleReport(encoded);assert.strictEqual(decoded._consumed,decoded._total);
}
const battleState=JSON.parse(JSON.stringify(source));battleState.yenidenDogus={hero:{[main]:{n:2,pp:1,ae:2,history:159}}};const battle=savas.kadroRapor(0,null,null,{playerState:battleState,forceWin:false});assert(battle);assert.strictEqual(kodek.decodeBattleReport(battle.payload).player1.roles.find(x=>x.roleId===main).rebirthNum,2);
console.log('PASS: ownership/level/main prerequisite, five stages, exact 64-bit EXP deduction, atomic reset costs, free/paid Epic EXP Books, daily state, login/stat persistence, all ten combat effects and report serialization. No player files changed.');

const plain=fixture();plain.yenidenDogus={hero:{}};plain.meslekAritma=[0,0,0,0];
// Isolate reincarnation ratios from stars inherited from the live player fixture.
plain.heroStars={};
const basePacket=gear.statPaketi(plain,partner,159).subarray(4),baseCount=basePacket.readUInt16BE(0);
for(const stage of [1,2,5]){
 plain.yenidenDogus.hero[String(partner)]={n:stage,pp:1,ae:1};
 const upgraded=gear.statPaketi(plain,partner,159).subarray(4);
 for(const index of [0,1,2,3,4,5,6,7,8,9,26])if(index<baseCount)assert.strictEqual(upgraded.readUInt32BE(2+4*index),Math.min(0x7fffffff,basePacket.readUInt32BE(2+4*index)*(stage+1)));
}
assert.strictEqual(r.fragmentId(main),0);
console.log('PASS: +100% core stats per reincarnation (x2/x3/x6), correct partner fragments, exact 100 deduction, 50/99 rejected without consuming materials, main exempt.');

const beforeRefinery=gear.statPaketi(plain,partner,159);
plain.meslekAritma[Number(packet.satir('BaseHero',partner).profession)-1]=1;
const combined=gear.statPaketi(plain,partner,159),rates=packet.satir('ProfessionRefine',1);
for(const [index,key] of [[4,'speed'],[5,'hp'],[6,'phyAtk'],[7,'magicAtk'],[8,'phyDef'],[9,'magicDef']]){
 const before=beforeRefinery.readUInt32BE(6+4*index);assert.strictEqual(combined.readUInt32BE(6+4*index),before+Math.round(before*rates[key]));
}
plain.kadro={[main]:1,[partner]:6};level.heroKayit(plain,partner,159).lv=159;
const actualBattle=savas.kadroRapor(0,null,null,{playerState:plain,forceWin:false});
assert.strictEqual(kodek.decodeBattleReport(actualBattle.payload).player1.roles.find(x=>x.roleId===partner).totalHealth,stats.blokOku(combined.subarray(4)).hp);
console.log('PASS: reincarnation/refinery rounding composes consistently and battle HP matches the boosted stat packet.');

const sync=pushes.filter(p=>p[0]===0x01180f00);assert(sync.length>=2);assert(sync.every(p=>gear.kayitlariOku(p[1],5).son===p[1].length));
const failure=JSON.parse(JSON.stringify(d)),failedGold=account.altin,failedBooks=env.mevcut(failure,epic);
const failed=handlers['0x01818502']({payload:Buffer.from([1]),durum:failure,kaydet:()=>{throw Error('disk unavailable');}});
assert.strictEqual(failed.readUInt32BE(0),1);assert.strictEqual(account.altin,failedGold);assert.strictEqual(env.mevcut(failure,epic),failedBooks);
console.log('PASS: free/paid EXP Books send complete parseable bag updates; failed saves refund gold without granting items.');
