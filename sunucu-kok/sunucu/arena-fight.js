'use strict';

// Both the native challenge and launcher matching use this authenticated path.
function createFight({arena,kodek,load,save,count,refresh}) {
  let busy = false;
  return async function start(session,payload) {
    if (busy) throw Error('Một trận Arena đang được xử lý.');
    busy = true;
    try {
      const opponent = arena.selected(payload);
      if (!opponent) throw Error('Arena opponent is unavailable');
      const frames = arena.frames(payload);
      const report = frames.find(frame => frame.id === kodek.OP.REPORT);
      const result = frames.find(frame => frame.id === kodek.OP.RESULT);
      if (!report || !result || typeof result.won !== 'boolean') throw Error('Invalid Arena battle result');
      // Never acknowledge a successful battle before its authoritative rank update is durable.
      await arena.commit(opponent.accountId,result.won);
      let state;
      try {state=load();count(state,'arenaFight',1);save(state);}
      catch(error) {console.error('[Arena] battle counter save failed:',error.message);}
      session.send(0x01181904,Buffer.concat([Buffer.alloc(4),result.payload,report.payload]),'ARENA-result-report');
      session.send(0x01181907,Buffer.alloc(4),'ARENA-FightOk');
      // A secondary counter/UI error must not turn a committed win into a rejected battle.
      if(state)try {session.send(0x01181906,refresh(state),'ARENA-ranking-update');}
      catch(error) {console.error('[Arena] ranking refresh failed:',error.message);}
    } finally {busy=false;}
  };
}
module.exports = {createFight};
