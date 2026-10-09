'use strict';
// MOD SOUL'S HOME (PetHouse) — modul 29184 (0x7200): besleme, aktiflestirme (RankUp),
// ana pet secimi ve pet esyasi sayaci.
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// CS 0x01817200 MainPetFeedReq   = [u32 petId]
//  -> SC 0x01187200 FeedRet      = [u32 hata][u32 petId][u32 level][u32 exp]
//     !!! TUZAK: client `if(yeniLevel > eskiLevel) UnstreamizeMainPet(stream,...)` yapiyor,
//     yani SEVIYE ARTARSA paketin devaminda bir MainPet blogu OKUYOR. O blogun duzeni
//     cozulmedigi icin beslemede seviyeyi ASLA artirmiyoruz (sadece exp artar) -> ek blok
//     gerekmez, EOF riski yok.
//     !!! TUZAK: `OwnMainPets.GetPetByIdentifier(petId,0).Level` NULL KONTROLSUZ ->
//     istekteki petId'yi AYNEN geri yolla (client yalniz sahip oldugu peti gonderir).
//
// CS 0x01817201 MainPetRankUpReq = [u32 petId]
//  -> SC 0x01187201 RankUpRet    = [u32 hata][u32 templateId]   (8B)
//     Client peti YEREL kuruyor: AcquireMainPet(templateId) + UnstreamizeMainPet(null,...)
//     (null akis -> hicbir sey okumaz), yani ek blok YOK.
//     templateId gecerli olmali: MainPetRankUp tablosu petId 1101..1115.
//
// CS 0x01817202 MainPetDelReq    -> cevabin tam duzeni cozulmedi (ConfigValue okuyor).
//     Silme DESTEKLENMIYOR: [u32 hata!=0] donuyoruz; client hata metnini gosterip cikiyor.
//
// CS 0x01817203 MainPetChangeReq = [u32 petId]
//  -> SC 0x01187203 ChangeRet    = [u32 hata][u32 mainPetId]    (8B)
//
// CS 0x01817204 NotiyPetItemReq
//  -> SC 0x01187204 NotiyRet     = [u32 petItemNum]  (4B — HATA KODU YOK!)
const fs = require('fs');
const path = require('path');

const VERI_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(VERI_JSON, f), 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;

const HATA_DESTEKLENMIYOR = 1;
const FEED_EXP = 10;                 // her beslemede eklenen exp
const VARSAYILAN_ITEM = 20;          // "Currently owning 3/20" panelindeki pet esyasi sayaci

class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  done() { return Buffer.concat(this.p); }
}

// ---------- gecerli pet sablonlari ----------
// MainPetRankUp satir id'si = petId (0x44D = 1101 ... 1115)
let SABLON = null;
function sablonlar() {
  if (SABLON) return SABLON;
  SABLON = [...new Set(jread('MainPetRankUp.json', []).map(r => num(r.id)))].filter(x => x >= 1000 && x < 100000).sort((a, b) => a - b);
  if (!SABLON.length) SABLON = [1101];
  return SABLON;
}
function sablonGecerli(id) { return sablonlar().includes(id >>> 0); }

// ---------- kalici durum ----------
// durum.evcil = { petler: { "<petId>": {level, exp} }, ana: <petId>, item: n }
function depo(durum) {
  durum.evcil = durum.evcil || {};
  const d = durum.evcil;
  d.petler = d.petler || {};
  if (!Number.isFinite(Number(d.item))) d.item = VARSAYILAN_ITEM;
  return d;
}
function pet(durum, petId) {
  const d = depo(durum);
  const k = String(petId >>> 0);
  if (!d.petler[k]) d.petler[k] = { level: 1, exp: 0 };
  return d.petler[k];
}

// ---------- paketler ----------
/** SC 0x01187200 — besleme. Seviye BILEREK sabit (bkz. basliktaki tuzak). */
function feedPaketi(petId, durum) {
  const p = pet(durum, petId);
  p.exp = (Number(p.exp) || 0) + FEED_EXP;
  const w = new W();
  w.u32(0);
  w.u32(petId >>> 0);            // istekteki id AYNEN geri (client null kontrolsuz ariyor)
  w.u32((Number(p.level) || 1) >>> 0);
  w.u32(p.exp >>> 0);
  return w.done();
}

/** SC 0x01187201 — aktiflestirme (8B). Gecersiz sablonda hata doner. */
function rankUpPaketi(petId, durum) {
  const id = petId >>> 0;
  const hedef = sablonGecerli(id) ? id : sablonlar()[0];
  const d = depo(durum);
  pet(durum, hedef);
  if (!d.ana) d.ana = hedef;
  const w = new W();
  w.u32(0).u32(hedef >>> 0);
  return w.done();
}

/** SC 0x01187203 — ana pet degistir (8B) */
function changePaketi(petId, durum) {
  const d = depo(durum);
  d.ana = petId >>> 0;
  const w = new W();
  w.u32(0).u32(d.ana >>> 0);
  return w.done();
}

/** SC 0x01187204 — pet esyasi sayaci (4B, HATA KODU YOK) */
function itemPaketi(durum) {
  const d = depo(durum);
  const w = new W();
  w.u32((Number(d.item) || 0) >>> 0);
  return w.done();
}

/** SC 0x01187202 — silme desteklenmiyor: hata kodu don, client guvenle cikar. */
function silPaketi() { const w = new W(); w.u32(HATA_DESTEKLENMIYOR); return w.done(); }

function ozet(durum) {
  const d = depo(durum);
  return { sahip: Object.keys(d.petler).length, ana: d.ana || 0, item: d.item, sablon: sablonlar().length };
}

module.exports = { feedPaketi, rankUpPaketi, changePaketi, itemPaketi, silPaketi, sablonlar, sablonGecerli, depo, ozet };
