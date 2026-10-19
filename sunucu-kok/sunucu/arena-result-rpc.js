'use strict';
const {randomUUID} = require('node:crypto');

function createClient(channel = process, timeoutMs = 15000) {
  const pending = new Map();
  channel.on('message', message => {
    if (message?.type !== 'arena-result-ack') return;
    const request = pending.get(message.id);
    if (!request) return;
    pending.delete(message.id);clearTimeout(request.timer);
    message.error ? request.reject(Error(message.error)) : request.resolve(message.result);
  });
  channel.on('disconnect', () => {
    for (const request of pending.values()) {clearTimeout(request.timer);request.reject(Error('Arena ranking server disconnected'));}
    pending.clear();
  });
  return function commit(opponentId, won) {
    if (!channel.connected || typeof channel.send !== 'function') return Promise.reject(Error('Arena ranking server unavailable'));
    return new Promise((resolve,reject) => {
      const id = randomUUID();
      const fail = error => {const request=pending.get(id);if (!request) return;clearTimeout(request.timer);pending.delete(id);reject(error);};
      const timer = setTimeout(() => fail(Error('Arena ranking update timed out')),timeoutMs);
      pending.set(id,{resolve,reject,timer});
      try {channel.send({type:'arena-result',id,opponentId,won},error=>{if(error)fail(error);});}
      catch(error) {fail(error);}
    });
  };
}
module.exports = {createClient};
