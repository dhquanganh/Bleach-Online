'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict');
const {Y,O}=require('./sunucu/paket'),rules=require('./sunucu/alliance-war');
function fixture(){
 let now=Date.parse('2026-10-26T13:50:00+07:00'),war;const states=new Map(),runtimes=new Map(),packets=new Map(),events=[];
 const db={collection(){return {find(q){return {sort(){return this;},async toArray(){return events.filter(e=>e.players.some(p=>p.accountId===q['players.accountId'])&&!e.delivered.includes(q.delivered.$ne));}};},async insertOne(e){events.push(e);},async updateOne(q,u){events.find(e=>e._id===q._id).delivered.push(u.$addToSet.delivered);}};}};
 for(const [i,id]of ['a','b','c','d'].entries()){
  const d={},k=rules.state(d,now);if(id!=='b')k.passed.push(16100101);states.set(id,{d,playback:false,level:id==='b'?40:80});packets.set(id,[]);
  runtimes.set(id,{child:{connected:true,send(m,cb){cb?.();queueMicrotask(()=>{let result,error;try{const s=states.get(id);if(m.action==='snapshot')result={...rules.view(s.d,s.level,1000,now),name:id,id0:2,id1:i+1,power:100,units:[{id:11100005,pos:8}],playback:s.playback};else if(m.action==='native-state'){packets.get(id).push(...m.data.packets.map(p=>({id:p.id,payload:Buffer.from(p.payload,'base64')})));result={ok:true};}else throw Error('Unexpected '+m.action);}catch(e){error=e.message;}war.receive(id,{type:'alliance-war-ack',requestId:m.requestId,result,error});});}}});
 }
 war=require('./alliance-war.cjs').createWar(db,{runtimes,now:()=>now});
 async function send(id,op,w){const frames=await war.nativeRequest(id,op,w?w.done():Buffer.alloc(0));packets.get(id).push(...frames.map(p=>({id:p.id,payload:Buffer.from(p.payload,'base64')})));return frames;}
 const enter=id=>send(id,0x01810210);
 const create=(id,model=16100101,password='')=>send(id,0x01816001,new Y().u8(1).u32(model).utf(password));
 const join=(id,number,password='',quick=false)=>send(id,0x01816002,new Y().u8(1).u8(quick?1:0).u32(number).utf(password));
 const op=(id,operation,from,to=0)=>send(id,0x01816100,new Y().u8(operation).u8(from).u8(to));
 function response(id,opcode){return packets.get(id).filter(p=>p.id===opcode).at(-1);}
 function list(id){const p=response(id,0x01186001);if(!p)return [];const r=new O(p.payload),out=[];for(let n=r.u16();n;n--)out.push({operation:r.u8(),number:r.u32(),model:r.u32(),owner:r.utf(),count:r.u32(),password:!!r.u8(),fighting:!!r.u8()});assert.equal(r.kalan(),0);return out;}
 return {war,states,packets,send,enter,create,join,op,response,list,advance(ms){now+=ms;}};
}
test('native halls receive existing rooms after ACK, refresh lost lists and list real online players',async()=>{
 const f=fixture();try{
  await f.enter('a');await f.create('a',16100301);await f.enter('b');
  const frames=f.packets.get('b');assert.ok(frames.findIndex(p=>p.id===0x01180210)<frames.findIndex(p=>p.id===0x01186001));
  const room=f.list('b')[0];assert.equal(room.model,16100301,'discovery includes a higher-level room; joining still validates eligibility');assert.equal(room.owner,'a');
  await f.join('b',room.number);assert.notEqual(new O(f.response('b',0x01186004).payload).u32(),0);
  const people=new O(f.response('b',0x01186002).payload);assert.equal(people.u16(),1);assert.equal(people.u8(),2);assert.equal(people.u32(),2);assert.equal(people.u32(),1);assert.equal(people.utf(),'a');assert.equal(people.u16(),80);assert.equal(people.kalan(),0);
  f.packets.get('b').length=0;f.advance(6100);await f.send('b',0x01810210);assert.equal(f.list('b')[0].number,room.number,'reopening resends existing rooms');
  f.packets.get('b').length=0;f.advance(6100);await f.send('a',0x01816102,new Y().utf(''));assert.equal(f.list('b')[0].number,room.number,'periodic full refresh repairs dropped client state');
  f.advance(60000);await f.send('b',0x01810210);assert.equal(f.list('b')[0].number,room.number,'native online room never expires solely because its browser stops polling');
 }finally{f.war.close();}
});
test('native room IDs, passwords, readiness, three seats and transferred ownership stay consistent',async()=>{
 const f=fixture();try{
  for(const id of ['a','b','c','d'])await f.enter(id);await f.create('a',16100101,'123');const number=f.list('b')[0].number;
  await f.join('b',number,'bad');assert.notEqual(new O(f.response('b',0x01186004).payload).u32(),0);
  await f.join('b',number,'123');await f.join('c',number,'123');await f.join('d',number,'123');assert.notEqual(new O(f.response('d',0x01186004).payload).u32(),0);assert.equal(f.war.rooms.values().next().value.members.length,3);
  await f.op('b',1,1);assert.equal(f.war.rooms.values().next().value.members[1].ready,true);
  await f.op('a',5,0,2);assert.equal(f.war.rooms.values().next().value.owner,'c');
  await f.op('a',6,0);const room=f.war.rooms.values().next().value;assert.equal(room.owner,'c','non-owner departure preserves transferred leader');assert.deepEqual(room.members.map(m=>m.id),['b','c']);
  await f.op('b',4,0,1);assert.notEqual(new O(f.response('b',0x01186100).payload).u32(),0,'non-leader cannot kick');
  await f.op('c',4,1,0);assert.deepEqual(room.members.map(m=>m.id),['c']);assert.equal(room.owner,'c');
 }finally{f.war.close();}
});
test('quick join skips locked maps and rooms in playback; late join never enters a battle in progress',async()=>{
 const f=fixture();try{
  for(const id of ['a','b','c','d'])await f.enter(id);await f.create('a',16100102);await f.create('c');
  await f.join('b',0,'',true);assert.equal(new O(f.response('b',0x01186004).payload).u32(),0);const room=[...f.war.rooms.values()].find(r=>r.owner==='c');assert.ok(room.members.some(m=>m.id==='b'));
  f.states.get('c').playback=true;await f.join('d',room.number);assert.notEqual(new O(f.response('d',0x01186004).payload).u32(),0);assert.equal(room.members.length,2);
  f.states.get('d').playback=true;await f.create('d');assert.notEqual(new O(f.response('d',0x01186003).payload).u32(),0);
 }finally{f.war.close();}
});
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
function hallMethod(name,globals={}){const source=fs.readFileSync(path.join(__dirname,'cikarim/alliance-war/coop/verify/scripts/Processors/Game/Lobby/TeamBattle/Hall/TProcessorWindowHall.as'),'utf8'),start=source.indexOf('function '+name+'('),brace=source.indexOf('{',start);assert.ok(start>=0);let depth=1,end=brace+1;while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}return vm.runInNewContext('('+source.slice(start,end).replace(/:\s*[\w.]+/g,'')+')',{uint:v=>Number(v)>>>0,int:v=>Number(v)|0,...globals});}
test('compiled Flash hall shows rooms across unlocked levels and searches server when its local list is empty',()=>{
 for(const name of ['ProcessorFilterPveModelID','ProcessorFilterPvpModelID']){const filter=hallMethod(name);assert.equal(filter(false,0,16100101,16100301),true,'All shows rooms even when their map is not unlocked');assert.equal(filter(true,16100101,16100301,16100301),false,'explicit map filter is preserved');}
 const target={FRoomDigests:{Count:0},FTF_Search:{text:'42'},ProcessorEnterRoomReq(){this.sent=this.FEnterRoomID;}};
 hallMethod('Btn_SearchOnClick').call(target,null,null);assert.equal(target.sent,42);assert.equal(target.FEnterPassword,'');
 hallMethod('UpdateUIRooms').call({FInitialization:false,FModels:null,FTeamBattle:{ModeType:1}});
});
