'use strict';
// Run in a separate process so every stat module reads this defender's own save.
const fs = require('node:fs');
const path = require('node:path');
try {
  const account = JSON.parse(fs.readFileSync(path.join(process.env.BLEACH_ACCOUNT_DIR, 'oyuncu.json'), 'utf8'));
  if (!account.karakter || !account.karakter.anaId) process.exit(0);
  require('./sunucu/statlar').anaIdAyarla(account.karakter.anaId);
  const units = require('./sunucu/savas').playerTeam();
  let profile=null;
  try {profile=require('./sunucu/player-profile').snapshot(account);}
  catch(error) {process.stderr.write('Public profile: '+error.message+'\n');}
  if (units.length) process.send({ units,profile }, () => process.disconnect());
  else process.disconnect();
} catch (e) { process.stderr.write('Arena snapshot: ' + e.message + '\n'); process.exitCode = 1; if (process.connected) process.disconnect(); }
