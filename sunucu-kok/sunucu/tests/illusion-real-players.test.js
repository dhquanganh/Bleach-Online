'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const {database,A,B,identity}=require('./illusion-test-db.cjs');
const {createBoard,end,day}=require('../../illusion-board.cjs');
const event=require('../infinite-illusion'),mail=require('../boss-reward-mail'),env=require('../envanter');
test('Two account services share real scores; legacy bots disappear; offline rewards are claimable exactly once',async()=>{
 const temp=fs.mkdtempSync(path.join(os.tmpdir(),'aizen-real-'));let time=1791700000,sequence=0,damage=100,calls=0;
 const board=createBoard(database(),{now:()=>time,intervalMs:0});
 function player(id){
  const currencyFile=path.join(temp,id+'.json');fs.writeFileSync(currencyFile,JSON.stringify({altin:100}));
  const d={nick:identity(id).name,infiniteIllusion:{day:day(time),entries:{'bot:42':{id:'bot:42',bot:true,damage:999999}},payouts:[],nextBot:time}};
  const ctx={durum:d,payload:Buffer.from([0]),kaydet:()=>{}};
  const service=event.service({now:()=>time,currencyFile,request:(action,data={})=>board.request(id,identity(id),{action,...data,id:String(++sequence)}),simulate:()=>{calls++;return {damage,payload:Buffer.from('report'),won:false};}});
  return {d,ctx,service,currencyFile};
 }
 try{
  const a=player(A),b=player(B);await a.service.tick(a.ctx);assert.deepEqual(a.d.infiniteIllusion.entries,{});assert(!('nextBot' in a.d.infiniteIllusion));assert.equal(calls,0);
  assert(!(await a.service.fight(a.ctx)).error);damage=500;assert(!(await b.service.fight(b.ctx)).error);
  await a.service.tick(a.ctx);const packet=a.service.packet(a.d),length=packet.readUInt16BE(0),view=JSON.parse(packet.subarray(2,2+length).toString());
  assert.deepEqual(view.rows.map(r=>r.name),['Real B','Real A']);assert.equal(view.mine.rank,2);
  assert.equal((await a.service.fight(a.ctx)).error,1);assert.equal(calls,2);
  a.ctx.payload=Buffer.from([2]);assert.equal((await a.service.fight(a.ctx)).error,4);assert.equal(calls,2);
  time=end(day(time));await board.refresh();await a.service.tick(a.ctx);assert.equal(a.d.infiniteIllusion.payouts[0].rank,2);
  assert.equal(a.d.posta.gelen.length,1);assert.equal(b.d.posta,undefined,'Offline account receives its reward on reconnect');
  await b.service.tick(b.ctx);await b.service.tick(b.ctx);assert.equal(b.d.posta.gelen.length,1);
  const letter=b.d.posta.gelen[0];assert.equal(JSON.parse(fs.readFileSync(b.currencyFile)).altin,100);
  assert(!mail.claim(b.ctx,[[letter.hi,letter.lo]],b.currencyFile).error);
  assert.equal(JSON.parse(fs.readFileSync(b.currencyFile)).altin,8100);assert.equal(env.mevcut(b.d,event.config.stoneItemId),800);
  await b.service.tick(b.ctx);mail.claim(b.ctx,[[letter.hi,letter.lo]],b.currencyFile);
  assert.equal(JSON.parse(fs.readFileSync(b.currencyFile)).altin,8100);assert.equal(env.mevcut(b.d,event.config.stoneItemId),800);
 }finally{await board.close();fs.rmSync(temp,{recursive:true,force:true});}
});
