'use strict';
const {test}=require('node:test');
const assert=require('node:assert/strict');
const {EventEmitter}=require('node:events');
const {createLadder}=require('./arena-ladder.cjs');
const {createRoster}=require('./arena-roster.cjs');
const {createClient}=require('./sunucu/arena-result-rpc');
const {createFight}=require('./sunucu/arena-fight');

// Model Mongo's atomic revision predicate; all tests use isolated in-memory data.
function database() {
  const tables=new Map();let failWrite=false;
  return {tables,failNextWrite(){failWrite=true;},collection(name){
    if(!tables.has(name))tables.set(name,new Map());const docs=tables.get(name);
    return {
      find(){return {async toArray(){return [...docs.values()];}};},
      async findOne(query,options={}) {
        if(query._id)return structuredClone(docs.get(query._id)||null);
        const rows=[...docs.values()].filter(d=>d.releasedAt<=query.releasedAt.$lte).sort((a,b)=>b.releasedAt-a.releasedAt);
        return structuredClone(rows[0]||null);
      },
      async updateOne(query,update,options={}) {
        if(failWrite && update.$set){failWrite=false;throw Error('simulated storage failure');}
        const old=docs.get(query._id);
        if(old && query.revision!==undefined && old.revision!==query.revision)return {matchedCount:0};
        if(!old){
          if(!options.upsert)return {matchedCount:0};
          docs.set(query._id,{_id:query._id,...structuredClone(update.$setOnInsert||{}),...structuredClone(update.$set||{})});
          return {matchedCount:0,upsertedCount:1};
        }
        Object.assign(old,structuredClone(update.$set||{}));return {matchedCount:1};
      },
    };
  }};
}
const rows=()=>['a','b','c','d'].map((accountId,i)=>({accountId,level:100-i}));
const order=result=>result.rows.map(r=>r.accountId);
const battle=(accountId,opponentId,id='battle-1',won=true)=>({accountId,opponentId,id,won});

test('Winning against a higher rank atomically exchanges both ranks; losses and lower-rank wins do not',async()=>{
  const db=database(),apply=createLadder(db);await apply(rows());
  let result=await apply(rows(),battle('d','b'));assert.deepEqual(order(result),['a','d','c','b']);assert(result.promoted);
  result=await apply(rows(),battle('a','b','lower'));assert(!result.promoted);assert.deepEqual(order(result),['a','d','c','b']);
  result=await apply(rows(),battle('c','a','loss',false));assert.deepEqual(order(result),['a','d','c','b']);
  assert.deepEqual([...result.rows.map(r=>r.ranking)],[1,2,3,4]);
});
test('Rank survives refresh, level changes, restart and new stronger accounts',async()=>{
  const db=database();let apply=createLadder(db);await apply(rows(),battle('d','a'));
  const changed=rows().reverse().map(r=>({...r,level:r.accountId==='a'?999:1}));
  for(let i=0;i<3;i++)assert.deepEqual(order(await apply(changed)),['d','b','c','a']);
  apply=createLadder(db);assert.deepEqual(order(await apply([{accountId:'new',level:9999},...changed])),['d','b','c','a','new']);
});
test('Offline/snapshot-missing accounts retain their rank; deleted accounts are removed',async()=>{
  const db=database(),apply=createLadder(db);await apply(rows(),battle('d','a'));
  const online=rows().filter(r=>r.accountId!=='d');
  const partial=await apply(online,null,['a','b','c','d']);assert.equal(partial.rows.find(r=>r.accountId==='b').ranking,2);
  assert.deepEqual(order(await apply(rows())),['d','b','c','a']);
  assert.deepEqual(order(await apply(rows().filter(r=>r.accountId!=='b'))),['d','c','a']);
});
test('Concurrent parent instances use CAS without duplicate or lost ranks',async()=>{
  const db=database(),one=createLadder(db),two=createLadder(db);await one(rows());
  await Promise.all([one(rows(),battle('d','a','race-1')),two(rows(),battle('c','b','race-2'))]);
  assert.deepEqual(order(await one(rows())),['d','c','b','a']);
});
test('Repeated results do not swap a player back, conflicting or invalid results are rejected',async()=>{
  const db=database(),apply=createLadder(db);const win=battle('d','a');await apply(rows(),win);
  const again=await apply(rows(),win);assert(again.duplicate);assert.deepEqual(order(again),['d','b','c','a']);
  await assert.rejects(apply(rows(),{...win,won:false}),/conflict/);
  for(const invalid of [battle('a','a'),battle('unknown','a'),battle('d','a','bad','true'),battle('d','a','')])await assert.rejects(apply(rows(),invalid),/Invalid/);
  assert.deepEqual(order(await apply(rows())),['d','b','c','a']);
});
function rosterFixture(db) {
  const messages={a:[],d:[]},runtimes=new Map(Object.keys(messages).map(id=>[id,{child:{connected:true,send(message,cb){messages[id].push(structuredClone(message));if(cb)cb();}}}]));
  const id=value=>({toHexString:()=>value});
  const accounts=db.collection('accounts'),players=db.collection('players');
  rows().forEach(row=>{db.tables.get('accounts').set(row.accountId,{_id:id(row.accountId)});db.tables.get('players').set(row.accountId,{_id:id(row.accountId),row});});
  return {messages,create:()=>createRoster(db,runtimes,()=>{throw Error('unexpected account disk access');},{intervalMs:0,buildRow:player=>({...player.row})})};
}
test('Shared roster publishes both changed ranks, refresh/restart retain them, reward snapshot is unchanged',async()=>{
  const db=database(),fixture=rosterFixture(db);let roster=fixture.create();
  try{
    await roster.refresh();const settled=structuredClone([...db.tables.get('arenaSettlements').values()]);
    const result=await roster.recordResult('d',battle('spoofed','a'));assert.equal(result.ranking,1);assert.equal(result.opponentRanking,4);
    for(const id of ['a','d'])assert.deepEqual(fixture.messages[id].at(-1).rows.map(r=>r.accountId),['d','b','c','a']);
    await roster.refresh();assert.deepEqual([...db.tables.get('arenaSettlements').values()],settled,'Live wins must not rewrite released rewards');
    await roster.close();roster=fixture.create();await roster.refresh();assert.equal(fixture.messages.a.at(-1).rows.find(r=>r.accountId==='a').ranking,4);
  }finally{await roster.close();}
});
test('Worker IPC commits only after authoritative parent acknowledgment, including failures/disconnect',async()=>{
  const channel=new EventEmitter();channel.connected=true;let sent;
  channel.send=(message,cb)=>{sent=message;cb();};const commit=createClient(channel,100);
  const request=commit('opponent',true);assert.equal(sent.type,'arena-result');assert.equal(sent.opponentId,'opponent');assert(!('accountId' in sent));
  channel.emit('message',{type:'arena-result-ack',id:'unrelated',result:{ranking:99}});
  channel.emit('message',{type:'arena-result-ack',id:sent.id,result:{ranking:1}});assert.equal((await request).ranking,1);
  const rejected=commit('opponent',false);channel.emit('message',{type:'arena-result-ack',id:sent.id,error:'storage unavailable'});await assert.rejects(rejected,/storage/);
  const disconnected=commit('opponent',true);channel.emit('disconnect');await assert.rejects(disconnected,/disconnected/);
  channel.connected=false;await assert.rejects(commit('opponent',true),/unavailable/);
});
test('Native battle packet follows durable commit, includes new ranking and refuses overlapping challenges',async()=>{
  const packets=[],events=[];let release,fail=false;
  const arena={selected:()=>({accountId:'target'}),frames:()=>[{id:1,payload:Buffer.from([42])},{id:2,payload:Buffer.from([9]),won:true}],
    async commit(id,won){events.push(['commit',id,won]);if(fail)throw Error('storage unavailable');await new Promise(resolve=>{release=resolve;});}};
  const fight=createFight({arena,kodek:{OP:{REPORT:1,RESULT:2}},load:()=>({}),save:()=>events.push('save'),count:()=>events.push('count'),refresh:()=>Buffer.from([1])});
  const session={send(id,payload){packets.push({id,payload});}};
  const first=fight(session,Buffer.alloc(9));assert.equal(packets.length,0);assert.deepEqual(events[0],['commit','target',true]);
  await assert.rejects(fight(session,Buffer.alloc(9)),/đang được xử lý/);release();await first;
  assert.deepEqual(packets.map(p=>p.id),[0x01181904,0x01181907,0x01181906]);assert.equal(packets[0].payload.readUInt32BE(),0);assert.deepEqual([...packets[0].payload.subarray(4)],[9,42]);
  fail=true;packets.length=0;await assert.rejects(fight(session,Buffer.alloc(9)),/storage/);assert.equal(packets.length,0);
});
test('A failed database write cannot move either rank',async()=>{
  const db=database(),apply=createLadder(db);await apply(rows());db.failNextWrite();await assert.rejects(apply(rows(),battle('d','a')),/storage/);
  assert.deepEqual(order(await createLadder(db)(rows())),['a','b','c','d']);
});
test('A secondary counter failure does not reject an already committed rank change',async()=>{
  const packets=[];
  const arena={selected:()=>({accountId:'target'}),frames:()=>[{id:1,payload:Buffer.alloc(0)},{id:2,payload:Buffer.alloc(0),won:true}],commit:async()=>({ranking:1})};
  const fight=createFight({arena,kodek:{OP:{REPORT:1,RESULT:2}},load:()=>({}),count:()=>{},save:()=>{throw Error('simulated counter failure');},refresh:()=>Buffer.alloc(0)});
  await fight({send:id=>packets.push(id)},Buffer.alloc(9));assert.deepEqual(packets,[0x01181904,0x01181907,0x01181906]);
});
