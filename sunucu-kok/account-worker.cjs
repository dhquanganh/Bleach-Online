'use strict';
// A separate module cache and runtime directory for every player.
require('./sunucu/oyun-sunucu.js');
require('./sunucu/admin.js');
process.on('disconnect', () => process.exit(0));

process.on('message', message => { if (message.type === 'arena-roster') {
  const rows=Array.isArray(message.rows)?message.rows:[];
  require('./sunucu/arena-real').update(rows.map(({profile,...row})=>row),message.settlement);
  require('./sunucu/cross-server-players').update(rows);
  require('./sunucu/player-profile').update(rows);
} });

process.on('message',message=>{if(message?.type==='illusion-update')require('./sunucu/infinite-illusion').notify();});

// Merge authoritative scores into the latest account state; never overwrite its inventory.
process.on('message',message=>{if(message?.type==='cross-scores'){
  if(!require('./sunucu/cross-server-players').updateScores(message.board))return;
  try{const d=require('./sunucu/durum'),state=d.yukle();require('./sunucu/cross-server').state(state);d.kaydet(state);require('./sunucu/cross-server').notify();}catch(error){console.error('[Cross score mirror]',error.message);}
}});
let crossScoreRecovery=false;
const crossScoreTimer=setInterval(async()=>{
  if(crossScoreRecovery)return;
  crossScoreRecovery=true;
  try{const d=require('./sunucu/durum'),state=d.yukle();if(state.crossServer?.pendingScores?.length)await require('./sunucu/cross-server').flushScores({durum:state,kaydet:d.kaydet,reload:d.yukle});}
  catch(error){console.error('[Cross score retry]',error.message);}
  finally{crossScoreRecovery=false;}
},5000);
crossScoreTimer.unref();
