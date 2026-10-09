'use strict';
// SOUL SKILLS (Soul Map -> "Soul Skills" sekmesi, modul GeneralStar 0x0B00) — KALICI beceri durumu.
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// CS 0x01810b05 SkillListReq   (payload yok; client login'de ProcessorSkillsDataReq ile atar)
//  -> SC 0x01180b05 SkillListRet = [u32 hata][u16 n] + n x (u32 skillId, u8 isUnlock)
//     Yakalanan gercek cevap: 00000000 0001 00c7e401 01  (11B) = tek beceri 13100033, acik.
//     Client (TProcessorGeneralStar.SupplementarySkills) Soul Map'teki her beceri dugumunu
//     (StarPoint.isSkill=1, addType type=100 value=skillId) listede YOKSA "kilitli" olarak ekler.
//     Bu yuzden liste sadece ACIK becerileri tasir; kilitliler client'ta kendiliginden olusur.
// CS 0x01810b06 ChangeSkillReq = [u32 skillId]  ("Click to switch skill")
//  -> SC 0x01180b06 ChangeSkillRet = [u8 hata][u32 skillId]   (!!! hata kodu 1 BAYT)
//     Client: MainHero.Skill = Skills.GetSkillByIdentifier(id) -> id LISTEDE OLMALI (null -> NPE).
//     ZERO_ACK (id=0) tam bu yuzden "tiklayinca hicbir sey olmuyor" veriyordu.
// CS 0x01810b04 SkillUpgradeReq = [u32 mevcutSkillId]
//  -> SC 0x01180b04 SkillUpgradeRet = [u32 hata][u32 yeniSkillId]
//     yeniSkillId = SoulSkill[mevcut].nextSkillId olmali: client `skill.NextID == yeni` olan
//     kaydi bulup id'sini degistirir (UnstreamizeUpgradeSkill). Bedel = SoulSkill.f2
//     {type:1, code:14100074 (Skill Scroll), amount} -> envanterden dusulur, client'a
//     InventoryNtf/ReduceThings ile bildirilir (ekOnce: cevaptan ONCE, panel sayaci dogru kalsin).
// Soul Map dugumu acilinca (PointReq 0x01810b03) dugum beceri dugumuyse gercek sunucu
//  SC_Account_MainHeroSkillInfoNtf 0x01180106 = [u16 n] + n x u32 skillId push eder ->
//  client IsUnlock=true yapar (kilit ikonu kalkar). Biz de ayni push'u yapiyoruz.
// Char paketindeki ana hero girisinde Skill(u32 id + u8 unlock) = ANA (secili) beceri -> login'de
//  secili beceri ve seviyesi korunur.
//
// ============================ KALICILIK ============================
//  durum.beceri = { ana: <seciliSkillId>, acik: { "<tabanId>": <mevcutId> } }
//  tabanId = ailenin ilk id'si (SkillConfig.skillId), mevcutId = yukseltilmis satir id'si.
const fs = require('fs');
const path = require('path');

const V = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(V, f), 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;

const HATA_ESYA = 0x15;   // ErrorCode 21: "Not enough items"
const HATA_MAX = 95;      // ErrorCode 95: "Maximum value exceeded"
const HATA_GENEL = 1;
const VARSAYILAN_TABAN = 13100033;   // yakalanan hesabin ana becerisi (Void Explosion)

// ---------- tablolar ----------
let SOUL = null, SKILL = null, DUGUM = null, AILE = null;
function soulTablo() {
  if (SOUL) return SOUL;
  SOUL = new Map();
  for (const r of jread('SoulSkill.json', [])) {
    const id = num(r.id); if (!id) continue;
    let need = { code: 14100074, amount: 0 };
    try { const j = JSON.parse(r.f2 || '{}'); if (j && j.code) need = { code: Number(j.code) >>> 0, amount: Math.max(0, Number(j.amount) || 0) }; } catch (e) {}
    SOUL.set(id, { id, lv: Number(r.skillLv) || 0, next: Number(r.nextSkillId) >>> 0, need });
  }
  return SOUL;
}
function skillTablo() {
  if (SKILL) return SKILL;
  SKILL = new Map(); AILE = new Map();
  for (const r of jread('SkillConfig.json', [])) {
    const id = num(r.id); if (!id) continue;
    SKILL.set(id, { id, aile: Number(r.skillId) >>> 0 || id, ad: r.name || '' });
  }
  return SKILL;
}
/** Soul Map dugum id -> verdigi beceri id (StarPoint.addType type 100). */
function dugumTablo() {
  if (DUGUM) return DUGUM;
  DUGUM = new Map();
  for (const r of jread('StarPoint.json', [])) {
    const id = num(r.id); if (!id) continue;
    if (Number(r.isSkill) !== 1) continue;
    try {
      const j = JSON.parse(r.addType || '{}');
      const a = (j.add || []).find(x => Number(x.type) === 100 && x.value);
      if (a) DUGUM.set(id, Number(a.value) >>> 0);
    } catch (e) {}
  }
  return DUGUM;
}
function dugumBecerisi(nodeId) { return dugumTablo().get(nodeId >>> 0) || 0; }
function gecerliSkill(id) { return skillTablo().has(id >>> 0); }
function aile(id) { const s = skillTablo().get(id >>> 0); return s ? s.aile : (id >>> 0); }

/** Ana heronun dogustan becerisi (BaseHero.active). Ana hero degisirse (karakter yaratma) yeniden cozulur. */
let TABAN = 0, TABAN_ANA = 0, BASEHERO_ACTIVE = null;
function tabanBeceri() {
  let anaId = 0; try { anaId = require('./seviye').anaId(); } catch (e) {}
  if (TABAN && TABAN_ANA === anaId) return TABAN;
  if (!BASEHERO_ACTIVE) { BASEHERO_ACTIVE = new Map(); for (const h of jread('BaseHero.json', [])) BASEHERO_ACTIVE.set(num(h.id), Number(h.active) >>> 0); }
  TABAN = BASEHERO_ACTIVE.get(anaId) || 0;
  if (!TABAN || !gecerliSkill(TABAN)) TABAN = VARSAYILAN_TABAN;
  TABAN_ANA = anaId;
  return TABAN;
}

// ---------- kalici durum ----------
function depo(durum) {
  if (!durum.beceri || typeof durum.beceri !== 'object') durum.beceri = {};
  const d = durum.beceri;
  if (!d.acik || typeof d.acik !== 'object') d.acik = {};
  const t = tabanBeceri();
  if (!d.acik[String(t)]) d.acik[String(t)] = t;
  // bozuk kayitlari ayikla (SkillConfig'te olmayan id client'i cokertir)
  for (const [k, v] of Object.entries(d.acik)) if (!gecerliSkill(v)) delete d.acik[k];
  if (!d.acik[String(t)]) d.acik[String(t)] = t;
  const acik = Object.values(d.acik).map(x => x >>> 0);
  if (!acik.includes(Number(d.ana) >>> 0)) d.ana = d.acik[String(t)];
  return d;
}
function acikListe(durum) { return Object.values(depo(durum).acik).map(x => x >>> 0); }
function ana(durum) { return depo(durum).ana >>> 0; }

// ---------- paketler ----------
/** SC 0x01180b05 */
function listePaketi(durum) {
  const ids = acikListe(durum);
  const b = Buffer.alloc(6 + 5 * ids.length);
  b.writeUInt32BE(0, 0); b.writeUInt16BE(ids.length & 0xffff, 4);
  ids.forEach((id, i) => { b.writeUInt32BE(id, 6 + 5 * i); b[10 + 5 * i] = 1; });
  return b;
}
/** SC 0x01180106 MainHeroSkillInfoNtf = [u16 n] + n x u32 */
function kilitAcPaketi(ids) {
  const list = (ids || []).map(x => x >>> 0).filter(Boolean);
  const b = Buffer.alloc(2 + 4 * list.length);
  b.writeUInt16BE(list.length & 0xffff, 0);
  list.forEach((id, i) => b.writeUInt32BE(id, 2 + 4 * i));
  return b;
}
/** Beceriyi ac (Soul Map dugumu). Donus: yeni acildiysa true. */
function kilitAc(durum, skillId) {
  const id = skillId >>> 0;
  if (!id || !gecerliSkill(id)) return false;
  const d = depo(durum);
  const k = String(aile(id));
  if (d.acik[k]) return false;          // zaten acik
  d.acik[k] = id;
  return true;
}
/** SC 0x01180b06 = [u8 hata][u32 id] */
function degistir(durum, skillId) {
  const id = skillId >>> 0;
  const d = depo(durum);
  const ok = acikListe(durum).includes(id);
  if (ok) d.ana = id;
  const b = Buffer.alloc(5);
  b[0] = ok ? 0 : HATA_GENEL; b.writeUInt32BE(ok ? id : 0, 1);
  return { hata: ok ? 0 : HATA_GENEL, paket: b };
}
/**
 * SC 0x01180b04 = [u32 hata][u32 yeniId]. envanter = require('./envanter'), durum ile dusum yapilir.
 * Donus: { hata, paket, yeni, dusulen: {code, amount} | null }
 */
function yukselt(durum, skillId, envanter) {
  const id = skillId >>> 0;
  const d = depo(durum);
  const hataPaketi = (h) => { const b = Buffer.alloc(8); b.writeUInt32BE(h >>> 0, 0); return { hata: h, paket: b, yeni: 0, dusulen: null }; };
  const tabanK = Object.keys(d.acik).find(k => (d.acik[k] >>> 0) === id);
  if (!tabanK) return hataPaketi(HATA_GENEL);                 // sahip olunmayan beceri
  const s = soulTablo().get(id);
  if (!s || !s.next || !gecerliSkill(s.next)) return hataPaketi(HATA_MAX);   // son seviye
  const need = s.need;
  if (need.amount > 0) {
    if (!envanter || envanter.mevcut(durum, need.code) < need.amount) return hataPaketi(HATA_ESYA);
    if (!envanter.dus(durum, need.code, need.amount)) return hataPaketi(HATA_ESYA);
  }
  d.acik[tabanK] = s.next;
  if ((d.ana >>> 0) === id) d.ana = s.next;
  const b = Buffer.alloc(8); b.writeUInt32BE(0, 0); b.writeUInt32BE(s.next, 4);
  return { hata: 0, paket: b, yeni: s.next, dusulen: need.amount > 0 ? { code: need.code, amount: need.amount } : null };
}

function ozet(durum) {
  const d = depo(durum);
  const ad = id => (skillTablo().get(id >>> 0) || {}).ad || '';
  const s = soulTablo().get(d.ana >>> 0);
  return { ana: d.ana, anaAd: ad(d.ana), anaLv: s ? s.lv : 0, acik: acikListe(durum).length, dugum: dugumTablo().size };
}

module.exports = {
  HATA_ESYA, HATA_MAX, HATA_GENEL,
  soulTablo, skillTablo, dugumTablo, dugumBecerisi, gecerliSkill, aile, tabanBeceri,
  depo, acikListe, ana, listePaketi, kilitAcPaketi, kilitAc, degistir, yukselt, ozet,
};
