'use strict';
// ZAMANLI ETKINLIKLER (DailyActivity) — modul 15104 (0x3B00).
// Bu surumdeki "dunya bossu" karsiligi burasi: Evil Spirit x3, Guild War,
// Protect Seireitei, Ryoka Attack, Void Region. (Ayri bir WorldBoss modulu YOK;
// MODULARID listesinin tamami tarandi — WorldBoss yalniz DailyWelfare'deki
// WorldBossLv ALANI olarak geciyor.)
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// CS 0x01813b00 AutomaticStatusReq  (payload yok)
//  -> SC 0x01183b00 StatusRet = [i16 adet] + adet x (i8 Type, i8 IsSign, i8 CanSign,
//                                                    u32 Silver, u32 Exp)      = 2 + 11n
//     NOT: parser'in IKI dali var (ilk kurulum / guncelleme) ama ikisi de AYNI duzeni
//     okuyor — ilk acilis ile sonraki acilislar arasinda fark yok.
//
// CS 0x01813b01 AutomaticOperateReq = [i8 Type]   (kayit ol / vazgec)
//  -> SC 0x01183b01 OperateRet = [u32 hata][i8 Type][i8 IsSign]                = 6B
//     Client donen Type'i FDAAutoInfos icinde arayip IsSign'i gunceller.
//
// CS 0x01813b02 DailyRewardReq
//  -> SC 0x01183b02 DailyRewardRet = [i8 RewardIndex][i16 adet] + adet x i32 SpecialHeroID
//     !!! HATA KODU YOK. SpecialHeroID'ler forma besleniyor -> adet=0 en guvenlisi.
//
// TUZAK: Type degerleri DailyActivity.activityType'tan gelir (2,3,3,3,4,8,9).
// GetInfoByType ilk eslesmeyi doner, yani ayni Type'tan birden fazla gondermek
// anlamsiz — BENZERSIZ type basina tek kayit yolluyoruz.
const fs = require('fs');
const path = require('path');

const VERI_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(VERI_JSON, f), 'utf8')); } catch { return d; } };

const SILVER = 50000;      // etkinlik basina gosterilen gumus odulu
const EXP = 20000;         // etkinlik basina gosterilen exp odulu

class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(((v | 0) << 16) >> 16); this.p.push(b); return this; }
  i8(v) { const b = Buffer.alloc(1); b.writeInt8(((v | 0) << 24) >> 24); this.p.push(b); return this; }
  done() { return Buffer.concat(this.p); }
}

// ---------- katalog ----------
let TIPLER = null;
function tipler() {
  if (TIPLER) return TIPLER;
  const gor = new Map();
  for (const r of jread('DailyActivity.json', [])) {
    const t = Number(r.activityType) || 0;
    if (!t || gor.has(t)) continue;                 // benzersiz type
    gor.set(t, { tip: t, ad: r.activityName });
  }
  TIPLER = [...gor.values()].sort((a, b) => a.tip - b.tip);
  return TIPLER;
}

// ---------- kalici durum ----------
// durum.gunlukEtkinlik = { kayit: { "<type>": 1 }, odulIndeks: n }
function depo(durum) {
  durum.gunlukEtkinlik = durum.gunlukEtkinlik || {};
  const d = durum.gunlukEtkinlik;
  d.kayit = d.kayit || {};
  if (!Number.isFinite(Number(d.odulIndeks))) d.odulIndeks = 0;
  return d;
}
function kayitli(durum, tip) { return depo(durum).kayit[String(tip)] ? 1 : 0; }

// ---------- paketler ----------
/** SC 0x01183b00 — etkinlik durumlari */
function durumPaketi(durum) {
  const liste = tipler();
  const w = new W();
  w.i16(liste.length);
  for (const x of liste) {
    w.i8(x.tip);
    w.i8(kayitli(durum, x.tip));
    w.i8(1);                       // CanSign: katilim butonu acik
    w.u32(SILVER);
    w.u32(EXP);
  }
  return w.done();
}

/** SC 0x01183b01 — kayit ol / vazgec (toggle) */
function operatePaketi(tip, durum) {
  const d = depo(durum);
  const t = tip | 0;
  const varMi = tipler().some(x => x.tip === t);
  if (!varMi) { const w = new W(); w.u32(1); return w.done(); }   // bilinmeyen tip -> hata
  const yeni = kayitli(durum, t) ? 0 : 1;
  if (yeni) d.kayit[String(t)] = 1; else delete d.kayit[String(t)];
  const w = new W();
  w.u32(0).i8(t).i8(yeni);
  return w.done();
}

/** SC 0x01183b02 — gunluk odul. HATA KODU YOK; hero listesi bos. */
function odulPaketi(durum) {
  const d = depo(durum);
  const w = new W();
  w.i8((Number(d.odulIndeks) || 0) & 0x7f);
  w.i16(0);                        // SpecialHeroID yok
  return w.done();
}

function ozet(durum) {
  const d = depo(durum);
  return { tip: tipler().length, kayitli: Object.keys(d.kayit).length, adlar: tipler().map(x => x.ad) };
}

module.exports = { tipler, durumPaketi, operatePaketi, odulPaketi, depo, ozet };
