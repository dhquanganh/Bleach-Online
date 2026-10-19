'use strict';
// A separate module cache and runtime directory for every player.
require('./sunucu/oyun-sunucu.js');
require('./sunucu/admin.js');
process.on('disconnect', () => process.exit(0));

process.on('message', message => { if (message.type === 'arena-roster') require('./sunucu/arena-real').update(message.rows,message.settlement); });
