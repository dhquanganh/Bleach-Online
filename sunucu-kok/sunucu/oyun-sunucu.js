'use strict';
// Bleach ÖZEL SUNUCU (M1) — yakalanan oturumu replay eder, char paketinde parayı bizim değere çeker.
// Dinler: 10025 (oyun soketi) + 843 (Flash policy). Dosyalar serve.mjs --ozel ile 7420'den.
//
// Strateji: C2S 0x0181abcd -> S2C 0x0118abcd (opcode-swap) + harita.js'teki GERCEK istisnalar
// (or. 0x01810101 -> 0x01180104). Her S2C opcode'u icin yakalanan cevaplar FIFO kuyrukta.
// Login char paketi (0x01180102) gonderilirken altin/gumus/kupon/VIP/level veri.json'dan yazilir.
const net = require('net');
const fs = require('fs');
const path = require('path');
const { parseStream, frame } = require('./cerceve');
const handlers = require('./handlers');
const durumMod = require('./durum');
const LOG = require('./logger');
const savas = require('./savas');
const harita = require('./harita');
const kodek = require('./kodek');
const herolar = require('./herolar');
const gorev = require('./gorev-motor');
const seviye = require('./seviye');
const beceri = require('./beceri');
const meyhane = require('./meyhane');
const karakter = require('./karakter');
const statlar = require('./statlar');

const ROOT = path.join(__dirname, '..');
const TL = path.join(__dirname, 'zaman');
const GATE_PORT = Number(process.env.BLEACH_PORT) || 10025, POLICY_PORT = Number(process.env.BLEACH_POLICY_PORT) || 843;
const olay = handlers.olay;
const POLICY = '<?xml version="1.0"?><cross-domain-policy><allow-access-from domain="*" to-ports="*"/></cross-domain-policy>\0';

const CHAR_ID = 0x01180102;
// Cevaplanmayacak opcode'lar. 0x01810101 artik gercek cevabi (0x01180104) ile yanitlaniyor:
// eskiden yanlis opcode (0x01180101) ile ACK verildigi icin client donguye giriyordu.
// FreshGuide CompleteStep (0x01811800): client bu opcode icin HIC handler kaydetmiyor
// (CONST_NETWORK'te SC_FreshGuide_Base+0 diye bir paket yok) -> cevap beklenmiyor, gonderilen
// paket sessizce dusuyor. Gercek karsiligi char paketindeki FreshGuideProgress UTF alani.
// StopAutoBattle (0x01810505): client durdurma isteğini yollayıp pencereyi KENDİSİ kapatıyor
// (TWindowInstanceAutoBattle.OnSureStop / TProcessorBarrierAutoBattle.OnSureStop -> FStatus =
// AutoStatus_End, Updata()), sunucudan cevap BEKLEMİYOR. Swap kurali bu istege 0x01180505 ile
// cevap veriyordu — o da AutoBattleInfo; elimizde 471B'lik gercek kayit oldugu icin "durdur"a
// basinca taze bir 10 turluk oto-savas donuyor ve ekran bir daha kapanmiyordu.
// Sweeps settle immediately; stopping/speeding up the presentation never starts a battle.
const IGNORE = new Set([0x01811800, 0x01810505, 0x01810506]);
// gecerli-bos cevap: hep sifir (result=0, count=0, UTF bos) -> panel crash'siz acilir
const ZERO_ACK = Buffer.alloc(256);

// --- tum hero roster ID'leri (heroes.json'dan) ---
let HERO_IDS = [];
try {
  const hj = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'veri-json', 'heroes.json'), 'utf8'));
  HERO_IDS = hj.map(h => parseInt(h.id, 16)).filter(n => n > 0);
} catch (e) { }

// char template sabitleri (yakalanan pakette dogrulandi)
const HEROCOUNT_OFF = 117;   // u16 hero sayisi
const HERO_ENTRY_S = 119;    // ilk hero girisi basi
const HERO_ENTRY_E = 510;    // ilk hero girisi sonu (391 bayt)

// char paketine tum heroları enjekte et (opt-in). Ana hero TAM, digerleri MINIMAL
// (ekipman=0, crashjade=0) -> paylasilan instance yok, client repair-loop'a girmez.
const EQCOUNT_REL = 327; // hero girisinde eqCount offset (dogrulandi)
function injectAllHeroes(buf) {
  if (!HERO_IDS.length) return buf;
  const head = buf.subarray(0, HEROCOUNT_OFF);
  const fullEntry = buf.subarray(HERO_ENTRY_S, HERO_ENTRY_E); // ana hero tam giris
  const tail = buf.subarray(HERO_ENTRY_E);
  const prefix = fullEntry.subarray(0, EQCOUNT_REL);          // stat+skill+growrate (eqCount oncesi)
  const ZERO4 = Buffer.from([0, 0, 0, 0]);                    // eqCount=0 + cjCount=0
  const mainId = buf.readUInt32BE(HERO_ENTRY_S);
  const ids = [mainId, ...HERO_IDS.filter(id => id !== mainId)];
  const parts = [head];
  const cnt = Buffer.alloc(2); cnt.writeUInt16BE(ids.length & 0xffff); parts.push(cnt);
  for (const id of ids) {
    if (id === mainId) { parts.push(fullEntry); continue; } // ana hero tam
    const e = Buffer.from(prefix);       // minimal giris
    e.writeUInt32BE(id >>> 0, 0);        // hero Identifier
    e[17] = 0;                            // FightPosition=0
    parts.push(e); parts.push(ZERO4);    // ekipman=0, crashjade=0
  }
  parts.push(tail);
  return Buffer.concat(parts);
}

function veri() {
  try { return JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')); }
  catch { return { altin: 999999999, gumus: 999999999, gumusHigh: 0, kupon: 999999999, askeriEmir: 999999, vipLevel: 10, vipExp: 999999, level: 99 }; }
}

// timeline'dan S2C cevaplarini opcode -> [payload...] kuyruguna yukle
function loadResponses() {
  const tl = JSON.parse(fs.readFileSync(path.join(TL, 'timeline.json'), 'utf8'));
  const q = {};       // idHex -> [Buffer]
  for (const e of tl) {
    if (e.dir !== 's2c') continue;
    const p = fs.readFileSync(path.join(TL, e.file));
    (q[e.id] ||= []).push(p);
  }
  return q;
}

// UTF alanini atla (u16 len + bytes)
function skipUTF(buf, pos) { const n = buf.readUInt16BE(pos); return pos + 2 + n; }

// char paketinde parayi/VIP/level'i duzenle (TUnstreamizerCharacter.BasicProperties sirasi)
function editChar(payload) {
  const v = veri();
  const vip = harita.vipSinir(v.vipLevel);
  let dd = null; try { dd = durumMod.yukle(); } catch (e) { }   // kalici oyuncu durumu (kadro/beceri/seviye/partner)
  // Karakter yaratmada secilen isim + protagonist (nick UTF yeniden kurulur, ana hero id/meslek/beceri)
  const skipHeroFields = process.env.BLEACH_DIAGNOSTIC_SKIP_HERO_FIELDS === '1';
  let b = Buffer.from(payload);
  if (process.env.BLEACH_ACCOUNT_DIR && dd && dd.agentUserId) {
    const oldEnd = skipUTF(b, 8), user = Buffer.from(String(dd.agentUserId), 'utf8'), field = Buffer.alloc(2 + user.length);
    field.writeUInt16BE(user.length); user.copy(field, 2);
    b = Buffer.concat([b.subarray(0, 8), field, b.subarray(oldEnd)]);
    const roleOffset = 8 + field.length;
    b.writeUInt32BE(dd.roleIdHi >>> 0, roleOffset); b.writeUInt32BE(dd.roleIdLo >>> 0, roleOffset + 4);
  }
  if (!skipHeroFields) {
    try { b = karakter.charYama(b, dd, harita.basicEnd); } catch (e) { console.log('  [char] karakter yama hatasi:', e.message); }
  }
  try {
    let p = 0;
    p += 4;               // AgentOperatorId
    p += 4;               // ServerId
    p = skipUTF(b, p);    // AgentUserId
    p += 4; p += 4;       // RoleId hi/lo
    p = skipUTF(b, p);    // NickName
    p += 4;               // Country
    // Replace captured account rank AND prestige using this account's saved state.
    b.writeUInt32BE(require('./military-rank').id(dd || {}, v), p); p += 4;
    b.writeUInt32BE(require('./military-rank').prestige(dd || {}, v), p); p += 4; // Prestige
    b.writeUInt32BE(v.gumusHigh >>> 0, p); p += 4;   // SilverCoin.High
    b.writeUInt32BE(v.gumus >>> 0, p); p += 4;   // SilverCoin.Low
    b.writeUInt32BE(v.altin >>> 0, p); p += 4;   // CreditGold  <<<
    b.writeUInt32BE(v.kupon >>> 0, p); p += 4;   // GiftCertificate
    b.writeUInt32BE((v.askeriEmir || 0) >>> 0, p); p += 4; // MilitaryOrders
    b.writeUInt32BE(vip >>> 0, p); p += 4;                  // VipLevel (VipConfig 0..VIP_MAX)
    b.writeUInt32BE((v.vipExp || 0) >>> 0, p); p += 4;     // VipExp
    // devam: BackpackCapacity(u16)+Expand(u8)+TownID(u32) atla
    if (dd && dd.backpack) { b.writeUInt16BE(Math.min(65535,dd.backpack.capacity),p); b[p+2]=dd.backpack.count&255; }
    p += 2 + 1 + 4;
    // StarMapIndex: Soul Map ilerlemesi. ONCEDEN ATLANIYORDU -> her login'de yakalanan hesabin
    // degeri geliyordu, kaydettigimiz ilerleme client'a HIC ulasmiyordu ("kaydetmiyor" sikayeti).
    if (dd && Number.isFinite(Number(dd.starMapIndex))) b.writeUInt32BE(Number(dd.starMapIndex) >>> 0, p);
    p += 4;                                                                             // StarMapIndex
    // GeneralsSoul harcanabilir: once kalici durum, yoksa veri.json
    if (dd && Number.isFinite(Number(dd.generalsSoul))) b.writeUInt32BE(Number(dd.generalsSoul) >>> 0, p);
    else if (v.generalsSoul !== undefined) b.writeUInt32BE(v.generalsSoul >>> 0, p);
    p += 4;                                                                             // GeneralsSoul
    if (v.blueSoul !== undefined) b.writeUInt32BE(v.blueSoul >>> 0, p); p += 4;     // HeroSoulBlueSoul
    if (v.purpleSoul !== undefined) b.writeUInt32BE(v.purpleSoul >>> 0, p); p += 4;     // HeroSoulPurpleSoul
    if (v.goldSoulV !== undefined) b.writeUInt32BE(v.goldSoulV >>> 0, p); p += 4;     // HeroSoulGoldSoul
    if (v.orangeSoul !== undefined) b.writeUInt32BE(v.orangeSoul >>> 0, p); p += 4;     // HeroSoulOrangeSoul
    console.log(`  [char] altin=${v.altin} gumus=${v.gumus} kupon=${v.kupon} vip=${vip}${v.vipLevel !== vip ? ` (istenen ${v.vipLevel}, max ${harita.VIP_MAX})` : ''} ruhlar yazildi`);
  } catch (e) {
    console.log('  [char] duzenleme hatasi:', e.message, '- ham paket gonderiliyor');
    return payload;
  }
  // ANA HERO (KALICI): seviye + exp (veri.json level/deneyim — seviye.js), kadro pozisyonu
  // (durum.kadro), secili Soul Skill (durum.beceri.ana). THero.Level = max(HistoryMaxLevel, RebirthLevel).
  // ESKIDEN yalniz level yaziliyordu; exp/pozisyon/beceri her giriste yakalanan hesabin degerine donuyordu.
  let out = b;
  let sv = seviye.anaDurum(v);
  try {   // eski kayitlarda birikmis exp (deneyim >= need) -> seviyeye cevir (eski surum exp'i biriktiriyordu)
    const n = seviye.ilerlet(sv.lv, sv.exp);
    if (n.lv !== sv.lv || n.exp !== sv.exp) { v.level = n.lv; v.deneyim = n.exp; seviye.veriYaz(v); sv = { lv: n.lv, exp: n.exp }; console.log(`  [char] birikmis exp seviyeye cevrildi -> lv ${n.lv} exp ${n.exp}`); }
  } catch (e) { }
  if (!skipHeroFields) {
    try {
        let pos; try { const kp = ((dd && dd.kadro) || {})[String(seviye.anaId())]; if (kp !== undefined) pos = Number(kp); } catch (e) { }
      let skill = 0; try { skill = dd ? beceri.ana(dd) : 0; } catch (e) { }
      out = harita.anaHeroYama(out, { level: sv.lv, exp: sv.exp, pos, skill });
      console.log(`  [char] ana hero level=${sv.lv} exp=${sv.exp}${pos ? ' pos=' + pos : ''}${skill ? ' skill=' + skill : ''}`);
    } catch (e) { console.log('  [char] level hatasi:', e.message); }
  }
  if (process.env.BLEACH_DIAGNOSTIC_SKIP_HERO_INJECTION === '1') return ekipmanYama(out, dd);
  // Karakter shop (veri.json.herolar) + MEYHANEDEN DEVSIRILEN partnerler (durum.meyhane.alinan)
  // veya tumKarakterler -> hepsi. Giris sonu DINAMIK hesaplanir (sabit offset paketi bozuyordu).
  // ESKIDEN devsirilen partnerler enjekte EDILMIYORDU -> relogin'de Formation/Partners'tan kayboluyordu.
  try {
    const hepsi = v.tumKarakterler === true || v.tumKarakterler === 'true';
    const sahip = new Set((Array.isArray(v.herolar) ? v.herolar : []).map(Number).filter(x => x > 0));
    let devsirilen = 0;
    try { for (const id of meyhane.alinanlar(dd || {})) { if (!sahip.has(id)) devsirilen++; sahip.add(id); } } catch (e) { }
    if (hepsi || sahip.size) {
      const lv = sv.lv;
      const seviyeOf = id => seviye.heroSeviye(dd || {}, id, v);   // partnerin KENDI kalici seviyesi
      const r = herolar.injectAll(out, lv, harita.basicEnd, hepsi ? null : [...sahip], seviyeOf);
      if (r.eklenen) {
        console.log(`  [char] HEROLAR: +${r.eklenen} hero (${devsirilen} devsirilen; giris sonu ${r.girisSonu}), paket ${r.buf.length}B`);
        try { if (dd) { for (const id of r.ids || []) seviye.heroKayit(dd, id, lv); durumMod.kaydet(dd); } } catch (e) { }
      } else console.log(`  [char] hero enjekte atlandi: ${r.hata}`);
      return ekipmanYama(r.buf, dd);
    }
  } catch (e) { console.log('  [char] hero enjekte hatasi:', e.message); }
  return ekipmanYama(out, dd);
}
// Her heronun TAKILI ekipmani + uyanis + Hogyoku kalici depodan (ekipman.js); yakalanan set sadece ilk tohum.
function ekipmanYama(buf, dd) {
  if (!dd) return buf;
  buf = meyhane.charYama(buf, dd, harita.basicEnd);
  if (process.env.BLEACH_DIAGNOSTIC_SKIP_EQUIPMENT_PATCH === '1') return buf;
  try {
    const ekipman = require('./ekipman');
    const r = ekipman.charYama(buf, dd, harita.basicEnd);
    try { durumMod.kaydet(dd); } catch (e) { }
    console.log(`  [char] ekipman yamasi: ${Object.keys(ekipman.depo(dd).esyalar).length} ornek, paket ${r.length}B`);
    return r;
  } catch (e) { console.log('  [char] ekipman yama hatasi:', e.message); return buf; }
}

// istek->cevap istisnalari (opcode-swap disi)
const OVERRIDE = {
  0x01810001: 0x01180102, // login -> karakter verisi
  0x01810000: 0x01180000, // kapi
};
function respIdFor(reqId) {
  if (OVERRIDE[reqId] !== undefined) return OVERRIDE[reqId] >>> 0;
  if (harita.OVERRIDE.has(reqId >>> 0)) return harita.OVERRIDE.get(reqId >>> 0); // gercek cevap opcode'u
  // 0x0181abcd -> 0x0118abcd ; 0x0161->0x0116 ; 0x0171->0x0117 ; 0x0145-> ? (ayni?)
  const hi = (reqId >>> 16) & 0xffff, lo = reqId & 0xffff;
  // 0x0154 = PACKETID_CS_BATTLE_Base ailesi (CS_BattleStatistics 0x01548002 -> SC 0x01458002)
  const map = { 0x0181: 0x0118, 0x0161: 0x0116, 0x0171: 0x0117, 0x0145: 0x0145, 0x0154: 0x0145 };
  const rhi = map[hi]; if (rhi === undefined) return null;
  return ((rhi << 16) | lo) >>> 0;
}

let RESP = loadResponses();
// kapsamli crawler cevaplari (opcode -> en zengin payload) — birincil kaynak
const CEVAP = {};
try {
  const idx = JSON.parse(fs.readFileSync(path.join(__dirname, 'cevaplar', '_index.json'), 'utf8'));
  for (const [hex, file] of Object.entries(idx)) CEVAP[hex.toLowerCase()] = fs.readFileSync(path.join(__dirname, 'cevaplar', file));
  console.log('kapsamli cevap yuklendi:', Object.keys(CEVAP).length, 'opcode');
} catch (e) { }
// GOREVLER: ARTIK durum-tabanli gercek motor (gorev-motor.js). Eski "hepsi bitmis" statik
// override KALDIRILDI — quest paketleri her baglantida oyuncunun durumundan uretilir
// (loginPush + CS 0x01811200/0x01811201). Crawler'in bayat quest cevaplari sizmasin diye sil:
delete CEVAP['0x01181202'];
delete CEVAP['0x01181203'];
console.log(`harita: ${harita.OVERRIDE.size} gercek cevap istisnasi | ekstra: ${harita.EKSTRA.size} | login push: ${harita.LOGIN_PUSH.length} | VIP max: ${harita.VIP_MAX}`);
const hx = id => '0x' + (id >>> 0).toString(16).padStart(8, '0');
function syncHeroChangeResponse(reqId, reqPayload, respId, respPayload) {
  const req = reqId >>> 0;
  if (!Buffer.isBuffer(respPayload)) return;
  const durum = durumMod.yukle();
  let changed = false;
  if (req === 0x01816f00 && (respId >>> 0) === 0x01186f00) {
    changed = savas.syncHeroChangeInfo(durum, respPayload);
  } else if ((req === 0x01816f07 || req === 0x01816f0a) &&
    Buffer.isBuffer(reqPayload) && reqPayload.length >= 4 && respPayload.length >= 4 &&
    respPayload.readUInt32BE(0) === 0) {
    const heroId = reqPayload.readUInt32BE(0) >>> 0;
    changed = req === 0x01816f07
      ? savas.heroChangeReset(durum, heroId)
      : savas.heroChangeOneKey(durum, heroId);
  }
  if (changed) durumMod.kaydet(durum);
}
LOG.reset();
let CONN_SEQ = 0;
const CLIENTS = new Set();   // canli baglantilarin send() islevleri (disaridan push: yukleme)
const GAME_SESSIONS = new Set();
// One arena shared by every authenticated connection; the clock runs even without polling.
const battlefieldService = require('./battlefield').service();
setInterval(() => {
  try { battlefieldService.arena.tick(); }
  catch (e) { console.error('[battlefield] tick failed:', e.message); }
}, 1000).unref();
const loggedInClients = () => Array.from(GAME_SESSIONS).filter(session => session.authenticated && !session.client.destroyed);
const illusion = require('./infinite-illusion');
const illusionService = illusion.service();
function illusionRefresh() {
  try {
    const d=durumMod.yukle();
    const rewarded=illusionService.tick({durum:d,kaydet:durumMod.kaydet});
    const payload=illusionService.packet(d);
    for(const session of loggedInClients()) {
      session.send(illusion.OP.INFO,payload,'ILLUSION-ranking');
      if(rewarded){
        for(const mail of rewarded)session.send(0x01181605,require('./boss-reward-mail').notification(mail),'ILLUSION-daily-mail');
      }
    }
  }catch(e){console.log('[infinite-illusion]',e.message);}
}
setInterval(illusionRefresh,15000).unref();

// Native Arena_Update refreshes the chest at release time and after claiming.
let lastArenaRewardState='';
setInterval(()=>{
  const clients=loggedInClients();if(!clients.length)return;
  try{
    const d=durumMod.yukle(),box=require('./arena-rewards').info(d);
    const key=JSON.stringify([box,require('./arena-real').rank(),require('./arena-real').reward()?.period]);
    if(key===lastArenaRewardState)return;
    const payload=handlers.byReq['0x01810206']({durum:d});
    for(const session of clients)session.send(0x01181906,payload,'ARENA-reward-state');
    lastArenaRewardState=key;
  }catch(e){console.error('[Arena reward] refresh failed:',e.message);}
},1000).unref();

// === KONTROL HTTP (127.0.0.1:GATE_PORT+2, portatif 10027): launcher "VIP / Altin Yukle" ===
// POST /topup {altin:N} -> veri.json altin/vipExp/vipLevel + durum.topup gunluk sayaci + canli client'a CharBaseInfoUpdate.
// GET  /hesap -> {altin, vipLevel, vipExp, bugun}
// Arena uses an embedded result/report followed by FightOk, unlike PvE packets.
const startArena = require('./arena-fight').createFight({
  arena:require('./arena-real'),kodek,load:durumMod.yukle,save:durumMod.kaydet,
  count:(state,event,amount)=>olay.say(state,event,amount),
  refresh:state=>handlers.byReq['0x01810206']({durum:state}),
});
// POST /arena-matching/match starts the same native Arena flow as an in-game challenge.
const KONTROL_PORT = GATE_PORT + 2;
require('http').createServer((req, res) => {
  const authPath = new URL(req.url, 'http://localhost').pathname;
  if (!require('./account-guard').guard(req, res, ['/topup', '/inventory-sync'].includes(authPath))) return;
  const cors = { 'Access-Control-Allow-Origin': req.headers.origin || process.env.BLEACH_WEB_ORIGIN || 'http://127.0.0.1:7420', 'Access-Control-Allow-Credentials': 'true', 'Access-Control-Allow-Methods': 'GET,POST,OPTIONS', 'Access-Control-Allow-Headers': 'content-type', 'Cache-Control': 'no-store' };
  const json = (code, o) => { res.writeHead(code, { ...cors, 'content-type': 'application/json; charset=utf-8' }); res.end(JSON.stringify(o)); };
  if (req.method === 'OPTIONS') { res.writeHead(204, cors); return res.end(); }
  const u = new URL(req.url, 'http://x');
  const localOrigin = req.headers.origin;
  if (localOrigin && !/^https?:\/\/(127\.0\.0\.1|localhost)(:\d+)?$/.test(localOrigin)) {
    return json(403, { ok: false, hata: 'Chỉ launcher trên máy này mới được phép truy cập.' });
  }
  if (u.pathname === '/hesap') {
    const v = veri(); let bugun = 0, toplam = 0;
    try { const t = require('./etkinlik-ozel').topupDepo(durumMod.yukle()); bugun = Number(t.gun[require('./paket').gun()]) || 0; toplam = Number(t.toplam) || 0; } catch (e) { }
    return json(200, { altin: Number(v.altin) || 0, vipLevel: Number(v.vipLevel) || 0, vipExp: Number(v.vipExp) || 0, bugun, toplam, bagli: CLIENTS.size });
  }
  if (u.pathname === '/inventory-sync' && req.method === 'POST') {
    try {
      // Include actual equipment instances from the persisted bag.
      const bag = handlers.envanterDepo.loadBagPaketi(durumMod.yukle());
      const inventory = bag.subarray(4); // InventoryNtf omits the LoadBagResult error field.
      const connected = loggedInClients();
      for (const session of connected) session.send(handlers.envanterDepo.OP_NTF, inventory, 'ADMIN-envanter');
      return json(200, { ok: true, connected: connected.length });
    } catch (e) { return json(500, { ok: false, hata: e.message }); }
  }
  if (u.pathname === '/topup' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const n = Math.floor(Number(JSON.parse(b || '{}').altin) || 0);
        if (!(n > 0) || n > 100000000) return json(400, { ok: false, hata: 'gecersiz miktar' });
        const r = handlers.topupUygula(n);
        for (const s of CLIENTS) { try { s(0x01180105, r.paket, 'TOPUP-para'); } catch (e) { } }
        return json(200, { ok: true, altin: r.altin, vipLevel: r.vipLevel, vipExp: r.vipExp, bugun: r.bugun, toplam: r.toplam, bagli: CLIENTS.size });
      } catch (e) { return json(500, { ok: false, hata: e.message }); }
    });
    return;
  }
  if (u.pathname === '/arena-matching/status' && req.method === 'GET') {
    const connected = loggedInClients();
    return json(200, { connected: connected.length, ready: connected.length === 1 });
  }
  if (u.pathname === '/arena-matching/opponents' && req.method === 'GET') {
    const origin = req.headers.origin;
    if (origin && !/^https?:\/\/(127\.0\.0\.1|localhost)(:\d+)?$/.test(origin)) return json(403, { ok: false, hata: 'Chỉ launcher trên máy này mới được phép truy cập.' });
    try {
      const level = seviye.anaDurum().lv;
      const opponents = require('./arena-real').list().map(({ units, accountId, ...row }) => row);
      const connected = loggedInClients().length;
      return json(200, { ok: true, playerLevel: level, connected, opponents });
    } catch (e) {
      return json(500, { ok: false, hata: e.message });
    }
  }
  if (u.pathname === '/arena-matching/match' && req.method === 'POST') {
    const origin = req.headers.origin;
    if (origin && !/^https?:\/\/(127\.0\.0\.1|localhost)(:\d+)?$/.test(origin)) return json(403, { ok: false, hata: 'Chỉ launcher trên máy này mới được phép ghép trận.' });
    let b = '';
    req.on('data', chunk => {
      b += chunk;
      if (b.length > 2048) req.destroy();
    });
    req.on('end', async () => {
      try {
        const connected = loggedInClients();
        if (connected.length !== 1) {
          return json(409, { ok: false, hata: connected.length ? 'Có nhiều hơn một client game đang đăng nhập; hãy chỉ giữ một client để ghép trận.' : 'Chưa có client game đăng nhập. Hãy mở game và đăng nhập trước.' });
        }
        const body = JSON.parse(b || '{}');
        if (!body || typeof body !== 'object' || Array.isArray(body)) return json(400, { ok: false, hata: 'Yêu cầu ghép trận không hợp lệ.' });
        const opponents = require('./arena-real').list();
        if (!opponents.length) return json(409, { ok: false, hata: 'Chưa có tài khoản khác tạo nhân vật để thách đấu.' });
        let opponent;
        if (body.id0 === undefined && body.id1 === undefined) {
          opponent = opponents[Math.floor(Math.random() * opponents.length)];
        } else {
          const id0 = Number(body.id0), id1 = Number(body.id1);
          if (!Number.isInteger(id0) || !Number.isInteger(id1) || id0 < 0 || id0 > 0xffffffff || id1 < 0 || id1 > 0xffffffff) {
            return json(400, { ok: false, hata: 'Đối thủ không hợp lệ.' });
          }
          opponent = opponents.find(bot => bot.id0 === id0 && bot.id1 === id1);
          if (!opponent) return json(404, { ok: false, hata: 'Đối thủ không còn trong danh sách.' });
        }
        const payload = Buffer.alloc(9);
        payload.writeUInt32BE(opponent.id0, 0);
        payload.writeUInt32BE(opponent.id1, 4);
        const session = connected[0];
        await startArena(session, payload);
        return json(200, { ok: true, started: true, opponent: { name: opponent.name, level: opponent.level, ranking: opponent.ranking } });
      } catch (e) {
        return json(e instanceof SyntaxError ? 400 : 500, { ok: false, hata: e.message });
      }
    });
    return;
  }
  res.writeHead(404, cors); res.end('yok');
}).on('error', e => console.log(`[kontrol] ${KONTROL_PORT} dinlenemedi: ${e.message}`)).listen(KONTROL_PORT, '127.0.0.1', () => console.log(`[kontrol] http://127.0.0.1:${KONTROL_PORT} (topup/hesap/arena-matching)`));

net.createServer(client => {
  const rq = {}; // bu baglantinin opcode kuyruk imleçleri (idHex->index)
  let buf = Buffer.alloc(0);
  let nemuLoginPending = false, loginPushPending = false;
  const cid = ++CONN_SEQ;
  const peer = `${client.remoteAddress}:${client.remotePort}`;
  LOG.connOpen(cid, peer);
  client.on('error', (e) => LOG.note(cid, 'error: ' + e.message));
  client.on('close', () => {
    LOG.connClose(cid, 'kapandi');
  });
  client.once('data', first => {
    if (first.toString('latin1').startsWith('<policy-file-request/>')) { LOG.note(cid, 'policy-file-request'); client.end(POLICY); return; }
    handle(first);
    client.on('data', handle);
  });

  function send(id, payload, kaynak) { client.write(frame(id, payload)); LOG.s2c(cid, id, payload, kaynak || '?'); }
  const session = { cid, client, send, authenticated: false };
  let accountVerified = false;
  CLIENTS.add(send);
  GAME_SESSIONS.add(session);
  client.on('close', () => { CLIENTS.delete(send); GAME_SESSIONS.delete(session); });

  // gercek sunucunun bu cevaptan ONCE gonderdigi ekstra paketler (or. gorev listeleri)
  function ekstralar(respId) {
    const list = harita.EKSTRA.get(respId >>> 0);
    if (!list) return;
    for (const eid of list) { const p = CEVAP[hx(eid)]; if (p) send(eid, Buffer.from(p), 'EKSTRA'); }
  }

  // GIRIS: char paketi (kalici durumla yamali) + login push'lari. Hem normal giriste hem
  // karakter yaratma sonrasinda kullanilir.
  function girisGonder(kaynak) {
    const queue = RESP[hx(CHAR_ID)];
    if (!queue || !queue.length) { LOG.note(cid, 'char paketi sablonu yok!'); return; }
    const idx = rq[hx(CHAR_ID)] || 0; rq[hx(CHAR_ID)] = idx + 1;
    const raw = queue[Math.min(idx, queue.length - 1)];
    const payload = process.env.BLEACH_DIAGNOSTIC_RAW_CHAR === '1' ? Buffer.from(raw) : editChar(raw);
    if (process.env.BLEACH_DIAGNOSTIC_RAW_CHAR === '1') LOG.note(cid, `diagnostic raw char packet ${payload.length}B`);
    nemuLoginPending = true; loginPushPending = true;
    send(CHAR_ID, payload, kaynak || `replay[${idx + 1}/${queue.length}]`);
  }

  // Capture order: CounterReq -> Nemu BaseInfo; Activity_LoadInfoReq -> TeamBattle notification.
  function nemuLoginPush() {
    if (!nemuLoginPending) return;
    nemuLoginPending = false;
    try { send(0x01186700, handlers.nemuBaseInfor(durumMod.yukle()), 'PUSH-nemu'); }
    catch (e) { LOG.note(cid, 'nemu push hata: ' + e.message); }
  }
  function kalanLoginPush() {
    if (!loginPushPending) return;
    loginPushPending = false;
    for (const pid of harita.LOGIN_PUSH) {
      if (pid === 0x01186700 || pid === 0x01181202 || pid === 0x01181203) continue;
      const p = CEVAP[hx(pid)]; if (p) send(pid, Buffer.from(p), 'PUSH-login');
    }
  }

  // cevap payload'ina istege ozel dokunus
  function uyarla(reqPk, respId, payload) {
    // CharBaseAttributeRet: ilk u32 = istenen hero id
    if (respId === 0x01180104 && reqPk.payload.length >= 4 && payload.length >= 4) {
      const b = Buffer.from(payload); reqPk.payload.copy(b, 0, 0, 4); return b;
    }
    return payload;
  }

  // Olay omurgasinin (olay.js) urettigi push'lari gonder (BleachTrain ilerleme vb.)
  function pushBosalt() { for (const p of olay.pushAl()) send(p.id, p.payload, p.kaynak); }

  function handle(chunk) {
    buf = Buffer.concat([buf, chunk]);
    const { packets, rest } = parseStream(buf);
    buf = rest;
    for (const pk of packets) {
      if (process.env.BLEACH_ACCOUNT_DIR && !accountVerified) {
        if ((pk.id >>> 0) === 0x01810001) {
          if (!pk.payload.includes(Buffer.from(process.env.BLEACH_GAME_TOKEN || '\0invalid'))) { client.destroy(); return; }
          accountVerified = true;
        } else if (![0x01810000, 0x00000001].includes(pk.id >>> 0)) { client.destroy(); return; }
      }
      pushBosalt();
      LOG.c2s(cid, pk);
      const reqHex = hx(pk.id);
      if([0x01810200,0x01810201,0x01810202,0x01810205,0x01810206,0x01810207,0x01810209,0x0181020c,0x0181020e,0x01810211].includes(pk.id>>>0)){
        const d=durumMod.yukle();if(d.protectSeireitei && d.protectSeireitei.active){d.protectSeireitei.active=false;d.protectSeireitei.atDoor=false;durumMod.kaydet(d);}
      }

      if (pk.id === 0x00000001) { continue; } // heartbeat
      if (IGNORE.has(pk.id >>> 0)) { LOG.note(cid, `ignore ${reqHex}`); continue; }
      // === GIRIS / KARAKTER YARATMA (detay: karakter.js) ===
      // Karakteri olmayan hesaba gercek sunucu gibi CreateCharCmd (0x01180100) gonderilir;
      // client isim + protagonist secer, CreateChar (0x01810100) yollar; kayit sonrasi char paketi.
      if ((pk.id >>> 0) === 0x01810001) {
        let dK = null; try { dK = durumMod.yukle(); } catch (e) { }
        if (!karakter.var(dK)) { send(karakter.OP_CMD, karakter.cmdPaketi(), 'KARAKTER-yarat-ekrani'); continue; }
        session.authenticated = true;
        girisGonder();
        continue;
      }
      if ((pk.id >>> 0) === 0x01810100) {
        let r = { hata: 1, paket: Buffer.from([0, 0, 0, 1]) };
        try {
          const dK = durumMod.yukle();
          r = karakter.olustur(dK, pk.payload);
          if (!r.hata) { durumMod.kaydet(dK); statlar.anaIdAyarla(r.karakter.anaId); session.authenticated = true; console.log(`[karakter] yaratildi: "${r.karakter.nick}" hero ${r.karakter.anaId} (prof ${r.karakter.profession}, cinsiyet ${r.karakter.gender})`); }
        } catch (e) { LOG.note(cid, 'karakter yaratma hata: ' + e.message); }
        send(karakter.OP_RET, r.paket, r.hata ? 'KARAKTER-ret-hata' : 'KARAKTER-ret');
        if (!r.hata) girisGonder('KARAKTER-giris');
        continue;
      }
      // Hueco Mundo's payload is [u8 pointIndex]. Never resolve it via the last world-map stage.
      if ((pk.id >>> 0) === 0x01817601) {
        try {
          const hueco = require('./hueco-mundo');
          const d = durumMod.yukle();
          const r = hueco.battle(d, pk.payload, (opponent, options) => savas.kadroRapor(0, opponent, null, options));
          let inventory = null;
          if (r.rewards.length) {
            const added = handlers.envanterDepo.ekle(d, r.rewards);
            if (!added.length) throw new Error('Hueco Mundo coin grant failed');
            inventory = handlers.envanterDepo.kazancPaketi(d, added);
          }
          durumMod.kaydet(d);
          send(hueco.OP.BATTLE, r.ret, 'HUECO-battle');
          if (r.report) {
            send(kodek.OP.REPORT, r.report, 'HUECO-report');
            send(kodek.OP.RESULT, kodek.encodeSingleResult(r.won, r.rewards), 'HUECO-result');
            if (inventory) send(handlers.envanterDepo.OP_NTF, inventory, 'HUECO-coin');
            if (r.claimRet) send(hueco.OP.CLAIM, r.claimRet, 'HUECO-auto-reward');
            send(hueco.OP.INIT, hueco.initPacket(d), 'HUECO-progress');
          }
        } catch (e) {
          send(0x01187601, Buffer.from([0, 0, 0, 1]), 'HUECO-error');
          LOG.note(cid, 'Hueco Mundo battle error: ' + e.message);
        }
        continue;
      }
      // === OTO-SAVAS: WorldMap_AutoBattle -> AutoBattleInfo (0x01180505) ===
      // Cevap opcode'u swap DEGIL (istek Base+4, cevap Base+5). Swap ile uretilen 0x01180504
      // ContinueAutoInfo'ya dusuyor; orada GetDatebase(City, 0).Type null exception veriyor.
      if (savas.isAutoBattle(pk.id)) {
        try {
          const frames = savas.autoBattleFrames(pk.id, pk.payload);
          const sweep = frames[0];
          const costs = [{ type: 3, code: 0, amount: sweep.vitalityCost }];
          if (handlers.paraEksik(costs)) throw new Error('Not enough vitality for world-map Auto-Battle');
          const costPacket = sweep.vitalityCost ? handlers.paraHarca(costs) : null;
          if (sweep.vitalityCost && !costPacket) throw new Error('Unable to charge Auto-Battle vitality');
          try {   // GOREV: oto-savas N tur = N galibiyet
            const dG = durumMod.yukle(); const ilerleyen = gorev.savasKazanildi(dG, sweep.stageId, sweep.count); durumMod.kaydet(dG);
            for (const g of ilerleyen) send(0x01181204, gorev.schedulePaketi(g.questId, g.kill), 'GOREV-schedule');
          } catch (e) { LOG.note(cid, 'gorev oto-savas hata: ' + e.message); }
          if (costPacket) send(0x01180105, costPacket, 'OTO-vitality');
          for (const fr of frames) {
            let inventoryPacket = null, moneyPacket = null;
            if (fr.odul && fr.odul.length) {
              let addedItems = [];
              try { addedItems = handlers.envanterEkleOdul(fr.odul); }
              catch (e) { LOG.note(cid, 'oto odul kalici yazma hata: ' + e.message); }
              try { inventoryPacket = handlers.envanterPaketiEkleme(addedItems); }
              catch (e) { LOG.note(cid, 'oto odul hata: ' + e.message); }
              try { moneyPacket = handlers.paraIcinOdul(fr.odul); }
              catch (e) { LOG.note(cid, 'oto para hata: ' + e.message); }
            }
            send(fr.id, fr.payload, 'OTO-SAVAS');
            if (inventoryPacket) send(0x01180f02, inventoryPacket, 'OTO-odul');
            if (moneyPacket) send(0x01180105, moneyPacket, 'OTO-para');
          }
        } catch (e) {
          send(0x01180505, Buffer.from([0, 0, 0, 1]), 'OTO-error');
          LOG.note(cid, `oto-savas hata ${reqHex}: ${e.message}`);
        }
        continue;
      }
      if ((pk.id >>> 0) === 0x01818b02) {
        try {
          const etkinlik = require('./savas-etkinlik');
          const durumVoid = durumMod.yukle();
          const enterRet = etkinlik.voidFightEnter(durumVoid, pk.payload, seviye.anaId());
          if (enterRet.readUInt32BE(0) === 0) {
            const roleHi = durumVoid.roleIdHi >>> 0;
            const roleLo = durumVoid.roleIdLo >>> 0;
            const frames = savas.voidFightFrames(durumVoid);
            const damage = etkinlik.voidDamageFromStatistics(savas.sonIstatistik());
            const deadRet = etkinlik.voidFinishFight(durumVoid, roleHi, roleLo, damage);
            if (!deadRet) throw new Error('Void Region participant disappeared before battle resolution');
            const inflicted = deadRet.readBigInt64BE(8);
            durumMod.kaydet(durumVoid);
            const resultFrame = frames.find(frame => (frame.id >>> 0) === 0x01458001);
            const reportFrame = frames.find(frame => (frame.id >>> 0) === 0x01458000);
            if (!resultFrame || !reportFrame) throw new Error('Void battle report/result packet is incomplete');
            const rankRet = etkinlik.voidRankPacket(durumVoid);
            send(0x01188b02, enterRet, 'VOID-FightEnter');
            send(reportFrame.id, reportFrame.payload, 'VOID-BattleReport');
            send(resultFrame.id, resultFrame.payload, 'VOID-BattleResult');
            const resolutionDelay = etkinlik.voidFightDurationMs();
            setTimeout(() => {
              if (client.destroyed) {
                LOG.note(cid, `Void Region battle resolved after ${resolutionDelay}ms; client disconnected before result packets`);
                return;
              }
              send(0x01188b04, deadRet, 'VOID-DeadRet');
              send(0x01188b05, rankRet, 'VOID-RankRet');
              LOG.note(cid, `Void Region battle resolved: damage=${inflicted}`);
            }, resolutionDelay);
            LOG.note(cid, `Void Region battle started: front=${pk.payload[0]}, boss=${etkinlik.voidBossEnemyId()}, damage=${inflicted}; result packets in ${resolutionDelay}ms`);
          } else {
            LOG.note(cid, 'Void Region FightEnter rejected: submit a formation and choose a valid front');
            send(0x01188b02, enterRet, 'VOID-FightEnter-rejected');
          }
        } catch (e) {
          LOG.note(cid, `Void Region FightEnter hata: ${e.message}`);
          send(0x01188b02, Buffer.from([0,0,0,1]), 'VOID-FightEnter-error');
        }
        continue;
      }
      // Tower of Gold uses an independent floor and never the Trial Tower stage cache.
      if ((pk.id >>> 0) === 0x0181f100) {
        const tower = require('./tower-gold'), d = durumMod.yukle();
        send(tower.STATE,tower.packet(d),'GOLDTOWER-info');
        continue;
      }
      if ((pk.id >>> 0) === 0x0181f101) {
        const tower = require('./tower-gold');
        try {
          const d = durumMod.yukle(), floor = tower.readFloor(pk.payload);
          const battle = floor ? tower.fight(d,floor,tower.readMode(pk.payload)) : null;
          if (!battle) { send(tower.RET,Buffer.from([0,0,0,1]),'GOLDTOWER-invalid-floor'); continue; }
          const awards = tower.complete(d,battle);
          // Save progress before notifying the client, so retrying the same floor cannot duplicate loot.
          if (awards.length) {
            handlers.odulVer(d,awards);
          }
          if(battle.won)durumMod.kaydet(d);
          send(tower.RET,Buffer.alloc(4),'GOLDTOWER-enter');
          for (const frame of battle.frames) send(frame.id,frame.payload,'GOLDTOWER-battle');
          const extra=handlers.ekAl();
          for(const item of extra.once.concat(extra.sonra))send(item.id,item.payload,item.kaynak);
          if(awards.length)send(0x01180f00,require('./envanter').loadBagPaketi(d),'GOLDTOWER-bag');
          send(tower.STATE,tower.packet(d),'GOLDTOWER-progress');
        } catch(e) { LOG.note(cid,'Tower of Gold: '+e.message); send(tower.RET,new (require('./paket').Y)().u32(1).utf(e.message).done(),'GOLDTOWER-error'); }
        continue;
      }
      // FightPet battle requests carry no stage id; resolve against the selected event boss,
      // never the last world-map stage kept by the generic battle handler.
      if ((pk.id >>> 0) === 0x01812607) {
        let acknowledged = false;
        try {
          const durumBoss = durumMod.yukle();
          const fightPet = require('./evcil-ek');
          const boss = fightPet.fightPetInfo(durumBoss);
          const frames = savas.fightPetFrames(boss.enemyId, boss.hp);
          const damage = savas.sonOyuncuHasari();
          const resolved = fightPet.fightPetApplyDamage(durumBoss, damage);
          let goldUpdate = null;
          let goldRewardForClient = 0;
          if (resolved.goldReward > 0 && resolved.winnerIsCurrentPlayer) {
            const resultFrame = frames.find(frame => (frame.id >>> 0) === kodek.OP.RESULT);
            if (!resultFrame || resultFrame.payload.length < 5) throw new Error('FightPet result packet is missing before boss reward');
            const claimAmount = fightPet.fightPetPendingGold(durumBoss);
            const award = [{ type: 0, code: 1, amount: claimAmount }];
            goldUpdate = handlers.paraIcinOdul(award);
            if (!goldUpdate) throw new Error('Unable to apply FightPet gold reward');
            fightPet.fightPetClaimGold(durumBoss, claimAmount);
            resultFrame.payload = kodek.encodeSingleResult(resultFrame.payload.readUInt8(4) !== 0, award);
            goldRewardForClient = claimAmount;
          }
          durumMod.kaydet(durumBoss);

          send(0x01182607, savas.fightAck(pk.id, pk.payload) || ZERO_ACK, 'FIGHTPET-FightRet');
          acknowledged = true;
          for (const frame of frames) send(frame.id, frame.payload, 'FIGHTPET-Battle');
          send(0x01182601, resolved.monsterPacket, 'FIGHTPET-MonsterInfo');
          send(0x01182602, resolved.rankPacket, 'FIGHTPET-RankUpdate');
          if (goldUpdate) send(0x01180105, goldUpdate, 'FIGHTPET-GoldReward');
          if (goldRewardForClient > 0) {
            const rewardPayload = Buffer.alloc(4);
            rewardPayload.writeUInt32BE(goldRewardForClient, 0);
            send(0x0118260A, rewardPayload, 'FIGHTPET-GoldReward-notice');
          }
          if (resolved.defeated) {
            send(0x01182608, Buffer.alloc(0), 'FIGHTPET-GameOver');
          }
          if (resolved.goldReward > 0 && resolved.winnerIsCurrentPlayer) {
            LOG.note(cid, `FightPet boss defeated: top damage=${resolved.winner.damage}, gold reward=${resolved.goldReward}`);
          } else if (resolved.goldReward > 0) {
            LOG.note(cid, `FightPet boss defeated: top damage=${resolved.winner.damage}, ${resolved.goldReward} Gold queued for ${resolved.winner.name}`);
          }
          LOG.note(cid, `FightPet battle: boss=${boss.enemyId}, damage=${resolved.applied}, hp=${resolved.hp}`);
        } catch (e) {
          LOG.note(cid, `FightPet battle hata: ${e.message}`);
          if (!acknowledged && !client.destroyed) {
            const failed = Buffer.alloc(6);
            failed.writeUInt32BE(1, 0);
            send(0x01182607, failed, 'FIGHTPET-FightRet-failed');
          }
        }
        continue;
      }
      if((pk.id >>> 0)===0x01811f04){
        try{
          const d=durumMod.yukle(),hunt=require('./soul-hunt').kur(handlers),result=hunt.rob({durum:d,payload:pk.payload,kaydet:durumMod.kaydet});
          if(result.error){const b=Buffer.alloc(4);b.writeUInt32BE(result.error);send(0x01181f04,b,'SOULHUNT-rob-error');}
          else{send(0x01181f07,Buffer.alloc(4),'SOULHUNT-FightOk');send(kodek.OP.REPORT,result.report.payload,'SOULHUNT-report');send(kodek.OP.RESULT,kodek.encodeSingleResult(result.report.won,[]),'SOULHUNT-result');const q=handlers.ekAl();for(const p of q.once.concat(q.sonra))send(p.id,p.payload,p.kaynak);}
        }catch(e){LOG.note(cid,'Soul Hunt rob: '+e.message);send(0x01181f04,Buffer.from([0,0,0,1]),'SOULHUNT-rob-error');}continue;
      }
      if((pk.id >>> 0)===0x01812401 || (pk.id >>> 0)===0x0181247d){
        try{
          const d=durumMod.yukle(),protect=require('./protect-seireitei').kur(handlers);
          const result=(pk.id>>>0)===0x0181247d?protect.replay({durum:d,payload:pk.payload,kaydet:durumMod.kaydet}):protect.fight({durum:d,payload:pk.payload,kaydet:durumMod.kaydet});
          send(0x01182401,result.ack,'PROTECT-FightRet');
          if(!result.error){send(kodek.OP.REPORT,result.report,'PROTECT-report');send(kodek.OP.RESULT,result.result,'PROTECT-result');for(const update of result.updates)send(update.id,update.payload,'PROTECT-update');}
        }catch(e){LOG.note(cid,'Protect Seireitei: '+e.message);send(0x01182401,Buffer.from([0,0,0,1]),'PROTECT-error');}continue;
      }
      if((pk.id>>>0)>=0x0181ed00 && (pk.id>>>0)<=0x0181ed04){
        if(!session.authenticated)continue;
        const field=require('./battlefield');
        try{
          const result=battlefieldService.handle(pk.id>>>0,{durum:durumMod.yukle(),payload:pk.payload,kaydet:durumMod.kaydet});
          if(result.bag)send(0x01180f00,result.bag,'BATTLEFIELD-bag');
          send((pk.id & 0xffff)|0x01180000,field.packet(result.data),'BATTLEFIELD-reply');
          if(result.report){send(kodek.OP.REPORT,result.report.payload,'BATTLEFIELD-report');send(kodek.OP.RESULT,kodek.encodeSingleResult(result.report.won,[]),'BATTLEFIELD-result');}
        }catch(e){LOG.note(cid,'Battlefield: '+e.message);send((pk.id & 0xffff)|0x01180000,field.packet({error:1,message:'Khong the luu chien truong. Hay thu lai.'}),'BATTLEFIELD-error');}
        continue;
      }
      if((pk.id>>>0)===0x01813d02 || (pk.id>>>0)===0x01813d7d){
        try{const d=durumMod.yukle(),cross=require('./cross-server').kur(handlers),ctx={durum:d,payload:pk.payload,kaydet:durumMod.kaydet};const result=(pk.id>>>0)===0x01813d7d?cross.replay(ctx):cross.fight(ctx);
          if(result.error){const p=Buffer.alloc(4);p.writeUInt32BE(result.error);send(0x01183d02,p,'CROSS-error');}
          else{send(0x01183d02,result.ack,'CROSS-ack');send(kodek.OP.REPORT,result.report,'CROSS-report');send(kodek.OP.RESULT,result.result,'CROSS-result');const q=handlers.ekAl();for(const p of q.once.concat(q.sonra))send(p.id,p.payload,p.kaynak);}
        }catch(e){LOG.note(cid,'Cross Server: '+e.message);send(0x01183d02,Buffer.from([0,0,0,1]),'CROSS-error');}continue;
      }
      if((pk.id>>>0)===illusion.OP.INFO_REQ || (pk.id>>>0)===illusion.OP.FIGHT_REQ){
        if(!session.authenticated)continue;
        try {
          const d=durumMod.yukle(),ctx={durum:d,payload:pk.payload,kaydet:durumMod.kaydet};
          if((pk.id>>>0)===illusion.OP.INFO_REQ){
            if(pk.payload.length){send(illusion.OP.INFO,new (require('./paket').Y)().utf('{"error":4}').done(),'ILLUSION-error');continue;}
            const rewarded=illusionService.tick(ctx);
            send(illusion.OP.INFO,illusionService.packet(d),'ILLUSION-info');
            if(rewarded)for(const mail of rewarded)send(0x01181605,require('./boss-reward-mail').notification(mail),'ILLUSION-daily-mail');
          }else{
            const result=illusionService.fight(ctx),ack=Buffer.alloc(4);ack.writeUInt32BE(result.error||0);
            send(illusion.OP.FIGHT,ack,'ILLUSION-ack');
            if(result.rewarded)for(const mail of result.rewarded)send(0x01181605,require('./boss-reward-mail').notification(mail),'ILLUSION-daily-mail');
            if(!result.error){
              if(!result.sweep){send(kodek.OP.REPORT,result.report,'ILLUSION-report');send(kodek.OP.RESULT,kodek.encodeSingleResult(result.won,[]),'ILLUSION-result');}
              for(const peer of loggedInClients())peer.send(illusion.OP.INFO,result.info,'ILLUSION-ranking');
            }
          }
        }catch(e){LOG.note(cid,'Infinite Illusion: '+e.message);send(illusion.OP.FIGHT,Buffer.from([0,0,0,1]),'ILLUSION-error');}
        continue;
      }
      if((pk.id>>>0)===0x01818201){
        try{const d=durumMod.yukle(),result=require('./conquest').kur(handlers).fight({durum:d,payload:pk.payload,kaydet:durumMod.kaydet});
          if(result.error){const p=Buffer.alloc(4);p.writeUInt32BE(result.error);send(0x01188201,p,'CONQUEST-error');}
          else{send(0x01188201,result.ack,'CONQUEST-ack');send(kodek.OP.REPORT,result.report,'CONQUEST-report');send(kodek.OP.RESULT,result.result,'CONQUEST-result');const q=handlers.ekAl();for(const p of q.once.concat(q.sonra))send(p.id,p.payload,p.kaynak);}
        }catch(e){LOG.note(cid,'Conquest: '+e.message);send(0x01188201,Buffer.from([0,0,0,1]),'CONQUEST-error');}continue;
      }
      // === SAVAS: fight istegi -> (1) fight-ack (2) savas raporu (3) sonuc ===
      // Gercek sunucu once fight opcode'un normal swap cevabini (ack) yollar, SONRA raporu.
      // Ack olmadan client savas moduna gecmiyordu. Ack = [u32 result=0][istek payload][u16 0].
      if (savas.isFight(pk.id)) {
        try {
          const isHeroChangeFight = (pk.id >>> 0) === 0x01816f09 &&
            Buffer.isBuffer(pk.payload) && pk.payload.length >= 4;
          const heroChangeState = isHeroChangeFight ? durumMod.yukle() : null;
          const heroChangeStageId = isHeroChangeFight
            ? savas.heroChangeStageId(pk.payload, heroChangeState) : 0;
          if (isHeroChangeFight && !heroChangeStageId) {
            const rejected = Buffer.alloc(4);
            rejected.writeUInt32BE(1, 0);
            send(0x01186f09, rejected, 'HEROCHANGE-invalid-stage');
            LOG.note(cid, `Hero Change challenge rejected: invalid hero/stage hero=${pk.payload.readUInt32BE(0) >>> 0}`);
            continue;
          }
          const isHurdle = (pk.id >>> 0) === 0x01810202 &&
            Buffer.isBuffer(pk.payload) && pk.payload.length >= 8;
          const raidersCityId = isHurdle ? pk.payload.readUInt32BE(0) >>> 0 : 0;
          const isRaidersDaily = isHurdle && savas.isRaidersDailyCity(raidersCityId);
          const raidersStageId = isRaidersDaily ? savas.raidersDailyStageId(pk.payload) : 0;
          if (isRaidersDaily && !raidersStageId) {
            const rejected = Buffer.alloc(4);
            rejected.writeUInt32BE(4, 0);
            send(0x01180202, rejected, 'MERU-invalid-stage');
            LOG.note(cid, `Meru Realm challenge rejected: invalid city=${raidersCityId}, stage=${pk.payload.readUInt32BE(4) >>> 0}`);
            continue;
          }
          const hurdleCityType = isHurdle ? savas.stageCityType(raidersCityId) : 0;
          if (isHurdle && [1, 2].includes(hurdleCityType) && !savas.stageIdCoz(pk.payload, hurdleCityType === 2 ? durumMod.yukle() : null)) {
            const rejected = Buffer.alloc(4);
            rejected.writeUInt32BE(4, 0);
            send(0x01180202, rejected, 'HURDLE-invalid-stage');
            LOG.note(cid, `Stage challenge rejected: invalid city=${raidersCityId}, stage=${pk.payload.readUInt32BE(4) >>> 0}`);
            continue;
          }
          const isSkyTowerPve = (pk.id >>> 0) === 0x01810a01 &&
            Buffer.isBuffer(pk.payload) && pk.payload.length >= 10 && pk.payload.readUInt8(0) === 1;
          if (isSkyTowerPve) {
            const towerId = pk.payload.readUInt32BE(2) >>> 0;
            const layerId = pk.payload.readUInt32BE(6) >>> 0;
            const towerEvent = require('./savas-etkinlik');
            if (!savas.skyTowerStageId(pk.payload) || !towerEvent.skyTowerCanChallenge(towerId, layerId)) {
              const rejected = Buffer.alloc(4);
              rejected.writeUInt32BE(1, 0);
              send(0x01180a01, rejected, 'SKYTOWER-invalid-stage');
              LOG.note(cid, `SkyTower challenge rejected: invalid tower=${towerId}, layer=${layerId}`);
              continue;
            }
          }
          if ((pk.id >>> 0) === 0x01811904) {
            startArena(session, pk.payload).catch(e => { const error = Buffer.alloc(4); error.writeUInt32BE(1); send(0x01181904, error, 'ARENA-rejected'); LOG.note(cid, e.message); });
            continue;
          }
          if ((pk.id >>> 0) === 0x01810202 && pk.payload.length >= 4) { try { require('./moduller').sonHurdleAyarla(pk.payload.readUInt32BE(0)); } catch (e) { } }   // sandik paketi sehir tipine gore
          const respId = respIdFor(pk.id);
          if (respId !== null) {
            const respHex2 = hx(respId);
            // Enter_Hurdle vb: istegi echo'la (dogru stage id). Diger tiplerde CEVAP varsa onu kullan.
            const heroChangeFightTime = isHeroChangeFight
              ? savas.heroChangeAttempt(heroChangeState) : 0;
            if (isHeroChangeFight) durumMod.kaydet(heroChangeState);
            const ack = savas.fightAck(pk.id, pk.payload) ||
              (CEVAP[respHex2] ? Buffer.from(CEVAP[respHex2]) : ZERO_ACK);
            if (isHeroChangeFight && ack.length >= 12) ack.writeUInt32BE(heroChangeFightTime >>> 0, 8);
            send(respId, ack, 'SAVAS-ack');
          }
          // istek payload'i stage bilgisini tasir (Enter_Hurdle: [u32 cityId][u32 blockPointId])
          // -> savas motoru o stage'in GERCEK dusman kadrosunu kurar.
          const instanceState = isHurdle && hurdleCityType === 2 ? durumMod.yukle() : null;
          const battleState = heroChangeState || instanceState;
          const resolvedStageId = isHurdle ? savas.stageIdCoz(pk.payload, instanceState)
            : (isHeroChangeFight ? heroChangeStageId : 0);
          const frames = savas.fightFrames(pk.id, pk.payload, battleState);
          const battleResult = frames.find(frame => (frame.id >>> 0) === kodek.OP.RESULT);
          const stageFight = (isHurdle && !!resolvedStageId) || isSkyTowerPve || isHeroChangeFight;
          const stageWon = !!battleResult && battleResult.won === true;
          if (instanceState && stageWon) {
            if (!savas.instanceStageWon(instanceState, pk.payload, resolvedStageId)) {
              throw new Error(`Unable to advance instance ${raidersCityId}/${pk.payload.readUInt32BE(4) >>> 0} at stage ${resolvedStageId}`);
            }
            durumMod.kaydet(instanceState);
          }
          if (isHeroChangeFight && stageWon) {
            if (!savas.heroChangeWon(heroChangeState, pk.payload, resolvedStageId)) {
              throw new Error(`Unable to advance Hero Change hero ${pk.payload.readUInt32BE(0) >>> 0} at stage ${resolvedStageId}`);
            }
            durumMod.kaydet(heroChangeState);
          }
          let raidersNotify = null;
          if (isRaidersDaily && stageWon) {
            const raidersState = durumMod.yukle();
            raidersNotify = require('./savas-etkinlik').killHeroApplyWin(raidersState, raidersStageId);
            if (!raidersNotify) throw new Error(`Unable to record Meru Realm clear for stage ${raidersStageId}`);
            durumMod.kaydet(raidersState);
          }
          if (isSkyTowerPve && stageWon) {
            const towerId = pk.payload.readUInt32BE(2) >>> 0;
            const layerId = pk.payload.readUInt32BE(6) >>> 0;
            const towerState = durumMod.yukle();
            if (!require('./savas-etkinlik').skyTowerApplyWin(towerState, towerId, layerId)) {
              throw new Error(`Unable to persist Trial Tower clear for ${towerId}/${layerId}`);
            }
            durumMod.kaydet(towerState);
          }
          // GOREV: savas kazanildi -> o stage'i (blockPointId) isteyen kabul edilmis gorevlerin kill sayaci artar.
          // Kayit + SendTaskSchedule ile client gorevi TASKBACK'e alir.
          try {
            const bp = resolvedStageId || (pk.payload && pk.payload.length >= 8 ? pk.payload.readUInt32BE(4) : 0);
            const dG = durumMod.yukle();
            const towerWon = isSkyTowerPve && stageWon;
            const eligible = !stageFight || stageWon;
            const ilerleyen = eligible && !isHeroChangeFight
              ? gorev.savasKazanildi(dG, isSkyTowerPve ? (pk.payload.readUInt32BE(6) >>> 0) : bp, 1)
              : [];
            if (isHurdle && hurdleCityType === 2 && stageWon) ilerleyen.push(...gorev.instanceKazanildi(dG));
            if (towerWon) olay.say(dG, 'trialWin', 1);
            if ((pk.id >>> 0) === 0x01810202 && stageWon) olay.say(dG, 'instancePass', 1);
            durumMod.kaydet(dG);
            for (const g of ilerleyen) send(0x01181204, gorev.schedulePaketi(g.questId, g.kill), 'GOREV-schedule');
          } catch (e) { LOG.note(cid, 'gorev savas hata: ' + e.message); }
          for (const fr of frames) {
            let addedItems = [];
            let inventoryPacket = null;
            let moneyPacket = null;
            if (fr.odul && fr.odul.length) {
              // Save the reward before notifying the client that the battle is complete.
              addedItems = handlers.envanterEkleOdul(fr.odul);
              const itemRewards = fr.odul.filter(item => Number(item.type) === 1);
              const failedItems = itemRewards.filter(item =>
                !addedItems.some(saved => (saved.code >>> 0) === (Number(item.code) >>> 0)));
              if (failedItems.length) {
                LOG.note(cid, `savas item odulu kaydedilemedi: ${failedItems.length}/${itemRewards.length} stage=${fr.stageId || 0}`);
              }
              if (addedItems.length) inventoryPacket = handlers.envanterPaketiEkleme(addedItems);
              try { require('./telemetri').odul(cid, 'savas', fr.odul); } catch (e) { }
              // Para odulleri (gumus/exp/soul...) hesaba GERCEKTEN islenir + veri.json'a birikir
              try { moneyPacket = handlers.paraIcinOdul(fr.odul); }
              catch (e) { LOG.note(cid, 'savas para hata: ' + e.message); }
            }
            send(fr.id, fr.payload, 'SAVAS');
            // Deliver inventory and currency updates after the persistent reward grant.
            if (inventoryPacket) {
              send(0x01180f02, inventoryPacket, 'SAVAS-odul');
              send(0x01180f00, handlers.envanterDepo.loadBagPaketi(durumMod.yukle()), 'SAVAS-bag-sync');
            }
            if (moneyPacket) send(0x01180105, moneyPacket, 'SAVAS-para');
            if (fr.heroChangeFragmentId && addedItems.some(item =>
              (item.code >>> 0) === (fr.heroChangeFragmentId >>> 0))) {
              const fragmentState = durumMod.yukle();
              const fragmentCount = handlers.envanterDepo.mevcut(fragmentState, fr.heroChangeFragmentId);
              const fragmentPacket = Buffer.alloc(8);
              fragmentPacket.writeUInt32BE(fr.heroChangeFragmentId >>> 0, 0);
              fragmentPacket.writeUInt32BE(fragmentCount >>> 0, 4);
              send(0x01186f06, fragmentPacket, 'HEROCHANGE-fragment-count');
            }
          }
          const stageAssessment = isHurdle ? savas.stageAssessment(pk.payload, stageWon, resolvedStageId) : null;
          if (stageAssessment) send(stageAssessment.id, stageAssessment.payload, 'SAVAS-stage-assessment');
          const nextInstanceLayer = isHurdle ? savas.stageNextLayer(pk.payload, stageWon, resolvedStageId) : null;
          if (nextInstanceLayer) send(nextInstanceLayer.id, nextInstanceLayer.payload, 'SAVAS-instance-next-layer');
          if (raidersNotify) {
            for (const packet of raidersNotify.bestFirst) send(0x01180702, packet, 'MERU-best-first');
            send(0x01180700, raidersNotify.progress, 'MERU-stage-clear');
          }
          // "Battle Stats": client bu istegi SADECE RelatedPartner/NightmareTrial modlarinda
          // atiyor (TBattleHandle.ProcessorOnBattleStatistics:1278), normal stage savasinda
          // butona basmak sunucuya hicbir sey gondermiyor. veri.json'da
          // savasIstatistigiOtomatik=true ise paketi biz itiyoruz: client alir almaz
          // PacketPerform_SC_StatisticsRet -> FProcessorWindowStatistics.Visible = true yapiyor
          // (pencerenin kendi Btn_Close'u var). Varsayilan KAPALI: her savastan sonra pencerenin
          // kendiliginden acilmasi rahatsiz edici olabilir.
          try {
            if (veri().savasIstatistigiOtomatik === true) {
              const st = savas.sonIstatistik();
              if (st) send(0x01458002, st, 'SAVAS-istatistik-oto');
            }
          } catch (e) { LOG.note(cid, 'istatistik push hata: ' + e.message); }
          LOG.note(cid, `savas gonderildi (${reqHex}): ack + ${frames.length} frame`);
        } catch (e) { LOG.note(cid, `savas hata ${reqHex}: ${e.message}`); }
        continue;
      }
      // === SAVAS ISTATISTIGI: "Battle Stats" -> CS_BattleStatistics 0x01548002 (payload yok) ===
      // Client bu istegi YALNIZCA RelatedPartner / NightmareTrial modlarinda atiyor
      // (TBattleHandle.ProcessorOnBattleStatistics); normal stage savasinda hic istemiyor.
      if ((pk.id >>> 0) === 0x01548002) {
        const st = savas.sonIstatistik();
        send(0x01458002, st || Buffer.alloc(4), st ? 'SAVAS-istatistik' : 'SAVAS-istatistik-bos');
        continue;
      }
      // === GOREVLER: gercek accept/complete/cancel (durum-tabanli, kalici) ===
      if ((pk.id >>> 0) === 0x01811201) {
        try {
          const dq = durumMod.yukle();
          const r = gorev.aksiyon(dq, pk.payload);
          if (r) {
            if (r.degisti && r.oduller) olay.say(dq, 'gorev', 1);   // gorev bitti -> Experiences sartlari
            // PARTNER odulu (type 4, code = hero id): esya degil, KADROYA katilir (meyhane.alinan) + TavernRecruitRet push
            const partnerler = (r.oduller || []).filter(a => Number(a.type) === 4 && Number(a.code) > 0);
            if (partnerler.length) {
              try {
                const lv = seviye.anaDurum().lv;
                dq.meyhane = dq.meyhane || {}; dq.meyhane.alinan = dq.meyhane.alinan || {};
                for (const a of partnerler) {
                  const hid = Number(a.code) >>> 0;
                  if (!dq.meyhane.alinan[String(hid)]) { dq.meyhane.alinan[String(hid)] = 1; try { seviye.heroKayit(dq, hid, lv); } catch (e) { } }
                  const w = Buffer.alloc(20); w.writeUInt32BE(0, 0); w.writeUInt32BE(hid, 4); w.writeUInt32BE(Math.max(1, lv) >>> 0, 8);
                  send(0x01180c02, w, 'GOREV-partner');
                  console.log(`[gorev] partner odulu: hero ${hid} kadroya eklendi`);
                }
                r.degisti = true;
              } catch (e) { LOG.note(cid, 'gorev partner hata: ' + e.message); }
              r.oduller = r.oduller.filter(a => Number(a.type) !== 4);
            }
            if (r.degisti) durumMod.kaydet(dq);
            if (r.oduller && r.oduller.length) {
              let addedItems = [];
              try { addedItems = handlers.envanterEkleOdul(r.oduller); } catch (e) { LOG.note(cid, 'gorev odul hata: ' + e.message); }
              try { const env = handlers.envanterPaketiEkleme(addedItems); if (env) send(0x01180f02, env, 'GOREV-envanter'); } catch (e) { LOG.note(cid, 'gorev envanter hata: ' + e.message); }
              try { const para = handlers.paraIcinOdul(r.oduller); if (para) send(0x01180105, para, 'GOREV-para'); } catch (e) { }
            }
            send(0x01181201, r.ret, 'GOREV-actionRet');
            if (r.schedule) send(0x01181204, r.schedule, 'GOREV-schedule');
          }
        } catch (e) { LOG.note(cid, 'gorev aksiyon hata: ' + e.message); }
        continue;
      }
      // === GOREV bilgi istegi: guncel kabul/biten durumu + CompleteSendInfor ===
      if ((pk.id >>> 0) === 0x01811200) {
        try {
          const dq = durumMod.yukle();
          send(0x01181202, gorev.kabulPaketi(dq), 'GOREV-kabul');
          send(0x01181203, gorev.bitenPaketi(dq), 'GOREV-biten');
          send(0x01181200, Buffer.alloc(0), 'GOREV-sendinfo');
        } catch (e) { LOG.note(cid, 'gorev infor hata: ' + e.message); }
        continue;
      }
      if ((pk.id >>> 0) === 0x01816f00) {
        const heroChangeState = durumMod.yukle();
        send(0x01186f00, savas.heroChangeInfoPacket(heroChangeState), 'HEROCHANGE-info');
        continue;
      }
      const respId = respIdFor(pk.id);
      if (respId === null) { LOG.note(cid, `respId yok ${reqHex}`); continue; }
      const respHex = hx(respId);
      ekstralar(respId);
      // Soul Map: dugum aktiflesmeden ONCE Souls sayaci guncellenmeli — hem baslik sayaci
      // hem "siradaki dugum tiklanabilir mi" karari FCharacter.GeneralsSoul'dan okunuyor.
      // Ruhlar artik KALICI durumdan geliyor (harcaniyorlar); veri.json yalniz ilk tohum.
      if (reqHex === '0x01810b03') {
        try { send(0x01180105, handlers.soulPaketi(durumMod.yukle()), 'SOULMAP-souls'); }
        catch (e) { LOG.note(cid, 'soul paketi hata: ' + e.message); }
      }
      if((pk.id >>> 0)===0x0181f301){
        try{const text=new (require('./paket').O)(pk.payload).utf();LOG.note(cid,'FLASH-VOID '+text.slice(0,8000));}catch(e){LOG.note(cid,'FLASH-VOID invalid diagnostic');}
        continue;
      }
      // gercek handler var mi? (v2 mimari — modüller buraya)
      const h = handlers.byReq[reqHex];
      if (typeof h === 'function') {
        try {
          const out = h({ reqId: pk.id, payload: pk.payload, durum: durumMod.yukle(), kaydet: durumMod.kaydet });
          // Ek paket kuyrugu: handler'in ana cevaptan ONCE/SONRA gonderilmesini istedigi paketler
          // (envanter dusumu, beceri kilit-acma push'u, kullan/sat cevaplari). Detay: handlers.ekOnce/ekSonra.
          const ek = handlers.ekAl();
          for (const e of ek.once) send(e.id, e.payload, e.kaynak);
          if (out === false) {                       // islendi, ana cevap yok (fallback'e DUSME)
            for (const e of ek.sonra) send(e.id, e.payload, e.kaynak);
            continue;
          }
          if (out !== null && out !== undefined) {
            // Handler {id, payload} dondurebilir: SC opcode'u swap'tan farkli olan cevaplar (or. SkyTower ChestInfo)
            if (!Buffer.isBuffer(out) && out.payload) send(out.id >>> 0, out.payload, 'HANDLER'); else send(respId, out, 'HANDLER');
            for (const e of ek.sonra) send(e.id, e.payload, e.kaynak);
            if (reqHex === '0x01811e01') nemuLoginPush();
            if (reqHex === '0x01812300') kalanLoginPush();
            // Soul Map: dugum acildiktan SONRA kalan ruhu tekrar yolla ki sayac dussun
            // (aktiflestirme maliyeti handler icinde kalici durumdan dusuluyor).
            if (reqHex === '0x01810b03') {
              try { send(0x01180105, handlers.soulPaketi(durumMod.yukle()), 'SOULMAP-ruh-kalan'); }
              catch (e) { LOG.note(cid, 'soul kalan hata: ' + e.message); }
            }
            // Aktivite odul alma: odulu GERCEKTEN envantere ekle (yoksa popup cikar, esya gelmez)
            // Mentorship komutu: CommandRet sadece hata kodu; gorunur sonuc ayri pakette.
            // cmd 9 = Interaction -> IntercationRet 0x01183507 gonderilmezse buton olu kaliyor.
            if (reqHex === '0x01813503' && pk.payload && pk.payload.length >= 1 && pk.payload.readInt8(0) === 9) {
              try { send(0x01183507, handlers.mentorEtkilesim(pk.payload, durumMod.yukle()), 'MENTOR-etkilesim'); }
              catch (e) { LOG.note(cid, 'mentor etkilesim hata: ' + e.message); }
            }
            // Gunluk odul claim'leri: client odul miktarini cevaptan ogrenmiyor, parayi
            // ayrica CharBaseInfoUpdate ile yollamak gerekiyor.
            if (reqHex === '0x01816d01' || reqHex === '0x01816d02' || reqHex === '0x01816d03') {
              try { const para = handlers.sonParaPaketi(); if (para) send(0x01180105, para, 'GUNLUK-para'); }
              catch (e) { LOG.note(cid, 'gunluk para hata: ' + e.message); }
            }
            // OLAY TETIKLERI: basarili cevap (ilk u32 = 0) -> Experiences/gorev sayaci (handlers.OLAY_TETIK)
            const olayKey = handlers.OLAY_TETIK && handlers.OLAY_TETIK[reqHex];
            if (olayKey) {
              try {
                const pl = Buffer.isBuffer(out) ? out : out.payload;
                if (pl && pl.length >= 4 && pl.readUInt32BE(0) === 0) { const dO = durumMod.yukle(); olay.say(dO, olayKey, 1); durumMod.kaydet(dO); }
              } catch (e) { LOG.note(cid, 'olay tetik hata: ' + e.message); }
            }
            if (reqHex === '0x01812303') {
              try {
                const r = handlers.sonClaim();
                if (r && r.ozel) { /* etkinlik-ozel: odul/bildirim paketleri handler kuyrugundan gitti */ }
                else if (r) {
                  // OperateRet odulu SADECE gosterir; "alindi" isaretini AwardStatusChangeNotify yapar.
                  // TUZAK: gonderilen wireId acik listede olmali, yoksa client return edip kalan
                  // durumlari da dusurur.
                  send(0x01182305, handlers.etkinlik.bildirimPaketi(r.wireId, r.index, -1, r.kosullar), 'ETKINLIK-alindi');
                  try { require('./telemetri').odul(cid, 'etkinlik:' + r.wireId, r.oduller); } catch (e) { }
                  const env = handlers.envanterIcinOdul(r.oduller);
                  if (env) send(0x01180f02, env, 'ETKINLIK-envanter');
                  const para = handlers.paraIcinOdul(r.oduller);
                  if (para) send(0x01180105, para, 'ETKINLIK-para');
                } else {
                  const env = handlers.envanterIcin(pk.payload);   // kademesiz etkinlik: eski yol
                  if (env) send(0x01180f02, env, 'ODUL-envanter');
                }
              } catch (e) { LOG.note(cid, 'odul envanter hata: ' + e.message); }
            }
            continue;
          }
          for (const e of ek.sonra) send(e.id, e.payload, e.kaynak);
        } catch (e) { handlers.ekAl(); LOG.note(cid, `handler hata ${reqHex}: ${e.message}`); }
      }
      // kapsamli gercek cevap (crawler'dan) — char paketi haric (o editChar'dan gelir)
      const cev = CEVAP[respHex];
      if (cev && respId !== CHAR_ID) {
        const payload = uyarla(pk, respId, Buffer.from(cev));
        syncHeroChangeResponse(pk.id, pk.payload, respId, payload);
        send(respId, payload, 'CEVAP-gercek');
        continue;
      }
      const queue = RESP[respHex];
      if (!queue || queue.length === 0) {
        // GECERLI-BOS cevap: hep sifir -> result=0(basari), count=0(bos liste), UTF=bos.
        syncHeroChangeResponse(pk.id, pk.payload, respId, ZERO_ACK);
        send(respId, ZERO_ACK, 'ACK-zero');
        continue;
      }
      const idx = rq[respHex] || 0;
      let payload = queue[Math.min(idx, queue.length - 1)];
      rq[respHex] = idx + 1;
      if (respId === CHAR_ID) payload = editChar(payload);
      payload = uyarla(pk, respId, payload);
      syncHeroChangeResponse(pk.id, pk.payload, respId, payload);
      send(respId, payload, `replay[${idx + 1}/${queue.length}]`);
      if (respId === CHAR_ID) loginPush();
    }
    pushBosalt();
  }
}).on('error', e => console.log(`10025 hata: ${e.message}`)).listen(GATE_PORT, '127.0.0.1', () => console.log(`[oyun-sunucu] 127.0.0.1:${GATE_PORT} (replay + para enjeksiyon)`));

// Flash policy 843
net.createServer(sock => { sock.on('error', () => { }); sock.once('data', () => sock.end(POLICY)); })
  .on('error', e => console.log(`843 hata: ${e.message}`)).listen(POLICY_PORT, '127.0.0.1', () => console.log(`[policy] 127.0.0.1:${POLICY_PORT}`));

console.log('veri.json:', JSON.stringify(veri()));
try {
  const d0 = durumMod.yukle();
  if (karakter.var(d0)) statlar.anaIdAyarla(karakter.anaId(d0));   // secilen protagonist tum modullere
  console.log('[karakter]', JSON.stringify(karakter.ozet(d0)), '| ana hero id:', seviye.anaId());
  console.log('[seviye]', JSON.stringify(seviye.ozet(d0)), '| [beceri]', JSON.stringify(beceri.ozet(d0)), '| partner(devsirilen):', meyhane.alinanlar(d0).length, '| kadro:', JSON.stringify(d0.kadro || {}));
  console.log('[bleachtrain]', JSON.stringify(handlers.bleachtrain.ozet(d0)));
} catch (e) { console.log('[durum] ozet hatasi:', e.message); }
