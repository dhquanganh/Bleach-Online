'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),{EventEmitter}=require('node:events');
const {createClient}=require('../illusion-rpc');
test('Boss IPC correlates concurrent replies; rejects database errors, disconnects and timeouts',async()=>{
 const channel=new EventEmitter(),messages=[];channel.connected=true;channel.send=(m,cb)=>{messages.push(m);cb();};
 const request=createClient(channel,30),first=request('info'),second=request('fight',{damage:123});
 assert.notEqual(messages[0].id,messages[1].id);assert.equal(messages[1].damage,123);
 channel.emit('message',{type:'illusion-ack',id:messages[1].id,result:{mine:{damage:123}}});
 assert.equal((await second).mine.damage,123);
 channel.emit('message',{type:'illusion-ack',id:messages[0].id,error:'database unavailable'});
 await assert.rejects(first,/database unavailable/);
 const lost=request('info');channel.emit('disconnect');await assert.rejects(lost,/disconnected/);
 await assert.rejects(request('info'),/timeout/);
 channel.connected=false;await assert.rejects(request('info'),/unavailable/);
});
