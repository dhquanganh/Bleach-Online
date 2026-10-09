'use strict';
// Güçlü sunucu logger: her paket (tam hex + opcode adi + cevap tipi), baglanti yasam dongusu,
// dongu/anomali tespiti. Dosya: yakala/sunucu-canli.log (+ jsonl).
const fs = require('fs');
const path = require('path');

const DIR = path.join(__dirname, '..', 'yakala');
try { fs.mkdirSync(DIR, { recursive: true }); } catch {}
const LOG = path.join(DIR, 'sunucu-canli.log');
const JL = path.join(DIR, 'sunucu-canli.jsonl');

// opcode kategori adlandirma (CONST_NETWORK semasi)
function opName(id) {
  const hi = (id >>> 16) & 0xffff, lo = id & 0xffff;
  const cat = { 0x0181: 'CS_LOBBY', 0x0118: 'SC_LOBBY', 0x0161: 'CS_AS', 0x0116: 'SC_AS', 0x0171: 'CS_CENTER', 0x0117: 'SC_CENTER', 0x0145: 'CS_CS', 0x0163: 'CS_CS' }[hi] || 'UNK';
  return `${cat}+0x${lo.toString(16).padStart(4, '0')}`;
}

function hex(buf, max = 256) {
  const b = buf.subarray(0, max);
  let s = [...b].map(x => x.toString(16).padStart(2, '0')).join(' ');
  if (buf.length > max) s += ` …(+${buf.length - max})`;
  return s;
}

let seq = 0;
const opCount = {};        // conn:op -> sayi (dongu tespiti)
const conns = {};          // id -> {up,down,packets,opened}

function line(s) { try { fs.appendFileSync(LOG, s + '\n'); } catch {} }
function jl(o) { try { fs.appendFileSync(JL, JSON.stringify(o) + '\n'); } catch {} }

function reset() {
  try { fs.writeFileSync(LOG, `=== sunucu-canli.log  ${new Date().toISOString()} ===\n`); fs.writeFileSync(JL, ''); } catch {}
  seq = 0; for (const k in opCount) delete opCount[k]; for (const k in conns) delete conns[k];
}

// TELEMETRI: her olay ayrica oyun.db'ye yazilir (sunucu/telemetri.js).
// Tamamen best-effort — DB yoksa/hata verirse oyun akisi ETKILENMEZ.
let T = null;
try { T = require('./telemetri'); } catch (e) { T = null; }
const tel = fn => { if (!T) return; try { fn(T); } catch (e) {} };

function connOpen(id, peer) {
  conns[id] = { up: 0, down: 0, packets: 0, opened: Date.now() };
  line(`\n[+] conn${id} baglandi  ${peer}  @${new Date().toISOString()}`);
  jl({ t: Date.now(), ev: 'open', conn: id, peer });
  tel(t => t.oturumAc(id));
}
function connClose(id, reason) {
  const c = conns[id] || {};
  line(`[-] conn${id} kapandi  (${reason})  paket=${c.packets} up=${c.up}B down=${c.down}B sure=${Date.now() - (c.opened || Date.now())}ms`);
  jl({ t: Date.now(), ev: 'close', conn: id, reason, ...c });
  tel(t => t.oturumKapat(id));
}

// C2S paketi
function c2s(id, pk) {
  const c = conns[id] || (conns[id] = { up: 0, down: 0, packets: 0, opened: Date.now() });
  c.up += pk.payload.length; c.packets++;
  const key = id + ':' + pk.id;
  opCount[key] = (opCount[key] || 0) + 1;
  const loop = opCount[key];
  const warn = loop === 25 ? '  ⚠️DONGU-BASLADI' : (loop > 25 && loop % 50 === 0 ? `  ⚠️DONGU x${loop}` : '');
  line(`  #${++seq} conn${id} C2S ${opName(pk.id)} (0x${(pk.id >>> 0).toString(16)}) len=${pk.payload.length}${warn}`);
  if (pk.payload.length) line(`        ${hex(pk.payload)}`);
  jl({ t: Date.now(), ev: 'c2s', seq, conn: id, id: '0x' + (pk.id >>> 0).toString(16), name: opName(pk.id), len: pk.payload.length, hex: hex(pk.payload, 512), loop });
  tel(t => t.olay(id, 'c2s', pk.id, pk.payload.length));
}

// S2C cevabi
function s2c(id, respId, payload, kaynak) {
  const c = conns[id]; if (c) c.down += payload.length;
  line(`      -> S2C ${opName(respId)} (0x${(respId >>> 0).toString(16)}) len=${payload.length} [${kaynak}]`);
  jl({ t: Date.now(), ev: 's2c', conn: id, id: '0x' + (respId >>> 0).toString(16), name: opName(respId), len: payload.length, kaynak });
  tel(t => t.olay(id, 's2c', respId, payload.length));
}
function note(id, msg) { line(`      ! conn${id} ${msg}`); jl({ t: Date.now(), ev: 'note', conn: id, msg }); }

module.exports = { reset, connOpen, connClose, c2s, s2c, note, opName };
