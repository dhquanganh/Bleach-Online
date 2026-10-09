'use strict';
// Char paketine TUM karakterleri ekler (tumKarakterler).
// Hero girisi formati TUnstreamizerCharacter.UnstreamizationPerform_HeroProperties'ten BIREBIR.
//
// NEDEN ESKIDEN PATLIYORDU: eski kod girisin sonunu sabit (HERO_ENTRY_E=510) varsayiyordu.
// Gercek son 570 (olculdu). Giris uzunlugu DEGISKEN: attribute sayisi + takili ekipman sayisi/
// appendAttribute sayisi ile degisiyor. Sabit offset -> paketin kuyrugu kayiyor -> client char
// paketini parse edemiyor, login sonrasi hic istek atmiyordu (sessiz kirilma).
// Cozum: girisi gercekten YURUYUP sonunu hesapla, ek herolari ana girisin ARKASINA ekle
// (ana hero index 0'da kalmali: TCharacter.MainHero = GetHeroByIndex(0)).
const fs = require('fs');
const path = require('path');
const statlar = require('./statlar');
const V = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jload = f => { try { return JSON.parse(fs.readFileSync(path.join(V, f), 'utf8')); } catch { return []; } };
const num = h => parseInt(h, 16) >>> 0;

const BaseHero = jload('BaseHero.json');
const roleSet = new Set(jload('RoleModel.json').map(r => num(r.id)));
const skillSet = new Set(jload('SkillConfig.json').map(s => num(s.id)));
const talentSet = new Set(jload('HeroTalent.json').map(t => num(t.id)));

// Client UnstreamizationPerform_HeroByDatabase su DB'leri null kontrolsuz okur:
//   BaseHero[id], HeroTalent[BaseHero.talent], RoleModel[id], SkillConfig[BaseHero.normalAttack]
// Biri eksikse client null-crash olur -> sadece HEPSI cozulen herolari enjekte et.
function gecerliHerolar() {
  const out = [];
  for (const h of BaseHero) {
    const id = num(h.id);
    if (!id || !roleSet.has(id)) continue;
    // ANA ROLLER (isMain=1, 11100001-11100006) enjekte EDILMEZ: bunlar oyuncunun
    // karakter-yaratmada sectigi protagonist slotlari. Ikinci bir "ana karakter"
    // eklenince client'in MainHero=index0 mantigi bozuluyor ve char paketi sonrasi donuyor.
    if (Number(h.isMain) === 1) continue;
    if (!talentSet.has(Number(h.talent) || 0)) continue;
    if (!skillSet.has(Number(h.normalAttack) || 0)) continue;
    const skill = Number(h.active) || 0;
    if (!skillSet.has(skill)) continue;
    out.push({ id, profession: Number(h.profession) || 0, skill });
  }
  return out;
}

// --- Bir hero girisini yuruyup BITIS offsetini dondur (null = cozulemedi) ---
function girisSonu(b, start) {
  let p = start;
  const u8 = () => b[p++];
  const u16 = () => { const v = b.readUInt16BE(p); p += 2; return v; };
  try {
    p += 16;                       // id, RebirthLevel, Exp hi/lo
    p += 2;                        // Profession, FightPosition
    p += 4;                        // ChangeSchedule
    const advN = b.readInt16BE(p); p += 2; p += 9 * Math.max(0, advN);
    p += 32;                       // HeroOverTime..RelatedPartnerPos (8 x u32)
    p += 3;                        // RebirthNum, PropPower, AttackEffect
    p += 4;                        // HistoryMaxLevel
    p += 1;                        // AddQuality
    p += 2;                        // atlanan u16
    p += 5;                        // Skill: u32 id + u8 unlock
    p += 2 + 4 * u16At(b, p);      // BaseAttributes
    p += 2 + 4 * u16At(b, p);      // PvPAttributes
    p += 2 + 16 + 2 + 16;          // GrowRate
    const eq = u16();
    for (let i = 0; i < eq; i++) {
      const cat = u8();
      const cls = (cat === 2 || cat === 4 || cat === 6) ? 'E' : cat === 20 ? 'C' : cat === 13 ? 'W' : 'A';
      p += 15;                     // TUnstreamizerInventory taban
      if (cls === 'E') {
        p += 2;                    // UpgradingLevel, HoleAdditionalQuantity
        p += 2 + 10 * u16At(b, p); // AppendAttributes
        p += 8;                    // WeaponSkillID, FlushSpiritLevel
        const g = u16();
        p += 5 * g;                // gifted stone: u8 kategori + u32 tpl (TUnstreamizerEquipment.as:55-61)
      }
      if (cls === 'A' || cls === 'W') p += 14;  // SpecialProcessing
    }
    const cj = u16(); p += cj * 17;
    return p <= b.length ? p : null;
  } catch { return null; }
  function u16At(buf, off) { const v = buf.readUInt16BE(off); p = off + 2; return v; }
}

// --- Bir girisin ATTRIBUTE blogunu (BaseAttr + PvPAttr + GrowRate) ham olarak al ---
// Client bu bloklari bos (n=0) gonderince hero'nun stat vektoru doluyor ve sonraki
// adimda patliyor. Bu yuzden ek herolar ana hero'nun GERCEK blogunu birebir kullanir.
// Aralik hesabi statlar.js'te (savas motoru da ayni yurumeyi kullaniyor).
function attrBlok(b, start) {
  const [bas, son] = statlar.attrAralik(b, start);
  return b.subarray(bas, son);
}

// --- Hero girisi: sabit alanlar + skill + GERCEK attribute blogu + bos ekipman/crashjade ---
function heroGirisi(h, level, attr) {
  const parts = [];
  const U32 = v => { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); parts.push(b); };
  const U16 = v => { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); parts.push(b); };
  const I16 = v => { const b = Buffer.alloc(2); b.writeInt16BE(v); parts.push(b); };
  const U8 = v => parts.push(Buffer.from([v & 0xff]));
  const F32 = v => { const b = Buffer.alloc(4); b.writeFloatBE(v); parts.push(b); };
  U32(h.id); U32(level); U32(0); U32(0);      // id, RebirthLevel, Exp hi/lo
  U8(h.profession); U8(0);                     // Profession, FightPosition=0 (kadroda degil)
  U32(0); I16(0);                              // ChangeSchedule, AdvanceChanges yok
  for (let i = 0; i < 8; i++) U32(0);          // HeroOverTime..RelatedPartnerPos
  U8(0); U8(0); U8(0);                         // RebirthNum, PropPower, AttackEffect
  U32(level); U8(0); U16(0);                   // HistoryMaxLevel, AddQuality, atlanan u16
  U32(h.skill); U8(1);                         // Skill + IsUnlock
  parts.push(attr);                            // BaseAttr + PvPAttr + GrowRate (ana hero'dan birebir)
  U16(0);                                      // EquipmentsMounted yok
  U16(0);                                      // CrashJadeMounted yok
  return Buffer.concat(parts);
}

// buf = char payload (editChar sonrasi), basicEnd = harita.basicEnd
// idFiltre = sadece bu ID'ler eklensin (karakter shop'ta sahip olunanlar). null = hepsi.
// seviyeOf = (heroId) => seviye  — partnerlerin KENDI kalici seviyesi (seviye.js); yoksa `level`.
function injectAll(buf, level, basicEnd, idFiltre, seviyeOf) {
  const e = basicEnd(buf);
  if (e + 2 > buf.length) return { buf, eklenen: 0, hata: 'basicEnd tasti' };
  const cnt = buf.readUInt16BE(e);
  if (cnt < 1) return { buf, eklenen: 0, hata: 'hero yok' };
  // mevcut TUM girisleri yuru -> orijinal hero bolgesinin sonu
  let son = e + 2;
  const mevcutIds = [];
  for (let i = 0; i < cnt; i++) {
    mevcutIds.push(buf.readUInt32BE(son));
    const n = girisSonu(buf, son);
    if (n == null) return { buf, eklenen: 0, hata: `giris #${i} cozulemedi` };
    son = n;
  }
  const varOlan = new Set(mevcutIds);
  let liste = gecerliHerolar().filter(h => !varOlan.has(h.id));
  if (Array.isArray(idFiltre)) { const S = new Set(idFiltre.map(Number)); liste = liste.filter(h => S.has(h.id)); }
  // Ana hero girisinin GERCEK attribute blogu (BaseAttr+PvPAttr+GrowRate).
  // ESKIDEN: bu blok TUM herolara birebir kopyalaniyordu -> 142 karakterin hepsi ayni
  // stata sahipti (SSS partner ile level-1 sablonu ayni vuruyordu).
  // SIMDI: her hero icin kendi BaseHero gucune gore olceklenmis bir kopya uretilir.
  // Blogun uzunlugu/alan sayisi birebir korunur (sadece buyukluk slotlari degisir),
  // cunku client bu blogu null-kontrolsuz okuyor.
  const [aBas, aSon] = statlar.attrAralik(buf, e + 2);
  const attr = Buffer.from(buf.subarray(aBas, aSon));   // kopya: buf'u yamalayacagiz
  const ana = statlar.anaKaynak() || { id: buf.readUInt32BE(e + 2), lv: 1 };
  // ANA hero da ayni tabana oturur: yakalama seviyesindeki blok -> guncel level'e buyutulur
  try {
    const kAna = statlar.olcekler(buf.readUInt32BE(e + 2), level, ana.id, ana.lv);
    const anaBlok = statlar.blokOlcekle(attr, kAna);
    if (anaBlok.length === aSon - aBas) { buf = Buffer.from(buf); anaBlok.copy(buf, aBas); }
  } catch (e) { }
  // Kaydedilmis kadro (Formation): hero giris offset 17 = FightPosition (0 = kadroda degil)
  let kadro = {};
  try { kadro = require('./durum').yukle().kadro || {}; } catch (e) { }
  const ekler = liste.map(h => {
    let lv = level;
    if (typeof seviyeOf === 'function') { try { lv = Number(seviyeOf(h.id)) || level; } catch (e) { lv = level; } }
    const k = statlar.olcekler(h.id, lv, ana.id, ana.lv);
    const g = heroGirisi(h, lv, statlar.blokOlcekle(attr, k));
    const p = Number(kadro[String(h.id)]) || 0;
    if (p > 0) g[17] = p & 0xff;
    return g;
  });
  if (!ekler.length) return { buf, eklenen: 0, hata: 'eklenecek hero yok', ids: [] };
  const head = buf.subarray(0, e);
  const say = Buffer.alloc(2); say.writeUInt16BE((cnt + ekler.length) & 0xffff);
  const girisler = buf.subarray(e + 2, son);   // orijinal girisler (ana hero index 0'da kalir)
  const kuyruk = buf.subarray(son);
  return { buf: Buffer.concat([head, say, girisler, ...ekler, kuyruk]), eklenen: ekler.length, girisSonu: son, ids: liste.map(h => h.id) };
}

module.exports = { injectAll, gecerliHerolar, girisSonu, heroGirisi };
