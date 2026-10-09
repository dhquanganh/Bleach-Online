'use strict';
// OLAY / SAYAC OMURGASI — oyuncunun yaptigi her seyin KALICI sayaci + sunucu-ici olay yayini.
//
// Gorev/etkinlik/gunluk-gorev/basari/"Experiences" (BleachTrain) gibi sistemlerin sartlari
// ("N kez cultivate", "N kez arena", "seviye N", "gorev X bitti") bu sayaclardan okunur.
// Handler'lar `say(durum, anahtar, n)` / `ayarla(durum, anahtar, deger)` cagirir; abone moduller
// (bleachtrain.js vb.) degisen anahtara gore client'a push edilecek paketleri uretir; oyun-sunucu
// her istekten sonra `pushAl()` ile kuyrugu bosaltip gonderir.
//
// durum.olay = { sayac: { "<anahtar>": n }, gun: 'YYYY-MM-DD', gunluk: { "<anahtar>": n } }
// Anahtar sozlugu (bleachtrain.js SART tablosuyla ayni):
//   seviye (mutlak), cultivate, cultivateGold, cultivateOneKey, zanpakutoTrain, zanpakutoGodspeed,
//   recruit, soulmap, arenaFight, arenaReward, signin, dailyTask, dailyPoints, fortifyEquip,
//   fortifyAccessory, refineEquip, inheritEquip, gemInlay, gemSynth, hoguUpgrade, hoguEquip,
//   summon (Jigokucho), vitalityBuy, girlfriendExchange, girlfriendParty, homeUpgrade, girlfriendUpgrade,
//   luckyCat, konso, trialWin, soulHunt, soulHuntRob, guildJoin, guildDonateSilver, guildDonateGold,
//   guildRescue, slavePress, slaveCapture, slaveExp, slaveInteract, expBookUse, oneKeyExchange,
//   diceSilver, diceGold, beautyGame, doubleFortify, designateRefine, autoJanken, spiritForge,
//   militaryRank (mutlak), battlePower (mutlak), dailyActivityEvil/Ryoka/Protect/GuildWar, allianceBattle, allianceCampaign
const ABONELER = [];       // (durum, anahtar) => [{id, payload, kaynak}]
let PUSH = [];             // gonderilmeyi bekleyen paketler

function depo(durum) {
  if (!durum.olay || typeof durum.olay !== 'object') durum.olay = {};
  if (!durum.olay.sayac || typeof durum.olay.sayac !== 'object') durum.olay.sayac = {};
  const bugun = require('./paket').gun();   // yerel tarih
  if (durum.olay.gun !== bugun) { durum.olay.gun = bugun; durum.olay.gunluk = {}; }
  if (!durum.olay.gunluk || typeof durum.olay.gunluk !== 'object') durum.olay.gunluk = {};
  return durum.olay;
}
function oku(durum, anahtar) { return Number(depo(durum).sayac[String(anahtar)]) || 0; }
function gunlukOku(durum, anahtar) { return Number(depo(durum).gunluk[String(anahtar)]) || 0; }
function yay(durum, anahtar) {
  for (const f of ABONELER) { try { const p = f(durum, anahtar); if (Array.isArray(p)) PUSH.push(...p); } catch (e) { console.log('[olay] abone hatasi:', e.message); } }
}
/** Sayaci n artir (toplam + gunluk). */
function say(durum, anahtar, n) {
  const d = depo(durum); const k = String(anahtar); const a = Math.max(0, Math.floor(Number(n === undefined ? 1 : n) || 0));
  if (!a) return oku(durum, k);
  d.sayac[k] = (Number(d.sayac[k]) || 0) + a;
  d.gunluk[k] = (Number(d.gunluk[k]) || 0) + a;
  yay(durum, k);
  return d.sayac[k];
}
/** Mutlak deger (seviye, savas gucu, rutbe...). Yalniz artarsa yayinlanir. */
function ayarla(durum, anahtar, deger) {
  const d = depo(durum); const k = String(anahtar); const v = Math.max(0, Math.floor(Number(deger) || 0));
  const eski = Number(d.sayac[k]) || 0;
  d.sayac[k] = v;
  if (v !== eski) yay(durum, k);
  return v;
}
function abone(f) { if (typeof f === 'function') ABONELER.push(f); }
function pushAl() { const p = PUSH; PUSH = []; return p; }
function pushEkle(id, payload, kaynak) { if (payload) PUSH.push({ id: id >>> 0, payload, kaynak: kaynak || 'OLAY-push' }); }

module.exports = { depo, oku, gunlukOku, say, ayarla, abone, pushAl, pushEkle };
