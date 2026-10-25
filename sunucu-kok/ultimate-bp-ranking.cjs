'use strict';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const {ROOT,FILES}=require('./accounts.cjs'),rules=require('./sunucu/ultimate-bp-ranking');
const hash=value=>crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');
function fail(status,message){const e=Error(message);e.status=status;throw e;}
// Apply the same redo order as the worker before adding offline mail. Otherwise a
// later login could replay a pre-mail player snapshot over the reward receipt.
function recoveredFiles(source){
 const files={...source};let v=JSON.parse(files['veri.json']||'{}'),d=JSON.parse(files['oyuncu.json']||'{}');
 for(const key of ['myobokuPending','ultimateBPPending'])if(v[key]){d=v[key];delete v[key];}
 if(files['arena-reward-pending.json']){const pending=JSON.parse(files['arena-reward-pending.json']);if(!pending.account||!pending.player)throw Error('Invalid Arena reward journal');v=pending.account;d=pending.player;delete files['arena-reward-pending.json'];}
 files['veri.json']=JSON.stringify(v,null,2);files['oyuncu.json']=JSON.stringify(d,null,2);return files;
}
function createRanking(db,{runtimes=new Map(),serial=async(k,f)=>f(),save=async()=>{},snapshot,directory=path.join(ROOT,'.accounts'),intervalMs=3000,now=()=>Math.floor(Date.now()/1000)}={}){
 const payouts=db.collection('ultimateBPRankingPayouts');let queue=Promise.resolve(),lastView;
 const run=fn=>{const p=queue.catch(()=>{}).then(fn);queue=p;return p;};
 function diskFiles(player){const id=player._id.toHexString(),rt=runtimes.get(id);if(rt)return snapshot(rt.dir);const dir=path.join(directory,id),sync=path.join(dir,'synced-hash'),journal=path.join(dir,'pending.json');if(fs.existsSync(sync)&&snapshot){const files=snapshot(dir);if(hash(files)!==fs.readFileSync(sync,'utf8'))return files;}if(fs.existsSync(journal))return JSON.parse(fs.readFileSync(journal,'utf8')).files;return player.files;}
 async function current(){
  const [players,accounts]=await Promise.all([db.collection('players').find({},{projection:{files:1}}).toArray(),db.collection('accounts').find({},{projection:{username:1}}).toArray()]);
  const valid=new Map(accounts.map(a=>[a._id.toHexString(),a]));const entries=[];
  for(const player of players){const id=player._id.toHexString();if(!valid.has(id))continue;const files=recoveredFiles(diskFiles(player)),v=JSON.parse(files['veri.json']||'{}'),d=JSON.parse(files['oyuncu.json']||'{}');if(!d.karakter?.anaId)continue;
   const score=Number(v.ultimateBP?.pieces)||0;if(!Number.isSafeInteger(score)||score<0||score>1000000000)throw Error('Invalid Ultimate BP score for '+id);
   entries.push({accountId:id,id0:Number(d.roleIdHi)>>>0,id1:Number(d.roleIdLo)>>>0,serverId:Number(d.server)||1,name:String(d.karakter.nick||d.nick||valid.get(id).username).slice(0,100),pieces:score});
  }
  const rows=rules.rank(entries),rewards=rules.tiers().map(t=>({...t,items:t.items.map(a=>({...a,name:require('./sunucu/envanter').article(a.itemId)?.ad||String(a.itemId),icon:'/auth/admin/items/'+a.itemId+'/icon'}))}));
  const settlement=await payouts.findOne({_id:rules.ID});
  lastView={rows,minimum:rules.MINIMUM,rewards,ties:'Crystal Pieces giảm dần; bằng điểm xếp theo ID tài khoản.',revision:hash({rows,rewards,minimum:rules.MINIMUM,round:settlement?.round||1,resetComplete:!!settlement?.resetComplete}),settlement:settlement?{id:settlement._id,round:settlement.round||1,resetComplete:!!settlement.resetComplete,resetTotal:settlement.resetTargets?.length||0,resetDone:settlement.resetTargets?.filter(r=>r.done).length||0,at:settlement.at,status:settlement.status,total:settlement.rewards.length,delivered:settlement.rewards.filter(r=>r.delivered).length,rows:settlement.rewards.map(r=>({accountId:r.accountId,name:r.name,rank:r.rank,pieces:r.pieces,delivered:!!r.delivered}))}:null};
  for(const rt of runtimes.values())if(rt.child.connected)rt.child.send({type:'ultimate-bp-ranking',rows,minimum:rules.MINIMUM},error=>{if(error)console.error('[Ultimate BP ranking push]',error.name);});
  return lastView;
 }
 async function deliver(payout){return serial(payout.accountId,async()=>{
  const {ObjectId}=require('mongodb'),id=new ObjectId(payout.accountId),rt=runtimes.get(payout.accountId);
  if(rt){
   await new Promise((resolve,reject)=>{let timer;const done=(error)=>{clearTimeout(timer);rt.child.off('message',onMessage);rt.child.off('exit',onExit);error?reject(error):resolve();};const onMessage=m=>{if(m?.type==='ultimate-bp-rank-mail-ack'&&m.id===payout.id)done(m.error?Error(m.error):null);};const onExit=()=>done(Error('Game closed before reward acknowledgment'));rt.child.on('message',onMessage);rt.child.once('exit',onExit);timer=setTimeout(()=>done(Error('Reward acknowledgment timed out')),10000);rt.child.send({type:payout.reset?'ultimate-bp-rank-reset':'ultimate-bp-rank-mail',payout},e=>{if(e)done(e);});});
   if(rt.saving)await rt.saving;await save(rt);return;
  }
  const player=await db.collection('players').findOne({_id:id});if(!player)throw Error('Recipient no longer exists');
  const files=recoveredFiles(diskFiles(player)),state=JSON.parse(files['oyuncu.json']||'{}');if(payout.reset){const v=JSON.parse(files['veri.json']);rules.reset(state,v,payout.id);files['veri.json']=JSON.stringify(v,null,2);}else rules.enqueue(state,payout);files['oyuncu.json']=JSON.stringify(state,null,2);
  const result=await db.collection('players').updateOne({_id:id,files:player.files},{$set:{files,updatedAt:new Date()}});if(!result.matchedCount)throw Error('Recipient changed during reward delivery');
  // Mirror a successful offline DB update before releasing the same per-account login lock.
  const dir=path.join(directory,payout.accountId);fs.mkdirSync(dir,{recursive:true});for(const name of FILES){const file=path.join(dir,name);if(files[name]!==undefined)fs.writeFileSync(file,files[name]);else fs.rmSync(file,{force:true});}
  fs.writeFileSync(path.join(dir,'synced-hash'),hash(snapshot?snapshot(dir):files));fs.rmSync(path.join(dir,'pending.json'),{force:true});
 });}
 async function resume(){let doc=await payouts.findOne({_id:rules.ID});if(!doc||doc.resetComplete)return;
  const attempts=await Promise.allSettled(doc.rewards.map(async(reward,i)=>{if(reward.delivered)return;await deliver(reward);await payouts.updateOne({_id:rules.ID},{$set:{['rewards.'+i+'.delivered']:true,['rewards.'+i+'.deliveredAt']:now()}});}));
  for(const result of attempts)if(result.status==='rejected')console.error('[Ultimate BP reward]',result.reason.name);
  doc=await payouts.findOne({_id:rules.ID});if(!doc.rewards.every(r=>r.delivered))return;
  if(!doc.resetTargets){
   const players=await db.collection('players').find({},{projection:{_id:1}}).toArray();
   await payouts.updateOne({_id:rules.ID},{$set:{status:'resetting',resetTargets:players.map(p=>({accountId:p._id.toHexString(),done:false}))}});
   doc=await payouts.findOne({_id:rules.ID});
  }
  const resets=await Promise.allSettled(doc.resetTargets.map(async(target,i)=>{if(target.done)return;await deliver({reset:true,accountId:target.accountId,id:rules.ID+':reset:'+(doc.round||1)});await payouts.updateOne({_id:rules.ID},{$set:{['resetTargets.'+i+'.done']:true}});}));
  for(const result of resets)if(result.status==='rejected')console.error('[Ultimate BP reset]',result.reason.name);
  doc=await payouts.findOne({_id:rules.ID});if(doc.resetTargets.every(r=>r.done))await payouts.updateOne({_id:rules.ID},{$set:{status:'delivered',resetComplete:true,completedAt:now()}});
 }
 function view(){return run(current);}
 function award(expected,actor){return run(async()=>{
  let doc=await payouts.findOne({_id:rules.ID});
  if(!doc||doc.resetComplete){
   const preview=await current();
   if(expected!==preview.revision){if(doc&&expected===doc.previewRevision)return preview;fail(409,'BXH vừa thay đổi. Tải lại trước khi trao quà.');}
   if(!preview.rows.length)fail(400,'Chưa có người chơi đủ 5.000 Crystal Pieces.');
   const round=doc?(doc.round||1)+1:1,at=now(),rewards=preview.rows.slice(0,50).map(r=>({...r,id:rules.ID+':round:'+round+':'+r.accountId,items:rules.tiers().find(t=>r.rank<=t.through).items,at,delivered:false}));
   const next={status:'delivering',round,resetComplete:false,resetTargets:null,at,actor:String(actor),previewRevision:expected,rewards};
   if(doc){
    const archive={...doc,_id:rules.ID+':history:'+(doc.round||1)};
    await payouts.updateOne({_id:archive._id},{$setOnInsert:archive},{upsert:true});
    const changed=await payouts.updateOne({_id:rules.ID,resetComplete:true,previewRevision:doc.previewRevision},{$set:next});
    if(!changed.matchedCount)fail(409,'Đợt trao thưởng vừa thay đổi. Tải lại BXH.');
   }else await payouts.updateOne({_id:rules.ID},{$setOnInsert:next},{upsert:true});
  }
  await resume();return current();
 });}
 let maintenance;
 const tick=()=>{if(maintenance)return;maintenance=run(async()=>{await resume();await current();}).catch(e=>console.error('[Ultimate BP ranking]',e.name)).finally(()=>{maintenance=null;});};
 const timer=intervalMs?setInterval(tick,intervalMs):null;timer?.unref();
 return {view,award,refresh:()=>run(async()=>{await resume();return current();}),close:async()=>{clearInterval(timer);await queue.catch(()=>{});}};
}
module.exports={createRanking,recoveredFiles};
