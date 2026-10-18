'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { fork } = require('node:child_process');
const { ROOT, FILES } = require('./accounts.cjs');
const militaries = JSON.parse(fs.readFileSync(path.join(__dirname, 'cikarim/veri-json/Military.json'))).map(row => parseInt(row.id, 16) >>> 0);
function createRoster(db, runtimes, snapshot) {
  const cache = new Map(); let pending = null, closed = false;
  async function build(player) {
    const id = player._id.toHexString(), rt = runtimes.get(id);
    const files = rt ? snapshot(rt.dir) : player.files;
    const hash = crypto.createHash('sha256').update(JSON.stringify(files)).digest('hex');
    if (cache.get(id)?.hash === hash) return cache.get(id).row;
    const account = JSON.parse(files['oyuncu.json'] || '{}');
    if (!account.karakter?.anaId) return null;
    const dir = path.join(ROOT, '.accounts', 'arena-cache', id);
    fs.mkdirSync(dir, { recursive: true });
    for (const name of FILES) if (files[name] !== undefined) fs.writeFileSync(path.join(dir, name), files[name]);
    const units = await new Promise((resolve, reject) => {
      const child = fork(path.join(__dirname, 'arena-snapshot.cjs'), [], {
        env: { ...process.env, BLEACH_ACCOUNT_DIR: dir }, stdio: ['ignore','ignore','pipe','ipc'],
      });
      let result = [], error = '';
      const timeout = setTimeout(() => { child.kill(); reject(Error('Arena snapshot timed out')); }, 20000);
      child.on('message', message => { result = message.units || []; });
      child.stderr.on('data', chunk => { error += chunk; });
      child.on('error', e => { clearTimeout(timeout); reject(e); });
      child.on('exit', code => { clearTimeout(timeout); code === 0 ? resolve(result) : reject(Error(error.slice(0, 200))); });
    });
    const level = units[0]?.level || 1;
    const row = units.length ? {
      accountId: id, id0: account.roleIdHi >>> 0, id1: account.roleIdLo >>> 0,
      name: account.karakter.nick || account.nick, country: Math.max(1, Number(account.country) || 1),
      military: militaries.includes(account.militaryRank) ? account.militaryRank : militaries[0],
      level, units, heroes: units.map(u => u.id), positions: units.map(u => u.pos),
    } : null;
    cache.set(id, { hash, row }); return row;
  }
  function refresh() {
    if (closed) return Promise.resolve();
    if (pending) return pending;
    pending = (async () => {
      const players = await db.collection('players').find({}, { projection: { files: 1 } }).toArray();
      const accountRows = await db.collection('accounts').find({}, { projection: { _id: 1, arenaPriority: 1 } }).toArray();
      const accounts = new Set(accountRows.map(a => a._id.toHexString()));
      const priority = new Map(accountRows.map(a => [a._id.toHexString(), Number(a.arenaPriority) || 0]));
      for (const id of cache.keys()) if (!accounts.has(id)) cache.delete(id);
      const rows = [];
      for (const player of players) {
        if (!accounts.has(player._id.toHexString())) continue;
        try { const row = await build(player); if (row) rows.push(row); }
        catch (e) { console.error('[Arena roster]', e.message); }
      }
      rows.sort((a,b) => priority.get(b.accountId)-priority.get(a.accountId) || b.level-a.level || a.accountId.localeCompare(b.accountId));
      rows.forEach((row, index) => { row.ranking = index+1; });
      for (const rt of runtimes.values()) if (rt.child.connected) rt.child.send({ type: 'arena-roster', rows });
    })().finally(() => { pending = null; });
    return pending;
  }
  const timer = setInterval(() => refresh().catch(e => console.error('[Arena roster]', e.name)), 5000);
  return { refresh, async close() { closed = true; clearInterval(timer); if (pending) await pending; } };
}
module.exports = { createRoster };
