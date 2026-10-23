'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),crypto=require('node:crypto'),{EventEmitter}=require('node:events'),{ObjectId}=require('mongodb');
const {createAdmin}=require('./admin-accounts.cjs');
test('Online admin item delivery persists a mail via worker IPC and keeps the session connected',async()=>{
 const id=new ObjectId(),actor=new ObjectId(),state={karakter:{anaId:11100004}},currency={herolar:[]};
 let player={_id:id,files:{'oyuncu.json':JSON.stringify(state),'veri.json':JSON.stringify(currency)}},stops=0,mailId;
 const audit=[],child=new EventEmitter();child.send=(message,callback)=>{queueMicrotask(()=>{try{const mail=require('./sunucu/admin-item-mail').enqueue(state,message.itemId,message.amount,message.requestId);mailId=mail.lo;child.emit('message',{type:'admin-item-mail-ack',requestId:message.requestId,result:{mailId:{hi:0,lo:mail.lo},connected:1}});callback(null);}catch(e){callback(e);}});};
 const rt={child},runtimes=new Map([[id.toHexString(),rt]]);
 const db={collection:name=>({findOne:async()=>name==='accounts'?{_id:id,username:'mail-test',role:'player'}:structuredClone(player),updateOne:async(filter,update)=>{if(update.$push)audit.push(...update.$push.adminChanges.$each);return {matchedCount:1};}})};
 const handle=createAdmin({db,runtimes,serial:async(key,fn)=>fn(),save:async()=>{player.files['oyuncu.json']=JSON.stringify(state);},stop:async()=>{stops++;},body:async req=>req.body,snapshot:()=>{throw Error('online mail must not overwrite runtime files')}});
 const revision=()=>crypto.createHash('sha256').update(JSON.stringify(player.files)).digest('hex');
 let status,result;await handle({method:'POST',body:{revision:revision(),itemId:14130950,amount:80}},null,'/auth/admin/accounts/'+id.toHexString()+'/items',{account:{_id:actor,role:'admin'}},(s,r)=>{status=s;result=r});
 assert.equal(status,200);assert.equal(stops,0);assert.equal(result.disconnected,false);assert.equal(result.account.online,true);assert.equal(result.item.delivery,'mail');assert.equal(result.item.connected,1);assert.equal(result.item.mailId.lo,mailId);
 const saved=JSON.parse(player.files['oyuncu.json']);assert.deepEqual(saved.posta.gelen[0].ek,[[14130950,80]]);assert.equal(require('./sunucu/envanter').mevcut(saved,14130950),0);assert.equal(audit[0].delivery,'mail');assert.equal(child.listenerCount('message'),0);assert.equal(child.listenerCount('exit'),0);
});
