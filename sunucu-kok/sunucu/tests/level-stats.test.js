'use strict';
// Verify real stat packets and level-up handling without changing player data.
const assert=require('assert'),fs=require('fs'),path=require('path'),vm=require('vm'),{createRequire}=require('module');
const root=path.resolve(__dirname,'..'),local=createRequire(path.join(root,'seviye.js'));
const level=local('./seviye'),stats=local('./statlar'),gear=local('./ekipman'),source=stats.anaKaynakHam();
assert(source);
const highHero=11110030;
for(const id of [source.id,highHero]) {
 const before=stats.blokOku(gear.statPaketi({},id,158).subarray(4));
 const after=stats.blokOku(gear.statPaketi({},id,159).subarray(4));
 for(const key of ['hp','atk','def','guc'])assert(after[key]>before[key],`${id}: ${key} must grow at 158->159`);
}
assert(level.buyumeTemeli(highHero,159).life>level.buyumeTemeli(highHero,1).life);
let count=0;
for(const [id,h] of stats.heroById) {
 const before=level.statCarpanlari(id,158,source.id,source.lv),after=level.statCarpanlari(id,159,source.id,source.lv);
 for(const [field,growth] of [['power','powerGrow'],['agile','agileGrow'],['intelligence','intelligenceGrow'],['life','lifeGrow']]) {
  if(Number(h[growth])>0 && Number(h[field])>0) {assert(after[field]>before[field],`${id} ${field}: capped growth`);count++;}
 }
}
const before=gear.statPaketi({},highHero,158).subarray(4),after=gear.statPaketi({},highHero,159).subarray(4);
let offset=0;
for(let block=0;block<2;block++) {
 const n=before.readUInt16BE(offset);assert.strictEqual(after.readUInt16BE(offset),n);offset+=2;
 for(let i=0;i<n;i++)if(!stats.OLCEKLI.includes(i)&&i!==stats.IDX.Speed)assert(before.subarray(offset+i*4,offset+i*4+4).equals(after.subarray(offset+i*4,offset+i*4+4)),`fixed stat ${i} changed`);
 assert(after.readUInt32BE(offset+4*stats.IDX.Speed)>before.readUInt32BE(offset+4*stats.IDX.Speed),'BaseHero speed growth must reach the client packet');
 offset+=n*4;
}
assert(before.subarray(offset).equals(after.subarray(offset)));
// Oversized growth cannot overflow the packet's integer range.
const oversized=stats.blokOlcekle(source.blok,1e10);assert.strictEqual(oversized.length,source.blok.length);
for(let p=0,b=0;b<2;b++){const n=oversized.readUInt16BE(p);p+=2;for(const i of stats.OLCEKLI)if(i<n)assert(oversized.readUInt32BE(p+i*4)<=0x7fffffff);p+=n*4;}
let account={level:10,deneyim:0},writes=0;
const fakeFs={...fs,readFileSync:(file,encoding)=>path.basename(file)==='veri.json'?JSON.stringify(account):fs.readFileSync(file,encoding),writeFileSync:(file,data)=>{assert.strictEqual(path.basename(file),'veri.json');account=JSON.parse(data);writes++;}};
const mod={exports:{}};
vm.runInNewContext(fs.readFileSync(path.join(root,'seviye.js'),'utf8'),{module:mod,exports:mod.exports,Buffer,console,__dirname:root,require:name=>name==='fs'?fakeFs:name==='./statlar'?{anaKaynak:()=>source}:name==='./olay'?{ayarla:()=>{}}:local(name)});
const engine=mod.exports,d={kadro:{[source.id]:1,[highHero]:6}};
const exp=engine.need(10);
const results=engine.expEkle(d,exp);
assert.strictEqual(writes,1);assert.strictEqual(account.level,11);
assert.strictEqual(engine.heroSeviye(d,highHero),11,'new partner must start at pre-upgrade level');
assert.strictEqual(results.find(r=>r.id===highHero).exp,0);
// Use the actual upgrade handler: level notification must be followed by fresh attribute packets.
const handlerSource=fs.readFileSync(path.join(root,'handlers.js'),'utf8');
const start=handlerSource.indexOf("'0x01810102': ")+"'0x01810102': ".length,end=handlerSource.indexOf('\n  },',start)+4;
const pushes=[];
const handler=vm.runInNewContext('('+handlerSource.slice(start,end)+')',{seviye:engine,ekSonra:(...args)=>pushes.push(args),require:local,console});
const req=Buffer.alloc(10);req.writeUInt16BE(2);req.writeUInt32BE(source.id,2);req.writeUInt32BE(highHero,6);
let saved=0;
const ret=handler({payload:req,durum:d,kaydet:()=>saved++});
assert.strictEqual(ret.readUInt16BE(0),2);assert.strictEqual(ret.readUInt32BE(6),11);assert.strictEqual(ret.readUInt32BE(22),11);
assert.strictEqual(pushes.length,2);assert.strictEqual(saved,1);
for(const [opcode,payload] of pushes){assert.strictEqual(opcode,0x01180104);assert(payload.equals(gear.statPaketi(d,payload.readUInt32BE(0),11)));}
assert.strictEqual(handler({payload:req,durum:d,kaydet:()=>saved++}),false);assert.strictEqual(pushes.length,2);
// A registered partner retains its own level and normal multi-level/max-level behavior.
const partner={seviye:{herolar:{[highHero]:{lv:5,exp:0}}}};
const result=engine.heroExpEkle(partner,highHero,engine.need(5)+engine.need(6));assert.strictEqual(result.lv,7);
assert.strictEqual(engine.ilerlet(159,Number.MAX_SAFE_INTEGER).lv,159);
const unknown=engine.statCarpanlari(0,159,source.id,source.lv);assert.strictEqual(unknown.genel,1);
// Event and gift reward EXP must mutate the caller's state, not a separately reloaded copy.
account={level:10,deneyim:0};
const rewardState={kadro:{[source.id]:1,[highHero]:6},envanter:{esyalar:[],dusulen:{}}};
let stored=JSON.parse(JSON.stringify(rewardState));
const stateStore={yukle:()=>JSON.parse(JSON.stringify(stored)),kaydet:d=>stored=JSON.parse(JSON.stringify(d))};
const paymentStart=handlerSource.indexOf('function paraIcinOdul('),paymentEnd=handlerSource.indexOf('// --- PARA HARCAMA:',paymentStart);
const paymentContext={fs:fakeFs,path,__dirname:root,Buffer,console,seviye:engine,PARA:{'2:0':{idx:11,alan:'deneyim'}},PARA_TAVAN:2000000000,require:name=>name==='./durum'?stateStore:local(name)};
const payment=vm.runInNewContext('('+handlerSource.slice(paymentStart,paymentEnd)+')',paymentContext);
const rewardStart=handlerSource.indexOf('function odulVer('),rewardEnd=handlerSource.indexOf('// ---- EK PAKET KUYRUGU',rewardStart);
const rewardPushes=[];
const grant=vm.runInNewContext('('+handlerSource.slice(rewardStart,rewardEnd)+')',{envanterDepo:local('./envanter'),paraIcinOdul:payment,ekSonra:(...args)=>rewardPushes.push(args),console});
grant(rewardState,[{type:2,code:0,amount:exp},{type:1,code:14140507,amount:1}]);
stateStore.kaydet(rewardState); // same final save as event/gift handlers
assert.strictEqual(account.level,11);assert.strictEqual(engine.heroSeviye(stored,highHero),11);
assert(engine.bekleyenMi(stored,source.id));assert(engine.bekleyenMi(stored,highHero));
assert.strictEqual(local('./envanter').mevcut(stored,14140507),1);
const expPacket=rewardPushes.find(p=>p[0]===0x01180105)[1];assert.strictEqual(expPacket[2],11);assert.strictEqual(expPacket.readUInt32BE(3),exp);
assert(handlerSource.includes('para: awards => paraIcinOdul(awards, durum)'));
console.log(`PASS: ${count} growth fields, high-level/main/partner stats, fixed packet fields, overflow bounds, EXP progression, shared event/gift state and immediate level+attribute notifications. Player files unchanged.`);
