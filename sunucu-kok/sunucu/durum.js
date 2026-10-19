'use strict';
// Kalici oyuncu durumu — gercek sunucunun state'i. Admin tool bunu duzenler.
// Baslangic: yakalanan char paketi sablonu + veri.json birimleri. Modüller ekledikçe genisler.
const fs = require('fs');
const path = require('path');

const DURUM_DOSYA = require('./runtime-path')('oyuncu.json');
const VERI = require('./runtime-path')('veri.json');

const VARSAYILAN = {
  agentUserId: '352354512635355',
  agent: 54,
  server: 974,
  roleIdHi: 0x00000167,
  roleIdLo: 0x04d18922,
  nick: 'Miho Hinata',
  country: 0,
  militaryRank: 40100001,
  prestige: 0,
  // birimler (veri.json'dan da okunur)
  altin: 999999999,
  gumus: 999999999,
  gumusHigh: 0,
  kupon: 999999999,
  askeriEmir: 999999,
  vipLevel: 15,
  vipExp: 999999,
  // ilerledikce: level, herolar[], envanter[], vs.
};

function veriBirimleri() {
  try { return JSON.parse(fs.readFileSync(VERI, 'utf8')); } catch { return {}; }
}

function yukle() {
  require('./arena-rewards').recover();
  let d;
  try { d = JSON.parse(fs.readFileSync(DURUM_DOSYA, 'utf8')); } catch { d = { ...VARSAYILAN }; }
  // veri.json birimleri her zaman uygulanir (admin tool oradan yaziyor)
  const v = veriBirimleri();
  for (const k of ['altin', 'gumus', 'gumusHigh', 'kupon', 'askeriEmir', 'vipLevel', 'vipExp', 'generalsSoul']) {
    if (v[k] !== undefined) d[k] = v[k];
  }
  if (d.vipTrial && d.vipTrial.expires <= Math.floor(Date.now()/1000)) {
    const earned = require('./paket').tablo('VipConfig').liste.filter(row => Number(row.chargeCount) <= (Number(v.vipExp)||0)).sort((a,b)=>b._id-a._id)[0];
    v.vipLevel = Math.max(Number(d.vipTrial.previous)||0, earned ? earned._id : 0);
    fs.writeFileSync(VERI,JSON.stringify(v,null,2)); d.vipLevel=v.vipLevel; delete d.vipTrial;
    fs.writeFileSync(DURUM_DOSYA,JSON.stringify(d,null,2));
  }
  d.militaryRank = require('./military-rank').id(d,v);
  d.prestige = require('./military-rank').prestige(d,v);
  if (v.nick) d.nick = v.nick;
  return require('./retired-heroes').clean(d);
}

// Kalici yazim: once oyuncu.json (canli kaynak), ardindan oyun.db'ye AYNA.
// DB aynasi best-effort: veritabani yoksa/kilitliyse oyun akisini ASLA bozmaz.
function kaydet(d) {
  d = require('./retired-heroes').clean(d);
  fs.writeFileSync(DURUM_DOSYA, JSON.stringify(d, null, 2));
  try {
    const db = require('./db');
    db.durumYaz('oyuncu', d);
  } catch (e) { /* DB yoksa sessiz gec — oyuncu.json zaten yazildi */ }
}

module.exports = { yukle, kaydet, VARSAYILAN };
