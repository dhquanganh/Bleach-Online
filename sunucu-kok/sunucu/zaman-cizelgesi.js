'use strict';
// protokol.log sırası (iki yön iç içe, ama payload 512B'de kesik) + bin'lerin TAM payload'ları
// birleştirilip lockstep zaman çizelgesi (timeline.json + payload dosyaları) üretir.
const fs = require('fs');
const path = require('path');
const { parseStream } = require('./cerceve');

const ROOT = path.join(__dirname, '..');
const CAP = path.join(ROOT, 'yakala');
const OUTDIR = path.join(__dirname, 'zaman');
fs.mkdirSync(OUTDIR, { recursive: true });
fs.mkdirSync(path.join(OUTDIR, 'p'), { recursive: true });

// 1) bin'leri parse et -> per (conn,dir) sıralı payload kuyruğu
const bins = fs.readdirSync(CAP).filter(f => f.endsWith('.bin'));
const queues = {}; // key conn|dir -> {packets, idx}
for (const f of bins) {
  const m = /_(conn\d+)\.(c2s|s2c)\.bin$/.exec(f);
  if (!m) continue;
  const buf = fs.readFileSync(path.join(CAP, f));
  const { packets } = parseStream(buf);
  queues[`${m[1]}|${m[2]}`] = { packets, idx: 0 };
}

// 2) protokol.log başlık satırlarını sırayla oku: "[ts] connN DIR N bayt"
const log = fs.readFileSync(path.join(CAP, 'protokol.log'), 'utf8').split('\n');
const rx = /\]\s+(conn\d+)\s+(C2S|S2C)\s+(\d+)\s+bayt/;
const timeline = [];
let seq = 0;
for (const line of log) {
  const m = rx.exec(line);
  if (!m) continue;
  const conn = m[1], dir = m[2].toLowerCase(), len = Number(m[3]);
  const q = queues[`${conn}|${dir}`];
  if (!q || q.idx >= q.packets.length) continue;
  const pk = q.packets[q.idx++];
  const fn = `${String(seq).padStart(3, '0')}_${conn}_${dir}_0x${(pk.id >>> 0).toString(16).padStart(8, '0')}.bin`;
  fs.writeFileSync(path.join(OUTDIR, 'p', fn), pk.payload);
  timeline.push({ seq, conn, dir, id: '0x' + (pk.id >>> 0).toString(16).padStart(8, '0'), len: pk.payload.length, file: 'p/' + fn });
  seq++;
}
fs.writeFileSync(path.join(OUTDIR, 'timeline.json'), JSON.stringify(timeline, null, 2));

const c2s = timeline.filter(t => t.dir === 'c2s').length;
const s2c = timeline.filter(t => t.dir === 's2c').length;
console.log(`timeline: ${timeline.length} olay (${c2s} C2S, ${s2c} S2C) -> ${OUTDIR}\\timeline.json`);
// kuyruk artigi
for (const [k, q] of Object.entries(queues)) {
  if (q.idx < q.packets.length) console.log(`  uyari: ${k} kuyrukta ${q.packets.length - q.idx} paket eslenemedi`);
}
