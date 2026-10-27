'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),{randomUUID}=require('node:crypto'),{EventEmitter}=require('node:events');
const {createBoard,seasonAt,transfer}=require('./cross-scoreboard.cjs');
const {createClient}=require('./sunucu/cross-score-rpc');
function fixture(initial={low:100,high:400,equal:100}){
  let time=1791530000,fail=false;const docs=new Map();
  const accounts=Object.keys(initial).map(id=>({_id:{toHexString:()=>id}}));
  const players=accounts.map(a=>({_id:a._id,files:{'oyuncu.json':JSON.stringify({crossServer:{season:seasonAt(time),score:initial[a._id.toHexString()]}})}}));
  const db={collection(name){
    if(name==='accounts'||name==='players')return {find:()=>({toArray:async()=>name==='accounts'?accounts:players})};
    assert.equal(name,'cross_scoreboards');
    return {findOne:async q=>structuredClone(docs.get(q._id)||null),insertOne:async d=>{if(docs.has(d._id))throw Object.assign(Error('duplicate'),{code:11000});docs.set(d._id,structuredClone(d));},
      updateOne:async(q,u)=>{if(fail){fail=false;throw Error('disk unavailable');}const d=docs.get(q._id);if(d.revision!==q.revision)return {matchedCount:0};Object.assign(d,structuredClone(u.$set));return {matchedCount:1};}};
  }};
  const updates=[],options={now:()=>time,onUpdate:b=>updates.push(structuredClone(b))};
  return {db,options,players,updates,board:createBoard(db,options),fail:()=>{fail=true;},advance:()=>{time+=8*86400;},season:()=>seasonAt(time)};
}
const result=(f,opponentId,won=true,id=randomUUID())=>({id,opponentId,won,season:f.season()});
test('A lower or equal-score attacker winning receives 30 points',async()=>{
  const f=fixture(),b=f.board;
  assert.deepEqual((await b.snapshot()).scores,{low:100,high:400,equal:100});
  assert.equal((await b.settle('high',result(f,'low'))).amount,0);
  assert.equal((await b.settle('low',result(f,'high',false))).amount,0);
  assert.equal((await b.settle('high',result(f,'low',false))).amount,0);
  assert.equal((await b.settle('low',result(f,'equal'))).amount,30);
  const won=await b.settle('low',result(f,'high'));
  assert.equal(won.amount,30);assert.deepEqual(won.scores,{low:160,high:370,equal:70});
  assert.equal(Object.values(won.scores).reduce((a,b)=>a+b),600,'no points created or destroyed');
});
test('Retry, restart and stale online/offline account files cannot apply a result twice',async()=>{
  const f=fixture(),request=result(f,'high');
  await f.board.settle('low',request);
  const restarted=createBoard(f.db,f.options),duplicate=await restarted.settle('low',request);
  assert(duplicate.duplicate);assert.equal(duplicate.scores.low,130);assert.equal(duplicate.scores.high,370);
  for(const p of f.players)p.files['oyuncu.json']=JSON.stringify({crossServer:{season:f.season(),score:999999}});
  assert.deepEqual((await restarted.snapshot()).scores,{low:130,high:370,equal:100});
});
test('Concurrent challenges serialize against current scores, equal-score wins count and higher-score wins stop transferring',async()=>{
  const f=fixture({low:100,high:160});
  await Promise.all(Array.from({length:5},()=>f.board.settle('low',result(f,'high'))));
  assert.deepEqual((await f.board.snapshot()).scores,{low:160,high:100});
});
test('Both scores commit together; storage failure can safely retry the same battle',async()=>{
  const f=fixture();await f.board.snapshot();f.fail();const request=result(f,'high');
  await assert.rejects(f.board.settle('low',request),/disk/);
  assert.deepEqual((await f.board.snapshot()).scores,{low:100,high:400,equal:100});
  assert.equal((await f.board.settle('low',request)).amount,30);
  await assert.rejects(f.board.settle('low',result(f,'low')),/unavailable/);
  await assert.rejects(f.board.settle('low',result(f,'missing')),/unavailable/);
});
test('New seasons reset authoritative scores and reject an old pending result',async()=>{
  const f=fixture(),request=result(f,'high');await f.board.settle('low',request);f.advance();
  assert.deepEqual((await f.board.snapshot()).scores,{low:0,high:0,equal:0});
  await assert.rejects(f.board.settle('low',request),/season ended/);
  assert.equal(transfer(0,10,true),30,'winner receives the full reward even below 30');
});
test('Worker RPC uses the durable battle ID, handles duplicate in-flight requests and storage errors',async()=>{
  const channel=new EventEmitter();channel.connected=true;const sent=[];channel.send=(m,cb)=>{sent.push(m);cb?.();};
  const commit=createClient(channel,100),message={id:randomUUID(),opponentId:'high',won:true,season:5};
  const promise=commit(message);assert.equal(commit(message),promise);assert.equal(sent.length,1);
  assert.deepEqual(sent[0],{type:'cross-score-result',...message});assert(!('accountId' in sent[0]));
  channel.emit('message',{type:'cross-score-ack',id:message.id,result:{amount:30}});assert.equal((await promise).amount,30);
  const failed=commit({...message,id:randomUUID()});channel.emit('disconnect');await assert.rejects(failed,/disconnected/);
});

test('Equal zero and low-score wins award 30 while the loser is floored at zero',async()=>{
  for(const [a,b] of [[0,0],[0,10],[10,10],[10,20]]){
    const f=fixture({low:a,high:b}),request=result(f,'high');
    const won=await f.board.settle('low',request);
    assert.equal(won.amount,30);assert.equal(won.scores.low,a+30);
    assert.equal(won.scores.high,0);
    const retry=await f.board.settle('low',request);
    assert(retry.duplicate);assert.deepEqual(retry.scores,won.scores);
  }
});
