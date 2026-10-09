'use strict';
// ETKINLIK (Activity) SISTEMI — event panelleri, odul alma ve AC/KAPA anahtari.
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// CS 0x01812300 LoadActivityInfoReq (payload yok)
//  -> SC 0x01182300 = [i16 adet] + adet x (u32 wireId, i8 Status, i32 EffectCoolingDown)
//     wireId = HDActivity'nin SATIR id'si (actId DEGIL!). TUnstreamizerActivityAtoms wireId ile
//     HDActivity'yi arar, oradan actId'yi ve kategoriyi (actId - actId%1000) turetir.
//     BU LISTE = etkinligin VAR OLUP OLMADIGI. Listede olmayan id icin InitRet ve
//     AwardStatusChangeNotify client tarafinda SESSIZCE DUSER. Yani ac/kapa = bu liste.
//     EffectCoolingDown = -1 -> sayac yok. Client ayrica HDActivity.playerLv/vipLv suzer.
//
// CS 0x01812302 InitReq = [u32 wireId]
//  -> SC 0x01182302 = [u32 wireId][u16 blokSayisi][blokSayisi x u32 blokTipi] + govdeler
//     tip 1 BoxState : [u16 adet] + adet x (i32 BoxIndex, u32 TypeAcquire, i32 State,
//                                           [u16 kosulAdet] + kosulAdet x u32 Condition)
//     tip 2 Parameter: [u16 adet] + adet x u32
//     TUZAK 1: tipler ONCE topluca yazilir, govdeler SONRA. Ic ice yazmak paneli bozar.
//     TUZAK 2: TypeAcquire 0=Collection 1=Award 2=Buy 3=Mail 4=ShowOnly. Hediye panelleri
//              BoxClassification ile AwardStates'e bakar -> 1 olmali. 0 gonderilirse
//              kutular hicbir listeye girmez ve panel bombos kalir.
//     State: 0 = sart saglanmadi, 1 = alinabilir, -1 = alinmis  (CONST_ACTIVITY_MODE)
//
// CS 0x01812303 OperateReq = [u32 wireId][u32 index]
//  -> SC 0x01182303 = [u32 hata][u32 wireId][u32 promptIndex]
//                     [i16 adet] + adet x (i16 type, u32 code, u32 amount)
//     promptIndex, STRING_ACTIVITY_30 dizisine indekstir; client sinir kontrolu yapiyor -> 0 guvenli.
//
// SC 0x01182305 AwardStatusChangeNotify = [i16 adet] + adet x
//     (u32 wireId, i32 Index, i32 Status, [i16]+i32[] Condition, [i16]+UTF[] Strs)
//     Odulu "alinmis" yapan paket BUDUR; OperateRet tek basina isaretlemiyor.
//     TUZAK: bilinmeyen wireId gelirse client `continue` degil RETURN eder -> o kaydin
//     sonrasindaki TUM durumlar duser. Gonderilen her id acik listede olmali.
// ===================================================================================
const fs = require('fs');
const path = require('path');

const VERI_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json');
const AYAR_DOSYA = path.join(__dirname, 'etkinlikler.json');
const YAKALANAN_LISTE = path.join(__dirname, 'cevaplar', '0x01182300.bin');

const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;

// ---------- BE yazici ----------
class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  i32(v) { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); this.p.push(b); return this; }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.p.push(b); return this; }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(((v | 0) << 16) >> 16); this.p.push(b); return this; }
  i8(v) { const b = Buffer.alloc(1); b.writeInt8(((v | 0) << 24) >> 24); this.p.push(b); return this; }
  utf(s) { const t = Buffer.from(String(s == null ? '' : s), 'utf8'); this.u16(t.length); this.p.push(t); return this; }
  done() { return Buffer.concat(this.p); }
}

// ---------- durum sabitleri (CONST_ACTIVITY_MODE) ----------
const DURUM = { ALINAMAZ: 0, ALINABILIR: 1, ALINMIS: -1 };
const TIP = { COLLECTION: 0, AWARD: 1, BUY: 2, MAIL: 3, SHOWONLY: 4 };
const BLOK = { BOXSTATE: 1, PARAMETER: 2 };

// ---------- katalog: wireId -> etkinlik ----------
let KATALOG = null;
function katalog() {
  if (KATALOG) return KATALOG;
  KATALOG = new Map();
  for (const r of jread(path.join(VERI_JSON, 'HDActivity.json'), [])) {
    const wireId = num(r.id);
    const actId = Number(r.actId) || 0;
    KATALOG.set(wireId, {
      wireId, actId,
      kategori: actId - (actId % 1000),      // CONST_ACTIVITY_MODE.Activity_*
      ad: r.actName,
      playerLv: Number(r.playerLv) || 0,
      vipLv: Number(r.vipLv) || 0,
    });
  }
  return KATALOG;
}

// ---------- ayar (AC/KAPA) ----------
// Ilk calistirmada yakalanan gercek listeden tohumlanir ki davranis bugunkuyle ayni kalsin.
let AYAR = null;
let AYAR_MTIME = 0;
// Ayar dosyasini BASKA BIR SUREC de yaziyor (cikarim/etkinlik-listele.js --baslat).
// Bellekte sabit tutulursa "baslat dedigim an baslasin" calismaz; sunucu degisikligi
// ancak yeniden baslatinca gorurdu. Dosya zamani degistiyse onbellek dusurulur.
function ayarTazele() {
  try {
    const m = fs.statSync(AYAR_DOSYA).mtimeMs;
    if (AYAR && m !== AYAR_MTIME) AYAR = null;      // disaridan degistirilmis -> yeniden oku
    AYAR_MTIME = m;
  } catch (e) { /* dosya yoksa ilk kurulum akisina duser */ }
}
function varsayilanAcikListe() {
  const out = [];
  try {
    const b = fs.readFileSync(YAKALANAN_LISTE);
    const n = b.readInt16BE(0);
    let p = 2;
    for (let i = 0; i < n; i++) { out.push(b.readUInt32BE(p)); p += 9; }   // u32 + i8 + i32
  } catch (e) { }
  return out;
}
function ayar() {
  ayarTazele();
  if (AYAR) return AYAR;
  AYAR = jread(AYAR_DOSYA, null);
  if (!AYAR || !Array.isArray(AYAR.acik)) {
    const k = katalog();
    AYAR = {
      _aciklama: 'Etkinlik ac/kapa. acik[] = oyunda GORUNECEK etkinliklerin wireId listesi ' +
        '(wireId = HDActivity satir id). Buradan cikarirsan etkinlik tamamen kaybolur. ' +
        'hepsiAcik=true yaparsan katalogdaki TUM etkinlikler acilir.',
      hepsiAcik: false,
      acik: varsayilanAcikListe(),
      _katalogNot: 'Tum etkinlikleri gormek icin: node cikarim/etkinlik-listele.js',
    };
    AYAR.acik = AYAR.acik.filter(id => k.has(id));
    ayarKaydet();
  }
  return AYAR;
}
function ayarKaydet() {
  try {
    fs.writeFileSync(AYAR_DOSYA, JSON.stringify(AYAR, null, 2));
    AYAR_MTIME = fs.statSync(AYAR_DOSYA).mtimeMs;   // kendi yazdigimizi "disaridan degisti" sanma
  } catch (e) { }
}
// ---------- ZAMANLAMA ----------
// ayar.zamanlama = { "<wireId>": { baslangic: <ms>, bitis: <ms> } }
// Zamanlanmis bir etkinlik YALNIZ penceresi icindeyken aciktir; pencere gecince
// kendiliginden kapanir. Kapanmis etkinlikte claim de reddedilir (claim() acikMi'ye bakar),
// yani "etkinlik bitti ama odul hala alinabiliyor" acigi olusmaz.
function zamanlamaDepo() { const a = ayar(); a.zamanlama = a.zamanlama || {}; return a.zamanlama; }
function pencere(wireId) { return zamanlamaDepo()[String(wireId >>> 0)] || null; }
/** Kalan sure (ms). Zamanlama yoksa null, suresi dolmussa 0. */
function kalanSure(wireId) {
  const p = pencere(wireId); if (!p) return null;
  return Math.max(0, (Number(p.bitis) || 0) - Date.now());
}

function acikMi(wireId) {
  const id = wireId >>> 0;
  const a = ayar();
  if (!katalog().has(id)) return false;
  const p = pencere(id);
  if (p) {                                   // zamanlanmis: pencere belirleyicidir
    const t = Date.now();
    return t >= (Number(p.baslangic) || 0) && t < (Number(p.bitis) || 0);
  }
  if (a.hepsiAcik) return true;
  return a.acik.includes(id);
}

/** Etkinligi kalici ac/kapat (zamanlama olmadan). Donus: yeni durum. */
function ayarla(wireId, acik) {
  const a = ayar();
  const id = wireId >>> 0;
  const i = a.acik.indexOf(id);
  if (acik && i < 0) a.acik.push(id);
  if (!acik && i >= 0) a.acik.splice(i, 1);
  if (!acik) delete zamanlamaDepo()[String(id)];   // kapatirken zamanlamayi da kaldir
  ayarKaydet();
  return acikMi(id);
}

/**
 * Etkinligi SIMDI baslat ve verilen sure kadar acik tut.
 * or. zamanla(99, 3, 12) -> 3 gun 12 saat.
 * Donus: { wireId, ad, baslangic, bitis, sureMs } | null (bilinmeyen etkinlik)
 */
function zamanla(wireId, gun = 0, saat = 0, dakika = 0) {
  const id = wireId >>> 0;
  const k = katalog().get(id);
  if (!k) return null;
  const sureMs = ((Number(gun) || 0) * 24 * 3600 + (Number(saat) || 0) * 3600 + (Number(dakika) || 0) * 60) * 1000;
  if (sureMs <= 0) return null;
  const t = Date.now();
  zamanlamaDepo()[String(id)] = { baslangic: t, bitis: t + sureMs };
  const a = ayar();
  if (!a.acik.includes(id)) a.acik.push(id);     // liste paketinde gorunsun
  ayarKaydet();
  return { wireId: id, ad: k.ad, baslangic: t, bitis: t + sureMs, sureMs };
}

/** Zamanlamayi iptal et (etkinligi hemen durdur). */
function durdur(wireId) {
  const id = wireId >>> 0;
  delete zamanlamaDepo()[String(id)];
  const a = ayar();
  const i = a.acik.indexOf(id);
  if (i >= 0) a.acik.splice(i, 1);
  ayarKaydet();
  return !acikMi(id);
}

function acikListe() {
  const a = ayar();
  const taban = a.hepsiAcik ? [...katalog().keys()] : a.acik.filter(id => katalog().has(id));
  // zamanlanmislarin suresi dolduysa listeden dus
  return taban.filter(id => acikMi(id));
}

// ---------- KADEMELER: bir etkinligin odul basamaklari ----------
// Client kurali (TProcessorActivityManager.GetConfigByActivityNumber):
//   kategori = actId - actId % 10000  ->  CONFIGS_ID_Vect/CONFIGS_ResourceID_Vect ile
//   konfig TABLOSU bulunur  ->  o tabloda satir ID'si TAM actId olan kayit alinir.
//   (Eskiden yalniz HDLevelGiftBag'e bakiliyordu; awardId eslesmesi tesadufmus.)
// Kategori->tablo haritasi cikarim/... ile uretilip etkinlik-tablolari.json'a yazildi (149 kategori).
//
// Kademe sekilleri tablodan tabloya degisiyor; hepsi destekleniyor:
//   {key, value:[awardId], prompt}      -> HDGBOnline.actAward, HDGBGold, HDGBSevenDay,
//                                          HDFirstPay.returnRate, HDDailyPay.f6, HDSinglePay.f6...
//   {condition, award:[awardId], ...}   -> HDLevelGiftBag.text, HDOrder.f6 (condition DIZI de olabilir)
//   {lv, gold, value:[...]}             -> HDGrowFundLv.f6
//   skaler actAward = <awardId>         -> HDGBOpenSever, HDGBCollectgame (tek odul, kademesiz)
const ODUL_ANAHTAR = ['award', 'value', 'reward', 'awardId', 'awardid', 'awardID'];
// SART = oyuncu seviyesi kapisi. SADECE bunlar; `key` BILEREK yok:
// `key` anlami tablodan tabloya degisiyor (HDGBOnline=cevrimici DAKIKA, HDDailyPay=ALTIN,
// HDGBSevenDay=GUN, HDKillHero=stage id, HDVipBox=VIP seviyesi). Onu seviye sanmak
// "Online Gift Pack" 2. kademesini (key=180) lv99 oyuncuya KALICI KILITLI gosteriyordu.
const SEVIYE_ANAHTAR = ['condition', 'lv', 'level'];
const SKALER_ODUL_ALAN = ['actAward', 'awardId', 'awardID'];

let TABLO_HARITA = null;
function tabloHarita() { return (TABLO_HARITA ||= jread(path.join(__dirname, 'etkinlik-tablolari.json'), {})); }

// Sart degeri OYUNCU SEVIYESI mi, yoksa harcama/gun/stage esigi mi?
// Ozel sunucuda para yatirma/harcama sayaci simule edilmiyor; oyle esikleri kapi yapmak
// odulleri sonsuza kadar kilitler. Bu yuzden yalnizca makul bir SEVIYE gibi duran
// (1..200) esikler kapi sayilir, digerleri 0 (sartsiz) kabul edilir.
// `condition` SAYISINDAN seviye cikarmak yapisal olarak imkansiz — ayni sayi dizisi
// farkli tablolarda bambaska sey demek:
//   HDLevelGiftBag.text          condition 5,10,20..80    = OYUNCU SEVIYESI
//   HDGambling.f6                condition 10,20..100     = GALIBIYET SERISI ("十连胜")
//   NewHalloweenRecharge         condition 200,400..1000  = YUKLENEN ALTIN
//   NewYear.f6                   condition 1,1,1,400,200  = harcama (yaninda cost alani var)
// Bu yuzden kapi kategori KIMLIGINE gore acilir. Simule etmedigimiz bir sayac
// (galibiyet serisi, yukleme, cevrimici dakika, harcama) yuzunden odul KALICI
// kilitlenmemeli; oyle esikler sartsiz (0) sayilir.
const SEVIYE_KATEGORI = new Set([990000]);   // Activity_LevelGiftBag: tek gercek seviye kapisi
const TOPUP_KATEGORI = 130000;               // Activity_FirstPay: HDFirstPay.returnRate.key = toplam yukleme
const BEDEL_ALAN = ['cost', 'gold', 'costScore', 'costChip', 'payGold', 'score', 'price', 'rechargeCondition', 'costFont'];
function sartCoz(x, kategori) {
  if ((kategori >>> 0) === TOPUP_KATEGORI) {
    const esik = Number(x.key);
    return Number.isFinite(esik) && esik > 0 ? esik : 0;
  }
  for (const b of BEDEL_ALAN) if (x[b] !== undefined && x[b] !== null) return 0;
  for (const a of SEVIYE_ANAHTAR) {
    if (x[a] === undefined || x[a] === null) continue;
    if (Array.isArray(x[a])) return 0;                 // or. HDOrder condition:[12,14,18,20] = saatler
    // `lv`/`level` alan ADI zaten seviye diyor; `condition` ise ancak seviye tabanli
    // kategoride seviyedir.
    if (a === 'condition' && !SEVIYE_KATEGORI.has(kategori >>> 0)) return 0;
    const n = Number(x[a]);
    if (!Number.isFinite(n) || n <= 0) continue;
    return n <= 200 ? n : 0;                           // 200 ustu = seviye degil
  }
  return 0;
}
// Odul id'leri duz dizi, tek sayi VEYA IC ICE nesne olabilir:
//   {reward:[21401049]}                      -> HDRecruitPartner.condition
//   {key, value:{awardID:21403500, showID}}  -> KnifeHeroCollect.knifeAward
//   {award:[{rechargeCondition, awardID}]}   -> DayBack.finalGift
function odulIdCoz(x, derinlik = 0) {
  const out = [];
  if (x === null || x === undefined || derinlik > 3) return out;
  if (typeof x === 'number') { if (x > 0) out.push(x); return out; }
  if (Array.isArray(x)) { for (const v of x) out.push(...odulIdCoz(v, derinlik + 1)); return out; }
  if (typeof x !== 'object') return out;
  for (const a of ODUL_ANAHTAR) {
    if (x[a] === undefined || x[a] === null) continue;
    const v = x[a];
    if (typeof v === 'number') { if (v > 0) out.push(v); }
    else out.push(...odulIdCoz(v, derinlik + 1));
    if (out.length) break;
  }
  return out;
}

let KADEME_ONBELLEK = new Map();
function kademeler(wireId) {
  const id = wireId >>> 0;
  if (KADEME_ONBELLEK.has(id)) return KADEME_ONBELLEK.get(id);
  const k = katalog().get(id);
  let out = [];
  const h = k ? tabloHarita()[String(k.kategori)] : null;
  if (k && h && h.tablo) {
    const rows = jread(path.join(VERI_JSON, h.tablo + '.json'), []);
    // satir ID'si = actId (client kurali); yedek: awardId eslesmesi veya tek satirli tablo
    const row = rows.find(r => num(r.id) === k.actId)
      || rows.find(r => Number(r.awardId) === k.actId)
      || (rows.length === 1 ? rows[0] : null);
    if (row) {
      for (const alan of Object.keys(row)) {
        const v = row[alan];
        if (typeof v !== 'string' || !/^\s*[\[{]/.test(v)) continue;   // kok DIZI de NESNE de olabilir
        let t = null; try { t = JSON.parse(v); } catch (e) { continue; }
        if (t && !Array.isArray(t) && typeof t === 'object') t = [t];  // or. DayBack.loginGift = {index,award:[...]}
        if (!Array.isArray(t) || !t.length) continue;
        // eleman kendisi dizi olabilir (DayBack.rechargeGift = [[{...},{...}], ...]) -> duzlestir
        const duz = [];
        for (const x of t) { if (Array.isArray(x)) duz.push(...x); else duz.push(x); }
        const kademeler2 = duz.filter(x => x && typeof x === 'object')
          .map(x => ({ sart: sartCoz(x, k.kategori), awardIdler: odulIdCoz(x) }))
          .filter(x => x.awardIdler.length);
        if (kademeler2.length) { out = kademeler2.map((x, i) => ({ ...x, index: i })); break; }
      }
      // kademesiz tek odul (or. HDGBOpenSever.actAward = 21401010)
      if (!out.length) {
        for (const a of SKALER_ODUL_ALAN) {
          const n = Number(row[a]);
          if (Number.isFinite(n) && n > 0 && odulCoz(n).length) { out = [{ index: 0, sart: 0, awardIdler: [n] }]; break; }
        }
      }
    }
  }
  KADEME_ONBELLEK.set(id, out);
  return out;
}

// ---------- oduller ----------
let ODUL = null;
function odulTablosu() { return (ODUL ||= jread(path.join(__dirname, 'oduller.json'), {})); }
const normOdul = v => (Array.isArray(v) ? v : []).map(x => ({
  type: (Number(x.type) || 0) >>> 0,
  code: (Number(x.code) || 0) >>> 0,
  amount: (Number(x.amount) || 1) >>> 0,
}));
const FIRST_TOPUP_FINAL_AWARD = 21401023;
const DEMON_ICHIGO_TOKEN = 14100331;
/**
 * awardId -> [{type, code, amount}]
 * Award.json'un IKI sutunu var: `fixed` (garantili) ve `f1` (SANSLI HAVUZ).
 * oduller.json'da bunlar ayri duruyor: byId/award = garantili, awardRnd = havuz
 * ([{rate, items:[...]}]). Eskiden yalniz byId/award'a bakiliyordu -> 9923 Award
 * satirinin %92.7'si cozulup 728'i "odul yok" gorunuyordu. awardRnd eklenince %100.
 */
function odulCoz(awardId) {
  const o = odulTablosu();
  const k = String(awardId >>> 0);
  const sabit = (o.byId && o.byId[k]) || (o.award && o.award[k]) || null;
  if (Array.isArray(sabit) && sabit.length) {
    const rewards = normOdul(sabit);
    if ((awardId >>> 0) === FIRST_TOPUP_FINAL_AWARD && !rewards.some(x => x.type === 1 && x.code === DEMON_ICHIGO_TOKEN)) {
      rewards.push({ type: 1, code: DEMON_ICHIGO_TOKEN, amount: 1 });
    }
    return rewards;
  }
  // sansli havuz: rate'lere gore agirlikli tek cekilis
  const havuz = o.awardRnd && o.awardRnd[k];
  if (!Array.isArray(havuz) || !havuz.length) return [];
  const toplam = havuz.reduce((s, x) => s + (Number(x.rate) || 0), 0);
  let r = Math.random() * (toplam > 0 ? toplam : havuz.length);
  for (const x of havuz) {
    r -= (toplam > 0 ? (Number(x.rate) || 0) : 1);
    if (r <= 0) return normOdul(x.items);
  }
  return normOdul(havuz[havuz.length - 1].items);
}
/** Bir kademenin TUM odulleri (birden fazla awardId olabilir), en fazla 64 kalem. */
function kademeOdulleri(kademe) {
  const out = [];
  for (const a of kademe.awardIdler) for (const x of odulCoz(a)) { out.push(x); if (out.length >= 64) return out; }
  return out;
}

// ---------- kalici durum ----------
// durum.etkinlik = { "<wireId>": { alinan: [index, ...] } }
function etkinlikDurum(durum, wireId) {
  durum.etkinlik = durum.etkinlik || {};
  const k = String(wireId >>> 0);
  if (!durum.etkinlik[k] || !Array.isArray(durum.etkinlik[k].alinan)) durum.etkinlik[k] = { alinan: [] };
  return durum.etkinlik[k];
}
function alinmisMi(durum, wireId, index) { return etkinlikDurum(durum, wireId).alinan.includes(index | 0); }

function ilerleme(durum, wireId, fallbackLevel) {
  const k = katalog().get(wireId >>> 0);
  if (k && k.kategori === TOPUP_KATEGORI) return Math.max(0, Number(durum && durum.topup && durum.topup.toplam) || 0);
  return Number(fallbackLevel) || 0;
}

// ---------- durum hesabi: sart saglandi mi, alindi mi ----------
function kademeDurumu(durum, wireId, kademe, seviye) {
  if (alinmisMi(durum, wireId, kademe.index)) return DURUM.ALINMIS;
  return ilerleme(durum, wireId, seviye) >= kademe.sart ? DURUM.ALINABILIR : DURUM.ALINAMAZ;
}

// ---------- PAKETLER ----------
/** SC 0x01182300 — acik etkinlik listesi (= ac/kapa anahtari) */
function listePaketi() {
  const idler = acikListe();
  const w = new W();
  w.i16(idler.length);
  for (const id of idler) { w.u32(id); w.i8(0); w.i32(-1); }   // Status=0, cooldown yok
  return w.done();
}

/** SC 0x01182302 — bir etkinligin kutu durumlari */
function initPaketi(wireId, durum, seviye) {
  const id = wireId >>> 0;
  const kad = kademeler(id);
  const w = new W();
  w.u32(id);
  if (!kad.length) {                       // kademesi cozulemeyen etkinlik: bos ama GECERLI paket
    w.u16(1).u32(BLOK.BOXSTATE);
    w.u16(0);
    return w.done();
  }
  w.u16(1).u32(BLOK.BOXSTATE);             // ONCE tip listesi, SONRA govde
  w.u16(kad.length);
  for (const k of kad) {
    w.i32(k.index);
    w.u32(TIP.AWARD);                      // AwardStates'e girmesi icin 1 SART
    w.i32(kademeDurumu(durum, id, k, seviye));
    w.u16(1).u32(k.sart >>> 0);            // kosul: gereken seviye (panel metninde gosteriliyor)
  }
  return w.done();
}

/**
 * KARMA InitRet: YAKALANAN gercek paketi temel al (blok yapisi client'in bekledigiyle birebir; Chess/
 * TreasureMap/LimitBuy gibi pencereler Parameter blogunu okur, uretilen tek-bloklu paketle parse'da patliyordu),
 * yalniz BoxState girislerinin State alanini KALICI "alindi" kaydimizla yamala.
 * Bilinmeyen blok tipi gelirse yamalama orada durur (o ana kadarki yamalar kalir).
 */
function initPaketiKarma(wireId, yakalanan, durum, seviye) {
  const id = wireId >>> 0;
  const b = Buffer.from(yakalanan);
  try {
    if (b.length < 6 || b.readUInt32BE(0) !== id) b.writeUInt32BE(id, 0);
    const n = b.readUInt16BE(4); const tipler = []; let p = 6;
    for (let i = 0; i < n; i++) { tipler.push(b.readUInt32BE(p)); p += 4; }
    const kad = kademeler(id); const lv = Number(seviye) || 0;
    for (const t of tipler) {
      if (t === BLOK.PARAMETER) { const c = b.readUInt16BE(p); p += 2 + 4 * c; continue; }
      if (t !== BLOK.BOXSTATE) break;
      const c = b.readUInt16BE(p); p += 2;
      for (let i = 0; i < c; i++) {
        const idx = b.readInt32BE(p); const eski = b.readInt32BE(p + 8);
        const k = kad.find(x => x.index === idx);
        let yeni = eski;
        if (alinmisMi(durum, id, idx)) yeni = DURUM.ALINMIS;
        else if (k) yeni = lv >= k.sart ? DURUM.ALINABILIR : DURUM.ALINAMAZ;
        else if (eski === DURUM.ALINMIS) yeni = DURUM.ALINABILIR;   // yakalanan hesap almisti, biz almadik
        b.writeInt32BE(yeni, p + 8);
        p += 12; const kc = b.readUInt16BE(p); p += 2 + 4 * kc;
      }
    }
  } catch (e) { /* bozuk/bilinmeyen yapi: yakalanan oldugu gibi gider */ }
  return b;
}

/** SC 0x01182303 — odul alma cevabi */
function operateRet(hata, wireId, oduller) {
  const w = new W();
  w.u32(hata >>> 0).u32(wireId >>> 0).u32(0);      // promptIndex 0 = guvenli
  const list = Array.isArray(oduller) ? oduller.slice(0, 64) : [];
  w.i16(list.length);
  for (const a of list) { w.i16(a.type & 0xffff); w.u32(a.code >>> 0); w.u32(a.amount >>> 0); }
  return w.done();
}

/** SC 0x01182305 — "bu odul artik alinmis" bildirimi */
function bildirimPaketi(wireId, index, status, kosullar) {
  const w = new W();
  w.i16(1);
  w.u32(wireId >>> 0).i32(index | 0).i32(status | 0);
  const c = Array.isArray(kosullar) ? kosullar : [];
  w.i16(c.length); for (const x of c) w.i32(x | 0);
  w.i16(0);                                         // Strs yok
  return w.done();
}

// ---------- CLAIM ----------
const HATA = { YOK: 0, GENEL: 1, SART_YOK: 80, ALINMIS: 99 };   // ErrorCode.json ile dogrulandi
/**
 * Odul alma. Gereklilik ve "zaten alinmis" kontrolu YAPILIR, sonuc KALICI yazilir.
 * Donus: { hata, oduller, index, wireId, kosullar }
 */
function claim(wireId, index, durum, seviye) {
  const id = wireId >>> 0, i = index | 0;
  if (!acikMi(id)) return { hata: HATA.GENEL, oduller: [], index: i, wireId: id, kosullar: [] };
  const kad = kademeler(id);
  const k = kad.find(x => x.index === i);
  if (!k) return { hata: HATA.GENEL, oduller: [], index: i, wireId: id, kosullar: [] };
  if (alinmisMi(durum, id, i)) return { hata: HATA.ALINMIS, oduller: [], index: i, wireId: id, kosullar: [k.sart] };
  if (ilerleme(durum, id, seviye) < k.sart) return { hata: HATA.SART_YOK, oduller: [], index: i, wireId: id, kosullar: [k.sart] };
  etkinlikDurum(durum, id).alinan.push(i);          // KALICI: durum.kaydet cagrani yapar
  return { hata: HATA.YOK, oduller: kademeOdulleri(k), index: i, wireId: id, kosullar: [k.sart] };
}

module.exports = {
  katalog, ayar, ayarla, acikMi, acikListe, ayarKaydet,
  zamanla, durdur, kalanSure, pencere,
  kademeler, odulCoz, kademeOdulleri,
  listePaketi, initPaketi, initPaketiKarma, operateRet, bildirimPaketi,
  claim, kademeDurumu, alinmisMi, etkinlikDurum,
  DURUM, TIP, BLOK, HATA, AYAR_DOSYA,
};
