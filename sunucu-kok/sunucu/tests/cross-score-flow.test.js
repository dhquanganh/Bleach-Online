'use strict';
const assert=require('node:assert/strict');
const {Y,O}=require('../paket'),cross=require('../cross-server'),players=require('../cross-server-players');
const {transfer}=require('../../cross-scoreboard.cjs');
const previous=process.env.BLEACH_ACCOUNT_ID;process.env.BLEACH_ACCOUNT_ID='point-self';
(async()=>{
  const now=1791530000,season=Math.floor(Math.floor((now+25200)/86400)/cross.config.seasonDays);
  let revision=100;
  for(const [ownScore,opponentScore,won,expected] of [[100,400,true,30],[400,100,true,0],[100,400,false,0],[400,100,false,0],[100,100,true,30],[0,0,true,30],[0,10,true,30]]){
    let disk={karakter:{anaId:11100001},crossServer:{season,score:ownScore}};
    const scores={'point-self':ownScore,'point-opponent':opponentScore};
    players.updateScores({season,revision:revision++,scores:{...scores}});
    players.update([{accountId:'point-opponent',name:'Opponent',crossScore:opponentScore,units:[{id:11100001,pos:1}]}]);
    const requestIds=[];let rejectOnce=true;
    const settleScores=async request=>{
      requestIds.push(request.id);
      if(rejectOnce){rejectOnce=false;throw Error('simulated interruption before durable settlement');}
      const amount=transfer(scores['point-self'],scores['point-opponent'],request.won);
      scores['point-self']+=amount;scores['point-opponent']=Math.max(0,scores['point-opponent']-amount);
      return {season,revision:revision++,scores:{...scores},amount};
    };
    const pushed=[];let notices=0;cross.setNotify(()=>{notices++;});
    const service=cross.kur({ekSonra(id,payload){pushed.push({id,payload});}},{now:()=>now,settleScores,simulate:()=>({won,payload:Buffer.from('report')})});
    const ctx={durum:structuredClone(disk),payload:Buffer.alloc(0),kaydet:d=>{disk=structuredClone(d);},reload:()=>structuredClone(disk)};
    service.handlers['0x01813d05'](ctx);
    ctx.payload=new Y().u8(0).u32(ctx.durum.crossServer.normal[0]).done();
    const result=await service.fight(ctx);assert(!result.error);
    assert.equal(disk.crossServer.score,ownScore,'no unconditional win/loss points');
    assert.equal(disk.crossServer.pendingScores.length,1,'settlement survives interruption');
    const attempts=disk.crossServer.times,history=disk.crossServer.history.length;
    disk.someOtherProgress='keep this';
    await cross.flushScores(ctx,settleScores,()=>now);
    assert.equal(requestIds[0],requestIds[1],'retry uses the same durable battle ID');
    assert.equal(disk.crossServer.pendingScores.length,0);
    assert.equal(disk.crossServer.score,ownScore+expected);
    assert.equal(players.accounts()[0].score,Math.max(0,opponentScore-expected),'all duplicated opponent cards use the same account score');
    assert(players.all().every(row=>row.score===Math.max(0,opponentScore-expected)));
    assert.equal(disk.crossServer.times,attempts);assert.equal(disk.crossServer.history.length,history);
    assert.equal(disk.someOtherProgress,'keep this','score acknowledgment merges into the latest state');
    assert.equal(notices,1,'delayed settlement notifies online clients immediately');
    // The native client requests its records at BattleResult. Its queued refresh
    // must contain authoritative points and ranks without a page reload.
    pushed.length=0;service.handlers['0x01813d0e'](ctx);
    assert.deepEqual(pushed.map(p=>p.id),[cross.OP.LIST,cross.OP.BASE,cross.OP.RANK]);
    const base=new O(pushed.find(p=>p.id===cross.OP.BASE).payload);
    for(let i=0;i<5;i++)base.u32();assert.equal(base.u32(),ownScore+expected,'main panel gets new score');
    const rank=new O(pushed.find(p=>p.id===cross.OP.RANK).payload);const count=rank.u16(),rows=[];
    for(let i=0;i<count;i++)rows.push({rank:rank.u32(),name:rank.utf(),server:rank.utf(),level:rank.u32(),score:rank.u32(),tier:rank.u32()});
    assert.equal(rows.find(r=>r.name==='Opponent').score,Math.max(0,opponentScore-expected));
    assert.equal(rows.find(r=>r.name!=='Opponent').score,ownScore+expected);
    assert.equal(rank.kalan(),0);

    assert.equal(scores['point-self'],ownScore+expected);assert(scores['point-opponent']>=0);
    await cross.flushScores(ctx,settleScores,()=>now);assert.equal(requestIds.length,2);
  }
  cross.setNotify(null);
  console.log('PASS live score/rank packets and Cross battle point flow: win/loss/equal/zero scenarios, both account scores, persistent retry, no repeated attempt/reward and current-state merge.');
})().catch(error=>{console.error(error);process.exitCode=1;}).finally(()=>{if(previous===undefined)delete process.env.BLEACH_ACCOUNT_ID;else process.env.BLEACH_ACCOUNT_ID=previous;});
