'use strict';
// DIL PAKETI URETICI — SystemLanguage tablosunu cevirip client'in bin paketine CERRAHI olarak yazar.
//
// Client tum arayuz metinlerini Resources/Bin/normal/*.binPackage icindeki SystemLanguage tablosundan
// (dbId = RESOURCEID_Base + 68 = 0x01000044, kayit = u32 id + UTF desc, LITTLE ENDIAN) okur. Ayri bir
// dil dosyasi/CDN klasoru YOK (tek dil: Ingilizce). Bu arac:
//   1) dil/<kod>.json'u okur: { "<SystemLanguage id (hex '00042E32' ya da ondalik)>": "ceviri", ... }
//      Eksik id'ler Ingilizce kalir. Metinlerdeki %0 %1 yer tutuculari ve <font> etiketleri KORUNMALI.
//   2) her surum klasorundeki Bin/normal/*.binPackage'i okur; SystemLanguage blogunu cozer, ceviriyi
//      uygular, yeniden sikistirir; DIGER BLOKLAR bayt-birebir korunur (military-yama.js yontemi).
//   3) sonucu Bin/dil-<kod>/<dosya> olarak yazar. serve.mjs BLEACH_DIL=<kod> ile bu klasoru sunar.
//
// Kullanim:
//   node cikarim/dil-paketle.js --kod tr            # dil/tr.json -> Bin/dil-tr/
//   node cikarim/dil-paketle.js --kod tr --dogrula  # yazmadan cozumle/say (round-trip kontrolu)
//   node cikarim/dil-paketle.js --dok               # SystemLanguage'i dil/en.json olarak dok (ceviri sablonu)
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const ROOT = path.join(__dirname, '..');
const PUBLIC = path.join(ROOT, 'kaynak', 'login.gogames.me', 'public');
const DIL_DIR = path.join(ROOT, 'dil');
const DBID_SYSTEMLANGUAGE = 0x01000000 + 68;

const arg = process.argv.slice(2);
const val = (b, d) => { const i = arg.indexOf(b); return i >= 0 ? arg[i + 1] : d; };
const KOD = String(val('--kod', 'tr')).toLowerCase();
const DOGRULA = arg.includes('--dogrula');
const DOK = arg.includes('--dok');

function bloklar(buf) {
  const out = []; let p = 0;
  const pkgId = buf.readUInt32LE(p); p += 4;
  const n = buf.readUInt16LE(p); p += 2;
  for (let i = 0; i < n; i++) { const len = buf.readUInt32LE(p); p += 4; out.push({ sikisik: buf.subarray(p, p + len) }); p += len; }
  return { pkgId, bloklar: out, kuyruk: buf.subarray(p) };
}
function paketYaz(pkgId, bl, kuyruk) {
  const parts = []; const h = Buffer.alloc(6); h.writeUInt32LE(pkgId >>> 0, 0); h.writeUInt16LE(bl.length, 4); parts.push(h);
  for (const b of bl) { const u = Buffer.alloc(4); u.writeUInt32LE(b.sikisik.length, 0); parts.push(u, b.sikisik); }
  if (kuyruk && kuyruk.length) parts.push(kuyruk);
  return Buffer.concat(parts);
}
// SystemLanguage blogu: u32 dbId, u32 kayit, kayit x (u32 id, u16 len, utf8)
function coz(bin) {
  let p = 0; const dbId = bin.readUInt32LE(p); p += 4; const n = bin.readUInt32LE(p); p += 4;
  const kayitlar = [];
  for (let i = 0; i < n; i++) { const id = bin.readUInt32LE(p); p += 4; const len = bin.readUInt16LE(p); p += 2; kayitlar.push({ id, desc: bin.toString('utf8', p, p + len) }); p += len; }
  if (p !== bin.length) throw new Error(`SystemLanguage coz hatasi: ${p} != ${bin.length}`);
  return { dbId, kayitlar };
}
function kur(dbId, kayitlar) {
  const parts = []; const h = Buffer.alloc(8); h.writeUInt32LE(dbId >>> 0, 0); h.writeUInt32LE(kayitlar.length, 4); parts.push(h);
  for (const k of kayitlar) { const t = Buffer.from(k.desc, 'utf8'); if (t.length > 0xffff) throw new Error('metin cok uzun: ' + k.id); const b = Buffer.alloc(6); b.writeUInt32LE(k.id >>> 0, 0); b.writeUInt16LE(t.length, 4); parts.push(b, t); }
  return Buffer.concat(parts);
}
function ceviriYukle(kod) {
  const f = path.join(DIL_DIR, kod + '.json');
  if (!fs.existsSync(f)) return null;
  const j = JSON.parse(fs.readFileSync(f, 'utf8'));
  const m = new Map();
  for (const [k, v] of Object.entries(j)) { if (k.startsWith('_')) continue; const id = /^[0-9]+$/.test(k) ? Number(k) : parseInt(k, 16); if (id && typeof v === 'string') m.set(id >>> 0, v); }
  return m;
}
function yerTutucuKontrol(orj, yeni) {
  const say = s => (s.match(/%\d/g) || []).sort().join(',');
  return say(orj) === say(yeni);
}

const surumler = fs.readdirSync(PUBLIC).filter(d => fs.existsSync(path.join(PUBLIC, d, 'Resources', 'Bin', 'normal'))).sort();
if (!surumler.length) { console.log('Bin/normal yok'); process.exit(1); }

if (DOK) {
  const s = surumler[surumler.length - 1];
  const dir = path.join(PUBLIC, s, 'Resources', 'Bin', 'normal');
  for (const f of fs.readdirSync(dir).filter(x => x.endsWith('.binPackage'))) {
    const { bloklar: bl } = bloklar(fs.readFileSync(path.join(dir, f)));
    for (const b of bl) { let ham; try { ham = zlib.inflateSync(b.sikisik); } catch { continue; } if (ham.readUInt32LE(0) !== DBID_SYSTEMLANGUAGE) continue;
      const { kayitlar } = coz(ham); const o = { _aciklama: 'SystemLanguage (Ingilizce sablon). Ceviri icin dil/<kod>.json olarak kopyala, degerleri cevir. %0 %1 yer tutuculari ve <font> etiketleri korunmali.' };
      for (const k of kayitlar) o[k.id.toString(16).toUpperCase().padStart(8, '0')] = k.desc;
      fs.mkdirSync(DIL_DIR, { recursive: true }); fs.writeFileSync(path.join(DIL_DIR, 'en.json'), JSON.stringify(o, null, 1));
      console.log(`dil/en.json yazildi: ${kayitlar.length} metin (${f})`); process.exit(0); }
  }
  console.log('SystemLanguage blogu bulunamadi'); process.exit(1);
}

const ceviri = ceviriYukle(KOD);
if (!ceviri) { console.log(`dil/${KOD}.json yok. Once: node cikarim/dil-paketle.js --dok  (sablon) -> dil/${KOD}.json`); process.exit(1); }
console.log(`dil: ${KOD}, ceviri: ${ceviri.size} metin, surumler: ${surumler.join(', ')}${DOGRULA ? '  [dogrula — yazilmaz]' : ''}`);
let toplamUygulanan = 0, atlanan = 0;
for (const s of surumler) {
  const kaynakDir = path.join(PUBLIC, s, 'Resources', 'Bin', 'normal');
  const hedefDir = path.join(PUBLIC, s, 'Resources', 'Bin', 'dil-' + KOD);
  for (const f of fs.readdirSync(kaynakDir).filter(x => x.endsWith('.binPackage'))) {
    const orj = fs.existsSync(path.join(kaynakDir, f + '.orj')) ? path.join(kaynakDir, f) : path.join(kaynakDir, f);   // yamali (military) sürüm kullanılır
    const buf = fs.readFileSync(orj);
    const { pkgId, bloklar: bl, kuyruk } = bloklar(buf);
    let degisti = false, uygulanan = 0;
    for (const b of bl) {
      let ham; try { ham = zlib.inflateSync(b.sikisik); } catch { continue; }
      if (ham.length < 8 || ham.readUInt32LE(0) !== DBID_SYSTEMLANGUAGE) continue;
      const { dbId, kayitlar } = coz(ham);
      if (!kur(dbId, kayitlar).equals(ham)) throw new Error('round-trip tutmadi (coz/kur)');
      for (const k of kayitlar) {
        const y = ceviri.get(k.id >>> 0); if (y === undefined) continue;
        if (!yerTutucuKontrol(k.desc, y)) { atlanan++; continue; }   // yer tutucu sayisi tutmuyor -> guvenli degil, atla
        k.desc = y; uygulanan++;
      }
      const yeniHam = kur(dbId, kayitlar);
      b.sikisik = zlib.deflateSync(yeniHam);
      if (!zlib.inflateSync(b.sikisik).equals(yeniHam)) throw new Error('sikistirma dogrulamasi basarisiz');
      degisti = true;
      console.log(`  ${s}/${f}: SystemLanguage ${kayitlar.length} kayit, ${uygulanan} cevrildi`);
    }
    toplamUygulanan += uygulanan;
    if (DOGRULA) continue;
    fs.mkdirSync(hedefDir, { recursive: true });
    fs.writeFileSync(path.join(hedefDir, f), degisti ? paketYaz(pkgId, bl, kuyruk) : buf);
  }
}
console.log(`${DOGRULA ? 'dogrulandi' : 'yazildi'}: Bin/dil-${KOD}/ | uygulanan ${toplamUygulanan}, yer tutucu uyusmazligi ${atlanan}`);
