'use strict';
const config=require('./sunucu/infinite-illusion-config.json');
const day=now=>Math.floor((now+25200)/86400);
const end=period=>(period+1)*86400-25200;
const reward=rank=>config.rewards.find(r=>rank<=r.through)||config.rewards.at(-1);
const ranked=entries=>Object.values(entries||{}).filter(r=>!r.bot&&r.damage>0).sort((a,b)=>b.damage-a.damage||a.at-b.at||a.id.localeCompare(b.id));

function createBoard(db,options={}){
 const periods=db.collection('illusionPeriods'),now=options.now||(()=>Math.floor(Date.now()/1000));
 let queue=Promise.resolve(),closed=false;
 const serial=fn=>{const p=queue.catch(()=>{}).then(fn);queue=p;return p;};
 const ready=Promise.all([periods.createIndex({status:1,_id:1}),periods.createIndex({'rewards.accountId':1,_id:-1})]);
 ready.catch(error=>console.error('[Boss indexes]',error.message));
 function changed(){try{if(options.onUpdate)options.onUpdate();}catch(error){console.error('[Boss ranking push]',error.message);}}
 async function settleDue(time){
  const due=await periods.find({status:'open',_id:{$lt:day(time)}}).toArray();let settled=false;
  for(const candidate of due){
   let done=false;
   for(let attempt=0;attempt<32;attempt++){
    const old=await periods.findOne({_id:candidate._id});
    if(!old||old.status==='settled'){done=true;break;}
    const rows=ranked(old.entries);
    const rewards=rows.map((r,i)=>({id:`aizen:${old._id}:${r.id}`,accountId:r.id,day:old._id,rank:i+1,gold:reward(i+1).gold,stones:reward(i+1).stones}));
    // Freeze standings AND the durable reward outbox in the same atomic write.
    const result=await periods.updateOne({_id:old._id,status:'open',revision:old.revision},{$set:{status:'settled',revision:old.revision+1,releasedAt:end(old._id),settledAt:time,rewards}});
    if(result.matchedCount){settled=true;done=true;break;}
   }
   if(!done)throw Error('Boss settlement changed concurrently; retry');
  }
  if(settled)changed();
 }
 async function current(time){
  const period=day(time);
  await periods.updateOne({_id:period},{$setOnInsert:{status:'open',revision:0,entries:{},rewards:[],createdAt:time}},{upsert:true});
  return periods.findOne({_id:period});
 }
 async function view(accountId,time){
  const period=await current(time),rows=ranked(period.entries),index=rows.findIndex(r=>r.id===accountId),own=period.entries[accountId];
  const archives=await periods.find({status:'settled','rewards.accountId':accountId}).sort({_id:-1}).toArray();
  const payouts=archives.flatMap(p=>p.rewards.filter(r=>r.accountId===accountId).map(({accountId,...r})=>r));
  const decorate=(r,i)=>{const {lastRequestId,...publicRow}=r;return {...publicRow,rank:i+1,reward:reward(i+1)};};
  return {day:period._id,now:time,resetAt:end(period._id),rows:rows.slice(0,100).map(decorate),mine:index<0?null:decorate(rows[index],index),battles:own?.battles||0,nextFight:own?.nextFight||0,lastDamage:own?.lastDamage||0,payouts,rewards:config.rewards,boss:{id:config.bossHeroId,name:'Muken Aizen',hp:config.bossHp,atk:config.bossAttack,def:config.bossDefense},realPlayersOnly:true};
 }
 async function request(accountId,identity,message){
  if(closed)throw Error('Boss ranking server closed');
  return serial(async()=>{
   await ready;
   if(!/^[a-f0-9]{24}$/.test(accountId))throw Error('Invalid authenticated account');
   if(!['info','fight'].includes(message.action))throw Error('Invalid boss request');
   if(message.action==='fight'&&(!Number.isFinite(message.damage)||message.damage<0||typeof message.id!=='string'||message.id.length>100))throw Error('Invalid server boss damage');
   let time=now();await settleDue(time);
   if(message.action==='fight'){
    let committed=false;
    for(let attempt=0;attempt<32;attempt++){
     time=now();await settleDue(time);const old=await current(time),previous=old.entries[accountId];
     if(previous?.lastRequestId===message.id){committed=true;break;}
     if(time<(previous?.nextFight||0))return {error:1,...await view(accountId,time)};
     const damage=Math.min(config.bossHp,Math.floor(message.damage)),best=!previous||damage>previous.damage;
     const row={id:accountId,id0:identity.id0>>>0,id1:identity.id1>>>0,name:String(identity.name||'Shinigami').slice(0,100),bot:false,damage:best?damage:previous.damage,at:best?time:previous.at,battles:(previous?.battles||0)+1,lastDamage:damage,nextFight:time+config.fightCooldownSeconds,lastRequestId:message.id};
     const result=await periods.updateOne({_id:old._id,status:'open',revision:old.revision},{$set:{revision:old.revision+1,[`entries.${accountId}`]:row}});
     if(result.matchedCount){committed=true;changed();break;}
    }
    if(!committed)throw Error('Boss score changed concurrently; retry');
   }
   time=now();await settleDue(time);
   return view(accountId,time);
  });
 }
 function refresh(){return serial(async()=>{await ready;await settleDue(now());});}
 const timer=options.intervalMs===0?null:setInterval(()=>refresh().catch(e=>console.error('[Boss settlement]',e.message)),options.intervalMs||10000);
 timer?.unref();
 return {request,refresh,async close(){closed=true;clearInterval(timer);await queue.catch(()=>{});}};
}
module.exports={createBoard,day,end,ranked,reward};
