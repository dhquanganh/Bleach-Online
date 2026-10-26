'use strict';
// Gercek sunucu handler kayit defteri. Opcode -> (ctx) => Buffer|null.
// ctx = { reqId, payload, durum, kaydet, replay(respId) }
// null donerse: oyun-sunucu replay/ACK fallback'ine duser.
// Modüller (envanter/shop/hero/savas) buraya eklenecek; her biri gercek mantik.

// yardimci: BE yazici
class W {
  constructor() { this.parts = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.parts.push(b); return this; }
  i32(v) { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); this.parts.push(b); return this; }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.parts.push(b); return this; }
  u8(v) { this.parts.push(Buffer.from([v & 0xff])); return this; }
  raw(buf) { this.parts.push(buf); return this; }
  done() { return Buffer.concat(this.parts); }
}

const fs = require('fs');
const path = require('path');
const etkinlik = require('./etkinlik');
const envanterDepo = require('./envanter');
const meyhane = require('./meyhane');
const evcil = require('./evcil');
const gunlukEtkinlik = require('./gunluk');
const seviye = require('./seviye');
const beceri = require('./beceri');
const canta = require('./canta');
const olay = require('./olay');
const bleachtrain = require('./bleachtrain');
const arenaReal = require('./arena-real');

// Odul listesini ({type,code,amount}[]) GERCEKTEN ver: esyalar kalici envantere + InventoryNtf,
// para birimleri hesaba + CharBaseInfoUpdate. Paketler ek kuyruguna (cevaptan sonra) yazilir.
function odulVer(durum, oduller) {
  try {
    const eklenen = envanterDepo.ekle(durum, oduller);
    const ntf = envanterDepo.kazancPaketi(durum, eklenen);
    if (ntf) ekSonra(envanterDepo.OP_NTF, ntf, 'ODUL-envanter');
  } catch (e) { console.log('[odul] envanter hatasi:', e.message); }
  try { const p = paraIcinOdul(oduller, durum); if (p) ekSonra(0x01180105, p, 'ODUL-para'); } catch (e) { console.log('[odul] para hatasi:', e.message); }
}

// ---- EK PAKET KUYRUGU ----
// Bir handler tek Buffer donduruyor; bazi istekler ise birden fazla SC paketi gerektiriyor
// (or. SkillUpgradeRet'ten ONCE envanter dusumu, PointRet'ten SONRA beceri kilit-acma push'u).
// Handler ekOnce/ekSonra ile kuyruga yazar; oyun-sunucu cevabi gonderirken kuyrugu bosaltir.
// Handler `false` dondururse: istek ISLENDI ama ana cevap YOK (replay/ACK fallback'ine dusme).
const EK = { once: [], sonra: [] };
function ekOnce(id, payload, kaynak) { if (payload) EK.once.push({ id: id >>> 0, payload, kaynak: kaynak || 'EK' }); }
function ekSonra(id, payload, kaynak) { if (payload) EK.sonra.push({ id: id >>> 0, payload, kaynak: kaynak || 'EK' }); }
function ekAl() { const o = EK.once, s = EK.sonra; EK.once = []; EK.sonra = []; return { once: o, sonra: s }; }

// ---- SAYACLAR (modul 0x1E00) ----
// CS 0x01811e01 = [u16 adet] + adet x u32 key   ->   SC 0x01181e01 = [u16 adet] + adet x (u32 key, u32 value)
// Yakalanan 18 baytlik gercek cevapla dogrulandi (2 + 2*8).
// CONST_COUNTER: KEY_Recharge=300029, KEY_AddConsume=300028, KEY_FirstRecharge=300005,
//   KEY_VIP_ReceiveState=4, KEY_OrgDailyDonate=15, Copy/ninja/jade/talisman 300001..300024.
// Sayaclar KALICI: etkinlik sartlari (yukleme/harcama) bunlarin uzerinden gercek olur.
function sayacDepo(durum) { durum.sayac = durum.sayac || {}; return durum.sayac; }
function sayacOku(durum, key) { return Number(sayacDepo(durum)[String(key >>> 0)]) || 0; }
function sayacArtir(durum, key, delta) {
  const d = sayacDepo(durum);
  const k = String(key >>> 0);
  d[k] = Math.max(0, (Number(d[k]) || 0) + (Number(delta) || 0));
  return d[k];
}
const ACT_DIR = path.join(__dirname, 'activity');

// Kazanilan esyayi KALICI envantere yaz. Cagrildigi her yerde durum yuklenip kaydedilir,
// cunku savas odulu gibi bazi yollarda elimizde durum nesnesi olmuyor.
// Donus: gercekten eklenen kalemler (envanterNtf icin).
function envanterEkleOdul(oduller) {
  try {
    const durumMod = require('./durum');
    const d = durumMod.yukle();
    const eklenen = envanterDepo.ekle(d, oduller);
    if (eklenen.length) durumMod.kaydet(d);
    return eklenen;
  } catch (e) { console.log('[envanter] ekleme hatasi: ' + e.message); return []; }
}

function envanterPaketiEkleme(eklenen) {
  if (!Array.isArray(eklenen) || !eklenen.length) return null;
  const d = require('./durum').yukle();
  return envanterDepo.kazancPaketi(d, eklenen);
}

// Etkinlik sartlari oyuncu seviyesine bakiyor (or. Level Pack kademeleri 5..80).
function oyuncuSeviyesi() {
  try { return Number(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).level) || 1; }
  catch (e) { return 1; }
}
// Son odul alma sonucu: oyun-sunucu bunu okuyup AwardStatusChangeNotify + envanter paketlerini yollar.
let SON_CLAIM = null;
function sonClaim() { return SON_CLAIM; }
// OZEL etkinlik pencereleri (DayBack/RushInSeireitei/Chess/MoneyPenny): etkinlik-ozel.js — kendi durum makinesi.
let OZEL = null;
function ozel() {
  if (OZEL !== null) return OZEL;
  try { OZEL = require('./etkinlik-ozel').kur({ ekSonra, odulVer, paraHarca, awardOf, olay }); }
  catch (e) { console.log('[etkinlik-ozel] yuklenemedi:', e.message); OZEL = false; }
  return OZEL;
}
// YUKLEME (top-up) simulasyonu: launcher "VIP / Altin Yukle" -> oyun-sunucu HTTP -> burasi.
// altin += n, vipExp += n, vipLevel = VipConfig.chargeCount esigi; gunluk yukleme sayaci (Daily Presents / Make Money)
// ve KEY_Recharge (300029) sayaci. Donus: CharBaseInfoUpdate paketi (Gold, VipLevel, VipExp) + ozet.
let VIP_ESIK = null;
function vipHesapla(vipExp) {
  if (!VIP_ESIK) { VIP_ESIK = []; try { for (const r of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'VipConfig.json'), 'utf8'))) VIP_ESIK.push([parseInt(r.id, 16) >>> 0, Number(r.chargeCount) || 0]); } catch (e) { } }
  let lv = 0; for (const [id, esik] of VIP_ESIK) if (vipExp >= esik && id > lv) lv = id;
  return require('./harita').vipSinir(lv);
}
function topupUygula(miktar) {
  const n = Math.max(1, Math.floor(Number(miktar) || 0));
  const yol = require('./runtime-path')('veri.json');
  const v = JSON.parse(fs.readFileSync(yol, 'utf8'));
  v.altin = Math.min(PARA_TAVAN, (Number(v.altin) || 0) + n);
  v.vipExp = Math.min(PARA_TAVAN, (Number(v.vipExp) || 0) + n);
  v.vipLevel = Math.max(Number(v.vipLevel) || 0, vipHesapla(v.vipExp));
  fs.writeFileSync(yol, JSON.stringify(v, null, 2));
  const durumMod = require('./durum'); const d = durumMod.yukle();
  const t = require('./etkinlik-ozel').topupEkle(d, n);
  sayacArtir(d, 300029, n); sayacArtir(d, 300005, 1);
  olay.say(d, 'topup', n);                       // Experiences/HD sartlari (yukleme) — kaydet'ten ONCE
  durumMod.kaydet(d);
  const H = require('./harita');
  const paket = H.baseInfoUpdate([{ index: H.BASEINFO.Gold, v: v.altin }, { index: H.BASEINFO.VipLevel, v: v.vipLevel }, { index: H.BASEINFO.VipExp, v: v.vipExp }]);
  console.log(`[topup] +${n} altin -> altin ${v.altin}, VIP ${v.vipLevel} (exp ${v.vipExp}), bugun ${t.gun[require('./paket').gun()]}`);
  return { paket, altin: v.altin, vipLevel: v.vipLevel, vipExp: v.vipExp, bugun: t.gun[require('./paket').gun()] || 0, toplam: t.toplam || 0 };
}
// Handler BASARILI (ilk u32 = 0) cevap verince artacak olay sayaclari (Experiences / gorev sartlari).
// Kendi icinde olay.say cagiran handler'lar (recruit, cultivate, signin, soulmap...) burada YOK (cift sayim olmasin).
const OLAY_TETIK = {
  '0x01810e00': 'fortifyEquip', '0x01810e01': 'refineEquip', '0x01810e03': 'designateRefine', '0x01810e02': 'inheritEquip',
  '0x01810e09': 'spiritForge', '0x01810e06': 'enchant', '0x01810e05': 'advanceEquip',
  '0x01811101': 'gemInlay',
  '0x01811301': 'hoguUpgrade', '0x01811303': 'hoguUpgrade', '0x01811004': 'oneKeyExchange', '0x01810f01': 'expBookUse',
  '0x01811b02': 'signinExchange', '0x01811901': 'arenaReward',
  '0x01814228': 'luckyCat', '0x01814214': 'konso', '0x0181423d': 'girlfriendUpgrade', '0x0181423e': 'girlfriendParty',
  '0x01814240': 'girlfriendExchange', '0x01814242': 'girlfriendExchange',
  '0x01814401': 'diceSilver', '0x01816601': 'beautyGame', '0x01816602': 'beautyGame',
  '0x01810c00': 'autoJanken', '0x01810c01': 'autoJanken', '0x01814302': 'summon',
};
// yakalanan gercek activity InitRet verisi (activityId hex -> payload Buffer)
const ACT_INITRET = {};
try {
  const idx = JSON.parse(fs.readFileSync(path.join(ACT_DIR, '_initret.json'), 'utf8'));
  for (const [aid, file] of Object.entries(idx)) ACT_INITRET[aid.toLowerCase()] = fs.readFileSync(path.join(ACT_DIR, file));
} catch (e) { }

function genericActivity(actId) {
  const parts = [];
  const u32 = v => { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); return b; };
  const i32 = v => { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); return b; };
  const u16 = v => { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); return b; };
  parts.push(u32(actId), u16(2));
  parts.push(u32(1)); const N = 16; parts.push(u16(N));
  for (let i = 0; i < N; i++) { parts.push(i32(i), u32(0), i32(1), u16(1), u32(0)); }
  parts.push(u32(2), u16(N)); for (let i = 0; i < N; i++) parts.push(u32(0));
  return Buffer.concat(parts);
}

function worldMapPaketi(durum) {
  const file = path.join(__dirname, 'cevaplar', '0x01180201.bin');
  let base;
  try { base = fs.readFileSync(file); } catch (e) { return Buffer.alloc(0); }
  if (base.length < 10) return base;

  const count = base.readUInt16BE(4);
  const tailAt = 6 + count * 5;
  if (tailAt > base.length) return base;
  const points = new Map();
  let blockPoints;
  try {
    blockPoints = require('./paket').tablo('BlockPoint').byId;
    for (const pointId of blockPoints.keys()) points.set(Number(pointId) >>> 0, 0);
  } catch (e) { blockPoints = null; }
  for (let i = 0; i < count; i++) {
    const offset = 6 + i * 5;
    points.set(base.readUInt32BE(offset), base.readUInt8(offset + 4));
  }

  try {
    const done = new Set((durum.gorev && durum.gorev.biten || []).map(Number));
    const active = durum.gorev && durum.gorev.kabul || {};
    const tasks = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'Task.json'), 'utf8'));
    for (const task of tasks) {
      const taskId = parseInt(task.id, 16) >>> 0;
      const completed = done.has(taskId);
      if ((!completed && !active[String(taskId)]) || ![2, 4].includes(Number(task.eventType))) continue;
      let complete;
      try { complete = JSON.parse(task.complete || '{}'); } catch (e) { continue; }
      const pointId = Number(complete.campId) >>> 0;
      if (pointId && blockPoints && blockPoints.has(pointId)) {
        const status = completed ? 5 : 1;
        if (status > (points.get(pointId) || 0)) points.set(pointId, status);
      }
    }
  } catch (e) { }

  const entries = [...points.entries()].sort((a, b) => a[0] - b[0]);
  const out = Buffer.alloc(6 + entries.length * 5 + (base.length - tailAt));
  base.copy(out, 0, 0, 6);
  out.writeUInt16BE(entries.length, 4);
  let offset = 6;
  for (const [id, status] of entries) {
    out.writeUInt32BE(id >>> 0, offset);
    out.writeUInt8(status & 0xff, offset + 4);
    offset += 5;
  }
  base.copy(out, offset, tailAt);
  // TNodal reads camp stars (7 bytes each), then campaigns (id + 5 bytes).
  // Captured campaign positions must not override the persisted battle position.
  if (tailAt + 2 > base.length) return out;
  const campaignAt = offset + 2 + out.readUInt16BE(offset) * 7;
  if (campaignAt + 2 > out.length) return out;
  const cities = require('./paket').tablo('City').liste.filter(city => Number(city.type) === 2);
  const campaigns = Buffer.alloc(2 + cities.length * 9);
  campaigns.writeUInt16BE(cities.length, 0);
  cities.forEach((city, index) => {
    const cityId = parseInt(city.id, 16) >>> 0;
    let campaignId = Number(city.start);
    for (let id = Number(city.start); id <= Number(city.last); id++) {
      if (Object.prototype.hasOwnProperty.call(durum.instanceProgress || {}, `${cityId}:${id}`)) campaignId = id;
    }
    const selected = Number((durum.instanceCampaign || {})[cityId]);
    if (selected >= Number(city.start) && selected <= Number(city.last)) campaignId = selected;
    const single = require('./paket').satir('Single', campaignId);
    const saved = Number((durum.instanceProgress || {})[`${cityId}:${campaignId}`]);
    const layer = single ? Math.max(0, Math.min(Number(single.endId) - Number(single.startId) + 1, (saved || Number(single.startId)) - Number(single.startId))) : 0;
    const pos = 2 + index * 9;
    campaigns.writeUInt32BE(cityId, pos);
    campaigns[pos + 4] = saved ? (campaignId === Number(city.last) ? 1 : 0) : 255;
    campaigns[pos + 5] = layer;
    campaigns[pos + 8] = 1;
  });
  const stars = new Map();
  const starCount = out.readUInt16BE(offset);
  for (let i=0;i<starCount;i++) {
    const pos=offset+2+i*7;
    stars.set(out.readUInt32BE(pos),Buffer.from(out.subarray(pos,pos+7)));
  }
  for (const city of cities) for(let id=Number(city.start);id<=Number(city.last);id++) {
    const single=require('./paket').satir('Single',id);
    const saved=Number((durum.instanceProgress||{})[`${city._id}:${id}`]);
    const rating=Number((durum.instanceStars||{})[id]) || (single && saved>Number(single.endId)?3:0);
    if(!rating)continue;
    const record=Buffer.alloc(7);record.writeUInt32BE(id,0);
    record[4]=Number(single.endId)-Number(single.startId);record[5]=1;record[6]=Math.min(3,rating);
    stars.set(id,record);
  }
  const starHeader=Buffer.alloc(2);starHeader.writeUInt16BE(stars.size,0);
  return Buffer.concat([out.subarray(0,offset),starHeader,...stars.values(),campaigns]);
}

// istek->handler (opcode hex).
const byReq = {
  '0x01810201': ({ durum }) => worldMapPaketi(durum),

  // === ZAMANLI ETKINLIKLER (DailyActivity, modul 0x3B00) ===
  // Bu surumde "dunya bossu"nun tek gercek karsiligi: Evil Spirit x3, Guild War,
  // Protect Seireitei, Ryoka Attack, Void Region. Detay: sunucu/gunluk.js basligi.
  '0x01813b00': ({ durum }) => gunlukEtkinlik.durumPaketi(durum),
  '0x01813b01': ({ payload, durum, kaydet }) => {
    const tip = payload && payload.length >= 1 ? payload.readInt8(0) : 0;
    const p = gunlukEtkinlik.operatePaketi(tip, durum);
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01813b02': ({ durum }) => gunlukEtkinlik.odulPaketi(durum),

  // === SAYACLAR (0x01811e01 -> 0x01181e01) ===
  // Client hangi sayaclari istediyse AYNI sirayla degerlerini doner. Bilinmeyen key -> 0.
  '0x01811e01': ({ payload, durum }) => {
    const w = new W();
    const n = payload && payload.length >= 2 ? payload.readUInt16BE(0) : 0;
    const adet = Math.max(0, Math.min(n, 128));
    w.u16(adet);
    for (let i = 0; i < adet; i++) {
      const off = 2 + i * 4;
      const key = payload.length >= off + 4 ? payload.readUInt32BE(off) : 0;
      let deger = sayacOku(durum, key);
      if ((key >>> 0) === 4) deger = durum.vipAlimGun === gunTarihi() ? 1 : 0;   // KEY_VIP_ReceiveState: gunluk
      if ((key >>> 0) === 15) deger = olay.gunlukOku(durum, 'guildDonateSilverAmount');   // KEY_OrgDailyDonate: bugun bagislanan gumus
      w.u32(key >>> 0); w.u32(deger >>> 0);
    }
    return w.done();
  },

  // === MOD SOUL'S HOME (PetHouse, modul 0x7200) ===
  // Detay + tuzaklar: sunucu/evcil.js basligi.
  '0x01817200': ({ payload, durum, kaydet }) => {          // besleme
    const petId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const p = evcil.feedPaketi(petId, durum);
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01817201': ({ payload, durum, kaydet }) => {          // aktiflestirme
    const petId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const p = evcil.rankUpPaketi(petId, durum);
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01817202': () => evcil.silPaketi(),                   // silme desteklenmiyor
  '0x01817203': ({ payload, durum, kaydet }) => {          // ana pet degistir
    const petId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const p = evcil.changePaketi(petId, durum);
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01817204': ({ durum }) => evcil.itemPaketi(durum),    // pet esyasi sayaci (hata kodu YOK)

  // === MEYHANE (Tavern, modul 0x0C00) — Janken / devsirme / Advance ===
  // Detay + tuzaklar: sunucu/meyhane.js basligi. Ozetle: Mora paketlerindeki id
  // Tavern_Warrior SATIR id'si (30150001+), Recruit'teki ise HERO id'si (11110001+).
  '0x01810c00': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 5) return new W().u32(1).done();
    const tip = payload && payload.length >= 1 ? payload.readInt8(0) : 0;
    const gradeId = payload && payload.length >= 5 ? payload.readUInt32BE(1) : 0;
    const p = meyhane.moraPaketi(tip, gradeId, durum);
    if (p.readUInt32BE(0) === 0) ekSonra(0x01180105, meyhane.moneyPaketi(), 'TAVERN-money');
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01810c01': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 1) return new W().u32(1).done();
    const p = meyhane.normalMoraPaketi(durum, payload.readUInt8(0));
    if (p.readUInt32BE(0) === 0) ekSonra(0x01180105, meyhane.moneyPaketi(), 'TAVERN-money');
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01810c02': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 4) return new W().u32(1).done();
    const wid = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const p = meyhane.recruitPaketi(wid, durum, seviye.anaDurum().lv);   // partner ana heronun seviyesinde gelir
    if (p.length >= 8 && p.readUInt32BE(0) === 0) olay.say(durum, 'recruit', 1);
    try { kaydet(durum); } catch (e) { }
    return p;
  },

  // === SEVIYE ATLAMA: CS_Account_CharUpgradeReq 0x01810102 = [u16 n] + n x u32 heroId ===
  // -> SC_Account_CharUpgradeNtf 0x01180103 (harita OVERRIDE ile eslesir). Detay: seviye.js.
  // ESKIDEN yakalanan sabit cevap (hero 11100005 -> lv 7) donuyordu: herkes hep "Lv.7" oluyor,
  // relogin'de veri.json'daki level (1) geri geliyordu. Simdi gercek kalici seviye/exp.
  // Yalniz GERCEKTEN seviye atlayan (bekleyen) herolar cevaplanir; ExperienceTarget
  // artefakti (client her hedefli exp'te istek atar) sessiz gecilir.
  '0x01810102': ({ payload, durum, kaydet }) => {
    const ids = seviye.upgradeReqIds(payload);
    const hazir = ids.filter(id => seviye.bekleyenMi(durum, id));
    if (!hazir.length) return false;                 // islendi, cevap yok
    const p = seviye.upgradeNtf(durum, hazir);
    const ekipman = require('./ekipman');
    for (const id of hazir) {
      const level = seviye.heroSeviye(durum, id);
      const attr = ekipman.statPaketi(durum, id, level);
      if (attr) ekSonra(0x01180104, attr, 'SEVIYE-stat');
      else console.log(`[seviye] stat paketi olusturulamadi: hero=${id} lv=${level}`);
    }
    seviye.bekleyenTemizle(durum, hazir);
    try { kaydet(durum); } catch (e) { }
    console.log(`[seviye] seviye atlama bildirildi: ${hazir.map(id => id + '->lv' + seviye.heroSeviye(durum, id)).join(', ')}`);
    return p;
  },

  // === SOUL SKILLS (GeneralStar beceri sekmesi) — detay: beceri.js ===
  '0x01810b05': ({ durum, kaydet }) => {                 // SkillListReq -> [u32 0][u16 n]+n x (u32 id,u8 1)
    const p = beceri.listePaketi(durum);
    try { kaydet(durum); } catch (e) { }
    return p;
  },
  '0x01810b06': ({ payload, durum, kaydet }) => {        // ChangeSkillReq [u32 id] -> [u8 hata][u32 id]
    const id = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const r = beceri.degistir(durum, id);
    if (!r.hata) { try { kaydet(durum); } catch (e) { } }
    console.log(`[beceri] degistir ${id}: ${r.hata ? 'HATA ' + r.hata : 'ok'}`);
    return r.paket;
  },
  '0x01810b04': ({ payload, durum, kaydet }) => {        // SkillUpgradeReq [u32 id] -> [u32 hata][u32 yeniId]
    const id = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const r = beceri.yukselt(durum, id, envanterDepo);
    if (!r.hata) {
      if (r.dusulen) {                                   // Skill Scroll dusumu CEVAPTAN ONCE (panel sayaci)
        const g = envanterDepo.guncellemePaketi(durum, r.dusulen.code, envanterDepo.instanceOf(r.dusulen.code));
        ekOnce(g.id, g.payload, 'BECERI-parsomen');
      }
      try { kaydet(durum); } catch (e) { }
    }
    console.log(`[beceri] yukselt ${id}: ${r.hata ? 'HATA ' + r.hata : 'ok -> ' + r.yeni + (r.dusulen ? ' (-' + r.dusulen.amount + ' parsomen)' : '')}`);
    return r.paket;
  },

  // === CANTA: esya KULLAN (0x01810f01 -> 0x01180f08) ve SAT (0x01810f03 -> 0x01180f05) ===
  // Cevap opcode'lari swap DEGIL -> ek kuyruguyla acikca gonderilir, handler false doner.
  '0x01810f01': ({ payload, durum, kaydet }) => {
    const titleBefore=payload?.length>=10&&require('./usable-items').resolve(payload.readUInt32BE(6))?.kind==='title'?structuredClone(durum):null;
    const r = canta.kullan(durum, payload, {
      para: (awards, target = durum) => paraIcinOdul(awards, target),
      harca: paraHarca,
      odulBul: odulBulKesin,
      nhanNhanVat: (heroId, target = durum) => meyhane.itemRecruitPaketi(heroId, target, seviye.anaDurum().lv),
    });
    if(!r.hata&&r.once.some(p=>p.kaynak==='KULLAN-title')){
      try{kaydet(durum);}catch(error){for(const key of Object.keys(durum))delete durum[key];Object.assign(durum,titleBefore);r.once=[];r.hata=1;r.ret.writeUInt32BE(1,0);}
    }
    for (const e of r.once) ekSonra(e.id, e.payload, e.kaynak);
    ekSonra(r.retId, r.ret, 'KULLAN-ret');
    if (!r.hata && r.once.some(packet => packet.kaynak === 'KULLAN-loot')) {
      // Refresh after the receipt handler, which rebuilds its temporary reward list.
      // LoadBagResult also refreshes existing Flash clients that ignore unseen InventoryNtf instances.
      ekSonra(0x01180f00, envanterDepo.loadBagPaketi(durum), 'KULLAN-bag-sync');
    }
    if (!r.hata&&!titleBefore) { try { kaydet(durum); } catch (e) { } }
    console.log(`[canta] kullan ${r.tpl || '?'} x${r.adet || 0} ${r.ad ? '"' + r.ad + '"' : ''}: ${r.hata ? 'HATA ' + r.hata : 'ok'}`);
    return false;
  },
  '0x01810f03': ({ payload, durum, kaydet }) => {
    const r = canta.sat(durum, payload, { para: awards => paraIcinOdul(awards, durum) });
    for (const e of r.once) ekSonra(e.id, e.payload, e.kaynak);
    ekSonra(r.retId, r.ret, 'SAT-ret');
    if (!r.hata) { try { kaydet(durum); } catch (e) { } }
    console.log(`[canta] sat ${r.adet || 0} kalem: ${r.hata ? 'HATA ' + r.hata : 'ok +' + r.toplam + ' gumus'}`);
    return false;
  },

  // === VIP: gunluk kupon odulu (CS_Vip_ReceiveReq 0x01812200 -> SC_Vip_ReceiveRet 0x01182200) ===
  // Cevap [u32 hata][u16 kupon] -> client "Coupon +N" yazar, butonu "alindi"ya cevirir.
  // Miktar VipConfig[vip].dailyChicket. Alindi bilgisi sayac KEY_VIP_ReceiveState=4 ile (login'de
  // Counter istegiyle okunur); gun degisince sifirlanir (durum.vipAlimGun).
  '0x01812200': ({ durum, kaydet }) => {
    let vip = 0; try { const hh = require('./harita'); vip = hh.vipSinir(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).vipLevel); } catch (e) { }
    if (vip <= 0) return hataKodu(1);
    const bugun = gunTarihi();
    if (durum.vipAlimGun === bugun) return hataKodu(1);
    let kupon = 0;
    try { for (const r of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'VipConfig.json'), 'utf8'))) if ((parseInt(r.id, 16) >>> 0) === vip) kupon = Number(r.dailyChicket) || 0; } catch (e) { }
    const p = paraIcinOdul([{ type: 0, code: 2, amount: kupon }]);
    if (p) ekSonra(0x01180105, p, 'VIP-kupon');
    durum.vipAlimGun = bugun; sayacDepo(durum)['4'] = 1;
    try { kaydet(durum); } catch (e) { }
    console.log(`[vip] gunluk odul: VIP${vip} -> +${kupon} kupon`);
    const w = new W(); w.u32(0); w.u16(kupon); return w.done();
  },

  // === BLEACH TRAIN ("Experiences" / Novice paneli, 0x6a00) — detay: bleachtrain.js ===
  // Eskiden yakalanan sabit cevaplar donuyordu (baska hesabin ilerlemesi/odulleri). Simdi gercek:
  // 184 gorevin ilerlemesi olay sayaclarindan, odul GrowRoadTask'tan (VIP >= VipNeed ise VIP odulu).
  '0x01816a00': ({ durum, kaydet }) => { const p = bleachtrain.listePaketi(durum); try { kaydet(durum); } catch (e) { } return p; },
  '0x01816a01': ({ payload, durum, kaydet }) => {
    const id = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const r = bleachtrain.odulAl(durum, id, { ver: o => odulVer(durum, o) });
    if (!r.hata) { try { kaydet(durum); } catch (e) { } }
    console.log(`[bleachtrain] odul ${id} "${r.ad || ''}": ${r.hata ? 'HATA ' + r.hata : 'ok ' + JSON.stringify(r.oduller)}`);
    return r.paket;
  },
  '0x01816a03': ({ payload, durum, kaydet }) => {
    const g = payload && payload.length >= 8 ? payload.readUInt32BE(0) : 0, i = payload && payload.length >= 8 ? payload.readUInt32BE(4) : 0;
    const r = bleachtrain.vipBagAl(durum, g, i, {
      awardCoz: odulBulKesin,
      altinHarca: m => { const p = paraHarca([{ type: 0, code: 1, amount: m }]); if (p) ekOnce(0x01180105, p, 'BLEACHTRAIN-altin'); return !!p; },
      ver: o => odulVer(durum, o),
    });
    if (!r.hata) { try { kaydet(durum); } catch (e) { } }
    console.log(`[bleachtrain] vip paketi ${g}/${i}: ${r.hata ? 'HATA ' + r.hata : 'ok -' + r.fiyat + ' altin'}`);
    return r.paket;
  },

  // Tournament of Throne is registered by king-challenge.js through savas-etkinlik.

  // === RELATED PARTNER: aktif beceri listesi (CS 0x01818005 -> SC 0x01188005) ===
  // [u32 hata][u16 adet] + adet x (u32 heroId, u32 skillId) — bos liste = varsayilan beceriler.
  '0x01818005': () => { const w = new W(); w.u32(0); w.u16(0); return w.done(); },
  // ChangeCard: [i32 itemId][i16 adet] -> esya KALICI envantere yazilir, cevap sadece hata kodu.
  '0x01810c03': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 6) return new W().u32(1).done();
    const itemId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const adet = payload && payload.length >= 6 ? payload.readInt16BE(4) : 1;
    const p = meyhane.changeCardPaketi(itemId, adet, durum);
    if (p.readUInt32BE(0) === 0) {
      ekSonra(envanterDepo.OP_NTF, envanterDepo.kazancPaketi(durum, [{code: itemId, amount: adet}]), 'TAVERN-card');
      kaydet(durum);
    }
    return p;
  },
  // "Advance" butonu — ayri modul (HeroSLevel 8448)
  '0x01812101': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 4) return new W().u32(1).done();
    const heroId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const p = meyhane.addQualityPaketi(heroId, durum);
    if (p.readUInt32BE(0) === 0) ekSonra(0x01180105, meyhane.moneyPaketi(true), 'TAVERN-quality');
    try { kaydet(durum); } catch (e) { }
    return p;
  },

  // === CANTA: LoadBag (0x01810f00 -> 0x01180f00) ===
  // Istek: [u8 cantaTipi]  (0 = NORMAL, 1 = Temporary)
  // Cevap: [u32 hata][u8 cantaTipi][u16 adet] + adet x 30B InventoryReference
  // ESKIDEN yakalanan 367 baytlik ESKI HESABIN cantasi donuluyordu -> kazanilan her sey
  // her giriste siliniyordu. Artik taban canta + kalici olarak biriken esyalar donuyor.
  '0x01810f00': ({ payload, durum }) => {
    const tip = payload && payload.length >= 1 ? payload.readUInt8(0) : 0;
    if (tip === 0) { const items = require('./usable-items'); ekSonra(items.OP_STATE, items.statePacket(durum), 'ITEM-state'); }
    return envanterDepo.loadBagPaketi(durum, tip);
  },

  // === ACTIVITY sistemi (0x2300) — event panelleri + ODUL ALMA + AC/KAPA ===
  // LoadActivityInfoReq -> acik etkinlik listesi. BU LISTE ac/kapa anahtaridir:
  // listede olmayan bir etkinlik icin InitRet/AwardStatus client'ta SESSIZCE duser.
  // Liste sunucu/etkinlikler.json'dan geliyor (ilk acilista yakalanan 40 etkinlikle tohumlanir).
  '0x01812300': () => etkinlik.listePaketi(),

  // InitReq -> kutu durumlari. Kademesi COZULEBILEN etkinlikte (or. Level Pack) durumu BIZ
  // uretiriz: sart saglandi mi (seviye), daha once alinmis mi. Cozulemeyende eski davranis
  // (yakalanan gercek veri, yoksa genel paket) korunur ki calisan paneller bozulmasin.
  '0x01812302': ({ payload, durum, kaydet }) => {
    const actId = payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    if(etkinlik.katalog().get(actId)?.kategori===450000)return require('./ultimate-bp').init(actId,durum);
    const key = (actId >>> 0).toString(16).padStart(8, '0');
    // OZEL pencereler (Daily Presents, Seireitei Attack, zar tahtasi, Make Money): kendi durum makinesi.
    try { const oz = ozel(); const kat = oz ? oz.kategoriOf(actId) : 0; if (oz && oz.init[kat]) {const packet=oz.init[kat](actId, durum);if(kat===970000)kaydet(durum);return packet;} }
    catch (e) { console.log('[etkinlik-ozel] init hata ' + actId + ': ' + e.message); if(etkinlik.katalog().get(actId)?.kategori===970000)return etkinlik.initPaketi(actId,durum,0); }
    // ONCELIK: yakalanan gercek paket (blok yapisi pencereye birebir uyar) + kutu durumlari kalici kayittan.
    // ESKIDEN uretilen tek-bloklu kademe paketi one geciyordu -> Parameter blogu bekleyen etkinlik
    // pencereleri (Chess, TreasureMap, LimitBuy, SoulBox...) parse'da patlayip karartma ekranda kaliyordu.
    if (ACT_INITRET[key]) {
      try { return etkinlik.initPaketiKarma(actId, ACT_INITRET[key], durum, oyuncuSeviyesi()); }
      catch (e) { console.log('[etkinlik] karma init hata ' + actId + ': ' + e.message); return Buffer.from(ACT_INITRET[key]); }
    }
    try {
      if (etkinlik.kademeler(actId).length) return etkinlik.initPaketi(actId, durum, oyuncuSeviyesi());
    } catch (e) { console.log('[etkinlik] init hata ' + actId + ': ' + e.message); }
    return genericActivity(actId);                               // yakalanmamis -> genel
  },

  // OperateReq [u32 wireId][u32 index] -> OperateRet.
  // ESKIDEN: sart kontrolu YOKTU, "alindi" KAYDEDILMIYORDU ve eslesme bulunamazsa awardOf
  // uydurma bir odul donduruyordu -> Receive sonsuz basilabiliyordu.
  // SIMDI: seviye sarti + "zaten alinmis" kontrolu yapilir, sonuc KALICI yazilir, odul gercek.
  '0x01812303': ({ payload, durum, kaydet }) => {
    const actId = payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const idx = payload.length >= 8 ? payload.readUInt32BE(4) : 0;
    if(etkinlik.katalog().get(actId)?.kategori===450000){
      SON_CLAIM={ozel:true};
      if(payload.length!==14||payload.readInt16BE(8)!==1)return etkinlik.operateRet(80,actId,[]);
      const service=require('./ultimate-bp'),r=service.operate(actId,idx,[payload.readInt32BE(10)],durum,kaydet);
      if(!r.hata){
        const exp=(r.oduller||[]).filter(a=>a.type===2&&a.code===0).reduce((n,a)=>n+a.amount,0);
        if(exp)ekSonra(0x01180105,require('./harita').baseInfoUpdate([{index:11,v:exp}]),'ULTIMATE-exp');
        ekSonra(0x01180f00,envanterDepo.loadBagPaketi(durum),'ULTIMATE-bag');
        const v=JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'),'utf8'));
        const fields=[['gumus',0],['kupon',1],['askeriEmir',2],['altin',3],['generalsSoul',4],['prestij',5],['blueSoul',7],['purpleSoul',8],['goldSoulV',9],['orangeSoul',10]];
        ekSonra(0x01180105,require('./harita').baseInfoUpdate(fields.filter(([k])=>v[k]!==undefined).map(([k,index])=>index===0?{index,v:Number(v.gumusHigh)||0,a:Number(v[k])||0}:{index,v:Number(v[k])||0})),'ULTIMATE-currency');
        if(r.hero)ekSonra(0x01180c02,new (require('./paket').Y)().u32(0).u32(r.hero).u32(1).u32(0).u32(0).done(),'ULTIMATE-hero');
      }
      ekSonra(0x01182302,service.init(actId,durum),'ULTIMATE-refresh');
      return etkinlik.operateRet(r.hata,actId,r.oduller);
    }
    if(etkinlik.katalog().get(actId)?.kategori===970000)SON_CLAIM={ozel:true};
    // OZEL pencereler: [wire][idx] + opsiyonel [i16 n][n x i32] (DayBack bit, Chess zar/bayrak)
    try {
      const oz = ozel(); const kat = oz ? oz.kategoriOf(actId) : 0;
      if (oz && oz.operate[kat]) {
        if(kat===970000 && (payload.length!==8 && (payload.length<10||payload.readInt16BE(8)<0||payload.length!==10+4*payload.readInt16BE(8))))return etkinlik.operateRet(80,actId,[]);
        const ek = []; if (payload.length >= 10) { const n = payload.readInt16BE(8); for (let i = 0; i < n && 10 + i * 4 + 4 <= payload.length; i++) ek.push(payload.readInt32BE(10 + i * 4)); }
        const r = oz.operate[kat](actId, idx, ek, durum);
        if (!r.hata) {
          if (r.oduller && r.oduller.length) odulVer(durum, r.oduller);
          try { kaydet(durum); } catch (e) { }
          try { require('./telemetri').odul('-', 'etkinlik-ozel:' + actId + '/' + idx, r.oduller || []); } catch (e) { }
        }
        if (r.bildir && r.bildir.length) ekSonra(oz.OP_NOTIFY, oz.bildirimPaketi(actId, r.bildir), 'ETKINLIK-ozel-durum');
        SON_CLAIM = { ozel: true };
        return etkinlik.operateRet(r.hata, actId, r.oduller || []);
      }
    } catch (e) { console.log('[etkinlik-ozel] operate hata ' + actId + ': ' + e.message); if(etkinlik.katalog().get(actId)?.kategori===970000)return etkinlik.operateRet(1,actId,[]); }
    try {
      if (etkinlik.kademeler(actId).length) {
        const r = etkinlik.claim(actId, idx, durum, oyuncuSeviyesi());
        if (!r.hata) {
          // Esyalari KALICI envantere yaz (ayni durum nesnesine), sonra tek seferde kaydet.
          try { envanterDepo.ekle(durum, r.oduller); } catch (e) { console.log('[envanter] ' + e.message); }
          try { kaydet(durum); } catch (e) { }
        }
        SON_CLAIM = r.hata ? null : r;
        return etkinlik.operateRet(r.hata, actId, r.oduller);
      }
    } catch (e) { console.log('[etkinlik] claim hata ' + actId + ': ' + e.message); }
    SON_CLAIM = null;
    const awards = awardOf(actId, idx);
    const w = new W();
    w.u32(0).u32(actId).u32(idx).u16(awards.length);
    for (const a of awards) { w.u16(a.type & 0xffff); w.u32(a.code >>> 0); w.u32(a.amount >>> 0); }
    return w.done();
  },
  // === FORMATION / kadro (TacticalDeployment) ===
  // CS_TacticalDeployment_ChangePositionReq 0x01810900: [u32 heroId][i8 pos]
  // -> SC_TacticalDeploymentChangePositonRet 0x01180900: [i32 result=0][u32 heroId][u8 pos]
  // Client cevabi okuyup FightPosition'i set eder; ayni slottaki eski hero'yu kendisi bosaltir.
  // ACK-zero donulunce result=0 ama heroId=0 oluyordu -> GetHeroByIdentifier(0)=null -> hicbir sey olmuyordu.
  '0x01810900': ({ payload, durum, kaydet }) => {
    if (!payload || payload.length !== 5 || payload.readInt8(4) < 0 || payload.readInt8(4) > 15) return Buffer.from('000000010000000000','hex');
    const heroId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const pos = payload && payload.length >= 5 ? payload.readInt8(4) : 0;
    const previousFormation = { ...durum.kadro };
    try {                                   // kadro KALICI: relogin'de char paketine islenir
      durum.kadro = durum.kadro || {};
      const mainId = Number(durum.karakter?.anaId) || seviye.anaId();
      if (!Object.hasOwn(durum.kadro,String(mainId))) durum.kadro[String(mainId)] = require('./statlar').anaKaynak()?.pos || 6;
      if (pos > 0) for (const k of Object.keys(durum.kadro)) if (durum.kadro[k] === pos && Number(k) !== heroId) durum.kadro[k] = 0;
      durum.kadro[String(heroId)] = pos;
      kaydet(durum);
      require('./military-rank').refresh({ekSonra},durum);
    } catch (e) { durum.kadro = previousFormation; return Buffer.from('000000010000000000','hex'); }
    const b = Buffer.alloc(9);
    b.writeInt32BE(0, 0); b.writeUInt32BE(heroId >>> 0, 4); b.writeUInt8(pos & 0xff, 8);
    return b;
  },
  // === DAILY WELFARE (0x01816d00 -> 0x01186d00) ===
  // TUZAK: bu pakette basta HATA KODU YOK (modulun diger 3 paketinde VAR). u32 result koyarsan
  // tum alanlar kayar. Duzen: [u32 WorldBossLv][i8 maskA][i8 maskB] = 6 bayt.
  //   maskA bit0-3 = GetBack "kilitli", bit4-6 = Welfare "alinmis"
  //   maskB bit0-3 = GetBack "alinabilir";  GetBack Status = bitB - bitA (1 alinabilir/0 alinmis/-1 kilitli)
  //   Welfare Status = bit(i+4) ? alinmis : alinabilir.  bit7 kullanilmiyor (0 birak).
  // Panel acilirken DailyGetBackReward[RebirthLevel] ve DailyWelfareReward[10000000+RebirthLevel]
  // NULL KONTROLSUZ okunuyor; iki tabloda da 1..160 satir var ve bizim RebirthLevel=99 -> guvenli.
  // (RebirthLevel 0 olsaydi satir olmadigi icin panel cokerdi.)
  '0x01816d00': ({ durum, kaydet }) => gunlukPaket(gunlukDurum(durum, kaydet), true),

  // GetBackReq 0x01816d01 = [i8 payMode][i8 itemMask]  (payMode 1=bedava(x0.5), 2=altinla(x1.0))
  //   itemMask bit i = tiklanan kalem; 0=monster, 1=orgBattle, 2=orgDefence, 3=traitor
  // OneKeyReq 0x01816d02 = [i8 payMode] -> alinabilir TUM kalemler
  // WelfareReq 0x01816d03 = [i8 kod 1..5] -> kalem: 1->0, 2/4->1, 3/5->2 (kod-1 = oran indeksi)
  // Cevap: [u32 hata][i8 maskA][i8 maskB]. Client odul MIKTARINI cevaptan OGRENMIYOR
  // (metni tiklama aninda kendi DB'sinden yaziyor) -> odulu ayrica CharBaseInfoUpdate ile veriyoruz.
  '0x01816d01': ({ payload, durum, kaydet }) => {
    const d = gunlukDurum(durum, kaydet);
    const mod = payload && payload.length >= 1 ? payload.readInt8(0) : 1;
    const mask = payload && payload.length >= 2 ? payload.readInt8(1) : 0;
    let gumus = 0;
    for (let i = 0; i < 4; i++) if ((mask >> i) & 1) gumus += getBackOdul(i, mod);
    for (let i = 0; i < 4; i++) if ((mask >> i) & 1) d.getback &= ~(1 << i);
    kaydet(durum); paraVer(gumus);
    return gunlukPaket(d, false);
  },
  '0x01816d02': ({ payload, durum, kaydet }) => {
    const d = gunlukDurum(durum, kaydet);
    const mod = payload && payload.length >= 1 ? payload.readInt8(0) : 1;
    let gumus = 0;
    for (let i = 0; i < 4; i++) if ((d.getback >> i) & 1) gumus += getBackOdul(i, mod);
    d.getback = 0; kaydet(durum); paraVer(gumus);
    return gunlukPaket(d, false);
  },
  '0x01816d03': ({ payload, durum, kaydet }) => {
    const d = gunlukDurum(durum, kaydet);
    const kod = payload && payload.length >= 1 ? payload.readInt8(0) : 1;
    const kalem = kod === 1 ? 0 : (kod === 2 || kod === 4) ? 1 : 2;
    if (!((d.welfare >> kalem) & 1)) { paraVer(welfareOdul(kod)); d.welfare |= (1 << kalem); kaydet(durum); }
    return gunlukPaket(d, false);
  },

  // === LIKE US (0x01817500 -> 0x01187500) === [u32 hata][u32 durum]
  // durum 1 = kisayol ikonu goster, 2 = ConfigValue[60500001] (LikeUsUrl) uzerinden link ac.
  // O ConfigValue satiri DB'mizde YOK ve okuma null kontrolsuz -> durum 2 tiklaninca crash.
  // 0 = ozellik kapali: tek guvenli deger.
  '0x01817500': () => { const w = new W(); w.u32(0); w.u32(0); return w.done(); },

  // === GONGFU FIGHT — BaseInforRet 0x01183d07 (50 bayt, hata kodu YOK) ===
  // Sira: RankYesterday, RankToday, FightValue, GrounpLevel, ScoreYesterDay, ScoreToday,
  //       CurFightTimes, LastFightSce, IfApplyToday, ToastTimes  (10 x u32)
  //       + SpanFightFlag(u8) + CanBuyTime(u32) + ApplyYesterdaySce(u32) + BoxState(i8)
  // KRITIK: GrounpLevel -> GroupLevelNames[7] dizisine indeks (0..6 disi RangeError) VE
  //   GSPVP_Reward[5001 + 5*GrounpLevel] null kontrolsuz okunuyor -> 0 en guvenlisi.
  //   SpanFightFlag > 0 -> PlayerSuperLevelGroups[flag-1] RangeError -> 0.
  //   BoxState signed okunup uint'e yaziliyor -> 0x00..0x7f arasinda kalmali.
  // CurFightTimes=0 birakilirsa her dovus tiklamasi "hak satin al" penceresi aciyor -> 5.
  '0x01813d07': () => {
    const w = new W();
    w.u32(0); w.u32(0); w.u32(0); w.u32(0);   // rankYesterday, rankToday, fightValue, GrounpLevel=0
    w.u32(0); w.u32(0); w.u32(5);             // scoreYesterday, scoreToday, CurFightTimes=5
    w.u32(0); w.u32(0); w.u32(0);             // lastFightSce, ifApplyToday, toastTimes
    w.u8(0);                                  // SpanFightFlag
    w.u32(0); w.u32(0);                       // canBuyTime, applyYesterdaySce
    w.u8(0);                                  // BoxState
    return w.done();
  },
  // TryInRet 0x01183d09: tek bayt (0=NotFight, 1=CanFight, 2=Wait). Client'ta sadece atanir, okunmaz.
  '0x01813d09': () => Buffer.from([0]),
  // SeasonInforRet 0x01183d0d: 20 bayt = SeasonState, OpenTime, ResetTime, CloseTime, FightZoneID.
  // State=0 (Close) girisi reddettirip hata mesaji basiyor -> 1 (Open). ResetTime 0 birakilirsa
  // new Date(0) ile bozuk tarih metni cikiyor (kozmetik) -> gercek zaman damgasi veriliyor.
  '0x01813d0d': () => {
    const w = new W(); const t = Math.floor(Date.now() / 1000);
    w.u32(1); w.u32(t - 3600); w.u32(t + 86400); w.u32(t + 7 * 86400); w.u32(1);
    return w.done();
  },

  // === PET (0x01817100 -> 0x01187100) === [u32 hata][u16 anaPet][u16 yardimciPet]
  // Sayaclar 0 iken HIC DB aramasi yapilmiyor. Pet eklemek icin PetLevelUp[petId*1000+level],
  // MainPetRankUp[petId] ve RoleModel[PetLevelUp.PetResourceID] satirlarinin hepsi bulunmali
  // (uctu de null kontrolsuz okunuyor).
  // DOGRULANMIS pet'ler: PetLevelUp[petId*1000+level], MainPetRankUp[petId] (yalniz 1101-1115)
  // ve RoleModel[PetResourceID] satirlarinin UCU DE mevcut olmali (hepsi null kontrolsuz).
  // NOT: PetLevelUp.json sutun etiketleri kaymis; gercek PetResourceID "f10" alaninda.
  // Seviye o pet'in tavanini asmamali (1101<=10, 1104<=60, 1107<=100, 1111<=150).
  '0x01817100': () => {
    const w = new W();
    w.u32(0);
    const ana = [[1101, 5], [1104, 30], [1107, 50], [1111, 100]];
    w.u16(ana.length);
    for (const [id, lv] of ana) { w.u32(id); w.u32(lv); w.u32(0); }
    const yrd = [[1201, 10], [1201, 30], [1301, 40]];   // yardimci: idHigh/idLow benzersiz ornek id
    w.u16(yrd.length);
    let seq = 1;
    for (const [tpl, lv] of yrd) { w.u32(0); w.u32(seq++); w.u32(tpl); w.u32(lv); w.u32(0); }
    return w.done();
  },

  // === CUSTOM HERO (0x01818700 -> 0x01188700) === [u32 hata][i16 heroSayisi]
  // Sayac readShort (SIGNED) ile okunup uint'e cevriliyor: 0x8000+ deger sonsuz donguye sokar.
  // Ayrica Level=0 + sahip olunmayan hero id -> GetHeroByIdentifier(id).CustomHero null crash.
  // Level >= 1 gonderilince sahiplik kontrolu KISA DEVRE yapiyor (client: Level==0 && ...),
  // yani tum CustomHeros satirlari guvenle listelenebilir. Tavan: CustomHeroExp 14500001-14500101
  // oldugu icin Level+1 <= 101 -> Level <= 100.
  '0x01818700': () => {
    const ids = customHeroIds();
    const w = new W();
    w.u32(0);
    w.u16(Math.min(ids.length, 0x7fff));
    for (const id of ids.slice(0, 0x7fff)) { w.u32(id); w.u32(50); w.u32(1); }
    return w.done();
  },

  // === SUPER MARKET / MALL (0x01811a01 -> 0x01181a01) ===
  // [u32 hata][i16 adet] + adet x (u32 mallID, u32 kullanilmayan)
  // TUZAK: adet TAM OLARAK 7 ise client FOnShutDownFunction cagirip kisayolu kapatiyor.
  // mallID hicbir DB'ye indeks degil (sadece indexOf ile siniflaniyor) -> bilinmeyen id guvenli.
  '0x01811a01': () => { const w = new W(); w.u32(0); w.u16(0); return w.done(); },

  // === MENTORSHIP (0x01813500 -> 0x01183500) ===
  // TUZAK: bu pakette de basta HATA KODU YOK; ilk alan dogrudan Identity.
  // [u8 Identity][u32 x6 gunluk sayaclar][u32 MasterID0][u32 MasterID1][UTF MasterName]
  // [u32 MasterLevel][u32 MasterHeroID][UTF MasterGuildName][u32 InteractionCD][i16 ogrenciSayisi]
  // KRITIK: Identity -> FFunctions[Identity]() olarak CAGRILIYOR ve dizide 3 eleman var.
  //   0=Freedom, 1=Master, 2=Disciple; >=3 -> undefined cagrisi -> client cokuyor.
  //   Identity 0 iken MasterHeroID/DiscipleHeroID (RoleModel) ve DiscipleLevel (SlaveGainExp)
  //   null-kontrolsuz aramalarinin hicbiri calismiyor -> en guvenli durum.
  // Identity=1 (Master) + ogrenciler. Client en fazla 3 ogrenci cizdiriyor.
  // DiscipleHeroID RoleModel'de, DiscipleLevel SlaveGainExp'te (1..159) BULUNMALI — ikisi de
  // null kontrolsuz. InteractionCDTime=0 -> "Interact" butonu aktif.
  '0x01813500': () => {
    const w = new W();
    const utf = s => { const b = Buffer.from(String(s), 'utf8'); w.u16(b.length); w.raw(b); };
    const t = Math.floor(Date.now() / 1000);
    w.u8(1);                                   // Identity = Master
    w.u32(3); w.u32(1); w.u32(12500); w.u32(5); w.u32(0); w.u32(0);   // gunluk sayaclar
    w.u32(0); w.u32(0); utf('');                // MasterID hi/lo, MasterName (Master'iz: bos)
    w.u32(0); w.u32(11100001); utf('');          // MasterLevel, MasterHeroID (RoleModel'de var), guild
    w.u32(0);                                    // InteractionCDTime
    const ogrenci = [
      [1001, 'Ichigo', 40, 11100001, 'Gotei 13'],
      [1002, 'Rukia', 60, 11100002, ''],
    ];
    w.u16(ogrenci.length);
    for (const [id, ad, lv, hero, guild] of ogrenci) {
      w.u32(0); w.u32(id); utf(ad);
      w.u32(lv); w.u32(hero); utf(guild);
      w.u32(0); w.u32(t - 3600); w.u32(t - 3600); w.u32(0);  // CD, StartWorkTime, DrawTime, AddUpExp
    }
    return w.done();
  },

  // === NIJIA STAR (0x01813904 -> 0x01183904) ===
  // [i16 heroSayisi] + hero x (u32 heroID + 7 x i32 yildiz)
  // heroSayisi negatif olursa uint'e cevrilip ~4 milyar oluyor -> buffer tasmasi. 0 guvenli.
  // Bilinmeyen heroID'de client donguyu KIRIYOR (crash yok ama kalan kayitlar sessizce dusuyor).
  '0x01813904': ({durum,payload}) => require('./hollow-soul-map').read(durum,payload),

  // === KNIFE SOUL: egitim (KnifeTrainRequest [i16 adet][i8 tip]) ===
  // Cevap 0x01181400 = [u32 hata][u32 ID][u32 CurrentExp][u8 smallCrit][u8 bigCrit][u32 GainExp] = 18B
  // TUZAK: ID null kontrolsuz KnifeSoul[ID] olarak okunuyor -> gercek id sart (18100001..18100159).
  '0x01811400': ({ payload, durum, kaydet }) => {
    return require('./reiatsu').train({payload,durum,kaydet},{ekOnce,paraHarca,paraIcinOdul,olay},{cost:knifeSoulMaliyet});
  },

  // === KNIFE SOUL: info (payload YOK) ===
  // Client expects [u32 error][u32 ID][u32 exp][u32 AddedAgile/Power/Intelligence/Life].
  '0x01811405': ({ durum, kaydet }) => {
    const d = knifeDurum(durum);
    try { kaydet(durum); } catch (e) { }
    const w = new W();
    w.u32(0); w.u32(d.id >>> 0); w.u32(d.exp >>> 0);
    w.u32(d.addedAgile >>> 0); w.u32(d.addedPower >>> 0);
    w.u32(d.addedIntelligence >>> 0); w.u32(d.addedLife >>> 0);
    return w.done();
  },

  // === SPIRIT SCHOOL: bilgi (payload YOK) ===
  // Cevap 0x01181406 = [u32 expId][u32 currentExp][u32 freeNum] = 12B — HATA KODU YOK!
  // TUZAK: SpiritSchoolExp[expId] null kontrolsuz -> expId gercek olmali (18301001..).
  '0x01811406': ctx => require('./academy').info(ctx),
  '0x01811407': ctx => require('./academy').train(ctx,{ekOnce,ekSonra}),

  // === ARENA: giris ===
  // [u32 hata][u8 BoxType][u16 BoxRanking][u32 BoxLevel][u8 FightTimes][u8 AddTimes]
  // [u32 ColdDown][u16 HighRanking][u16 CurRanking][u16 StreakWin][u16 heroSayisi]...[u16 raporSayisi]
  // TUZAKLAR: HeroId RoleModel'de OLMALI (null kontrolsuz .Model), Military Military.json'da,
  // Country >= 1 (gotoAndStop korumasiz), hero sayisi EN FAZLA 8 (FUIHeros sabit 8).
  '0x01810206': ({ durum }) => {
    const w = new W();
    w.u32(0);
      const box = require('./arena-rewards').info(durum);
      w.u8(box.type); w.u16(box.ranking); w.u32(box.level);
    w.u8(5); w.u8(0); w.u32(0);           // FightTimes=5, AddTimes, ColdDown
    const ranking = arenaReal.rank();
    w.u16(ranking); w.u16(ranking); w.u16(0); // HighRanking, CurRanking, StreakWin
    arenaHerolar(w, durum);
    w.u16(0);                              // rapor yok
    return w.done();
  },
  // Arena sıralama listesi (BigFish): [u32 hata][u16 adet] + ayni hero yapisi
  '0x01811900': ({ durum }) => { const w = new W(); w.u32(0); arenaHerolar(w, durum); return w.done(); },

  // === HELL BUTTERFLY ===
  // [u32 hata][u32 id0][u32 id1][u8 Level][u32 CurExp][u8 CollectionLevel]
  // [u8 eatUsed][u32 EatCD][u8 commUsed][i16 beslenenArkadas]
  // TUZAK: Level Butterfly.json'da olmali (1..159) — 0 paneli cokertiyor.
  // Ayrica istekteki RoleId AYNEN geri yollanmali; aksi halde client "baskasinin kelebegi"
  // dalina girip null friend digest'i deref ediyor.
  '0x01814301': ({ payload }) => {
    const id0 = payload && payload.length >= 8 ? payload.readUInt32BE(0) : 0;
    const id1 = payload && payload.length >= 8 ? payload.readUInt32BE(4) : 0;
    const w = new W();
    w.u32(0); w.u32(id0 >>> 0); w.u32(id1 >>> 0);
    w.u8(1);                 // Level = 1 (Butterfly.json'da var)
    w.u32(0);                // CurExp
    w.u8(1);                 // CollectionLevel
    w.u8(0); w.u32(0);       // eatUsed=0 -> 2 hak, EatCD=0
    w.u8(0);                 // commUsed=0 -> 10 hak
    w.u16(0);                // beslenen arkadas yok
    return w.done();
  },

  // === MENTORSHIP: yakalama listesi 0x01813501 -> 0x01183501 ===
  // [u32 hata][i16 adet] + adet x (u8 tip, u32 id0, u32 id1, UTF ad, u16 lv, UTF lonca,
  //                                u8 kimlik, u16 ogrenciSayisi, u32 etkilesimCD, UTF ustadAd)
  // Bizim eski 4 baytlik ACK'imiz adet alanini okurken EOF veriyordu -> panel bos aciliyordu.
  // Bos liste PANELI BOZMAZ: client "kimse yok" gorselini gosterir, sekmeler calisir.
  '0x01813501': () => { const w = new W(); w.u32(0); w.u16(0); return w.done(); },

  // === MENTORSHIP: kurtarma listesi 0x01813502 -> 0x01183502 ===
  // [u32 hata][i16 adet] + adet x (u32 id0, u32 id1, UTF ad, u16 lv, UTF ustadAd, u32 CD, i8 kaynak)
  '0x01813502': () => { const w = new W(); w.u32(0); w.u16(0); return w.done(); },

  // === HOME: ruh canavari 0x01814214 -> 0x01184214 ===
  // Istek: [u8 tip][u32 id0][u32 id1].  Cevap:
  //   [u32 hata][u8 tip][u32 id0][u32 id1] ve YALNIZ tip==1 ise:
  //   [i16 odulAdet] + adet x (i16 tur, u32 id, u32 miktar) + [u8 benimSayi][u8 arkadasSayi]
  // TUZAK: tip==0 cevabi client'i SAVAS SAHNESINE sokuyor; ardindan savas raporu gelmezse
  //   oyuncu bos savas ekraninda kalir. Ev canavari savasi henuz yok -> daima tip=1 + 0 odul
  //   donuyoruz (panel sayaci tazeler, kimse takilmaz).
  '0x01814214': ({ payload }) => {
    const id0 = payload && payload.length >= 9 ? payload.readUInt32BE(1) : 0;
    const id1 = payload && payload.length >= 9 ? payload.readUInt32BE(5) : 0;
    const w = new W();
    w.u32(0); w.u8(1); w.u32(id0 >>> 0); w.u32(id1 >>> 0);
    w.u16(0);                        // odul yok -> Article araması hic yapilmaz
    w.u8(0); w.u8(0);                // benim / arkadas canavar sayisi
    return w.done();
  },

  // === BLEACH AGENT: satin alma === [u32 hata][u32 buyType (echo)][u32 bitisZamani]
  '0x01818301': ({ payload }) => {
    const tip = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const w = new W();
    w.u32(0); w.u32(tip >>> 0);
    w.u32((Math.floor(Date.now() / 1000) + 30 * 86400) >>> 0);
    return w.done();
  },

  // === FIGHTING SHOW: siralamalar ===
  // ALL 0x01182900 = [u32 ATILAN][i16 adet] + adet x (u32 Rank, u32 Family, UTF Ad, u32 Level, u32 Guc)
  // TUZAK: adet 0 ise client Init() erken donuyor ve panel HIC render edilmiyor -> en az 1 kayit.
  // Family 0 = rozet gizli (guvenli). Bu modulde hata kodu YOK.
  '0x01812900': () => {
    const w = new W();
    const utf = s => { const b = Buffer.from(String(s), 'utf8'); w.u16(b.length); w.raw(b); };
    w.u32(0);
    const liste = [[1, 0, 'Miho Hinata', 99, 2522], [2, 0, 'Ultima Aizen', 99, 10284]];
    w.u16(liste.length);
    for (const [rank, family, ad, lv, guc] of liste) { w.u32(rank); w.u32(family); utf(ad); w.u32(lv); w.u32(guc); }
    return w.done();
  },
  // Single 0x01182901 = [u32 kendi siran] — hata kodu YOK
  '0x01812901': () => { const w = new W(); w.u32(1); return w.done(); },

  // === SMITHY: ekipman guclendirme (en cok tiklanan) ===
  // CS 0x01810e00 = [u32 heroId][u32 equipKey][u32 IDTemplate][i16 attrN + attrN x i8]
  // SC 0x01180e00 = [u32 sonuc][u16 StrengthenLevel][u32 CooldownEndTick][u8 limit][u32 heroId]
  //   heroId 0 GONDERILIRSE paket orada BITER (ekipman blogu beklenmez) -> en guvenli bicim.
  //   Ekipman blogu gondermek Article/BaseEquip/BuildValue/BuildConsume/TempleValue/
  //   WeaponSkillConfig zincirinin TAMAMINI null kontrolsuz tetikliyor.
  '0x01810e00': ({ payload, durum, kaydet }) => {
    const tpl = payload && payload.length >= 12 ? payload.readUInt32BE(8) : 0;
    durum.smithy = durum.smithy || {};
    const anahtar = String(tpl || 0);
    const yeni = Math.min((Number(durum.smithy[anahtar]) || 0) + 1, 159);   // ConfigValue 60100011 = 159
    durum.smithy[anahtar] = yeni;
    try { kaydet(durum); } catch (e) { }
    const w = new W();
    w.u32(0); w.u16(yeni); w.u32(0); w.u8(0); w.u32(0);
    return w.done();
  },
  // Panel acilirken istenen FlushSpirit bilgisi: [u32 sonuc][u32 korumaTasiBayragi]
  '0x01810e07': () => { const w = new W(); w.u32(0); w.u32(0); return w.done(); },

  // === CUSTOM HERO: skill ac/kapa ===
  // CS 0x01818702 = [u32 heroId][u32 bayrak] (0=ac, 1=kapat)
  // SC 0x01188702 = [u32 sonuc][u32 heroId][u32 SkillSwitch][u32 SkillID]
  // TUZAK: SkillID KAPATIRKEN BILE gecerli bir SkillConfig id'si olmali (0 gonderilemez);
  // client her iki dalda da ConstructSkillByID -> SkillConfig[id].Name okuyor.
  '0x01818702': ({ payload }) => {
    const heroId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const bayrak = payload && payload.length >= 8 ? payload.readUInt32BE(4) : 0;
    const w = new W();
    w.u32(0); w.u32(heroId >>> 0);
    w.u32(bayrak === 0 ? 1 : 0);      // 0=ac istegi -> switch 1
    w.u32(14300005);                   // dogrulanmis SkillConfig id (00DA3365)
    return w.done();
  },

  // === HOME: GirlFriend Tease ===
  // CS 0x01814242 = [u8 tip 1..3][u32 roleIdHi][u32 roleIdLo]
  // SC 0x01184242 = [u32 hata][u32 TeaseScore][u32 MyTeaseTime][u32 CurrentTeaseTime]
  //                 [i16 atilan][i16 atilan][u32 ArticleId][u32 miktar]
  // TUZAK: ArticleId null kontrolsuz Article[id].Name olarak okunuyor -> gercek id sart.
  // Puanlar HomeGirlAward'dan: tip1 +2, tip2 +9, tip3 +99.
  '0x01814242': ({ payload, durum, kaydet }) => {
    const tip = payload && payload.length >= 1 ? payload.readUInt8(0) : 1;
    const artis = tip === 3 ? 99 : tip === 2 ? 9 : 2;
    durum.tease = durum.tease || { skor: 0, benim: 0, bugun: 0 };
    durum.tease.skor += artis; durum.tease.benim++; durum.tease.bugun++;
    try { kaydet(durum); } catch (e) { }
    const w = new W();
    w.u32(0); w.u32(durum.tease.skor >>> 0); w.u32(durum.tease.benim >>> 0); w.u32(durum.tease.bugun >>> 0);
    w.u16(0); w.u16(1);
    w.u32(14100074);                   // dogrulanmis Article id ("Skill Scroll")
    w.u32(artis);
    return w.done();
  },

  // === MENTORSHIP: komut (Arrest/Rescue/Draw/Interact...) ===
  // CommandRet 0x01183503 SADECE [u32 hata] tasiyor — gorunur sonuc ayri pakette gelir.
  // Bu girdi olmadan istek ACK-zero'ya dusuyordu ve oyun-sunucu'daki IntercationRet
  // follow-up'i (yalniz handler calisinca tetikleniyor) HIC gonderilmiyordu.
  '0x01813503': () => { const w = new W(); w.u32(0); return w.done(); },

  // === MENTORSHIP: etkilesim gunlugu === [u32 hata][i16 adet]
  // TUZAK: kayit gonderilecekse Post id'si Post.json'da OLMALI (TextColor null kontrolsuz okunuyor).
  // Bos liste en guvenlisi.
  '0x01813505': () => { const w = new W(); w.u32(0); w.u16(0); return w.done(); },

  // === SOUL MAP: Activate (GeneralStar_PointReq, payload YOK) ===
  // Client TIKLANAN dugumu SOYLEMIYOR -> sunucu "siradaki"ni secip id'sini geri verir.
  // BOZULMA SEBEBI (duzeltildi): eski surum ne ruh maliyetini ne de listenin SONUNU
  //   gozetiyordu; her tiklamada bir ileri yuruyup 16 tiklamada son dugume (17134020,
  //   mapId 36 / index 20) ulasti. Orada UpdatePointAndCo "son sayfa + son dugum" daline
  //   girip GENERALSTAR_FORMAT_09 ("...quality upgrade to Orange") yazip ERKEN RETURN
  //   ediyor: ekranda sonsuz tebrik, sifir ilerleme. Artik son dugumde HATA donuyoruz.
  '0x01810b03': ({ durum, kaydet }) => {
    const liste = starPointListe(anaFType());
    if (!liste.length) return hataKodu(HATA_MAX);   // client listesi de bos olurdu -> id gonderme
    const cur = Number(durum.starMapIndex) || 0;
    const i = cur ? liste.findIndex(n => n.id === cur) : -1;
    const sonraki = liste[i + 1];                   // i=-1 (bastan) -> liste[0]
    if (!sonraki) return hataKodu(HATA_MAX);        // zaten son dugum: ILERLETME, tebrik spam'i yok
    const ruh = ruhOku(durum);
    if (ruh < sonraki.need) return hataKodu(HATA_RUH);
    const kalanRuh = ruh - sonraki.need;
    if (!ruhYaz(kalanRuh)) return hataKodu(1);
    durum.generalsSoul = kalanRuh;
    durum.starMapIndex = sonraki.id;
    // Beceri dugumu: gercek sunucu SC_Account_MainHeroSkillInfoNtf 0x01180106 push eder ->
    // client IsUnlock=true (kilit ikonu kalkar, "Soul Skills" sekmesinde secilebilir olur).
    const sk = beceri.dugumBecerisi(sonraki.id);
    if (sk && beceri.kilitAc(durum, sk)) {
      ekSonra(0x01180106, beceri.kilitAcPaketi([sk]), 'SOULMAP-beceri-acildi');
      console.log(`[beceri] Soul Map dugumu beceri acti: ${sk}`);
    }
    olay.say(durum, 'soulmap', 1);
    try { kaydet(durum); } catch (e) { }
    console.log(`[soulmap] ${sonraki.ad} (${sonraki.id}) acildi, ${sonraki.need} ruh -> kalan ${durum.generalsSoul}`);
    const w = new W(); w.u32(0); w.u32(sonraki.id >>> 0);
    return w.done();
  },

  // === HOME (Enter_Home) === 30 bayt
  // [u32 hata][u32 id0][u32 id1][u8 Level][u8 x4 sayaclar][u32 luckyCatCDEnd][u8 cdLimit]
  // [u32 ChangeShapeGirlID][u32 InteractiveScore]
  // TUZAK: Level HomeLevel'de (1..5) VE ChangeShapeGirlID HomeGirlFriend'de (1..10) BULUNMALI;
  // ikisi de null kontrolsuz okunuyor, 0 gondermek paneli cokertiyor.
  '0x0181020b': ({ payload }) => {
    const w = new W();
    const id0 = payload && payload.length >= 8 ? payload.readUInt32BE(0) : 0;
    const id1 = payload && payload.length >= 8 ? payload.readUInt32BE(4) : 0;
    const t = Math.floor(Date.now() / 1000);
    w.u32(0); w.u32(id0); w.u32(id1);
    w.u8(1);                                  // Level = 1 (HomeLevel'de var)
    w.u8(0); w.u8(0); w.u8(0); w.u8(0);       // monster sayaclari + luckyCatCount
    w.u32(t);                                 // LuckyCatCDEndTick
    w.u8(0);                                  // CD limit (bool)
    w.u32(1);                                 // ChangeShapeGirlID = 1
    w.u32(0);                                 // InteractiveScore
    return w.done();
  },

  // === HOME: GirlFriend BaseInfor === 45 bayt
  // TUZAK: CD baslangic tick'leri 0 GONDERILMEZ. Client CDTime-(ServerTick-startTick) islemini
  // UINT yapiyor ve negatif koruma calismiyor -> 0 verilirse ~4.29 milyara tasip butonlari
  // sonsuza kadar kilitliyor. Simdiki tick gonderiliyor.
  '0x0181423c': () => {
    const w = new W();
    const t = Math.floor(Date.now() / 1000);
    w.u32(0);          // hata
    w.u32(1);          // GirlFriendTopLevelID (1..10, HomeGirlFriend'de var)
    w.u32(0);          // CurrentChangeShapeGirlID (0 burada GUVENLI: != 0 kontrolu var)
    w.u32(0); w.u32(t);   // MakeTofu: kullanilan sayi, CD baslangici
    w.u32(0); w.u32(t);   // SpriteCommunicate: kullanilan sayi, CD baslangici
    w.u32(0);          // TeaseScore
    w.u8(0);           // FriendTeaseType (i8)
    w.u32(0); w.u32(0); w.u32(0);   // FriendTeaseTime, CurrentTeaseTime, MyTeaseTime
    return w.done();
  },

  // === NEMU kiyafet (Welcome/Nip) ===
  // NipReq 0x01816800 [u32 clothesId] -> NipRet 0x01186800 [u32 result=0][u32 clothesId]
  // ZERO_ACK GirlClothesID'yi 0 yapiyordu -> ReveredBook'ta Nemu resmi hic yuklenmiyordu.
  '0x01816800': ({ payload, durum, kaydet }) => {
    let id = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    if (!id) id = nemuClothes(durum);
    try { durum.girlClothesID = id >>> 0; kaydet(durum); } catch (e) { }
    const b = Buffer.alloc(8); b.writeUInt32BE(0, 0); b.writeUInt32BE(id >>> 0, 4);
    return b;
  },
  // ReveredBook bilgi istegi 0x01816700 -> BaseInfor 0x01186700 [u32 GirlClothesID][u32 QuestionID]
  '0x01816700': ({ durum }) => nemuBaseInfor(durum),
};

// --- Odul turetme: aktivite+index -> [{type,code,amount}] ---
// type 1/17/21/23 => code dogrudan template; digerleri Award DB mapping. Bos donmek yerine
// gecerli bir odul don ki claim gorunur sekilde calissin (para zaten max; deger kozmetik).
// Tam odul tablosu: cikarim/odul-cikar.js -> sunucu/oduller.json
// (Award DB 9195 sabit + 2719 sansli havuz + 51 tablonun gomulu odulleri; 5232 aranabilir ID)
let ODUL = null;
function loadOdul() {
  if (ODUL) return ODUL;
  ODUL = { award: {}, byId: {} };
  try { ODUL = JSON.parse(fs.readFileSync(path.join(__dirname, 'oduller.json'), 'utf8')); } catch (e) { }
  console.log(`[odul] ${Object.keys(ODUL.award || {}).length} Award + ${Object.keys(ODUL.byId || {}).length} aranabilir ID yuklendi`);
  return ODUL;
}
const DEFAULT_AWARD = [{ type: 1, code: 14100021, amount: 1 }]; // gecerli odul (REWARDID_DATA'da mevcut)
let AWARD_KEYS = null;
function awardOf(actId, idx) {
  const o = loadOdul();
  const norm = a => a.map(x => ({ type: (x.type || 0) >>> 0, code: (x.code || 0) >>> 0, amount: (x.amount || 1) >>> 0 })).slice(0, 8);
  // 1) aktivite/kutu ID'si dogrudan bir tablo satiri mi? (gercek odul)
  const byId = (o.byId || {})[String(actId >>> 0)];
  if (byId && byId.length) return norm(byId);
  // 2) Award DB'de dogrudan kayit
  const aw = (o.award || {})[String(actId >>> 0)];
  if (aw && aw.length) return norm(aw);
  // 3) eslesme yok: Award DB'den (actId,idx) ile DETERMINISTIK gercek bir odul sec.
  //    (eskiden hep ayni fallback donuyordu -> her sey "Spirit Soul 1" gorunuyordu)
  AWARD_KEYS ??= Object.keys(o.award || {});
  if (AWARD_KEYS.length) {
    const k = AWARD_KEYS[(((actId >>> 0) * 2654435761 + (idx >>> 0) * 40503) >>> 0) % AWARD_KEYS.length];
    const a = o.award[k];
    if (a && a.length) return norm(a);
  }
  return DEFAULT_AWARD;
}

// --- Odul -> gercek item template (CONST_COMMON.RewardIDToTemplateID birebir) ---
const RW_MAIN = [0, 0, 0, 2, 5, 6, 3, 7, 7, 7, 7, 4, 4, 4, 1, 15, 13, 13, 14, 18, 12, 12, 12, 12, 22, 22, 22, 24, 20, 20];
const RW_SUB = [0, 1, 2, 0, 0, 0, 0, 3, 4, 5, 6, 11100101, 11100102, 11200003, 14100021, 12, 8, 9, 0, 24, 6003059, 6003060, 6003061, 6003062, 25, 26, 27, 28, 31, 30];
const RW_DATA = [14100022, 14100023, 14100024, 14100025, 14100026, 14100027, 14100028, 14100061, 14100062, 14100063, 14100064, 14100043, 14100044, 14100045, 14100021, 14100021, 14100075, 14100076, 14100283, 14100293, 14100297, 14100298, 14100299, 14100300, 14100352, 14100353, 14100351, 14140507, 14610000, 14630000];
function odulTemplate(type, code) {
  if (type === 1 || type === 17 || type === 21 || type === 23) return code >>> 0;
  for (let i = 0; i < RW_MAIN.length; i++) if (RW_MAIN[i] === type && RW_SUB[i] === code) return RW_DATA[i];
  return 0;
}
// Article DB: client her esya icin Article[IDTemplate].ExpandUsable/OverlayNumber okur.
// Article'da olmayan template -> client null-crash. Bu yuzden ZORUNLU dogrulama.
let ARTICLE = null;
function articleSet() {
  if (ARTICLE) return ARTICLE;
  ARTICLE = new Set();
  try {
    for (const a of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'Article.json'), 'utf8')))
      ARTICLE.add(parseInt(a.id, 16) >>> 0);
  } catch (e) { }
  console.log(`[odul] Article dogrulama: ${ARTICLE.size} gecerli item`);
  return ARTICLE;
}

// Claim sonrasi envantere GERCEKTEN eklenecek paket (0x01180f02). Yoksa popup cikar ama esya gelmez.
// Kademesiz etkinlik yolu: esya once KALICI depoya yazilir (eskiden yazilmiyordu -> relogin'de kayip).
function envanterIcin(payload) {
  const actId = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
  const idx = payload && payload.length >= 8 ? payload.readUInt32BE(4) : 0;
  const oduller = awardOf(actId, idx);
  envanterEkleOdul(oduller);
  return envanterIcinOdul(oduller);
}

// Odul -> envanter paketi (0x01180f02). Sonuc/OperateRet paketi odulu SADECE gosterir;
// esyanin gercekten cantaya girmesi icin ayrica InventoryNtf gerekiyor.
// code=0 girdileri para birimi (silver/exp) -> envantere degil hesaba yazilir, atlanir.
// Article'da bulunmayan template GONDERILMEZ: client null-crash olur.
// Paket, esyanin KALICI TOPLAMINI sabit instance id ile tasir: client ayni yigini bulup
// miktari gunceller (eskiden her odul ayri yigin olarak dusuyordu). Cagiran once
// envanterEkleOdul ile kalici depoya yazmis olmali; yazmadiysa en az odul miktari gosterilir.
function envanterIcinOdul(awards) {
  const art = articleSet();
  const items = [];
  for (const a of (awards || [])) {
    if (!a || !a.code) continue;
    const tpl = odulTemplate(a.type, a.code);
    if (tpl && art.has(tpl)) items.push({ code: tpl, amount: a.amount || 1 });
  }
  if (!items.length) return null;
  let d = null; try { d = require('./durum').yukle(); } catch (e) { }
  return envanterDepo.kazancPaketi(d, items);
}

// Esya kullanimi icin KESIN odul cozumu (awardOf'un rastgele fallback'i YOK): byId/award[template].
function odulBulKesin(tpl) {
  const o = loadOdul();
  const k = String(tpl >>> 0);
  const a = (o.byId || {})[k] || (o.award || {})[k];
  if (!a || !a.length) return null;
  return a.map(x => ({ type: (x.type || 0) >>> 0, code: (x.code || 0) >>> 0, amount: (x.amount || 1) >>> 0 }));
}

// Arena hero listesi (hem Enter_Arena hem BigFish ayni yapiyi kullaniyor):
//   [u16 adet] + adet x (u32 id0, u32 id1, u8 Country, u16 Ranking, u32 Military, u32 HeroId, UTF Nick, u32 Level)
// Kisitlar: HeroId RoleModel'de, Military Military.json'da, Country >= 1, adet <= 8.
function arenaHerolar(w, durum) {
  const utf = s => { const b = Buffer.from(String(s), 'utf8'); w.u16(b.length); w.raw(b); };
  const liste = arenaReal.list();
  w.u16(liste.length);
  for (const bot of liste) {
    w.u32(bot.id0); w.u32(bot.id1); w.u8(bot.country); w.u16(bot.ranking);
    w.u32(bot.military); w.u32(bot.heroes[0]); utf(bot.name); w.u32(bot.level);
  }
}

// Mentorship komut sonucu: CommandRet SADECE hata kodu tasiyor; gorunur sonuc ayri pakette gelir.
// cmd 9 (Interaction) -> SC_Mentorship_IntercationRet 0x01183507 =
//   [u32 hata][u32 id0][u32 id1][u32 InteractionCDTime][u32 TodayInteractionCount][u32 kazanilanExp]
// Not: kazanilanExp yalniz Identity Master/Disciple dalinda okunuyor; Freedom'da sayac disinda
// bir sey gorunmez — bu yuzden LoadBaseData'da Identity=1 (Master) gonderiyoruz.
function mentorEtkilesim(payload, durum) {
  const id0 = payload && payload.length >= 6 ? payload.readUInt32BE(2) : 0;
  const id1 = payload && payload.length >= 10 ? payload.readUInt32BE(6) : 0;
  durum.mentor = durum.mentor || { bugun: 0 };
  durum.mentor.bugun = (Number(durum.mentor.bugun) || 0) + 1;
  const w = new W();
  w.u32(0); w.u32(id0 >>> 0); w.u32(id1 >>> 0);
  w.u32(0);                                  // CD = 0 -> buton hemen tekrar aktif
  w.u32(durum.mentor.bugun >>> 0);
  w.u32(10000);                              // kazanilan exp
  return w.done();
}

// ================== KNIFE SOUL + SPIRIT SCHOOL ==================
// Ikisinde de client, gelen id'yi null kontrolsuz DB'de ariyor; sahte/sifir id panel cokertir.
// KnifeSoul.json     : id, nextID, level, needExp, power, agile, intelligence, life
// SpiritSchoolExp.json: id, monsterId, monsterLevel, needExp
function tabloYukle(ad) {
  try {
    const m = new Map();
    for (const r of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', ad), 'utf8')))
      m.set(parseInt(r.id, 16) >>> 0, r);
    return m;
  } catch (e) { return new Map(); }
}
let KNIFE = null, OKUL = null;
function knifeTablo() { return (KNIFE ||= tabloYukle('KnifeSoul.json')); }

function knifeDurum(durum) {
  if (!durum.knifeSoul || !durum.knifeSoul.id) durum.knifeSoul = { id: 18100001, exp: 0 };
  if (!knifeTablo().has(durum.knifeSoul.id >>> 0)) durum.knifeSoul = { id: 18100001, exp: 0 };
  return durum.knifeSoul;
}
function knifeEgit(d, adet) {
  const t = knifeTablo();
  const kazanc = adet * 50;
  d.exp = (Number(d.exp) || 0) + kazanc;
  // seviye zinciri: needExp dolunca nextID'ye gec
  for (let guvenlik = 0; guvenlik < 200; guvenlik++) {
    const r = t.get(d.id >>> 0); if (!r) break;
    const need = Number(r.needExp) || 0, sonraki = Number(r.nextID) || 0;
    if (!need || d.exp < need || !sonraki || !t.has(sonraki >>> 0)) break;
    d.exp -= need; d.id = sonraki;
  }
  return kazanc;
}
function knifeSoulMaliyet(tip, adet, bakiye) {
  if (tip === 1) {
    const miktar = Math.max(1, Number(adet) || 1);
    if ((Number(bakiye.generalsSoul) || 0) < miktar) return { hata: 0x69, oduller: [] };
    return { hata: 0, oduller: [{ type: 6, code: 0, amount: miktar }] };
  }
  if (tip === 2) {
    const miktar = 10 * Math.max(1, Number(adet) || 1);
    const gold = Math.max(0, Number(bakiye.altin) || 0);
    const coupon = Math.max(0, Number(bakiye.kupon) || 0);
    if (gold + coupon < miktar) return { hata: 0x10, oduller: [] };
    const goldHarca = Math.min(gold, miktar);
    const couponHarca = miktar - goldHarca;
    const oduller = [];
    if (goldHarca) oduller.push({ type: 0, code: 1, amount: goldHarca });
    if (couponHarca) oduller.push({ type: 0, code: 2, amount: couponHarca });
    return { hata: 0, oduller };
  }
  return { hata: 1, oduller: [] };
}
function okulDurum(durum) {
  const bugun = gunTarihi();
  const t = okulTablo();
  let d = durum.spiritSchool;
  if (!d || !d.expId || !t.has(d.expId >>> 0)) {
    d = durum.spiritSchool = { expId: 18301001, exp: 0, free: 0, freeDate: bugun };
  }
  d.exp = Math.max(0, Math.floor(Number(d.exp) || 0));
  if (d.freeDate !== bugun) {
    d.free = 0;
    d.freeDate = bugun;
  } else {
    d.free = Math.min(
      Math.max(0, Number(require('./paket').cv(60109015, 3)) || 0),
      Math.max(0, Math.floor(Number(d.free) || 0))
    );
  }
  return d;
}
function okulPlanla(d, adet) {
  const t = okulTablo();
  let expId = d.expId >>> 0;
  let exp = d.exp;
  let trained = 0;
  const limit = Math.max(1, Number(require('./paket').cv(60109017, 500)) || 500);
  while (trained < adet) {
    let row = t.get(expId);
    if (!row || Number(row.monsterLevel) + 1 >= limit) break;
    exp += 100;
    trained++;
    for (let guard = 0; guard < 510; guard++) {
      row = t.get(expId);
      const need = Number(row && row.needExp) || 0;
      if (!need || exp < need) break;
      const nextId = expId + 1;
      const next = t.get(nextId);
      if (!next || Number(next.monsterId) !== Number(row.monsterId)
        || Number(next.monsterLevel) !== Number(row.monsterLevel) + 1
        || Number(next.monsterLevel) + 1 > limit) break;
      exp -= need;
      expId = nextId;
    }
  }
  return { expId, exp, trained, gain: trained * 100 };
}

// ================== SOUL MAP (GeneralStar) ==================
// Dugum listesi AGDAN GELMIYOR: client 75 dugumu StarPoint bin'inden kendisi kuruyor
// (mapId/10 == FType filtresi; FType: profession 4->1, 1->2, 3->3).
// Sunucunun sahip oldugu TEK durum: StarMapIndex (u32).
// CS 0x01810b03 payload BOS -> tiklanan dugum belirtilmiyor; sunucu SIRADAKI dugumu secer.
// SC 0x01180b03 = [u32 hata][u32 StarMapIndex] = 8 bayt.
// KRITIK: ACK-zero StarMapIndex=0 demekti; client GetEsotericPointByIdentifier(0) -> null
// -> .IsSkill NPE. "Activate'e basinca hicbir sey olmuyor"un sebebi buydu.
const HATA_RUH = 105;   // ErrorCode.json: "Not enough number of Souls"
const HATA_MAX = 95;    // ErrorCode.json: "Maximum value exceeded"
function hataKodu(k) { const w = new W(); w.u32(k >>> 0); return w.done(); }

let STARPOINT = null;
function starPointListe(ftype) {
  if (!STARPOINT) {
    STARPOINT = new Map();
    try {
      for (const r of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'StarPoint.json'), 'utf8'))) {
        const id = parseInt(r.id, 16) >>> 0, mapId = Number(r.mapId) || 0;
        const t = Math.floor(mapId / 10);
        if (!id || !t) continue;
        if (!STARPOINT.has(t)) STARPOINT.set(t, []);
        // need = aktiflestirme ruh maliyeti (TStarPoint.NeedFetch), index = dugumun sayfa ici sirasi
        STARPOINT.get(t).push({ id, need: Number(r.needFetch) || 0, mapId, index: Number(r.index) || 0, ad: r.name });
      }
      for (const [, v] of STARPOINT) v.sort((a, b) => a.id - b.id);
    } catch (e) { }
    console.log(`[soulmap] StarPoint tipleri: ${[...STARPOINT.keys()].map(k => k + ':' + STARPOINT.get(k).length).join(' ')}`);
  }
  return STARPOINT.get(ftype) || [];
}
// Client FType'i profession'dan turetiyor (TUnstreamizerGeneralStar): 4->1, 1->2, 3->3.
// switch'in DEFAULT'u YOK: baska bir profession'da client'in dugum listesi BOS kalir ve
// gonderdigimiz her id GetEsotericPointByIdentifier -> null -> FloatingWords NPE olur.
// O yuzden burada "|| 1" gibi bir varsayilan YOK; eslesmezse 0 donup istek reddedilir.
function anaFType() { return ({ 4: 1, 1: 2, 3: 3 })[anaProfession()] || 0; }
// Ruhlar harcanabilir oldugu icin kalici durumda tutulur; ilk kez veri.json'dan tohumlanir.
function ruhOku(durum) {
  const v = JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8'));
  const balance = Number(v.generalsSoul);
  if (!Number.isFinite(balance) || balance < 0) throw new Error('Soul balance is missing or invalid in veri.json');
  durum.generalsSoul = Math.floor(balance);
  return durum.generalsSoul >>> 0;
}
function ruhYaz(balance) {
  const file = require('./runtime-path')('veri.json');
  try {
    const v = JSON.parse(fs.readFileSync(file, 'utf8'));
    v.generalsSoul = Math.max(0, Math.floor(Number(balance) || 0));
    fs.writeFileSync(file, JSON.stringify(v, null, 2));
    return true;
  } catch (e) {
    console.log('[soulmap] ruh bakiyesi kaydedilemedi:', e.message);
    return false;
  }
}
function anaProfession() {
  try {
    const anaId = require('./statlar').anaKaynak().id;
    for (const h of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'BaseHero.json'), 'utf8')))
      if ((parseInt(h.id, 16) >>> 0) === anaId) return Number(h.profession) || 0;
  } catch (e) { }
  return 0;
}
// Souls sayaci PointRet'ten ONCE gonderilmeli: hem baslik sayaci hem "siradaki dugum
// tiklanabilir mi" karari FCharacter.GeneralsSoul'dan okunuyor (CharBaseInfoUpdate index 4).
function soulPaketi(durum) {
  let s = NaN;
  if (durum && Number.isFinite(Number(durum.generalsSoul))) s = Number(durum.generalsSoul);
  if (!Number.isFinite(s)) { try { s = Number(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).generalsSoul); } catch (e) { } }
  if (!Number.isFinite(s)) s = 999999;
  return require('./harita').baseInfoUpdate([{ index: 4, v: s >>> 0 }]);
}

// ================== GUNLUK ODULLER (DailyWelfare) ==================
// Durum gunluk sifirlanir. getback: 4 bitlik "alinabilir", welfare: 3 bitlik "alinmis".
// InforRet maskA bit0-3 = GetBack kilitli, bit4-6 = Welfare alinmis; maskB bit0-3 = alinabilir.
// GetBack Status = bitB - bitA (1 alinabilir / 0 alinmis / -1 kilitli).
function gunTarihi() { return require('./paket').gun(); }   // yerel tarih (client ile ayni "bugun")
function gunlukDurum(durum, kaydet) {
  const bugun = gunTarihi();
  if (!durum.gunluk || durum.gunluk.gun !== bugun) {
    durum.gunluk = { gun: bugun, getback: 0x0f, welfare: 0 };   // hepsi alinabilir
    try { kaydet(durum); } catch (e) { }
  }
  return durum.gunluk;
}
// InforRet'te WorldBossLv=0 gonderiyoruz: client "seviyem >= WorldBossLv" dalina girip odulu
// GUMUS olarak gosteriyor. Boylece Experience (delta + seviye atlama round-trip'i) yolundan kaciniyoruz.
function gunlukPaket(d, inforMu) {
  const w = new W();
  if (!inforMu) w.u32(0);      // claim cevaplarinda hata kodu VAR, InforRet'te YOK
  else w.u32(0);               // InforRet'in ilk alani WorldBossLv (0 -> gumus dali)
  let maskA = 0, maskB = 0;
  for (let i = 0; i < 4; i++) if ((d.getback >> i) & 1) maskB |= (1 << i);   // alinabilir
  for (let i = 0; i < 3; i++) if ((d.welfare >> i) & 1) maskA |= (1 << (i + 4));
  w.u8(maskA & 0x7f); w.u8(maskB & 0x7f);
  return w.done();
}
let DGB = null, DWR = null;
function gunlukTablo() {
  if (DGB) return { DGB, DWR };
  const oku = f => { try { return JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', f), 'utf8')); } catch (e) { return []; } };
  DGB = new Map(oku('DailyGetBackReward.json').map(r => [parseInt(r.id, 16) >>> 0, r]));
  DWR = new Map(oku('DailyWelfareReward.json').map(r => [parseInt(r.id, 16) >>> 0, r]));
  return { DGB, DWR };
}
function anaSeviye() {
  try { return Math.max(1, Math.min(Number(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).level) || 99, 160)); }
  catch (e) { return 99; }
}
// GetBack kalem -> DailyGetBackReward alan cifti (TDailyGetBackReward.Reward_Gold sirasi).
// Bedava alim WelFare_Free=50 -> x0.5, altinla alim x1.0. *_Gold sutunlari GUMUS anlamina geliyor.
const GB_ALAN = ['monster_Gold', 'orgBattle_Gold', 'orgDefence_Gold', 'traitor_Gold'];
function getBackOdul(kalem, payMode) {
  const { DGB } = gunlukTablo();
  const r = DGB.get(anaSeviye());
  if (!r) return 0;
  const ham = Number(r[GB_ALAN[kalem]]) || 0;
  return Math.max(0, Math.round(ham * (payMode === 2 ? 1 : 0.5)));
}
// Welfare kod 1..5 -> ConfigValue WelFare_acquire oranlari [[0,100],[0,120],[0,160],[20,600],[80,800]]
const WELFARE_ORAN = [100, 120, 160, 600, 800];
function welfareOdul(kod) {
  const { DWR } = gunlukTablo();
  const r = DWR.get(10000000 + anaSeviye());
  if (!r) return 0;
  const oran = WELFARE_ORAN[Math.max(0, Math.min(kod - 1, 4))] || 100;
  return Math.max(0, Math.round((Number(r.gold) || 0) * oran / 100));
}
// Odulu GERCEKTEN hesaba isle; paket oyun-sunucu tarafindan ayrica gonderilir.
let SON_PARA = null;
function paraVer(gumus) {
  SON_PARA = null;
  if (!(gumus > 0)) return;
  try { SON_PARA = paraIcinOdul([{ type: 0, code: 0, amount: gumus }]); } catch (e) { }
}
function sonParaPaketi() { const p = SON_PARA; SON_PARA = null; return p; }

// CustomHeros tablosu (CONST_DATEBASEVO RESOURCEID_Base+281). 138 satir; hepsi RoleModel ve
// BaseHero'da da mevcut oldugu icin yapisal olarak guvenli.
let CUSTOM_HERO = null;
function customHeroIds() {
  if (CUSTOM_HERO) return CUSTOM_HERO;
  CUSTOM_HERO = [];
  try {
    for (const r of JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'CustomHeros.json'), 'utf8'))) {
      const id = parseInt(r.id, 16) >>> 0;
      if (id) CUSTOM_HERO.push(id);
    }
  } catch (e) { }
  console.log(`[panel] CustomHeros: ${CUSTOM_HERO.length} karakter`);
  return CUSTOM_HERO;
}

// --- PARA odulleri: GERCEKTEN hesaba isle (SC_Account_CharBaseInfoUpdate 0x01180105) ---
// Hangi (type,code) hangi para birimi: CONST_COMMON.REWARDID_TOMAINCODE/TOSUBCODE -> REWARDID_DATA
// -> Article isimleri. REWARDIDNotInventory_DATA bunlarin item DEGIL para oldugunu dogruluyor.
//   t0/0 Silver, t0/1 Gold, t0/2 Coupon, t2/0 EXP, t5/0 Prestige, t6/0 Soul,
//   t7/3-6 Blue/Purple/Golden/Red Reishi.  (t3/0 Vitality: BaseInfo karsiligi yok -> atlanir)
// Paket girdisi SABIT 13 bayt: u8 index + 3 x u32 (her okuyucu tam 3 readUnsignedInt yapiyor;
// yakalanan 74 gercek pakette hepsi 15B = 2 + 13 ile dogrulandi).
// SilverCoin (index 0) TEK ISTISNA: once High sonra Low okunuyor.
const PARA = {
  '0:0': { idx: 0, alan: 'gumus', cift: true },
  '0:1': { idx: 3, alan: 'altin' },
  '0:2': { idx: 1, alan: 'kupon' },
  '3:0': { idx: 2, alan: 'askeriEmir' },   // "Vitality" (Article 14100028) = HUD'daki Vitality = MilitaryOrders
  '2:0': { idx: 11, alan: 'deneyim' },
  '5:0': { idx: 5, alan: 'prestij' },
  '6:0': { idx: 4, alan: 'generalsSoul' },
  '7:3': { idx: 7, alan: 'blueSoul' },
  '7:4': { idx: 8, alan: 'purpleSoul' },
  '7:5': { idx: 9, alan: 'goldSoulV' },
  '7:6': { idx: 10, alan: 'orangeSoul' },
};
const PARA_TAVAN = 2000000000;   // u32 tasmasin
// EXP (2:0) ISTISNA: client index 11'i DELTA olarak okur ve kadrodaki her heroya ekler;
// seviye atlama seviye.js'te hesaplanip KALICI yazilir (ana hero veri.json level/deneyim,
// partnerler durum.seviye). ESKIDEN birikimli toplam delta diye yollaniyordu (exp katlaniyordu)
// ve seviye hic hesaplanmiyordu.
function paraIcinOdul(awards, durum = null, options = {}) {
  const yol = require('./runtime-path')('veri.json');
  let v; try { v = JSON.parse(fs.readFileSync(yol, 'utf8')); } catch (e) { return null; }
  const guncel = [];
  // Reuse the handler state so its later save retains EXP, pending upgrades and inventory.
  let durumMod = null, d = durum, durumDegisti = false;
  for (const a of (awards || [])) {
    const p = PARA[(a.type || 0) + ':' + (a.code || 0)];
    if (!p) continue;
    const kazanc = Math.max(0, Number(a.amount) || 0);
    if (!kazanc) continue;
    if (p.alan === 'deneyim') {
      try {
        durumMod = durumMod || require('./durum');
        d = d || durumMod.yukle();
        const r = seviye.expEkle(d, kazanc, v);        // v uzerinde level/deneyim guncellenir
        durumDegisti = true;
        const atlayan = r.filter(x => x.atladi > 0);
        if (atlayan.length) console.log(`[seviye] +${kazanc} exp -> seviye atladi: ${atlayan.map(x => x.id + '->lv' + x.lv).join(', ')} (client sorunca bildirilir)`);
      } catch (e) { console.log('[seviye] exp hatasi: ' + e.message); }
      guncel.push({ index: p.idx, v: kazanc });         // DELTA
      continue;
    }
    const yeni = Math.min(PARA_TAVAN, Math.max(0, Number(v[p.alan]) || 0) + kazanc);
    v[p.alan] = yeni;
    // Silver: v=High, a=Low ; digerleri: v=deger
    guncel.push(p.cift ? { index: p.idx, v: Number(v.gumusHigh) || 0, a: yeni } : { index: p.idx, v: yeni });
  }
  if(options.refund)require('./ultimate-bp-spending').refund(v,(awards||[]).filter(a=>a.type===0&&a.code===1).reduce((n,a)=>n+a.amount,0));
  if (!guncel.length) return null;
  try { fs.writeFileSync(yol, JSON.stringify(v, null, 2)); } catch (e) { }   // kalici birikim
  if (durumDegisti && d) { try { durumMod.kaydet(d); } catch (e) { } }
  return require('./harita').baseInfoUpdate(guncel);
}
// --- PARA HARCAMA: bedeli hesaptan dus (yetersizse null, hicbir sey degismez) ---
// awards ayni bicim ({type,code,amount}); EXP harcanamaz. Donus: CharBaseInfoUpdate paketi.
function paraHarca(awards, options = {}) {
  const yol = require('./runtime-path')('veri.json');
  let v; try { v = JSON.parse(fs.readFileSync(yol, 'utf8')); } catch (e) { return null; }
  const sums=new Map();
  for(const a of awards||[]){const p=PARA[(a.type||0)+':'+(a.code||0)];if(!p||p.alan==='deneyim'||!Number.isSafeInteger(a.amount)||a.amount<0)return null;const entry=sums.get(p.alan)||{p,bedel:0};entry.bedel+=a.amount;sums.set(p.alan,entry);}
  const kalemler=[...sums.values()];
  if(kalemler.some(({p,bedel})=>!Number.isSafeInteger(bedel)||(Number(v[p.alan])||0)<bedel))return null;
  if (!kalemler.length) return null;
  const guncel = [];
  for (const { p, bedel } of kalemler) {
    const yeni = Math.max(0, (Number(v[p.alan]) || 0) - bedel);
    v[p.alan] = yeni;
    guncel.push(p.cift ? { index: p.idx, v: Number(v.gumusHigh) || 0, a: yeni } : { index: p.idx, v: yeni });
  }
  if(!options.rollback)require('./ultimate-bp-spending').earn(v,kalemler.filter(x=>x.p.alan==='altin').reduce((n,x)=>n+x.bedel,0));
  if (kalemler.some(({p, bedel}) => bedel > 0 && ['altin','kupon'].includes(p.alan))) {
    const day = require('./paket').gun();
    const ledger = v.dailyTaskSpending && v.dailyTaskSpending.day === day ? v.dailyTaskSpending : {day, count:0};
    ledger.count++; v.dailyTaskSpending = ledger;
  }
  try { fs.writeFileSync(yol, JSON.stringify(v, null, 2)); } catch (e) { return null; }
  return require('./harita').baseInfoUpdate(guncel);
}
function paraEksik(awards) {
  const yol = require('./runtime-path')('veri.json');
  let v; try { v = JSON.parse(fs.readFileSync(yol, 'utf8')); } catch (e) { return 0; }
  for (const a of (awards || [])) {
    const p = PARA[(a.type || 0) + ':' + (a.code || 0)];
    if (!p || p.alan === 'deneyim') continue;
    if ((Number(v[p.alan]) || 0) < Math.max(0, Number(a.amount) || 0)) return p.alan === 'altin' ? 16 : 13;
  }
  return 0;
}

// --- GOREVLER: tum gorevleri BITMIS bildir (ozellik kilitlerini acar) ---
// SC_Task_AlreadyFinishTaskRet 0x01181203: i16 n + n x i32 questId  -> TaskState = ALREADYBACK
// SC_Task_AlreadyAcceptTaskRet 0x01181202: u16 n + n x (u32 questId, u16 killTime)
// Client her id icin GetIndexByQuestID + GetQuestByIdentifier yapar; Task DB'de OLMAYAN id
// null doner ve exception atar -> sadece gercek Task.json id'leri gonderilir.
// Yakalanan veri erken oyundandi (1 alinmis + 5 bitmis) -> "Task ... not yet finished" kilidi bundandi.
let GOREV = null;
function gorevPaketleri() {
  if (GOREV) return GOREV;
  let ids = [];
  try {
    ids = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'Task.json'), 'utf8'))
      .map(t => parseInt(t.id, 16) >>> 0).filter(Boolean);
  } catch (e) { }
  const kabul = Buffer.alloc(2); kabul.writeUInt16BE(0, 0);   // alinmis (devam eden) gorev yok
  const biten = Buffer.alloc(2 + ids.length * 4);
  biten.writeInt16BE(ids.length & 0x7fff, 0);
  ids.forEach((id, i) => biten.writeUInt32BE(id >>> 0, 2 + i * 4));
  console.log(`[gorev] ${ids.length} gorev BITMIS olarak bildirilecek (${biten.length}B)`);
  GOREV = { kabul, biten };
  return GOREV;
}

// --- Nemu yardimcilari ---
const NEMU_DEFAULT = 102030; // 0x00018E8E — TWindowWelcome varsayilan kiyafeti
let NEMU_QUESTION = 0x00fa3eb2;
try { const b = fs.readFileSync(path.join(__dirname, 'cevaplar', '0x01186700.bin')); if (b.length >= 8) NEMU_QUESTION = b.readUInt32BE(4); } catch (e) { }
function nemuClothes(durum) { const c = durum && (durum.girlClothesID >>> 0); return c ? c : NEMU_DEFAULT; }
function nemuBaseInfor(durum) {
  const b = Buffer.alloc(8);
  b.writeUInt32BE(nemuClothes(durum), 0);
  b.writeUInt32BE(NEMU_QUESTION >>> 0, 4);
  return b;
}

// Ek moduller (lonca, arena, evcil, ev, ekipman...): moduller.js — ayni byReq tablosuna eklenir.
try {
  const ek = require('./moduller').kur({ W, olay, ekOnce, ekSonra, odulVer, paraHarca, paraEksik, paraIcinOdul, odulBulKesin, envanterDepo, sayacDepo, gunTarihi, seviye, beceri, meyhane, evcil, awardOf });
  let n = 0; for (const [k, f] of Object.entries(ek)) { byReq[k] = f; n++; }
  console.log(`[moduller] ${n} ek handler kaydedildi`);
} catch (e) { console.log('[moduller] yukleme hatasi:', e.message); }

module.exports = { byReq, W, nemuBaseInfor, envanterIcin, envanterIcinOdul, envanterPaketiEkleme, paraIcinOdul, paraHarca, paraEksik, knifeSoulMaliyet, sonParaPaketi, soulPaketi, mentorEtkilesim, awardOf, odulBulKesin, gorevPaketleri, etkinlik, sonClaim, oyuncuSeviyesi, envanterDepo, envanterEkleOdul, meyhane, evcil, gunlukEtkinlik, sayacOku, sayacArtir, seviye, beceri, canta, olay, bleachtrain, odulVer, ekOnce, ekSonra, ekAl, topupUygula, OLAY_TETIK };
