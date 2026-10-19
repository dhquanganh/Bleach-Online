'use strict';
// A separate module cache and runtime directory for every player.
require('./sunucu/oyun-sunucu.js');
require('./sunucu/admin.js');
process.on('disconnect', () => process.exit(0));

process.on('message', message => { if (message.type === 'arena-roster') {
  const rows=Array.isArray(message.rows)?message.rows:[];
  require('./sunucu/arena-real').update(rows.map(({profile,...row})=>row),message.settlement);
  require('./sunucu/player-profile').update(rows);
} });
