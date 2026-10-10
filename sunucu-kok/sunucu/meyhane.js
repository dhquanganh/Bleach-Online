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
//     tip 2/3 -> ten rounds, up to thirty results; client animates the soul rewards
//
// CS 0x01810c01 NormalMoraReq  = [i8 guaranteed] (0=random, 1=paid win)
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
//    gondermiyoruz; veri.json stores the authoritative balances.
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
const SOUL_FIELDS = {3: 'blueSoul', 4: 'purpleSoul', 5: 'goldSoulV', 6: 'orangeSoul'};
const PAY = new Map(jread('Tavern_PayConfig.json', []).map(r => [num(r.id), Number(r.value)]));
const CARDS = jread('Exchange_ExpCard.json', []);
const CONFIG = new Map(jread('ConfigValue.json', []).map(r => [num(r.id), r.isClient]));
const QUALITY_COST = JSON.parse(CONFIG.get(60104007) || '[200,500]');
const QUALITY_LEVEL = Number(CONFIG.get(60104010)) || 80;
const CHEAT_COST = PAY.get(30140011) || 50;
const VIP = new Map(jread('VipConfig.json', []).map(r => [num(r.id), r]));
const MILITARY = new Map(jread('Military.json', []).map(r => [num(r.id), r]));
const fail = (code = 1) => new W().u32(code).done();
function accountRead(account) { return account || require('./seviye').veriOku(); }
function accountSave(account, supplied) { if (!supplied) fs.writeFileSync(path.join(__dirname, 'veri.json'), JSON.stringify(account, null, 2)); }
function owned(id, durum, account) {
  return !!depo(durum).alinan[String(id)] || (account.herolar || []).map(Number).includes(id)
    || account.tumKarakterler === true || account.tumKarakterler === 'true';
}
function premium(account, cost) {
  const coupons = Math.min(Number(account.kupon) || 0, cost);
  if (coupons + (Number(account.altin) || 0) < cost) return false;
  account.kupon = (Number(account.kupon) || 0) - coupons;
  account.altin = (Number(account.altin) || 0) - (cost - coupons);
  return true;
}
function reward(account, warrior, win) {
  if (win) {
    const field = SOUL_FIELDS[warrior.soul.type];
    account[field] = Math.min(2000000000, (Number(account[field]) || 0) + warrior.soul.value);
  } else account.gumus = Math.min(2000000000, (Number(account.gumus) || 0) + warrior.returnValue);
}
function enterPaketi(durum) {
  const d = depo(durum);
  d.pending = [];
  delete d.secili;
  return new W().u32(0).u8(0).u16(0).done();
}
function moneyPaketi(includeOrange = false) {
  const v = accountRead();
  const fields = [{index: 0, v: Number(v.gumusHigh) || 0, a: Number(v.gumus) || 0},
    {index: 1, v: Number(v.kupon) || 0}, {index: 3, v: Number(v.altin) || 0}];
  if (includeOrange) fields.push({index: 10, v: Number(v.orangeSoul) || 0});
  return require('./harita').baseInfoUpdate(fields);
}
function charYama(buf, durum, basicEnd) {
  const out = Buffer.from(buf), end = basicEnd(out);
  if (end + 2 > out.length) return buf;
  const count = out.readUInt16BE(end);
  let pos = end + 2;
  for (let i = 0; i < count; i++) {
    const next = require('./herolar').girisSonu(out, pos);
    if (next == null) return buf;
    const changes = out.readInt16BE(pos + 22);
    const qualityOffset = pos + 63 + 9 * Math.max(0, changes);
    out[qualityOffset] = Math.min(MAX_KALITE, Math.max(0, Number(depo(durum).kalite[String(out.readUInt32BE(pos))]) || 0));
    pos = next;
  }
  return out;
}

// ---------- paketler ----------
/** SC 0x01180c00 — Mora sonucu/aday listesi */
function moraPaketi(tip, gradeId, durum, supplied) {
  const account = accountRead(supplied);
  const grade = kademeler().get(gradeId >>> 0);
  if (![0, 1, 2, 3].includes(tip) || !grade || (Number(account.level) || 1) < grade.level) return fail();
  const vip = VIP.get(Number(account.vipLevel) || 0) || {};
  if ((tip === 2 && !Number(vip.oneWine)) || (tip === 3 && !Number(vip.oneWinWine))) return fail();
  const d = depo(durum);
  if ((d.pending || []).length) return fail();
  const config = jread('Tavern_Grade.json', []).find(r => num(r.id) === grade.id);
  const wine = JSON.parse(config.wineLv).wineLv;
  const quality = wine[tip === 0 ? 0 : 1] || wine[0];
  const havuz = kademeSavascilari(gradeId).filter(s => s.soul.type === quality);
  if (havuz.length < 3) return fail();
  const pay = JSON.parse(config.payConfigs);
  const price = PAY.get(pay[tip === 0 ? 'NORMAL' : 'ADVANCED']);
  if (!(price > 0)) return fail();
  const cost = price * (tip < 2 ? 1 : 10);
  if ((Number(account.gumus) || 0) < cost) return fail(13);
  if (tip === 3 && !premium(account, CHEAT_COST * 30)) return fail(16);
  account.gumus = (Number(account.gumus) || 0) - cost;
  const w = new W();
  w.u32(0).u8(tip & 0xff);
  if (tip === 0 || tip === 1) {
    // Flash reads exactly three distinct opponents and ends on the first loss.
    d.pending = [];
    w.u16(3);
    const choices = havuz.slice();
    for (let i = 0; i < 3; i++) {
      const s = choices.splice(rnd(choices.length), 1)[0];
      d.pending.push(s.id);
      w.u32(s.id).u8(0).u32(s.returnValue);
    }
    accountSave(account, supplied);
    return w.done();
  }
  // ×10 / hepsini kazan
  const results = [];
  for (let i = 0; i < 10; i++) {
    const choices = havuz.slice();
    for (let round = 0; round < 3; round++) {
      const s = choices.splice(rnd(choices.length), 1)[0];
      const win = tip === 3 ? 1 : (Math.random() < 0.6 ? 1 : 0);
      results.push({s, win});
      reward(account, s, win);
      if (!win) break;
    }
  }
  w.u16(results.length);
  for (const {s, win} of results) w.u32(s.id).u8(win).u32(win ? 0 : s.returnValue);
  accountSave(account, supplied);
  return w.done();
}

/** SC 0x01180c01 — tek Janken sonucu (13B) */
function normalMoraPaketi(durum, guaranteed = 0, supplied) {
  if (guaranteed !== 0 && guaranteed !== 1) return fail();
  const d = depo(durum);
  const account = accountRead(supplied);
  const havuz = savascilar();
  const s = havuz.find(x => x.id === (d.pending || [])[0]);
  if (!s) return fail();
  if (guaranteed && !premium(account, CHEAT_COST)) return fail(16);
  const kazandi = guaranteed || (Math.random() < 0.6 ? 1 : 0);
  d.pending.shift();
  if (!kazandi) d.pending = [];
  reward(account, s, kazandi);
  accountSave(account, supplied);
  const w = new W();
  w.u32(0).u32(s.id >>> 0).u8(kazandi).u32(kazandi ? 0 : (s.returnValue >>> 0));
  return w.done();
}

/** SC 0x01180c02 — devsirme (20B). warriorId -> heroId cevrilir.
 *  level: devsirilen partnerin seviyesi (ana heronun seviyesi). Client RecruitRet'teki
 *  RebirthLevel'i hero'ya AYNEN yazar (PacketPerform_SC_TavernRecruit); 0 gonderilince
 *  partner "Lv.0" oluyordu. Partner ayrica durum.meyhane.alinan'a KALICI yazilir ve
 *  oyun-sunucu.editChar bunlari her giriste char paketine enjekte eder (relogin'de kaybolmaz). */
function recruitPaketi(warriorId, durum, level, supplied) {
  const d = depo(durum);
  const account = accountRead(supplied);
  const s = savascilar().find(x => x.id === (warriorId >>> 0));
  if (!s || !s.heroId) { const w = new W(); w.u32(1); return w.done(); }   // gecersiz -> hata
  if (owned(s.heroId, durum, account)) return fail(45);
  const grade = [...kademeler().values()].find(g => g.page === s.grade);
  if (!grade || (Number(account.level) || 1) < grade.level) return fail(44);
  const rankId = Math.max(40100001, Math.min(40100036, Number(account.rutbe) || Number(durum.militaryRank) || 40100036));
  const rank = MILITARY.get(rankId);
  const roster = new Set([...(account.herolar || []).map(Number), ...alinanlar(durum)]);
  roster.delete(require('./seviye').anaId());
  if (rank && roster.size + 1 >= Number(rank.maxHeroNum) + (Number(durum.heroAddSlotNum) || 0)) return fail(46);
  const field = SOUL_FIELDS[s.soul.type];
  if ((Number(account[field]) || 0) < s.recruitSoul) return fail(43);
  account[field] -= s.recruitSoul;
  accountSave(account, supplied);
  d.alinan[String(s.heroId)] = 1;
  d.harcanan[String(s.soul.type)] = (Number(d.harcanan[String(s.soul.type)]) || 0) + s.recruitSoul;
  const recruitLevel = require('./seviye').heroKayit(durum, s.heroId, level).lv;
  const w = new W();
  w.u32(0);
  w.u32(s.heroId >>> 0);     // HERO id (warrior satir id'si DEGIL)
  w.u32(recruitLevel);   // Includes talent-defined initial level; matches persisted state.
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
  const recruitLevel = require('./seviye').heroKayit(durum, id, level).lv;
  const w = new W();
  w.u32(0).u32(id).u32(recruitLevel).u32(0).u32(0);
  return w.done();
}
/** Devsirilmis (kalici) partner id listesi. */
function alinanlar(durum) {
  const d = (durum && durum.meyhane && durum.meyhane.alinan) || {};
  return Object.keys(d).map(Number).filter(x => x > 0);
}

/** SC 0x01180c03 — exp karti degisimi (4B; client ruhu kendi dusuyor) */
function changeCardPaketi(itemId, count, durum, supplied) {
  if (!Number.isInteger(count) || count < 1 || count > 32767) return fail();
  const account = accountRead(supplied);
  const card = CARDS.find(c => c.item === itemId && [...kademeler().values()]
    .some(g => g.page === c.grade && g.level <= (Number(account.level) || 1)));
  if (!card || !SOUL_FIELDS[card.quality] || !(card.value > 0)) return fail();
  const field = SOUL_FIELDS[card.quality], cost = card.value * count;
  if ((Number(account[field]) || 0) < cost) return fail(43);
  const inventory = require('./envanter');
  if (inventory.mevcut(durum, itemId) + count > inventory.MAX_ADET) return fail();
  const added = inventory.ekle(durum, [{type: 1, code: itemId, amount: count}]);
  if (!added || !added.length) return fail();
  account[field] -= cost;
  accountSave(account, supplied);
  return new W().u32(0).done();
}

/** SC 0x01182101 — Advance / kalite yukseltme (12B) */
function addQualityPaketi(heroId, durum, supplied) {
  const d = depo(durum);
  const account = accountRead(supplied);
  const k = String(heroId >>> 0);
  const simdiki = Number(d.kalite[k]) || 0;
  if (!Number.isInteger(simdiki) || simdiki < 0) return fail();
  if (!savascilar().some(s => s.heroId === heroId) || !owned(heroId, durum, account)
    || (Number(account.level) || 1) < QUALITY_LEVEL || simdiki >= QUALITY_COST.length) return fail();
  const cost = QUALITY_COST[simdiki];
  if ((Number(account.orangeSoul) || 0) < cost) return fail(43);
  account.orangeSoul -= cost;
  accountSave(account, supplied);
  const yeni = simdiki + 1;
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
  depo, ozet, MAX_KALITE, enterPaketi, moneyPaketi, charYama,
};
