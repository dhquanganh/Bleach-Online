'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { promisify } = require('node:util');
const { MongoClient } = require('mongodb');
const scrypt = promisify(crypto.scrypt);
const ROOT = path.resolve(__dirname, '..');
const GAME = path.join(__dirname, 'sunucu');
const FILES = ['oyuncu.json', 'veri.json', 'battlefield-runtime.json'];
function config() {
  const file = path.join(ROOT, '.env');
  if (fs.existsSync(file)) for (const line of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const m = line.match(/^([A-Z_]+)=(.*)$/); if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim();
  }
  if (!process.env.MONGODB_URI) throw new Error('Configure MONGODB_URI in .env');
}
async function passwordHash(password, salt = crypto.randomBytes(16).toString('hex')) {
  return salt + ':' + (await scrypt(password, salt, 64)).toString('hex');
}
async function passwordMatches(password, stored) {
  const hash = await passwordHash(password, stored.split(':')[0]);
  return hash.length === stored.length && crypto.timingSafeEqual(Buffer.from(hash), Buffer.from(stored));
}
async function connect() {
  config();
  if (process.env.MONGODB_DNS_SERVERS) require('node:dns').setServers(process.env.MONGODB_DNS_SERVERS.split(','));
  const client = new MongoClient(process.env.MONGODB_URI, { serverSelectionTimeoutMS: 15000 });
  await client.connect();
  const db = client.db(process.env.MONGODB_DB || 'bleach_online');
  await db.collection('accounts').createIndex({ username: 1 }, { unique: true });
  await db.collection('sessions').createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 });
  return { client, db };
}
function currentFiles() {
  return Object.fromEntries(FILES.filter(f => fs.existsSync(path.join(GAME, f))).map(f => [f, fs.readFileSync(path.join(GAME, f), 'utf8')]));
}
function newFiles(username, id) {
  const v = JSON.parse(fs.readFileSync(path.join(GAME, 'veri-varsayilan.json'), 'utf8'));
  v.nick = ''; // The native game will ask the user to create a character.
  return { 'veri.json': JSON.stringify(v), 'oyuncu.json': JSON.stringify({ agentUserId: id, agent: 54, server: 974, roleIdHi: 1, roleIdLo: crypto.randomInt(1, 0x7fffffff), nick: username }) };
}
module.exports = { connect, passwordHash, passwordMatches, currentFiles, newFiles, ROOT, GAME, FILES };
