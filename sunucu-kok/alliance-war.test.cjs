'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict');
const rules=require('./sunucu/alliance-war'),{satir}=require('./sunucu/paket');
const time=s=>Date.parse(s+'+07:00');
test('campaign refills add five at 12:30 and 18:30, cap ten, and do not refill at midnight',()=>{
 const d={},before=time('2026-10-25T12:29:59');const k=rules.state(d,before);assert.equal(k.pveLeft,10);k.pveLeft=1;
 rules.state(d,time('2026-10-25T12:30:00'));assert.equal(k.pveLeft,6);
 rules.state(d,time('2026-10-25T18:30:00'));assert.equal(k.pveLeft,10);k.pveLeft=2;
 rules.state(d,time('2026-10-26T00:00:00'));assert.equal(k.pveLeft,2);
 rules.state(d,time('2026-10-29T13:00:00'));assert.equal(k.pveLeft,10);
});
test('PvP times use UTC+7 with exclusive closing boundaries and daily reward reset',()=>{
 for(const [t,open] of [['13:44:59',false],['13:45:00',true],['14:44:59',true],['14:45:00',false],['21:00:00',true],['22:00:00',false]])assert.equal(rules.pvpOpen(time('2026-10-25T'+t)),open,t);
 const d={},k=rules.state(d,time('2026-10-25T23:59:59'));k.pvpLeft=0;rules.state(d,time('2026-10-26T00:00:00'));assert.equal(k.pvpLeft,10);
});
test('settlement is idempotent, losses keep PvE attempts, wins unlock hard and deliver one mail',()=>{
 const now=time('2026-10-25T13:00:00'),d={},k=rules.state(d,now),base={id:'loss',at:now,mode:'pve',model:16100101,won:false,reward:false,honor:0,items:[],window:k.pveSlot};
 assert.equal(rules.settle(d,base,now),true);assert.equal(k.pveLeft,10);assert.equal(k.passed.length,0);
 const win={...base,id:'win',won:true,reward:true,honor:20,items:[{id:15850001,amount:1}]};rules.settle(d,win,now);assert.equal(k.pveLeft,9);assert.equal(rules.honor(d),20);assert.equal(d.posta.gelen.length,1);assert.ok(k.passed.includes(16100101));assert.equal(rules.settle(d,win,now),false);assert.equal(k.pveLeft,9);assert.equal(d.posta.gelen.length,1);
 rules.settle(d,{...win,id:'no-quota',reward:false,honor:0,items:[]},now);assert.equal(k.pveLeft,9);
});
test('delayed results debit the original window before applying a due refill',()=>{
 const before=time('2026-10-25T12:29:59'),after=time('2026-10-25T12:30:01'),d={},k=rules.state(d,before);k.pveLeft=4;
 rules.settle(d,{id:'boundary',at:before,mode:'pve',model:16100101,won:true,reward:true,honor:20,items:[],window:k.pveSlot},after);assert.equal(k.pveLeft,8);
 const delayed={},reserved=rules.state(delayed,before);reserved.pveLeft=4;const window=reserved.pveSlot;rules.state(delayed,after);assert.equal(reserved.pveLeft,9);
 rules.settle(delayed,{id:'native-advanced',at:before,mode:'pve',model:16100101,won:true,reward:true,honor:20,items:[],window,remaining:4},after);assert.equal(reserved.pveLeft,8);
});
test('Honor shop enforces unlock, daily quota, finite stock and valid quantities',()=>{
 const now=time('2026-10-25T13:00:00'),row=satir('Mall',11107001),d={etkinlikSavas:{onur:1500}};rules.state(d,now);
 assert.equal(rules.validateShop(d,row,1,50,now),true);assert.equal(rules.validateShop(d,row,1,49,now),false);assert.equal(rules.validateShop(d,row,0,50,now),false);assert.equal(rules.validateShop(d,row,1.5,50,now),false);assert.equal(rules.validateShop(d,row,3,50,now),false);
 d.allianceWar.shopCount=2;assert.equal(rules.validateShop(d,row,1,50,now),false);rules.state(d,time('2026-10-26T00:00:00'));assert.equal(d.allianceWar.shopCount,0);d.etkinlikSavas.onur=1499;assert.equal(rules.validateShop(d,row,1,50,now),false);
});
function database(){const rows=[];return {rows,collection(){return {find(q){return {sort(){return this;},async toArray(){return rows.filter(r=>r.players.some(p=>p.accountId===q['players.accountId'])&&!r.delivered.includes(q.delivered.$ne));}};},async insertOne(row){rows.push(structuredClone(row));},async updateOne(q,u){const row=rows.find(r=>r._id===q._id);if(!row.delivered.includes(u.$addToSet.delivered))row.delivered.push(u.$addToSet.delivered);},async findOne(q){return rows.find(r=>r._id===q._id&&r.players.some(p=>p.accountId===q['players.accountId']));}};}};}
test('global rooms validate password, capacity, leader, ready state and real PvP opponents',async()=>{
 const db=database(),runtimes=new Map(),states=new Map(),now=time('2026-10-25T13:50:00');let war,simulationCount=0;
 for(const id of ['a','b','c','d']){const d={},k=rules.state(d,now);states.set(id,d);runtimes.set(id,{child:{connected:true,send(message,cb){cb?.();queueMicrotask(()=>{let result,error;try{if(message.action==='snapshot')result={name:id,units:[{id:11100005}],...rules.view(d,80,1000,now),pveSlot:k.pveSlot,pvpDay:k.pvpDay};if(message.action==='simulate'){simulationCount++;result={won:true,rightWon:false,battles:[]};}if(message.action==='settle'){rules.settle(d,message.data,now);result={ok:true};}}catch(e){error=e.message;}war.receive(id,{type:'alliance-war-ack',requestId:message.requestId,result,error});});}}});}
 war=require('./alliance-war.cjs').createWar(db,{runtimes,now:()=>now});
 try{
  await war.request('a','create',{mode:'pve',model:16100101,password:'secret'});const room=(await war.request('a','view')).room;
  await assert.rejects(war.request('b','join',{roomId:room.id,password:'bad'}),/mật khẩu/);await war.request('b','join',{roomId:room.id,password:'secret'});
  await assert.rejects(war.request('b','start'),/đội trưởng/);await assert.rejects(war.request('a','start'),/sẵn sàng/);
  await war.request('c','join',{roomId:room.id,password:'secret'});await assert.rejects(war.request('d','join',{roomId:room.id,password:'secret'}),/chỗ trống/);
  await war.request('b','ready',{ready:true});await war.request('c','ready',{ready:true});await war.request('a','start');assert.equal(simulationCount,1);assert.equal(db.rows.length,1);assert.equal(db.rows[0].delivered.length,3);assert.equal(rules.honor(states.get('b')),20);
  for(const id of ['a','b','c'])await war.request(id,'leave');
  const first=await war.request('a','auto',{mode:'pvp'});assert.equal(first.waiting,true);assert.equal(simulationCount,1,'no bot fight while queue is empty');await war.request('b','auto',{mode:'pvp'});assert.equal(simulationCount,2);assert.equal(db.rows.length,2);assert.equal(rules.state(states.get('a'),now).pvpLeft,9);assert.equal(rules.state(states.get('b'),now).pvpLeft,9);
 }finally{war.close();}
});
module.exports={database};
test('pending rewards survive coordinator restart and are never marked delivered before player persistence succeeds',async()=>{
 const db=database(),now=time('2026-10-25T13:50:00'),d={},k=rules.state(d,now),result={accountId:'recover',id:'restart-reward',at:now,mode:'pve',model:16100101,won:true,reward:true,honor:20,items:[{id:15850001,amount:1}],window:k.pveSlot,remaining:10};
 db.rows.push({_id:result.id,at:now,players:[result],reports:[],delivered:[]});let war,fail=true;
 const runtimes=new Map([['recover',{child:{connected:true,send(message,cb){cb?.();queueMicrotask(()=>{rules.settle(d,message.data,now);war.receive('recover',{type:'alliance-war-ack',requestId:message.requestId,result:{ok:true}});});}}}]]);
 const deps={runtimes,now:()=>now,persist:async()=>{if(fail)throw Error('temporary Mongo write failure');}};
 war=require('./alliance-war.cjs').createWar(db,deps);await assert.rejects(war.resume('recover'),/Mongo/);assert.deepEqual(db.rows[0].delivered,[]);assert.equal(d.posta.gelen.length,1);war.close();
 fail=false;war=require('./alliance-war.cjs').createWar(db,deps);
 try{await war.resume('recover');await war.resume('recover');assert.deepEqual(db.rows[0].delivered,['recover']);assert.equal(d.posta.gelen.length,1);assert.equal(rules.honor(d),20);assert.equal(rules.state(d,now).pveLeft,9);}finally{war.close();}
});
test('real isolated game workers fight, deliver durable rewards, reject old fake starts and buy items atomically',{timeout:90000},async()=>{
 const fs=require('node:fs'),os=require('node:os'),path=require('node:path'),net=require('node:net'),{fork}=require('node:child_process'),{Y,O}=require('./sunucu/paket'),{frame,parseStream}=require('./sunucu/cerceve');
 const root=fs.mkdtempSync(path.join(os.tmpdir(),'alliance-live-')),runtimes=new Map(),children=[],sockets=[],db=database();
 const wait=ms=>new Promise(resolve=>setTimeout(resolve,ms));async function until(f,label){for(let i=0;i<250;i++){const result=f();if(result)return result;await wait(40);}throw Error('Timeout: '+label);}
 const today=rules.clock().day,now=time(today+'T21:10:00');let persistCount=0;
 const war=require('./alliance-war.cjs').createWar(db,{runtimes,now:()=>now,persist:async()=>{persistCount++;}});
 async function available(port){return new Promise(resolve=>{const s=net.createServer();s.once('error',()=>resolve(false));s.listen(port,'127.0.0.1',()=>s.close(()=>resolve(true)));});}
 async function start(n){
  let port=21500+n*20;while(!(await Promise.all([0,1,2,3].map(x=>available(port+x)))).every(Boolean))port+=100;
  const dir=path.join(root,String(n));fs.mkdirSync(dir);const v=JSON.parse(fs.readFileSync(path.join(__dirname,'sunucu/veri-varsayilan.json'),'utf8'));Object.assign(v,{level:80,altin:1000,kupon:0,herolar:[],tumKarakterler:false});fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(v));fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify({roleIdHi:2,roleIdLo:n,agentUserId:String(n),agent:54,server:974,karakter:{anaId:11100005,nick:'AllianceReal'+n,profession:1,gender:1},nick:'AllianceReal'+n,kadro:{11100005:8},etkinlikSavas:{onur:1500}}));
  const id='live'+n,token='alliance-live-token-'+n,child=fork(path.join(__dirname,'sunucu/oyun-sunucu.js'),[],{env:{...process.env,BLEACH_ACCOUNT_DIR:dir,BLEACH_ACCOUNT_ID:id,BLEACH_PORT:String(port),BLEACH_ADMIN_PORT:String(port+1),BLEACH_POLICY_PORT:String(port+3),BLEACH_GAME_TOKEN:token},stdio:['ignore','ignore','pipe','ipc'],windowsHide:true});children.push(child);let errors='';child.stderr.on('data',c=>{errors+=c;});runtimes.set(id,{child,dir});child.on('message',m=>war.receive(id,m));
  let socket;for(let i=0;i<250;i++){try{socket=await new Promise((resolve,reject)=>{const s=net.connect(port,'127.0.0.1');s.once('error',reject);s.once('connect',()=>resolve(s));});break;}catch(error){await wait(40);}}assert.ok(socket,errors);sockets.push(socket);let buffer=Buffer.alloc(0);const packets=[];socket.on('error',()=>{});socket.on('data',chunk=>{const parsed=parseStream(Buffer.concat([buffer,chunk]));buffer=parsed.rest;packets.push(...parsed.packets);});socket.write(frame(0x01810001,new Y().utf(token).done()));await until(()=>packets.find(p=>p.id===0x01180102),'character login');return {id,dir,socket,packets};
 }
 try{
  const a=await start(1),b=await start(2);const before=await war.request(a.id,'view');assert.equal(before.pveLeft,10);assert.equal(before.pvpLeft,10);assert.equal(before.gold,1000);
  await war.request(a.id,'buy',{rowId:11107001,qty:1});let after=await war.request(a.id,'view');assert.equal(after.gold,900);assert.equal(after.honor,1500);assert.equal(after.shopLeft,before.shopLeft-1);assert.ok(persistCount>0);
  const d=JSON.parse(fs.readFileSync(path.join(a.dir,'oyuncu.json'),'utf8'));assert.ok(d.envanter,'item persisted in player inventory');assert.equal(JSON.parse(fs.readFileSync(path.join(a.dir,'veri.json'),'utf8')).allianceShopPending,undefined);
  await assert.rejects(war.request(a.id,'buy',{rowId:11107001,qty:0}),/hợp lệ/);await assert.rejects(war.request(a.id,'buy',{rowId:11102001,qty:1}),/hợp lệ/);
  const heroState=JSON.parse(fs.readFileSync(path.join(a.dir,'oyuncu.json'),'utf8'));heroState.etkinlikSavas.onur=2050;fs.writeFileSync(path.join(a.dir,'oyuncu.json'),JSON.stringify(heroState));await war.request(a.id,'buy',{rowId:11107022,qty:1});assert.ok(JSON.parse(fs.readFileSync(path.join(a.dir,'veri.json'),'utf8')).herolar.includes(11130001));await assert.rejects(war.request(a.id,'buy',{rowId:11107022,qty:1}));assert.equal((await war.request(a.id,'view')).gold,900);
  a.socket.write(frame(0x01816106));const rejected=await until(()=>a.packets.find(p=>p.id===0x0118610a),'old fake start response');assert.notEqual(new O(rejected.payload).u32(),0);
  await war.request(a.id,'auto',{mode:'pvp'});const result=await war.request(b.id,'auto',{mode:'pvp'});assert.ok(result.battleId);assert.equal(db.rows.length,1);assert.equal(db.rows[0].delivered.length,2);assert.ok(db.rows[0].reports.length>0);
  const report=await war.request(a.id,'report',{id:result.battleId,index:0});assert.ok(report.report.turns.length>0);assert.equal(report.report._consumed,report.report._total);assert.equal(report.report.player1.roles[0].name,'AllianceReal2');assert.equal(report.report.player2.roles[0].name,'AllianceReal1');
  await until(()=>a.packets.find(p=>p.id===0x01186302),'native battle result');
  const nativeHead=new O(a.packets.find(p=>p.id===0x01186300).payload);assert.equal(nativeHead.u8(),15);assert.equal(nativeHead.u32(),16200001);assert.equal(nativeHead.utf(),result.battleId);assert.ok(a.packets.some(p=>p.id===0x01186301));assert.ok((await war.request(a.id,'view')).playback);
  after=await war.request(a.id,'view');assert.equal(after.pvpLeft,9);assert.equal(after.history.length,1);assert.equal(JSON.parse(fs.readFileSync(path.join(a.dir,'oyuncu.json'),'utf8')).posta.gelen.length,1);
  await war.request(a.id,'view');assert.equal(JSON.parse(fs.readFileSync(path.join(a.dir,'oyuncu.json'),'utf8')).posta.gelen.length,1,'refresh never duplicates rewards');
  a.socket.write(frame(0x01816303,new Y().utf(result.battleId).done()));for(let i=0;i<30&&(await war.request(a.id,'view')).playback;i++)await wait(20);
  await war.request(a.id,'leave');await war.request(a.id,'create',{mode:'pve',model:16100101});const campaign=await war.request(a.id,'start');assert.ok(campaign.battleId);assert.equal(db.rows.length,2);assert.ok(db.rows[1].reports.length>0);const final=await war.request(a.id,'view');assert.equal(final.pveLeft,db.rows[1].players[0].won?9:10);assert.ok(db.rows[1].battles.every(b=>b.enemyId>=30001001&&b.enemyId<=30001006));
 }finally{war.close();for(const socket of sockets)socket.destroy();await Promise.all(children.map(child=>new Promise(resolve=>{if(child.exitCode!==null)return resolve();child.once('exit',resolve);child.kill();})));assert.ok(path.resolve(root).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(root,{recursive:true,force:true});}
});
