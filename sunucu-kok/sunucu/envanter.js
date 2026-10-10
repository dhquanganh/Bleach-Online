'use strict';
// KALICI ENVANTER — kazanilan her esya diske yazilir ve her giriste cantaya geri konur;
// harcanan/kullanilan/satilan esya da KALICI olarak dusulur.
//
// SORUN (bu modul oncesi): odul alinca sunucu yalniz SC_Backpack_InventoryNtf (0x01180f02)
// yolluyordu. O paket esyayi ANLIK gosteriyor ama hicbir yere kaydetmiyor; client girişte
// CS_Backpack_LoadBag (0x01810f00) ile cantayi bastan istiyor ve bizim sunucu ona YAKALANMIS
// eski hesabin cantasini donuyordu. Sonuc: kazanilan her sey relogin'de siliniyordu.
//
// COZUM: verilen esyalar durum.envanter.esyalar'a yazilir, harcananlar durum.envanter.dusulen'e;
// LoadBag cevabi = yakalanan TABAN canta + biriken esyalar - dusulenler.
//
// PAKET (AS3 TProcessorBackpack.PerformPacket_SC_LoadBagResult + TUnstreamizerInventories):
//   SC 0x01180f00 LoadBagResult = [u32 hata][u8 cantaTipi][u16 adet] + adet x 30B InventoryReference
//   SC 0x01180f02 InventoryNtf  = [u8 cantaTipi][u16 adet] + adet x 30B  (ayni instance -> MIKTARI DEGISTIRIR)
//   SC 0x01180f06 ReduceThings  = [u8 cantaTipi][u16 adet] + adet x u32 instanceId (kaydi SILER)
//   InventoryReference = u8 Kategori, u32 IDTemplate, u32 instanceId, u16 Adet,
//                        u8 TimingCategory, u32 timing, 14B kuyruk(sifir)
//   Yakalanan 367 baytlik gercek cevapla BIREBIR dogrulandi: 5 + 2 + 12*30 = 367.
//   NOT: UnstreamizeClassificationInventories akistan 0 BAYT okur — sadece mevcut listeyi
//   kategorilere (Equipment/Gem/Material...) ayirir. Yani TEK bolum gonderilir.
//
// INSTANCE ID: client esyayi instance id ile adresler (kullan/sat/ReduceThings/InventoryNtf
// guncellemesi ProcessorInventoryUpdateByBackpack -> GetInventoryByIdentifier). Eskiden her
// LoadBag'de 1000'den sirali atanan id'ler, oyun icinde gelen odullerde ise rastgele SEQ id'ler
// kullaniliyordu -> ayni esya iki ayri yigin olarak gorunuyor, guncelleme eslesmiyordu.
// Simdi instance id = SABIT fonksiyon(code): hem LoadBag hem oyun ici bildirimler ayni id'yi
// kullanir; client yigini bulup miktari GUNCELLER (ApplianceAssign), bulamazsa yeni ekler.
//
// TUZAK: IDTemplate Article.json'da OLMALI; client Article[IDTemplate].MajorType'i
// null kontrolsuz okuyor (TUnstreamizerInventoryReference:165) -> bilinmeyen id cantayi cokertir.
const fs = require('fs');
const path = require('path');

const TABAN_DOSYA = path.join(__dirname, 'cevaplar', '0x01180f00.bin');
const ARTICLE_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json', 'Article.json');

const GIRIS_BOYU = 30;
const MAX_GIRIS = 2048;          // paket sismesin (250 giris ~ 7.5 KB)
const MAX_ADET = 0xffff;        // Quantity u16
const OP_NTF = 0x01180f02, OP_REDUCE = 0x01180f06;

// ---- Odul (type,code) -> Article template (CONST_COMMON.RewardIDToTemplateID birebir) ----
// type 1/17/21/23: code dogrudan Article; digerleri RW_MAIN/RW_SUB -> RW_DATA ile cevrilir.
const RW_MAIN = [0, 0, 0, 2, 5, 6, 3, 7, 7, 7, 7, 4, 4, 4, 1, 15, 13, 13, 14, 18, 12, 12, 12, 12, 22, 22, 22, 24, 20, 20];
const RW_SUB = [0, 1, 2, 0, 0, 0, 0, 3, 4, 5, 6, 11100101, 11100102, 11200003, 14100021, 12, 8, 9, 0, 24, 6003059, 6003060, 6003061, 6003062, 25, 26, 27, 28, 31, 30];
const RW_DATA = [14100022, 14100023, 14100024, 14100025, 14100026, 14100027, 14100028, 14100061, 14100062, 14100063, 14100064, 14100043, 14100044, 14100045, 14100021, 14100021, 14100075, 14100076, 14100283, 14100293, 14100297, 14100298, 14100299, 14100300, 14100352, 14100353, 14100351, 14140507, 14610000, 14630000];
function odulTemplate(type, code) {
  type = Number(type) || 0; code = Number(code) >>> 0;
  if (type === 1 || type === 17 || type === 21 || type === 23) return code;
  for (let i = 0; i < RW_MAIN.length; i++) if (RW_MAIN[i] === type && RW_SUB[i] === code) return RW_DATA[i];
  return 0;
}

// ---- Article dogrulamasi ----
let ARTICLE = null, ARTICLE_KAT = null, ARTICLE_BILGI = null;
function articleYukle() {
  if (ARTICLE) return;
  ARTICLE = new Set(); ARTICLE_KAT = new Map(); ARTICLE_BILGI = new Map();
  try {
    for (const a of JSON.parse(fs.readFileSync(ARTICLE_JSON, 'utf8'))) {
      const id = parseInt(a.id, 16) >>> 0; if (!id) continue;
      ARTICLE.add(id);
      ARTICLE_KAT.set(id, Number(a.majorType) || 1);
      ARTICLE_BILGI.set(id, {
        id, ad: a.name || '', majorType: Number(a.majorType) || 1, minorType: Number(a.minorType) || 0,
        // Article.json labels after Picture are shifted; follow TArticle.ReadDataByStream.
        itemFunction: Number(a.functionValue) || 0, functionValue: Number(a.f16) || 0,
        heroId: Number(a.f16) || 0, f16: Number(a.f16) || 0,
        sellPrice: Number(a.itemFunction) || 0, costPrice: Number(a.sellPrice) || 0,
        overlay: Number(a.overlayNumber) || 1, level: Number(a.level) || 1,
        usable: String(a.costPrice || '').split('_')[0] === '1', description: a.functionDesc || '', quality: Number.isFinite(Number(a.quality)) ? Number(a.quality) : 1,
      });
    }
  } catch (e) { }
}
function articleSet() { articleYukle(); return ARTICLE; }
function kategoriBul(idTemplate) { articleYukle(); return ARTICLE_KAT.get(idTemplate >>> 0) || 1; }
function article(idTemplate) { articleYukle(); return ARTICLE_BILGI.get(idTemplate >>> 0) || null; }
/** Sabit, benzersiz instance id (code'dan turetilir). */
function instanceOf(code) { return (0x10000000 + ((code >>> 0) & 0x0fffffff)) >>> 0; }

// EKIPMAN KANCASI: kategori 2/4/6 (ekipman/hazine/sus) esyalari yigin degil AYRI ORNEK (seviye, tas...)
// -> ekipman.js yonetir. Buradaki fonksiyonlar bu kategorileri kancaya devreder.
let KANCA = null;
function kancaAyarla(k) { KANCA = k; }
function kancaKat(code) { return !!(KANCA && KANCA.kategoriler.has(kategoriBul(code))); }

// ---- TABAN canta: yakalanan gercek cevaptan cozulur (oyuncunun baslangic esyalari) ----
let TABAN = null;
function taban() {
  if (TABAN) return TABAN;
  TABAN = [];
  try {
    const b = fs.readFileSync(TABAN_DOSYA);
    let p = 0;
    p += 4;                                   // hata
    p += 1;                                   // cantaTipi
    const n = b.readUInt16BE(p); p += 2;
    for (let i = 0; i < n && p + GIRIS_BOYU <= b.length; i++) {
      TABAN.push({
        kategori: b[p],
        code: b.readUInt32BE(p + 1),
        instance: b.readUInt32BE(p + 5),
        amount: b.readUInt16BE(p + 9),
      });
      p += GIRIS_BOYU;
    }
  } catch (e) { }
  return TABAN;
}

// ---- kalici depo ----
// durum.envanter = { esyalar: [{code, amount}], dusulen: { "<code>": adet }, sonInstance }
function depo(durum) {
  durum.envanter = durum.envanter || {};
  if (!Array.isArray(durum.envanter.esyalar)) durum.envanter.esyalar = [];
  if (!durum.envanter.dusulen || typeof durum.envanter.dusulen !== 'object') durum.envanter.dusulen = {};
  if (!Number.isFinite(Number(durum.envanter.sonInstance))) durum.envanter.sonInstance = 5000;
  return durum.envanter;
}

/**
 * Odul listesinden esyalari kalici envantere ekler (ayni IDTemplate istiflenir).
 * Girdi {type, code, amount}: type verilmisse odulTemplate ile Article'a cevrilir.
 * Donus: gercekten eklenen [{code, amount}] (envanterNtf icin de kullanilir).
 * Article'da olmayan / para birimi (code=0) girdiler ATLANIR — para ayri islenir.
 */
function ekle(durum, oduller) {
  const art = articleSet();
  const d = depo(durum);
  const eklenen = [];
  for (const a of (oduller || [])) {
    if (!a) continue;
    const code = (a.type !== undefined && a.type !== null) ? odulTemplate(a.type, a.code) : ((a.code || 0) >>> 0);
    if (!code || !art.has(code)) continue;              // para birimi veya gecersiz sablon
    const adet = Math.max(1, Number(a.amount) || 1);
    if (kancaKat(code)) { const insts = KANCA.ekle(durum, code, adet); if (insts.length) eklenen.push({ code, amount: insts.length, insts }); continue; }
    // once dusulen bakiyesini geri kapat (ayni esya harcanip tekrar kazanildiysa)
    let kalanAdet = adet;
    const dk = String(code);
    if (Number(d.dusulen[dk]) > 0) {
      const geri = Math.min(Number(d.dusulen[dk]), kalanAdet);
      d.dusulen[dk] -= geri; kalanAdet -= geri;
      if (d.dusulen[dk] <= 0) delete d.dusulen[dk];
    }
    if (kalanAdet > 0) {
      let kayit = d.esyalar.find(x => (x.code >>> 0) === code);
      if (kayit) kayit.amount = Math.min(MAX_ADET, (Number(kayit.amount) || 0) + kalanAdet);
      else {
        if (d.esyalar.length >= MAX_GIRIS) continue;      // canta dolu
        kayit = { code, amount: Math.min(MAX_ADET, kalanAdet) };
        d.esyalar.push(kayit);
      }
    }
    eklenen.push({ code, amount: adet });
  }
  return eklenen;
}

/** Bir esyanin toplam mevcudu (taban + biriken - dusulen). */
function mevcut(durum, code) {
  const c = code >>> 0;
  if (kancaKat(c)) return KANCA.mevcut(durum, c);
  const d = depo(durum);
  let t = 0;
  for (const x of taban()) if ((x.code >>> 0) === c) t += Number(x.amount) || 0;
  for (const x of d.esyalar) if ((x.code >>> 0) === c) t += Number(x.amount) || 0;
  t -= Number(d.dusulen[String(c)]) || 0;
  return Math.max(0, t);
}
/** Esya harca/dus. Yetersizse false (hicbir sey degismez). */
function dus(durum, code, adet, instance) {
  const c = code >>> 0, n = Math.max(0, Math.floor(Number(adet) || 0));
  if (!c || !n) return false;
  if (kancaKat(c)) { if (instance && KANCA.dusInst(durum, instance) && n === 1) return true; return KANCA.dus(durum, c, n); }
  if (mevcut(durum, c) < n) return false;
  const d = depo(durum);
  d.dusulen[String(c)] = (Number(d.dusulen[String(c)]) || 0) + n;
  return true;
}

/** Tam canta listesi: TABAN + biriken - dusulen, istiflenmis, SABIT instance id'li. */
function liste(durum) {
  const d = depo(durum);
  const birlesik = new Map();                            // code -> {kategori, code, amount}
  const it = (code, amount) => {
    const c = code >>> 0;
    const v = birlesik.get(c);
    if (v) v.amount = v.amount + amount;
    else birlesik.set(c, { kategori: kategoriBul(c), code: c, amount });
  };
  for (const x of taban()) it(x.code, Number(x.amount) || 1);
  for (const x of d.esyalar) it(x.code, Number(x.amount) || 1);
  for (const [k, n] of Object.entries(d.dusulen)) { const v = birlesik.get(Number(k) >>> 0); if (v) v.amount -= Number(n) || 0; }
  const out = [];
  for (const x of birlesik.values()) {
    if (!(x.amount > 0)) continue;
    if (KANCA && KANCA.kategoriler.has(x.kategori)) continue;   // ekipman ornekleri kancadan gelir
    x.amount = Math.min(MAX_ADET, x.amount);
    x.instance = instanceOf(x.code);
    out.push(x);
    if (out.length >= MAX_GIRIS) break;
  }
  return out;
}

/** 30 baytlik InventoryReference girisi. */
function giris30(x) {
  const b = Buffer.alloc(GIRIS_BOYU);
  b[0] = (x.kategori || kategoriBul(x.code)) & 0xff;
  b.writeUInt32BE(x.code >>> 0, 1);
  b.writeUInt32BE((x.instance || instanceOf(x.code)) >>> 0, 5);
  b.writeUInt16BE(Math.max(1, Math.min(x.amount || 1, MAX_ADET)), 9);
  // TimingCategory=0 (Permant), timing=0, 14B kuyruk sifir
  return b;
}

/** SC 0x01180f00 LoadBagResult */
function loadBagPaketi(durum, cantaTipi = 0) {
  const esyalar = cantaTipi === 0 ? liste(durum) : [];    // 1 = Temporary (gecici canta bos)
  let ek = [];
  if (cantaTipi === 0 && KANCA) { try { ek = KANCA.cantaKayitlari(durum); } catch (e) { ek = []; } }
  const head = Buffer.alloc(7);
  head.writeUInt32BE(0, 0); head[4] = cantaTipi & 0xff; head.writeUInt16BE(esyalar.length + ek.length, 5);
  return Buffer.concat([head, ...esyalar.map(giris30), ...ek]);
}

/** SC 0x01180f02 InventoryNtf: verilen kalemler (amount = client'in gorecegi TOPLAM, instance sabit).
 *  Kalem Buffer ise (ekipman kaydi) oldugu gibi yazilir. */
function ntfPaketi(items, cantaTipi = 0) {
  const head = Buffer.alloc(3);
  head[0] = cantaTipi & 0xff; head.writeUInt16BE(items.length & 0xffff, 1);
  return Buffer.concat([head, ...items.map(x => Buffer.isBuffer(x) ? x : giris30(x))]);
}
/** SC 0x01180f06 ReduceThings: kayitlari sil. */
function reducePaketi(instances, cantaTipi = 0) {
  const b = Buffer.alloc(3 + 4 * instances.length);
  b[0] = cantaTipi & 0xff; b.writeUInt16BE(instances.length & 0xffff, 1);
  instances.forEach((x, i) => b.writeUInt32BE(x >>> 0, 3 + 4 * i));
  return b;
}
/**
 * Bir esyanin client'taki halini kalici duruma esitleyen paket:
 * mevcut > 0 -> InventoryNtf(toplam), yoksa ReduceThings(instance).
 * instance: client'in istekte bildirdigi id (varsa) — kendi yiginini o id ile tanir.
 */
function guncellemePaketi(durum, code, instance) {
  const c = code >>> 0;
  if (kancaKat(c)) {
    const inst = instance >>> 0;
    if (inst && KANCA.varMi(durum, inst)) return { id: OP_NTF, payload: ntfPaketi([KANCA.kayitBuf(durum, inst)]) };
    return inst ? { id: OP_REDUCE, payload: reducePaketi([inst]) } : null;
  }
  const inst = (instance >>> 0) || instanceOf(c);
  const m = mevcut(durum, c);
  if (m > 0) return { id: OP_NTF, payload: ntfPaketi([{ code: c, amount: m, instance: inst, kategori: kategoriBul(c) }]) };
  return { id: OP_REDUCE, payload: reducePaketi([inst]) };
}
/** Kazanilan esyalar icin InventoryNtf: toplam miktar + sabit instance (client yigini gunceller).
 *  Ekipman kalemleri (insts) tam kayit olarak (seviye/tas kuyrugu ile) yazilir. */
function kazancPaketi(durum, eklenen) {
  const items = [];
  for (const e of (eklenen || [])) {
    const c = e.code >>> 0; if (!c) continue;
    if (Array.isArray(e.insts) && KANCA) { for (const i of e.insts) { const b = KANCA.kayitBuf(durum, i); if (b) items.push(b); } continue; }
    const m = durum ? mevcut(durum, c) : 0;
    items.push({ code: c, amount: Math.max(m, Number(e.amount) || 1), instance: instanceOf(c), kategori: kategoriBul(c) });
  }
  return items.length ? ntfPaketi(items) : null;
}

function ozet(durum) {
  const d = depo(durum);
  const toplam = d.esyalar.reduce((s, x) => s + (Number(x.amount) || 0), 0);
  const dusulen = Object.values(d.dusulen).reduce((s, x) => s + (Number(x) || 0), 0);
  return { cesit: d.esyalar.length, adet: toplam, dusulen, tabanCesit: taban().length };
}

module.exports = {
  ekle, liste, loadBagPaketi, taban, ozet, depo, articleSet, kategoriBul, article, instanceOf,
  mevcut, dus, giris30, ntfPaketi, reducePaketi, guncellemePaketi, kazancPaketi, odulTemplate,
  OP_NTF, OP_REDUCE, MAX_ADET, kancaAyarla,
};
