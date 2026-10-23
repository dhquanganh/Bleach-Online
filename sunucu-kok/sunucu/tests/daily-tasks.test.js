'use strict';
const assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-daily-'));process.env.BLEACH_ACCOUNT_DIR=dir;
for(const name of ['veri.json','oyuncu.json'])fs.copyFileSync(path.join(__dirname,'..',name),path.join(dir,name));
const task=require('../daily-tasks'),p=require('../paket'),env=require('../envanter'),events=require('../olay');
try{
 let account={level:159,kupon:1000,altin:1000},d={},saved={},canPay=true,saveFail=false;
 const packets=[],costs=[],grants=[],refunds=[];
 const H=task.kur({dailyTaskAccount:()=>account,seviye:{anaDurum:a=>({lv:a.level})},ekSonra:(id,payload)=>packets.push({id,payload}),paraHarca:list=>{if(!canPay)return null;costs.push(list);return Buffer.from([1]);},paraIcinOdul:list=>refunds.push(list),odulVer:(d,list)=>grants.push(list)});
 const call=(op,payload=Buffer.alloc(0))=>H['0x018120'+op]({durum:d,payload,kaydet:next=>{if(saveFail)throw Error('disk');saved=JSON.parse(JSON.stringify(next));}});
 const req=(id,type)=>new p.Y().u32(id).i8(type).done();
 const ok=b=>assert.equal(b.readUInt32BE(0),0),bad=b=>assert.notEqual(b.readUInt32BE(0),0);
 ok(call('00'));let g=task.state(d);assert.equal(g.tasks.length,5);assert.equal(new Set(g.tasks).size,5);assert.equal(g.targets.length,3);
 const row=p.satir('DailyTask',16300001);assert.equal(row.taskname,'Clear Stage');assert.equal(row.complete,1);assert.equal(row.point,15);
 bad(call('01',req(1,4)));bad(call('01',req(g.tasks[0],3)));bad(call('01',Buffer.alloc(4)));bad(call('03',new p.Y().u32(50).done()));
 // Progress only counts authoritative actions after accepting, and active tasks cannot be replaced.
 g.tasks=[16300002,16300005,16300009,16300013,16300017];events.say(d,'instancePass',100);
 ok(call('01',req(16300002,1)));bad(call('01',req(16300005,1)));bad(call('01',req(16300002,3)));
 events.say(d,'arenaFight',20);assert.equal(task.progress(d,()=>account).prog,0);
 events.say(d,'instancePass',1);assert.equal(task.state(d).prog,1);bad(call('01',req(16300002,3)));
 events.say(d,'instancePass',1);assert.equal(task.state(d).prog,2);assert(events.pushAl().some(p=>p.id===0x01182005));
 ok(call('01',req(16300002,3)));g=task.state(d);assert.equal(g.finish,1);assert.equal(g.point,15);assert.equal(g.tasks.length,5);bad(call('01',req(16300002,3)));assert.equal(events.gunlukOku(d,'dailyPoints'),15);
 // Refresh is free once, then costs the configured 10, and is atomic on payment/save failure.
 ok(call('02'));assert.equal(costs.length,0);const previous=JSON.stringify(d);canPay=false;bad(call('02'));assert.equal(JSON.stringify(d),previous);canPay=true;saveFail=true;bad(call('02'));assert.equal(JSON.stringify(d),previous);assert.equal(refunds.length,1);saveFail=false;ok(call('02'));assert.deepEqual(costs.at(-1),[{type:0,code:2,amount:10}]);
 // Ten natural completions reach at least 150 points, with a replenished list.
 while(task.state(d).finish<10){g=task.state(d);const id=g.tasks.find(id=>task.KEYS[p.satir('DailyTask',id).eventType]);const r=p.satir('DailyTask',id);ok(call('01',req(id,1)));events.say(d,task.KEYS[r.eventType],r.complete);ok(call('01',req(id,3)));}
 g=task.state(d);assert(g.point>=150);bad(call('01',req(g.tasks[0],1)));bad(call('02'));
 // Current level tier only, in order, each milestone exactly once.
 const tier=p.tablo('DailyAward').liste.filter(r=>r.level1===140).sort((a,b)=>a.mark-b.mark);
 bad(call('03',new p.Y().u32(tier[9]._id).done()));bad(call('03',new p.Y().u32(1).done()));
 g.double=1;const gems=env.mevcut(d,14900001);
 for(const r of tier){ok(call('03',new p.Y().u32(r._id).done()));bad(call('03',new p.Y().u32(r._id).done()));}
 assert.equal(env.mevcut(d,14900001)-gems,100,'150-point reward is exactly 100 inventory Primogems, even with Double Reward');
 assert(packets.some(x=>x.id===0x01180f00));assert.equal(task.state(d).mask,1023);
 assert.equal(task.state(saved).mask,1023,'claims survive reconnect');
 // Inventory overflow and disk errors must leave the final claim available.
 task.state(d).mask=511;const old=env.mevcut(d,14900001);env.ekle(d,[{type:1,code:14900001,amount:65535}]);bad(call('03',new p.Y().u32(tier[9]._id).done()));assert.equal(task.state(d).mask,511);
 d.gunlukSayac.gun='2000-01-01';ok(call('00'));g=task.state(d);assert.equal(g.point,0);assert.equal(g.finish,0);assert.equal(g.mask,0);assert.equal(g.double,0);assert.equal(g.cur,0);
 // Paid completion is also validated, charged from configured Instant and never free.
 const id=g.tasks[0];ok(call('01',req(id,1)));canPay=false;bad(call('01',req(id,4)));assert.equal(task.state(d).finish,0);canPay=true;ok(call('01',req(id,4)));assert.equal(task.state(d).finish,1);
 // Exercise the actual registered production handler and persistent inventory delivery.
 const accountPath=path.join(dir,'veri.json');
 const actualAccount=JSON.parse(fs.readFileSync(accountPath));actualAccount.level=159;actualAccount.kupon=1000;actualAccount.altin=1000;fs.writeFileSync(accountPath,JSON.stringify(actualAccount));
 const handlers=require('../handlers'),live={};const liveState=task.state(live);liveState.point=150;liveState.mask=511;liveState.double=1;
 const beforeLive=env.mevcut(live,14900001);
 const response=handlers.byReq['0x01812003']({durum:live,payload:new p.Y().u32(50).done(),kaydet:next=>fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(next))});
 ok(response);const persisted=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json')));
 assert.equal(env.mevcut(persisted,14900001)-beforeLive,100);assert.equal(task.state(persisted).mask,1023);
 assert(handlers.ekAl().sonra.some(packet=>packet.id===0x01180f00));
 handlers.paraHarca([{type:0,code:2,amount:10}]);
 assert.equal(JSON.parse(fs.readFileSync(accountPath)).dailyTaskSpending.count,1);
 console.log('PASS Daily Tasks: authoritative progress, 10/day, refresh and save rollback, tier/order/idempotency, exact 100 Primogems, overflow and daily reset');
}finally{fs.rmSync(dir,{recursive:true,force:true});}
