'use strict';
// Gercek istek->cevap haritasi + login push + hesap yamalari (VIP siniri, level) + CharBaseInfoUpdate uretici.
// Kaynak: cikarim/cevap-haritasi.js -> sunucu/cevap-haritasi.json (AS3 isim eslesmesi + yakalanan akis kaniti).
const fs = require('fs');
const path = require('path');

let H = { cevap: {}, onceki: {}, loginPush: [], isim: {} };
try { H = JSON.parse(fs.readFileSync(path.join(__dirname, 'cevap-haritasi.json'), 'utf8')); } catch (e) { }

function swap(id) {
  const hi = (id >>> 16) & 0xffff, lo = id & 0xffff;
  const m = { 0x0181: 0x0118, 0x0161: 0x0116, 0x0171: 0x0117 };
  return m[hi] !== undefined ? ((m[hi] << 16) | lo) >>> 0 : null;
}

// Swap'tan FARKLI gercek cevaplar (or. 0x01810101 -> 0x01180104, 0x01811906 -> 0x01181908)
const OVERRIDE = new Map();
for (const [cs, arr] of Object.entries(H.cevap || {})) {
  const c = parseInt(cs, 16) >>> 0, s = parseInt(arr[0], 16) >>> 0;
  if (swap(c) !== s) OVERRIDE.set(c, s);
}

// Cevaptan ONCE gonderilen ekstra paketler. Yakalanan veriyle zararsiz olanlar beyaz listede.
// Task: AlreadyAcceptTaskRet(1202) + AlreadyFinishTaskRet(1203) -> CompleteSendInfor(1200)
const EKSTRA_IZIN = new Set([0x01181200]);
const EKSTRA = new Map();
for (const [t, list] of Object.entries(H.onceki || {})) {
  const tid = parseInt(t, 16) >>> 0;
  if (EKSTRA_IZIN.has(tid)) EKSTRA.set(tid, list.map(x => parseInt(x, 16) >>> 0));
}

// Char paketinden hemen sonra gercek sunucunun push ettikleri (Nemu 0x01186700 ayrica dinamik)
const LOGIN_PUSH = (H.loginPush || []).map(x => parseInt(x, 16) >>> 0).filter(x => x !== 0x01186700);

// ---- VIP siniri: VipConfig yalniz 0..VIP_MAX; ustu gecersiz -> tum VIP ozellikleri kapali kalir ----
const VIP_MAX = (() => {
  try {
    const v = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'VipConfig.json'), 'utf8'));
    return Math.max(...v.map(x => parseInt(x.id, 16)));
  } catch (e) { return 10; }
})();
function vipSinir(v) { const n = Number(v) || 0; return Math.max(0, Math.min(n, VIP_MAX)); }

// ---- Char paketi: BasicProperties sonu (dinamik; UTF uzunluklarina gore) ----
// AgentOp4 Server4 UTF(user) RoleId8 UTF(nick) Country4 Rank4 Prestige4 SilverH4 SilverL4 Gold4 Gift4 MilOrd4 Vip4 VipExp4
// BackpackCap2 Expand1 Town4 StarMap4 Souls5x4  => nick sonrasi 71 bayt
function basicEnd(b) {
  let p = 8;
  p += 2 + b.readUInt16BE(p);  // user
  p += 8;                      // RoleId hi/lo
  p += 2 + b.readUInt16BE(p);  // nick
  return p + 71;
}

// Ana hero seviyesi: THero.Level = max(HistoryMaxLevel, RebirthLevel)
// Hero girisi: id4 RebirthLevel4 ExpH4 ExpL4 Prof1 FightPos1 ChangeSchedule4 s16 n + n*9 + 8x4 + RebirthNum1 PropPower1 AttackEffect1 HistoryMaxLevel4
function seviyeYama(buf, level) {
  const b = Buffer.from(buf);
  const lv = Math.max(1, Math.min(Number(level) || 1, 159)) >>> 0; // HeroExp 1..159
  const e = basicEnd(b);
  if (e + 2 > b.length || b.readUInt16BE(e) === 0) return b;
  const s = e + 2;
  const n = b.readInt16BE(s + 22);
  const hist = s + 24 + 9 * Math.max(0, n) + 32 + 3;
  if (hist + 4 > b.length) return b;
  b.writeUInt32BE(lv, s + 4);  // RebirthLevel
  b.writeUInt32BE(lv, hist);   // HistoryMaxLevel
  return b;
}

// Ana hero girisinin KALICI alanlari: seviye (RebirthLevel+HistoryMaxLevel), exp (Exp hi/lo),
// kadro pozisyonu (FightPosition, offset 17) ve secili Soul Skill (Skill u32 id + u8 unlock;
// HistoryMaxLevel'dan sonra AddQuality(1)+atlanan u16(2) -> hist+7). Hepsi opsiyonel.
// Offsetler yakalanan paketle dogrulandi: id 11100005 lv 9 exp 185 pos 6 skill 13100033 @ s+66.
function anaHeroYama(buf, o) {
  o = o || {};
  const b = Buffer.from(buf);
  const e = basicEnd(b);
  if (e + 2 > b.length || b.readUInt16BE(e) === 0) return b;
  const s = e + 2;
  const n = b.readInt16BE(s + 22);
  const hist = s + 24 + 9 * Math.max(0, n) + 32 + 3;
  if (hist + 12 > b.length) return b;
  if (o.level !== undefined) {
    const lv = Math.max(1, Math.min(Number(o.level) || 1, 159)) >>> 0;
    b.writeUInt32BE(lv, s + 4); b.writeUInt32BE(lv, hist);
  }
  if (o.exp !== undefined) { b.writeUInt32BE(0, s + 8); b.writeUInt32BE(Math.max(0, Number(o.exp) || 0) >>> 0, s + 12); }
  if (o.pos > 0) b[s + 17] = o.pos & 0xff;
  if (o.skill > 0) { b.writeUInt32BE(o.skill >>> 0, hist + 7); b[hist + 11] = 1; }
  return b;
}

// ---- SC_Account_CharBaseInfoUpdate 0x01180105: u16 n, n x (u8 index, u32 v, u32 a, u32 b); FamilyID yalniz u32 ----
const BASEINFO = {
  SilverCoin: 0, GiftCertificate: 1, MilitaryOrders: 2, Gold: 3, Soul: 4, Prestige: 5, StrengthenCD: 6,
  BlueSoul: 7, PurpleSoul: 8, GoldSoul: 9, OrangeSoul: 10, Experience: 11, ExperienceTarget: 12, Integral: 13,
  VipLevel: 14, CharacterLevel: 15, CharacterState: 16, VipExp: 17, FamilyID: 18, ReveredBook: 19,
};
function baseInfoUpdate(items) {
  const parts = [Buffer.alloc(2)];
  parts[0].writeUInt16BE(items.length & 0xffff);
  for (const it of items) {
    if (it.index === BASEINFO.FamilyID) { const x = Buffer.alloc(5); x[0] = it.index; x.writeUInt32BE(it.v >>> 0, 1); parts.push(x); continue; }
    const x = Buffer.alloc(13);
    x[0] = it.index;
    x.writeUInt32BE((it.v || 0) >>> 0, 1);
    x.writeUInt32BE((it.a || 0) >>> 0, 5);
    x.writeUInt32BE((it.b || 0) >>> 0, 9);
    parts.push(x);
  }
  return Buffer.concat(parts);
}

// ---- SC_Backpack_InventoryNtf 0x01180f02: odulu GERCEKTEN envantere ekler ----
// u8 cantaTipi, u16 adet, adet x InventoryReference
// InventoryReference = u8 Kategori + sinif blogu (+ Appliance/WakeEquip ise 14B SpecialProcessing)
// Sinif blogu (TUnstreamizerInventory taban): u32 IDTemplate, u32 id, u16 Quantity, u8 TimingCategory, u32 timing
// Son 14 bayt her iki sinifta da ayni uzunlukta:
//   Appliance/WakeEquip -> SpecialProcessing (okunup atilir)
//   Equipment           -> upgLevel,hole,appendAttrN=0,weaponSkill,flushSpirit,giftedN=0
let SEQ = (Date.now() & 0x3fffffff) >>> 0;
function envanterNtf(items, cantaTipi = 0) {
  const parts = [];
  const u8 = v => parts.push(Buffer.from([v & 0xff]));
  const u16 = v => { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); parts.push(b); };
  const u32 = v => { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); parts.push(b); };
  u8(cantaTipi); u16(items.length);
  for (const it of items) {
    const cat = it.category || 1;                 // 1 = Normal -> Appliance sinifi
    u8(cat);
    u32(it.code >>> 0);                           // IDTemplate (Article'da OLMALI)
    u32(it.instance || (SEQ = (SEQ + 1) >>> 0));  // benzersiz instance id
    u16(Math.max(1, Math.min(it.amount || 1, 0xffff)));
    u8(0);                                        // TimingCategory = Permant
    u32(0);                                       // timing
    u8(0); u8(0); u16(0); u32(0); u32(0); u16(0); // 14B (bkz. yukarida)
  }
  return Buffer.concat(parts);
}

module.exports = { OVERRIDE, EKSTRA, LOGIN_PUSH, VIP_MAX, vipSinir, basicEnd, seviyeYama, anaHeroYama, BASEINFO, baseInfoUpdate, envanterNtf, isim: H.isim || {} };
