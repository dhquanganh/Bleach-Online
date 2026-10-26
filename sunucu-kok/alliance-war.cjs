'use strict';
const crypto=require('node:crypto');
const rules=require('./sunucu/alliance-war');
const fail=message=>{throw Object.assign(Error(message),{status:400});};
function createWar(db,{runtimes,now=Date.now,timeoutMs=45000,persist=async()=>{}}){
 const rooms=new Map(),pending=new Map();let queue=Promise.resolve(),closed=false;
 const events=db.collection('alliance_battles');
 if(events.createIndex)events.createIndex({'players.accountId':1,at:1}).catch(error=>console.error('[Alliance index]',error.message));
 function call(id,action,data={}){
  if(closed)return Promise.reject(Error('Máy chủ đang dừng.'));
  const rt=runtimes.get(id);if(!rt?.child.connected)return Promise.reject(Error('Người chơi đã ngắt kết nối.'));
  const requestId=crypto.randomUUID();return new Promise((resolve,reject)=>{
   const timer=setTimeout(()=>{pending.delete(requestId);reject(Error('Máy chủ chiến đấu chưa phản hồi.'));},timeoutMs);
   pending.set(requestId,{id,resolve,reject,timer});rt.child.send({type:'alliance-war',requestId,action,data},error=>{if(error){clearTimeout(timer);pending.delete(requestId);reject(error);}});
  });
 }
 function receive(id,message){if(message?.type!=='alliance-war-ack')return false;const p=pending.get(message.requestId);if(!p||p.id!==id)return true;pending.delete(message.requestId);clearTimeout(p.timer);message.error?p.reject(Error(message.error)):p.resolve(message.result);return true;}
 function own(id){return [...rooms.values()].find(r=>r.members.some(m=>m.id===id));}
 function remove(id){const r=own(id);if(!r)return;r.members=r.members.filter(m=>m.id!==id);r.queuedAt=0;r.members.forEach(m=>m.ready=false);if(!r.members.length)rooms.delete(r.id);else if(r.owner===id)r.owner=r.members[0].id;}
 function prune(){for(const r of [...rooms.values()])for(const m of [...r.members])if(!runtimes.has(m.id)||(now()-m.seen>30000&&!native.watchers.has(m.id)))remove(m.id);for(const r of rooms.values())if(r.queuedAt&&(now()-r.queuedAt>120000||!rules.pvpOpen(now())))r.queuedAt=0;}
 function publicRoom(r){return {id:r.id,mode:r.mode,model:r.model,owner:r.owner,locked:!!r.password,queued:!!r.queuedAt,fighting:!!r.playing,members:r.members.map(({id,name,level,ready})=>({id,name,level,ready}))};}
 async function deliver(id){const rows=await events.find({'players.accountId':id,delivered:{$ne:id}}).sort({at:1}).toArray();for(const e of rows){const result=e.players.find(p=>p.accountId===id);await call(id,'settle',result);await persist(id);await events.updateOne({_id:e._id},{$addToSet:{delivered:id}});}}
 async function snapshot(id){await deliver(id);return call(id,'snapshot');}
 function check(r,s){if(s.level<40)fail('Cần đạt cấp 40.');if(r.mode==='pve'&&!s.models.some(m=>m.id===r.model&&m.unlocked))fail('Chưa mở chiến dịch này hoặc chưa qua chế độ Thường.');}
 async function fight(left,right){
  const at=now(),sides=right?[left,right]:[left],snapshots=new Map();
  for(const room of sides){if(room.members.some(m=>m.id!==room.owner&&!m.ready))fail('Tất cả thành viên cần sẵn sàng.');for(const m of room.members){const s=await snapshot(m.id);if(s.playback)fail('Hãy kết thúc màn chiến đấu hiện tại trước.');check(room,s);snapshots.set(m.id,s);}}
  const team=r=>r.members.map(m=>({name:snapshots.get(m.id).name,units:snapshots.get(m.id).units}));
  const result=await call(left.owner,'simulate',{mode:left.mode,model:left.model,left:team(left),right:right?team(right):null});
  const id=crypto.randomUUID(),players=[];
  for(const room of sides)for(const m of room.members){
   const s=snapshots.get(m.id),won=room===left?result.won:result.rightWon;
   const {reward,honor,items}=rules.battleReward(left.mode,left.model,won,left.mode==='pve'?s.pveLeft:s.pvpLeft);
   players.push({accountId:m.id,name:s.name,heroId:s.units[0]?.id,side:room===left?0:1,id,at,mode:left.mode,model:left.model,won,reward,honor,items,remaining:left.mode==='pve'?s.pveLeft:s.pvpLeft,window:left.mode==='pve'?s.pveSlot:s.pvpDay,
    battles:result.battles.map(b=>({round:b.round,left:b.left,right:b.right,won:b.won,draw:b.draw,turns:b.turns})),reportIds:result.battles.map((_,i)=>i)});
  }
  // Persist the outcome before touching balances; receipts make redelivery safe after a crash.
  const event={_id:id,at,players,battles:result.battles.map(({report,...metadata})=>metadata),reports:result.battles.map(b=>b.report),delivered:[]};
  await events.insertOne(event);
  for(const r of sides){r.playing=true;r.queuedAt=0;r.members.forEach(m=>{m.ready=false;m.seen=now();});}
  for(const p of players){try{await deliver(p.accountId);}catch(error){console.error('[Alliance reward pending]',error.message);}}
  for(const p of players)if(result.battles.length)try{await call(p.accountId,'playback',require('./sunucu/alliance-war-playback').playback(event,p.accountId));}catch(error){console.error('[Alliance scene]',error.message);}
  return id;
 }
 async function handle(id,action,data={}){
  if(closed)fail('Máy chủ đang dừng.');
  if(!data||typeof data!=='object'||Array.isArray(data))fail('Dữ liệu không hợp lệ.');
  prune();const r=own(id);
  const s=await snapshot(id);
  if(r)r.members.find(m=>m.id===id).seen=now();
  if(action==='view')return {accountId:id,...s,units:undefined,room:r?publicRoom(r):null,rooms:[...rooms.values()].map(publicRoom)};
  if(action==='report'){
   const event=await events.findOne({_id:String(data.id),'players.accountId':id});const index=Number(data.index);
   if(!event||!Number.isInteger(index)||index<0||index>=event.reports.length)fail('Không tìm thấy trận chiến.');return {report:require('./sunucu/kodek').decodeBattleReport(Buffer.from(event.reports[index],'base64'))};
  }
  if(action==='play'){
   const event=await events.findOne({_id:String(data.id),'players.accountId':id});
   if(!event)fail('Không tìm thấy trận chiến của bạn.');
   const index=data.index===undefined?undefined:Number(data.index);
   if(index!==undefined&&(!Number.isInteger(index)||index<0||index>=event.reports.length))fail('Trận đấu không hợp lệ.');
   await call(id,'playback',require('./sunucu/alliance-war-playback').playback(event,id,index));return {ok:true,playing:true};
  }
  if(action==='buy'){const result=await call(id,'buy',{rowId:data.rowId,qty:data.qty});await persist(id);return result;}
  if(action==='leave'){remove(id);return {ok:true};}
  if(action==='create'||action==='auto'){
   if(s.playback)fail('Hãy kết thúc màn chiến đấu hiện tại trước.');
   if(r)fail('Bạn đang ở trong một đội.');if(!['pve','pvp'].includes(data.mode))fail('Chế độ không hợp lệ.');
   const model=data.mode==='pve'?Number(data.model):0;
   const room={id:crypto.randomUUID(),owner:id,mode:data.mode,model,password:String(data.password||''),members:[],queuedAt:0};
   if(room.password.length>32)fail('Mật khẩu tối đa 32 ký tự.');check(room,s);
   if(action==='auto'&&data.mode==='pvp'&&!rules.pvpOpen(now()))fail('Alliance Battle mở 13:45–14:45 và 21:00–22:00 (UTC+7).');
   let available=null;
   if(action==='auto'&&data.mode==='pve')for(const candidate of rooms.values()){
    if(candidate.mode!=='pve'||candidate.model!==model||candidate.password||candidate.queuedAt||candidate.members.length>=3)continue;
    let playing=false;for(const member of candidate.members)if((await snapshot(member.id)).playback)playing=true;
    candidate.playing=playing;if(!playing){available=candidate;break;}
   }
   const target=available||room;target.members.push({id,name:s.name,level:s.level,ready:action==='auto',seen:now()});rooms.set(target.id,target);
   if(action==='auto'&&data.mode==='pvp'){
    target.queuedAt=now();const opponent=[...rooms.values()].find(v=>v!==target&&v.mode==='pvp'&&v.queuedAt&&v.members.length===1);
    if(opponent){try{return {ok:true,battleId:await fight(target,opponent)};}catch(error){target.queuedAt=0;opponent.queuedAt=0;throw error;}}
    return {ok:true,waiting:true};
   }
   return {ok:true};
  }
  if(action==='join'){
   if(s.playback)fail('Hãy kết thúc màn chiến đấu hiện tại trước.');
   if(r)fail('Hãy rời đội hiện tại trước.');const target=rooms.get(String(data.roomId));if(!target||target.members.length>=3||target.queuedAt)fail('Đội không còn chỗ trống.');for(const member of target.members)if((await snapshot(member.id)).playback)fail('Phòng đang chiến đấu. Hãy chờ kết thúc trận.');target.playing=false;if(target.password!==String(data.password||''))fail('Sai mật khẩu.');check(target,s);target.members.push({id,name:s.name,level:s.level,ready:false,seen:now()});return {ok:true};
  }
  if(!r)fail('Bạn chưa tham gia đội.');
  if(action==='ready'){if(s.playback)fail('Hãy kết thúc màn chiến đấu hiện tại trước.');if(typeof data.ready!=='boolean')fail('Trạng thái sẵn sàng không hợp lệ.');if(r.queuedAt)fail('Hãy hủy tìm trận trước.');r.members.find(m=>m.id===id).ready=data.ready;return {ok:true};}
  if(r.owner!==id)fail('Chỉ đội trưởng được thực hiện thao tác này.');
  if(action==='cancel'){r.queuedAt=0;return {ok:true};}
  if(r.queuedAt)fail('Hãy hủy tìm trận trước.');
  if(['kick','model','password'].includes(action))for(const member of r.members)if((await snapshot(member.id)).playback)fail('Hãy chờ cả đội kết thúc trận hiện tại.');
  if(action==='kick'){if(data.member===id||!r.members.some(m=>m.id===data.member))fail('Thành viên không hợp lệ.');remove(data.member);return {ok:true};}
  if(action==='model'){if(r.mode!=='pve')fail('Đội không thuộc chiến dịch.');const candidate={...r,model:Number(data.model)};for(const member of r.members)check(candidate,member.id===id?s:await snapshot(member.id));r.model=candidate.model;r.members.forEach(m=>m.ready=false);return {ok:true};}
  if(action==='password'){if(typeof data.password!=='string'||data.password.length>32)fail('Mật khẩu tối đa 32 ký tự.');r.password=data.password;return {ok:true};}
  if(action==='start'){
   if(r.mode==='pve')return {ok:true,battleId:await fight(r)};
   if(!rules.pvpOpen(now()))fail('Alliance Battle mở 13:45–14:45 và 21:00–22:00 (UTC+7).');
   if(r.members.some(m=>m.id!==id&&!m.ready))fail('Tất cả thành viên cần sẵn sàng.');
   r.queuedAt=now();const opponent=[...rooms.values()].find(v=>v!==r&&v.mode==='pvp'&&v.queuedAt&&v.members.length===r.members.length);
   if(opponent){try{return {ok:true,battleId:await fight(r,opponent)};}catch(error){r.queuedAt=0;opponent.queuedAt=0;throw error;}}
   return {ok:true,waiting:true};
  }
  fail('Thao tác không hợp lệ.');
 }
 const native=require('./alliance-war-native.cjs').createNative({execute:handle,own,remove,rooms,call,snapshot,now});
 let nativeTickPending=false;
 const nativeTimer=setInterval(()=>{if(closed||nativeTickPending||!native.watchers.size)return;nativeTickPending=true;const p=queue.catch(()=>{}).then(async()=>{if(!closed)await native.publish();prune();});queue=p;p.catch(error=>console.error('[Alliance native]',error.message)).finally(()=>{nativeTickPending=false;});},2000);nativeTimer.unref();
 return {receive,
 request(id,action,data){const p=queue.catch(()=>{}).then(async()=>{const result=await handle(id,action,data);await native.publish();return result;});queue=p;return p;},
 nativeRequest(id,op,payload){const p=queue.catch(()=>{}).then(()=>{if(closed)throw Error('Server closed');return native.request(id,op,payload);});queue=p;return p;},
 resume(id){const p=queue.catch(()=>{}).then(()=>{if(!closed)return deliver(id);});queue=p;return p;},
 drop(id){native.drop(id);remove(id);for(const [key,p] of pending)if(p.id===id){pending.delete(key);clearTimeout(p.timer);p.reject(Error('Ng??i ch?i ?? ng?t k?t n?i.'));}},
 close(){closed=true;clearInterval(nativeTimer);native.close();for(const p of pending.values()){clearTimeout(p.timer);p.reject(Error('M?y ch? ?ang d?ng.'));}pending.clear();rooms.clear();},rooms};
}
module.exports={createWar};
