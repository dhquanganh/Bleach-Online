'use strict';
function createClient(channel=process,timeoutMs=15000){
  const pending=new Map();
  channel.on('message',m=>{
    if(m?.type!=='cross-score-ack')return;
    const request=pending.get(m.id);if(!request)return;
    pending.delete(m.id);clearTimeout(request.timer);
    m.error?request.reject(Error(m.error)):request.resolve(m.result);
  });
  channel.on('disconnect',()=>{for(const request of pending.values()){clearTimeout(request.timer);request.reject(Error('Cross score server disconnected'));}pending.clear();});
  return message=>{
    if(pending.has(message.id))return pending.get(message.id).promise;
    if(!channel.connected||typeof channel.send!=='function')return Promise.reject(Error('Cross score server unavailable'));
    let resolve,reject;const promise=new Promise((a,b)=>{resolve=a;reject=b;});
    const fail=error=>{const p=pending.get(message.id);if(!p)return;pending.delete(message.id);clearTimeout(p.timer);reject(error);};
    const timer=setTimeout(()=>fail(Error('Cross score settlement timed out')),timeoutMs);
    pending.set(message.id,{resolve,reject,timer,promise});
    try{channel.send({type:'cross-score-result',...message},error=>{if(error)fail(error);});}catch(error){fail(error);}
    return promise;
  };
}
module.exports={createClient};
