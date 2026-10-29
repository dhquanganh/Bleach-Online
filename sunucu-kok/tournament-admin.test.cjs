'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-tournament-admin-test-'));
process.env.BLEACH_ACCOUNT_DIR=temp;
for(const name of ['oyuncu.json','veri.json'])fs.copyFileSync(path.join(__dirname,'sunucu',name),path.join(temp,name));
const K=require('./sunucu/king-challenge'),{createStore}=require('./sunucu/king-challenge-store'),{createTournament,buildPlayer}=require('./tournament-admin.cjs'),{createAdmin}=require('./admin-accounts.cjs');
test('Tournament admin changes the game registry, enforces locks/revisions, starts immediately and preserves prizes',async()=>{
 const file=path.join(temp,'registry.json'),store=createStore(file),ids=Array.from({length:10},(_,i)=>(i+1).toString(16).padStart(24,'0'));
 const accounts=ids.map((_id,i)=>({_id,username:'user'+i})),players=ids.map((_id,i)=>({_id,files:{'veri.json':JSON.stringify({level:i===9?30:99}),'oyuncu.json':JSON.stringify({karakter:{anaId:11100005,nick:'Player '+i},roleIdLo:i+1})}}));
 const db={collection(name){return {find(){return {sort(){return this;},async toArray(){return name==='accounts'?accounts:players;}};},async findOne(q){return players.find(p=>p._id===String(q._id));}};}};
 let now=Date.parse('2026-10-29T10:00:00Z')/1000,pushes=0,simulations=0;
 const runtime={child:{connected:true,send(m,cb){assert.equal(m.type,'tournament-update');pushes++;cb();}}};
 const simulate=(a,b)=>{simulations++;return {won:a.low<b.low,payload:Buffer.from('test battle')};};
 const service=createTournament({db,store,runtimes:new Map([[ids[0],runtime]]),snapshot:()=>players[0].files,now:()=>now,simulate,build:async files=>{const d=JSON.parse(files['oyuncu.json']);return {group:1,player:{low:d.roleIdLo,high:1,name:d.karakter.nick,model:11100005,power:500,units:[{id:11100005,pos:1,maxHp:10000,atk:1000,def:500,speed:100}]}};}});
 const admin=createAdmin({db,tournament:service,body:async r=>r.data});
 async function call(method,data,role='admin'){let result;await admin({method,data},{},'/auth/admin/tournament',{account:{role,_id:'admin'}},(status,value)=>{result={status,value};});return result;}
 const initial=(await call('GET')).value,scheduled=initial.start;
 assert.equal(initial.groups[0].players.length,0);assert.equal((await call('GET',null,'player')).status,403);assert.equal((await call('DELETE')).status,405);
 let v=initial;
 async function change(data){const out=await call('POST',{...data,revision:v.revision});assert.equal(out.status,200,JSON.stringify(out));v=out.value;return v;}
 assert.equal((await call('POST',{action:'start',revision:v.revision})).status,400);
 assert.equal((await call('POST',{action:'add',accountId:ids[9],revision:v.revision})).status,400);
 for(let i=0;i<8;i++)await change({action:'add',accountId:ids[i]});
 assert.equal(v.groups[0].players.length,8);assert.equal((await call('POST',{action:'add',accountId:ids[8],revision:v.revision})).status,409);
 assert.equal((await call('POST',{action:'remove',key:ids[0],revision:initial.revision})).status,409);
 await change({action:'remove',key:ids[7]});await change({action:'add',accountId:ids[8]});
 assert.equal((await call('POST',{action:'order',group:1,keys:[ids[0],ids[0]],revision:v.revision})).status,400);
 const ordered=v.groups[0].players.map(p=>p.key).reverse();await change({action:'order',group:1,keys:ordered});assert.deepEqual(v.groups[0].players.map(p=>p.key),ordered);
 const state={kingChallenge:{version:2,group:1,current:{start:scheduled,groups:{},bets:[],claimed:false,entryKey:ids[0]},archive:[]}};
 await change({action:'start'});assert.equal(v.start,now);assert.equal(v.status,'running');assert.equal(simulations,4,'quarter finals execute immediately without 60-second delay');
 assert(pushes>=12,'roster changes and start notify workers');
 const sync=()=>store.transact(r=>{const x=K.synchronize(state,now,simulate,r,ids[0]);x.resolve(1);return {commit:true,result:x};});
 sync();assert.equal(state.kingChallenge.current.start,now);assert.equal(state.kingChallenge.current.submission.player.key,ids[0]);assert.equal(simulations,4,'another worker reuses reports');
 assert.equal((await call('POST',{action:'start',revision:v.revision})).status,409);assert.equal((await call('POST',{action:'remove',key:ids[0],revision:v.revision})).status,409);
 now+=300;await service.view();assert.equal(simulations,6);now+=300;await service.view();assert.equal(simulations,7);sync();assert.equal(K.ownRank(state.kingChallenge.current),1);
 const oldStart=state.kingChallenge.current.start;now=oldStart+K.DISPLAY_SECONDS;sync();assert.equal(state.kingChallenge.archive[0].start,oldStart);assert.equal(K.ownRank(state.kingChallenge.archive[0]),1,'finished prize entitlement survives manual start');
 assert.equal(state.kingChallenge.current.start,scheduled);sync();assert.equal(state.kingChallenge.current.start,scheduled,'new registration must not redirect back to the completed admin tournament');
 const next=await service.view();assert.equal(next.status,'registration');assert.equal(next.groups[0].players.length,0);
});
test('Production snapshot builds PvP formation in an isolated process',async()=>{
 const files=Object.fromEntries(require('./accounts.cjs').FILES.filter(n=>fs.existsSync(path.join(__dirname,'sunucu',n))).map(n=>[n,fs.readFileSync(path.join(__dirname,'sunucu',n),'utf8')]));
 const before=files['oyuncu.json'],result=await buildPlayer(files);assert(result.player.units.length>0);assert(result.player.power>0);assert([1,2,3,4].includes(result.group));assert.equal(files['oyuncu.json'],before);
});
test.after(()=>fs.rmSync(temp,{recursive:true,force:true}));
