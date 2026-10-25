'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path'),{EventEmitter}=require('events'),{ObjectId}=require('mongodb');
const rules=require('./sunucu/ultimate-bp-ranking'),{createRanking}=require('./ultimate-bp-ranking.cjs');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'ultimate-ranks-'));after(()=>fs.rmSync(temp,{recursive:true,force:true}));
const clone=v=>v===undefined?undefined:structuredClone(v),id=n=>new ObjectId(n.toString(16).padStart(24,'0'));
function fixture(scores=[6000,8000,8000,4999],options={}){
 const directory=fs.mkdtempSync(path.join(temp,'accounts-')),accounts=scores.map((n,i)=>({_id:id(i+1),username:'user'+i})),players=scores.map((pieces,i)=>({_id:id(i+1),files:{'veri.json':JSON.stringify({ultimateBP:{pieces}}),'oyuncu.json':JSON.stringify({roleIdHi:1,roleIdLo:i+1,karakter:{anaId:11100005,nick:'Hero '+(i+1)}})}}));const documents=new Map();
 const db={collection(name){if(name==='ultimateBPRankingPayouts')return {async findOne(q){return clone(documents.get(q._id));},async updateOne(q,u,opts){if(opts?.upsert){if(!documents.has(q._id))documents.set(q._id,{_id:q._id,...clone(u.$setOnInsert)});return {matchedCount:1};}const settlement=documents.get(q._id);if(!settlement)return {matchedCount:0};for(const [key,value]of Object.entries(u.$set)){const parts=key.split('.');let target=settlement;for(const p of parts.slice(0,-1))target=target[p];target[parts.at(-1)]=clone(value);}return {matchedCount:1};}};const rows=name==='accounts'?accounts:players;return {find(){return {async toArray(){return rows;}}},async findOne(q){return rows.find(r=>r._id.equals(q._id));},async updateOne(q,u){const r=rows.find(r=>r._id.equals(q._id));if(!r||q.files&&JSON.stringify(q.files)!==JSON.stringify(r.files))return {matchedCount:0};Object.assign(r,clone(u.$set));return {matchedCount:1};}};}};
 const snapshot=dir=>Object.fromEntries(['veri.json','oyuncu.json'].filter(f=>fs.existsSync(path.join(dir,f))).map(f=>[f,fs.readFileSync(path.join(dir,f),'utf8')]));
 const board=createRanking(db,{directory,snapshot,intervalMs:0,now:()=>123456,...options});return {board,players,accounts,db,directory,snapshot,documents,get settlement(){return documents.get(rules.ID);}};
}
test('ranks real online/offline characters by pieces, deterministic ties, excludes uncreated/deleted accounts and below 5000',async()=>{
 const f=fixture();f.players.push({_id:id(99),files:{'oyuncu.json':'{}'}});const v=await f.board.view();assert.deepEqual(v.rows.map(r=>r.accountId),[id(2),id(3),id(1)].map(x=>x.toHexString()));assert.deepEqual(v.rows.map(r=>r.rank),[1,2,3]);assert.equal(v.minimum,5000);assert.equal(v.rewards.length,6);assert.ok(v.rewards[0].items.some(i=>i.itemId===14400001));await f.board.close();
});
test('native RankInfo7 serializes the exact array/object schema consumed by Flash with UTF-8 names and real scores',()=>{
 const {Y,O}=require('./sunucu/paket');rules.update({rows:[{id0:1,id1:22,rank:1,name:'Tướng thử',serverId:974,pieces:5000}]});const o=new O(rules.write(new Y()).done());assert.equal(o.u16(),1);assert.equal(o.u32(),1);assert.equal(o.u32(),22);assert.equal(o.u32(),1);assert.deepEqual(JSON.parse(o.utf()),[{name:'Tướng thử',serverID:974,value:5000}]);assert.equal(o.kalan(),0);rules.update({rows:[]});
});
test('admin preview rejects stale scores, freezes exact top 50 prizes once, and offline mail survives claim/deletion/retry',async()=>{
 const f=fixture();let view=await f.board.view();f.players[0].files['veri.json']=JSON.stringify({ultimateBP:{pieces:10000}});await assert.rejects(f.board.award(view.revision,'admin'),{status:409});assert.equal(f.settlement,undefined);
 view=await f.board.view();const result=await f.board.award(view.revision,'admin');assert.equal(result.settlement.status,'delivered');assert.equal(result.settlement.delivered,3);assert.equal(f.settlement.rewards[0].accountId,id(1).toHexString());assert.equal(f.settlement.actor,'admin');
 const state=JSON.parse(f.players[0].files['oyuncu.json']);assert.equal(state.posta.gelen.length,1);assert.ok(state.posta.gelen[0].ek.some(([i])=>i===14400001));const immutable=JSON.stringify(f.settlement.rewards);
 await f.board.award(view.revision,'admin');assert.equal(JSON.stringify(f.settlement.rewards),immutable);assert.equal(JSON.parse(f.players[0].files['oyuncu.json']).posta.gelen.length,1);
 state.posta.gelen=[];const duplicate=rules.enqueue(state,f.settlement.rewards[0]);assert.equal(duplicate.created,false);assert.equal(state.posta.gelen.length,0);await f.board.close();
});
test('all six rank ranges get correct rewards; below threshold receives nothing; mail parcels fit inventory and claim once',async()=>{
 const f=fixture(Array.from({length:52},(_,i)=>10000-i));const v=await f.board.view();await f.board.award(v.revision,'admin');assert.equal(f.settlement.rewards.length,50);for(const rank of [1,2,3,4,10,11,20,21,50]){const p=f.settlement.rewards[rank-1],tier=rules.tiers().find(t=>rank<=t.through);assert.deepEqual(p.items,tier.items);}
 assert.equal(JSON.parse(f.players[50].files['oyuncu.json']).posta,undefined);
 const state=JSON.parse(f.players[0].files['oyuncu.json']),mail=state.posta.gelen[0],env=require('./sunucu/envanter'),before=env.mevcut(state,14400001);let saved;const ctx={durum:state,kaydet:d=>{saved=structuredClone(d);}};assert.equal(require('./sunucu/admin-item-mail').claim(ctx,[[mail.hi,mail.lo]]).error,undefined);assert.equal(env.mevcut(saved,14400001),before+1);assert.equal(saved.posta.gelen[0].ek.length,0);require('./sunucu/admin-item-mail').claim(ctx,[[mail.hi,mail.lo]]);assert.equal(env.mevcut(ctx.durum,14400001),before+1);await f.board.close();
});
test('online worker acknowledgments and restart resume recover a lost acknowledgment without a second mail',async()=>{
 const runtimes=new Map(),f=fixture([7000],{runtimes});const dir=path.join(f.directory,id(1).toHexString());fs.mkdirSync(dir);for(const [name,value]of Object.entries(f.players[0].files))fs.writeFileSync(path.join(dir,name),value);
 const child=new EventEmitter();child.connected=true;let pushes=0;child.send=(m,callback)=>{if(callback)callback();if(m.type==='ultimate-bp-ranking')return;const d=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json')));const v=JSON.parse(fs.readFileSync(path.join(dir,'veri.json')));if(m.type==='ultimate-bp-rank-reset'){rules.reset(d,v,m.payout.id);fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(v));}else{const result=rules.enqueue(d,m.payout);if(result.created)pushes++;}fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(d));setImmediate(()=>child.emit('message',{type:'ultimate-bp-rank-mail-ack',id:m.payout.id}));};runtimes.set(id(1).toHexString(),{child,dir});
 // DB sync fails once after the worker persisted the mailbox, just as after a lost ack/crash.
 await f.board.close();let attempts=0;const resumed=createRanking(f.db,{runtimes,directory:f.directory,snapshot:f.snapshot,intervalMs:0,save:async()=>{if(++attempts===1)throw Error('sync interruption');f.players[0].files=f.snapshot(dir);}});const v=await resumed.view();let result=await resumed.award(v.revision,'admin');assert.equal(result.settlement.delivered,0);assert.equal(pushes,1);await resumed.close();
 const again=createRanking(f.db,{runtimes,directory:f.directory,snapshot:f.snapshot,intervalMs:0,save:async()=>{f.players[0].files=f.snapshot(dir);}});await again.refresh();assert.equal(f.settlement.status,'delivered');assert.equal(pushes,1);assert.equal(JSON.parse(f.players[0].files['oyuncu.json']).posta.gelen.length,1);await again.close();
});
test('ranking API checks admin role, request shape and returns concrete preview/delivery state',async()=>{
 const f=fixture();const handle=require('./admin-accounts.cjs').createAdmin({db:f.db,ultimateBPRanking:f.board,body:async req=>req.data});async function call(method,data,role='admin'){let result;await handle({method,data},{},'/auth/admin/ultimate-bp/ranking',{account:{role,_id:id(90)}},(status,value)=>result={status,value});return result;}
 assert.equal((await call('GET',null,'player')).status,403);assert.equal((await call('POST',{})).status,400);const preview=(await call('GET')).value;assert.equal(preview.rows.length,3);assert.equal((await call('POST',{revision:preview.revision})).value.settlement.delivered,3);assert.equal((await call('POST',{revision:preview.revision})).value.settlement.delivered,3);await f.board.close();
});

test('offline reward delivery replays interrupted Myoboku/Ultimate BP/Arena snapshots before adding its protected mail',async()=>{
 for(const kind of ['myobokuPending','ultimateBPPending','arena']){
  const f=fixture([7000]);const pending={roleIdHi:1,roleIdLo:1,karakter:{anaId:11100005,nick:'Recovered'},ultimateBP:{claims:[1,0,0,0,0],heroes:[]}};
  if(kind==='arena')f.players[0].files['arena-reward-pending.json']=JSON.stringify({account:{ultimateBP:{pieces:7000}},player:pending});else f.players[0].files['veri.json']=JSON.stringify({ultimateBP:{pieces:7000},[kind]:pending});
  const v=await f.board.view();assert.equal(v.rows[0].name,'Recovered');await f.board.award(v.revision,'admin');const files=f.players[0].files,state=JSON.parse(files['oyuncu.json']);assert.equal(state.ultimateBP.claims[0],0);assert.equal(state.posta.gelen.length,1);assert.equal(JSON.parse(files['veri.json'])[kind],undefined);assert.equal(files['arena-reward-pending.json'],undefined);await f.board.close();
 }
});

test('successful payout resets all players including below threshold and outside Top 50, clears remainder and gift cycles, preserves mail and heroes',async()=>{
 const f=fixture([...Array.from({length:51},(_,i)=>10000-i),123,0]);
 for(const player of f.players){const v=JSON.parse(player.files['veri.json']);v.ultimateBP.remainder=9;v.ultimateBP.spent=v.ultimateBP.pieces*10+9;player.files['veri.json']=JSON.stringify(v);const d=JSON.parse(player.files['oyuncu.json']);d.ultimateBP={claims:[2,1,0,0,0],heroes:[11150037]};player.files['oyuncu.json']=JSON.stringify(d);}
 const preview=await f.board.view(),result=await f.board.award(preview.revision,'admin');assert.equal(result.settlement.resetComplete,true);assert.equal(result.settlement.resetDone,53);assert.equal(result.rows.length,0);
 for(const player of f.players){const v=JSON.parse(player.files['veri.json']),d=JSON.parse(player.files['oyuncu.json']);assert.equal(v.ultimateBP.pieces,0);assert.equal(v.ultimateBP.remainder,0);assert.deepEqual(d.ultimateBP.claims,[0,0,0,0,0]);assert.deepEqual(d.ultimateBP.heroes,[11150037]);}
 assert.equal(JSON.parse(f.players[0].files['oyuncu.json']).posta.gelen.length,1);await f.board.close();
});
test('reset receipts survive retries; a new round has unique payouts and archives previous ranking',async()=>{
 const f=fixture([6000,100]);const first=await f.board.view();await f.board.award(first.revision,'admin');const player=f.players[0],v=JSON.parse(player.files['veri.json']);require('./sunucu/ultimate-bp-spending').earn(v,60000);player.files['veri.json']=JSON.stringify(v);
 const d=JSON.parse(player.files['oyuncu.json']);assert.equal(rules.reset(d,v,rules.ID+':reset:1'),false);assert.equal(v.ultimateBP.pieces,6000);await f.board.award(first.revision,'admin');assert.equal(JSON.parse(player.files['veri.json']).ultimateBP.pieces,6000);
 const second=await f.board.view();const result=await f.board.award(second.revision,'admin');assert.equal(result.settlement.round,2);assert.equal(result.settlement.resetComplete,true);assert.ok(f.documents.has(rules.ID+':history:1'));assert.equal(JSON.parse(player.files['oyuncu.json']).posta.gelen.length,2);assert.equal(JSON.parse(player.files['veri.json']).ultimateBP.pieces,0);await f.board.close();
});

test('reset starts only after every reward is saved; interrupted online reset resumes without wiping newly earned pieces',async()=>{
 const runtimes=new Map(),f=fixture([7000,200],{runtimes});const dir=path.join(f.directory,id(1).toHexString());fs.mkdirSync(dir);for(const [name,value]of Object.entries(f.players[0].files))fs.writeFileSync(path.join(dir,name),value);
 const child=new EventEmitter();child.connected=true;child.send=(m,callback)=>{if(callback)callback();if(m.type==='ultimate-bp-ranking')return;const d=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json'))),v=JSON.parse(fs.readFileSync(path.join(dir,'veri.json')));if(m.type==='ultimate-bp-rank-reset')rules.reset(d,v,m.payout.id);else rules.enqueue(d,m.payout);fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(v));fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(d));setImmediate(()=>child.emit('message',{type:'ultimate-bp-rank-mail-ack',id:m.payout.id}));};runtimes.set(id(1).toHexString(),{child,dir});await f.board.close();let saves=0;
 const board=createRanking(f.db,{runtimes,directory:f.directory,snapshot:f.snapshot,intervalMs:0,save:async()=>{if(++saves===2)throw Error('reset sync interrupted');f.players[0].files=f.snapshot(dir);}});
 const preview=await board.view(),result=await board.award(preview.revision,'admin');assert.equal(result.settlement.status,'resetting');assert.equal(result.settlement.delivered,1);assert.equal(result.settlement.resetComplete,false);assert.equal(JSON.parse(f.players[1].files['veri.json']).ultimateBP.pieces,0);
 const v=JSON.parse(fs.readFileSync(path.join(dir,'veri.json')));require('./sunucu/ultimate-bp-spending').earn(v,100);fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(v));await board.close();
 const restart=createRanking(f.db,{runtimes,directory:f.directory,snapshot:f.snapshot,intervalMs:0,save:async()=>{f.players[0].files=f.snapshot(dir);}});await restart.refresh();assert.equal(f.settlement.resetComplete,true);assert.equal(JSON.parse(f.players[0].files['veri.json']).ultimateBP.pieces,10);assert.equal(JSON.parse(f.players[0].files['oyuncu.json']).posta.gelen.length,1);await restart.close();
});
