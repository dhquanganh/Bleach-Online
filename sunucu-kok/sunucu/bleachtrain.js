'use strict';
// BLEACH TRAIN ("Experiences" / Novice paneli, modul 0x6a00) — 184 buyume gorevi + VIP hediye paketleri.
//
// ============================ PROTOKOL (TProcessorBleachTrain / TUnstreamizerBleachTrain) ============================
// CS 0x01816a00 BleachTrain_Req (bos)  -> SC 0x01186a00 = [u16 n] + n x (u32 taskId, u32 alindi(0/1), u32 ilerleme)
//                                        + [u16 m] + m x (u32 bagGroupId, u32 bagIndex)   (satin alinan VIP paketleri)
//   Client: IfCanGotReward = !alindi && AllNumber <= ilerleme; IfOpen = Accept(seviye) <= oyuncu seviyesi.
// CS 0x01816a01 GetReward_Req = [u32 taskId]  -> SC 0x01186a01 = [u32 hata][u32 taskId] + ODUL
//   ODUL (SToolReward.ShowReward) = [u16 n] + n x (u16 type, u32 code, u32 amount)
// SC 0x01186a02 BleachTrainUpdate (PUSH) = [u32 taskId][u32 ilerleme]  (sunucu ilerleme degisince iter)
// CS 0x01816a03 VipBag_Req = [u32 groupId][u32 index] -> SC 0x01186a03 = [u32 hata][u32 groupId][u32 index] + ODUL
//   Yakalanan 44B ornek: 00000000 00895829 00000000 0003 (0001 00d72628 0000000a)(0001 00d72622 0000000a)(0006 00000000 0000012c)
//
// ============================ VERI (JSON sutunlari VO sirasina gore KAYMIS) ============================
// GrowRoadTask (TGrowRoadTask.ReadDataByStream): name, descriptionSimple, taskTarget, accept(u32 seviye),
//   taskLocked, NormalReward(JSON), "[vipNeed,[VipReward]]"(JSON), Type(i32 sekme seviyesi), AllNumber(i32 hedef),
//   IocnID, IsGoto, IsPoptip.  JSON'da: type=NormalReward, allNumber=vip json, iocnID=Type(sekme),
//   isGoto=AllNumber(hedef), isPoptip=IocnID, f10=IsGoto, f11=IsPoptip.
// GrowRoadGift (TGrowRoadGift): accept, f1=Reward(award id[]), f2=ImageIcon, f3=VipLimit, f4=RewardDiscount,
//   f5=RewardOriginal, f6=RewardPrice(altin).
//
// ============================ SARTLAR ============================
// Gercek sunucunun sart motoru elimizde yok; her gorevin taskTarget metni bir SART anahtarina cevrilir
// (regex tablosu). Ilerleme = olay.js sayaci (veya seviye / gorev-bitti). Eslesmeyen metin -> gorevin
// Accept seviyesine ulasinca tamamlanmis sayilir (oyuncu kilitli kalmasin).
const fs = require('fs');
const path = require('path');
const olay = require('./olay');

const V = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(V, f), 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;
const OP_LISTE = 0x01186a00, OP_ODUL = 0x01186a01, OP_GUNCELLE = 0x01186a02, OP_VIPBAG = 0x01186a03;
const HATA_GENEL = 1, HATA_ALTIN = 0x38, HATA_ALINMIS = 1, HATA_SART = 1;

// ---------- sart tablosu: [regex, anahtar, tip] tip: 'sayac' | 'seviye' | 'gorev' | 'mutlak' ----------
const SARTLAR = [
  [/Player Level reaches/i, 'seviye', 'mutlak'],
  [/Finish Level \d+ Task - (.+)$/i, 'gorev', 'gorev'],
  [/Click Cultivating to cultivate Reiatsu/i, 'cultivate', 'sayac'],
  [/One-click Cultivate/i, 'cultivateOneKey', 'sayac'],
  [/Use gold to cultivate Reiatsu/i, 'cultivateGold', 'sayac'],
  [/Zanpakut.+God-speed Cultivation/i, 'zanpakutoGodspeed', 'sayac'],
  [/Zanpakut.+Soul Cultivation/i, 'zanpakutoTrain', 'sayac'],
  [/Fortify any Level Acessory/i, 'fortifyAccessory', 'sayac'],
  [/Fortify any equipment/i, 'fortifyEquip', 'sayac'],
  [/Use Double Fortify/i, 'doubleFortify', 'sayac'],
  [/Daily Task Points/i, 'dailyPoints', 'mutlak'],
  [/Complete any \d+ Daily Task/i, 'dailyTask', 'sayac'],
  [/In Soul Hunt, rob/i, 'soulHuntRob', 'sayac'],
  [/In Soul Hunt, hunt/i, 'soulHunt', 'sayac'],
  [/Use Jigokuch.+summon/i, 'summon', 'sayac'],
  [/Obtain Arena Ranking Reward/i, 'arenaReward', 'sayac'],
  [/In the Arena challenge/i, 'arenaFight', 'sayac'],
  [/Ranking upgrade to/i, 'militaryRank', 'mutlak'],
  [/Challenge Pass Trial Tower/i, 'trialWin', 'sayac'],
  [/Challenge any Trial and win/i, 'trialWin', 'sayac'],
  [/Challenge Pass Level \d+ Instance/i, 'instancePass', 'sayac'],
  [/Complete Sign-in/i, 'signin', 'sayac'],
  [/Use Sign-in points to exchange/i, 'signinExchange', 'sayac'],
  [/Partner equip with more than (\d+)/i, 'equipCount', 'mutlak'],
  [/Exchange with Girlfriend/i, 'girlfriendExchange', 'sayac'],
  [/Party with Girlfriend/i, 'girlfriendParty', 'sayac'],
  [/Upgrade Girlfriend/i, 'girlfriendUpgrade', 'sayac'],
  [/Upgrade Home/i, 'homeUpgrade', 'sayac'],
  [/Get Silver from Lucky Cat/i, 'luckyCat', 'sayac'],
  [/HomeKill Kons/i, 'konso', 'sayac'],
  [/Embed Spirit stones/i, 'gemInlay', 'sayac'],
  [/Synthesize \d+ Level/i, 'gemSynth', 'sayac'],
  [/Upgrade any Hogu/i, 'hoguUpgrade', 'sayac'],
  [/equip with \d+ H.gu/i, 'hoguEquip', 'mutlak'],
  [/Purchase Vitality/i, 'vitalityBuy', 'sayac'],
  [/Refine any equipment .* Inherit/i, 'inheritEquip', 'sayac'],
  [/Inherit any equipment/i, 'inheritEquip', 'sayac'],
  [/Refine any equipment/i, 'refineEquip', 'sayac'],
  [/Designate Refine/i, 'designateRefine', 'sayac'],
  [/Spirit Forge any Equipment/i, 'spiritForge', 'sayac'],
  [/Recruit any quality Partner/i, 'recruit', 'sayac'],
  [/Press Slave|Plunder Slave|Successfully Plunder/i, 'slavePress', 'sayac'],
  [/Capture Slave/i, 'slaveCapture', 'sayac'],
  [/Slave Work EXP|Drain Slave of all EXP/i, 'slaveExp', 'sayac'],
  [/Master Slave Interaction|Spiritual Interaction/i, 'slaveInteract', 'sayac'],
  [/Rescue Guild member/i, 'guildRescue', 'sayac'],
  [/Donate silver to Guild/i, 'guildDonateSilver', 'sayac'],
  [/Donate Gold to Guild/i, 'guildDonateGold', 'sayac'],
  [/Join or create a Guild|Join any one Clan/i, 'guildJoin', 'sayac'],
  [/Light up Soul Map/i, 'soulmap', 'sayac'],
  [/Increase Battle Power to/i, 'battlePower', 'mutlak'],
  [/Throw Dice, use any amount of Silver/i, 'diceSilver', 'sayac'],
  [/Throw Dice, use any amount of Gold/i, 'diceGold', 'sayac'],
  [/Complete Beauty Game/i, 'beautyGame', 'sayac'],
  [/Auto-win Janken/i, 'autoJanken', 'sayac'],
  [/One-click Exchange/i, 'oneKeyExchange', 'sayac'],
  [/use at least \d+ EXP Book/i, 'expBookUse', 'sayac'],
  [/Evil Spirit Attacks/i, 'dailyActivityEvil', 'sayac'],
  [/Ryoka Attacks/i, 'dailyActivityRyoka', 'sayac'],
  [/Protect Seireitei/i, 'dailyActivityProtect', 'sayac'],
  [/Daily Activities Guild War/i, 'dailyActivityGuildWar', 'sayac'],
  [/Alliance Battle/i, 'allianceBattle', 'sayac'],
  [/Alliance Campaign/i, 'allianceCampaign', 'sayac'],
];

// ---------- tablolar ----------
let TASKS = null, GIFTS = null, GOREV_AD = null;
function odulListesi(s) { try { const j = JSON.parse(s || '[]'); return Array.isArray(j) ? j.map(x => ({ type: Number(x.type) || 0, code: Number(x.code) >>> 0, amount: Math.max(1, Number(x.amount) || 1) })) : []; } catch { return []; } }
function tasks() {
  if (TASKS) return TASKS;
  TASKS = new Map();
  for (const r of jread('GrowRoadTask.json', [])) {
    const id = num(r.id); if (!id) continue;
    let vipNeed = 0, vipOdul = [];
    try { const j = JSON.parse(r.allNumber || '[]'); vipNeed = Number(j[0]) || 0; vipOdul = odulListesi(JSON.stringify(j[1] || [])); } catch {}
    const hedef = r.taskTarget || '';
    let sart = null;
    for (const [re, anahtar, tip] of SARTLAR) { const m = hedef.match(re); if (m) { sart = { anahtar, tip, gorevAd: tip === 'gorev' ? m[1].trim() : null }; break; } }
    TASKS.set(id, {
      id, ad: r.name, hedefMetin: hedef, accept: Number(r.accept) || 0, sekme: Number(r.iocnID) || 0,
      allNumber: Math.max(1, Number(r.isGoto) || 1), normal: odulListesi(r.type), vipNeed, vip: vipOdul, sart,
    });
  }
  return TASKS;
}
function gifts() {
  if (GIFTS) return GIFTS;
  GIFTS = new Map();
  const arr = s => { try { const j = JSON.parse(s || '[]'); return Array.isArray(j) ? j.map(Number) : []; } catch { return []; } };
  for (const r of jread('GrowRoadGift.json', [])) {
    const id = num(r.id); if (!id) continue;
    GIFTS.set(id, { id, accept: Number(r.accept) || 0, odul: arr(r.f1), ikon: arr(r.f2), vip: arr(r.f3), indirim: arr(r.f4), orjinal: arr(r.f5), fiyat: arr(r.f6) });
  }
  return GIFTS;
}
function gorevAdlari() {
  if (GOREV_AD) return GOREV_AD;
  GOREV_AD = new Map();
  for (const t of jread('Task.json', [])) { const id = num(t.id); const ad = String(t.name || '').trim(); if (!id || !ad) continue; if (!GOREV_AD.has(ad)) GOREV_AD.set(ad, []); GOREV_AD.get(ad).push(id); }
  return GOREV_AD;
}

// ---------- durum ----------
function depo(durum) {
  if (!durum.bleachTrain || typeof durum.bleachTrain !== 'object') durum.bleachTrain = {};
  const d = durum.bleachTrain;
  if (!d.alinan || typeof d.alinan !== 'object') d.alinan = {};
  if (!d.satin || typeof d.satin !== 'object') d.satin = {};
  return d;
}
function seviye() { try { return require('./seviye').anaDurum().lv; } catch { return 1; } }
function vipSeviye() { try { const h = require('./harita'); return h.vipSinir(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).vipLevel); } catch { return 0; } }
/** Bir gorevin guncel ilerlemesi (client AllNumber ile karsilastirir). */
function ilerleme(durum, t) {
  const lv = seviye();
  if (!t.sart) return lv >= t.accept ? t.allNumber : 0;          // sarti cozulemeyen: seviyeye ulasinca tamam
  const s = t.sart;
  if (s.anahtar === 'seviye') return lv;
  if (s.tip === 'gorev') {
    const ids = gorevAdlari().get(s.gorevAd) || [];
    const biten = (durum.gorev && Array.isArray(durum.gorev.biten)) ? durum.gorev.biten.map(Number) : [];
    return ids.some(id => biten.includes(id)) ? t.allNumber : 0;
  }
  if (s.tip === 'mutlak') return mutlakDeger(durum, s.anahtar, lv);
  return olay.oku(durum, s.anahtar);
}
// "Mutlak" sartlar sayac degil, o anki DEGER: takili ekipman sayisi, savas gucu, askeri rutbe, gunluk gorev puani.
function mutlakDeger(durum, anahtar, lv) {
  try {
    if (anahtar === 'equipCount') {
      let n = 0; const tk = (durum.ekipman && durum.ekipman.takili) || {};
      for (const slots of Object.values(tk)) n += Object.values(slots || {}).filter(Boolean).length;
      return n;
    }
    if (anahtar === 'battlePower') {   // client'in Total Battle Power'i (lv 8 -> ~1600); partner basina ek
      const partner = (durum.meyhane && durum.meyhane.alinan) ? Object.keys(durum.meyhane.alinan).length : 0;
      return Math.round(lv * 200 + partner * lv * 120);
    }
    if (anahtar === 'militaryRank') return Number(durum.militaryRank) || 0;
    if (anahtar === 'dailyPoints') return olay.gunlukOku(durum, 'dailyPoints');
  } catch (e) {}
  return olay.oku(durum, anahtar);
}
function alindiMi(durum, id) { return !!depo(durum).alinan[String(id >>> 0)]; }

// ---------- paketler ----------
class W { constructor() { this.p = []; } u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; } u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.p.push(b); return this; } done() { return Buffer.concat(this.p); } }
function odulYaz(w, oduller) { w.u16(oduller.length); for (const o of oduller) { w.u16(o.type); w.u32(o.code); w.u32(o.amount); } return w; }

/** SC 0x01186a00 */
function listePaketi(durum) {
  const d = depo(durum);
  const w = new W();
  const t = [...tasks().values()];
  w.u16(t.length);
  for (const x of t) { w.u32(x.id); w.u32(alindiMi(durum, x.id) ? 1 : 0); w.u32(Math.min(0x7fffffff, ilerleme(durum, x))); }
  const satin = Object.keys(d.satin);
  w.u16(satin.length);
  for (const k of satin) { const [g, i] = k.split(':').map(Number); w.u32(g); w.u32(i); }
  return w.done();
}
/**
 * CS 0x01816a01. ctx = { ver(oduller) -> void (envanter+para kalici ve paketleri kuyruga) }
 * Donus: { hata, paket }
 */
function odulAl(durum, taskId, ctx) {
  const id = taskId >>> 0;
  const t = tasks().get(id);
  const hataPaketi = h => ({ hata: h, paket: new W().u32(h).u32(id).u16(0).done() });
  if (!t) return hataPaketi(HATA_GENEL);
  if (alindiMi(durum, id)) return hataPaketi(HATA_ALINMIS);
  if (seviye() < t.accept) return hataPaketi(HATA_SART);
  if (ilerleme(durum, t) < t.allNumber) return hataPaketi(HATA_SART);
  const vip = vipSeviye();
  const oduller = (t.vipNeed > 0 && vip >= t.vipNeed && t.vip.length) ? t.vip : t.normal;   // "Normal ve VIP'ten yalniz biri"
  depo(durum).alinan[String(id)] = 1;
  if (ctx && ctx.ver) ctx.ver(oduller);
  const w = new W().u32(0).u32(id); odulYaz(w, oduller);
  return { hata: 0, paket: w.done(), oduller, ad: t.ad };
}
/** CS 0x01816a03. ctx = { altinHarca(miktar) -> bool, awardCoz(awardId) -> [{type,code,amount}]|null, ver(oduller) } */
function vipBagAl(durum, groupId, index, ctx) {
  const g = gifts().get(groupId >>> 0);
  const hataPaketi = h => ({ hata: h, paket: new W().u32(h).u32(groupId).u32(index).u16(0).done() });
  if (!g || index < 0 || index >= g.odul.length) return hataPaketi(HATA_GENEL);
  const k = (groupId >>> 0) + ':' + (index >>> 0);
  if (depo(durum).satin[k]) return hataPaketi(HATA_ALINMIS);
  if (g.accept > 0 && seviye() > g.accept) return hataPaketi(HATA_SART);   // "Can only purchase prior to Level 50": accept = ust sinir
  // Ozel sunucu: VIP kademeli indirimli paketler HERKESE acik (VIP satin alma yolu yok; client zaten
  // satin alma penceresini aciyor, sessiz red "hic bir sey olmuyor" gibi gorunuyordu).
  if (vipSeviye() < (g.vip[index] || 0)) console.log(`[bleachtrain] vip paketi ${groupId}/${index}: VIP${g.vip[index]} gerek, oyuncu VIP${vipSeviye()} -> ozel sunucu izni`);
  const fiyat = Number(g.fiyat[index]) || 0;
  const oduller = (ctx && ctx.awardCoz && ctx.awardCoz(g.odul[index])) || [];
  if (!oduller.length) return hataPaketi(HATA_GENEL);
  if (fiyat > 0 && !(ctx && ctx.altinHarca && ctx.altinHarca(fiyat))) return hataPaketi(HATA_ALTIN);
  depo(durum).satin[k] = 1;
  if (ctx && ctx.ver) ctx.ver(oduller);
  const w = new W().u32(0).u32(groupId).u32(index); odulYaz(w, oduller);
  return { hata: 0, paket: w.done(), oduller, fiyat };
}
/** Bir olay anahtari degisince etkilenen gorevler icin 0x01186a02 push paketleri. */
function guncellePaketleri(durum, anahtar) {
  const out = [];
  for (const t of tasks().values()) {
    if (!t.sart || alindiMi(durum, t.id)) continue;
    const ilgili = t.sart.tip === 'gorev' ? anahtar === 'gorev' : t.sart.anahtar === anahtar;
    if (!ilgili) continue;
    const p = Buffer.alloc(8); p.writeUInt32BE(t.id, 0); p.writeUInt32BE(Math.min(0x7fffffff, ilerleme(durum, t)), 4);
    out.push({ id: OP_GUNCELLE, payload: p, kaynak: 'BLEACHTRAIN-guncelle' });
  }
  return out;
}
olay.abone((durum, anahtar) => guncellePaketleri(durum, anahtar));

function ozet(durum) { const d = depo(durum); return { gorev: tasks().size, alinan: Object.keys(d.alinan).length, paket: Object.keys(d.satin).length, sartsiz: [...tasks().values()].filter(t => !t.sart).length }; }

module.exports = { OP_LISTE, OP_ODUL, OP_GUNCELLE, OP_VIPBAG, tasks, gifts, depo, ilerleme, listePaketi, odulAl, vipBagAl, guncellePaketleri, ozet, SARTLAR };
