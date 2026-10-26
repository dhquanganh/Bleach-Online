'use strict';
const fs = require('node:fs');
const path = require('node:path');
const net = require('node:net');
const crypto = require('node:crypto');
const { fork } = require('node:child_process');
const { ObjectId } = require('mongodb');
const { connect, passwordHash, passwordMatches, newFiles, ROOT, FILES } = require('./accounts.cjs');
const digest = value => crypto.createHash('sha256').update(value).digest('hex');
const cookieToken = req => ((req.headers.cookie || '').split(';').map(v => v.trim()).find(v => v.startsWith('bleach_session=')) || '').slice(15);
const delay = ms => new Promise(r => setTimeout(r, ms));
async function body(req) {
  let text = ''; for await (const chunk of req) { text += chunk; if (text.length > 4096) throw new Error('Yêu cầu quá lớn'); }
  return JSON.parse(text || '{}');
}
function available(port) { return new Promise(resolve => { const s = net.createServer(); s.once('error', () => resolve(false)); s.listen(port, '127.0.0.1', () => s.close(() => resolve(true))); }); }
async function startAuth(port) {
  const { client, db } = await connect();
  if (!await db.collection('accounts').findOne({ username: 'admin' })) { await client.close(); throw new Error('Run node sunucu-kok/migrate-mongo.cjs first'); }
  try { await require('./sunucu/anniversary-feast-config').readDatabase(db); await require('./sunucu/myoboku-config').readDatabase(db); await require('./sunucu/ultimate-bp-config').readDatabase(db); }
  catch (error) { await client.close(); throw error; }
  const origin = `http://127.0.0.1:${port}`, runtimes = new Map(), starting = new Map(), locks = new Map(), attempts = new Map();
  let nextPort = 11000, closing = false;
  const townPresence=require('./town-presence.cjs').createPresence({runtimes,snapshot});
  const arenaRoster = require('./arena-roster.cjs').createRoster(db, runtimes, snapshot);
  const allianceWar=require('./alliance-war.cjs').createWar(db,{runtimes,persist:id=>serial(id,async()=>{const rt=runtimes.get(id);if(!rt)throw Error('Player disconnected before persistence');if(rt.saving)await rt.saving;await save(rt);})});
  const illusionBoard = require('./illusion-board.cjs').createBoard(db,{onUpdate(){
    for(const rt of runtimes.values())if(rt.child.connected){try{rt.child.send({type:'illusion-update'},()=>{});}catch(error){console.error('[Boss ranking push]',error.message);}}
  }});
  const ultimateBPRanking=require('./ultimate-bp-ranking.cjs').createRanking(db,{runtimes,serial,save,snapshot});
  const adminAccounts = require('./admin-accounts.cjs').createAdmin({ db, runtimes, serial, save, stop, body, snapshot, ultimateBPRanking });
  async function serial(id, action) {
    const previous = locks.get(id) || Promise.resolve();
    const current = previous.catch(() => {}).then(action); locks.set(id, current);
    try { return await current; } finally { if (locks.get(id) === current) locks.delete(id); }
  }
  async function identity(req) {
    const token = cookieToken(req); if (!/^[a-f0-9]{64}$/.test(token)) return null;
    const session = await db.collection('sessions').findOne({ _id: digest(token), expiresAt: { $gt: new Date() } });
    if (!session) return null;
    const account = await db.collection('accounts').findOne({ _id: session.accountId });
    return account && { account, token, session };
  }
  function snapshot(dir) { return require('./sunucu/retired-heroes').cleanFiles(Object.fromEntries(FILES.filter(f => fs.existsSync(path.join(dir, f))).map(f => [f, fs.readFileSync(path.join(dir, f), 'utf8')]))); }
  async function save(rt) {
    if (rt.saving) return rt.saving;
    const files = snapshot(rt.dir), hash = digest(JSON.stringify(files));
    if (hash === rt.savedHash) return;
    // This journal stays on disk if MongoDB is unavailable, and is replayed on next login.
    fs.writeFileSync(path.join(rt.dir, 'pending.json'), JSON.stringify({ files }));
    rt.saving = db.collection('players').updateOne({ _id: rt.accountId }, { $set: { files, updatedAt: new Date() } }, { upsert: true }).then(() => {
      rt.savedHash = hash; fs.writeFileSync(path.join(rt.dir, 'synced-hash'), hash); fs.rmSync(path.join(rt.dir, 'pending.json'), { force: true });
    }).finally(() => { rt.saving = null; });
    return rt.saving;
  }
  async function stop(id) {
    const rt = runtimes.get(id); if (!rt) return;
    townPresence.drop(id);
    if (rt.child.exitCode === null) { rt.child.kill(); await new Promise(resolve => { if (rt.child.exitCode !== null) return resolve(); rt.child.once('exit', resolve); }); }
    if (rt.saving) await rt.saving;
    await save(rt); runtimes.delete(id);
  }
  async function runtime(user) {
    if (!await db.collection('sessions').findOne({ _id: digest(user.token), accountId: user.account._id, expiresAt: { $gt: new Date() } })) throw new Error('Session expired');
    const id = user.account._id.toHexString();
    if (starting.has(id)) return starting.get(id);
    const old = runtimes.get(id);
    if (old && old.token === user.token && old.child.exitCode === null) return old;
    const pending = (async () => {
      if (old) await stop(id);
      const dir = path.join(ROOT, '.accounts', id); fs.mkdirSync(dir, { recursive: true });
      const journal = path.join(dir, 'pending.json');
      const syncFile = path.join(dir, 'synced-hash');
      if (fs.existsSync(syncFile)) {
        const files = snapshot(dir);
        if (digest(JSON.stringify(files)) !== fs.readFileSync(syncFile, 'utf8')) fs.writeFileSync(journal, JSON.stringify({ files }));
      }
      if (fs.existsSync(journal)) {
        await db.collection('players').updateOne({ _id: user.account._id }, { $set: { files: require('./sunucu/retired-heroes').cleanFiles(JSON.parse(fs.readFileSync(journal, 'utf8')).files), updatedAt: new Date() } }, { upsert: true });
        fs.rmSync(journal);
      }
      const player = await db.collection('players').findOne({ _id: user.account._id });
      if (!player) throw new Error('Không tìm thấy dữ liệu nhân vật');
      player.files = require('./sunucu/retired-heroes').cleanFiles(player.files);
      for (const f of FILES) { const file = path.join(dir, f); if (player.files[f] !== undefined) fs.writeFileSync(file, player.files[f]); else fs.rmSync(file, { force: true }); }
      fs.writeFileSync(syncFile, digest(JSON.stringify(snapshot(dir))));
      let gamePort;
      do { gamePort = nextPort; nextPort += 4; } while (!(await Promise.all([0, 1, 2, 3].map(n => available(gamePort + n)))).every(Boolean));
      const gameToken = crypto.randomBytes(32).toString('hex');
      const child = fork(path.join(__dirname, 'account-worker.cjs'), [], { env: { ...process.env, BLEACH_ACCOUNT_DIR: dir, BLEACH_ACCOUNT_ID: id, BLEACH_PORT: String(gamePort), BLEACH_ADMIN_PORT: String(gamePort + 1), BLEACH_POLICY_PORT: String(gamePort + 3), BLEACH_ACCOUNT_ROLE: user.account.role, BLEACH_SESSION_TOKEN: user.token, BLEACH_GAME_TOKEN: gameToken, BLEACH_WEB_ORIGIN: origin, BLEACH_INTERNAL_SECRET: crypto.randomBytes(32).toString('hex') }, stdio: ['ignore', 'ignore', 'pipe', 'ipc'] });
      child.stderr.on('data', chunk => console.error('[account worker]', chunk.toString().slice(0, 1000)));
      const rt = { child, dir, accountId: user.account._id, gamePort, gameToken, token: user.token, expiresAt: user.session.expiresAt, savedHash: fs.readFileSync(syncFile, 'utf8') };
      runtimes.set(id, rt);
      child.once('exit',()=>{if(runtimes.get(id)===rt){townPresence.drop(id);allianceWar.drop(id);}});
      child.on('message', message => {
        if(runtimes.get(id)!==rt)return;
        if(allianceWar.receive(id,message))return;
        if(message?.type==='alliance-war-native-request'){
          if(!require('./alliance-war-native.cjs').REQUESTS.has(message.op)||typeof message.payload!=='string'||message.payload.length>5500)return;
          allianceWar.nativeRequest(id,message.op,Buffer.from(message.payload,'base64')).then(packets=>{if(child.connected)child.send({type:'alliance-war-native-ack',requestId:message.requestId,packets});},error=>{console.error('[Alliance native request]',error.message);if(child.connected)child.send({type:'alliance-war-native-ack',requestId:message.requestId,packets:[]});});return;
        }
        if(message?.type==='town-presence'){townPresence.receive(id,rt,message);return;}
        if(message?.type==='illusion-request'){
          const respond=response=>{if(child.connected){try{child.send({type:'illusion-ack',id:message.id,...response},()=>{});}catch(error){console.error('[Boss ranking ack]',error.message);}}};
          try{
            const data=JSON.parse(snapshot(rt.dir)['oyuncu.json']||'{}');
            const identity={id0:data.roleIdHi,id1:data.roleIdLo,name:data.karakter?.nick||data.nick||'Shinigami'};
            illusionBoard.request(id,identity,message).then(result=>respond({result}),error=>{console.error('[Boss ranking]',error.message);respond({error:'Không lưu được BXH sát thương. Vui lòng thử lại.'});});
          }catch(error){console.error('[Boss ranking]',error.message);respond({error:'Không tải được BXH sát thương.'});}
          return;
        }
        if(message?.type!=='arena-result')return;
        const reply = response => {
          if(!child.connected)return;
          try {child.send({type:'arena-result-ack',id:message.id,...response},()=>{});} catch(error) {
            console.error('[Arena ranking] acknowledgment failed:',error.message);
          }
        };
        // The authenticated worker supplies the server-computed result, never an HTTP win flag.
        arenaRoster.recordResult(id,message).then(result => {
          reply({result});
        },error => {
          console.error('[Arena ranking]',error.message);
          reply({error:'Không lưu được hạng Arena. Vui lòng thử lại.'});
        });
      });
      let ready = false;
      for (let i = 0; i < 120; i++) {
        if (child.exitCode !== null) break;
        const open = await Promise.all([0, 1, 2].map(n => available(gamePort + n)));
        if (open.every(v => !v)) { ready = true; break; }
        await delay(250);
      }
      if (!ready) { await stop(id); throw new Error('Không khởi động được máy chủ nhân vật'); }
      await arenaRoster.refresh();
      allianceWar.resume(id).catch(error=>console.error('[Alliance recovery]',error.message));
      ultimateBPRanking.refresh().catch(error=>console.error('[Ultimate BP ranking]',error.name));
      return rt;
    })();
    starting.set(id, pending); try { return await pending; } finally { starting.delete(id); }
  }
  async function handle(req, res, pathname) {
    const json = (status, value) => { res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' }); res.end(JSON.stringify(value)); };
    if (pathname === '/login') { res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' }); res.end(fs.readFileSync(path.join(__dirname, 'login.html'))); return true; }
    if (pathname.startsWith('/auth/')) {
      try {
        if (req.headers.origin && req.headers.origin !== origin) { json(403, { error: 'Nguồn yêu cầu không hợp lệ' }); return true; }
        if (['/auth/login', '/auth/register'].includes(pathname) && req.method === 'POST') {
          const ip = req.socket.remoteAddress, now = Date.now(); let limit = attempts.get(ip);
          if (!limit || limit.until < now) { limit = { count: 0, until: now + 60000 }; attempts.set(ip, limit); }
          if (++limit.count > 15) { json(429, { error: 'Thử lại sau một phút' }); return true; }
          const data = await body(req), username = String(data.username || '').trim().toLowerCase(), password = data.password;
          if (!/^[a-z0-9_]{3,24}$/.test(username) || typeof password !== 'string' || password.length > 128 || password.length < (pathname === '/auth/register' ? 6 : 1)) { json(400, { error: 'Tên tài khoản 3–24 chữ, số hoặc _. Mật khẩu đăng ký ít nhất 6 ký tự.' }); return true; }
          if (pathname === '/auth/register') {
            const id = new ObjectId();
            try { await db.collection('accounts').insertOne({ _id: id, username, passwordHash: await passwordHash(password), role: 'player', createdAt: new Date() }); }
            catch (e) { if (e.code === 11000) { json(409, { error: 'Tài khoản đã tồn tại' }); return true; } throw e; }
            try { await db.collection('players').insertOne({ _id: id, files: newFiles(username, id.toHexString()), updatedAt: new Date() }); }
            catch (e) { await db.collection('accounts').deleteOne({ _id: id }); throw e; }
          }
          const account = await db.collection('accounts').findOne({ username });
          if (!account || !await passwordMatches(password, account.passwordHash)) { json(401, { error: 'Sai tài khoản hoặc mật khẩu' }); return true; }
          await serial(account._id.toHexString(), async () => {
            await stop(account._id.toHexString());
            await db.collection('sessions').deleteMany({ accountId: account._id });
            const token = crypto.randomBytes(32).toString('hex');
            await db.collection('sessions').insertOne({ _id: digest(token), accountId: account._id, expiresAt: new Date(Date.now() + 86400000) });
            res.setHeader('Set-Cookie', `bleach_session=${token}; HttpOnly; SameSite=Strict; Path=/; Max-Age=86400`);
          });
          json(200, { ok: true, username: account.username, role: account.role }); return true;
        }
        const user = await identity(req);
        if (!user) { json(401, { error: 'Bạn cần đăng nhập' }); return true; }
        if(pathname.startsWith('/auth/alliance-war/')){
          const action=pathname.slice('/auth/alliance-war/'.length);
          if((action==='view'&&req.method!=='GET')||(action!=='view'&&req.method!=='POST')){json(405,{error:'Phương thức không hợp lệ.'});return true;}
          try{json(200,await allianceWar.request(user.account._id.toHexString(),action,req.method==='POST'?await body(req):{}));}
          catch(error){json(error.status||400,{error:error.message});}return true;
        }
        if (pathname.startsWith('/auth/admin/')) { await adminAccounts(req, res, pathname, user, json); return true; }
        if (pathname === '/auth/logout' && req.method === 'POST') {
          await serial(user.account._id.toHexString(), async () => { const rt = runtimes.get(user.account._id.toHexString()); if (rt && rt.token === user.token) await stop(user.account._id.toHexString()); await db.collection('sessions').deleteOne({ _id: digest(user.token) }); });
          res.setHeader('Set-Cookie', 'bleach_session=; HttpOnly; SameSite=Strict; Path=/; Max-Age=0'); json(200, { ok: true }); return true;
        }
        if (pathname === '/auth/me' && req.method === 'GET') { json(200, { username: user.account.username, role: user.account.role }); return true; }
        json(404, { error: 'Không tìm thấy' }); return true;
      } catch (e) { console.error('[auth]', e.code || e.name); json(503, { error: 'Không thể kết nối dịch vụ. Vui lòng thử lại.' }); return true; }
    }
    if (['/', '/index.html', '/yerel/oturum.json', '/admin', '/admin/legacy'].includes(pathname)) {
      const user = await identity(req);
      if (!user) { if (pathname === '/yerel/oturum.json') json(401, { error: 'Bạn cần đăng nhập' }); else { res.writeHead(302, { Location: pathname === '/admin' ? '/login?next=admin' : '/login' }); res.end(); } return true; }
      if (pathname === '/admin' || pathname === '/admin/legacy') {
        if (user.account.role !== 'admin') { json(403, { error: 'Cần tài khoản admin' }); return true; }
        if (pathname === '/admin/legacy') {
          const rt = await serial(user.account._id.toHexString(), () => runtime(user));
          res.writeHead(302, { Location: `http://127.0.0.1:${rt.gamePort + 1}/` }); res.end(); return true;
        }
        res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' });
        res.end(fs.readFileSync(path.join(__dirname, 'admin-accounts.html'))); return true;
      }
      if (pathname === '/yerel/oturum.json') {
        const rt = await serial(user.account._id.toHexString(), () => runtime(user));
        json(200, { gatewayIP: '127.0.0.1', gatewayPort: String(rt.gamePort), adminPort: rt.gamePort + 1, isCombin: '0', cdnRoot: origin + '/public/', username: user.account.username, flag: '1', isAdult: '1', time: String(Math.floor(Date.now() / 1000)), agent: '54', server: '974', version: '2026090619', token: rt.gameToken, payurl: origin + '/admin', fightreporturl: '', support: '', officeurl: '', isNew: '1', lang: process.env.BLEACH_DIL || 'en' }); return true;
      }
    }
    return false;
  }
  const timer = setInterval(() => { if (closing) return; for (const [id, rt] of runtimes) {
    serial(id, () => rt.expiresAt <= new Date() ? stop(id) : save(rt)).catch(e => console.error('[Mongo save]', e.code || e.name));
  } }, 2000);
  async function close() { closing = true; clearInterval(timer); townPresence.close(); allianceWar.close(); await arenaRoster.close(); await illusionBoard.close(); await ultimateBPRanking.close(); await Promise.all([...runtimes.keys()].map(id => serial(id, () => stop(id)))); await client.close(); }
  return { handle, close, db };
}
module.exports = { startAuth, cookieToken };
