'use strict';
// EKIPMAN SISTEMI: kalici ekipman ornekleri (seviye/ek nitelik/tas/silah becerisi/ruh), tak/cikar,
// demirci (guclendir/arit/aktar/ilerlet/beceri/ruh/delik), yesim (birlestir/tak/cikar), tilsim, sus,
// uyanis, Hogyoku (CrashJade), Ekipman Ocagi (UltimateEquip), CharBaseAttributeRet (stat = taban + ekipman).
//
// Kayit (InventoryReference, TUnstreamizerEquipment birebir):
//   u8 kat, u32 tpl, u32 inst, u16 1, u8 0, u32 0, u8 lvl, u8 hole, u16 nApp + nApp x (u32 id, u32 cat, u16 val),
//   u32 weaponSkill, u32 flush, u16 nGem + nGem x (u8 3, u32 gemTpl)
// Client BaseEquip/BuildValue/BuildConsume/TreasureUpgrade/TempleValue/EquipAdditional/WeaponSkillConfig'i
// null-kontrolsuz okur -> her degisiklik once tabloda dogrulanir.
const fs = require('fs');
const path = require('path');
const { Y, O, tablo, satir, json, cv, simdi, rnd, sec } = require('./paket');
const envanter = require('./envanter');
const statlar = require('./statlar');

const OP_NTF = 0x01180f02, OP_SEND = 0x01180f01, OP_REDUCE = 0x01180f06, OP_PARA = 0x01180105, OP_ATTR = 0x01180104;
const MAX_LV = 159;
const slotKat = s => (s >= 1 && s <= 6) ? 2 : (s >= 7 && s <= 10) ? 4 : (s >= 11 && s <= 18) ? 6 : 0;
const EKIPMAN_KAT = new Set([2, 4, 6]);

// ---------- tablo yardimcilari ----------
const article = tpl => satir('Article', tpl);
const baseEquip = tpl => satir('BaseEquip', tpl);
const baseStone = tpl => satir('BaseStone', tpl);
function beCoz(tpl) {   // BaseEquip gercek alanlar (JSON etiketleri kaymis)
  const r = baseEquip(tpl); if (!r) return null;
  return {
    meslek: String(r.dressProfession || '0').split('_').map(Number).filter(x => x > 0),
    mainType: json(r.mainAdditionalType, []), mainValue: json(r.maxAdditionalCount, []),
    maxApp: Number(r.suitId) || 0, holeCount: Number(r.skillRevise) || 0, suitId: Number(r.edgeColor) || 0,
    skillRevise: Number(r.flushSpiritCoefficient) || 0, flushK: Number(r.f9) || 0, drillHoleNum: Number(r.f10) || 0,
  };
}
const buildValue = (cat2, q, L) => satir('BuildValue', cat2 * 10000 + q * 1000 + L);
const buildConsume = (q, L) => satir('BuildConsume', q * 1000 + L);
const treasureUp = (tpl, L) => satir('TreasureUpgrade', (tpl % 1000) * 1000 + L);
let ORN = null;
function ornamentValue(tpl, L) {
  if (!ORN) { ORN = new Map(); for (const r of tablo('OrnamentValue').liste) ORN.set(String(r.level), r); }
  return ORN.get(tpl + ':' + L) || null;
}
function equipAdditional(id) { const r = satir('EquipAdditional', id); if (!r) return null; const te = json(r.typeEffect, {}); const p = String(te.typeEffect || '').split('_').map(Number); return { id: r._id, cat: p[0] || 0, min: p[1] || 0, max: p[2] || 0, div: p[3] || 1, pct: p[4] || 0, lvl: Number(r.equipLevel) || 0 }; }
function mapLvOf(reqLevel) { const bands = cv(60340008, [1, 50, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170]); let m = bands[0]; for (const b of bands) if (b <= reqLevel) m = b; return m; }
function bandIndex(mapLv) { const bands = cv(60340008, [1]); const i = bands.indexOf(mapLv); return i < 0 ? 0 : i; }

// ---------- depo ----------
function depo(durum) {
  durum.ekipman = durum.ekipman || {};
  const e = durum.ekipman;
  e.esyalar = e.esyalar || {};
  e.takili = e.takili || {};
  e.adaylar = e.adaylar || {};
  if (!Number.isFinite(Number(e.sonInst))) e.sonInst = 0x20000000;
  e.cd = Number(e.cd) || 0; e.koruma = Number(e.koruma) || 0;
  if (!e.goc) goc(durum);
  return e;
}
function yeniInst(e) { e.sonInst = (Number(e.sonInst) || 0x20000000) + 1; return e.sonInst >>> 0; }
function yeniEsya(e, tpl, inst) {
  const a = article(tpl); if (!a || !EKIPMAN_KAT.has(Number(a.majorType))) return null;
  const id = inst || yeniInst(e);
  e.esyalar[String(id)] = { tpl: tpl >>> 0, kat: Number(a.majorType), slot: Number(a.minorType) || 0, lvl: 0, hole: 0, app: [], ws: 0, fl: 0, gems: [] };
  return id;
}
function esya(durum, inst) { return depo(durum).esyalar[String(inst >>> 0)] || null; }
function takiliMi(e, inst) { const s = String(inst >>> 0); for (const [h, m] of Object.entries(e.takili)) for (const [slot, i] of Object.entries(m)) if (String(i) === s) return { hero: Number(h), slot: Number(slot) }; return null; }
function anaId() { try { return require('./seviye').anaId(); } catch (e) { return 0; } }
function anaMeslek() { const h = statlar.heroById.get(anaId() >>> 0); return h ? Number(h.profession) || 0 : 0; }
function meslekUygun(tpl, meslek) { const b = beCoz(tpl); if (!b) return true; return !b.meslek.length || b.meslek.includes(meslek); }

// ---------- goc: yakalanan taban canta + yakalanan takili set -> kalici depo ----------
function yakalananTakili() {
  const out = [];
  try {
    const harita = require('./harita');
    const b = fs.readFileSync(path.join(__dirname, 'cevaplar', '0x01180102.bin'));
    const s = harita.basicEnd(b) + 2;
    const [, aSon] = statlar.attrAralik(b, s);
    const r = kayitlariOku(b, aSon);
    for (const k of r.kayitlar) out.push(k);
  } catch (e) { }
  return out;
}
function goc(durum) {
  const e = durum.ekipman;
  e.goc = 1;
  // taban cantadaki ekipmanlar (ayri ornekler)
  try { for (const x of envanter.taban()) if (EKIPMAN_KAT.has(Number(x.kategori))) for (let i = 0; i < (Number(x.amount) || 1); i++) yeniEsya(e, x.code, i === 0 && x.instance > 5000 ? x.instance : 0); } catch (err) { }
  // kalici envanterde birikmis ekipmanlar (eski surum yiginlamisti)
  try {
    const d = envanter.depo(durum);
    const kalan = [];
    for (const x of d.esyalar) {
      const a = article(x.code);
      if (a && EKIPMAN_KAT.has(Number(a.majorType))) { for (let i = 0; i < (Number(x.amount) || 1); i++) yeniEsya(e, x.code, 0); }
      else kalan.push(x);
    }
    d.esyalar = kalan;
  } catch (err) { }
  // yakalanan takili set -> ana hero (meslek uymayan silah cantaya, uygun olan cantadan takilir)
  // Admin grants can migrate another account's inventory in the auth process.
  // Prefer that account's character over the process-global runtime character.
  const ana = Number(durum.karakter?.anaId) || anaId();
  const meslek = Number(statlar.heroById.get(ana >>> 0)?.profession) || anaMeslek();
  const tak = {};
  for (const k of yakalananTakili()) {
    const a = article(k.tpl); if (!a) continue;
    const inst = yeniInst(e);
    e.esyalar[String(inst)] = { tpl: k.tpl, kat: k.kat, slot: Number(a.minorType) || 0, lvl: k.lvl, hole: k.hole, app: k.app, ws: k.ws, fl: k.fl, gems: k.gems };
    if (meslekUygun(k.tpl, meslek) && !tak[a.minorType]) tak[a.minorType] = inst;
  }
  if (!tak[1]) { for (const [inst, x] of Object.entries(e.esyalar)) if (x.slot === 1 && !takiliMi(e, inst) && meslekUygun(x.tpl, meslek)) { tak[1] = Number(inst); break; } }
  if (ana) e.takili[String(ana)] = tak;
}

// ---------- serilestirme ----------
function kayitBuf(x, inst) {
  const w = new Y();
  w.u8(x.kat).u32(x.tpl).u32(inst).u16(1).u8(0).u32(0);
  w.u8(Math.min(255, x.lvl || 0)).u8(x.hole || 0);
  const app = (x.app || []).filter(a => a && a[0] && satir('EquipAdditional', a[0]));
  w.u16(app.length); for (const a of app) w.u32(a[0]).u32(a[1]).u16(a[2]);
  w.u32(x.ws && satir('WeaponSkillConfig', x.ws) ? x.ws : 0).u32(x.fl || 0);
  const gems = (x.gems || []).filter(g => article(g));
  w.u16(gems.length); for (const g of gems) w.u8(3).u32(g);
  return w.done();
}
function kayitBufInst(durum, inst) { const x = esya(durum, inst); return x ? kayitBuf(x, inst >>> 0) : null; }
// Bir kayit dizisini oku (u16 n + n x InventoryReference). Donus {kayitlar, son}
function kayitlariOku(b, p0) {
  let p = p0; const n = b.readUInt16BE(p); p += 2; const out = [];
  for (let i = 0; i < n; i++) {
    const kat = b[p]; const tpl = b.readUInt32BE(p + 1); const inst = b.readUInt32BE(p + 5); p += 16;
    if (EKIPMAN_KAT.has(kat)) {
      const k = { kat, tpl, inst, lvl: b[p], hole: b[p + 1], app: [], ws: 0, fl: 0, gems: [] };
      const na = b.readUInt16BE(p + 2); p += 4;
      for (let j = 0; j < na; j++) { k.app.push([b.readUInt32BE(p), b.readUInt32BE(p + 4), b.readUInt16BE(p + 8)]); p += 10; }
      k.ws = b.readUInt32BE(p); k.fl = b.readUInt32BE(p + 4); p += 8;
      const g = b.readUInt16BE(p); p += 2;
      for (let j = 0; j < g; j++) { k.gems.push(b.readUInt32BE(p + 1)); p += 5; }
      out.push(k);
    } else if (kat === 20) out.push({ kat, tpl, inst });
    else { p += 14; out.push({ kat, tpl, inst }); }
  }
  return { kayitlar: out, son: p };
}
function cantaKayitlari(durum) {
  const e = depo(durum); const out = [];
  for (const [inst, x] of Object.entries(e.esyalar)) if (!takiliMi(e, inst) && article(x.tpl)) out.push(kayitBuf(x, Number(inst) >>> 0));
  return out;
}
function takiliKayitlar(durum, heroId) {
  const e = depo(durum); const m = e.takili[String(heroId >>> 0)] || {}; const out = [];
  for (const inst of Object.values(m)) { const x = e.esyalar[String(inst)]; if (x && article(x.tpl)) out.push(kayitBuf(x, Number(inst) >>> 0)); }
  return out;
}
function sendPaketi(bufs, tip = 0) { const w = new Y(); w.u8(tip).u16(bufs.length); for (const b of bufs) w.raw(b); return w.done(); }
function reducePaketi(insts, tip = 0) { const w = new Y(); w.u8(tip).u16(insts.length); for (const i of insts) w.u32(i); return w.done(); }

// ---------- envanter kancasi (kategori 2/4/6 esyalar buradan) ----------
const KANCA = {
  kategoriler: EKIPMAN_KAT,
  ekle(durum, code, adet) { const e = depo(durum); const out = []; for (let i = 0; i < adet; i++) { const id = yeniEsya(e, code, 0); if (id) out.push(id); } return out; },
  mevcut(durum, code) { const e = depo(durum); let n = 0; for (const [inst, x] of Object.entries(e.esyalar)) if ((x.tpl >>> 0) === (code >>> 0) && !takiliMi(e, inst)) n++; return n; },
  dus(durum, code, adet) { const e = depo(durum); const l = []; for (const [inst, x] of Object.entries(e.esyalar)) if ((x.tpl >>> 0) === (code >>> 0) && !takiliMi(e, inst)) l.push(inst); if (l.length < adet) return false; for (let i = 0; i < adet; i++) delete e.esyalar[l[i]]; return true; },
  dusInst(durum, inst) { const e = depo(durum); const s = String(inst >>> 0); if (!e.esyalar[s] || takiliMi(e, s)) return false; delete e.esyalar[s]; return true; },
  kayitBuf: kayitBufInst,
  cantaKayitlari,
  varMi(durum, inst) { return !!esya(durum, inst); },
};
try { envanter.kancaAyarla(KANCA); } catch (e) { }

// ---------- char paketi yamasi: her heronun takili listesi + uyanis alanlari ----------
function charYama(buf, durum, basicEnd) {
  const e = depo(durum);
  const b = Buffer.from(buf);
  const ee = basicEnd(b); const cnt = b.readUInt16BE(ee);
  let p = ee + 2; const parcalar = [b.subarray(0, p)];
  for (let i = 0; i < cnt; i++) {
    const start = p; const heroId = b.readUInt32BE(start);
    const [, aSon] = statlar.attrAralik(b, start);
    const r = kayitlariOku(b, aSon);
    // uyanis: 8 x u32 blogu (HeroOverTime.. ) advN'den sonra: offset = start+22+2+9*advN ; WakeupLevel = +20, WakeupStatus = +24
    const advN = b.readInt16BE(start + 22); const blok = start + 24 + 9 * Math.max(0, advN);
    const u = (durum.uyanis || {})[String(heroId)];
    const ent = Buffer.from(b.subarray(start, aSon));
    const reincarnation = require('./reincarnation');
    const rebirth = reincarnation.record(durum, heroId);
    const progress = require('./seviye').heroDurum(durum, heroId);
    const rebirthOffset = blok + 32 - start;
    ent[rebirthOffset] = rebirth.n;
    ent[rebirthOffset + 1] = rebirth.pp;
    ent[rebirthOffset + 2] = rebirth.ae;
    ent.writeUInt32BE(Math.max(progress.lv, rebirth.history, ent.readUInt32BE(rebirthOffset + 3)), rebirthOffset + 3);
    ent.writeUInt32BE(progress.lv, 4);
    ent.writeUInt32BE(0, 8); ent.writeUInt32BE(progress.exp, 12);
    const [attrStart] = statlar.attrAralik(b, start);
    const stat = statPaketi(durum, heroId, progress.lv);
    if (stat && stat.length - 4 === aSon - attrStart) stat.subarray(4).copy(ent, attrStart - start);
    if (u) { ent.writeUInt32BE((u.lv || 0) >>> 0, blok + 20 - start); ent.writeUInt32BE((u.status || 0) >>> 0, blok + 24 - start); }
    parcalar.push(ent);
    const tak = takiliKayitlar(durum, heroId);
    parcalar.push(sendPaketi(tak).subarray(1));          // u16 n + kayitlar
    // crash jade takili: u16 n + n x (i8 pos, u32 hi, u32 lo, u32 tpl, u32 exp)
    const cjTak = ((durum.hogyoku || {}).takili || {})[String(heroId)] || {};
    const cw = new Y(); const cjl = Object.entries(cjTak).filter(([, j]) => j && satir('CrashJade', j.tpl));
    cw.u16(cjl.length); for (const [pos, j] of cjl) cw.i8(Number(pos)).u32(j.hi).u32(j.lo).u32(j.tpl).u32(j.exp);
    parcalar.push(cw.done());
    const cj = b.readUInt16BE(r.son); p = r.son + 2 + cj * 17;
  }
  parcalar.push(b.subarray(p));
  return Buffer.concat(parcalar);
}

// ---------- STAT: taban blok (olcekli) + ekipman katkisi ----------
// attribute id -> BaseAttributes index
const ATTR_IDX = { 1: 0, 3: 1, 2: 2, 4: 3, 11: 4, 101: 5, 16: 6, 18: 6, 20: 7, 17: 8, 19: 8, 21: 9, 22: 10, 23: 11, 24: 12, 25: 13, 26: 14, 27: 15, 30: 16, 31: 17, 28: 18, 29: 19, 104: 20, 34: 21, 39: 22, 40: 23, 41: 24, 42: 25 };
function hogyokuBonuses(durum, heroId) {
  const bonus = new Array(27).fill(0);
  const add = (id, value) => {
    const index = ATTR_IDX[id];
    if (index !== undefined) bonus[index] += value;
  };
  const equipped = ((durum.hogyoku || {}).takili || {})[String(heroId >>> 0)] || {};
  for (const jade of Object.values(equipped)) {
    if (!jade) continue;
    const config = satir('CrashJade', jade.tpl);
    if (!config) continue;
    const types = json(config.addType, []);
    const values = json(config.addValue, []);
    for (let i = 0; i < Math.min(types.length, values.length); i++) {
      const type = Number(types[i]) || 0;
      const value = Number(values[i]) || 0;
      if (type && value) add(type, value);
    }
  }
  return bonus;
}

function bonuslar(durum, heroId, baseBlock, skipRefinery = false, skipRebirth = false, skipStars = false) {
  if (!baseBlock) {
    const ana = statlar.anaKaynakHam();
    if (ana) baseBlock = ana.blok;
  }
  const e = depo(durum); const m = e.takili[String(heroId >>> 0)] || {}; const ek = new Array(27).fill(0);
  const suitCounts = new Map();
  const percentBonuses = new Map();
  const stonePrimaryRates = new Map();
  const ornamentPrimaries = new Map();
  const add = (id, v) => {
    // Attack/defense percentage names are not the client's ControlRate/ControlAnti slots.
    if (Number(id) === 32 || Number(id) === 33) {
      for (const i of Number(id) === 32 ? [6,7] : [8,9]) percentBonuses.set(i, (percentBonuses.get(i) || 0) + v);
      return;
    }
    const i = ATTR_IDX[id]; if (i === undefined) return; ek[i] += v;
  };
  for(const [type,value] of require('./hollow-soul-map').bonuses(durum,heroId)) add(type,value);
  for(const [type,value] of require('./titles').bonuses(durum,heroId)) add(type,value);
  const baseValue = index => {
    if (!baseBlock || baseBlock.length < 2) return null;
    const n = baseBlock.readUInt16BE(0);
    if (index >= n || 2 + 4 * n > baseBlock.length) return null;
    const off = 2 + 4 * index;
    return statlar.TIP[index] === 1 ? baseBlock.readFloatBE(off) : baseBlock.readUInt32BE(off);
  };
  for (const inst of Object.values(m)) {
    const x = e.esyalar[String(inst)]; if (!x) continue;
    const a = article(x.tpl); const be = beCoz(x.tpl); if (!a || !be) continue;
    if (be.suitId && satir('Suit', be.suitId)) {
      suitCounts.set(be.suitId, (suitCounts.get(be.suitId) || 0) + 1);
    }
    const q = Number(a.quality) || 1, L = x.lvl || 0;
    be.mainType.forEach((t, i) => {
      let v = Number(be.mainValue[i]) || 0;
      if (L > 0) {
        if (x.kat === 2) { const r = buildValue(a.minorType, q, L); if (r && i === 0) v += Number(r.value) || 0; }
        else if (x.kat === 4) { const r = treasureUp(x.tpl, L); const av = r ? json(r.costGold, []) : []; v += Number(av[i]) || 0; }
        else if (x.kat === 6) { const r = ornamentValue(x.tpl, L); if (r && i === 0) v += Number(r.f3) || 0; }
      }
      add(t, v);
      const primary=ATTR_IDX[t];
      if(Number(a.majorType)===6&&primary>=0&&primary<=3)ornamentPrimaries.set(primary,(ornamentPrimaries.get(primary)||0)+v);
    });
    for (const ap of (x.app || [])) { const d = equipAdditional(ap[0]); const div = d ? (d.div || 1) : 1; add(ap[1], (ap[2] || 0) / div); }
    for (const gem of (x.gems || [])) {
      const stone = baseStone(gem);
      if (!stone) continue;
      const type = Number(stone.addType) || 0;
      const value = Number(stone.addValue) || 0;
      const index = ATTR_IDX[type];
      if (!type || !value || index === undefined) continue;
      if (type >= 1 && type <= 4 && statlar.TIP[index] === 0) {
        if (baseValue(index) !== null) {
          percentBonuses.set(index, (percentBonuses.get(index) || 0) + value);
          stonePrimaryRates.set(index, (stonePrimaryRates.get(index) || 0) + value);
        }
      } else {
        add(type, value);
      }
    }
    if (x.fl > 0 && be.flushK) { const mapLv = mapLvOf(Number(a.level) || 1); const tv = satir('TempleValue', mapLv * 1000 + a.minorType * 100 + x.fl); if (tv) add(be.mainType[0], Math.round(Number(tv.levelCoefficient) * be.flushK * Number(tv.typeCoefficient) * (L + 0.5))); }
  }
  for (const [suitId, count] of suitCounts) {
    const suit = satir('Suit', suitId);
    const effects = suit ? json(suit.sEffect, {}) : {};
    for (const [threshold, attributes] of Object.entries(effects)) {
      if (count < Number(threshold) || !Array.isArray(attributes)) continue;
      for (const effect of attributes) {
        const [attribute, value, percent] = String(effect).split('_');
        const id = Number(attribute), index = ATTR_IDX[id];
        const amount = Number(value);
        if (!Number.isFinite(id) || !Number.isFinite(amount)) continue;
        if (Number(percent) === 1 && index !== undefined && statlar.TIP[index] === 0) {
          if (baseValue(index) !== null) percentBonuses.set(index, (percentBonuses.get(index) || 0) + amount);
        } else add(id, amount);
      }
    }
  }
  const hogu = hogyokuBonuses(durum, heroId);
  for (let i = 0; i < hogu.length; i++) ek[i] += hogu[i];
  // Rank rows describe the total formation bonus, never a cumulative upgrade reward.
  for (const effect of require('./military-rank').bonuses(durum,heroId)) {
    const type=Number(effect.type), amount=Number(effect.value)||0;
    add(type,amount);
    const primary=ATTR_IDX[type];
    if (type>=1 && type<=4 && baseValue(primary)>0) {
      const targets={0:[6,8],1:[7,9],2:[4],3:[5]}[primary];
      for(const target of targets) if(baseValue(target)>0) ek[target]+=Math.round(amount*baseValue(target)/baseValue(primary));
    }
  }
  const reiatsu = statlar.knifeSoulBonuses(durum);
  ek[statlar.IDX.Power] += reiatsu.power;
  ek[statlar.IDX.Intelligence] += reiatsu.intelligence;
  ek[statlar.IDX.Agile] += reiatsu.agile;
  ek[statlar.IDX.Life] += reiatsu.life;
  // Use the same calibrated primary-to-combat conversion as other core bonuses.
  // A Reiatsu level must improve combat, not only the four displayed primaries.
  for(const [index,amount,targets] of [
    [statlar.IDX.Power,reiatsu.power,[statlar.IDX.PhysicalAttack,statlar.IDX.PhysicalDefends]],
    [statlar.IDX.Intelligence,reiatsu.intelligence,[statlar.IDX.MagicAttack,statlar.IDX.MagicDefends]],
    [statlar.IDX.Agile,reiatsu.agile,[statlar.IDX.Speed]],
    [statlar.IDX.Life,reiatsu.life,[statlar.IDX.Health]],
  ]){
    const primary=baseValue(index);
    if(primary>0&&amount>0)for(const target of targets){const combat=baseValue(target);if(combat>0)ek[target]+=Math.round(amount*combat/primary);}
  }
  for (const [type, value] of Object.entries(statlar.spiritSchoolBonuses(durum))) add(Number(type), value);
  const reincarnation = require('./reincarnation');
  const rebirth = reincarnation.bonuses(reincarnation.record(durum, heroId));
  ek[statlar.IDX.Hurt] += rebirth.damage;
  ek[19] += rebirth.reduction;
  const fruit = ((durum.fruits || {})[String(heroId)] || [0,0,0,0]);
  for (const [index, targets] of [[0,[6,8]],[1,[7,9]],[2,[4]],[3,[5]]]) {
    const amount = Number(fruit[index]) || 0;
    ek[index] += amount;
    const primary = baseValue(index);
    if (primary > 0 && amount > 0) for (const target of targets) {
      const value = baseValue(target);
      if (value > 0) ek[target] += Math.round(amount * value / primary);
    }
  }
  const heroChange = durum && durum.degisim;
  const heroChanges = heroChange && heroChange.hero;
  const changeAttr = satir('HeroChangeAttr', heroId);
  const changeIds = changeAttr ? json(changeAttr.chipID, []) : [];
  const changeCount = Math.max(0, Math.min(changeIds.length, Math.floor(Number(heroChanges && heroChanges[String(heroId >>> 0)]) || 0)));
  for (const changeId of changeIds.slice(0, changeCount)) {
    const change = satir('PartnerChange', Number(changeId));
    for (const effect of change ? json(change.effect, []) : []) {
      const type = Number(effect.addType) || 0;
      const value = Number(effect.addValue) || 0;
      const index = ATTR_IDX[type];
      if (index === undefined || !value) continue;
      if (Number(effect.oper) === 2) {
        percentBonuses.set(index, (percentBonuses.get(index) || 0) + value);
      } else if (Number(effect.oper) === 1) {
        add(type, value);
      }
    }
  }
  const advanced = heroChange && heroChange.adv || {};
  const heroIdUnsigned = heroId >>> 0;
  for (const [key, value] of Object.entries(advanced)) {
    if (!key.startsWith(`${heroIdUnsigned}:`) && !key.startsWith(`${heroIdUnsigned | 0}:`)) continue;
    const type = Number(Array.isArray(value) ? value[0] : 0) || 0;
    const rate = Number(Array.isArray(value) ? value[1] : 0) / 100;
    const index = ATTR_IDX[type];
    if (index === undefined || !(rate > 0)) continue;
    if (statlar.TIP[index] === 1) add(type, rate);
    else percentBonuses.set(index, (percentBonuses.get(index) || 0) + rate);
  }
  // Primary Soul Stones must affect the combat attributes derived from that stat.
  // Calibrate conversions against the same hero base block used by login, stat updates
  // and combat; direct equipment HP/attack bonuses remain separate from primary stats.
  const derived = {
    [statlar.IDX.Power]: [statlar.IDX.PhysicalAttack, statlar.IDX.PhysicalDefends],
    [statlar.IDX.Intelligence]: [statlar.IDX.MagicAttack, statlar.IDX.MagicDefends],
    [statlar.IDX.Agile]: [statlar.IDX.Speed],
    [statlar.IDX.Life]: [statlar.IDX.Health],
  };
  // Flat accessory primaries must improve their derived combat stats too,
  // before stones/percentages and final rebirth/refinery/star multipliers.
  for(const [index,amount] of ornamentPrimaries){
    const primary=baseValue(index);if(!(primary>0))continue;
    for(const target of derived[index]||[]){const base=baseValue(target);if(base>0)ek[target]+=Math.round(amount*base/primary);}
  }
  for (const [index, rate] of stonePrimaryRates) {
    const primary = baseValue(index);
    if (!(primary > 0)) continue;
    const increase = Math.round((primary + ek[index]) * rate);
    for (const target of derived[index] || []) {
      const combatBase = baseValue(target);
      if (combatBase > 0) ek[target] += Math.round(increase * combatBase / primary);
    }
  }
  for (const [index, rate] of percentBonuses) {
    const base = baseValue(index);
    if (base !== null) ek[index] += Math.round((base + ek[index]) * rate);
  }
  if(!skipRebirth){
    const stages=require('./reincarnation').record(durum,heroId).n;
    if(stages)for(let index=0;index<10;index++){
      const base=baseValue(index);if(base!==null)ek[index]+=Math.round((base+ek[index])*stages);
    }
  }
  const refinery = skipRefinery ? null : require('./refinery').rates(durum, heroId);
  if (refinery) {
    for (const [index, field] of [[6,'phyAtk'],[7,'magicAtk'],[8,'phyDef'],[9,'magicDef'],[5,'hp'],[4,'speed']]) {
      const rate = Number(refinery[field]) || 0;
      const base = baseValue(index);
      if (base !== null && rate > 0) ek[index] += Math.round((base + ek[index]) * rate);
    }
  }
  const starFactor=skipStars?1:require('./hero-stars').multiplier(durum,heroId);
  if(starFactor>1)for(let index=0;index<10;index++){
    const base=baseValue(index);if(base!==null)ek[index]+=Math.round((base+ek[index])*(starFactor-1));
  }
  return ek;
}
function statPaketi(durum, heroId, level) {
  const ana = statlar.anaKaynakHam(); if (!ana) return null;
  const k = statlar.olcekler(heroId, level, ana.id, ana.lv, durum);
  const blok = statlar.blokOlcekle(ana.blok, k);
  const ek = bonuslar(durum, heroId, blok, true, true, true);
  const refinery = require('./refinery').rates(durum, heroId);
  let p = 0; let toplam = 0;
  for (let no = 0; no < 2; no++) {
    const n = blok.readUInt16BE(p); p += 2;
    for (let i = 0; i < n && i < 27; i++) {
      const off = p + 4 * i; const v = ek[i] || 0; if (!v) continue;
      if (statlar.TIP[i] === 1) blok.writeFloatBE(blok.readFloatBE(off) + v, off);
      else { blok.writeUInt32BE(Math.max(0, Math.min(0x7fffffff, Math.round(blok.readUInt32BE(off) + v))) >>> 0, off); if (no === 0 && i !== 26) toplam += v; }
    }
    if (n > 26) { const off = p + 4 * 26; blok.writeUInt32BE(Math.min(0x7fffffff, blok.readUInt32BE(off) + Math.round(toplam)) >>> 0, off); }
    const factor=require('./reincarnation').statMultiplier(durum,heroId);
    if(factor>1){
      for(const index of [0,1,2,3,4,5,6,7,8,9,26]){
        if(index>=n)continue;const off=p+4*index;
        blok.writeUInt32BE(Math.min(0x7fffffff,Math.round(blok.readUInt32BE(off)*factor)),off);
      }
    }
    if (refinery) {
      let extraPower = 0;
      for (const [index, field] of [[6,'phyAtk'],[7,'magicAtk'],[8,'phyDef'],[9,'magicDef'],[5,'hp'],[4,'speed']]) {
        if (index >= n) continue;
        const off = p + 4 * index, before = blok.readUInt32BE(off);
        const after = Math.min(0x7fffffff, before + Math.round(before * (Number(refinery[field]) || 0)));
        blok.writeUInt32BE(after, off); extraPower += after - before;
      }
      if (n > 26) { const off = p + 4 * 26; blok.writeUInt32BE(Math.min(0x7fffffff, blok.readUInt32BE(off) + extraPower), off); }
    }
    const starFactor=require('./hero-stars').multiplier(durum,heroId);
    if(starFactor>1)for(const index of [0,1,2,3,4,5,6,7,8,9,26]){
      if(index>=n)continue;const off=p+4*index;
      blok.writeUInt32BE(Math.min(0x7fffffff,Math.round(blok.readUInt32BE(off)*starFactor)),off);
    }
    p += 4 * n;
  }
  return Buffer.concat([new Y().u32(heroId).done(), blok]);
}

// ---------- MountedResult yardimcisi ----------
function mountedResult(durum, err, heroId, inst, ek) {
  const w = new Y(); w.u32(err); if (err) return w.done();
  w.u32(heroId);
  if (heroId) w.raw(kayitBufInst(durum, inst));
  else if (ek) ek.ntf(inst);
  return w.done();
}
function bul(durum, heroId, sel) {
  const e = depo(durum);
  if (heroId) { const inst = (e.takili[String(heroId >>> 0)] || {})[String(sel)]; return inst ? { inst: Number(inst), x: e.esyalar[String(inst)] } : null; }
  const x = e.esyalar[String(sel >>> 0)]; return x && !takiliMi(e, sel) ? { inst: sel >>> 0, x } : null;
}
function malzemeParse(datum) { return String(datum || '').split('|').map(s => s.split('_').map(Number)).filter(p => p[0] > 0).map(p => ({ code: p[0], adet: p[1] || 1 })); }

// Shared Hollow Soul state; transactions live in crash-jade.js.
function hog(durum) { return require('./crash-jade').state(durum); }

// ---------- KUR: handler tablosu ----------
function kur(y) {
  const { ekOnce, ekSonra, paraHarca, seviye, W, olay } = y;
  const H = {};
  const harca = (list) => { const p = paraHarca(list); if (p) ekSonra(OP_PARA, p, 'EKIPMAN-para'); return !!p; };
  const gumus = n => n > 0 ? harca([{ type: 0, code: 0, amount: n }]) : true;
  const altin = n => n > 0 ? harca([{ type: 0, code: 1, amount: n }]) : true;
  const ntf = (durum, inst, emit = ekSonra) => { const b = kayitBufInst(durum, inst); if (b) emit(OP_NTF, sendPaketi([b]), 'EKIPMAN-ntf'); };
  const esyaGuncelle = (durum, code, inst, emit = ekSonra) => { try { const g = envanter.guncellemePaketi(durum, code, inst); if (g) emit(g.id, g.payload, 'EKIPMAN-esya'); } catch (e) { } };
  const esyaHarca = (durum, code, adet) => { if (!envanter.dus(durum, code, adet)) return false; esyaGuncelle(durum, code, 0); return true; };
  const esyaVer = (durum, code, adet, emit = ekSonra, insertNew = false) => { try { const missing = envanter.mevcut(durum, code) === 0; const ek = envanter.ekle(durum, [{ code, amount: adet }]); const p = envanter.kazancPaketi(durum, ek); if (p) emit(insertNew && missing ? OP_SEND : OP_NTF, p, 'EKIPMAN-kazanc'); } catch (e) { } };
  const kaydetS = (kaydet, durum) => { try { kaydet(durum); } catch (e) { } };
  const heroLevel = (durum, heroId) => { try { const v = JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')); return (heroId >>> 0) === (seviye.anaId() >>> 0) ? seviye.anaDurum(v).lv : seviye.heroSeviye(durum, heroId, v); } catch (e) { return 1; } };
  const attrPush = (durum, heroId) => { const p = statPaketi(durum, heroId, heroLevel(durum, heroId)); if (p) ekSonra(OP_ATTR, p, 'EKIPMAN-stat'); };
  const hoguAttrPush = (durum, heroIds) => { for (const heroId of new Set(heroIds.filter(id => Number(id) > 0).map(id => Number(id) >>> 0))) attrPush(durum, heroId); };
  const mr = (durum, err, heroId, inst) => mountedResult(durum, err, heroId, inst, { ntf: i => ntf(durum, i) });

  // --- Hero stat (client her degisiklikten sonra sorar) ---
  H['0x01810101'] = ({ payload, durum }) => { const heroId = new O(payload).u32(); const p = statPaketi(durum, heroId, heroLevel(durum, heroId)); return p || null; };
  // --- Tak / Cikar ---
  H['0x01811002'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), inst = o.u32(), tpl = o.u32();
    const e = depo(durum); const x = e.esyalar[String(inst)];
    if (!x || takiliMi(e, inst)) return new Y().u32(4).done();
    const a = article(x.tpl); if (!a) return new Y().u32(4).done();
    const slot = Number(a.minorType) || x.slot; const hk = String(heroId >>> 0);
    e.takili[hk] = e.takili[hk] || {};
    const eski = e.takili[hk][String(slot)];
    e.takili[hk][String(slot)] = inst;
    kaydetS(kaydet, durum);
    ekSonra(OP_REDUCE, reducePaketi([inst]), 'EKIPMAN-tak');
    if (eski && e.esyalar[String(eski)]) ekSonra(OP_SEND, sendPaketi([kayitBufInst(durum, eski)]), 'EKIPMAN-eski');
    if (heroId) attrPush(durum, heroId);
    console.log(`[ekipman] hero ${heroId} slot ${slot} <- ${x.tpl} (${a.name})${eski ? ' (eski cantaya)' : ''}`);
    return new Y().u32(0).u32(heroId).u32(inst).done();
  };
  H['0x01811001'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(); const n = o.u16(); const e = depo(durum); const hk = String(heroId >>> 0);
    const m = e.takili[hk] || {}; const cikan = [], bufs = [];
    for (let i = 0; i < n; i++) { const slot = o.u8(); const inst = m[String(slot)]; if (!inst) continue; cikan.push(slot); bufs.push(kayitBufInst(durum, inst)); delete m[String(slot)]; }
    kaydetS(kaydet, durum);
    if (bufs.length) ekSonra(OP_SEND, sendPaketi(bufs.filter(Boolean)), 'EKIPMAN-cikar');
    if (cikan.length && heroId) attrPush(durum, heroId);
    const w = new Y().u32(0).u32(heroId).u16(cikan.length); for (const s of cikan) w.u8(s); return w.done();
  };
  H['0x01811004'] = ({ payload, durum, kaydet }) => {   // OneKeySwap
    const o = new O(payload); const a = o.u32(), b = o.u32(); const e = depo(durum);
    const ta = e.takili[String(a)] || {}, tb = e.takili[String(b)] || {};
    e.takili[String(a)] = tb; e.takili[String(b)] = ta; kaydetS(kaydet, durum);
    const w = new Y().u32(0).u32(a); const la = takiliKayitlar(durum, a); w.u16(la.length); for (const x of la) w.raw(x);
    w.u32(b); const lb = takiliKayitlar(durum, b); w.u16(lb.length); for (const x of lb) w.raw(x);
    if (a) attrPush(durum, a);
    if (b && b !== a) attrPush(durum, b);
    return w.done();
  };
  // --- Demirci ---
  H['0x01810105'] = ({ payload, durum }) => {
    const o = new O(payload); const n = o.u16(); const e = depo(durum); const w = new Y(); const idx = []; for (let i = 0; i < n; i++) idx.push(o.u8());
    const items = idx.filter(i => i === 6); w.u16(items.length); for (const i of items) w.u8(6).u32(e.cd > simdi() ? e.cd : 0).u32(0).u32(0); return w.done();
  };
  H['0x01810e07'] = ({ durum }) => new Y().u32(0).u32(depo(durum).koruma).done();
  H['0x01810e00'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(), tpl = o.u32(); const n = o.u16(); let boost = 0; for (let i = 0; i < n; i++) { o.i8(); boost++; }
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const a = article(r.x.tpl); const q = Number(a.quality) || 1, L = r.x.lvl || 0;
    if (L >= MAX_LV) return new Y().u32(101).done();
    const cat2 = Number(a.minorType);
    if (r.x.kat === 2 && !buildValue(cat2, q, L + 1)) return new Y().u32(101).done();
    const bc = buildConsume(q, L); const bedel = bc ? Number(bc.consume) || 0 : 0;
    if (!gumus(bedel)) return new Y().u32(13).done();
    if (boost && !altin(10 * boost)) return new Y().u32(16).done();
    let art = 1; if (boost && Math.random() < 0.25 && buildValue(cat2, q, L + 2)) art = 2;
    r.x.lvl = Math.min(MAX_LV, L + art); const e = depo(durum); e.cd = 0; kaydetS(kaydet, durum);
    console.log(`[demirci] ${a.name} +${L}->+${r.x.lvl} (-${bedel} gumus)`);
    const w = new Y().u32(0).u16(r.x.lvl).u32(0).u8(0).u32(heroId); if (heroId) w.raw(kayitBufInst(durum, r.inst)); else ntf(durum, r.inst);
    if (heroId) attrPush(durum, heroId);
    // oyun-sunucu records and saves fortifyEquip after this successful response.
    return w.done();
  };
  H['0x01810e01'] = ({ payload, durum, kaydet }) => {   // Refine: aday listeleri
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(), tpl = o.u32(); const tip = o.i8(); const adet = Math.max(1, Math.min(10, o.i8() || 1));
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const a = article(r.x.tpl); const be = beCoz(r.x.tpl); const k = Math.max(1, be ? be.maxApp : 1);
    const maliyet = [{ type: 0, code: 0, amount: (Number(a.sellPrice) || 0) * 3 * adet }];
    if (tip !== 0) maliyet.push({ type: 0, code: 1, amount: cv(60106018, 5) * adet });
    // Refine always costs silver; special activity also costs gold. Charge both together so
    // paraHarca can validate every balance before deducting any of them.
    if (!harca(maliyet)) {
      const kod = typeof y.paraEksik === 'function' ? y.paraEksik(maliyet) : (tip === 0 ? 13 : 16);
      return new Y().u32(kod || (tip === 0 ? 13 : 16)).done();
    }
    const lvl = Number(a.level) || 1; const havuz = tablo('EquipAdditional').liste.map(x => equipAdditional(x._id)).filter(x => x && x.cat);
    const seviyeler = [...new Set(havuz.map(x => x.lvl))].sort((p, q2) => p - q2); let sv = seviyeler[0]; for (const s of seviyeler) if (s <= lvl) sv = s;
    const uygun = havuz.filter(x => x.lvl === sv); const listeler = [];
    for (let i = 0; i < adet; i++) { const l = []; const kul = new Set(); for (let j = 0; j < k && uygun.length; j++) { let d = sec(uygun); let t = 0; while (kul.has(d.cat) && t++ < 10) d = sec(uygun); kul.add(d.cat); l.push([d.id, d.cat, d.min + rnd(Math.max(1, d.max - d.min + 1))]); } listeler.push(l); }
    depo(durum).adaylar[String(r.inst)] = listeler; kaydetS(kaydet, durum);
    const w = new Y().u32(0).u32(0).u16(listeler.length); for (const l of listeler) { w.u16(l.length); for (const x of l) w.u32(x[0]).u32(x[1]).u16(x[2]); } return w.done();
  };
  H['0x01810e03'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); o.u32(); const idx = o.u16();
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const l = (depo(durum).adaylar[String(r.inst)] || [])[idx]; if (!l) return new Y().u32(1).done();
    r.x.app = l; delete depo(durum).adaylar[String(r.inst)]; kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId);
    return mr(durum, 0, heroId, r.inst);
  };
  H['0x01810e02'] = ({ payload, durum, kaydet }) => {   // Inherit
    const o = new O(payload); const hA = o.u32(), sA = o.u32(); o.u32(); const hB = o.u32(), sB = o.u32(); o.u32(); const gemsDe = o.i8();
    const A = bul(durum, hA, sA), B = bul(durum, hB, sB); if (!A || !B || A.inst === B.inst) return new Y().u32(4).done();
    const aB = article(B.x.tpl); const q = Number(aB.quality) || 1; let L = A.x.lvl || 0;
    if (B.x.kat === 2) { while (L > 0 && !buildValue(Number(aB.minorType), q, L)) L--; }
    B.x.lvl = L; A.x.lvl = 0; if (gemsDe) { B.x.gems = [...(B.x.gems || []), ...(A.x.gems || [])].slice(0, 8); A.x.gems = []; }
    kaydetS(kaydet, durum);
    const w = new Y().u32(0).u32(hA).raw(kayitBufInst(durum, A.inst)).u32(hB); if (hB) w.raw(kayitBufInst(durum, B.inst)); else ntf(durum, B.inst); if (!hA) ntf(durum, A.inst);
    if (hA) attrPush(durum, hA); if (hB && hB !== hA) attrPush(durum, hB);
    return w.done();
  };
  H['0x01810e04'] = ({ durum, kaydet }) => { depo(durum).cd = 0; kaydetS(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01810e05'] = ({ payload, durum, kaydet }) => {   // Advanced
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const up = satir('EquipUpgrade', r.x.tpl); if (!up || !article(Number(up.gotEquipId)) || !baseEquip(Number(up.gotEquipId))) return new Y().u32(1).done();
    for (const m of malzemeParse(up.datum)) { if (envanter.mevcut(durum, m.code) < m.adet) return new Y().u32(18).done(); }
    for (const m of malzemeParse(up.datum)) esyaHarca(durum, m.code, m.adet);
    const yeniA = article(Number(up.gotEquipId)); r.x.tpl = Number(up.gotEquipId); r.x.slot = Number(yeniA.minorType) || r.x.slot;
    const q = Number(yeniA.quality) || 1; while (r.x.lvl > 0 && r.x.kat === 2 && !buildValue(Number(yeniA.minorType), q, r.x.lvl)) r.x.lvl--;
    kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId);
    return mr(durum, 0, heroId, r.inst);
  };
  H['0x01810e06'] = ({ payload, durum, kaydet }) => {   // GetSkill
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); o.u32(); const stInst = o.u32(), stTpl = o.u32();
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const ms = satir('MagicStone', stTpl); if (!ms) return new Y().u32(4).done();
    if (!esyaHarca(durum, stTpl, 1)) return new Y().u32(18).done();
    const f = json(ms.func, []).filter(x => satir('WeaponSkillConfig', Number(x.weaponSkillid)));
    if (f.length) { const top = f.reduce((s, x) => s + (Number(x.rate) || 1), 0); let z = Math.random() * top; let secim = f[0]; for (const x of f) { z -= Number(x.rate) || 1; if (z <= 0) { secim = x; break; } } r.x.ws = Number(secim.weaponSkillid); }
    kaydetS(kaydet, durum); return mr(durum, 0, heroId, r.inst);
  };
  H['0x01810e08'] = ({ payload, durum, kaydet }) => {   // koruma tasi al
    const id = new O(payload).u32(); const mapLv = Math.floor(id / 1000); const band = bandIndex(mapLv); const fiyat = (cv(60340009, [50]))[band] || 50;
    if (!altin(fiyat)) return new Y().u32(16).done();
    const e = depo(durum); e.koruma |= (1 << band); kaydetS(kaydet, durum); return new Y().u32(0).u32(e.koruma).done();
  };
  H['0x01810e09'] = ({ payload, durum, kaydet }) => {   // Flush spirit
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const a = article(r.x.tpl); const be = beCoz(r.x.tpl); if (!be || !be.flushK) return new Y().u32(425).done();
    const mapLv = mapLvOf(Number(a.level) || 1); const tv = satir('TempleValue', mapLv * 1000 + Number(a.minorType) * 100 + (r.x.fl + 1)); if (!tv) return new Y().u32(425).done();
    const taslar = json(tv.protectedStone, []); const adet = Number(tv.flushSpiritConsume) || 1; let ok = false;
    for (const t of taslar) if (envanter.mevcut(durum, t) >= adet) { esyaHarca(durum, t, adet); ok = true; break; }
    if (!ok) return new Y().u32(18).done();
    const e = depo(durum); const band = bandIndex(mapLv); let basari = Math.random() * 1000 < (Number(tv.flushSpiritSuccessrate) || 500);
    if (e.koruma & (1 << band)) { basari = true; e.koruma &= ~(1 << band); }
    if (!basari) { kaydetS(kaydet, durum); return new Y().u32(0).u32(1).done(); }
    r.x.fl += 1; kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId);
    const w = new Y().u32(0).u32(0).u32(heroId); if (heroId) w.raw(kayitBufInst(durum, r.inst)); else ntf(durum, r.inst); return w.done();
  };
  H['0x01810e10'] = ({ payload, durum, kaydet }) => {   // Punch: heroId, tpl, sel
    const o = new O(payload); const heroId = o.u32(); o.u32(); const sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const be = beCoz(r.x.tpl); if (!be || (r.x.hole || 0) >= be.drillHoleNum) return new Y().u32(1).done();
    const a = article(r.x.tpl); const lv = Number(a.level) || 1; const punchLv = lv <= 69 ? 69 : lv <= 89 ? 89 : lv <= 119 ? 119 : lv <= 139 ? 139 : 179;
    const dc = satir('DrillHoleCost', punchLv * 1000 + (r.x.hole + 1)); if (dc) { if (!gumus(Number(dc.drillCostMoney) || 0)) return new Y().u32(13).done(); const its = json(dc.costItemNum, []); const n = Number(dc.f4) || 0; for (const it of its) if (n && envanter.mevcut(durum, it) >= n) { esyaHarca(durum, it, n); break; } }
    r.x.hole = (r.x.hole || 0) + 1; kaydetS(kaydet, durum); return mr(durum, 0, heroId, r.inst);
  };
  H['0x01810d00'] = ({ payload, durum, kaydet }) => {   // Equip_Make
    const tpl = new O(payload).u32(); const g = satir('EquipGenerate', tpl); if (!g || !article(tpl) || !baseEquip(tpl)) return new Y().u32(4).done();
    const mal = malzemeParse(g.datum); for (const m of mal) if (envanter.mevcut(durum, m.code) < m.adet) return new Y().u32(18).done();
    if (!gumus(Number(g.cost) || 0)) return new Y().u32(13).done();
    for (const m of mal) esyaHarca(durum, m.code, m.adet);
    const e = depo(durum); const inst = yeniEsya(e, tpl, 0);
    olay.say(durum, 'fortifyEquip', 1);
    kaydetS(kaydet, durum);
    ekSonra(OP_SEND, sendPaketi([kayitBufInst(durum, inst)]), 'EKIPMAN-uretim'); console.log(`[demirci] uretildi ${article(tpl).name}`);
    return new Y().u32(0).done();
  };
  // --- Yesim ---
  const gemSonraki = tpl => { const stone=baseStone(tpl),next=stone&&Number(stone.nextId);return next&&baseStone(next)&&Number(article(next)?.majorType)===3?next:0; };
  H['0x01811100'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const mode = o.i8(); o.u32(); const gTpl = o.u32(); const count = o.u16(); const lvl = o.i8();
    const birlestir = (tpl, n) => {
      if(Number(article(tpl)?.majorType)!==3||!baseStone(tpl))return 0;
      const nx = gemSonraki(tpl);
      if (!nx || !n || envanter.mevcut(durum, tpl) < 2 * n) return 0;
      const trial=structuredClone(durum),before=envanter.mevcut(trial,nx);
      envanter.dus(trial, tpl, 2 * n);
      const ek = envanter.ekle(trial, [{ code: nx, amount: n }]);
      if(envanter.mevcut(trial,nx)!==before+n)return 0;
      durum.envanter=trial.envanter;
      const g = envanter.guncellemePaketi(durum, tpl, envanter.instanceOf(tpl));
      if (g) ekOnce(g.id, g.payload, 'YESIM-esya');
      const p = envanter.kazancPaketi(durum, ek);
      if (p) ekOnce(OP_NTF, p, 'YESIM');
      return n;
    };
    let synthesized = 0;
    if (mode === 0) { if(count<1||count>32767)return new Y().u8(1).done();synthesized = birlestir(gTpl, count); }
    else if(mode===1) { const hedef = count || lvl;if(hedef<1||hedef>12)return new Y().u8(1).done();for (const x of envanter.liste(durum)) { if (x.kategori !== 3) continue; let tpl = x.code; let a = article(tpl); while (a && Number(a.level) < hedef) { const n = Math.floor(envanter.mevcut(durum, tpl) / 2); if (!n) break; const made = birlestir(tpl, n); if (!made) break; synthesized += made; tpl = gemSonraki(tpl); a = article(tpl); } } }
    else return new Y().u8(1).done();
    if (!synthesized) return new Y().u8(1).done();
    if (olay && typeof olay.say === 'function') olay.say(durum, 'gemSynth', 1);
    kaydetS(kaydet, durum);
    ekOnce(0x01180f00, envanter.loadBagPaketi(durum), 'YESIM-canta-yenile');
    return new Y().u8(0).done();
  };
  H['0x01811101'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); o.u32(); const gInst = o.u32(), gTpl = o.u32();
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const be = beCoz(r.x.tpl); const ga = article(gTpl); if (!be || !ga || Number(ga.majorType) !== 3 || !baseStone(gTpl)) return new Y().u32(4).done();
    const kapasite = (be.holeCount > 100 ? 0 : be.holeCount) + (r.x.hole || 0);
    if ((r.x.gems || []).length >= kapasite) return new Y().u32(1).done();
    if ((r.x.gems || []).some(g => { const x = article(g); return x && Number(x.minorType) === Number(ga.minorType); })) return new Y().u32(452).done();
    if (!envanter.dus(durum, gTpl, 1)) return new Y().u32(18).done();
    r.x.gems = [...(r.x.gems || []), gTpl]; kaydetS(kaydet, durum);
    // Jade redraws on the result packet: update its inventory model before that packet.
    esyaGuncelle(durum, gTpl, gInst, ekOnce);
    if (heroId) attrPush(durum, heroId);
    return mountedResult(durum, 0, heroId, r.inst, { ntf: i => ntf(durum, i, ekOnce) });
  };
  H['0x01811102'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); o.u32(); o.i8(); const gTpl = o.u32();
    const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const i = (r.x.gems || []).indexOf(gTpl); if (i < 0) return new Y().u32(4).done();
    // InventoryNtf only assigns existing client entries; SendThings inserts a missing stack.
    r.x.gems.splice(i, 1); esyaVer(durum, gTpl, 1, ekOnce, true); kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId);
    return mountedResult(durum, 0, heroId, r.inst, { ntf: i => ntf(durum, i, ekOnce) });
  };
  // --- Tilsim (hazine) ---
  H['0x01811301'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const L = r.x.lvl || 0; const tu = treasureUp(r.x.tpl, L + 1); if (!tu) return new Y().u32(101).done();
    const a = article(r.x.tpl); const lv100 = (Number(a.level) || 0) >= 100;
    if (lv100) { const n = Number(tu.f6) || 0; if (n && !esyaHarca(durum, 14100782, n)) { if (!altin(n * (Number(tu.productCount) || 1))) return new Y().u32(18).done(); } }
    else { const n = Number(tu.costItemCount) || 0; if (n) { let kalan = n; const ayni = KANCA.mevcut(durum, r.x.tpl); const kul = Math.min(kalan, ayni); if (kul) { KANCA.dus(durum, r.x.tpl, kul); kalan -= kul; } const tal = Math.min(kalan, envanter.mevcut(durum, 14100019)); if (tal) { esyaHarca(durum, 14100019, tal); kalan -= tal; } if (kalan && !altin(kalan * (Number(tu.productCount) || 10))) return new Y().u32(18).done(); } }
    r.x.lvl = L + 1; kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId);
    return mr(durum, 0, heroId, r.inst);
  };
  H['0x01811302'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const inst = o.u32(); o.u32(); const dst = o.u32(); const x = esya(durum, inst); if (!x || !article(dst) || !baseEquip(dst)) return new Y().u32(4).done();
    if (!esyaHarca(durum, 14100020, 1)) return new Y().u32(18).done();
    ekSonra(OP_REDUCE, reducePaketi([inst]), 'TILSIM'); x.tpl = dst; x.slot = Number(article(dst).minorType) || x.slot; while (x.lvl > 0 && !treasureUp(dst, x.lvl)) x.lvl--; kaydetS(kaydet, durum);
    ekSonra(OP_SEND, sendPaketi([kayitBufInst(durum, inst)]), 'TILSIM'); return new Y().u32(0).done();
  };
  H['0x01811303'] = ({ payload, durum, kaydet }) => {
    const inst = new O(payload).u32(); const x = esya(durum, inst); if (!x) return new Y().u32(4).done();
    const tl = satir('TreasureLevelup', x.tpl + (x.lvl || 0) * 100) || satir('TreasureLevelup', x.tpl); if (!tl || !article(Number(tl.upItem))) return new Y().u32(1).done();
    if (!altin(Number(tl.needGold) || 0)) return new Y().u32(16).done();
    x.tpl = Number(tl.upItem); kaydetS(kaydet, durum); ntf(durum, inst); return new Y().u32(0).done();
  };
  H['0x01816e00'] = ({ payload, durum, kaydet }) => {   // TreasureAwake_LevelUp (ayni tablo)
    const o = new O(payload); const tpl = o.u32(), inst = o.u32(); const x = esya(durum, inst); if (!x) return new Y().u32(4).done();
    const tl = satir('TreasureLevelup', tpl + (x.lvl || 0) * 100); if (!tl || !article(Number(tl.upItem))) return new Y().u32(1).done();
    if (!altin(Number(tl.needGold) || 0)) return new Y().u32(16).done();
    x.tpl = Number(tl.upItem); kaydetS(kaydet, durum); ekSonra(OP_REDUCE, reducePaketi([inst]), 'TILSIM'); ekSonra(OP_SEND, sendPaketi([kayitBufInst(durum, inst)]), 'TILSIM'); return new Y().u32(0).done();
  };
  H['0x01811304'] = ({ payload, durum, kaydet }) => {   // Product: ayristir
    const o = new O(payload); const n = o.u16(); let toplam = 0; const insts = [];
    for (let i = 0; i < n; i++) { const inst = o.u32(); o.u32(); const x = esya(durum, inst); if (!x || takiliMi(depo(durum), inst)) continue; const tu = treasureUp(x.tpl, x.lvl || 0); toplam += tu ? Number(tu.productCount) || 0 : 10; delete depo(durum).esyalar[String(inst)]; insts.push(inst); }
    if (insts.length) { ekSonra(OP_REDUCE, reducePaketi(insts), 'TILSIM'); esyaVer(durum, 14100782, Math.max(1, toplam)); }
    kaydetS(kaydet, durum); return new Y().u32(0).done();
  };
  // --- Sus ---
  H['0x01816400'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const L = r.x.lvl || 0; if (L >= 100) return new Y().u32(101).done(); const ov = ornamentValue(r.x.tpl, L + 1); if (!ov) return new Y().u32(101).done();
    const cost = json(ov.f2, []); for (const c of cost) { const code = Number(c.code) || 0; if (Number(c.type) === 1 && code && envanter.mevcut(durum, code) < (Number(c.amount) || 1)) return new Y().u32(18).done(); }
    for (const c of cost) { if (Number(c.type) === 1) esyaHarca(durum, Number(c.code), Number(c.amount) || 1); else if (Number(c.type) === 0 && Number(c.code) === 0) gumus(Number(c.amount) || 0); }
    r.x.lvl = L + 1; kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId); return mr(durum, 0, heroId, r.inst);
  };
  H['0x01816401'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), sel = o.u32(); const r = bul(durum, heroId, sel); if (!r) return new Y().u32(4).done();
    const ou = satir('OrnamentUpgrade', r.x.tpl); if (!ou || !article(Number(ou.f2)) || !baseEquip(Number(ou.f2))) return new Y().u32(1).done();
    const cost = json(ou.newItemID, []); for (const c of cost) if (Number(c.type) === 1 && envanter.mevcut(durum, Number(c.code)) < (Number(c.amount) || 1)) return new Y().u32(18).done();
    for (const c of cost) if (Number(c.type) === 1) esyaHarca(durum, Number(c.code), Number(c.amount) || 1);
    r.x.tpl = Number(ou.f2); kaydetS(kaydet, durum); if (heroId) attrPush(durum, heroId); return mr(durum, 0, heroId, r.inst);
  };
  // --- Uyanis ---
  const uy = (durum, id) => { durum.uyanis = durum.uyanis || {}; const k = String(id >>> 0); durum.uyanis[k] = durum.uyanis[k] || { lv: 0, status: 0 }; return durum.uyanis[k]; };
  H['0x01811008'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const heroId = o.u32(), slot = o.u32(); const u = uy(durum, heroId);
    const wr = satir('WakeUp', heroId); const gerekli = wr ? ((json(wr.f0, [])[u.lv] || [])[slot] || 0) : 0;
    if (gerekli && envanter.mevcut(durum, gerekli) > 0) esyaHarca(durum, gerekli, 1);
    u.status |= (1 << slot); kaydetS(kaydet, durum); return new Y().u32(0).u32(heroId).u32(u.status).done();
  };
  H['0x01811009'] = ({ payload, durum, kaydet }) => { const heroId = new O(payload).u32(); const u = uy(durum, heroId); const wr = satir('WakeUp', heroId); const max = wr ? json(wr.f0, []).length : 1; if (u.lv + 1 >= max) return new Y().u32(1).done(); u.lv += 1; u.status = 0; kaydetS(kaydet, durum); attrPush(durum, heroId); return new Y().u32(0).u32(heroId).u32(u.lv).done(); };
  H['0x01811007'] = ({ payload, durum, kaydet }) => {
    const tpl = new O(payload).u32(); const we = satir('WakeUpEquip', tpl); if (!we || !article(tpl)) return new Y().u32(4).done();
    const comp = json(we.f2, []); for (const c of comp) if (Number(c.type) === 1 && envanter.mevcut(durum, Number(c.code)) < (Number(c.amount) || 1)) return new Y().u32(18).done();
    for (const c of comp) if (Number(c.type) === 1) esyaHarca(durum, Number(c.code), Number(c.amount) || 1);
    if (!gumus(Number(we.f3) || 0)) return new Y().u32(13).done();
    esyaVer(durum, tpl, 1); kaydetS(kaydet, durum); return new Y().u32(0).u32(tpl).done();
  };
  H['0x0181100a'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const tip = o.i32(), id = o.i32(), pos = o.i32(); durum.liderUyanis = durum.liderUyanis || {};
    const lw = satir('LeaderWakeUp', id); const w = new Y().u32(0).i32(tip).i32(id);
    if (tip === 0 && lw && lw.nextID) { const fiyat = json(lw.upLevelPriceStr, []); for (const c of fiyat) if (Number(c.type) === 1 && envanter.mevcut(durum, Number(c.code)) >= (Number(c.amount) || 1)) esyaHarca(durum, Number(c.code), Number(c.amount) || 1); durum.liderUyanis[String(pos)] = { id: Number(lw.nextID), str: 0 }; }
    else if (tip === 1) { const s = durum.liderUyanis[String(pos)] || { id, str: 0 }; s.str = Math.min((lw ? Number(lw.maxStr) : 99) || 99, (s.str || 0) + 1); durum.liderUyanis[String(pos)] = s; }
    kaydetS(kaydet, durum); w.u16(0); return w.done();
  };
  // Native Hollow Soul King / CrashJade transactions and immediate stats.
  Object.assign(H, require('./crash-jade').kur(y,{statPush:attrPush}).handlers);
  // --- Ekipman Ocagi (UltimateEquip) ---
  const forge = durum => { durum.ocak = durum.ocak || { enerji: 10, satin: 3, is: 0, hazir: 0 }; const f = durum.ocak; const g = require('./paket').gun(); if (f.gun !== g) { f.gun = g; f.satin = 3; f.enerji = Math.max(f.enerji, 10); } return f; };
  H['0x01818c00'] = ({ durum }) => { const f = forge(durum); return new Y().u32(0).u32(f.enerji).u32(f.satin).u32(f.is).u32(f.hazir).done(); };
  H['0x01818c01'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tpl = o.u32(), inst = o.u32(); const ef = satir('EquipForge', tpl); const x = esya(durum, inst); if (!ef || !x || takiliMi(depo(durum), inst)) return new Y().u32(4).done(); delete depo(durum).esyalar[String(inst)]; ekSonra(OP_REDUCE, reducePaketi([inst]), 'OCAK'); esyaVer(durum, Number(ef.itemId), Math.max(1, Number(ef.retCount) || 1)); kaydetS(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01818c02'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tpl = o.u32(), inst = o.u32(); const ea = satir('EquipAdvance', tpl); const x = esya(durum, inst); if (!ea || !x || !article(Number(ea.itemId))) return new Y().u32(4).done(); const n = Number(ea.needCount) || 0; if (n && !esyaHarca(durum, 14100723, n)) return new Y().u32(18).done(); x.tpl = Number(ea.itemId); kaydetS(kaydet, durum); ntf(durum, inst); return new Y().u32(0).done(); };
  H['0x01818c03'] = ({ durum, kaydet }) => { const f = forge(durum); if (f.enerji < 1) return new Y().u32(1).done(); f.enerji -= 1; f.is = simdi() + 600; kaydetS(kaydet, durum); return new Y().u32(0).u32(f.enerji).u32(f.is).u32(f.hazir).done(); };
  H['0x01818c04'] = ({ durum, kaydet }) => { const f = forge(durum); if (f.satin < 1) return new Y().u32(1).done(); if (!altin(cv(62100005, 50))) return new Y().u32(16).done(); f.satin -= 1; f.enerji += cv(62100006, 60); kaydetS(kaydet, durum); return new Y().u32(0).u32(f.enerji).u32(f.satin).done(); };
  H['0x01818c05'] = ({ durum, kaydet }) => { const f = forge(durum); if (!f.is) return new Y().u32(1).done(); if (f.is > simdi() && !altin(cv(62100007, 20))) return new Y().u32(16).done(); f.is = 0; f.hazir += 1; kaydetS(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01818c06'] = ({ durum, kaydet }) => { const f = forge(durum); if (f.hazir < 1) return new Y().u32(1).done(); f.hazir -= 1; const aw = y.awardOf ? y.awardOf(cv(62100003, 23200001), 0) : [{ type: 1, code: 14100723, amount: 5 }]; y.odulVer(durum, aw); kaydetS(kaydet, durum); const w = new Y().u32(0).u32(f.hazir); w.odul(aw.filter(a => [1, 17, 21, 23].includes(a.type) ? article(a.code) : envanter.odulTemplate(a.type, a.code))); return w.done(); };
  // --- Depo -> canta (gecici canta yok) ---
  H['0x01810f07'] = () => new Y().u32(0).done();
  H['0x01810204'] = () => false;   // Enter_Jade: client hic gondermez

  return H;
}

module.exports = { kur, depo, yeniEsya, esya, kayitBuf, kayitBufInst, kayitlariOku, cantaKayitlari, takiliKayitlar, charYama, statPaketi, bonuslar, hogyokuBonuses, sendPaketi, reducePaketi, KANCA, hog, takiliMi, EKIPMAN_KAT };
