'use strict';
const {Y,O,tablo,satir}=require('./sunucu/paket');
const rules=require('./sunucu/alliance-war');
const REQUESTS=new Set([0x0181020e,0x0181020f,0x01810210,0x01816001,0x01816002,0x01816003,0x01816100,0x01816101,0x01816102,0x01816103,0x01816104,0x01816105,0x01816106,0x01816107,0x01816108,0x01816109,0x0181610a,0x0181610b,0x01816310]);
const packet=(id,w)=>({id,payload:Buffer.isBuffer(w)?w:w.done()});
const wire=frames=>frames.map(f=>({id:f.id,payload:f.payload.toString('base64')}));
const mode=n=>n===1?'pve':n===2?'pvp':null;
class Reader extends O {
 need(n){if(!this.ok(n))throw Error('Gói tin không hợp lệ.');}
 u8(){this.need(1);return super.u8();}
 u32(){this.need(4);return super.u32();}
 utf(){this.need(2);const n=this.b.readUInt16BE(this.p);this.need(n+2);return super.utf();}
}
function roomList(rows,operation=2){const w=new Y().u16(rows.length);for(const r of rows)w.u8(operation).u32(r.number).u32(r.model||16200001).utf(r.members.find(m=>m.id===r.owner)?.name||'Alliance').u32(r.members.length).bool(!!r.password).bool(!!r.queuedAt||!!r.playing);return packet(0x01186001,w);}
function playerList(rows,operation=2){const w=new Y().u16(rows.length);for(const s of rows)w.u8(operation).u32(s.id0).u32(s.id1).utf(s.name).u16(s.level);return packet(0x01186002,w);}
function roomInfo(room,id,snapshots){
 const index=room.members.findIndex(m=>m.id===id),owner=room.members.findIndex(m=>m.id===room.owner),w=new Y().u32(room.number).utf(room.password).u32(room.model||16200001).u8(owner).u8(index).u16(room.members.length);
 room.members.forEach((m,seat)=>{const s=snapshots.get(m.id);if(!s?.units?.length)throw Error('Không tải được đội hình thật.');const main=s.units[0],units=s.units.filter(u=>satir('BaseHero',u.id)&&satir('RoleModel',u.id));w.u8(seat).u32(s.id0||0).u32(s.id1||1).u32(main.id).utf(s.name).u16(s.level).u32(s.power||main.guc||0).bool(m.id===room.owner||m.ready).bool(false).bool(false).u32(0).u16(units.length);for(const u of units)w.u32(u.id).u8(u.pos);});
 return packet(0x01180211,w);
}
function createNative({execute,own,remove,rooms,call,snapshot,now}){
 const watchers=new Map(),numbers=new Map();let sequence=1;
 function number(room){if(!numbers.has(room.id))numbers.set(room.id,sequence++);room.number=numbers.get(room.id);return room;}
 async function send(id,frames){if(frames.length)await call(id,'native-state',{packets:wire(frames)});}
 async function publish(){
  if(!watchers.size)return;const snapshots=new Map();
  for(const [id]of watchers)try{snapshots.set(id,await snapshot(id));const r=own(id);if(r){const member=r.members.find(m=>m.id===id);member.seen=now();member.name=snapshots.get(id).name;member.level=snapshots.get(id).level;}}catch(error){watchers.delete(id);remove(id);}
  for(const r of rooms.values()){number(r);if(r.members.every(m=>snapshots.has(m.id)))r.playing=r.members.some(m=>!!snapshots.get(m.id).playback);}
  for(const [id,v]of watchers){
   const s=snapshots.get(id);if(!s)continue;
   const status=[s.pvpLeft,s.pveLeft,s.honor,s.models.filter(m=>m.unlocked).map(m=>m.id)],frames=[];
   if(v.status!==JSON.stringify(status)){v.status=JSON.stringify(status);const w=new Y().u16(s.pvpLeft).u16(s.pveLeft).u32(s.honor).u16(status[3].length);for(const model of status[3])w.u32(model);frames.push(packet(0x01186005,w));}
   const r=own(id);
   if(r){
    for(const member of r.members)if(!snapshots.has(member.id))try{snapshots.set(member.id,await snapshot(member.id));}catch{}
    const key=JSON.stringify([r.id,r.owner,r.model,r.password,r.queuedAt,r.members.map(m=>[m.id,m.ready,snapshots.get(m.id)?.units.map(u=>[u.id,u.pos]),snapshots.get(m.id)?.level,snapshots.get(m.id)?.power,snapshots.get(m.id)?.name])]);
    if(!s.playback&&key!==v.room){v.room=key;frames.push(roomInfo(number(r),id,snapshots));}
    const preparing=r.queuedAt?r.id+':'+r.queuedAt:'';
    if(!s.playback&&preparing&&v.preparing!==preparing){frames.push(packet(0x01186107,new Y().u32(0)),packet(0x01186109,new Y().u32(0).u8(1)));}
    v.preparing=preparing;
   }else v.room='';
   if(v.stage==='hall'&&!r){
    const resync=!v.syncAt||now()-v.syncAt>=5000;const visible=[...rooms.values()].filter(r=>r.mode===v.mode),changed=[],current=new Map();for(const room of visible){const key=JSON.stringify([room.model,room.owner,room.password,room.queuedAt,room.playing,room.members.map(m=>[m.id,m.name])]);current.set(room.id,{key,room:{...room,members:room.members.map(m=>({...m}))}});if(resync||v.list?.get(room.id)?.key!==key)changed.push(room);}
    const deleted=[...(v.list||new Map())].filter(([key])=>!current.has(key)).map(([,v])=>v.room);v.list=current;v.syncAt=resync?now():v.syncAt;if(changed.length)frames.push(roomList(changed));if(deleted.length)frames.push(roomList(deleted,3));
    const people=new Map([...snapshots].filter(([other,s])=>other!==id&&s.level>=40&&['hall','room'].includes(watchers.get(other)?.stage)&&watchers.get(other)?.mode===v.mode));
    const updates=[...people].filter(([other,s])=>resync||JSON.stringify(v.people?.get(other))!==JSON.stringify([s.id0,s.id1,s.name,s.level])).map(([,s])=>s);
    const removed=[...(v.people||new Map())].filter(([other])=>!people.has(other)).map(([,s])=>({id0:s[0],id1:s[1],name:s[2],level:s[3]}));
    v.people=new Map([...people].map(([other,s])=>[other,[s.id0,s.id1,s.name,s.level]]));
    if(updates.length)frames.push(playerList(updates));if(removed.length)frames.push(playerList(removed,3));
   }
   try{await send(id,frames);}catch(error){watchers.delete(id);remove(id);}
  }
 }
 async function request(id,op,payload){
  const r=new Reader(payload),room=own(id),v=watchers.get(id)||{stage:'hub',mode:'pve',list:new Map()};watchers.set(id,v);
  const ok=(ret,w=new Y().u32(0))=>[packet(ret,w)];
  const done=()=>{if(r.kalan())throw Error('Gói tin không hợp lệ.');};
  const leader=()=>{if(!room||room.owner!==id)throw Error('Chỉ đội trưởng được thực hiện.');if(room.playing)throw Error('The room is still in battle.');if(room.queuedAt)throw Error('Hãy hủy tìm trận trước.');};
  if(op===0x0181020e){done();v.stage='hub';v.room='';return ok(0x0118020e,new Y().u32(0).u32(0));}
  if(op===0x0181020f||op===0x01810210){done();const s=await snapshot(id);if(s.level<40)throw Error('Cần cấp 40.');v.stage='hall';v.status='';v.mode=op===0x01810210?'pve':'pvp';v.list=new Map();v.people=new Map();v.syncAt=0;return ok(op===0x01810210?0x01180210:0x0118020f);}
  if(op===0x01816001){const m=mode(r.u8()),model=r.u32(),password=r.utf();done();if(!m||m!==v.mode)throw Error('Chế độ không hợp lệ.');await execute(id,'create',{mode:m,model,password});v.stage='room';return ok(0x01186003);}
  if(op===0x01816002){const m=mode(r.u8()),type=r.u8(),target=r.u32(),password=r.utf();done();if(!m||m!==v.mode||![0,1].includes(type))throw Error('Chế độ không hợp lệ.');let candidate=[...rooms.values()].find(x=>number(x).number===target&&x.mode===m);if(type===1){const s=await snapshot(id);const eligible=x=>x.mode===m&&!x.password&&!x.queuedAt&&x.members.length<3&&(m==='pvp'||s.models.some(model=>model.id===x.model&&model.unlocked));const choices=[candidate,...rooms.values()].filter((x,i,list)=>x&&list.indexOf(x)===i&&eligible(x));candidate=null;for(const choice of choices){try{let playing=false;for(const member of choice.members)if((await snapshot(member.id)).playback)playing=true;choice.playing=playing;if(!playing){candidate=choice;break;}}catch{}}}if(!candidate)throw Error('Không tìm thấy đội.');await execute(id,'join',{roomId:candidate.id,password:type===1?'':password});v.stage='room';return ok(0x01186004);}
  if(op===0x01816003){done();await execute(id,'leave');watchers.delete(id);return ok(0x01186006,Buffer.alloc(0));}
  if(op===0x01816310){done();const s=await snapshot(id);if(s.level<40||!rules.pvpOpen(now()))throw Error('Alliance Battle chưa mở.');await send(id,ok(0x0118020f));v.stage='room';v.mode='pvp';await execute(id,'auto',{mode:'pvp'});return [];}
  if(op===0x01816100){
   const operation=r.u8(),from=r.u8(),to=r.u8();done();if(!room)throw Error('Bạn chưa vào phòng.');const self=room.members.findIndex(m=>m.id===id),target=room.members[to];if(from!==self)throw Error('Ghế không hợp lệ.');
   if(operation===1||operation===2)await execute(id,'ready',{ready:operation===1});
   else if(operation===6){await execute(id,'leave');v.stage='hall';v.list=new Map();}
   else if(operation===4){leader();if(!target||target.id===id)throw Error('Thành viên không hợp lệ.');await execute(id,'kick',{member:target.id});const other=watchers.get(target.id);if(other){other.stage='hall';other.list=new Map();}await send(target.id,ok(0x01186100,new Y().u32(0).u8(4).u8(from).u8(to)));return [];}
   else if(operation===5){leader();if(!target)throw Error('Thành viên không hợp lệ.');room.owner=target.id;room.members.forEach(m=>m.ready=false);}
   else if(operation===3){const owner=room.members.findIndex(m=>m.id===room.owner);await send(room.owner,ok(0x01186100,new Y().u32(0).u8(3).u8(self).u8(owner)));return [];}
   else if(operation===7){leader();return [];}
   else if(operation===8){leader();if(to>2)throw Error('Ghế không hợp lệ.');if(target)[room.members[from],room.members[to]]=[room.members[to],room.members[from]];return [];}
   else throw Error('Thao tác không hợp lệ.');
   return ok(0x01186100,new Y().u32(0).u8(operation).u8(from).u8(operation===6?0:to));
  }
  if(op===0x01816101||op===0x01816108){const model=r.u32();done();leader();for(const member of room.members){const s=await snapshot(member.id);if(!s.models.some(m=>m.id===model&&m.unlocked))throw Error('Thành viên chưa mở chiến dịch.');}await execute(id,'model',{model});return ok(op===0x01816101?0x01186105:0x0118610d,op===0x01816101?new Y().u32(0).u16(0).u32(model):new Y().u32(0).u32(model));}
  if(op===0x01816102){const password=r.utf();done();await execute(id,'password',{password});return ok(0x01186106,new Y().u32(0).utf(password));}
  if(op===0x01816103||op===0x01816106){done();await execute(id,'start');return [];}
  if(op===0x01816105){const type=r.u8();done();if(type===2){await execute(id,'cancel');if(room)for(const member of room.members)if(member.id!==id)await send(member.id,ok(0x01186109,new Y().u32(0).u8(2)));return ok(0x01186109,new Y().u32(0).u8(2));}if(type!==1)throw Error('Thao tác không hợp lệ.');await execute(id,'start');return [];}
  if(op===0x01816107){done();return ok(0x0118610c,new Y().u32(0).u16(0));}
  if(op===0x0181610a){done();return ok(0x0118610f);}
  throw Error('Thao tác không được hỗ trợ.');
 }
 function error(op,message){const returns={0x0181020e:0x0118020e,0x0181020f:0x0118020f,0x01810210:0x01180210,0x01816001:0x01186003,0x01816002:0x01186004,0x01816100:0x01186100,0x01816101:0x0118610d,0x01816102:0x01186106,0x01816103:0x01186107,0x01816105:0x01186109,0x01816106:0x0118610a,0x01816108:0x0118610d};return [packet(returns[op]||0x01186100,new Y().u32(1).utf(message))];}
 return {watchers,publish,async request(id,op,payload){let result;try{result=await request(id,op,payload);if([0x0181020e,0x0181020f,0x01810210].includes(op)){await send(id,result);result=[];watchers.get(id).status='';}}catch(e){result=error(op,e.message);}await publish();return wire(result);},drop(id){watchers.delete(id);},close(){watchers.clear();}};
}
module.exports={REQUESTS,createNative,roomList,roomInfo,wire};
