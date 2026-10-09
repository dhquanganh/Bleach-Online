'use strict';
// OFFLINE BUNDLE URETICI — Node sunucusunun (oyun-sunucu.js) uretecegi cevaplari
// STATIK olarak pisirip AIR app dizinine yazar. AS3 Sunucu.as bunlari oynatir.
// Cikti: <appdir>/cevaplar/0x<opcode>.bin  (64 yanit + PISMIS char + nemu)  ve  maps.json
//
// Pisirilenler:
//  - 0x01180102.bin : login char paketi (para/VIP/level/herolar enjekte edilmis) -- editChar/injectAll
//  - 0x01186700.bin : Nemu BaseInfor (dinamik) -- handlers.nemuBaseInfor(durum)
//  - 0x01181202/0x01181203 : gorev paketleri (hepsi bitmis) -- handlers.gorevPaketleri
//  - maps.json : { override:{csHex:scHex}, ekstra:{scHex:[..]}, loginPush:[hex], ignore:[hex] }
const fs = require('fs');
const path = require('path');
const harita = require('./harita');
const handlers = require('./handlers');
let durumMod = null; try { durumMod = require('./durum'); } catch (e) {}
let herolar = null;   try { herolar = require('./herolar'); } catch (e) {}

const SUN = __dirname;
const APPDIR = path.join(SUN, '..', 'kaynak', 'login.gogames.me');
const OUT = path.join(APPDIR, 'cevaplar');
fs.mkdirSync(OUT, { recursive: true });

const hx = id => '0x' + (id >>> 0).toString(16).padStart(8, '0');
function veri() {
  try { return JSON.parse(fs.readFileSync(path.join(SUN, 'veri.json'), 'utf8')); }
  catch { return { altin: 999999999, gumus: 999999999, gumusHigh: 0, kupon: 999999999, askeriEmir: 999999, vipLevel: 10, vipExp: 999999, level: 99 }; }
}
function skipUTF(buf, pos) { const n = buf.readUInt16BE(pos); return pos + 2 + n; }

// --- oyun-sunucu.js editChar ile BIREBIR ---
function editChar(payload) {
  const v = veri();
  const b = Buffer.from(payload);
  const vip = harita.vipSinir(v.vipLevel);
  try {
    let p = 0;
    p += 4; p += 4; p = skipUTF(b, p); p += 4; p += 4; p = skipUTF(b, p); p += 4;
    b.writeUInt32BE((Number(v.rutbe) || 40100036) >>> 0, p); p += 4;
    p += 4;
    b.writeUInt32BE(v.gumusHigh >>> 0, p); p += 4;
    b.writeUInt32BE(v.gumus >>> 0, p);     p += 4;
    b.writeUInt32BE(v.altin >>> 0, p);     p += 4;
    b.writeUInt32BE(v.kupon >>> 0, p);     p += 4;
    b.writeUInt32BE((v.askeriEmir || 0) >>> 0, p); p += 4;
    b.writeUInt32BE(vip >>> 0, p); p += 4;
    b.writeUInt32BE((v.vipExp || 0) >>> 0, p); p += 4;
    p += 2 + 1 + 4;
    let dd = null; try { dd = durumMod && durumMod.yukle(); } catch (e) {}
    if (dd && Number.isFinite(Number(dd.starMapIndex))) b.writeUInt32BE(Number(dd.starMapIndex) >>> 0, p);
    p += 4;
    if (dd && Number.isFinite(Number(dd.generalsSoul))) b.writeUInt32BE(Number(dd.generalsSoul) >>> 0, p);
    else if (v.generalsSoul !== undefined) b.writeUInt32BE(v.generalsSoul >>> 0, p);
    p += 4;
    if (v.blueSoul   !== undefined) b.writeUInt32BE(v.blueSoul   >>> 0, p); p += 4;
    if (v.purpleSoul !== undefined) b.writeUInt32BE(v.purpleSoul >>> 0, p); p += 4;
    if (v.goldSoulV  !== undefined) b.writeUInt32BE(v.goldSoulV  >>> 0, p); p += 4;
    if (v.orangeSoul !== undefined) b.writeUInt32BE(v.orangeSoul >>> 0, p); p += 4;
  } catch (e) { console.log('  [char] duzenleme hatasi:', e.message); return payload; }
  let out = b;
  try { const lv = v.level !== undefined ? v.level : 99; out = harita.seviyeYama(out, lv); }
  catch (e) { console.log('  [char] level hatasi:', e.message); }
  try {
    const hepsi = v.tumKarakterler === true || v.tumKarakterler === 'true';
    const sahip = Array.isArray(v.herolar) ? v.herolar : [];
    if (herolar && (hepsi || sahip.length)) {
      const lv = v.level !== undefined ? v.level : 99;
      const r = herolar.injectAll(out, lv, harita.basicEnd, hepsi ? null : sahip);
      if (r.eklenen) { console.log(`  [char] TUM HEROLAR: +${r.eklenen} hero, paket ${r.buf.length}B`); return r.buf; }
      else console.log(`  [char] hero enjekte atlandi: ${r.hata}`);
    }
  } catch (e) { console.log('  [char] hero enjekte hatasi:', e.message); }
  return out;
}

// 1) mevcut 64 cevap bin'ini kopyala
let kopya = 0;
const srcCev = path.join(SUN, 'cevaplar');
for (const f of fs.readdirSync(srcCev)) {
  if (!f.endsWith('.bin')) continue;
  fs.copyFileSync(path.join(srcCev, f), path.join(OUT, f));
  kopya++;
}
console.log('kopyalanan bin:', kopya);

// 1b) TIMELINE DOLGUSU: timeline'da olup cevaplar/ icinde OLMAYAN opcode'lar.
// Node sunucusu hem cevaplar/ (CEVAP) hem timeline (RESP) kullaniyordu; sadece cevaplar/
// paketlenince 0x01182302 (SC_Activity_InitRet) eksik kaliyor ve client cihazda
// "Currently initializing player data..." ekraninda TAKILIYOR. En zengin payload secilir.
try {
  const tl = JSON.parse(fs.readFileSync(path.join(SUN, 'zaman', 'timeline.json'), 'utf8'));
  const mevcut = new Set(fs.readdirSync(srcCev).filter(f => f.endsWith('.bin')).map(f => f.toLowerCase().replace('.bin', '')));
  const grup = {};
  for (const e of tl) { if (e.dir !== 's2c') continue; const k = String(e.id).toLowerCase(); (grup[k] = grup[k] || []).push(e); }
  let eklendi = 0;
  for (const id of Object.keys(grup)) {
    if (mevcut.has(id)) continue;
    const best = grup[id].reduce((a, b) => (b.len > a.len ? b : a));
    const fp = path.join(SUN, 'zaman', best.file);
    if (!fs.existsSync(fp)) { console.log('  timeline dosyasi yok: ' + best.file); continue; }
    fs.copyFileSync(fp, path.join(OUT, id + '.bin'));
    console.log('  timeline-dolgu: ' + id + ' (' + best.len + 'B, ' + grup[id].length + ' kayit)');
    eklendi++;
  }
  console.log('timeline dolgusu: ' + eklendi + ' opcode');
} catch (e) { console.log('timeline dolgu hatasi: ' + e.message); }

// 2) char paketini PISIR (ham 0x01180102.bin -> editChar) ve uzerine yaz
try {
  const ham = fs.readFileSync(path.join(srcCev, '0x01180102.bin'));
  const pismis = editChar(ham);
  fs.writeFileSync(path.join(OUT, '0x01180102.bin'), pismis);
  console.log('char pismis:', ham.length, '->', pismis.length, 'B');
} catch (e) { console.log('char pisirme hatasi:', e.message); }

// 3) Nemu BaseInfor (dinamik)
try {
  const nemu = handlers.nemuBaseInfor(durumMod ? durumMod.yukle() : {});
  fs.writeFileSync(path.join(OUT, '0x01186700.bin'), nemu);
  console.log('nemu:', nemu.length, 'B');
} catch (e) { console.log('nemu hatasi:', e.message); }

// 4) gorev paketleri (hepsi bitmis)
try {
  const g = handlers.gorevPaketleri();
  if (g.kabul) fs.writeFileSync(path.join(OUT, '0x01181202.bin'), g.kabul);
  if (g.biten) fs.writeFileSync(path.join(OUT, '0x01181203.bin'), g.biten);
  console.log('gorev paketleri yazildi');
} catch (e) { console.log('gorev hatasi:', e.message); }

// 4b) SWF LISTESI: tum kaynak SWF'lerinin goreli yollari -> swflist.json
// Cihazda File.getDirectoryListing() ile taramak APK'nin salt-okunur varlik sisteminde
// TAKILIYOR (icerik SWF'i hic calismiyor, ekran bos kaliyor). Listeyi DERLEME aninda cikar.
try {
  const SWFKOK = path.join(APPDIR, 'public', '2017112917', 'Resources', 'Swf');
  const liste = [];
  (function tara(dizin, onek) {
    if (!fs.existsSync(dizin)) return;
    for (const e of fs.readdirSync(dizin, { withFileTypes: true })) {
      if (e.isDirectory()) tara(path.join(dizin, e.name), onek + e.name + '/');
      else if (e.name.toLowerCase().endsWith('.swf')) liste.push(onek + e.name);
    }
  })(SWFKOK, '');
  fs.writeFileSync(path.join(APPDIR, 'swflist.json'), JSON.stringify(liste));
  console.log('swflist.json yazildi: ' + liste.length + ' SWF');
} catch (e) { console.log('swflist hatasi: ' + e.message); }

// 4c) FIFO VARYANTLARI: ayni opcode'a art arda gelen istekler SIRAYLA farkli cevap alir.
// Node sunucusu boyle calisiyordu (RESP[id][index++]); AS3'e sadece statik tek-cevap
// tasinmisti. Somut kanit: 0x01181e01 (SC_Counter_CounterRet) timeline'da 4 kayit /
// 3 farkli boyut [10,18,2]; tek 18B blob donunce client 0x01811e01'i 4 KEZ tekrarlayip
// sahneyi olduruyordu. Varyantlar <opcode>.NNN.bin olarak yazilir.
const fifo = {};
try {
  const tl2 = JSON.parse(fs.readFileSync(path.join(SUN, 'zaman', 'timeline.json'), 'utf8'));
  const grup2 = {};
  for (const e of tl2) { if (e.dir !== 's2c') continue; const k = String(e.id).toLowerCase(); (grup2[k] = grup2[k] || []).push(e); }
  for (const id of Object.keys(grup2)) {
    const arr = grup2[id];
    if (arr.length < 2) continue;                 // tek kayit -> statik bin yeterli
    let n = 0;
    for (const e of arr) {
      const fp = path.join(SUN, 'zaman', e.file);
      if (!fs.existsSync(fp)) continue;
      const ad = id + '.' + String(n).padStart(3, '0') + '.bin';
      fs.copyFileSync(fp, path.join(OUT, ad));
      n++;
    }
    if (n > 1) { fifo[id] = n; console.log('  fifo: ' + id + ' -> ' + n + ' varyant'); }
  }
  console.log('fifo opcode sayisi: ' + Object.keys(fifo).length);
} catch (e) { console.log('fifo hatasi: ' + e.message); }

// 5) maps.json
const override = {};
for (const [cs, sc] of harita.OVERRIDE.entries()) override[hx(cs)] = hx(sc);
// login + gate override (oyun-sunucu.js OVERRIDE sabiti)
override[hx(0x01810001)] = hx(0x01180102);
override[hx(0x01810000)] = hx(0x01180000);
const ekstra = {};
for (const [t, list] of harita.EKSTRA.entries()) ekstra[hx(t)] = list.map(hx);
const maps = {
  override,
  ekstra,
  loginPush: harita.LOGIN_PUSH.map(hx),
  nemuPush: hx(0x01186700),
  charOpcode: hx(0x01180102),
  ignore: [hx(0x01811800), hx(0x01810505)],
  fifo,
};
fs.writeFileSync(path.join(APPDIR, 'maps.json'), JSON.stringify(maps, null, 2));
console.log('maps.json yazildi: override=' + Object.keys(override).length + ' ekstra=' + Object.keys(ekstra).length + ' loginPush=' + maps.loginPush.length);
console.log('BUNDLE HAZIR ->', OUT);
