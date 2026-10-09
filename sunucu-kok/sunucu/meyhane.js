'use strict';
// MEYHANE (Tavern) — partner devsirme: Janken (tas-kagit-makas), ×10, "One click win",
// "Advance" (kalite yukseltme) ve exp karti degisimi.
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// Modul 3072 (0x0C00). MoraMode: 0=Normal, 1=Advanced, 2=OneKeyTen(×10), 3=OneKeyWin.
//
// CS 0x01810c00 MoraReq        = [i8 tip][i32 gradeId]
//  -> SC 0x01180c00 MoraRet    = [u32 hata][u8 tip][u16 adet]
//                                + adet x (u32 warriorId, u8 kazandi, u32 returnMoney)
//     tip 0/1 -> client ShowChooseMoraHero: rakip(ler)i gosterir, sonra jest butonlarini acar
//     tip 2/3 -> client 10 sonucu pespese oynatir ve kazanilan ruhlari toplar
//
// CS 0x01810c01 NormalMoraReq  = [i8 jest]      (tas/kagit/makas)
//  -> SC 0x01180c01 NormalMoraRet = [u32 hata][u32 warriorId][u8 kazandi][u32 returnMoney]  (13B)
//
// CS 0x01810c02 RecruitReq     = [i32 warriorId]
//  -> SC 0x01180c02 RecruitRet = [u32 hata][u32 heroId][u32 rebirthLv][u32 overTime][u32 costGold] (20B)
//
// CS 0x01810c03 ChangeCardReq  = [i32 itemId][i16 adet]
//  -> SC 0x01180c03 ChangeCardRet = [u32 hata]  (4B; client kalan ruhu KENDI dusuyor)
//
// CS 0x01812101 AddQualityReq  = [i32 heroId]      (modul HeroSLevel = 8448)
//  -> SC 0x01182101 AddQualityRet = [u32 hata][u32 heroId][u32 addQuality]  (12B)
//
// ============================ TUZAKLAR ============================
// 1) IKI AYRI ID UZAYI: Mora/NormalMora'da gonderilen id `Tavern_Warrior` SATIR id'sidir
//    (30150001..30150034). Recruit'te donen ise HERO id'sidir (awardId, 11110001+).
//    Karistirmak MakeEffectStruct'ta null deref yapar (GetDatebaseByIdentifier null kontrolsuz).
// 2) `Awardsouls.Type - 3` ruh sayacina INDEKS -> type 3..6 araliginda olmali.
// 3) AddQuality: client `GetHeroByIdentifier(heroId).AddQuality` null kontrolsuz okuyor;
//    sahip OLUNAN bir hero id gonderilmeli. Ayrica gondermeden once ConfigValue(60104007)'yi
//    AddQuality ile indeksliyor — o satir [200,500], yani en fazla 2 kademe.
// 4) Ruh dusumunu CLIENT kendi yapiyor (SetHeroSoulByIndex). Sunucudan ayrica ruh paketi
//    gondermiyoruz; yalniz harcamayi kalici duruma not ediyoruz.
const fs = require('fs');
const path = require('path');

const VERI_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(VERI_JSON, f), 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;

const MAX_KALITE = 2;          // ConfigValue 60104007 = [200,500] -> 2 kademe

class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.p.push(b); return this; }
  u8(v) { this.p.push(Buffer.from([v & 0xff])); return this; }
  done() { return Buffer.concat(this.p); }
}

// ---------- tablolar ----------
let SAVASCI = null, KADEME = null;
function savascilar() {
  if (SAVASCI) return SAVASCI;
  SAVASCI = [];
  for (const r of jread('Tavern_Warrior.json', [])) {
    let soul = { type: 3, value: 1 };
    try { const a = JSON.parse(r.awardsoul); if (a && a.type >= 3 && a.type <= 6) soul = { type: Number(a.type), value: Number(a.value) || 1 }; } catch (e) { }
    SAVASCI.push({
      id: num(r.id),                       // 30150001+  (Mora paketlerinde BU kullanilir)
      grade: Number(r.grade) || 1,
      heroId: Number(r.awardId) || 0,      // 11110001+  (Recruit paketinde BU kullanilir)
      recruitSoul: Number(r.recruitSoul) || 0,
      returnValue: Number(r.returnValue) || 0,
      ad: r.recruitName,
      soul,
    });
  }
  return SAVASCI;
}
function kademeler() {
  if (KADEME) return KADEME;
  KADEME = new Map();
  for (const r of jread('Tavern_Grade.json', [])) KADEME.set(num(r.id), { id: num(r.id), level: Number(r.level) || 1, page: Number(r.page) || 1 });
  return KADEME;
}
/** gradeId (30130001..7) -> o kademenin savascilari. Bilinmeyen id'de 1. kademeye duser. */
function kademeSavascilari(gradeId) {
  const k = kademeler().get(gradeId >>> 0);
  const g = k ? k.page : 1;
  const liste = savascilar().filter(s => s.grade === g);
  return liste.length ? liste : savascilar().filter(s => s.grade === 1);
}

// ---------- kalici durum ----------
// durum.meyhane = { secili: <warriorId>, alinan: {heroId:1}, kalite: {heroId:n}, harcanan: {soulType:n} }
function depo(durum) {
  durum.meyhane = durum.meyhane || {};
  const d = durum.meyhane;
  d.alinan = d.alinan || {};
  d.kalite = d.kalite || {};
  d.harcanan = d.harcanan || {};
  return d;
}

const rnd = n => Math.floor(Math.random() * n);

// ---------- paketler ----------
/** SC 0x01180c00 — Mora sonucu/aday listesi */
function moraPaketi(tip, gradeId, durum) {
  const d = depo(durum);
  const havuz = kademeSavascilari(gradeId);
  const w = new W();
  w.u32(0).u8(tip & 0xff);
  if (tip === 0 || tip === 1) {
    // Tek rakip: client once onu gosterir, sonra jest butonlarini acar.
    const s = havuz[rnd(havuz.length)];
    d.secili = s.id;
    w.u16(1);
    w.u32(s.id).u8(0).u32(s.returnValue >>> 0);
    return w.done();
  }
  // ×10 / hepsini kazan
  const adet = 10;
  w.u16(adet);
  for (let i = 0; i < adet; i++) {
    const s = havuz[rnd(havuz.length)];
    const kazandi = tip === 3 ? 1 : (Math.random() < 0.6 ? 1 : 0);
    w.u32(s.id).u8(kazandi).u32(kazandi ? 0 : (s.returnValue >>> 0));
  }
  return w.done();
}

/** SC 0x01180c01 — tek Janken sonucu (13B) */
function normalMoraPaketi(durum) {
  const d = depo(durum);
  const havuz = savascilar();
  let s = havuz.find(x => x.id === (d.secili >>> 0));
  if (!s) { const h = kademeSavascilari(0); s = h[rnd(h.length)]; d.secili = s.id; }
  const kazandi = Math.random() < 0.6 ? 1 : 0;
  const w = new W();
  w.u32(0).u32(s.id >>> 0).u8(kazandi).u32(kazandi ? 0 : (s.returnValue >>> 0));
  return w.done();
}

/** SC 0x01180c02 — devsirme (20B). warriorId -> heroId cevrilir.
 *  level: devsirilen partnerin seviyesi (ana heronun seviyesi). Client RecruitRet'teki
 *  RebirthLevel'i hero'ya AYNEN yazar (PacketPerform_SC_TavernRecruit); 0 gonderilince
 *  partner "Lv.0" oluyordu. Partner ayrica durum.meyhane.alinan'a KALICI yazilir ve
 *  oyun-sunucu.editChar bunlari her giriste char paketine enjekte eder (relogin'de kaybolmaz). */
function recruitPaketi(warriorId, durum, level) {
  const d = depo(durum);
  const s = savascilar().find(x => x.id === (warriorId >>> 0));
  if (!s || !s.heroId) { const w = new W(); w.u32(1); return w.done(); }   // gecersiz -> hata
  d.alinan[String(s.heroId)] = 1;
  d.harcanan[String(s.soul.type)] = (Number(d.harcanan[String(s.soul.type)]) || 0) + s.recruitSoul;
  try { require('./seviye').heroKayit(durum, s.heroId, level); } catch (e) { }
  const w = new W();
  w.u32(0);
  w.u32(s.heroId >>> 0);     // HERO id (warrior satir id'si DEGIL)
  w.u32(Math.max(1, Number(level) || 1) >>> 0);   // RebirthLevel = ana heronun seviyesi
  w.u32(0);                  // HeroOverTime (0 = suresiz)
  w.u32(0);                  // HeroCostGold
  return w.done();
}
/** SC 0x01180c02 — token nhân vật dùng trực tiếp hero ID trong Article.f16. */
function itemRecruitPaketi(heroId, durum, level) {
  const id = Number(heroId) >>> 0;
  const h = require('./herolar').gecerliHerolar().find(x => x.id === id);
  if (!h) return null;
  const d = depo(durum);
  if (d.alinan[String(id)]) return null;

  let v = {};
  try { v = JSON.parse(fs.readFileSync(path.join(__dirname, 'veri.json'), 'utf8')); } catch (e) { }
  if ((Array.isArray(v.herolar) && v.herolar.map(Number).includes(id)) || v.tumKarakterler === true || v.tumKarakterler === 'true') return null;

  d.alinan[String(id)] = 1;
  try { require('./seviye').heroKayit(durum, id, level); } catch (e) { }
  const w = new W();
  w.u32(0).u32(id).u32(Math.max(1, Number(level) || 1)).u32(0).u32(0);
  return w.done();
}
/** Devsirilmis (kalici) partner id listesi. */
function alinanlar(durum) {
  const d = (durum && durum.meyhane && durum.meyhane.alinan) || {};
  return Object.keys(d).map(Number).filter(x => x > 0);
}

/** SC 0x01180c03 — exp karti degisimi (4B; client ruhu kendi dusuyor) */
function changeCardPaketi() { const w = new W(); w.u32(0); return w.done(); }

/** SC 0x01182101 — Advance / kalite yukseltme (12B) */
function addQualityPaketi(heroId, durum) {
  const d = depo(durum);
  const k = String(heroId >>> 0);
  const simdiki = Number(d.kalite[k]) || 0;
  if (!heroId) { const w = new W(); w.u32(1); return w.done(); }
  const yeni = Math.min(MAX_KALITE, simdiki + 1);
  d.kalite[k] = yeni;
  const w = new W();
  w.u32(0).u32(heroId >>> 0).u32(yeni >>> 0);
  return w.done();
}

function ozet(durum) {
  const d = depo(durum);
  return { alinan: Object.keys(d.alinan).length, kalite: Object.keys(d.kalite).length, savasci: savascilar().length, kademe: kademeler().size };
}

module.exports = {
  savascilar, kademeler, kademeSavascilari,
  moraPaketi, normalMoraPaketi, recruitPaketi, itemRecruitPaketi, changeCardPaketi, addQualityPaketi, alinanlar,
  depo, ozet, MAX_KALITE,
};
