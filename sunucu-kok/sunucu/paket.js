'use strict';
// ORTAK PAKET YARDIMCILARI: BE yazici/okuyucu, tablo yukleyici (hex id -> satir), ConfigValue, zaman.
const fs = require('fs');
const path = require('path');
const VJ = path.join(__dirname, '..', 'cikarim', 'veri-json');

class Y {
  constructor() { this.p = []; }
  u8(v) { this.p.push(Buffer.from([v & 0xff])); return this; }
  i8(v) { const b = Buffer.alloc(1); b.writeInt8(Math.max(-128, Math.min(127, v | 0))); this.p.push(b); return this; }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.p.push(b); return this; }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(Math.max(-32768, Math.min(32767, v | 0))); this.p.push(b); return this; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(Math.max(0, Math.min(0xffffffff, Math.floor(Number(v) || 0))) >>> 0); this.p.push(b); return this; }
  i32(v) { const b = Buffer.alloc(4); b.writeInt32BE(Math.max(-2147483648, Math.min(2147483647, Math.floor(Number(v) || 0))) | 0); this.p.push(b); return this; }
  f64(v) { const b=Buffer.alloc(8); b.writeDoubleBE(Number(v)||0); this.p.push(b); return this; }
  f32(v) { const b = Buffer.alloc(4); b.writeFloatBE(Number(v) || 0); this.p.push(b); return this; }
  bool(v) { return this.u8(v ? 1 : 0); }
  i64(v) { const n = Math.max(0, Math.floor(Number(v) || 0)); return this.u32(Math.floor(n / 4294967296)).u32(n % 4294967296); }   // high, low
  utf(s) { const b = Buffer.from(String(s == null ? '' : s), 'utf8'); this.u16(b.length); this.p.push(b); return this; }
  raw(b) { if (b && b.length) this.p.push(b); return this; }
  // REWARD_LIST: [u16 n] + n x (u16 type, u32 code, u32 amount)
  odul(list) { const l = (list || []).filter(x => x); this.u16(l.length); for (const x of l) this.u16(x.type || 0).u32(x.code || 0).u32(x.amount || 1); return this; }
  done() { return Buffer.concat(this.p); }
}
class O {
  constructor(b) { this.b = b || Buffer.alloc(0); this.p = 0; }
  ok(n) { return this.p + n <= this.b.length; }
  u8() { return this.ok(1) ? this.b[this.p++] : 0; }
  i8() { return this.ok(1) ? this.b.readInt8(this.p++) : 0; }
  u16() { if (!this.ok(2)) return 0; const v = this.b.readUInt16BE(this.p); this.p += 2; return v; }
  i16() { if (!this.ok(2)) return 0; const v = this.b.readInt16BE(this.p); this.p += 2; return v; }
  u32() { if (!this.ok(4)) return 0; const v = this.b.readUInt32BE(this.p); this.p += 4; return v; }
  i32() { if (!this.ok(4)) return 0; const v = this.b.readInt32BE(this.p); this.p += 4; return v; }
  utf() { const n = this.u16(); if (!this.ok(n)) return ''; const s = this.b.subarray(this.p, this.p + n).toString('utf8'); this.p += n; return s; }
  kalan() { return this.b.length - this.p; }
}

// ---- tablolar (hex id) ----
const TABLO = new Map();
function tablo(ad) {
  if (TABLO.has(ad)) return TABLO.get(ad);
  let liste = [];
  try { liste = JSON.parse(fs.readFileSync(path.join(VJ, ad + '.json'), 'utf8')); } catch (e) {
    try { liste = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json-yedek', ad + '.json'), 'utf8')); } catch (e2) { liste = []; }
  }
  const byId = new Map();
  liste = require('./retired-heroes').filterTable(ad,liste);
  for (const r of liste) { const id = parseInt(r.id, 16) >>> 0; r._id = id; byId.set(id, r); }
  const t = { ad, liste, byId, ids: [...byId.keys()] };
  TABLO.set(ad, t);
  return t;
}
function satir(ad, id) { return tablo(ad).byId.get(Number(id) >>> 0) || null; }
function json(s, vars) { if (s == null) return vars; if (typeof s !== 'string') return s; try { return JSON.parse(s); } catch (e) { return vars; } }
// ConfigValue.isClient = deger (string/JSON)
function cv(id, vars) {
  const r = satir('ConfigValue', id);
  if (!r) return vars;
  const v = r.isClient;
  if (typeof v === 'string') { const j = json(v, undefined); return j === undefined ? (isNaN(Number(v)) ? v : Number(v)) : j; }
  return v;
}
function simdi() { return Math.floor(Date.now() / 1000); }
// YEREL tarih (UTC degil): client "bugun"u ServerTime (yerel) ile hesaplar; gece 00-03 arasi UTC bir onceki gundur.
function gun() { const d = new Date(); return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }
// gunluk sayaclar: durum.gunluk = { gun, ... } (gun degisince sifirlanir)
function gunluk(durum) {
  if (!durum.gunlukSayac || durum.gunlukSayac.gun !== gun()) durum.gunlukSayac = { gun: gun() };
  return durum.gunlukSayac;
}
function hata(k) { return new Y().u32(k >>> 0).done(); }
function rnd(n) { return Math.floor(Math.random() * n); }
function sec(arr) { return arr[rnd(arr.length)]; }

module.exports = { Y, O, tablo, satir, json, cv, simdi, gun, gunluk, hata, rnd, sec, VJ };
