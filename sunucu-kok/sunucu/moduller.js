'use strict';
// MODUL KAYIT DEFTERI — handlers.js'in byReq'ine eklenen ek handler'lar.
// handlers.js yardimcilari `y` ile gelir (dongusel require olmasin): { W, olay, ekOnce, ekSonra, odulVer,
// paraHarca, paraIcinOdul, odulBulKesin, envanterDepo, sayacDepo, gunTarihi, seviye, beceri, meyhane, evcil, awardOf }.
// Her handler: ({ reqId, payload, durum, kaydet }) => Buffer | {id,payload} | false (islendi, ana cevap yok) | null (fallback).
const lonca = require('./lonca');

let SON_HURDLE = 0;
function sonHurdleAyarla(cityId) { SON_HURDLE = Number(cityId) || 0; }

function kur(y) {
  const { W, olay, ekOnce, ekSonra, odulVer, paraHarca } = y;
  const harca = awards => { const p = paraHarca(awards); if (p) ekOnce(0x01180105, p, 'HARCAMA'); return !!p; };
  const u32 = v => { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); return b; };
  const H = {};

  // ================== LONCA (0x2500) ==================
  H['0x01812507'] = ({ durum }) => lonca.bilgiPaketi(durum);
  H['0x01812517'] = () => lonca.aktiviteDurumPaketi();
  H['0x01812508'] = ({ durum }) => lonca.kampPaketi(durum);
  H['0x01812506'] = ({ durum }) => lonca.uyeListesi(durum);
  H['0x01812500'] = ({ durum }) => lonca.loncaListesi(durum);
  H['0x01812501'] = ({ payload, durum, kaydet }) => {
    const r = lonca.kur(durum, payload);
    if (!r.hata) { olay.say(durum, 'guildJoin', 1); try { kaydet(durum); } catch (e) {} console.log(`[lonca] kuruldu: "${r.ad}"`); }
    return r.paket;
  };
  H['0x01812502'] = () => Buffer.concat([u32(0), u32(0)]);
  H['0x01812503'] = ({ payload, durum, kaydet }) => {
    const tip = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 1;
    const r = lonca.yukselt(durum, tip);
    if (!r.hata) { try { kaydet(durum); } catch (e) {} console.log(`[lonca] yukseltme tip${tip} -> ${r.yeni} (-${r.bedel})`); }
    return r.paket;
  };
  H['0x01812505'] = ({ payload, durum, kaydet }) => {
    const tip = payload && payload.length >= 4 ? payload.readUInt32BE(0) : 0;
    const r = lonca.techYukselt(durum, tip);
    if (!r.hata) { try { kaydet(durum); } catch (e) {} }
    return r.paket;
  };
  H['0x01812504'] = () => Buffer.concat([u32(0), Buffer.from([0, 0])]);
  H['0x01812511'] = () => Buffer.concat([u32(0), Buffer.from([0, 0])]);
  H['0x01812509'] = () => u32(0);
  H['0x01812512'] = ({ durum }) => lonca.depoPaketi(durum);
  H['0x01812513'] = ({ payload, durum, kaydet }) => {
    const r = lonca.depoDagit(durum, payload, { ver: o => odulVer(durum, o) });
    if (!r.hata) { try { kaydet(durum); } catch (e) {} }
    return r.paket;
  };
  H['0x01812514'] = ({ payload, durum, kaydet }) => {
    const r = lonca.bagis(durum, payload, { harca });
    if (!r.hata) {
      if (r.gumus) { olay.say(durum, 'guildDonateSilver', 1); olay.say(durum, 'guildDonateSilverAmount', r.gumus); }
      if (r.altin) olay.say(durum, 'guildDonateGold', 1);
      try { kaydet(durum); } catch (e) {}
      console.log(`[lonca] bagis: altin ${r.altin} gumus ${r.gumus}`);
    }
    return r.paket;
  };
  H['0x01812515'] = ({ durum, kaydet }) => { const p = lonca.ayril(durum); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812516'] = ({ durum, kaydet }) => { const p = lonca.dagit(durum); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812518'] = ({ payload, durum, kaydet }) => { const p = lonca.duyuru(durum, payload); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812519'] = ({ durum }) => lonca.logPaketi(durum);
  H['0x01812521'] = () => u32(0);
  H['0x01812510'] = () => lonca.muyeBattle();
  H['0x01812522'] = () => lonca.cityDefend();
  H['0x01812523'] = ({ durum }) => lonca.tekInit(durum);
  H['0x01812524'] = ({ payload, durum, kaydet }) => { const c = payload && payload.length >= 4 ? payload.readInt32BE(0) : 0; const p = lonca.tekGiris(durum, c); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812526'] = ({ durum }) => lonca.grupInit(durum);
  H['0x01812527'] = ({ payload, durum, kaydet }) => { const c = payload && payload.length >= 8 ? payload.readInt32BE(0) : 0, i = payload && payload.length >= 8 ? payload.readInt32BE(4) : 0; const p = lonca.grupAc(durum, c, i); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812528'] = ({ durum }) => lonca.grupGiris(durum);
  H['0x01812529'] = ({ payload, durum, kaydet }) => { const c = payload && payload.length >= 8 ? payload.readInt32BE(0) : 0, i = payload && payload.length >= 8 ? payload.readInt32BE(4) : 0; const p = lonca.kopyaYenile(durum, c, i); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01812700'] = ({ payload }) => lonca.savasKomut(payload);
  H['0x0181020a'] = () => u32(1);                        // Enter_OrganizationWar: tek oyunculu -> sehirde kal
  // OrgPointMap (0x7800)
  H['0x01817801'] = ({ payload, durum, kaydet }) => { const c = payload && payload.length >= 8 ? payload.readInt32BE(0) : 0, n = payload && payload.length >= 8 ? payload.readInt32BE(4) : 0; const p = lonca.noktaSifirla(durum, c, n); try { kaydet(durum); } catch (e) {} return p; };
  H['0x01817803'] = ({ payload, durum, kaydet }) => {
    const c = payload && payload.length >= 8 ? payload.readInt32BE(0) : 0, n = payload && payload.length >= 8 ? payload.readInt32BE(4) : 0;
    const p = lonca.grupMeydan(durum, c, n); try { kaydet(durum); } catch (e) {}
    try { const savas = require('./savas'); for (const fr of savas.fightFrames(0x01817803, payload)) ekSonra(fr.id, fr.payload, 'LONCA-savas'); } catch (e) { console.log('[lonca] grup savas hatasi:', e.message); }
    return p;
  };
  H['0x01817804'] = () => false;                          // QuitMap: cevap beklenmez
  // PointMapInfoUI (0x7900)
  H['0x01817900'] = () => Buffer.concat([u32(0), Buffer.from([0, 0])]);
  H['0x01817901'] = () => Buffer.concat([u32(0), Buffer.from([0, 0]), u32(0)]);
  H['0x01817902'] = () => Buffer.concat([u32(0), Buffer.from([0, 0])]);
  H['0x01817903'] = () => Buffer.concat([u32(0), Buffer.from([0, 0]), u32(0)]);
  H['0x01817904'] = () => Buffer.concat([u32(0), Buffer.from([0, 0])]);
  // TimeMall (0x7A00)
  H['0x01817a00'] = ({ payload, durum }) => lonca.timeMall(durum, payload);
  H['0x01817a01'] = ({ payload, durum }) => lonca.timeMall(durum, payload);
  H['0x01817a02'] = ({ payload }) => lonca.timeMallSatin(payload);

  // ================== DIGER MODULLER ==================
  const y2 = { ...y, sonHurdle: () => SON_HURDLE };
  const moduller = [['ekipman', './ekipman'], ['savas-etkinlik', './savas-etkinlik'], ['evcil-ek', './evcil-ek'], ['ev', './ev'], ['sosyal', './sosyal'], ['zanpakuto', './zanpakuto']];
  for (const [ad, yol] of moduller) {
    try {
      const m = require(yol).kur(y2);
      let n = 0; for (const [k, f] of Object.entries(m)) { H[k] = f; n++; }
      console.log(`[moduller] ${ad}: ${n} handler`);
    } catch (e) { console.log(`[moduller] ${ad} yuklenemedi:`, e.message); }
  }
  return H;
}

module.exports = { kur, sonHurdleAyarla };
