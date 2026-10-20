'use strict';
const {randomUUID}=require('node:crypto');
function createClient(channel=process,timeoutMs=20000){
 const pending=new Map();
 channel.on('message',m=>{
  if(m?.type!=='illusion-ack')return;const p=pending.get(m.id);if(!p)return;
  pending.delete(m.id);clearTimeout(p.timer);m.error?p.reject(Error(m.error)):p.resolve(m.result);
 });
 channel.on('disconnect',()=>{for(const p of pending.values()){clearTimeout(p.timer);p.reject(Error('Boss database disconnected'));}pending.clear();});
 return (action,data={})=>new Promise((resolve,reject)=>{
  if(!channel.connected||typeof channel.send!=='function')return reject(Error('Boss database unavailable'));
  const id=randomUUID();const fail=e=>{const p=pending.get(id);if(!p)return;pending.delete(id);clearTimeout(p.timer);reject(e);};
  const timer=setTimeout(()=>fail(Error('Boss database timeout')),timeoutMs);pending.set(id,{resolve,reject,timer});
  try{channel.send({type:'illusion-request',id,action,...data},error=>{if(error)fail(error);});}catch(error){fail(error);}
 });
}
module.exports={createClient};
