'use strict';
const fs=require('node:fs'),os=require('node:os'),path=require('node:path'),crypto=require('node:crypto'),{fork}=require('node:child_process');
const K=require('./sunucu/king-challenge');
const copy=x=>JSON.parse(JSON.stringify(x));
const revision=s=>crypto.createHash('sha256').update(JSON.stringify(s)).digest('hex');
function fail(status,message){throw Object.assign(Error(message),{status});}
async function buildPlayer(files){
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-tournament-'));
 try{
  for(const name of require('./accounts.cjs').FILES)if(files[name]!==undefined)fs.writeFileSync(path.join(dir,name),files[name]);
  return await new Promise((resolve,reject)=>{
   const child=fork(path.join(__dirname,'tournament-snapshot.cjs'),[],{env:{...process.env,BLEACH_ACCOUNT_DIR:dir},stdio:['ignore','ignore','pipe','ipc']});
   let result,error='';const timer=setTimeout(()=>child.kill(),20000);
   child.on('message',m=>{result=m;});child.stderr.on('data',b=>{error+=b;});
   child.on('error',reject);child.on('exit',code=>{clearTimeout(timer);code===0&&result?resolve(result):reject(Error(error.slice(0,300)||'Không thể lấy đội hình.'));});
  });
 }finally{fs.rmSync(dir,{recursive:true,force:true});}
}
function createTournament({db,runtimes=new Map(),snapshot,store=require('./sunucu/king-challenge-store').createStore(),now=()=>Math.floor(Date.now()/1000),build=buildPlayer,simulate=K.defaultSimulate}){
 function season(registry){
  const t=now(),active=Object.values(registry.seasons).filter(s=>s.start<=t&&t<s.start+K.DISPLAY_SECONDS).sort((a,b)=>b.start-a.start)[0];
  if(active)return active;
  const start=K.nextStart(t);
  return registry.seasons[start]||(registry.seasons[start]={start,registrations:{},groups:{},locked:{},registrationPhase:2,sequence:0});
 }
 function describe(s){return {start:s.start,serverTime:now(),status:now()<s.start?'registration':'running',revision:revision(s),groups:[1,2,3,4].map(group=>({group,players:Object.values(s.registrations).filter(e=>e.group===group).sort((a,b)=>a.order-b.order).map(e=>({key:e.player.key,name:e.player.name,power:e.player.power,heroes:e.player.units.length,order:e.order})),matches:(s.groups[group]?.matches||[]).map(m=>({id:m.id,done:m.done,time:m.time,ret:m.ret}))}))};}
 async function candidates(){
  const accounts=await db.collection('accounts').find({},{projection:{username:1}}).sort({username:1}).toArray();
  const players=await db.collection('players').find({},{projection:{files:1}}).toArray(),byId=new Map(players.map(p=>[String(p._id),p]));
  return accounts.flatMap(a=>{
   const id=String(a._id),rt=runtimes.get(id),p=byId.get(id);if(!p)return [];
   const files=rt?snapshot(rt.dir):p.files,d=JSON.parse(files['oyuncu.json']||'{}'),v=JSON.parse(files['veri.json']||'{}'),hero=d.karakter?.anaId;
   if(!hero)return [];
   const level=Number(v.level)||1,rebirth=require('./sunucu/reincarnation').record(d,hero).n,group=rebirth?4:level>=60&&level<=100?1:level<=120&&level>=101?2:level>=121&&level<=159?3:0;
   return [{id,username:a.username,name:d.karakter.nick||d.nick||a.username,level,group,online:!!rt}];
  });
 }
 async function view(){const data=store.transact(r=>{
  const s=season(r);
  if(now()>=s.start){
   const d={kingChallenge:{version:2,group:1,current:{start:s.start,registryEpoch:now(),groups:{},bets:[],claimed:false},archive:[]}};
   const x=K.synchronize(d,now(),simulate,r,'admin-spectator');for(const group of [1,2,3,4])x.resolve(group);
  }
  return {result:describe(s),commit:true};
 });return {...data,candidates:await candidates()};}
 function notify(){for(const rt of runtimes.values())if(rt.child.connected)try{rt.child.send({type:'tournament-update'},()=>{});}catch(e){console.error('[Tournament push]',e.message);}}
 async function update(data,actor){
  if(!data||!['add','remove','order','start'].includes(data.action)||typeof data.revision!=='string')fail(400,'Thao tác giải đấu không hợp lệ.');
  let added;
  if(data.action==='add'){
   if(typeof data.accountId!=='string'||!/^[a-f0-9]{24}$/.test(data.accountId))fail(400,'Chọn tài khoản hợp lệ.');
   const candidate=(await candidates()).find(c=>c.id===data.accountId);if(!candidate?.group)fail(400,'Người chơi chưa đủ điều kiện tham gia.');
   const {ObjectId}=require('mongodb'),p=await db.collection('players').findOne({_id:new ObjectId(data.accountId)});if(!p)fail(404,'Không tìm thấy người chơi.');
   const rt=runtimes.get(data.accountId);added=await build(rt?snapshot(rt.dir):p.files);
   if(![1,2,3,4].includes(added.group)||!added.player?.units?.length)fail(400,'Đội hình không hợp lệ.');
  }
  store.transact(r=>{
   const s=season(r);if(revision(s)!==data.revision)fail(409,'Danh sách đã thay đổi. Tải lại trước khi thao tác.');
   s.sequence=Number(s.sequence)||0;
   if(now()>=s.start)fail(409,'Giải đã bắt đầu; không thể sửa danh sách hoặc bắt đầu lại.');
   const entries=s.registrations;
   if(data.action==='add'){
    if(entries[data.accountId])fail(409,'Người chơi đã đăng ký.');
    const group=added.group,rows=Object.values(entries).filter(e=>e.group===group);if(rows.length>=8)fail(409,'Nhóm đã đủ 8 người.');
    const pos=Array.from({length:8},(_,i)=>i).find(i=>!rows.some(e=>e.player.pos===i));
    entries[data.accountId]={group,player:{...copy(added.player),key:data.accountId,pos},order:++s.sequence,time:now()};s.groups={};
   }else if(data.action==='remove'){
    if(typeof data.key!=='string'||!entries[data.key])fail(404,'Không tìm thấy người đăng ký.');
    delete entries[data.key];s.groups={};
   }else if(data.action==='order'){
    const keys=data.keys,group=data.group,rows=Object.values(entries).filter(e=>e.group===group);
    if(![1,2,3,4].includes(group)||!Array.isArray(keys)||new Set(keys).size!==keys.length||keys.length!==rows.length||keys.some(k=>typeof k!=='string'||entries[k]?.group!==group))fail(400,'Thứ tự danh sách không hợp lệ.');
    keys.forEach((k,i)=>{entries[k].order=++s.sequence;entries[k].player.pos=i;});s.groups={};
   }else{
    if(!Object.keys(entries).length)fail(400,'Cần ít nhất một người đăng ký.');
    const old=s.start,t=now();if(r.seasons[t])fail(409,'Giải khác vừa bắt đầu. Tải lại.');
    delete r.seasons[old];s.start=t;s.adminImmediate=true;s.groups={};r.seasons[t]=s;r.redirects||={};r.redirects[old]=t;
   }
   s.adminLog=[...(s.adminLog||[]),{actor,at:now(),action:data.action,key:data.key||data.accountId||null}].slice(-100);
   return {commit:true,result:null};
  });
  notify();return view();
 }
 return {view,update};
}
module.exports={createTournament,buildPlayer};
