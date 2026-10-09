'use strict';
// OZEL ETKINLIK PENCERELERI — kutu listesi degil, KENDI DURUM MAKINESI olan HD etkinlikler.
// Genel etkinlik.js yolu (kademe = seviye kapisi + "alindi" listesi) bu pencerelere uymuyor:
//   DayBack        (870000, "Daily Presents")   : gunun login hediyesi + gunluk yukleme kademeleri (bit maskesi) + nihai hediye
//   RushInSeireitei(940000, "Seireitei Attack") : canlilik -> saldiri hakki, 13 boss, sandiklar, puan dukkani, siralama blogu
//   Chess          (540000, "Treasure Hunt" zar tahtasi): 100 kare, zar/super zar, basari (ardisik zar) odulleri, nihai odul
//   MoneyPenny     (420000, "Make Money")       : 5 gunluk yukleme -> altin iadesi
// Protokol (client kaynagi): InitRet blok tipleri 1=BoxState 2=Parameter 9=ServerRank; OperateReq [wire][idx] + opsiyonel [i16 n][n x i32].
// AwardStatusChangeNotify (0x01182305) [i16 n] + n x (wire, idx, status, [i16]+i32[], [i16 0]) — pencere durumunu BU degistirir.
// Yukleme (top-up) ozel sunucuda gercek degil: launcher'daki "VIP / Altin Yukle" dugmesi handlers.topupUygula ile
// durum.topup.gun[tarih]'e yazar; bu pencereler o sayaci okur. BEDAVA=true: yukleme sartlari acik (kullanici istegi).
const fs = require('fs');
const path = require('path');
const { Y, O, satir, json, simdi, gun, gunluk, rnd } = require('./paket');
const etkinlik = require('./etkinlik');

const VJ = path.join(__dirname, '..', 'cikarim', 'veri-json');
const ACT_DIR = path.join(__dirname, 'activity');
const BEDAVA = true;
const OP_NOTIFY = 0x01182305;
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;

let TABLO_HARITA = null;
function tabloHarita() { return (TABLO_HARITA ||= jread(path.join(__dirname, 'etkinlik-tablolari.json'), {})); }
let HDACT = null;
function hdRow(wireId) {
  if (!HDACT) { HDACT = new Map(); for (const r of jread(path.join(VJ, 'HDActivity.json'), [])) HDACT.set(num(r.id), r); }
  return HDACT.get(wireId >>> 0) || null;
}
function kategoriOf(wireId) { const k = etkinlik.katalog().get(wireId >>> 0); return k ? k.kategori : 0; }
function baslangic(wireId) {
  const r = hdRow(wireId); const a = r ? json(r.startTime, null) : null;
  if (Array.isArray(a) && a.length >= 3) return Math.floor(new Date(a[0], a[1] - 1, a[2], a[3] || 0, a[4] || 0, a[5] || 0).getTime() / 1000);
  return simdi();
}
function konfig(wireId) {
  const k = etkinlik.katalog().get(wireId >>> 0); if (!k) return null;
  const h = tabloHarita()[String(k.kategori)]; if (!h || !h.tablo) return null;
  const rows = jread(path.join(VJ, h.tablo + '.json'), []);
  return rows.find(r => num(r.id) === k.actId) || rows[0] || null;
}
// ---- yukleme sayaci (durum.topup) ----
function topupDepo(durum) { if (!durum.topup || typeof durum.topup !== 'object') durum.topup = { gun: {}, toplam: 0 }; if (!durum.topup.gun) durum.topup.gun = {}; return durum.topup; }
function topupGun(durum, tarih) { return Number(topupDepo(durum).gun[tarih]) || 0; }
function topupEkle(durum, n) { const t = topupDepo(durum); const g = gun(); t.gun[g] = (Number(t.gun[g]) || 0) + n; t.toplam = (Number(t.toplam) || 0) + n; return t; }
function tarihStr(ts) { const d = new Date(ts * 1000); return d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' + String(d.getDate()).padStart(2, '0'); }

// ---- paketler ----
function kutuYaz(w, k) { w.i32(k.idx).u32(k.acq).i32(k.st); const c = k.kosul || []; w.u16(c.length); for (const x of c) w.u32(x); }
/** InitRet: bloklar = [{tip:2, degerler}, {tip:1, kutular}, {tip:9, raw}] — tipler ONCE, govdeler SONRA */
function initPaketi(wireId, bloklar) {
  const w = new Y().u32(wireId).u16(bloklar.length);
  for (const b of bloklar) w.u32(b.tip);
  for (const b of bloklar) {
    if (b.tip === 2) { w.u16(b.degerler.length); for (const v of b.degerler) w.u32(v); }
    else if (b.tip === 1) { w.u16(b.kutular.length); for (const k of b.kutular) kutuYaz(w, k); }
    else if (b.raw) w.raw(b.raw);
  }
  return w.done();
}
function bildirimPaketi(wireId, list) {
  const w = new Y().i16(list.length);
  for (const b of list) { w.u32(wireId).i32(b.idx).i32(b.st); const c = b.kosul || []; w.i16(c.length); for (const x of c) w.i32(x); w.i16(0); }
  return w.done();
}
const HATA = etkinlik.HATA;
const sonuc = (hata, oduller, bildir) => ({ hata: hata || 0, oduller: oduller || [], bildir: bildir || [] });
const odul = awardId => { try { return etkinlik.odulCoz(awardId); } catch (e) { return []; } };
// Yakalanan InitRet'in kutu blogundan SONRAKI ham kuyrugu (tip 9 siralama blogu vb.) — pencere bunu bekliyor.
const KUYRUK = new Map();
function yakalananKuyruk(wireId) {
  const key = (wireId >>> 0).toString(16).padStart(8, '0');
  if (KUYRUK.has(key)) return KUYRUK.get(key);
  let out = null;
  try {
    const b = fs.readFileSync(path.join(ACT_DIR, '0x01182302_' + key + '.bin'));
    const n = b.readUInt16BE(4); let p = 6; const tipler = [];
    for (let i = 0; i < n; i++) { tipler.push(b.readUInt32BE(p)); p += 4; }
    for (const t of tipler) {
      if (t === 2) { const c = b.readUInt16BE(p); p += 2 + 4 * c; continue; }
      if (t === 1) { const c = b.readUInt16BE(p); p += 2; for (let i = 0; i < c; i++) { p += 12; const kc = b.readUInt16BE(p); p += 2 + 4 * kc; } continue; }
      out = { tip: t, raw: b.subarray(p) }; break;
    }
  } catch (e) {}
  KUYRUK.set(key, out);
  return out;
}

function kur(y) {
  const { paraHarca, ekSonra } = y;
  const harca = list => { const p = paraHarca(list); if (p) ekSonra(0x01180105, p, 'ETKINLIK-para'); return !!p; };
  const altin = n => (BEDAVA || n <= 0) ? true : harca([{ type: 0, code: 1, amount: n }]);
  const canlilik = n => n <= 0 ? true : harca([{ type: 3, code: 0, amount: n }]);
  const init = {}, operate = {};

  // ================= DAYBACK (Daily Presents) =================
  const db = (wire, durum) => {
    const row = konfig(wire) || {};
    const login = json(row.loginGift, { index: 1, award: [] });
    const rechargeIndex = Number(row.rechargeIndex) || 2, rechargeReceiveIndex = Number(row.rechargeReceiveIndex) || 3;
    const rechargeGift = json(row.rechargeGift, []);
    const finalGift = json(row.finalGift, { index: 8, award: [] });
    const gunSayisi = Math.max(1, rechargeGift.length || 1);
    const day = Math.max(0, Math.min(gunSayisi - 1, Math.floor((simdi() - baslangic(wire)) / 86400)));
    const tiers = rechargeGift[day] || rechargeGift[0] || [];
    const fin = (finalGift.award || [])[day] || (finalGift.award || [])[0] || { rechargeCondition: 0, awardID: 0 };
    const g = gunluk(durum); g.dayback = g.dayback || {}; const s = g.dayback[String(wire)] = g.dayback[String(wire)] || { login: 0, mask: 0, final: 0 };
    const gercek = topupGun(durum, gun());
    const prog = BEDAVA ? Math.max(gercek, ...tiers.map(x => Number(x.condition) || 0), Number(fin.rechargeCondition) || 0) : gercek;
    return { login, rechargeIndex, rechargeReceiveIndex, tiers, fin, finalIndex: Number(finalGift.index) || 8, day, s, prog };
  };
  init[870000] = (wire, durum) => {
    const c = db(wire, durum);
    return initPaketi(wire, [
      { tip: 2, degerler: [c.day] },
      { tip: 1, kutular: [
        { idx: c.rechargeIndex, acq: 32765, st: c.prog },
        { idx: c.rechargeReceiveIndex, acq: 32765, st: c.s.mask },
        { idx: Number(c.login.index) || 1, acq: 1, st: c.s.login ? -1 : 1 },
        { idx: c.finalIndex, acq: 1, st: c.s.final ? -1 : 1 },
      ] },
    ]);
  };
  operate[870000] = (wire, idx, ek, durum) => {
    const c = db(wire, durum);
    if (idx === (Number(c.login.index) || 1)) {
      if (c.s.login) return sonuc(HATA.ALINMIS);
      const aw = (c.login.award || [])[c.day] || (c.login.award || [])[0];
      c.s.login = 1; return sonuc(0, odul(aw), [{ idx, st: -1 }]);
    }
    if (idx === c.rechargeReceiveIndex) {
      const bit = Math.max(0, ek[0] | 0); const t = c.tiers[bit];
      if (!t) return sonuc(HATA.GENEL);
      if (c.s.mask & (1 << bit)) return sonuc(HATA.ALINMIS);
      if (c.prog < (Number(t.condition) || 0)) return sonuc(HATA.SART_YOK);
      c.s.mask |= (1 << bit);
      return sonuc(0, odul(t.awardID), [{ idx: c.rechargeIndex, st: c.prog }, { idx, st: c.s.mask }]);
    }
    if (idx === c.finalIndex) {
      if (c.s.final) return sonuc(HATA.ALINMIS);
      if (c.prog < (Number(c.fin.rechargeCondition) || 0)) return sonuc(HATA.SART_YOK);
      c.s.final = 1; return sonuc(0, odul(c.fin.awardID), [{ idx, st: -1 }]);
    }
    return sonuc(HATA.GENEL);
  };

  // ================= RUSH IN SEIREITEI (Seireitei Attack + Point Shop) =================
  const rs = (wire, durum) => {
    const row = konfig(wire) || {};
    const gifts = json(row.refreshIndex, []);
    const atk = json(row.attackIndex, { index: 60, military: 10, hurt: 20 });
    const sp = json(row.totalScoreIndex, { index: 61, military: 20, hurt: 45 });
    const cfg = {
      gifts, atk, sp,
      atk10: Number(row.scoreIndex) || 65, sp10: Number(row.rankNum) || 66,
      refreshIdx: Number(row.f11) || 63, attackIdx: Number(row.f12) || 62,
      shop: json(row.f13, []), scoreIdx: Number(row.f14) || 64, totalIdx: Number(row.f15) || 67,
    };
    durum.seireitei = durum.seireitei || {};
    const s = durum.seireitei[String(wire)] = durum.seireitei[String(wire)] || { level: gifts.length ? Number(gifts[0].index) : 1, refresh: 0, score: 0, total: 0, chest: {}, normal: 0, special: 0 };
    const g = gunluk(durum); g.seireiteiShop = g.seireiteiShop || {}; const shopG = g.seireiteiShop[String(wire)] = g.seireiteiShop[String(wire)] || {};
    return { cfg, s, shopG };
  };
  const shopDurum = (c, it) => c.shopG[String(it.index)] ? -1 : (c.s.score >= (Number(it.score) || 0) ? 1 : 0);
  const shopBildir = c => c.cfg.shop.map(it => ({ idx: Number(it.index), st: shopDurum(c, it) }));
  init[940000] = (wire, durum) => {
    const c = rs(wire, durum); const { cfg, s } = c;
    const kutular = [
      { idx: Number(cfg.atk.index), acq: 0, st: s.normal }, { idx: Number(cfg.sp.index), acq: 0, st: s.special },
      { idx: cfg.attackIdx, acq: 0, st: s.level }, { idx: cfg.refreshIdx, acq: 0, st: s.refresh },
      { idx: cfg.scoreIdx, acq: 0, st: s.score }, { idx: cfg.totalIdx, acq: 0, st: s.total },
    ];
    for (const gf of cfg.gifts) kutular.push({ idx: Number(gf.index), acq: 1, st: Number(s.chest[String(gf.index)]) || 0, kosul: [Number((gf.awardIds || [])[s.refresh] || (gf.awardIds || [])[0] || 0)] });
    for (const it of cfg.shop) kutular.push({ idx: Number(it.index), acq: 2, st: shopDurum(c, it) });
    const bloklar = [{ tip: 1, kutular }];
    const k = yakalananKuyruk(wire); if (k) bloklar.push(k);
    return initPaketi(wire, bloklar);
  };
  operate[940000] = (wire, idx, ek, durum) => {
    const c = rs(wire, durum); const { cfg, s } = c;
    const sayimlar = () => [{ idx: Number(cfg.atk.index), st: s.normal }, { idx: Number(cfg.sp.index), st: s.special }];
    const takas = [[Number(cfg.atk.index), 'normal', 1, Number(cfg.atk.military)], [cfg.atk10, 'normal', 10, Number(cfg.atk.military) * 10],
                   [Number(cfg.sp.index), 'special', 1, Number(cfg.sp.military)], [cfg.sp10, 'special', 10, Number(cfg.sp.military) * 10]];
    const t = takas.find(x => x[0] === idx);
    if (t) { if (!canlilik(t[3])) return sonuc(16); s[t[1]] += t[2]; return sonuc(0, [], sayimlar()); }
    if (idx === cfg.attackIdx) {
      if (s.level === -1) return sonuc(HATA.GENEL);
      const i = cfg.gifts.findIndex(x => Number(x.index) === s.level); const gf = cfg.gifts[i]; if (!gf) return sonuc(HATA.GENEL);
      const hp = Number(gf.hp) || 1; let dmg = 0, n = 0, m = 0;
      while (n < s.normal && dmg < hp) { dmg += Number(cfg.atk.hurt) || 1; n++; }
      while (dmg < hp && m < s.special) { dmg += Number(cfg.sp.hurt) || 1; m++; }
      if (dmg < hp) return sonuc(0, [], sayimlar());            // yetersiz hasar: hak harcanmaz
      s.normal -= n; s.special -= m; s.chest[String(gf.index)] = 1;
      const puan = Number(gf.score) || 0; s.score += puan; s.total += puan;
      s.level = cfg.gifts[i + 1] ? Number(cfg.gifts[i + 1].index) : -1;
      return sonuc(0, [], [...sayimlar(), { idx: Number(gf.index), st: 1 }, { idx: cfg.attackIdx, st: s.level }, { idx: cfg.scoreIdx, st: s.score }, { idx: cfg.totalIdx, st: s.total }, ...shopBildir(c)]);
    }
    const gf = cfg.gifts.find(x => Number(x.index) === idx);
    if (gf) {
      if (Number(s.chest[String(gf.index)]) !== 1) return sonuc(Number(s.chest[String(gf.index)]) === -1 ? HATA.ALINMIS : HATA.SART_YOK);
      s.chest[String(gf.index)] = -1;
      const aw = (gf.awardIds || [])[s.refresh] || (gf.awardIds || [])[0];
      return sonuc(0, odul(aw), [{ idx, st: -1 }]);
    }
    const it = cfg.shop.find(x => Number(x.index) === idx);
    if (it) {
      if (c.shopG[String(it.index)]) return sonuc(HATA.ALINMIS);
      if (s.score < (Number(it.score) || 0)) return sonuc(HATA.SART_YOK);
      s.score -= Number(it.score) || 0; c.shopG[String(it.index)] = 1;
      return sonuc(0, odul(it.awardId), [{ idx: cfg.scoreIdx, st: s.score }, ...shopBildir(c)]);
    }
    if (idx === cfg.refreshIdx) {
      if (s.level !== -1) return sonuc(HATA.GENEL);
      s.level = cfg.gifts.length ? Number(cfg.gifts[0].index) : 1; s.chest = {}; s.refresh = s.refresh ? 0 : 1;
      return sonuc(0, [], [{ idx: cfg.attackIdx, st: s.level }, { idx: cfg.refreshIdx, st: s.refresh }, ...cfg.gifts.map(x => ({ idx: Number(x.index), st: 0 }))]);
    }
    return sonuc(HATA.GENEL);
  };

  // ================= CHESS (Treasure Hunt zar tahtasi) =================
  // THDChess.ReadDataByStream sirasi: boxes(JSON) final(JSON) achieve(JSON) + 11 x u32:
  //   MaxDiceNum NormalCost ControlCost FinalCost CoolDown LocationIndex RefreshFinalIndex NormalIndex ControlIndex ResetIndex VistaIndex
  // JSON kolon adlari kaymis (finalCost=MaxDiceNum, coolDown=NormalCost ...); sira uzerinden okunur.
  const ch = (wire, durum) => {
    const row = konfig(wire) || {};
    const sira = ['finalCost', 'coolDown', 'locationIndex', 'refreshFinalIndex', 'normalIndex', 'controlIndex', 'resetIndex', 'vistaIndex', 'prompt0', 'prompt1', 'prompt2'].map(k => Number(row[k]) || 0);
    const cfg = {
      boxes: json(row.maxDiceNum, []), fin: json(row.normalCost, { rate: [], award: [] }), ach: json(row.controlCost, []),
      normalCost: sira[1] || 150, controlCost: sira[2] || 250, finalCost: sira[3] || 10, cooldown: sira[4] || 43200,
      locIdx: sira[5] || 100, finalIdx: sira[6] || 101, normalIdx: sira[7] || 102, controlIdx: sira[8] || 103, resetIdx: sira[9] || 104,
    };
    durum.chess = durum.chess || {};
    const s = durum.chess[String(wire)] = durum.chess[String(wire)] || { pos: 0, final: 0, ach: {}, son: [], sonBedava: 0 };
    return { cfg, s };
  };
  init[540000] = (wire, durum) => {
    const { cfg, s } = ch(wire, durum);
    const kalan = BEDAVA ? 0 : Math.max(0, (s.sonBedava || 0) + cfg.cooldown - simdi());
    const kutular = cfg.ach.map(a => ({ idx: Number(a.index), acq: 1, st: Number(s.ach[String(a.index)]) || 0 }));
    kutular.push({ idx: cfg.locIdx, acq: 0, st: s.pos }, { idx: cfg.finalIdx, acq: 0, st: s.final });
    return initPaketi(wire, [{ tip: 2, degerler: [kalan] }, { tip: 1, kutular }]);
  };
  operate[540000] = (wire, idx, ek, durum) => {
    const { cfg, s } = ch(wire, durum);
    const hareket = adim => {
      const bildir = [];
      s.son = [...(s.son || []), adim].slice(-3);
      for (const a of cfg.ach) {
        const cond = (a.condition || []).map(Number); if (cond.length !== 3 || s.son.length < 3) continue;
        if (cond.every((v, i) => v === s.son[i]) && !s.ach[String(a.index)]) { s.ach[String(a.index)] = 1; bildir.push({ idx: Number(a.index), st: 1 }); }
      }
      const yeni = Math.min(100, s.pos + adim);
      const aw = yeni >= 100 ? (cfg.fin.award || [])[s.final] : cfg.boxes[yeni - 1];
      s.pos = yeni; bildir.unshift({ idx: cfg.locIdx, st: s.pos });
      return sonuc(0, odul(aw), bildir);
    };
    if (idx === cfg.normalIdx) {
      if (s.pos >= 100) return sonuc(HATA.GENEL);
      const odemeli = (ek[0] | 0) === 1;
      if (odemeli) { if (!altin(cfg.normalCost)) return sonuc(16); } else s.sonBedava = simdi();
      return hareket(1 + rnd(6));
    }
    if (idx === cfg.controlIdx) {
      if (s.pos >= 100) return sonuc(HATA.GENEL);
      if (!altin(cfg.controlCost)) return sonuc(16);
      return hareket(Math.max(1, Math.min(6, ek[0] | 0)));
    }
    if (idx === cfg.resetIdx) { if (s.pos < 100) return sonuc(HATA.GENEL); s.pos = 0; s.son = []; return sonuc(0, [], [{ idx: cfg.locIdx, st: 0 }]); }
    if (idx === cfg.finalIdx) {
      if (!altin(cfg.finalCost)) return sonuc(16);
      const rates = (cfg.fin.rate || []).map(Number); const r = rnd(100); let i = rates.findIndex(x => r < x); if (i < 0) i = Math.max(0, rates.length - 1);
      s.final = i; return sonuc(0, [], [{ idx: cfg.finalIdx, st: i }]);
    }
    const a = cfg.ach.find(x => Number(x.index) === idx);
    if (a) {
      if (Number(s.ach[String(a.index)]) !== 1) return sonuc(Number(s.ach[String(a.index)]) === -1 ? HATA.ALINMIS : HATA.SART_YOK);
      s.ach[String(a.index)] = -1; return sonuc(0, odul((a.award || [])[0]), [{ idx, st: -1 }]);
    }
    return sonuc(HATA.GENEL);
  };

  // ================= MONEY PENNY (Make Money) =================
  const mp = (wire, durum) => {
    const row = konfig(wire) || {};
    const boxes = json(row.payDay, []); const conds = json(row.additional, []).map(x => ({ condition: Number(x.condition) || 0, rate: Number(x.rate) || 0 }));
    const ekYuzde = Number(row.f9) || 5;
    const gunler = boxes.filter(b => Number(b.getType) === 4); const alim = boxes.find(b => Number(b.getType) === 1) || { index: 5 };
    const bas = baslangic(wire);
    const yuk = gunler.map((b, i) => topupGun(durum, tarihStr(bas + i * 86400)));
    let toplam = 0, hepsi = gunler.length > 0;
    yuk.forEach(v => { let rate = 0; for (const c of conds) { if (v < c.condition) break; rate = c.rate; } toplam += Math.floor(v * rate / 100); if (!(conds.length && v >= conds[0].condition)) hepsi = false; });
    if (hepsi) toplam += Math.floor(toplam * ekYuzde / 100);
    durum.moneypenny = durum.moneypenny || {};
    const s = durum.moneypenny[String(wire)] = durum.moneypenny[String(wire)] || { alindi: 0 };
    return { gunler, alim, yuk, toplam, s };
  };
  init[420000] = (wire, durum) => {
    const c = mp(wire, durum);
    const kutular = c.gunler.map((b, i) => ({ idx: Number(b.index), acq: 4, st: 0, kosul: [c.yuk[i]] }));
    kutular.push({ idx: Number(c.alim.index), acq: 1, st: c.s.alindi ? -1 : (c.toplam > 0 ? 1 : 0) });
    return initPaketi(wire, [{ tip: 1, kutular }]);
  };
  operate[420000] = (wire, idx, ek, durum) => {
    const c = mp(wire, durum);
    if (idx !== Number(c.alim.index)) return sonuc(HATA.GENEL);
    if (c.s.alindi) return sonuc(HATA.ALINMIS);
    if (c.toplam <= 0) return sonuc(HATA.SART_YOK);
    c.s.alindi = 1; return sonuc(0, [{ type: 0, code: 1, amount: c.toplam }], [{ idx, st: -1 }]);
  };

  return { init, operate, kategoriOf, bildirimPaketi, OP_NOTIFY, topupEkle, topupGun, topupDepo, BEDAVA };
}

module.exports = { kur, kategoriOf, topupEkle, topupGun, topupDepo, bildirimPaketi, OP_NOTIFY, BEDAVA };
