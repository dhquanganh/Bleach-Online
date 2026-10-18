'use strict';
// VERITABANI OKUMA KATMANI — sunucu ve (ayni sema ile) mobil motor bunu kullanir.
//
// Iki isi var:
//   1) 326 oyun tablosuna tek noktadan erisim (JSON dosyalarini tek tek okumak yerine)
//   2) RESKIN: isim/aciklama degisiklikleri `metin` tablosunda durur ve okuma sirasinda
//      SATIRIN UZERINE gecirilir. Orijinal veri hic bozulmaz -> geri almak tek UPDATE.
//
// Kurulum: node cikarim/db-kur.js
const fs = require('fs');
const path = require('path');
const { DatabaseSync } = require('node:sqlite');

const DB_DOSYA = path.join(__dirname, 'oyun.db');

let db = null;
function ac() {
  if (db) return db;
  if (!fs.existsSync(DB_DOSYA)) {
    throw new Error('oyun.db yok — once kur: node cikarim/db-kur.js');
  }
  db = new DatabaseSync(DB_DOSYA, { readOnly: Boolean(process.env.BLEACH_ACCOUNT_DIR) });
  return db;
}
function kapat() { if (db) { try { db.close(); } catch (e) {} db = null; } }

// --- reskin override'lari (tablo basina bir kez okunur) ---
const OVR = new Map();          // tablo -> Map("kayitId|alan" -> yeniDeger)
function overrideHarita(tablo) {
  if (OVR.has(tablo)) return OVR.get(tablo);
  const m = new Map();
  try {
    for (const r of ac().prepare(
      "SELECT kayit,alan,yeni FROM metin WHERE tablo=? AND yeni IS NOT NULL AND yeni<>''").all(tablo)) {
      m.set(r.kayit + '|' + r.alan, r.yeni);
    }
  } catch (e) {}
  OVR.set(tablo, m);
  return m;
}
function uygula(tablo, satir) {
  const m = overrideHarita(tablo);
  if (!m.size || satir.id === undefined) return satir;
  let kopya = null;
  for (const k of Object.keys(satir)) {
    const y = m.get(satir.id + '|' + k);
    if (y !== undefined) { kopya = kopya || { ...satir }; kopya[k] = y; }
  }
  return kopya || satir;
}

// --- okuma API'si ---
const TABLO_ONBELLEK = new Map();

/** Bir oyun tablosunun TAMAMI (kaynak sirasinda, reskin uygulanmis). */
function tablo(ad) {
  if (TABLO_ONBELLEK.has(ad)) return TABLO_ONBELLEK.get(ad);
  const satirlar = ac().prepare('SELECT json FROM veri WHERE tablo=? ORDER BY sira').all(ad)
    .map(s => uygula(ad, JSON.parse(s.json)));
  TABLO_ONBELLEK.set(ad, satirlar);
  return satirlar;
}

/** Tek kayit. id sayisal (11100005) veya hex string ("00A95F65") olabilir. */
function satir(ad, id) {
  const d = ac();
  let r = null;
  if (typeof id === 'number') r = d.prepare('SELECT json FROM veri WHERE tablo=? AND sayi=?').get(ad, id >>> 0);
  else r = d.prepare('SELECT json FROM veri WHERE tablo=? AND id=?').get(ad, String(id));
  return r ? uygula(ad, JSON.parse(r.json)) : null;
}

/** Sayisal id -> kayit haritasi (oyun kodu cogunlukla boyle ariyor). */
function harita(ad) {
  const m = new Map();
  for (const r of ac().prepare('SELECT sayi,json FROM veri WHERE tablo=? ORDER BY sira').all(ad)) {
    if (r.sayi !== null) m.set(r.sayi >>> 0, uygula(ad, JSON.parse(r.json)));
  }
  return m;
}

function tablolar() { return ac().prepare('SELECT ad,kayit,vo,eskiAd FROM tablo ORDER BY ad').all(); }
function odul(id) { const r = ac().prepare('SELECT json FROM odul WHERE id=?').get(String(id)); return r ? JSON.parse(r.json) : null; }

// --- oyuncu durumu ---
function durumOku(bolum) {
  const o = {};
  for (const r of ac().prepare('SELECT anahtar,deger FROM durum WHERE bolum=?').all(bolum)) {
    try { o[r.anahtar] = JSON.parse(r.deger); } catch (e) { o[r.anahtar] = r.deger; }
  }
  return o;
}
function durumYaz(bolum, obj) {
  if (process.env.BLEACH_ACCOUNT_DIR) return; // Account snapshots are persisted to MongoDB by the supervisor.
  const d = ac();
  const st = d.prepare('INSERT OR REPLACE INTO durum (bolum,anahtar,deger) VALUES (?,?,?)');
  d.exec('BEGIN');
  try { for (const [k, v] of Object.entries(obj)) st.run(bolum, k, JSON.stringify(v)); d.exec('COMMIT'); }
  catch (e) { try { d.exec('ROLLBACK'); } catch (e2) {} throw e; }
}

// --- RESKIN yazma ---
/** Tek metni degistir. anahtar = "<Tablo>.<kayitId>.<alan>" */
function metinAyarla(anahtar, yeni) {
  // node:sqlite `changes` ayarlara gore BigInt donebiliyor -> Number'a cevir (karisik aritmetik patlar)
  const n = Number(ac().prepare('UPDATE metin SET yeni=? WHERE anahtar=?').run(yeni, anahtar).changes);
  OVR.clear(); TABLO_ONBELLEK.clear();
  return n > 0;
}
/** Toplu: { "BaseHero.00A95F61.name": "Yeni Ad", ... } */
function metinTopluAyarla(obj) {
  const d = ac();
  const st = d.prepare('UPDATE metin SET yeni=? WHERE anahtar=?');
  let n = 0;
  d.exec('BEGIN');
  try { for (const [k, v] of Object.entries(obj)) n += Number(st.run(v, k).changes); d.exec('COMMIT'); }
  catch (e) { try { d.exec('ROLLBACK'); } catch (e2) {} throw e; }
  OVR.clear(); TABLO_ONBELLEK.clear();
  return n;
}
/** Bir metnin orijinalini/gecerli halini gor. */
function metinAra(desen, limit = 50) {
  return ac().prepare(
    "SELECT anahtar,tablo,alan,orijinal,yeni FROM metin WHERE orijinal LIKE ? ORDER BY tablo LIMIT ?"
  ).all('%' + desen + '%', limit);
}
/** Reskin ilerlemesi. */
function metinDurum() {
  return ac().prepare(
    "SELECT COUNT(*) toplam, SUM(CASE WHEN yeni IS NOT NULL AND yeni<>'' THEN 1 ELSE 0 END) degisen FROM metin"
  ).get();
}

module.exports = {
  ac, kapat, tablo, satir, harita, tablolar, odul,
  durumOku, durumYaz,
  metinAyarla, metinTopluAyarla, metinAra, metinDurum,
  DB_DOSYA,
};
