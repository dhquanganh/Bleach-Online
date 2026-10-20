'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict');
const {createBoard,day,end}=require('./illusion-board.cjs');
const {database,A,B,identity}=require('./sunucu/tests/illusion-test-db.cjs');
const C='c'.repeat(24);

test('Global real-player best scores, tie ordering, durable cooldown and restart',async()=>{
 const db=database();let time=1791700000,board=createBoard(db,{now:()=>time,intervalMs:0});
 const req=(id,action='info',damage,idempotency='id-'+time)=>board.request(id,identity(id),{action,damage,id:idempotency});
 assert.deepEqual((await req(A)).rows,[]);
 await req(A,'fight',900);await req(B,'fight',500);
 assert.deepEqual((await req(B)).rows.map(r=>[r.name,r.damage]),[['Real A',900],['Real B',500]]);
 assert.equal((await req(A,'fight',1000,'blocked')).error,1,'Central cooldown cannot be bypassed by another connection');
 time+=15;await req(A,'fight',100);assert.equal((await req(A)).mine.damage,900);
 const before=(await req(A)).battles;await req(A,'fight',100,'id-'+time);assert.equal((await req(A)).battles,before,'Repeated commit ID is idempotent');
 time+=15;await req(B,'fight',900);assert.equal((await req(A)).mine.rank,1,'First-achieved tie wins');
 await board.close();board=createBoard(db,{now:()=>time,intervalMs:0});
 assert.equal((await req(B)).mine.rank,2);assert.equal((await req(B)).lastDamage,900);assert.equal((await req(B,'fight',1000,'restart-blocked')).error,1);
 assert((await req(A)).rows.every(r=>r.bot===false));await board.close();
});
test('Midnight freezes rewards atomically before reset, including offline players; restart never pays twice',async()=>{
 const db=database();let time=1791700000,board=createBoard(db,{now:()=>time,intervalMs:0});
 const period=day(time);await board.request(A,identity(A),{action:'fight',damage:900,id:'a'});await board.request(B,identity(B),{action:'fight',damage:1000,id:'b'});
 time=end(period);db.failNext();await assert.rejects(board.request(A,identity(A),{action:'info'}),/database write/);
 assert.equal(db.docs.get(period).status,'open');assert(!db.docs.has(period+1),'Never reset while reward freeze failed');
 const next=await board.request(A,identity(A),{action:'info'});assert.equal(next.day,period+1);assert.deepEqual(next.rows,[]);assert.equal(next.nextFight,0);
 assert.equal(next.payouts[0].rank,2);assert.equal(next.payouts[0].gold,7000);
 const archive=db.docs.get(period);assert.equal(archive.status,'settled');assert.equal(archive.rewards.length,2);assert.equal(archive.rewards[0].accountId,B);
 await board.refresh();await board.refresh();assert.equal(db.docs.get(period).rewards.length,2);
 await board.close();time+=86400*3;board=createBoard(db,{now:()=>time,intervalMs:0});
 const offline=await board.request(B,identity(B),{action:'info'});assert.equal(offline.payouts.length,1);assert.equal(offline.payouts[0].rank,1);assert.equal(offline.payouts[0].stones,800);
 assert.equal(db.docs.get(period).entries[A].damage,900,'Archive remains auditable');await board.close();
});
test('Concurrent servers use revision CAS; invalid damage/storage failures do not fabricate scores',async()=>{
 const db=database();let time=1791700000;const x=createBoard(db,{now:()=>time,intervalMs:0}),y=createBoard(db,{now:()=>time,intervalMs:0});
 await Promise.all([x.request(A,identity(A),{action:'fight',damage:123,id:'a'}),y.request(B,identity(B),{action:'fight',damage:456,id:'b'})]);
 assert.equal((await x.request(A,identity(A),{action:'info'})).rows.length,2);
 for(const damage of [NaN,Infinity,-1])await assert.rejects(x.request(C,identity(C),{action:'fight',damage,id:'bad'}),/Invalid/);
 db.failNext();await assert.rejects(x.request(C,identity(C),{action:'fight',damage:100,id:'disk'}),/database write/);assert.equal((await x.request(C,identity(C),{action:'info'})).mine,null);
 await assert.rejects(x.request('bot:42',identity(C),{action:'fight',damage:100,id:'bot'}),/account/);
 await x.close();await y.close();
});
