'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { fork } = require('node:child_process');
const { ROOT, FILES } = require('./accounts.cjs');
const militaries = JSON.parse(fs.readFileSync(path.join(__dirname, 'cikarim/veri-json/Military.json'))).map(row => parseInt(row.id, 16) >>> 0);
function cacheKey(files,now){const state=JSON.parse(files['oyuncu.json']||'{}');const activeTitles=require('./sunucu/titles').equipped(state,now);return crypto.createHash('sha256').update(JSON.stringify({files,activeTitles})).digest('hex');}
function createRoster(db, runtimes, snapshot, options = {}) {
  const settle = require('./arena-settlement.cjs').createSettlement(db);
  const ladder = require('./arena-ladder.cjs').createLadder(db);
  const cache = new Map(); let pending = null, closed = false, queue = Promise.resolve();
  function serial(action) {const next=queue.catch(()=>{}).then(action);queue=next;return next;}
  async function build(player) {
    const id = player._id.toHexString(), rt = runtimes.get(id);
    const files = rt ? snapshot(rt.dir) : player.files;
    const account = JSON.parse(files['oyuncu.json'] || '{}');
    const hash = cacheKey(files);
    if (cache.get(id)?.hash === hash) return cache.get(id).row;
    if (!account.karakter?.anaId) return null;
    const dir = path.join(ROOT, '.accounts', 'arena-cache', id);
    fs.mkdirSync(dir, { recursive: true });
    for (const name of FILES) if (files[name] !== undefined) fs.writeFileSync(path.join(dir, name), files[name]);
    const snapshotData = await new Promise((resolve, reject) => {
      const child = fork(path.join(__dirname, 'arena-snapshot.cjs'), [], {
        env: { ...process.env, BLEACH_ACCOUNT_DIR: dir }, stdio: ['ignore','ignore','pipe','ipc'],
      });
      let result = {units:[],profile:null}, error = '';
      const timeout = setTimeout(() => { child.kill(); reject(Error('Arena snapshot timed out')); }, 20000);
      child.on('message', message => { result = {units:message.units||[],profile:message.profile||null}; });
      child.stderr.on('data', chunk => { error += chunk; });
      child.on('error', e => { clearTimeout(timeout); reject(e); });
      child.on('exit', code => { clearTimeout(timeout); code === 0 ? resolve(result) : reject(Error(error.slice(0, 200))); });
    });
    const {units,profile}=snapshotData;
    const level = units[0]?.level || 1;
    const row = units.length ? {
      accountId: id, id0: account.roleIdHi >>> 0, id1: account.roleIdLo >>> 0,
      name: account.karakter.nick || account.nick, country: Math.max(1, Number(account.country) || 1),
      military: militaries.includes(account.militaryRank) ? account.militaryRank : militaries[0],
      level, units, profile, heroes: units.map(u => u.id), positions: units.map(u => u.pos),
    } : null;
    cache.set(id, { hash, row }); return row;
  }
  function publish(rows,settled) {
    for (const [id,rt] of runtimes) if (rt.child.connected) {
      const reward=settled?.rewards.find(r=>r.accountId===id);
      try {
        rt.child.send({ type:'arena-roster',rows,settlement:reward?{...reward,period:settled._id,releasedAt:settled.releasedAt}:null },error=>{
          if(error)console.error('[Arena roster] delivery failed:',error.message);
        });
      } catch(error) {console.error('[Arena roster] delivery failed:',error.message);}
    }
  }
  async function refreshNow() {
      const players = await db.collection('players').find({}, { projection: { files: 1 } }).toArray();
      const accountRows = await db.collection('accounts').find({}, { projection: { _id: 1, arenaPriority: 1 } }).toArray();
      const accounts = new Set(accountRows.map(a => a._id.toHexString()));
      const priority = new Map(accountRows.map(a => [a._id.toHexString(), Number(a.arenaPriority) || 0]));
      for (const id of cache.keys()) if (!accounts.has(id)) cache.delete(id);
      const rows = [];
      for (const player of players) {
        if (!accounts.has(player._id.toHexString())) continue;
        try { const row = await (options.buildRow || build)(player); if (row) rows.push(row); }
        catch (e) { console.error('[Arena roster]', e.message); }
      }
      rows.sort((a,b) => priority.get(b.accountId)-priority.get(a.accountId) || b.level-a.level || a.accountId.localeCompare(b.accountId));
      // Priority/level seed the board once; subsequent refreshes retain earned places.
      const ranked = await ladder(rows,null,accounts);
      const settled = await settle(ranked.rows);
      publish(ranked.rows,settled);
      return {rows:ranked.rows,settled,members:accounts};
  }
  function refresh() {
    if (closed) return Promise.resolve();
    if (pending) return pending;
    pending = serial(refreshNow).finally(() => { pending = null; });
    return pending;
  }
  function recordResult(accountId,message) {
    if (closed) return Promise.reject(Error('Arena ranking server closed'));
    return serial(async () => {
      // Freeze any due reward snapshot before applying a battle resolved after the cutoff.
      const {rows,settled,members}=await refreshNow();
      const result=await ladder(rows,{id:message.id,accountId,opponentId:message.opponentId,won:message.won},members);
      publish(result.rows,settled);
      return {ranking:result.rows.find(row=>row.accountId===accountId).ranking,
        opponentRanking:result.rows.find(row=>row.accountId===message.opponentId).ranking,
        promoted:result.promoted,duplicate:result.duplicate};
    });
  }
  const timer = options.intervalMs === 0 ? null : setInterval(() => refresh().catch(e => console.error('[Arena roster]', e.name)), options.intervalMs || 5000);
  return { refresh,recordResult,async close() { closed = true; clearInterval(timer); await queue.catch(()=>{}); } };
}
module.exports = { createRoster,cacheKey };
