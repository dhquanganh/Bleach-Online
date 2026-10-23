'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),os=require('node:os');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-king-registration-'));
process.env.BLEACH_ACCOUNT_DIR=temp;process.env.BLEACH_KING_CHALLENGE_FILE=path.join(temp,'production-registry.json');
for(const f of ['veri.json','oyuncu.json'])fs.copyFileSync(path.resolve(__dirname,'..',f),path.join(temp,f));
const K=require('../king-challenge'),{createStore}=require('../king-challenge-store'),p=require('../paket'),levels=require('../seviye'),env=require('../envanter');
const file=path.join(temp,'registry.json'),u=n=>new p.Y().u32(n).done(),uu=(a,b)=>new p.Y().u32(a).u32(b).done();
const code=r=>(Buffer.isBuffer(r)?r:r.payload).readUInt32BE(0);
let now=Date.parse('2026-10-26T14:00:00Z')/1000,simulations=0;
function actor(id,level=99,storeOverride=null){
 const a={d:{roleIdHi:1,roleIdLo:id,nick:'Player '+id,server:974},coins:1000,fail:false,canPay:true,packets:[],saved:null};
 a.H=K.kur({ekSonra:(id,payload)=>a.packets.push({id,payload}),paraHarca:costs=>{const n=costs.reduce((n,r)=>n+r.amount,0);if(!a.canPay||a.coins<n)return null;a.coins-=n;return Buffer.alloc(1);},paraIcinOdul:rewards=>{a.coins+=rewards.reduce((n,r)=>n+r.amount,0);return Buffer.alloc(1);}},
 {now:()=>now,account:()=>({level}),accountKey:d=>String(d.roleIdLo),store:storeOverride||createStore(file),snapshot:()=>[{id:levels.anaId(),pos:6,maxHp:10000,hp:10000,atk:1000,def:500,speed:100}],simulate:(left,right)=>{simulations++;return {won:left.low<right.low,payload:Buffer.from([1,2,3])};}});
 a.call=(op,payload=Buffer.alloc(0))=>a.H['0x01818a'+op]({durum:a.d,payload,kaydet:d=>{if(a.fail)throw Error('save failed');a.saved=JSON.parse(JSON.stringify(d));}});
 return a;
}
try{
 assert.equal(K.nextStart(now),Date.parse('2026-10-26T14:05:00Z')/1000);
 assert.equal(K.nextStart(K.nextStart(now)),Date.parse('2026-10-28T14:05:00Z')/1000);
 const A=actor(1),B=actor(2),start=K.nextStart(now);
 assert.equal(A.call('01',u(1)).readUInt16BE(4),0,'empty event contains zero entrants and no bots');
 assert.equal(A.call('02',u(1)).readUInt16BE(4),0);
 assert.equal(code(A.call('04')),1);assert.notEqual(code(actor(90,59).call('07')),0);
 assert.equal(code(A.call('07')),0);assert.equal(code(A.call('07')),0);
 assert.equal(A.call('01',u(1)).readUInt16BE(4),1,'updating registration cannot duplicate a player');
 assert.equal(Object.keys(JSON.parse(fs.readFileSync(file)).seasons[start].registrations).length,1);
 assert.equal(B.call('01',u(1)).readUInt16BE(4),1,'another account sees the same registration');
 assert.equal(A.call('03',u(1)).readUInt16BE(4),0,'registration has no matches or assigned opponents');
 assert.deepEqual(JSON.parse(fs.readFileSync(file)).seasons[start].groups,{},'registration must not persist a provisional bracket');
 assert.equal(code(B.call('05',uu(1000,0))),1,'cannot wager on a missing opponent');
 now=start;assert.equal(code(A.call('03',u(1))),0);assert.equal(simulations,0,'byes never invoke combat');
 assert.equal(K.ownRank(A.d.kingChallenge.current),1,'single entrant advances through all byes immediately');
 for(const i of [0,4,6])assert.equal(A.d.kingChallenge.current.groups[1].matches[i].bye,true);
 A.call('03',u(2));assert(A.d.kingChallenge.current.groups[2].matches.every(m=>m.done&&m.ret===2),'entirely empty branches have no winner');
 assert.equal(code(B.call('07')),1,'registrations close at the event start');
 const prizes=K.award(1,1),before=prizes.map(r=>env.mevcut(A.d,r.code)),add=env.ekle;
 try{env.ekle=()=>[];assert.equal(code(A.call('04')),1);assert.equal(A.d.kingChallenge.current.claimed,false);}finally{env.ekle=add;}
 assert.equal(code(A.call('04')),0);prizes.forEach((r,i)=>assert.equal(env.mevcut(A.d,r.code)-before[i],r.amount));assert.equal(code(A.call('04')),1);
 assert.equal(code(B.call('04')),1,'spectators have no rank prize');
 assert.equal(code(A.call('09',new p.Y().utf(`${start}:1000`).done())),1,'a bye has no fabricated replay');
 now=start+1800;A.call('00');B.call('00');const second=A.d.kingChallenge.current.start;
 assert.equal(code(A.call('07')),0);assert.equal(code(B.call('07')),0);
 const failed=actor(99);failed.fail=true;assert.equal(code(failed.call('07')),1);
 assert.equal(Object.keys(JSON.parse(fs.readFileSync(file)).seasons[second].registrations).length,2,'failed account save must not publish a registration');
 const diskFailure=actor(77,99,{transact:fn=>createStore(file).transact(registry=>{fn(registry);throw Error('registry write failed');})});
 const beforeFailure=JSON.stringify(diskFailure.d);
 assert.equal(code(diskFailure.call('07')),1);assert.equal(JSON.stringify(diskFailure.d),beforeFailure);assert.equal(diskFailure.packets.length,0);
 assert(!JSON.parse(fs.readFileSync(file)).seasons[second].registrations['77']);
 assert.equal(code(A.call('05',uu(1000,0))),1,'betting waits for the final registration list');
 assert.equal(code(A.call('07')),0,'registration can be updated before the cutoff');
 const others=[];for(let id=3;id<=8;id++){const a=actor(id);others.push(a);assert.equal(code(a.call('07')),0,'unrelated open seats remain registerable');}
 assert.equal(code(actor(9).call('07')),1,'group accepts at most eight players');
 assert.equal(code(actor(10,110).call('07')),0,'capacity is independent per level group');
 assert.equal(A.call('01',u(1)).readUInt16BE(4),8);assert.equal(B.call('01',u(1)).readUInt16BE(4),8);
 const registration=JSON.parse(fs.readFileSync(file)).seasons[second].registrations['1'];
 assert.equal(registration.player.units[0].atk,1000);
 now=second;assert.equal(A.call('03',u(1)).readUInt16BE(4),7);assert.equal(simulations,0,'deadline pairs entrants before real fights begin');
 const paired=JSON.parse(fs.readFileSync(file)).seasons[second].groups[1];assert.equal(paired.pairedAt,second);
 const late=actor(80);assert.equal(late.call('01',u(1)).readUInt16BE(4),8,'a spectator opening after the cutoff sees the same frozen tournament');assert.equal(late.d.kingChallenge.current.start,second);
 assert.deepEqual(paired.players.map(p=>p.low),[1,2,3,4,5,6,7,8],'pairing follows the finalized registration list');
 assert.equal(code(A.call('07')),1,'registration closes before bracket generation');
 A.canPay=false;assert.equal(code(A.call('05',uu(1000,0))),16);A.canPay=true;
 A.fail=true;assert.equal(code(A.call('05',uu(1000,0))),16);A.fail=false;assert.equal(A.coins,1000);
 assert.equal(code(A.call('05',uu(1000,0))),0);assert.equal(code(A.call('05',uu(1000,1))),1);assert.equal(A.coins,950);
 assert.equal(code(B.call('05',uu(1000,1))),0);
 now=second+K.PAIRING_SECONDS;A.call('03',u(1));assert.equal(simulations,4);B.call('03',u(1));assert.equal(simulations,4,'two workers cannot reroll shared results');
 assert.equal(code(A.call('06',uu(1,1000))),0);assert.equal(A.coins,1050);assert.equal(code(A.call('06',uu(1,1000))),1);assert.equal(code(B.call('06',uu(1,1000))),1);
 assert.equal(code(A.call('04')),1,'real final waits for its round');
 now=second+K.PAIRING_SECONDS+300;B.call('03',u(1));assert.equal(simulations,6);
 now=second+K.PAIRING_SECONDS+600;A.call('03',u(1));assert.equal(simulations,7);assert.equal(K.ownRank(A.d.kingChallenge.current),1);
 B.call('03',u(1));assert.equal(K.ownRank(B.d.kingChallenge.current),4);assert.equal(simulations,7);
 assert.equal(code(A.call('09',new p.Y().utf(`${second}:1000`).done())),0);assert(A.packets.some(r=>r.id===0x01458000));
 now=second+1800;B.call('00');assert.equal(code(B.call('04')),0,'offline runner keeps its earned rank prize');
 assert.equal(code(A.call('09',new p.Y().utf(`${second}:1000`).done())),0,'shared archived replay is retained');
 // An independent process sees the same committed season rather than a module cache.
 const check=require('node:child_process').execFileSync(process.execPath,['-e',`const fs=require('fs');process.stdout.write(String(Object.keys(JSON.parse(fs.readFileSync(process.argv[1])).seasons[process.argv[2]].registrations).length));`,file,String(second)],{encoding:'utf8'});assert.equal(check,'9');
 const rightState={kingChallenge:{version:2,group:4,current:{start:second,groups:{},bets:[],claimed:false,entryKey:'right'},archive:[]}};
 const rightRegistry={seasons:{[second]:{start:second,locked:{},groups:{},registrations:{right:{group:4,player:{key:'right',pos:7,low:88,high:1,name:'Right-side entrant'}}}}}};
 const right=K.synchronize(rightState,second,()=>{throw Error('a bye cannot simulate');},rightRegistry,'right');right.resolve(4);
 assert.equal(K.ownRank(right.k),1);assert.equal(right.k.groups[4].players[0].key,'right','registration holes are compacted when the final list is seeded');
 fs.writeFileSync(file+'.lock',JSON.stringify({pid:process.pid}));try{assert.equal(code(A.call('00')),1);}finally{fs.unlinkSync(file+'.lock');}
 // Legacy bot data is never added to the new shared registration list; paid unresolved bets are refunded once.
 const legacy=actor(50);legacy.d.kingChallenge={version:1,group:1,current:{start:now+100,groups:{},bets:[{claimed:false,cost:{type:0,code:2,amount:50}}]},archive:[]};
 const amount=legacy.coins;legacy.call('01',u(1));assert.equal(legacy.coins,amount+50);legacy.call('01',u(1));assert.equal(legacy.coins,amount+50);assert(!legacy.d.kingChallenge.current.submission);
 const battle=require('../savas');assert.equal(battle.isFight(0x01818a00),false);assert.equal(battle.isFight(0x01818a03),false);
 const unit=battle.heroBirim(11150008,6,60,null,null,0,true),result=K.defaultSimulate({name:'A',units:[unit]},{name:'B',units:[unit]},A.d),decoded=require('../kodek').decodeBattleReport(result.payload);assert.equal(decoded._consumed,decoded._total);
 const handlers=require('../handlers');for(let op=0;op<=9;op++)assert.equal(typeof handlers.byReq['0x01818a0'+op],'function');
 assert.equal(handlers.byReq['0x01818a01']({durum:{roleIdHi:1,roleIdLo:99},payload:u(1),kaydet:()=>{}}).readUInt16BE(4),0);
 console.log('PASS registered tournament: zero bots, shared account registry, capacity/cutoff, single-player champion via byes, real PvP brackets, shared results/replays, wagers, rollback/refunds, rank prizes and migration.');
}finally{fs.rmSync(temp,{recursive:true,force:true});}
