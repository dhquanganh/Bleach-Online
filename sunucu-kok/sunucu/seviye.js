'use strict';
// SEVIYE / EXP MOTORU — ana hero + partnerlerin seviye ilerlemesi, KALICI.
//
// ============================ PROTOKOL (client kaynagi: TProcessorAccount) ============================
//  1) Sunucu EXP odulunu CharBaseInfoUpdate 0x01180105 index 11 (Experience) ile DELTA olarak yollar.
//     ProcessorCharBaseInfoExperience: ilk u32 = eklenecek miktar (2 u32 daha okunup atilir).
//     Client bu delta'yi Mounted (FightPosition != 0, yani kadrodaki) HER heroya ekler.
//  2) NeedExp'e ulasan herolarin exp'ini ESKI degere geri alip
//     CS_Account_CharUpgradeReq 0x01810102 = [u16 n] + n x u32 heroId  gonderir.
//  3) Sunucu SC_Account_CharUpgradeNtf 0x01180103 = [u16 n] + n x (u32 heroId, u32 RebirthLevel,
//     u32 ExpHigh, u32 ExpLow) doner; client seviye+exp'i buna gore SET eder, ana hero ise
//     seviye-atlama efekti oynatir (FOnUserLevelUpEffect).
//  4) Tek heroya hedefli exp (EXP parsomeni): CharBaseInfoUpdate index 12 (ExperienceTarget) =
//     [u32 expHigh][u32 expLow][u32 heroId] -> client exp'i SET eder; ardindan (kaynaktaki bir
//     artefakt yuzunden: Experience.EqualMax(kendisi) hep true) HER ZAMAN CharUpgradeReq atar.
//     Bu yuzden 0x01810102'ye yalniz GERCEKTEN seviye atlayan (bekleyen) herolar icin cevap
//     verilir; aksi halde ana heroda her parsomen kullaniminda seviye-atlama efekti cikardi.
//  HeroExp tablosu: id = seviye (1..159), f0 = NeedExp (o seviyeden sonrakine gereken),
//     f1/f2 = AllExp High/Low (birikimli). THeroExp.ReadDataByStream ile dogrulandi.
//  Seviye atlama kosulu: exp >= NeedExp[RebirthLevel]  (UInt64.EqualMax = this >= param).
//
// ============================ ESKI HATA (bu modul oncesi) ============================
//  - 0x01810102'ye YAKALANAN sabit 0x01180103 (hero 11100005 -> lv 7, exp 52) donuyordu ->
//    her seviye atlamada "Lv.7" gorunuyor, relogin'de veri.json level=1 yaziliyordu
//    ("when login level goes back to lv 1" sikayeti).
//  - paraIcinOdul EXP'yi delta yerine BIRIKIMLI toplam olarak yolluyordu (exp katlanarak artiyordu).
//
// ============================ KALICILIK ============================
//  Ana hero : veri.json  { level, deneyim }   (admin paneli de bu alanlari duzenler)
//  Partner  : durum.seviye.herolar[heroId] = { lv, exp }
//  Bekleyen : durum.seviye.bekleyen[heroId] = 1  (client'in sorunca cevaplanacak seviye atlamalari)
const fs = require('fs');
const path = require('path');

const VERI = path.join(__dirname, 'veri.json');
const HEROEXP = path.join(__dirname, '..', 'cikarim', 'veri-json', 'HeroExp.json');
const BASE_HERO = path.join(__dirname, '..', 'cikarim', 'veri-json', 'BaseHero.json');
const MAX_LV = 159;   // HeroExp 1..159; 160'da GetDatebase(HeroExp,160) null -> client NPE (VerificationHeroLevel)

let NEED = null;
let HERO_GROWTH = null;
function heroGrowthTable() {
  if (HERO_GROWTH) return HERO_GROWTH;
  HERO_GROWTH = new Map();
  try {
    for (const h of JSON.parse(fs.readFileSync(BASE_HERO, 'utf8'))) {
      const id = parseInt(h.id, 16) >>> 0;
      if (id) HERO_GROWTH.set(id, h);
    }
  } catch (e) { console.log('[seviye] BaseHero.json okunamadi:', e.message); }
  return HERO_GROWTH;
}
/** BaseHero'nun level bazli temel buyume degerleri; seviye motoru tum stat tuketicileri icin tek kaynaktir. */
function buyumeTemeli(heroId, lv, quality = 0) {
  const h = heroGrowthTable().get(heroId >>> 0);
  if (!h) return null;
  const n = Math.max(0, sinirla(lv) - 1);
  const stage = Math.max(0, Math.min(2, Number(quality) || 0));
  const baseRate = stage === 2 ? 2 : 1;
  const growthRate = stage === 2 ? 2 : stage === 1 ? 1.5 : 1;
  const at = (base, grow) => Math.max(0, Number(base) * baseRate + Number(grow) * growthRate * n || 0);
  const power = at(h.power, h.powerGrow);
  const agile = at(h.agile, h.agileGrow);
  const intelligence = at(h.intelligence, h.intelligenceGrow);
  const life = at(h.life, h.lifeGrow);
  return { power, agile, intelligence, life, combat: Math.max(power, agile, intelligence) };
}
/** Buyume carpanlari: ana savas degerleri ve HP, her birinin BaseHero buyumesini izler. */
function statCarpanlari(heroId, lv, anaId_, anaLv, quality = 0) {
  const hedef = buyumeTemeli(heroId, lv, quality);
  const taban = buyumeTemeli(anaId_, anaLv);
  if (!hedef || !taban || !(hedef.combat > 0) || !(taban.combat > 0) || !(hedef.life > 0) || !(taban.life > 0)) {
    return { genel: 1, power: 1, agile: 1, intelligence: 1, life: 1 };
  }
  // Follow BaseHero growth without a multiplier floor/cap: both caused level-up plateaus.
  // Packet serialization still clamps integer attributes to the supported wire range.
  const oran = (value, base) => {
    const ratio = value / base;
    return Number.isFinite(value) && Number.isFinite(base) && value > 0 && base > 0 &&
      Number.isFinite(ratio) && ratio > 0 ? ratio : 1;
  };
  return {
    genel: oran(hedef.combat, taban.combat),
    power: oran(hedef.power, taban.power),
    agile: oran(hedef.agile, taban.agile),
    intelligence: oran(hedef.intelligence, taban.intelligence),
    life: oran(hedef.life, taban.life),
  };
}

function tablo() {
  if (NEED) return NEED;
  NEED = new Map();
  try {
    for (const r of JSON.parse(fs.readFileSync(HEROEXP, 'utf8'))) {
      const lv = parseInt(r.id, 16) >>> 0;
      if (lv) NEED.set(lv, Number(r.f0) || 0);
    }
  } catch (e) { console.log('[seviye] HeroExp.json okunamadi:', e.message); }
  return NEED;
}
/** Bu seviyeden bir sonrakine gereken exp (0 = tablo yok). */
function need(lv) { const n = tablo().get(lv >>> 0); return n > 0 ? n : 0; }

function veriOku() { try { return JSON.parse(fs.readFileSync(VERI, 'utf8')); } catch { return {}; } }
function veriYaz(v) { try { fs.writeFileSync(VERI, JSON.stringify(v, null, 2)); } catch (e) { console.log('[seviye] veri.json yazilamadi:', e.message); } }

/** Ana hero id'si (yakalanan char paketi ya da karakter yaratmada secilen protagonist — statlar.anaIdAyarla). */
function anaId() {
  try { return ((require('./statlar').anaKaynak() || {}).id >>> 0) || 0; } catch (e) { return 0; }
}

function sinirla(lv) { return Math.max(1, Math.min(Number(lv) || 1, MAX_LV)) >>> 0; }

/** Seviye atlama dongusu (birden fazla seviye atlanabilir). */
function ilerlet(lv, exp) {
  lv = sinirla(lv);
  exp = Math.max(0, Math.floor(Number(exp) || 0));
  let atladi = 0;
  while (lv < MAX_LV) {
    const n = need(lv);
    if (!(n > 0) || exp < n) break;
    exp -= n; lv++; atladi++;
  }
  if (lv >= MAX_LV) { const n = need(MAX_LV); if (n > 0 && exp >= n) exp = n - 1; }   // tavanda exp barini doldurma
  return { lv, exp, atladi };
}

/** Ana heronun seviye/exp'i (veri.json). v verilirse ondan okunur (yeniden dosya okumaz). */
function anaDurum(v) {
  v = v || veriOku();
  return { lv: sinirla(v.level), exp: Math.max(0, Math.floor(Number(v.deneyim) || 0)) };
}

function depo(durum) {
  durum.seviye = durum.seviye || {};
  if (!durum.seviye.herolar || typeof durum.seviye.herolar !== 'object') durum.seviye.herolar = {};
  if (!durum.seviye.bekleyen || typeof durum.seviye.bekleyen !== 'object') durum.seviye.bekleyen = {};
  return durum.seviye;
}
/** Partner kaydi (yoksa verilen/ana seviyeyle olusturur). */
function heroKayit(durum, id, varsayilanLv) {
  const d = depo(durum).herolar;
  const k = String(id >>> 0);
  if (!d[k]) d[k] = { lv: sinirla(varsayilanLv || anaDurum().lv), exp: 0 };
  d[k].lv = sinirla(d[k].lv); d[k].exp = Math.max(0, Number(d[k].exp) || 0);
  return d[k];
}
/** Bir heronun {lv, exp}'i. Ana hero veri.json'dan, partner durumdan; kaydi yoksa ana seviye. */
function heroDurum(durum, id, v) {
  if ((id >>> 0) === anaId()) return anaDurum(v);
  const d = durum && durum.seviye && durum.seviye.herolar ? durum.seviye.herolar[String(id >>> 0)] : null;
  return d ? { lv: sinirla(d.lv), exp: Math.max(0, Number(d.exp) || 0) } : { lv: anaDurum(v).lv, exp: 0 };
}
function heroSeviye(durum, id, v) { return heroDurum(durum, id, v).lv; }

/** Client'in "Mounted" saydigi herolar = ana hero + kadroda pos>0 olanlar (durum.kadro). */
function kadroIds(durum) {
  const out = [];
  const a = anaId(); if (a) out.push(a);
  for (const [k, p] of Object.entries((durum && durum.kadro) || {})) {
    const id = Number(k) >>> 0;
    if (id && Number(p) > 0 && !out.includes(id)) out.push(id);
  }
  return out;
}

/**
 * Tek heroya exp ekle. Ana hero icin v (veri.json nesnesi) verilirse yalniz o nesne
 * degistirilir (cagiran yazar); verilmezse veri.json hemen yazilir. Partner durumda tutulur
 * (cagiran kaydet() yapar). Seviye atlayan hero "bekleyen"e alinir.
 * Donus: { id, lv, exp, atladi }
 */
function heroExpEkle(durum, id, delta, v) {
  const d = Math.max(0, Math.floor(Number(delta) || 0));
  const hid = id >>> 0;
  let r;
  if (hid === anaId()) {
    const yaz = !v; v = v || veriOku();
    const cur = anaDurum(v);
    r = ilerlet(cur.lv, cur.exp + d);
    v.level = r.lv; v.deneyim = r.exp;
    if (yaz) veriYaz(v);
  } else {
    const k = heroKayit(durum, hid);
    r = ilerlet(k.lv, k.exp + d);
    k.lv = r.lv; k.exp = r.exp;
  }
  if (r.atladi > 0) {
    depo(durum).bekleyen[String(hid)] = 1;
    if (hid === anaId()) { try { require('./olay').ayarla(durum, 'seviye', r.lv); } catch (e) {} }   // Experiences/gorev sartlari
  }
  return { id: hid, lv: r.lv, exp: r.exp, atladi: r.atladi };
}
/** Savas/gorev/etkinlik EXP odulu: client delta'yi TUM Mounted herolara ekler -> sunucu da ayni kume. */
function expEkle(durum, delta, v) {
  const ids = kadroIds(durum);
  const initialLevel = anaDurum(v).lv;
  // Initialize unseen partners before the main hero advances and writes its new level.
  for (const id of ids) if (id !== anaId()) heroKayit(durum, id, initialLevel);
  return ids.map(id => heroExpEkle(durum, id, delta, v));
}

function bekleyenMi(durum, id) { return !!(durum && durum.seviye && durum.seviye.bekleyen && durum.seviye.bekleyen[String(id >>> 0)]); }
function bekleyenTemizle(durum, ids) { const b = depo(durum).bekleyen; for (const id of ids || []) delete b[String(id >>> 0)]; }

/** CS 0x01810102 payload = [u16 n] + n x u32 heroId */
function upgradeReqIds(payload) {
  const out = [];
  if (!payload || payload.length < 2) return out;
  const n = payload.readUInt16BE(0);
  for (let i = 0; i < n && 2 + 4 * i + 4 <= payload.length; i++) out.push(payload.readUInt32BE(2 + 4 * i));
  return out;
}
/** SC 0x01180103 = [u16 n] + n x (u32 heroId, u32 RebirthLevel, u32 ExpHigh, u32 ExpLow) */
function upgradeNtf(durum, ids, v) {
  const list = (ids || []).map(x => x >>> 0).filter(Boolean);
  const b = Buffer.alloc(2 + 16 * list.length);
  b.writeUInt16BE(list.length & 0xffff, 0);
  list.forEach((id, i) => {
    const s = heroDurum(durum, id, v);
    const o = 2 + 16 * i;
    b.writeUInt32BE(id, o); b.writeUInt32BE(s.lv >>> 0, o + 4); b.writeUInt32BE(0, o + 8); b.writeUInt32BE(s.exp >>> 0, o + 12);
  });
  return b;
}
/** CharBaseInfoUpdate index 12 (ExperienceTarget): [u32 expHigh][u32 expLow][u32 heroId] -> client exp'i SET eder. */
function expHedefPaketi(id, exp) {
  return require('./harita').baseInfoUpdate([{ index: 12, v: 0, a: exp >>> 0, b: id >>> 0 }]);
}

function ozet(durum) {
  const a = anaDurum();
  const p = durum && durum.seviye ? Object.keys(durum.seviye.herolar || {}).length : 0;
  return { anaLv: a.lv, anaExp: a.exp, need: need(a.lv), partnerKayit: p };
}

module.exports = {
  MAX_LV, tablo, need, ilerlet, anaId, anaDurum, depo, heroKayit, heroDurum, heroSeviye, kadroIds,
  buyumeTemeli, statCarpanlari, heroExpEkle, expEkle, bekleyenMi, bekleyenTemizle, upgradeReqIds, upgradeNtf, expHedefPaketi, ozet,
  veriOku, veriYaz,
};
