'use strict';
// Yakalanan ham akışları (yakala/*.c2s.bin, *.s2c.bin) paketlere ayrıştırır.
// Kullanım: node sunucu/ayristir.js
const fs = require('fs');
const path = require('path');
const { parseStream, idName } = require('./cerceve');

const ROOT = path.join(__dirname, '..');
const CAP = path.join(ROOT, 'yakala');
const OUT = path.join(ROOT, 'sunucu', 'cozum');
fs.mkdirSync(OUT, { recursive: true });

function hexPreview(buf, n = 48) {
  return [...buf.subarray(0, n)].map(x => x.toString(16).padStart(2, '0')).join(' ') + (buf.length > n ? ' …' : '');
}

const files = fs.readdirSync(CAP).filter(f => f.endsWith('.bin'));
const conns = {};
for (const f of files) {
  const m = /_(conn\d+)\.(c2s|s2c)\.bin$/.exec(f);
  if (!m) continue;
  (conns[m[1]] ||= {})[m[2]] = path.join(CAP, f);
}

const summary = [];
for (const [conn, dirs] of Object.entries(conns)) {
  for (const dir of ['c2s', 's2c']) {
    if (!dirs[dir]) continue;
    const buf = fs.readFileSync(dirs[dir]);
    if (buf.length === 0) continue;
    const { packets, rest } = parseStream(buf);
    console.log(`\n=== ${conn} ${dir.toUpperCase()} (${buf.length} bayt, ${packets.length} paket${rest.length ? ', kalan ' + rest.length : ''}) ===`);
    packets.forEach((p, i) => {
      console.log(`  [${i}] id=${idName(p.id)} len=${p.payload.length}  ${hexPreview(p.payload)}`);
      // her paketi diske de yaz
      const fn = `${conn}_${dir}_${String(i).padStart(3, '0')}_${idName(p.id)}.bin`;
      fs.writeFileSync(path.join(OUT, fn), p.payload);
      summary.push({ conn, dir, index: i, id: idName(p.id), len: p.payload.length });
    });
  }
}
fs.writeFileSync(path.join(OUT, '_ozet.json'), JSON.stringify(summary, null, 2));
console.log(`\nToplam ${summary.length} paket -> ${OUT}`);

// opcode istatistiği
const byId = {};
for (const s of summary) { const k = `${s.dir} ${s.id}`; byId[k] = (byId[k] || 0) + 1; }
console.log('\n=== opcode dagilimi ===');
Object.entries(byId).sort((a, b) => b[1] - a[1]).forEach(([k, n]) => console.log(`  ${k}  x${n}`));
