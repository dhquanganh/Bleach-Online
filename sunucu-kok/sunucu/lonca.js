'use strict';
// LONCA (Organization, modul 0x2500) + OrgPointMap (0x7800) + PointMapInfoUI (0x7900) + TimeMall (0x7A00)
// + OrganizationWar komutu (0x2700) — tek oyunculu, KALICI lonca.
//
// Kaynak: scratchpad/spec-lonca.md (client AS3'ten byte-byte cikarildi). Ozet protokol:
//  GetGulidInfoReq 0x01812507 -> 0x01182507 (HATA KODU YOK): u32 OrgId; OrgId>0 ise UTF ad, i16 family,
//    u32 para, UTF lider, u32 seviye(1..51), u32 katkim, u32 uyeSayisi, u32 exploit, UTF duyuru, i8 yetki(2=lider),
//    i32 myActive, i32 groupActive, i16 n + n x (u32 tip 1..5, u32 seviye 0..50)
//  ActivityStatusReq 0x01812517 -> 0x01182517 = 7 x i8 (HATA KODU YOK) — login'de SART (yoksa kamp sekmesi NPE)
//  GetCampReq 0x01812508 -> 0x01182508 = u32 hata, i16 3, {1,lv},{2,1},{4,1}  (seviyeler 1..51)
//  LoadMemberListReq 0x01812506 -> 0x01182506 = u32 hata, i16 n, n x (u32 id0,u32 id1,UTF ad,u32 rutbe,u32 seviye,
//    u32 gorev(2 lider),u32 bugunKatki,u32 toplamKatki,u32 sonGiris(0=cevrimici),u32 guc,u32 gunlukAktiflik)
//  LoadGulidListReq 0x01812500 -> 0x01182500 (HATA YOK) = i16 n + n x (u32 id,UTF ad,i16 lv,i16 uye,UTF lider,i8 family)
//  CreateGulidReq 0x01812501 = UTF ad -> 0x01182501 = u32 hata  (client sonra GetGulidInfoReq yollar)
//  UpGradeReq 0x01812503 = u32 tip(1 lonca,2 guard,4 battle) -> 0x01182503 = u32 hata,u32 yeniLv,u32 tip,u32 para
//    bedel: OrganizationBase[yeniLv-1].campUpgradeMoney (lonca parasindan)
//  UpGradeGuildTechReq 0x01812505 = u32 tip(1..5) -> 0x01182505 = u32 hata,u32 tip,u32 yeniLv,u32 exploit
//    bedel: OrganizationAddition[91100001+(lv+1)].<tip>Consume (exploit'ten); tavan 50
//  DonateReq 0x01812514 = u32 altin,u32 gumusBirim(x1000) -> 0x01182514 = u32 hata,u32 katkim,u32 exploit,u32 para
//  LoadGulidDepotReq 0x01812512 -> 0x01182512 = u32 hata,i16 n,n x (u32 kod,u32 article,u32 adet) (article = appliance)
//  AssignGulidDepotReq 0x01812513 = i16 n,n x(u32 kod,u32 article,u32 adet),u32 id0,u32 id1 -> 0x01182513 = u32 hata
//  BoardModifyReq 0x01812518 = UTF -> 0x01182518 = u32 hata, UTF ; GuildLogReq 0x01812519 -> 0x01182519 =
//    u32 hata,i16 n,n x (UTF ozne,u32 fiil(0..5),UTF nesne,u32 zaman,u16 adet)
//  Quit 0x01812515 -> 0x01182515 = u32 hata,u32 0 ; Dismiss 0x01812516 -> 0x01182516 = u32 hata
//  Apply 0x01812502 -> 0x01182502 = u32,u32 ; ApplyList 0x01812504 -> 0x01182504 = u32,i16 0 ;
//  ConfirmApply 0x01812511 -> 0x01182511 = u32,i16 0 ; SwitchPower 0x01812509 -> 0x01182509 = u32 ; Kick 0x01812521 -> u32
//  MuyeBattle 0x01812510 -> 0x01182510 (HATA YOK) = u16 0,u16 0
//  CityDefendInfo 0x01812522 -> 0x01182522 = u32 0,u8 0,UTF "",u8 0,UTF "",u8 0,u16 0,UTF "",u32 0(hero=0!),u32 0,u16 0
//  SingleInit 0x01812523 -> 0x01182523 = u32 hata,i32 acikKopyaIdx ; SingleEnter 0x01812524 = i32 cityId ->
//    0x01182524 = u32 hata,i32 mevcutNokta,i16 n,n x (i32 nokta,i32 savas,i32 sifirlama) (nokta 0..8)
//  GroupInit 0x01812526 -> 0x01182526 = u32 hata,i32 -1,i16 0 ; GroupOpen 0x01812527 = i32 city,i32 idx ->
//    0x01182527 = u32,i32 idx,i32 acilisZamani ; GroupEnter 0x01812528 = i32 city -> 0x01182528 = u32,i32 nokta,i32 hp,i16 0
//  CopyRefresh 0x01812529 = i32 city,i32 idx -> 0x01182529 = u32,i32 idx,i32 zaman
//  OrganizationWar_CommandReq 0x01812700 = u32 cmd,u32 param -> 0x01182700 = u32 hata,u32 cmd,u32 deger
//  Enter_OrganizationWar 0x0181020A -> 0x0118020A = u32 hata (1 = sehirde kal)
//  OrgPointMap: PointRefresh 0x01817801 = i32 city,i32 nokta -> 0x01187801 = i32 hata,i32 sifirlamaSayisi ;
//    GroupChallenge 0x01817803 = i32 city,i32 nokta -> 0x01187803 = i32 hata (ardindan savas) ; QuitMap 0x01817804: CEVAP YOK
//  PointMapInfoUI: Allocation 0x01817900 -> 0x01187900 = i32 0,i16 0 ; Spoils 0x01817901 -> 0x01187901 = i32 0,i16 0,i32 0 ;
//    AttValue 0x01817902 -> 0x01187902 = i32 0,i16 0 ; Apply 0x01817903 -> 0x01187903 = i32 0,i16 0,i32 0 ;
//    ApplyList 0x01817904 -> 0x01187904 = i32 0,i16 0
//  TimeMall: Init 0x01817A00 = i32 tip -> 0x01187A00 = i32 0,i32 tip,i32 0,i32 0,i32 groupMoney,i16 0 ;
//    Refresh 0x01817A01 -> 0x01187A01 = ayni ; Buy 0x01817A02 = i32 tip,i32 id -> 0x01187A02 = i32 hata,i32 tip,i32 id
//
// KALICILIK: durum.lonca = { id, ad, family, seviye, para, duyuru, tech{1..5}, kamp{1,2,4}, depo[], log[],
//   katkim, exploit, myActive, groupActive, groupMoney, kurulus, kopya:{tek:{}, grup:{acik:{}}} }
const fs = require('fs');
const path = require('path');

const V = path.join(__dirname, '..', 'cikarim', 'veri-json');
const jread = (f, d) => { try { return JSON.parse(fs.readFileSync(path.join(V, f), 'utf8')); } catch { return d; } };
const num = h => parseInt(String(h), 16) >>> 0;
const LONCA_ID = 90000001;
const MAX_LONCA_LV = 51, MAX_TECH = 50;
const HATA = { GENEL: 1, PARA: 0x38, GUMUS: 0x0d, YOK: 1 };
const TECH_ALAN = { 1: 'atkConsume', 2: 'physDefConsume', 3: 'magDefConsume', 4: 'lifeConsume', 5: 'speedConsume' };

class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  i32(v) { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); this.p.push(b); return this; }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); this.p.push(b); return this; }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(v | 0); this.p.push(b); return this; }
  u8(v) { this.p.push(Buffer.from([v & 0xff])); return this; }
  utf(s) { const t = Buffer.from(String(s == null ? '' : s), 'utf8'); const b = Buffer.alloc(2); b.writeUInt16BE(t.length); this.p.push(b, t); return this; }
  done() { return Buffer.concat(this.p); }
}
function utfOku(b, p) { const n = b.readUInt16BE(p); return { s: b.toString('utf8', p + 2, p + 2 + n), son: p + 2 + n }; }

let BASE = null, ADD = null;
function baseTablo() { if (!BASE) { BASE = new Map(); for (const r of jread('OrganizationBase.json', [])) BASE.set(Number(r.orgLevel), r); } return BASE; }
function addTablo() { if (!ADD) { ADD = new Map(); for (const r of jread('OrganizationAddition.json', [])) ADD.set(Number(r.orgLevel), r); } return ADD; }

// ---------- durum ----------
function var_(durum) { return !!(durum && durum.lonca && durum.lonca.id); }
function depo(durum) {
  const l = durum.lonca;
  if (!l) return null;
  l.tech = l.tech || { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
  l.kamp = l.kamp || { 1: l.seviye || 1, 2: 1, 4: 1 };
  l.depo = Array.isArray(l.depo) ? l.depo : [];
  l.log = Array.isArray(l.log) ? l.log : [];
  l.kopya = l.kopya || { tek: {}, grup: { acik: {} } };
  l.seviye = Math.max(1, Math.min(Number(l.seviye) || 1, MAX_LONCA_LV));
  return l;
}
function oyuncu(durum) {
  let lv = 1; try { lv = require('./seviye').anaDurum().lv; } catch {}
  let rutbe = 40100036; try { rutbe = Number(JSON.parse(fs.readFileSync(path.join(__dirname, 'veri.json'), 'utf8')).rutbe) || 40100036; } catch {}
  return { id0: (durum.roleIdHi >>> 0) || 0x167, id1: (durum.roleIdLo >>> 0) || 0x04d18922, ad: durum.nick || 'Oyuncu', lv, rutbe, ulke: Number(durum.country) || 0 };
}
function logEkle(l, ozne, fiil, nesne, adet) { l.log.unshift({ ozne, fiil, nesne, zaman: Math.floor(Date.now() / 1000), adet: adet || 0 }); if (l.log.length > 30) l.log.length = 30; }

// ---------- paketler ----------
function bilgiPaketi(durum) {
  const w = new W();
  if (!var_(durum)) return w.u32(0).done();
  const l = depo(durum), o = oyuncu(durum);
  w.u32(l.id).utf(l.ad).i16(l.family || o.ulke).u32(l.para || 0).utf(o.ad).u32(l.seviye).u32(l.katkim || 0).u32(1).u32(l.exploit || 0).utf(l.duyuru || '');
  w.u8(2).i32(l.myActive || 0).i32(l.groupActive || 0);
  w.i16(5); for (let t = 1; t <= 5; t++) { w.u32(t); w.u32(Math.min(MAX_TECH, Number(l.tech[t]) || 0)); }
  return w.done();
}
function aktiviteDurumPaketi() {
  // Flash maps the seven bytes to types [2, 4, 5, 6, 7, 8, 9].
  // Mark the three Evil Spirit factions as joinable for all-day testing.
  return Buffer.from([2, 0, 1, 1, 1, 0, 0]);
}
function kampPaketi(durum) {
  const l = var_(durum) ? depo(durum) : null;
  const w = new W().u32(0).i16(3);
  const lv = t => Math.max(1, Math.min(MAX_LONCA_LV, l ? (Number(l.kamp[t]) || 1) : 1));
  w.u32(1).u32(l ? l.seviye : 1); w.u32(2).u32(lv(2)); w.u32(4).u32(lv(4));
  return w.done();
}
function uyeListesi(durum) {
  const w = new W().u32(0);
  if (!var_(durum)) return w.i16(0).done();
  const l = depo(durum), o = oyuncu(durum);
  let guc = 0; try { guc = require('./statlar').anaKaynak().blok ? 0 : 0; } catch {}
  w.i16(1).u32(o.id0).u32(o.id1).utf(o.ad).u32(o.rutbe).u32(o.lv).u32(2).u32(l.bugunKatki || 0).u32(l.katkim || 0).u32(0).u32(guc).u32(l.myActive || 0);
  return w.done();
}
function loncaListesi(durum) {
  const w = new W();
  if (!var_(durum)) return w.i16(0).done();          // kendi loncan varsa liste ekrani zaten acilmaz
  const l = depo(durum), o = oyuncu(durum);
  return w.i16(1).u32(l.id).utf(l.ad).i16(l.seviye).i16(1).utf(o.ad).u8(l.family || o.ulke).done();
}
function kur(durum, payload) {
  const w = new W();
  if (var_(durum)) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).done() };
  let ad = ''; try { ad = utfOku(payload, 0).s.trim(); } catch {}
  if (!ad || ad.length > 12) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).done() };
  const o = oyuncu(durum);
  durum.lonca = { id: LONCA_ID, ad, family: o.ulke, seviye: 1, para: 0, duyuru: '', tech: { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 }, kamp: { 1: 1, 2: 1, 4: 1 }, depo: [], log: [], katkim: 0, bugunKatki: 0, exploit: 0, myActive: 0, groupActive: 0, groupMoney: 0, kurulus: new Date().toISOString(), kopya: { tek: {}, grup: { acik: {} } } };
  logEkle(durum.lonca, o.ad, 3, ad, 0);            // 3 = "Join Guild"
  return { hata: 0, paket: w.u32(0).done(), ad };
}
function yukselt(durum, tip) {
  const w = new W();
  if (!var_(durum)) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(0).u32(tip).u32(0).done() };
  const l = depo(durum);
  const mevcut = tip === 1 ? l.seviye : Math.max(1, Number(l.kamp[tip]) || 1);
  if (![1, 2, 4].includes(tip) || mevcut >= MAX_LONCA_LV) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(mevcut).u32(tip).u32(l.para).done() };
  if (tip !== 1 && mevcut >= l.seviye) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(mevcut).u32(tip).u32(l.para).done() };
  const yeni = mevcut + 1;
  const r = baseTablo().get(yeni) || {};
  const bedel = Number(tip === 1 ? r.campUpgradeMoney : tip === 2 ? r.muyeguardUpgradeMoney : r.muyebattleUpgradeMoney) || 0;
  if ((l.para || 0) < bedel) return { hata: HATA.GUMUS, paket: w.u32(HATA.GUMUS).u32(mevcut).u32(tip).u32(l.para).done() };
  l.para -= bedel;
  if (tip === 1) { l.seviye = yeni; l.kamp[1] = yeni; } else l.kamp[tip] = yeni;
  return { hata: 0, paket: w.u32(0).u32(yeni).u32(tip).u32(l.para).done(), yeni, bedel };
}
function techYukselt(durum, tip) {
  const w = new W();
  if (!var_(durum) || !TECH_ALAN[tip]) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(tip).u32(0).u32(0).done() };
  const l = depo(durum);
  const lv = Number(l.tech[tip]) || 0;
  if (lv >= MAX_TECH) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(tip).u32(lv).u32(l.exploit).done() };
  const bedel = Number((addTablo().get(lv + 1) || {})[TECH_ALAN[tip]]) || 0;
  if ((l.exploit || 0) < bedel) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(tip).u32(lv).u32(l.exploit).done() };
  l.exploit -= bedel; l.tech[tip] = lv + 1;
  return { hata: 0, paket: w.u32(0).u32(tip).u32(lv + 1).u32(l.exploit).done(), bedel };
}
/** DonateReq. ctx.harca(awards) -> bool */
function bagis(durum, payload, ctx) {
  const w = new W();
  if (!var_(durum) || !payload || payload.length < 8) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).u32(0).u32(0).u32(0).done() };
  const l = depo(durum);
  const altin = payload.readUInt32BE(0), gumusBirim = payload.readUInt32BE(4);
  const gumus = gumusBirim * 1000;
  if (altin > 0) { if (!(ctx && ctx.harca && ctx.harca([{ type: 0, code: 1, amount: altin }]))) return { hata: HATA.PARA, paket: w.u32(HATA.PARA).u32(l.katkim).u32(l.exploit).u32(l.para).done() }; }
  if (gumus > 0) { if (!(ctx && ctx.harca && ctx.harca([{ type: 0, code: 0, amount: gumus }]))) return { hata: HATA.GUMUS, paket: w.u32(HATA.GUMUS).u32(l.katkim).u32(l.exploit).u32(l.para).done() }; }
  // lonca parasi: gumus 1:1/1000 birim -> para, altin x10 (varsayim); katki = para; exploit = para/10
  const para = Math.floor(gumus / 1000) + altin * 10;
  l.para = (l.para || 0) + para; l.katkim = (l.katkim || 0) + para; l.bugunKatki = (l.bugunKatki || 0) + para; l.exploit = (l.exploit || 0) + Math.max(1, Math.floor(para / 10));
  l.myActive = Math.min((l.myActive || 0) + 10, 260);
  l.gunlukGumus = (l.gunlukGumus || 0) + gumus;
  logEkle(l, oyuncu(durum).ad, 5, altin ? 'Altın' : 'Gümüş', altin || gumus);
  return { hata: 0, paket: w.u32(0).u32(l.katkim).u32(l.exploit).u32(l.para).done(), altin, gumus };
}
function depoPaketi(durum) {
  const w = new W().u32(0);
  if (!var_(durum)) return w.i16(0).done();
  const l = depo(durum);
  w.i16(l.depo.length);
  l.depo.forEach((x, i) => { w.u32(x.kod || (i + 1)); w.u32(x.article >>> 0); w.u32(x.adet >>> 0); });
  return w.done();
}
/** AssignGulidDepotReq: [i16 n]+n x(u32 kod,u32 article,u32 adet)+u32 id0,u32 id1. ctx.ver(oduller) */
function depoDagit(durum, payload, ctx) {
  const w = new W();
  if (!var_(durum) || !payload || payload.length < 2) return { hata: HATA.GENEL, paket: w.u32(HATA.GENEL).done() };
  const l = depo(durum);
  const n = payload.readInt16BE(0); const oduller = [];
  for (let i = 0; i < n && 2 + 12 * i + 12 <= payload.length; i++) {
    const o = 2 + 12 * i; const kod = payload.readUInt32BE(o), article = payload.readUInt32BE(o + 4), adet = payload.readUInt32BE(o + 8);
    const k = l.depo.find(x => (x.kod >>> 0) === kod && (x.article >>> 0) === article);
    if (!k || k.adet < adet) continue;
    k.adet -= adet; oduller.push({ type: 1, code: article, amount: adet });
  }
  l.depo = l.depo.filter(x => x.adet > 0);
  if (oduller.length && ctx && ctx.ver) ctx.ver(oduller);
  return { hata: 0, paket: w.u32(0).done(), adet: oduller.length };
}
function duyuru(durum, payload) {
  const w = new W();
  if (!var_(durum)) return w.u32(HATA.GENEL).utf('').done();
  let s = ''; try { s = utfOku(payload, 0).s.slice(0, 180); } catch {}
  depo(durum).duyuru = s;
  return w.u32(0).utf(s).done();
}
function logPaketi(durum) {
  const w = new W().u32(0);
  if (!var_(durum)) return w.i16(0).done();
  const l = depo(durum);
  w.i16(l.log.length);
  for (const x of l.log) { w.utf(x.ozne).u32(Math.max(0, Math.min(5, x.fiil | 0))).utf(x.nesne).u32(x.zaman >>> 0).u16(x.adet || 0); }
  return w.done();
}
function ayril(durum) { delete durum.lonca; return new W().u32(0).u32(0).done(); }
function dagit(durum) { delete durum.lonca; return new W().u32(0).done(); }
function muyeBattle() { return new W().u16(0).u16(0).done(); }
function cityDefend() { return new W().u32(0).u8(0).utf('').u8(0).utf('').u8(0).u16(0).utf('').u32(0).u32(0).u16(0).done(); }
// ---- kopyalar (tek / grup) ----
function tekKopya(durum, cityId) { const l = depo(durum); l.kopya.tek = l.kopya.tek || {}; const k = String(cityId >>> 0); if (!l.kopya.tek[k]) l.kopya.tek[k] = { nokta: 0, savas: {}, sifirlama: {} }; return l.kopya.tek[k]; }
function tekInit(durum) { const w = new W().u32(0); if (!var_(durum)) return w.i32(0).done(); const l = depo(durum); const n = Object.keys(l.kopya.tek || {}).length; return w.i32(Math.min(9, Math.max(0, n - 1))).done(); }
function tekGiris(durum, cityId) {
  const w = new W().u32(0);
  if (!var_(durum)) return w.i32(0).i16(0).done();
  const k = tekKopya(durum, cityId);
  const noktalar = Object.keys(k.savas).map(Number).filter(x => x >= 0 && x <= 8);
  w.i32(Math.max(0, Math.min(8, k.nokta | 0))).i16(noktalar.length);
  for (const n of noktalar) w.i32(n).i32(k.savas[n] | 0).i32(k.sifirlama[n] | 0);
  return w.done();
}
function noktaSifirla(durum, cityId, nokta) { const w = new W(); if (!var_(durum)) return w.i32(HATA.GENEL).i32(0).done(); const k = tekKopya(durum, cityId); k.savas[nokta] = 0; k.sifirlama[nokta] = (k.sifirlama[nokta] | 0) + 1; return w.i32(0).i32(k.sifirlama[nokta]).done(); }
function grupInit(durum) { const w = new W().u32(0); if (!var_(durum)) return w.i32(-1).i16(0).done(); const l = depo(durum); const acik = Object.keys(l.kopya.grup.acik || {}).map(Number).sort((a, b) => a - b); w.i32(-1).i16(acik.length); for (const i of acik) { const g = l.kopya.grup.acik[i]; w.i32(g.savas | 0).i32(g.zaman | 0); } return w.done(); }
function grupAc(durum, cityId, idx) { const w = new W(); if (!var_(durum) || idx < 0 || idx > 9) return w.u32(HATA.GENEL).i32(idx).i32(0).done(); const l = depo(durum); const t = Math.floor(Date.now() / 1000); l.kopya.grup.acik[idx] = { savas: 0, zaman: t }; return w.u32(0).i32(idx).i32(t).done(); }
function grupGiris(durum) { return new W().u32(0).i32(0).i32(100).i16(0).done(); }
function kopyaYenile(durum, cityId, idx) { const w = new W(); const t = Math.floor(Date.now() / 1000); if (var_(durum)) { const l = depo(durum); if (l.kopya.grup.acik[idx]) l.kopya.grup.acik[idx] = { savas: 0, zaman: t }; } return w.u32(0).i32(idx).i32(t).done(); }
function grupMeydan(durum, cityId, idx) { if (var_(durum)) { const l = depo(durum); if (l.kopya.grup.acik[idx]) l.kopya.grup.acik[idx].savas = (l.kopya.grup.acik[idx].savas | 0) + 1; } return new W().i32(0).done(); }
function savasKomut(payload) { const cmd = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0; return new W().u32(0).u32(cmd).u32(0).done(); }
function timeMall(durum, payload) { const tip = payload && payload.length >= 4 ? payload.readInt32BE(0) : 3; const gm = var_(durum) ? (depo(durum).groupMoney || 0) : 0; return new W().i32(0).i32(tip).i32(0).i32(0).i32(gm).i16(0).done(); }
function timeMallSatin(payload) { const tip = payload && payload.length >= 8 ? payload.readInt32BE(0) : 3, id = payload && payload.length >= 8 ? payload.readInt32BE(4) : 0; return new W().i32(HATA.GENEL).i32(tip).i32(id).done(); }

function ozet(durum) { return var_(durum) ? { ad: durum.lonca.ad, seviye: durum.lonca.seviye, para: durum.lonca.para, exploit: durum.lonca.exploit } : null; }

module.exports = {
  var: var_, depo, bilgiPaketi, aktiviteDurumPaketi, kampPaketi, uyeListesi, loncaListesi, kur, yukselt, techYukselt, bagis,
  depoPaketi, depoDagit, duyuru, logPaketi, ayril, dagit, muyeBattle, cityDefend, tekInit, tekGiris, noktaSifirla,
  grupInit, grupAc, grupGiris, kopyaYenile, grupMeydan, savasKomut, timeMall, timeMallSatin, ozet, HATA,
};
