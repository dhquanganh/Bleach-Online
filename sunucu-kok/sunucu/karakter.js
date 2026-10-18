'use strict';
// KARAKTER YARATMA — oyunun kendi "isim koy + protagonist sec" ekrani, KALICI.
//
// ============================ PROTOKOL (AS3: TProcessorGameRoot / TProcessorCreateChar) ============================
// Giris (CS_Login_GateServerTransmitToken 0x01810001) sonrasi gercek sunucu:
//   - karakteri OLAN hesaba SC_Account_CharInfoNtf 0x01180102 (char paketi) yollar;
//   - karakteri OLMAYAN hesaba SC_CREATECHAR_CreateCharCmd 0x01180100 (payload YOK) yollar ->
//     client karakter yaratma ekranini acar (PacketPerform_SC_EnterCreateChar).
// Client: CS_CREATECHAR_CreateChar 0x01810100 = [UTF isim][u8 profession][u8 gender]
//   profession: CONST_CHARACTER 4=Strength(Ghostsword) 1=Agility(Spiritbow) 3=Intellect(Hollowblade)
//   gender: 1=Male 0=Female  -> BaseHero isMain=1 satirlarindan (profession, sex) ile ana hero id:
//   11100001 Ghostsword M, 11100002 Ghostsword F, 11100003 Spiritbow M, 11100004 Spiritbow F,
//   11100005 Hollowblade M, 11100006 Hollowblade F  (PROFESSION_IDS sirasi, gender = index%2)
// Sunucu: SC_CREATECHAR_CreateCharRet 0x01180101 = [u32 hata] (0 = basari; hata ErrorCode.json)
//   -> client ekrani kapatip "loading" gosterir ve char paketini bekler -> sunucu char paketi +
//   login push'larini gonderir (girisGonder). Login durum makinesi bundan bagimsiz (token
//   gonderilince LoggedIn), o yuzden yaratma ekraninda beklemek baglantiyi dusurmez.
//
// ============================ KALICILIK ============================
//  durum.karakter = { nick, profession, gender, anaId, zaman }
//  veri.json.nick da guncellenir (admin paneli gosterir). Ana hero id statlar.anaIdAyarla ile
//  tum modullere (seviye/beceri/savas/soul map FType) yansir.
const fs = require('fs');
const path = require('path');

const V = path.join(__dirname, '..', 'cikarim', 'veri-json');
const num = h => parseInt(String(h), 16) >>> 0;
const OP_CMD = 0x01180100, OP_RET = 0x01180101;
const HATA_ISIM = 0x36;   // ErrorCode 54 "This name is already in use" / gecersiz isim icin en yakin
const HATA_GENEL = 1;

let MAIN = null;   // [{id, profession, sex, active, name}]
function anaRoller() {
  if (MAIN) return MAIN;
  MAIN = [];
  try {
    for (const h of JSON.parse(fs.readFileSync(path.join(V, 'BaseHero.json'), 'utf8'))) {
      if (Number(h.isMain) !== 1) continue;
      MAIN.push({ id: num(h.id), profession: Number(h.profession) || 0, sex: Number(h.sex) || 0, active: Number(h.active) >>> 0, name: h.name || '' });
    }
  } catch (e) {}
  return MAIN;
}
function anaRol(id) { return anaRoller().find(r => r.id === (id >>> 0)) || null; }
/** (profession, gender) -> ana hero id (0 = eslesme yok) */
function anaHeroId(profession, gender) {
  const r = anaRoller().find(x => x.profession === Number(profession) && x.sex === Number(gender));
  return r ? r.id : 0;
}

function var_(durum) { return !!(durum && durum.karakter && durum.karakter.nick && durum.karakter.anaId); }
function anaId(durum) { return var_(durum) ? (durum.karakter.anaId >>> 0) : 0; }
function nick(durum) { return var_(durum) ? String(durum.karakter.nick) : ''; }

function utfOku(b, p) { const n = b.readUInt16BE(p); return { s: b.toString('utf8', p + 2, p + 2 + n), son: p + 2 + n }; }
function utfYaz(s) { const t = Buffer.from(String(s), 'utf8'); const b = Buffer.alloc(2 + t.length); b.writeUInt16BE(t.length, 0); t.copy(b, 2); return b; }

/** CS 0x01810100 -> { hata, paket, karakter } */
function olustur(durum, payload) {
  const ret = h => { const b = Buffer.alloc(4); b.writeUInt32BE(h >>> 0, 0); return b; };
  try {
    if (!payload || payload.length < 4) return { hata: HATA_GENEL, paket: ret(HATA_GENEL) };
    const u = utfOku(payload, 0);
    const ad = u.s.trim();
    const profession = payload.length > u.son ? payload.readUInt8(u.son) : 0;
    const gender = payload.length > u.son + 1 ? payload.readUInt8(u.son + 1) : 1;
    if (!ad || ad.length > 16 || /[\x00-\x1f]/.test(ad)) return { hata: HATA_ISIM, paket: ret(HATA_ISIM) };
    const id = anaHeroId(profession, gender);
    if (!id) return { hata: HATA_GENEL, paket: ret(HATA_GENEL) };
    durum.karakter = { nick: ad, profession, gender, anaId: id, zaman: new Date().toISOString() };
    durum.nick = ad;
    delete durum.beceri;                       // yeni protagonist -> beceri durumu sifirdan (taban becerisi degisir)
    // eski protagonist'in kadro kaydi kalmasin (savas kadrosuna ikinci "ana" olarak girerdi)
    for (const kk of Object.keys(durum.kadro || {})) if (anaRol(Number(kk)) && (Number(kk) >>> 0) !== id) delete durum.kadro[kk];
    if (durum.seviye && durum.seviye.herolar) for (const kk of Object.keys(durum.seviye.herolar)) if (anaRol(Number(kk))) delete durum.seviye.herolar[kk];
    try {                                      // veri.json.nick (admin paneli / diger moduller)
      const VJ = require('./runtime-path')('veri.json');
      const v = JSON.parse(fs.readFileSync(VJ, 'utf8')); v.nick = ad; fs.writeFileSync(VJ, JSON.stringify(v, null, 2));
    } catch (e) {}
    return { hata: 0, paket: ret(0), karakter: durum.karakter };
  } catch (e) { return { hata: HATA_GENEL, paket: ret(HATA_GENEL) }; }
}

/**
 * Char paketini secilen karaktere gore yeniden kur: NickName UTF (uzunluk degisebilir ->
 * paket yeniden birlestirilir), ana hero girisi: id (offset 0), Profession (offset 16),
 * Skill (BaseHero.active; beceri.js taban olarak ayni degeri kullanir). Diger her sey aynen.
 * Ham (yakalanmis) paket uzerinde, editChar'dan ONCE cagrilir.
 */
function charYama(buf, durum, basicEnd) {
  if (!var_(durum)) return buf;
  const k = durum.karakter;
  const rol = anaRol(k.anaId); if (!rol) return buf;
  let b = Buffer.from(buf);
  // 1) NickName: AgentOp4 Server4 UTF(user) RoleId8 UTF(nick)
  let p = 8; p += 2 + b.readUInt16BE(p); p += 8;
  const eski = utfOku(b, p);
  if (eski.s !== k.nick) b = Buffer.concat([b.subarray(0, p), utfYaz(k.nick), b.subarray(eski.son)]);
  // 2) ana hero girisi
  const e = basicEnd(b);
  if (e + 2 > b.length || b.readUInt16BE(e) === 0) return b;
  const s = e + 2;
  b.writeUInt32BE(rol.id >>> 0, s);           // Identifier
  b[s + 16] = rol.profession & 0xff;           // Profession (Soul Map FType bundan turetilir)
  const n = b.readInt16BE(s + 22);
  const hist = s + 24 + 9 * Math.max(0, n) + 32 + 3;
  if (hist + 12 <= b.length && rol.active) { b.writeUInt32BE(rol.active >>> 0, hist + 7); b[hist + 11] = 1; }
  return b;
}

function cmdPaketi() { return Buffer.alloc(0); }
function ozet(durum) { return var_(durum) ? { nick: durum.karakter.nick, anaId: durum.karakter.anaId, rol: (anaRol(durum.karakter.anaId) || {}).name } : null; }

module.exports = { OP_CMD, OP_RET, anaRoller, anaRol, anaHeroId, var: var_, anaId, nick, olustur, charYama, cmdPaketi, ozet, utfYaz };
