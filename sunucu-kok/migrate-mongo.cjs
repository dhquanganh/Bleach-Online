'use strict';
const fs = require('node:fs');
const path = require('node:path');
const { DatabaseSync } = require('node:sqlite');
const { connect, passwordHash, currentFiles, GAME } = require('./accounts.cjs');
async function migrate() {
  const { client, db } = await connect();
  const failed = [];
  try {
    const hash = await passwordHash('admin');
    await db.collection('accounts').updateOne({ username: 'admin' }, { $setOnInsert: { username: 'admin', passwordHash: hash, role: 'admin', createdAt: new Date() } }, { upsert: true });
    const admin = await db.collection('accounts').findOne({ username: 'admin' });
    await db.collection('players').updateOne({ _id: admin._id }, { $setOnInsert: { files: currentFiles(), updatedAt: new Date() } }, { upsert: true });
    const sqlite = new DatabaseSync(path.join(GAME, 'oyun.db'), { readOnly: true });
    try {
      for (const { name } of sqlite.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'").all()) {
        try {
        const quoted = '"' + name.replaceAll('"', '""') + '"';
        const collection = db.collection('legacy_' + name);
        const total = Number(sqlite.prepare('SELECT COUNT(*) AS n FROM ' + quoted).get().n);
        if (await collection.countDocuments({ _id: { $gte: 0, $lt: total } }) === total) { console.log(`Already migrated ${name}: ${total} rows`); continue; }
        async function insertMissing(rows) {
          const existing = new Set((await collection.find({ _id: { $in: rows.map(r => r._id) } }, { projection: { _id: 1 } }).toArray()).map(r => r._id));
          const missing = rows.filter(r => !existing.has(r._id));
          if (missing.length) await collection.insertMany(missing, { ordered: false });
        }
        let batch = [], count = 0;
        for (const row of sqlite.prepare('SELECT * FROM ' + quoted).iterate()) {
          const index = count++;
          batch.push({ _id: index, data: { ...row } });
          if (batch.length === 2000) { await insertMissing(batch); batch = []; if (count % 20000 === 0) console.log(`Migrating ${name}: ${count}/${total}`); }
        }
        if (batch.length) await insertMissing(batch);
        console.log(`Migrated ${name}: ${count} rows`);
        await db.collection('migration_status').updateOne({ _id: name }, { $set: { status: 'complete', rows: count, updatedAt: new Date() } }, { upsert: true });
        } catch (e) {
          if (e.code !== 'ERR_SQLITE_ERROR') throw e;
          failed.push(name);
          await db.collection('migration_status').updateOne({ _id: name }, { $set: { status: 'source_error', error: e.message, updatedAt: new Date() } }, { upsert: true });
          console.error(`Could not read SQLite table ${name}: ${e.message}; continuing with other tables.`);
        }
      }
    } finally { sqlite.close(); }
    for (const name of fs.readdirSync(GAME).filter(n => n.endsWith('.json'))) {
      await db.collection('game_config').updateOne({ _id: name }, { $setOnInsert: { data: JSON.parse(fs.readFileSync(path.join(GAME, name), 'utf8')) } }, { upsert: true });
    }
    if (failed.length) { console.error(`Player and healthy tables imported; unreadable source tables: ${failed.join(', ')}`); process.exitCode = 1; }
    else console.log('Migration complete; admin account owns the existing player.');
  } finally { await client.close(); }
}
migrate().catch(e => { console.error('Migration failed:', e.message.replace(/mongodb[^\s]+/g, '[redacted]')); process.exitCode = 1; });
