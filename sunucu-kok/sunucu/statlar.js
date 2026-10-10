'use strict';
// KARAKTER STAT BLOKLARI — tek kaynak.
// Hem char paketi enjeksiyonu (herolar.js) hem savas motoru (savas.js) buradan beslenir;
// ikisi ayri formul kullanirsa client'in gosterdigi stat ile savastaki hasar birbirini tutmaz.
//
// BaseAttributes yerlesimi: CONST_COMMON.BASEATTRIBUTEINDEX_* (27 slot)
// Tip vektoru CONST_COMMON.BASSATTRIBUTENUMTYPE: 0 = int(u32), 1 = float(f32)
const fs = require('fs');
const path = require('path');

const TIP = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0];
const IDX = {
  Power: 0, Intelligence: 1, Agile: 2, Life: 3, Speed: 4, Health: 5, PhysicalAttack: 6,
  MagicAttack: 7, PhysicalDefends: 8, MagicDefends: 9, Hit: 10, Dodge: 11, Crit: 12,
  Punch: 14, Help: 15, Hurt: 18, StartAnger: 20, FightingPower: 26,
};
// Karakterle birlikte buyuyen slotlar. Speed(4) ve StartAnger(20) sabit kalir (oyun mekanigi),
// oran alanlari (float) HIC DOKUNULMAZ -> blogun yapisi/boyu birebir korunur, client kirilmaz.
const OLCEKLI = [0, 1, 2, 3, 5, 6, 7, 8, 9, 26];

const VJ = path.join(__dirname, '..', 'cikarim', 'veri-json');
let BaseHero = [];
try { BaseHero = JSON.parse(fs.readFileSync(path.join(VJ, 'BaseHero.json'), 'utf8')); } catch (e) { }
const heroById = new Map(BaseHero.map(h => [parseInt(h.id, 16) >>> 0, h]));

let KnifeSoul = null;
let SpiritSchool = null;
function knifeSoulBonuses(durum) {
  if (!KnifeSoul) {
    try { KnifeSoul = JSON.parse(fs.readFileSync(path.join(VJ, 'KnifeSoul.json'), 'utf8')); }
    catch (e) { KnifeSoul = []; }
    KnifeSoul = new Map(KnifeSoul.map(r => [parseInt(r.id, 16) >>> 0, r]));
  }
  const soul = durum && durum.knifeSoul;
  const id = soul && Number(soul.id) >>> 0;
  const row = KnifeSoul.get(id) || KnifeSoul.get(18100001);
  return row ? {
    power: Number(row.power) || 0,
    intelligence: Number(row.intelligence) || 0,
    agile: Number(row.agile) || 0,
    life: Number(row.life) || 0,
  } : { power: 0, intelligence: 0, agile: 0, life: 0 };
}

function spiritSchoolBonuses(durum) {
  if (!SpiritSchool) {
    SpiritSchool = { byId: new Map(), byType: new Map() };
    try {
      const rows = JSON.parse(fs.readFileSync(path.join(VJ, 'SpiritSchoolExp.json'), 'utf8'));
      for (const row of rows) {
        const id = parseInt(row.id, 16) >>> 0;
        const effect = typeof row.f5 === 'string' ? JSON.parse(row.f5) : row.f5;
        const type = Number(effect && effect.addType) || 0;
        const level = Number(row.monsterLevel);
        if (!id || !type || !Number.isFinite(level)) continue;
        SpiritSchool.byId.set(id, level);
        if (!SpiritSchool.byType.has(type)) SpiritSchool.byType.set(type, new Map());
        SpiritSchool.byType.get(type).set(level, Number(effect.addValue) || 0);
      }
    } catch (e) {
      SpiritSchool = { byId: new Map(), byType: new Map() };
    }
  }
  const level = SpiritSchool.byId.get(Number(durum && durum.spiritSchool && durum.spiritSchool.expId) >>> 0);
  if (level === undefined) return {};
  const bonuses = {};
  for (const [type, values] of SpiritSchool.byType) {
    const value = values.get(level) || 0;
    if (value) bonuses[type] = value;
  }
  return bonuses;
}

// Olcek = heronun hedef seviyedeki gucu / ana heronun YAKALAMA seviyesindeki gucu.
// Yakalanan attribute blogu ana heronun o anki gercek statlari oldugu icin taban budur;
// ana heronun kendisi de (yakalama seviyesi -> guncel level) ayni formulle buyur.
function olcek(heroId, lv, anaId, anaLv) {
  return olcekler(heroId, lv, anaId, anaLv).genel;
}

function olcekler(heroId, lv, anaId, anaLv, durum = null) {
  const quality = Number(durum && durum.meyhane && durum.meyhane.kalite && durum.meyhane.kalite[String(heroId)]) || 0;
  return require('./seviye').statCarpanlari(heroId, lv || 1, anaId, anaLv || 1, quality);
}

// Attribute blogunu olcekle. Uzunluk ve alan sayisi DEGISMEZ, sadece OLCEKLI int slotlari.
function blokOlcekle(blok, k) {
  const oran = typeof k === 'number'
    ? { genel: k, power: k, agile: k, intelligence: k, life: k }
    : (k || { genel: 1, power: 1, agile: 1, intelligence: 1, life: 1 });
  const b = Buffer.from(blok);
  let p = 0;
  for (let no = 0; no < 2; no++) {                 // BaseAttributes, PvPAttributes
    if (p + 2 > b.length) return b;
    const n = b.readUInt16BE(p); p += 2;
    if (p + 4 * n > b.length) return b;
    for (const i of OLCEKLI) {
      if (i >= n || TIP[i] === 1) continue;
      const factor = i === IDX.Power ? oran.power
        : i === IDX.Intelligence ? oran.intelligence
          : i === IDX.Agile ? oran.agile
            : i === IDX.Life || i === IDX.Health ? oran.life
              : oran.genel;
      if (!(factor > 0) || Math.abs(factor - 1) < 1e-6) continue;
      const v = b.readUInt32BE(p + 4 * i);
      b.writeUInt32BE(Math.max(1, Math.min(0x7fffffff, Math.round(v * factor))) >>> 0, p + 4 * i);
    }
    p += 4 * n;
  }
  return b;
}

// Bloktan savas icin gereken sayilari oku
function blokOku(blok) {
  try {
    if (!blok || blok.length < 2) return null;
    const n = blok.readUInt16BE(0);
    if (!(n > 0) || 2 + 4 * n > blok.length) return null;
    const v = i => (i >= n ? 0 : (TIP[i] === 1 ? blok.readFloatBE(2 + 4 * i) : blok.readUInt32BE(2 + 4 * i)));
    const s = {
      hp: Math.round(v(IDX.Health)),
      atk: Math.round(Math.max(v(IDX.PhysicalAttack), v(IDX.MagicAttack))),
      def: Math.round(Math.max(v(IDX.PhysicalDefends), v(IDX.MagicDefends))),
      speed: Math.max(0, Math.round(v(IDX.Speed))),
      anger: Math.round(v(IDX.StartAnger)) || 50,
      guc: Math.round(v(IDX.FightingPower)),
    };
    return (s.hp > 0 && s.atk > 0) ? s : null;
  } catch (e) { return null; }
}

// Attribute blogunun giris icindeki [bas, son) araligi (TUnstreamizerCharacter hero girisi)
function attrAralik(b, start) {
  let p = start;
  p += 16;                       // id, RebirthLevel, ExpHi, ExpLo
  p += 2;                        // Profession, FightPosition
  p += 4;                        // ChangeSchedule
  const advN = b.readInt16BE(p); p += 2; p += 9 * Math.max(0, advN);
  p += 32;                       // HeroOverTime..RelatedPartnerPos
  p += 3;                        // RebirthNum, PropPower, AttackEffect
  p += 4;                        // HistoryMaxLevel
  p += 1;                        // AddQuality
  p += 2;                        // atlanan u16
  p += 5;                        // Skill (u32 id + u8 unlock)
  const bas = p;
  const nB = b.readUInt16BE(p); p += 2 + 4 * nB;   // BaseAttributes
  const nP = b.readUInt16BE(p); p += 2 + 4 * nP;   // PvPAttributes
  p += 2 + 16 + 2 + 16;                            // GrowRate
  return [bas, p];
}

// YAKALANAN char paketinden ana hero: id, FightPosition, YAKALAMA seviyesi ve ham blok.
// (Yamalanmamis dosyadan okunur -> level alani gercek degerdir, 99 degil.)
// ANA HERO ID GECERSIZ KILMA: oyuncu karakter yaratma ekraninda baska bir protagonist secerse
// (karakter.js) id buradan degisir; stat blogu/yakalama seviyesi yakalanan hero'dan kalir
// (blok jenerik, herolar.js de partnerlere ayni blogu olcekleyerek veriyor).
let _ana;
let ANA_OVERRIDE = 0;
function anaIdAyarla(id) { ANA_OVERRIDE = (Number(id) >>> 0) || 0; }
function anaKaynak() {
  const k = anaKaynakHam();
  if (k && ANA_OVERRIDE && ANA_OVERRIDE !== k.id) return { ...k, id: ANA_OVERRIDE, yakalananId: k.id };
  return k;
}
function anaKaynakHam() {
  if (_ana !== undefined) return _ana;
  try {
    const harita = require('./harita');
    const TL = path.join(__dirname, 'zaman');
    const tl = JSON.parse(fs.readFileSync(path.join(TL, 'timeline.json'), 'utf8'));
    const e0 = tl.find(x => x.dir === 's2c' && /01180102/i.test(String(x.id)));
    const b = fs.readFileSync(path.join(TL, e0.file));
    const s = harita.basicEnd(b) + 2;
    const [bas, son] = attrAralik(b, s);
    _ana = {
      id: b.readUInt32BE(s),
      lv: b.readUInt32BE(s + 4) || 1,
      pos: b[s + 17] || 6,
      blok: Buffer.from(b.subarray(bas, son)),
    };
  } catch (e) { _ana = null; }
  return _ana;
}

module.exports = { TIP, IDX, OLCEKLI, olcek, olcekler, blokOlcekle, blokOku, attrAralik, anaKaynak, anaKaynakHam, anaIdAyarla, heroById, knifeSoulBonuses, spiritSchoolBonuses };
