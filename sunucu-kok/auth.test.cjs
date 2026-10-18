'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const net = require('node:net');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const { startAuth } = require('./auth-service.cjs');
const { frame, parseStream } = require('./sunucu/cerceve');
test('Login form explicitly retains session cookies in the bundled legacy Chromium', async () => {
  const source = fs.readFileSync(path.join(__dirname, 'login.html'), 'utf8').match(/<script>([\s\S]*?)<\/script>/)[1];
  for (const mode of ['login', 'register']) {
    const elements = Object.fromEntries(['login', 'register', 'confirmation', 'confirm', 'password', 'username', 'submit', 'message', 'form'].map(id => [id, { value: '' }]));
    elements.username.value = 'admin'; elements.password.value = 'admin123'; elements.confirm.value = 'admin123';
    const calls = [], location = { search: '', href: '/login' };
    const context = { document: { getElementById: id => elements[id] }, location, fetch: async (url, options) => {
      calls.push({ url, options });
      // Chrome 59 defaults to omitting credentials, including response Set-Cookie.
      assert.equal(options.credentials, 'same-origin');
      return { ok: true, json: async () => ({ ok: true }) };
    } };
    vm.runInNewContext(source, context);
    if (mode === 'register') elements.register.onclick();
    elements.form.onsubmit({ preventDefault() {} });
    await new Promise(resolve => setImmediate(resolve));
    assert.equal(calls.length, 1); assert.equal(calls[0].url, '/auth/' + mode); assert.equal(location.href, '/');
  }
});
test('MongoDB authentication, isolated players, socket tokens, persistence and roles', { timeout: 150000 }, async () => {
  const port = 17422, base = `http://127.0.0.1:${port}`, app = await startAuth(port);
  const server = http.createServer(async (req, res) => { try { if (!await app.handle(req, res, new URL(req.url, base).pathname)) { res.writeHead(200); res.end('game'); } } catch (e) { res.writeHead(500); res.end(e.message); } });
  await new Promise(r => server.listen(port, '127.0.0.1', r));
  const suffix = Date.now().toString(36), names = ['test_a_' + suffix, 'test_b_' + suffix], ids = [];
  async function request(route, data, cookie) { return fetch(base + route, { method: data ? 'POST' : 'GET', redirect: 'manual', headers: { 'Content-Type': 'application/json', ...(cookie ? { Cookie: cookie } : {}) }, body: data ? JSON.stringify(data) : undefined }); }
  try {
    assert.equal((await request('/')).status, 302);
    assert.equal((await request('/auth/me')).status, 401);
    assert.equal((await request('/auth/register', { username: 'bad!', password: '123456' })).status, 400);
    const cookies = [];
    for (const username of names) {
      const r = await request('/auth/register', { username, password: 'testing123' }); assert.equal(r.status, 200, await r.text());
      const header = r.headers.get('set-cookie'); assert.match(header, /HttpOnly/); assert.match(header, /SameSite=Strict/); cookies.push(header.split(';')[0]);
      ids.push((await app.db.collection('accounts').findOne({ username }))._id);
    }
    assert.equal((await request('/auth/register', { username: names[0], password: 'testing123' })).status, 409);
    assert.equal((await request('/auth/login', { username: names[0], password: 'wrong' })).status, 401);
    assert.equal((await request('/admin', undefined, cookies[0])).status, 403);
    await app.db.collection('accounts').updateOne({ _id: ids[1] }, { $set: { role: 'admin' } });
    const profiles = [];
    for (const cookie of cookies) { const r = await request('/yerel/oturum.json', undefined, cookie); assert.equal(r.status, 200, await r.clone().text()); profiles.push(await r.json()); }
    assert.notEqual(profiles[0].gatewayPort, profiles[1].gatewayPort);
    assert.notEqual(profiles[0].token, profiles[1].token);
    const workerBase = `http://127.0.0.1:${profiles[0].adminPort}`;
    assert.equal((await fetch(workerBase + '/api/hesap')).status, 401);
    assert.equal((await fetch(workerBase + '/api/hesap', { headers: { Cookie: cookies[1] } })).status, 401);
    assert.equal((await fetch(workerBase + '/', { headers: { Cookie: cookies[0] } })).status, 403);
    assert.equal((await fetch(workerBase + '/api/hesap', { headers: { Cookie: cookies[0] } })).status, 200);
    const admin = await request('/admin', undefined, cookies[1]); assert.equal(admin.status, 200);
    assert.match(await admin.text(), /heroForm/);
    const preflight = await fetch(workerBase + '/api/thiet-bi/mua', { method: 'OPTIONS', headers: { Origin: base, 'Access-Control-Request-Method': 'POST' } });
    assert.equal(preflight.status, 204); assert.equal(preflight.headers.get('access-control-allow-origin'), base);
    assert.equal((await fetch(`http://127.0.0.1:${Number(profiles[0].gatewayPort) + 2}/topup`, { method: 'POST', headers: { Cookie: cookies[0], 'Content-Type': 'application/json' }, body: '{"altin":100}' })).status, 403);
    async function socketLogin(token) {
      return new Promise((resolve, reject) => {
        const socket = net.connect(Number(profiles[0].gatewayPort), '127.0.0.1'); let result = Buffer.alloc(0);
        socket.setTimeout(4000, () => { socket.destroy(); reject(new Error('Socket timed out')); });
        socket.on('connect', () => { const b = Buffer.from(token); const payload = Buffer.alloc(2 + b.length); payload.writeUInt16BE(b.length); b.copy(payload, 2); socket.write(frame(0x01810001, payload)); });
        socket.on('data', b => { result = Buffer.concat([result, b]); if (parseStream(result).packets.length) socket.end(); });
        socket.on('error', reject); socket.on('close', () => resolve(result));
      });
    }
    assert.equal((await socketLogin('yerel')).length, 0);
    const packets = parseStream(await socketLogin(profiles[0].token)).packets; assert.ok(packets.some(p => p.id === 0x01180100));
    const dir = path.join(__dirname, '..', '.accounts', ids[0].toHexString());
    const file = path.join(dir, 'veri.json'), currency = JSON.parse(fs.readFileSync(file)); currency.altin = 12345; fs.writeFileSync(file, JSON.stringify(currency));
    assert.equal((await request('/auth/logout', {}, cookies[0])).status, 200);
    assert.equal((await request('/auth/me', undefined, cookies[0])).status, 401);
    const saved = await app.db.collection('players').findOne({ _id: ids[0] }); assert.equal(JSON.parse(saved.files['veri.json']).altin, 12345);
    const other = await app.db.collection('players').findOne({ _id: ids[1] }); assert.notEqual(JSON.parse(other.files['veri.json']).altin, 12345);
    const login = await request('/auth/login', { username: names[0], password: 'testing123' }); assert.equal(login.status, 200);
    const newCookie = login.headers.get('set-cookie').split(';')[0];
    currency.altin = 54321; fs.writeFileSync(file, JSON.stringify(currency)); // Simulate a local write surviving an abrupt server exit.
    const relog = await request('/yerel/oturum.json', undefined, newCookie); assert.equal(relog.status, 200);
    assert.equal(JSON.parse((await app.db.collection('players').findOne({ _id: ids[0] })).files['veri.json']).altin, 54321);
    assert.equal((await request('/auth/logout', {}, newCookie)).status, 200);
    assert.equal((await request('/auth/logout', {}, cookies[1])).status, 200);
    console.log('Verified MongoDB writes, independent game workers, native create-character response, auth failures, CORS, logout and relogin.');
  } finally {
    for (const id of ids) { await app.db.collection('sessions').deleteMany({ accountId: id }); await app.db.collection('players').deleteOne({ _id: id }); await app.db.collection('accounts').deleteOne({ _id: id }); }
    await app.close(); await new Promise(r => server.close(r));
    for (const id of ids) fs.rmSync(path.join(__dirname, '..', '.accounts', id.toHexString()), { recursive: true, force: true });
  }
});
