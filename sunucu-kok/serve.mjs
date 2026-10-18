// Bleach istemcisini yakalanan dosyalardan yerelde servis eder.
// node serve.mjs [--port 7420] [--fetch-missing]
//   --fetch-missing: kayıtta olmayan dosyayı canlı CDN'den çekip kaynak/ altına yazar
// Proxy modu: araclar/proxy-baslat.mjs canlı oturumun flashvars'ını POST /yerel/oturum ile bırakır;
//   başlatıcı dosyaları buradan yükler, oyun sunucusu trafiği 127.0.0.1:10025 → canlı gateway'e aktarılır.
//   Oturum yalnız bellekte tutulur, diske yazılmaz.
import http from 'node:http';
import net from 'node:net';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import authService from './auth-service.cjs';

const ROOT = path.dirname(fileURLToPath(import.meta.url));
const SRC = path.join(ROOT, 'kaynak', 'login.gogames.me');
const LIVE = 'https://login.gogames.me';
const portArg = process.argv.indexOf('--port');
const PORT = portArg > 0 ? Number(process.argv[portArg + 1]) : 7420;
const HOST = `127.0.0.1:${PORT}`;
const FETCH = process.argv.includes('--fetch-missing');
const OZEL = process.argv.includes('--ozel'); // ozel sunucu: 843+10025'i oyun-sunucu.js devralir
const GATE_PORT = 10025;
const PUBLIC = path.join(SRC, 'public');
const FALLBACK_SWF_VERSION = '2017112917';
// DIL: OYUNU-BASLAT.bat'taki secim BLEACH_DIL ortam degiskeniyle gelir (en = orijinal Ingilizce).
const DIL = (process.env.BLEACH_DIL || 'en').toLowerCase().replace(/[^a-z-]/g, '');
function dilListesi() {
  const out = ['en'];
  try {
    const base = path.join(SRC, 'public');
    for (const v of fs.readdirSync(base)) {
      const bin = path.join(base, v, 'Resources', 'Bin');
      if (!fs.existsSync(bin)) continue;
      for (const d of fs.readdirSync(bin)) if (d.startsWith('dil-') && !out.includes(d.slice(4))) out.push(d.slice(4));
    }
  } catch {}
  return out;
}

const MIME = {
  '.swf': 'application/x-shockwave-flash', '.js': 'application/javascript', '.html': 'text/html; charset=utf-8',
  '.mp3': 'audio/mpeg', '.jpg': 'image/jpeg', '.png': 'image/png', '.gif': 'image/gif', '.xml': 'text/xml',
};
const CROSSDOMAIN = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*"/></cross-domain-policy>';
const POLICY = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*"/></cross-domain-policy>\0';
const auth = OZEL ? await authService.startAuth(PORT) : null;
if (auth) {
  net.createServer(sock => { sock.on('error', () => {}); sock.once('data', () => sock.end(POLICY)); }).on('error', e => console.error('[policy]', e.code)).listen(843, '127.0.0.1');
  let shuttingDown = false;
  const shutdown = async () => { if (shuttingDown) return; shuttingDown = true; try { await auth.close(); process.exit(0); } catch (e) { console.error('[shutdown] Save failed; local journal retained'); process.exit(1); } };
  process.on('SIGINT', shutdown); process.on('SIGTERM', shutdown);
}

const missLog = path.join(ROOT, 'eksik.log');
const note = s => { console.log(s); fs.appendFileSync(missLog, `${new Date().toISOString()}\t${s}\n`); };
function cachedTexture(version, category, filename) {
  const versions = fs.readdirSync(PUBLIC)
    .filter(name => /^\d+$/.test(name) && name !== version)
    .sort((a, b) => Number(b) - Number(a));
  for (const name of versions) {
    const candidate = path.join(PUBLIC, name, 'Resources', 'Textures', category, filename);
    if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) return candidate;
  }
  if (category.toLowerCase() === 'model') {
    const fallbackModel = path.join(PUBLIC, '2017112917', 'Resources', 'Textures', 'Model', '00A9FBAB.TexClient');
    return fs.existsSync(fallbackModel) && fs.statSync(fallbackModel).isFile() ? fallbackModel : null;
  }
  for (const name of versions) {
    const textures = path.join(PUBLIC, name, 'Resources', 'Textures');
    if (!fs.existsSync(textures)) continue;
    for (const dir of fs.readdirSync(textures, { withFileTypes: true })) {
      if (!dir.isDirectory() || dir.name.toLowerCase() === category.toLowerCase()) continue;
      const candidate = path.join(textures, dir.name, filename);
      if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) return candidate;
    }
  }
  if (category.toLowerCase() === 'skill') {
    for (const name of versions) {
      const candidate = path.join(PUBLIC, name, 'Resources', 'Textures', 'Skill', '00C7E3E1.TexClient');
      if (fs.existsSync(candidate) && fs.statSync(candidate).isFile()) return candidate;
    }
  }
  return null;
}
function cachedSwf(version, filename) {
  const versions = fs.readdirSync(PUBLIC)
    .filter(name => /^\d+$/.test(name) && name !== version)
    .sort((a, b) => Number(b) - Number(a));
  const ordered = [FALLBACK_SWF_VERSION, ...versions.filter(name => name !== FALLBACK_SWF_VERSION)];
  for (const name of ordered) {
    const candidate = path.join(PUBLIC, name, 'Resources', 'Swf', ...filename.split('/'));
    if (candidate.startsWith(path.join(PUBLIC, name, 'Resources', 'Swf') + path.sep) &&
        fs.existsSync(candidate) && fs.statSync(candidate).isFile()) return candidate;
  }
  return null;
}

// --- protokol yakalama (emülatör için) ---
// CAPTURE=1 ortam değişkeni ile açılır. Her bağlantının iki yönünü ayrı ham dosyaya (.c2s/.s2c)
// ve okunur bir hex/annotate akışına (protokol.log) döker.
const CAPTURE = process.env.CAPTURE === '1' || process.argv.includes('--capture');
const CAP_DIR = path.join(ROOT, 'yakala');
if (CAPTURE) { try { fs.mkdirSync(CAP_DIR, { recursive: true }); } catch {} }
const protoLog = path.join(CAP_DIR, 'protokol.log');
let capSeq = 0;
function hexDump(buf, max = 512) {
  const b = buf.subarray(0, max);
  let out = '';
  for (let i = 0; i < b.length; i += 16) {
    const slice = b.subarray(i, i + 16);
    const hex = [...slice].map(x => x.toString(16).padStart(2, '0')).join(' ');
    const asc = [...slice].map(x => (x >= 32 && x < 127) ? String.fromCharCode(x) : '.').join('');
    out += `  ${i.toString(16).padStart(4, '0')}  ${hex.padEnd(48)}  ${asc}\n`;
  }
  if (buf.length > max) out += `  ... (+${buf.length - max} bayt)\n`;
  return out;
}

let session = null;
const stats = { connections: 0, open: 0, up: 0, down: 0, lastError: '' };

const readBody = req => new Promise((resolve, reject) => {
  let body = '';
  req.on('data', c => { body += c; if (body.length > 100000) req.destroy(); });
  req.on('end', () => resolve(body));
  req.on('error', reject);
});

http.createServer(async (req, res) => {
  const u = new URL(req.url, 'http://x');
  if (auth) {
    try { if (await auth.handle(req, res, u.pathname)) return; }
    catch (e) { console.error('[request]', e.code || e.name); res.writeHead(503, { 'Content-Type': 'application/json; charset=utf-8' }); res.end(JSON.stringify({ error: 'Không thể tải dữ liệu nhân vật. Vui lòng thử lại.' })); return; }
    if (u.pathname === '/yerel/oturum') { res.writeHead(403); res.end(); return; }
  }
  const send = (code, body, type = 'application/octet-stream', cors = true) => {
    const headers = { 'Content-Type': type, 'Cache-Control': 'no-store' };
    if (cors) headers['Access-Control-Allow-Origin'] = '*';
    res.writeHead(code, headers);
    res.end(body);
  };

  if (u.pathname.startsWith('/yerel/')) {
    // Oturum uçları: yalnız bu adresten, CORS başlığı yok — başka bir site token'ı okuyamaz.
    if (req.headers.host !== HOST) return send(403, 'yasak', 'text/plain', false);
    if (u.pathname === '/yerel/oturum' && req.method === 'POST') {
      try {
        const fv = JSON.parse(await readBody(req));
        if (!fv.token || !fv.gatewayIP || !fv.gatewayPort) return send(400, 'eksik alan', 'text/plain', false);
        session = fv;
        console.log(`oturum alindi: gateway ${fv.gatewayIP}:${fv.gatewayPort}, sunucu ${fv.server}, surum ${fv.version}`);
        return send(204, '', 'text/plain', false);
      } catch {
        return send(400, 'gecersiz', 'text/plain', false);
      }
    }
    if (u.pathname === '/yerel/oturum.json') {
      if (!session) return send(404, 'oturum yok', 'text/plain', false);
      const local = { ...session, cdnRoot: `http://${HOST}/public/`, gatewayIP: '127.0.0.1', gatewayPort: String(GATE_PORT) };
      return send(200, JSON.stringify(local), 'application/json', false);
    }
    if (u.pathname === '/yerel/durum') {
      const info = { oturum: !!session, gateway: session && `${session.gatewayIP}:${session.gatewayPort}`, ...stats };
      return send(200, JSON.stringify(info), 'application/json', false);
    }
    if (u.pathname === '/yerel/dil') return send(200, JSON.stringify({ kod: DIL, mevcut: dilListesi() }), 'application/json', false);
    return send(404, 'yok', 'text/plain', false);
  }

  if (u.pathname === '/' || u.pathname === '/index.html') return send(200, fs.readFileSync(path.join(ROOT, 'launcher.html')), MIME['.html']);
  if (u.pathname === '/crossdomain.xml') return send(200, CROSSDOMAIN, MIME['.xml']);
  // launcher katmani icin ek gorseller (ROOT/gorsel)
  if (u.pathname.startsWith('/gorsel/')) {
    const g = path.join(ROOT, 'gorsel', path.normalize(decodeURIComponent(u.pathname.slice(8))).replace(/^[/\\]+/, ''));
    if (g.startsWith(path.join(ROOT, 'gorsel') + path.sep) && fs.existsSync(g) && fs.statSync(g).isFile()) return send(200, fs.readFileSync(g), MIME[path.extname(g).toLowerCase()] || 'application/octet-stream');
    return send(404, 'yok');
  }

  const rel = path.normalize(decodeURIComponent(u.pathname)).replace(/^[/\\]+/, '');
  let abs = path.join(SRC, rel);
  if (!abs.startsWith(SRC + path.sep)) return send(403, 'yasak');
  const type = MIME[path.extname(abs).toLowerCase()];

  // DIL: secili dil icin cevrilmis bin paketi varsa (Resources/Bin/dil-<kod>/...), "normal" yerine onu ver.
  // Cevrilmis paketler cikarim/dil-paketle.js ile uretilir (dil/<kod>.json -> SystemLanguage blogu).
  if (DIL && DIL !== 'en') {
    const m = abs.match(/^(.*[\\/]Resources[\\/]Bin[\\/])(normal|combine)([\\/][^\\/]+\.binPackage)$/i);
    if (m) { const alt = m[1] + 'dil-' + DIL + m[3]; if (fs.existsSync(alt)) abs = alt; }
  }

  if (fs.existsSync(abs) && fs.statSync(abs).isFile()) return send(200, fs.readFileSync(abs), type);

  const swf = u.pathname.match(/^\/public\/(\d+)\/Resources\/Swf\/(.+\.swf)$/i);
  const texture = u.pathname.match(/^\/public\/(\d+)\/Resources\/Textures\/([^/]+)\/([^/]+\.TexClient)$/i);
  const sound = u.pathname.match(/^\/public\/(\d+)\/Resources\/Sound\/(\d+\.mp3)$/i);
  const map = u.pathname.match(/^\/public\/(\d+)\/Resources\/Map\/([0-9a-f]+\.bin)$/i);
  const fallback = () => {
    if (sound || map) {
      const asset=sound||map,category=sound?'Sound':'Map';
      const versions=fs.readdirSync(PUBLIC).filter(name=>/^\d+$/.test(name)&&name!==asset[1]).sort((a,b)=>Number(b)-Number(a));
      for(const version of versions){
        const cached=path.join(PUBLIC,version,'Resources',category,asset[2]);
        if(fs.existsSync(cached)&&fs.statSync(cached).isFile()){
          note(`${category.toUpperCase()}-FALLBACK\t${u.pathname}\t${path.relative(PUBLIC,cached)}`);
          send(200,fs.readFileSync(cached),sound?'audio/mpeg':'application/octet-stream');return true;
        }
      }
      return false;
    }
    if (swf) {
      const cached = cachedSwf(swf[1], swf[2]);
      if (!cached) return false;
      note(`SWF-FALLBACK\t${u.pathname}\t${path.relative(PUBLIC, cached)}`);
      send(200, fs.readFileSync(cached), type);
      return true;
    }
    if (!texture) return false;
    const cached = cachedTexture(texture[1], texture[2], texture[3]);
    if (!cached) return false;
    note(`TEXTURE-FALLBACK\t${u.pathname}\t${path.relative(PUBLIC, cached)}`);
    send(200, fs.readFileSync(cached), type);
    return true;
  };
  if (!FETCH) {
    if (fallback()) return;
    note(`YOK\t${u.pathname}`);
    return send(404, 'yok');
  }
  try {
    const r = await fetch(LIVE + u.pathname + u.search, { headers: { Referer: `${LIVE}/api/joyfun/login.php` } });
    if (!r.ok) {
      if (fallback()) return;
      note(`CANLI-${r.status}\t${u.pathname}`);
      return send(r.status, 'canli yok');
    }
    const buf = Buffer.from(await r.arrayBuffer());
    fs.mkdirSync(path.dirname(abs), { recursive: true });
    fs.writeFileSync(abs, buf);
    note(`CEKILDI\t${buf.length}\t${u.pathname}`);
    send(200, buf, type);
  } catch (err) {
    if (fallback()) return;
    note(`HATA\t${u.pathname}\t${err.message}`);
    send(502, 'hata');
  }
}).listen(PORT, '127.0.0.1', () => console.log(`http://${HOST}/  (fetch-missing: ${FETCH}, dil: ${DIL}, mevcut diller: ${dilListesi().join(',')})`));

// Ozel sunucu modunda 843 + 10025 oyun-sunucu.js tarafindan dinlenir.
if (!OZEL) {
// Flash socket izin dosyası (istemci önce 843'e sorar)
net.createServer(sock => {
  sock.on('error', () => {});
  sock.once('data', () => sock.end(POLICY));
}).on('error', e => console.log(`843 dinlenemedi: ${e.message}`)).listen(843, '127.0.0.1');

// Oyun sunucusu proxy'si: 127.0.0.1:10025 → canlı gateway (oturumdaki adres)
net.createServer(client => {
  stats.connections++;
  stats.open++;
  client.on('close', () => { stats.open--; });
  client.on('error', () => {});
  client.once('data', first => {
    if (first.toString('latin1').startsWith('<policy-file-request/>')) return client.end(POLICY);
    if (!session) { stats.lastError = 'oturum yok'; return client.destroy(); }
    const up = net.connect(Number(session.gatewayPort), session.gatewayIP);

    // --- protokol yakalama ---
    let cap = null;
    if (CAPTURE) {
      const id = ++capSeq;
      const ts = new Date().toISOString().replace(/[:.]/g, '-');
      cap = {
        c2s: fs.createWriteStream(path.join(CAP_DIR, `${ts}_conn${id}.c2s.bin`)),
        s2c: fs.createWriteStream(path.join(CAP_DIR, `${ts}_conn${id}.s2c.bin`)),
        log: (dir, d) => {
          fs.appendFileSync(protoLog,
            `\n[${new Date().toISOString()}] conn${id} ${dir} ${d.length} bayt\n${hexDump(d)}`);
        },
      };
      cap.c2s.write(first);
      cap.log('C2S', first);
    }

    up.write(first); // bağlanana kadar sırayla tamponlanır
    stats.up += first.length;
    client.on('data', d => { stats.up += d.length; if (cap) { cap.c2s.write(d); cap.log('C2S', d); } });
    up.on('data', d => { stats.down += d.length; if (cap) { cap.s2c.write(d); cap.log('S2C', d); } });
    client.pipe(up);
    up.pipe(client);
    up.on('error', e => { stats.lastError = e.message; client.destroy(); });
    up.on('close', () => { if (cap) { cap.c2s.end(); cap.s2c.end(); } client.destroy(); });
    client.on('close', () => up.destroy());
  });
}).on('error', e => console.log(`${GATE_PORT} dinlenemedi: ${e.message}`)).listen(GATE_PORT, '127.0.0.1');
} // if(!OZEL)
