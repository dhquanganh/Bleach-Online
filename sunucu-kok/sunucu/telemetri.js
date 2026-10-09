'use strict';
// TELEMETRI — oyunda atilan her adim oyun.db'ye yazilir.
//
// Olculenler: oturum suresi, giris sayisi, kac FARKLI gun girildigi, hangi panel/ozellige
// kac kez girildigi (opcode -> PACKETID adi), kazanilan her odul kalemi, paket/trafik hacmi.
//
// TASARIM KURALLARI:
//  1) Oyunu ASLA bozmaz: her yazim try/catch, DB yoksa sessizce devre disi kalir.
//  2) Paket basina senkron INSERT yapilmaz — olaylar bellekte biriktirilip toplu (tek
//     transaction) yazilir. Girise ~340 paket dusuyor; tek tek yazmak gecikme yaratirdi.
//  3) Opcode adlari cevap-haritasi.json'daki `isim` haritasindan gelir (843 kayit).
const fs = require('fs');
const path = require('path');

const FLUSH_ADET = 200;          // bu kadar olay birikince yaz
const FLUSH_MS = 5000;           // ya da bu kadar sure gecince

let DB = null, KAPALI = false;
function db() {
  if (KAPALI) return null;
  if (DB) return DB;
  try { DB = require('./db').ac(); sema(); } catch (e) { KAPALI = true; DB = null; }
  return DB;
}

function sema() {
  DB.exec(`
    CREATE TABLE IF NOT EXISTS t_oturum (
      id        INTEGER PRIMARY KEY AUTOINCREMENT,
      baslangic INTEGER NOT NULL,
      bitis     INTEGER,
      sure      INTEGER,
      paket     INTEGER NOT NULL DEFAULT 0,
      giden     INTEGER NOT NULL DEFAULT 0,
      gelen     INTEGER NOT NULL DEFAULT 0,
      gun       TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS t_olay (
      oturum   INTEGER NOT NULL,
      zaman    INTEGER NOT NULL,
      yon      TEXT NOT NULL,          -- c2s | s2c
      opcode   TEXT NOT NULL,
      ad       TEXT,                    -- PACKETID_... (panel/ozellik adi)
      uzunluk  INTEGER NOT NULL DEFAULT 0
    );
    CREATE INDEX IF NOT EXISTS ix_olay_ad     ON t_olay(ad);
    CREATE INDEX IF NOT EXISTS ix_olay_oturum ON t_olay(oturum);
    CREATE INDEX IF NOT EXISTS ix_olay_zaman  ON t_olay(zaman);
    CREATE TABLE IF NOT EXISTS t_odul (
      oturum INTEGER, zaman INTEGER NOT NULL, kaynak TEXT,
      tur INTEGER, kod INTEGER, miktar INTEGER
    );
    CREATE INDEX IF NOT EXISTS ix_odul_kod ON t_odul(kod);
    CREATE TABLE IF NOT EXISTS t_gun (
      gun    TEXT PRIMARY KEY,
      giris  INTEGER NOT NULL DEFAULT 0,
      sure   INTEGER NOT NULL DEFAULT 0,
      paket  INTEGER NOT NULL DEFAULT 0
    );
    CREATE TABLE IF NOT EXISTS t_ozet (anahtar TEXT PRIMARY KEY, deger TEXT NOT NULL);
  `);
}

// ---- opcode -> insan okunur ad ----
let ISIM = null;
function isim(opcodeHex) {
  if (!ISIM) {
    ISIM = {};
    try { ISIM = JSON.parse(fs.readFileSync(path.join(__dirname, 'cevap-haritasi.json'), 'utf8')).isim || {}; } catch (e) {}
  }
  return ISIM[opcodeHex] || null;
}

const gunAdi = t => new Date(t).toISOString().slice(0, 10);

// ---- oturumlar ----
const OTURUM = new Map();        // connId -> {id, baslangic, paket, giden, gelen}
let TAMPON = [];                 // bekleyen olaylar
let sonFlush = Date.now();

function oturumAc(connId) {
  const d = db(); if (!d) return;
  try {
    const t = Date.now();
    const r = d.prepare('INSERT INTO t_oturum (baslangic,gun) VALUES (?,?)').run(t, gunAdi(t));
    const id = Number(r.lastInsertRowid);
    OTURUM.set(connId, { id, baslangic: t, paket: 0, giden: 0, gelen: 0 });
    d.prepare(`INSERT INTO t_gun (gun,giris) VALUES (?,1)
               ON CONFLICT(gun) DO UPDATE SET giris = giris + 1`).run(gunAdi(t));
    sayacArtir(d, 'toplamGiris', 1);
  } catch (e) {}
}

function oturumKapat(connId) {
  const d = db(); if (!d) return;
  const o = OTURUM.get(connId); if (!o) return;
  try {
    flush();
    const t = Date.now(), sure = t - o.baslangic;
    d.prepare('UPDATE t_oturum SET bitis=?, sure=?, paket=?, giden=?, gelen=? WHERE id=?')
      .run(t, sure, o.paket, o.giden, o.gelen, o.id);
    d.prepare(`INSERT INTO t_gun (gun,sure,paket) VALUES (?,?,?)
               ON CONFLICT(gun) DO UPDATE SET sure = sure + excluded.sure, paket = paket + excluded.paket`)
      .run(gunAdi(o.baslangic), sure, o.paket);
    sayacArtir(d, 'toplamSure', sure);
    sayacArtir(d, 'toplamPaket', o.paket);
  } catch (e) {}
  OTURUM.delete(connId);
}

function sayacArtir(d, anahtar, delta) {
  try {
    d.prepare(`INSERT INTO t_ozet (anahtar,deger) VALUES (?,?)
               ON CONFLICT(anahtar) DO UPDATE SET deger = CAST(CAST(deger AS INTEGER) + ? AS TEXT)`)
      .run(anahtar, String(delta), delta);
  } catch (e) {}
}

// ---- olaylar (tamponlu) ----
function olay(connId, yon, opcodeId, uzunluk) {
  if (KAPALI) return;
  const o = OTURUM.get(connId);
  const hex = '0x' + (opcodeId >>> 0).toString(16).padStart(8, '0');
  if (o) { o.paket++; if (yon === 'c2s') o.giden += uzunluk; else o.gelen += uzunluk; }
  TAMPON.push([o ? o.id : 0, Date.now(), yon, hex, isim(hex), uzunluk | 0]);
  if (TAMPON.length >= FLUSH_ADET || Date.now() - sonFlush > FLUSH_MS) flush();
}

function flush() {
  const d = db(); if (!d || !TAMPON.length) return;
  const veri = TAMPON; TAMPON = [];
  try {
    const st = d.prepare('INSERT INTO t_olay (oturum,zaman,yon,opcode,ad,uzunluk) VALUES (?,?,?,?,?,?)');
    d.exec('BEGIN');
    try { for (const r of veri) st.run(r[0], r[1], r[2], r[3], r[4], r[5]); d.exec('COMMIT'); }
    catch (e) { try { d.exec('ROLLBACK'); } catch (e2) {} }
  } catch (e) {}
  sonFlush = Date.now();
}

/** Kazanilan odul kalemleri: [{type, code, amount}] */
function odul(connId, kaynak, oduller) {
  const d = db(); if (!d || !Array.isArray(oduller) || !oduller.length) return;
  const o = OTURUM.get(connId);
  try {
    const st = d.prepare('INSERT INTO t_odul (oturum,zaman,kaynak,tur,kod,miktar) VALUES (?,?,?,?,?,?)');
    const t = Date.now();
    d.exec('BEGIN');
    try {
      for (const a of oduller) st.run(o ? o.id : 0, t, String(kaynak || ''), (a.type | 0), (a.code | 0), (a.amount | 0) || 1);
      d.exec('COMMIT');
    } catch (e) { try { d.exec('ROLLBACK'); } catch (e2) {} }
    sayacArtir(d, 'toplamOdulKalemi', oduller.length);
  } catch (e) {}
}

/** Rapor: toplam sure, giris, farkli gun, en cok girilen paneller, en cok kazanilan odul. */
function rapor(limit = 12) {
  const d = db(); if (!d) return null;
  flush();
  const tek = s => { try { return d.prepare(s).get(); } catch (e) { return {}; } };
  const cok = (s, n) => { try { return d.prepare(s).all(n); } catch (e) { return []; } };
  return {
    oturum: tek('SELECT COUNT(*) adet, SUM(sure) toplamSure, MIN(baslangic) ilk, MAX(baslangic) son FROM t_oturum'),
    gun: tek('SELECT COUNT(*) farkliGun, SUM(giris) toplamGiris, SUM(sure) toplamSure FROM t_gun'),
    olay: tek('SELECT COUNT(*) adet FROM t_olay'),
    paneller: cok(`SELECT ad, COUNT(*) adet FROM t_olay WHERE yon='c2s' AND ad IS NOT NULL
                   GROUP BY ad ORDER BY adet DESC LIMIT ?`, limit),
    oduller: cok(`SELECT kod, SUM(miktar) toplam, COUNT(*) kez FROM t_odul
                  GROUP BY kod ORDER BY toplam DESC LIMIT ?`, limit),
    gunluk: cok('SELECT gun, giris, sure, paket FROM t_gun ORDER BY gun DESC LIMIT ?', limit),
  };
}

module.exports = { oturumAc, oturumKapat, olay, odul, flush, rapor };
