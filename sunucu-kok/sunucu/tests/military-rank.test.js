'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-rank-'));
process.env.BLEACH_ACCOUNT_DIR=temp;
const R=require('../military-rank'),{Y,tablo,gunluk}=require('../paket'),gear=require('../ekipman'),stats=require('../statlar');
const file=path.join(temp,'veri.json'),player=path.join(temp,'oyuncu.json');
let d={},pushes=[];
function write(v){fs.writeFileSync(file,JSON.stringify(v));}
function read(){return JSON.parse(fs.readFileSync(file));}
function save(next){fs.writeFileSync(player,JSON.stringify(next));}
const H=R.kur({ekSonra:(id,payload)=>pushes.push({id,payload}),olay:{ayarla:(next,key,value)=>{next.rankQuest=value;}}});
const call=(id,payload=Buffer.alloc(0),kaydet=save)=>H[id]({durum:d,payload,kaydet});
try{
 const fresh=require('../../accounts.cjs').newFiles('new-user','1234');
 assert.equal(JSON.parse(fresh['veri.json']).rutbe,R.FIRST);assert.equal(JSON.parse(fresh['veri.json']).prestij,0);
 assert.equal(JSON.parse(fresh['oyuncu.json']).militaryRank,R.FIRST);
 write({level:99,herolar:[11150031]});
 let packet=call('0x01810800');assert.equal(packet.length,9);assert.equal(packet.readUInt32BE(),R.FIRST);assert.equal(packet.readUInt32BE(4),0);
 assert.equal(read().rutbe,R.FIRST);assert.equal(JSON.parse(fs.readFileSync(player)).militaryRank,R.FIRST);
 assert.equal(call('0x01810801')[0],1);assert.equal(read().rutbe,R.FIRST);
 write({...read(),prestij:1000000});d.prestige=1000000;d.kadro={11150031:7};
 const before=gear.statPaketi(d,11150031,99);
 assert.equal(call('0x01810801')[0],0);assert.equal(d.militaryRank,R.FIRST+1);assert.equal(read().prestij,1000000);
 assert(pushes.some(p=>p.id===0x01180104&&p.payload.readUInt32BE()===11150031));
 const after=gear.statPaketi(d,11150031,99);
 for(let off=4,group=0;group<2;group++){const count=after.readUInt16BE(off);off+=2;for(const i of [0,1,2,3,5,6,7,8,9])assert(after.readUInt32BE(off+4*i)>before.readUInt32BE(off+4*i),`rank gain ${group}/${i}`);off+=count*4;}
 d=JSON.parse(fs.readFileSync(player));assert.deepEqual(gear.statPaketi(d,11150031,99),after);
 const snapshot=fs.readFileSync(file,'utf8'),oldState=JSON.stringify(d);
 assert.equal(call('0x01810801',Buffer.alloc(0),()=>{throw Error('disk full');})[0],1);
 assert.equal(fs.readFileSync(file,'utf8'),snapshot);assert.equal(JSON.stringify(d),oldState);
 write({...read(),rutbe:R.MAX,prestij:1000000,gumus:0xffffffff-10,gumusHigh:2,generalsSoul:7});d.militaryRank=R.MAX;d.prestige=1000000;
 assert.equal(call('0x01810801')[0],1);
 const bonuses=gear.bonuslar(d,11150031);
 d.kadro[11150031]=0;const reserve=gear.bonuslar(d,11150031);
 for(const [i,amount] of [[0,2000],[1,2000],[2,2000],[3,5000],[18,0.3],[19,0.3]])assert(Math.abs(bonuses[i]-reserve[i]-amount)<1e-6);
 const m=tablo('Military').byId.get(R.MAX),aw=JSON.parse(m.salary).award;
 const preSalary=fs.readFileSync(file,'utf8');
 assert.equal(call('0x01810802',Buffer.alloc(0),()=>{throw Error('disk full');})[0],1);assert.equal(fs.readFileSync(file,'utf8'),preSalary);assert(!gunluk(d).maas);
 assert.equal(call('0x01810802')[0],0);assert.equal(read().prestij,1000000-m.costCredit);assert.equal(read().gumusHigh,3);assert.equal(read().gumus,aw[0].amount-11);assert.equal(read().generalsSoul,7+aw[1].amount);
 const paid=JSON.stringify(read());assert.equal(call('0x01810802')[0],1);assert.equal(JSON.stringify(read()),paid);
 d=JSON.parse(fs.readFileSync(player));assert.equal(call('0x01810800')[8],1);assert.equal(call('0x01810802')[0],1);
 d.gunlukSayac.gun='old-day';assert.equal(call('0x01810802')[0],0);
 // Captured login rank/prestige must be overwritten using both variable UTF lengths.
 const login=new Y().u32(54).u32(974).utf('another-user-id').u32(1).u32(2).utf('different name').u32(0).u32(R.MAX).u32(999999).done();
 const patched=R.patchLogin(login,{},{});assert.equal(patched.readUInt32BE(patched.length-8),R.FIRST);assert.equal(patched.readUInt32BE(patched.length-4),0);
 // A second account with no rank must never inherit the first account's Mugetsu.
 write({});d={};assert.equal(call('0x01810800').readUInt32BE(),R.FIRST);assert.equal(R.bonuses(d,11150031).length,0);
 const handlers=require('../handlers');handlers.ekAl();d.kadro={11150031:0};
 const formation=handlers.byReq['0x01810900'];assert.equal(formation({durum:d,payload:new Y().u32(11150031).i8(15).done(),kaydet:save}).readUInt32BE(),0);
 assert(handlers.ekAl().sonra.some(p=>p.id===0x01180104));
 assert.equal(R.id({militaryRank:R.MAX},{}),R.MAX);assert.equal(R.id({militaryRank:R.MAX},{rutbe:R.FIRST}),R.FIRST);
 console.log('PASS rank: new accounts, isolation, relog, promotion, formation/PvE/PvP stats, max rank, salary/carry/daily upkeep, save rollback and captured login fields.');
}finally{fs.rmSync(temp,{recursive:true,force:true});}
