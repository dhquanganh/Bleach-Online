'use strict';
// SOSYAL / GUNLUK / MAGAZA MODULLERI: Mail, Friend, DailyTask, Sign, MilitaryRank, Heros (sil/slot/yenile),
// BlackMarket, Mall (satin alma gercek teslimat), Log, ChangeInfo, Inspector, Knife, YellowDiamond, Achievement,
// CDK, Mentorship SOS, HeroID_DataReq (kahraman edinme). Kaynak: scratchpad/spec-sosyal.md.
const fs = require('fs');
const path = require('path');
const { Y, O, tablo, satir, json, cv, simdi, gunluk, rnd, sec } = require('./paket');
const envanter = require('./envanter');

const VERI = require('./runtime-path')('veri.json');
function veriOku() { try { return JSON.parse(fs.readFileSync(VERI, 'utf8')); } catch (e) { return {}; } }
function veriYaz(v) { try { fs.writeFileSync(VERI, JSON.stringify(v, null, 2)); } catch (e) { } }
function heroEkle(id) { const v = veriOku(); v.herolar = Array.isArray(v.herolar) ? v.herolar : []; if (!v.herolar.map(Number).includes(id)) { v.herolar.push(id); veriYaz(v); return true; } return false; }
function heroSil(id) { const v = veriOku(); if (!Array.isArray(v.herolar)) return false; const n = v.herolar.filter(x => Number(x) !== id); if (n.length === v.herolar.length) return false; v.herolar = n; veriYaz(v); return true; }
const MAIL_IDX = { 0: { type: 0, code: 0 }, 1: { type: 0, code: 2 }, 3: { type: 0, code: 1 }, 4: { type: 6, code: 0 }, 5: { type: 5, code: 0 }, 11: { type: 2, code: 0 } };
const DEMON_MALL_ID = 0x00a97eb2, DEMON_ITEM_ID = 14100331, DEMON_HERO_ID = 11140008, DEMON_PRICE = 500000;

function kur(y) {
  const { ekSonra, ekOnce, odulVer, paraHarca, paraIcinOdul, awardOf, seviye, olay } = y;
  const H = {};
  const harca = list => { const pk = paraHarca(list); if (pk) ekSonra(0x01180105, pk, 'SOSYAL-para'); return !!pk; };
  const altin = n => n > 0 ? harca([{ type: 0, code: 1, amount: n }]) : true;
  const mallGoldPrice = (m, vipLevel) => {
    if (Number(m.isHot) === 1 || Number(m.isnew) === 1) return Math.max(0, Number(m.hotprice) || 0);
    const requiredVip = Number(m.vip) || 0;
    if (requiredVip > 0 && requiredVip <= vipLevel) return Math.max(0, Number(m.discount) || 0);
    return Math.max(0, Number(m.gold) || 0);
  };
  const chargeMallGold = amount => {
    const v = veriOku();
    const gold = Math.max(0, Number(v.altin) || 0);
    const coupon = Math.max(0, Number(v.kupon) || 0);
    if (!Number.isSafeInteger(amount) || amount < 0 || amount > gold + coupon) return false;
    let remainder = amount;
    const goldSpend = Math.min(gold, remainder);
    remainder -= goldSpend;
    const couponSpend = remainder;
    const charge = [];
    if (goldSpend) charge.push({ type: 0, code: 1, amount: goldSpend });
    if (couponSpend) charge.push({ type: 0, code: 2, amount: couponSpend });
    if (!charge.length) return true;
    const packet = paraHarca(charge);
    if (!packet) return false;
    ekSonra(0x01180105, packet, 'MAGAZA-para');
    return true;
  };
  const K = (kaydet, d) => { try { kaydet(d); } catch (e) { } };
  const gecerli = list => (list || []).filter(a => a && (([1, 17, 21, 23].includes(Number(a.type)) && satir('Article', a.code)) || envanter.odulTemplate(Number(a.type), Number(a.code))));
  const ver = (d, list) => { const l = gecerli(list); if (l.length) odulVer(d, l); return l; };
  const anaLv = () => { try { return seviye.anaDurum(veriOku()).lv; } catch (e) { return 1; } };
  const baseInfo = items => { try { return require('./harita').baseInfoUpdate(items); } catch (e) { return null; } };

  // ================= MAIL =================
  const posta = d => { d.posta = d.posta || { gelen: [], giden: [], seq: 1 }; const p = d.posta; if (!p.hosgeldin) { p.hosgeldin = 1; p.gelen.push({ hi: 0, lo: p.seq++, ad: 'Gotei 13', konu: 'Welcome to Soul Society', metin: 'Welcome, Shinigami! Here is a starter pack to begin your journey. All progress on this server is saved automatically.', zaman: simdi(), okundu: 0, ek: [[0, 100000], [14100003, 5], [14100074, 500]] }); } return p; };
  const mailYaz = (w, m, tip) => { w.u32(m.hi).u32(m.lo).utf(m.ad).utf(m.konu).utf(m.metin).u32(m.zaman).i8(m.okundu ? 1 : 0).u32(0); const ek = (m.ek || []).filter(e => e[0] < 10000 ? MAIL_IDX[e[0]] : satir('Article', e[0])); w.u16(ek.length); for (const e of ek) w.u32(e[0]).u32(e[1]); };
  H['0x01811600'] = ({ durum, kaydet }) => { const p = posta(durum); K(kaydet, durum); const w = new Y().u32(0).u16(p.gelen.length); for (const m of p.gelen) mailYaz(w, m, 1); w.u16(p.giden.length); for (const m of p.giden) mailYaz(w, m, 2); return w.done(); };
  H['0x01811601'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const kime = o.utf(), konu = o.utf(), metin = o.utf(); const p = posta(durum); const m = { hi: 0, lo: p.seq++, ad: kime || 'Unknown', konu, metin, zaman: simdi(), okundu: 1, ek: [] }; p.giden.push(m); if (p.giden.length > 30) p.giden.shift(); K(kaydet, durum); const w = new Y().u32(0); mailYaz(w, m, 2); return w.done(); };
  H['0x01811602'] = ({ payload, durum, kaydet }) => {
    if(!Buffer.isBuffer(payload)||payload.length<3||payload.length!==3+payload.readUInt16BE(1)*8)return new Y().u32(4).done();
    const o=new O(payload),box=o.u8(),n=o.u16(),p=posta(durum),ids=[];for(let i=0;i<n;i++)ids.push([o.u32(),o.u32()]);
    const list=box===2?p.giden:p.gelen;
    if(list.some(m=>(m.bossPayoutId||m.adminGrantId)&&m.ek.length&&ids.some(([hi,lo])=>hi===m.hi&&lo===m.lo)))return new Y().u32(1).done();
    for(const [hi,lo] of ids){const i=list.findIndex(m=>m.hi===hi&&m.lo===lo);if(i>=0)list.splice(i,1);}
    K(kaydet,durum);const w=new Y().u32(0).u8(box).u16(ids.length);for(const [hi,lo] of ids)w.u32(hi).u32(lo);return w.done();
  };
  H['0x01811603'] = ({ payload, durum, kaydet }) => {
    if(!Buffer.isBuffer(payload)||payload.length<2||payload.length!==2+payload.readUInt16BE(0)*8)return new Y().u32(4).done();
    const o=new O(payload),n=o.u16(),ids=[];for(let i=0;i<n;i++)ids.push([o.u32(),o.u32()]);
    let adminClaim;try{adminClaim=require('./admin-item-mail').claim({durum,kaydet},ids);}catch(e){return new Y().u32(1).done();}
    if(adminClaim.error)return new Y().u32(adminClaim.error).done();
    for(const update of adminClaim.updates)ekSonra(update.id,update.payload,'ADMIN-mail-claim');
    let claimed;try{claimed=(y.bossRewardMail||require('./boss-reward-mail')).claim({durum,kaydet},ids);}catch(e){return new Y().u32(1).done();}
    if(claimed.error)return new Y().u32(claimed.error).done();
    for(const update of claimed.updates)ekSonra(update.id,update.payload,'BOSS-mail-claim');
    const p=posta(durum),oduller=[];
    for(const [hi,lo] of ids){const m=p.gelen.find(x=>x.hi===hi&&x.lo===lo);if(!m||m.bossPayoutId||m.adminGrantId)continue;
      for(const e of m.ek||[]){if(e[0]<10000){const t=MAIL_IDX[e[0]];if(t)oduller.push({type:t.type,code:t.code,amount:e[1]});}else oduller.push({type:1,code:e[0],amount:e[1]});}m.ek=[];
    }
    ver(durum,oduller);K(kaydet,durum);return new Y().u32(0).done();
  };
  H['0x01811604'] = ({ payload, durum, kaydet }) => { const o = new O(payload); o.u8(); const hi = o.u32(), lo = o.u32(); const m = posta(durum).gelen.find(x => x.hi === hi && x.lo === lo); if (m) { m.okundu = 1; K(kaydet, durum); } return false; };
  // ================= FRIEND =================
  H['0x01811501'] = () => new Y().u32(0).u16(0).done();
  H['0x01811504'] = () => new Y().u32(1).done();
  // ================= DAILY TASK =================
  Object.assign(H, require('./daily-tasks').kur(y));
  // ================= SIGN =================
  const imza = d => { const ay = new Date().getMonth(); d.imza = d.imza || { ay, mask: 0, total: 0, reward: 1, integral: 0 }; if (d.imza.ay !== ay) { d.imza.ay = ay; d.imza.mask = 0; } return d.imza; };
  // Sunucu saati (Inspector_QuertServerTime): client ServerTick/ServerTime'i BURADAN alir; yakalanmis sabit cevap
  // "bugun"u yakalama gununde donduruyordu (imza yanlis gune yaziliyor, CD'ler sapiyordu).
  // ServerTime = tick - serverTz + clientTz; clientTz = timezoneOffset*60 -> serverTz = sunucu makinesinin
  // timezoneOffset*60 verilirse client'in gordugu tarih = yerel tarih. Paket: [u32 0][i32 tz][u32 now][u32 start][i32 tz]
  H['0x0181a002'] = () => { const tz = new Date().getTimezoneOffset() * 60; const now = simdi(); return new Y().u32(0).i32(tz).u32(now).u32(now - 30 * 86400).i32(tz).done(); };
  H['0x01811b00'] = ({ durum, kaydet }) => { const s = imza(durum); try { const cur = olay.oku(durum, 'signin'); if (s.total > cur) olay.say(durum, 'signin', s.total - cur); } catch (e) { } K(kaydet, durum); return new Y().u32(0).u32(s.ay).u32(s.mask).u32(s.integral).u32(Math.max(1, Math.min(5, s.reward))).u32(s.total).u32(simdi() - 30 * 86400).u32(0).u32(0).u32(0).done(); };
  H['0x01811b01'] = ({ payload, durum, kaydet }) => { const day = new O(payload).u32(); const s = imza(durum); if (day < 1 || day > 31 || (s.mask & (1 << (day - 1)))) return new Y().u32(1).done(); s.mask |= 1 << (day - 1); s.total++; s.integral += 10; ver(durum, [{ type: 0, code: 0, amount: 20000 }, { type: 0, code: 2, amount: 5 }]); const p = baseInfo([{ index: 13, v: s.integral }]); if (p) ekSonra(0x01180105, p, 'IMZA-puan'); olay.say(durum, 'signin', 1); K(kaydet, durum); console.log(`[imza] gun ${day} imzalandi (toplam ${s.total})`); return new Y().u32(0).u32(day).done(); };
  H['0x01811b02'] = ({ durum, kaydet }) => { const s = imza(durum); const sr = satir('SignReward', s.reward); if (!sr || s.total < Number(sr.day)) return new Y().u32(1).done(); ver(durum, json(sr.f2, [])); s.reward = Math.min(5, s.reward + 1); K(kaydet, durum); return new Y().u32(0).u32(s.reward).done(); };
  H['0x01811b03'] = () => new Y().u32(0).u32(0).u32(0).done();
  // ================= MILITARY RANK =================
  Object.assign(H, require('./military-rank').kur(y));
  // ================= HEROS =================
  H['0x01811003'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); if (id === (seviye.anaId() >>> 0)) return new Y().i32(1).i32(id).done(); heroSil(id); try { const m = require('./meyhane').depo(durum); if (m) { delete m.alinan[String(id)]; delete m.kalite[String(id)]; } delete (durum.kadro || {})[String(id)]; delete ((durum.seviye || {}).herolar || {})[String(id)]; } catch (e) { } try { const e = require('./ekipman').depo(durum); const tak = e.takili[String(id)] || {}; const bufs = Object.values(tak).map(i => require('./ekipman').kayitBufInst(durum, i)).filter(Boolean); delete e.takili[String(id)]; if (bufs.length) ekSonra(0x01180f01, require('./ekipman').sendPaketi(bufs), 'HERO-sil-esya'); } catch (e) { } K(kaydet, durum); return new Y().i32(0).i32(id).done(); };
  H['0x01811005'] = ({ durum, kaydet }) => { durum.heroSlotEk = (Number(durum.heroSlotEk) || 0) + 1; if (!altin(50)) { durum.heroSlotEk--; return new Y().u32(16).done(); } K(kaydet, durum); return new Y().u32(0).u32(durum.heroSlotEk).done(); };
  H['0x01811006'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const id = o.i32(), opt = o.i32(); const th = satir('TimeHero', id); const bedel = th ? [Number(th.oneDayCost), Number(th.threeDayCost), Number(th.sevenDayCost), Number(th.foreverCost)][Math.max(0, Math.min(3, opt))] || 50 : 50; if (!altin(bedel)) return new Y().u32(16).done(); durum.kiralik = durum.kiralik || {}; const sure = [86400, 259200, 604800, 0][Math.max(0, Math.min(3, opt))]; durum.kiralik[String(id)] = sure ? simdi() + sure : 0; K(kaydet, durum); const lv = seviye.heroSeviye(durum, id, veriOku()); ekSonra(0x01180c02, new Y().u32(0).u32(id).u32(lv).u32(durum.kiralik[String(id)]).u32(0).done(), 'HERO-yenile'); return new Y().u32(0).u32(id).done(); };
  // ================= BLACK MARKET / MALL =================
  H['0x01817000'] = () => new Y().i32(1).done(); H['0x01817001'] = () => new Y().i32(1).done(); H['0x01817002'] = () => new Y().i32(1).done();
  H['0x01817003'] = () => new Y().u8(1).i32(simdi()).done();
  H['0x01811a02'] = ({ durum }) => { const al = Object.entries((durum.magaza || {}).onur || {}); const w = new Y().u32(0).u32(al.reduce((s, [, n]) => s + n, 0)).i16(al.length); for (const [id, n] of al) w.u32(Number(id)).u32(n); return w.done(); };
  H['0x01811a01'] = ({ durum }) => {
    const rows=Object.entries((durum.magaza||{}).alim||{}).filter(([id,n])=>n>0&&satir('Mall',Number(id)));
    const w=new Y().u32(0).i16(rows.length);
    for(const [id,n] of rows)w.u32(Number(id)).u32(Number(n));
    return w.done();
  };
  H['0x01811a00'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const rowId = o.u32(); const qty = Math.max(1, o.u16() || 1); const m = satir('Mall', rowId); if (!m) return new Y().u32(4).done();
    durum.magaza = durum.magaza || {};
    durum.magaza.onur = durum.magaza.onur || {};
    durum.magaza.vip = durum.magaza.vip || {};
    durum.magaza.alim = durum.magaza.alim || {};
    const model = Number(m.model), item = Number(m.itemID);
    if([12,13].includes(model)&&[14100282,14100283,14100733].includes(Number(json(m.honour,{}).code)))return require('./cross-server').kur(y).exchange({payload,durum,kaydet},m,qty);
    if(model===15)return require('./crash-jade').kur(y).exchange({payload,durum,kaydet},m,qty);
    if(model===3){if(payload.length!==6)return new Y().u32(4).done();return require('./soul-hunt').kur(y).exchange({payload,durum,kaydet},m,payload.readUInt16BE(4));}
    const fiyat = rowId === DEMON_MALL_ID ? DEMON_PRICE : mallGoldPrice(m, Number(veriOku().vipLevel) || 0);
    if (rowId === DEMON_MALL_ID) {
      const v = veriOku();
      const owned = (Array.isArray(v.herolar) && v.herolar.map(Number).includes(DEMON_HERO_ID))
        || v.tumKarakterler === true || v.tumKarakterler === 'true'
        || Number((durum.meyhane || {}).alinan?.[String(DEMON_HERO_ID)]) > 0;
      if (model !== 2 || Number(m.majorType) !== 1 || item !== DEMON_ITEM_ID || qty !== 1 || owned || Number(durum.magaza.alim[String(DEMON_MALL_ID)]) > 0) return new Y().u32(1).done();
    }
    const tur = json(m.type, [2]); const kur = Number(tur[0]) || 2;   // type: [7]=integral(sign), [2]=gold, [11]=honor ...
    if (model === 2 || model === 14 || model === 3) {
      const total = fiyat * qty;
      if (!Number.isSafeInteger(total) || !chargeMallGold(total)) return new Y().u32(16).done();
    }
    else if (model === 1) { const s = imza(durum); const bedel = (Number(m.integration) || 0) * qty; if (s.integral < bedel) return new Y().u32(1).done(); s.integral -= bedel; const p = baseInfo([{ index: 13, v: s.integral }]); if (p) ekSonra(0x01180105, p, 'MAGAZA-puan'); }
    else if (model === 15) { const h = require('./ekipman').hog(durum); const hon = json(m.honour, null); const bedel = hon && Number(hon.amount) ? Number(hon.amount) * qty : qty; if (h.coin < bedel) return new Y().u32(1).done(); h.coin -= bedel; h.satinAlim = h.satinAlim || {}; h.satinAlim[String(rowId)] = (h.satinAlim[String(rowId)] || 0) + qty; }
    else if (model === 11) { const bedel = (Number(m.integration) || Number(m.f20) || 0) * qty; const s = durum.etkinlikSavas || {}; if ((s.onur || 0) < bedel) return new Y().u32(1).done(); s.onur -= bedel; durum.magaza.onur[String(rowId)] = (durum.magaza.onur[String(rowId)] || 0) + qty; }
    else if (model === 13) { const bedel = (Number(m.integration) || 0) * qty; if (bedel && !envanter.dus(durum, 14100279, bedel) && !altin(fiyat * qty)) return new Y().u32(18).done(); }
    else if (fiyat && !altin(fiyat * qty)) return new Y().u32(16).done();
    const adet = Math.max(1, Number(m.amount) || 1) * qty;
    if (Number(m.majorType) === 2 || Number(m.majorType) === 5) { if (satir('BaseHero', item)) { heroEkle(item); ekSonra(0x01180c02, new Y().u32(0).u32(item).u32(anaLv()).u32(0).u32(0).done(), 'MAGAZA-hero'); try { seviye.heroKayit(durum, item, anaLv()); } catch (e) { } } }
    else if (model === 15 && satir('CrashJade', item)) { const h = require('./ekipman').hog(durum); const j = { hi: 1, lo: h.seq++, tpl: item, exp: 0 }; h.canta.push(j); ekSonra(0x01186c16, new Y().u32(0).u32(0).u32(h.pelet).u32(j.hi).u32(j.lo).u32(j.tpl).done(), 'MAGAZA-hogyoku'); }
    else if (item === 14620000) { const h = require('./ekipman').hog(durum); h.pelet += adet; ekSonra(0x01186c16, new Y().u32(0).u32(1).u32(h.pelet).u32(0).u32(0).u32(0).done(), 'MAGAZA-pelet'); }
    else if (satir('Article', item)) { ver(durum, [{ type: 1, code: item, amount: adet }]); }
    durum.magaza.alim[String(rowId)] = (durum.magaza.alim[String(rowId)] || 0) + qty; if (model === 14) { durum.magaza.vip[String(rowId)] = (durum.magaza.vip[String(rowId)] || 0) + qty; ekSonra(0x01181a05, new Y().u32(rowId).u32(durum.magaza.vip[String(rowId)]).done(), 'MAGAZA-vip'); }
    olay.say(durum, 'mallBuy', qty); K(kaydet, durum); console.log(`[magaza] ${m.name} x${qty} (model ${model})`);
    return new Y().u32(0).done();
  };
  H['0x01811a04'] = ({ durum }) => { const al = Object.entries((durum.magaza || {}).vip || {}); const w = new Y().i16(al.length); for (const [id, n] of al) w.u32(Number(id)).u32(n); return w.done(); };
  // ================= LOG / CHANGE INFO / INSPECTOR =================
  H['0x01816b00'] = ({ payload }) => new Y().u32(new O(payload).u32()).u16(0).done();
  H['0x01816b01'] = ({ payload }) => new Y().u32(new O(payload).u32()).u16(0).done();
  H['0x01818600'] = ({ payload, durum, kaydet }) => { const ad = new O(payload).utf().trim(); if (!ad || ad.length > 16) return new Y().u32(1).done(); if (!altin(50)) return new Y().u32(16).done(); durum.nick = ad; if (durum.karakter) durum.karakter.nick = ad; const v = veriOku(); v.nick = ad; veriYaz(v); K(kaydet, durum); console.log(`[isim] -> ${ad}`); return new Y().u32(0).done(); };
  H['0x01818601'] = ({ payload, durum, kaydet }) => { const c = new O(payload).u8(); if (c < 1 || c > 3) return new Y().u32(1).done(); durum.country = c - 1; K(kaydet, durum); const p = baseInfo([{ index: 18, v: c - 1 }]); if (p) ekSonra(0x01180105, p, 'ULKE'); return new Y().u32(0).u8(c).done(); };
  H['0x0181a000'] = ctx => {
    try { return require('./player-profile').inspect(ctx); }
    catch(error) { console.error('[Inspector]',error.message);return new Y().u32(1).done(); }
  };
  H['0x0181a001'] = ({ payload }) => { const o = new O(payload); o.u32(); o.u32(); const tpl = o.u32(); return new Y().u32(1).u8(0).u32(tpl).done(); };
  H['0x0181a003'] = ({ payload }) => { const o = new O(payload); const inst = o.u32(), tpl = o.u32(); return new Y().u32(0).u32(inst).u32(tpl).u32(0).u32(inst).done(); };
  // ================= KNIFE (Zanpakuto of Kill Soul) =================
  const bicak = d => { d.bicak = d.bicak || { acik: [], sekil: 0, guc: {} }; return d.bicak; };
  H['0x01814102'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); if (!satir('Knife', id)) return new Y().u32(4).done(); const b = bicak(durum); if (!b.acik.includes(id)) b.acik.push(id); K(kaydet, durum); return new Y().u32(0).u32(id).done(); };
  H['0x01814104'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const op = o.u8(), id = o.u32(); const b = bicak(durum); if (op === 1 && !b.acik.includes(id)) b.acik.push(id); b.sekil = op === 1 ? id : 0; K(kaydet, durum); return new Y().u32(0).u8(op).u32(id).done(); };
  H['0x01814105'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const id = o.i32(), attr = Math.max(0, Math.min(2, o.i32())), up = o.i32(); const b = bicak(durum); const k = b.guc[String(id)] || [0, 0, 0]; k[attr] = (k[attr] || 0) + 1; b.guc[String(id)] = k; K(kaydet, durum); return new Y().u32(0).i32(id).i32(attr).i32(k[attr]).i32(0).done(); };
  H['0x01811404'] = () => false;
  // ================= YELLOW DIAMOND / ACHIEVEMENT / CDK / MENTOR =================
  H['0x01815100'] = () => new Y().u32(0).u8(0).u8(0).u8(0).u8(0).u8(0).u8(0).u32(0).u32(0).done();
  H['0x01815101'] = ({ payload }) => { const o = new O(payload); const tip = o.u32(); return new Y().u32(0).u32(tip).u32(0).u16(0).done(); };
  H['0x01815201'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const a = satir('Achievement', id); if (!a) return new Y().u32(4).u32(id).done(); durum.basari = durum.basari || {}; if (durum.basari[String(id)]) return new Y().u32(1).u32(id).done(); durum.basari[String(id)] = 1; ver(durum, json(a.titleID, [])); K(kaydet, durum); ekSonra(0x01185202, new Y().u32(id).u32(1).i16(0).done(), 'BASARI'); return new Y().u32(0).u32(id).done(); };
  const CDK = { 'BLEACH2026': [{ type: 0, code: 1, amount: 500 }, { type: 1, code: 14100003, amount: 10 }], 'SOULSOCIETY': [{ type: 0, code: 0, amount: 500000 }, { type: 1, code: 14100074, amount: 1000 }], 'BANKAI': [{ type: 1, code: 14100010, amount: 20 }, { type: 0, code: 2, amount: 200 }] };
  H['0x01812304'] = ({ payload, durum, kaydet }) => { const kod = new O(payload).utf().trim().toUpperCase(); durum.cdk = durum.cdk || {}; if (!CDK[kod] || durum.cdk[kod]) return new Y().u32(1).done(); durum.cdk[kod] = 1; ver(durum, CDK[kod]); K(kaydet, durum); console.log(`[cdk] ${kod} kullanildi`); return new Y().u32(0).done(); };
  H['0x01813504'] = () => new Y().u32(0).i16(0).done();
  // ================= UNVAN / KIZ OYUNU / GUNLUK KAYIT / LIKEUS / AGENT / OZEL HERO =================
  const unvan = d => { d.unvan = d.unvan || { takili: [] }; return d.unvan; };
  H['0x01815204'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const u = unvan(durum); if (satir('AchievementTitle', id) && !u.takili.includes(id)) u.takili = [id]; K(kaydet, durum); const w = new Y().u32(0).u16(u.takili.length); for (const t of u.takili) w.u32(t); return w.done(); };
  H['0x01815205'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const u = unvan(durum); u.takili = u.takili.filter(t => t !== id); K(kaydet, durum); return { id: 0x01185204, payload: new Y().u32(0).u16(u.takili.length).raw(Buffer.concat(u.takili.map(t => new Y().u32(t).done()))).done() }; };
  const kizOyun = d => { d.kizOyun = d.kizOyun || { ilerleme: {} }; const g = gunluk(d); g.kizOyun = g.kizOyun || { oyun: 3 }; return { k: d.kizOyun, g: g.kizOyun }; };
  H['0x01816601'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const girl = o.u32(), score = o.u32(); const { k, g } = kizOyun(durum); const b = satir('Beauty', girl); if (!b) return new Y().u32(4).done(); const p = k.ilerleme[String(girl)] || 0; let l = []; if (score >= 60 && p < 5) { k.ilerleme[String(girl)] = p + 1; if (p + 1 >= 5) { g.oyun = Math.max(0, g.oyun - 1); l = ver(durum, [{ type: 0, code: 0, amount: 20000 }, { type: 1, code: 14100130, amount: 5 }]); } } else if (score < 60) { g.oyun = Math.max(0, g.oyun - 1); k.ilerleme[String(girl)] = 0; } K(kaydet, durum); const w = new Y().u32(0).u32(girl); w.odul(l); return w.done(); };
  H['0x01816602'] = ({ payload, durum, kaydet }) => { const girl = new O(payload).u32(); const { k, g } = kizOyun(durum); if (!satir('Beauty', girl) || g.oyun < 1) return new Y().u32(1).done(); const kalan = 5 - (k.ilerleme[String(girl)] || 0); if (kalan > 0 && !altin(kalan * cv(60320013, 2))) return new Y().u32(16).done(); k.ilerleme[String(girl)] = 0; g.oyun--; const l = ver(durum, [{ type: 0, code: 0, amount: 20000 }, { type: 1, code: 14100130, amount: 5 }]); K(kaydet, durum); const w = new Y().u32(0).u32(girl); w.odul(l); return w.done(); };
  H['0x01816900'] = ({ durum }) => { const rows = tablo('GrowRoadDayTask').liste.filter(r => Number(r.unlockCondition) !== 0); const w = new Y().u16(rows.length); for (const r of rows) w.u32(r._id).u32(olay.gunlukOku(durum, 'gunlukKayit:' + r._id) || 0); return w.done(); };
  H['0x01817501'] = ({ payload, durum, kaydet }) => { const op = new O(payload).u32(); durum.likeUs = durum.likeUs || {}; let l = []; if (op === 2 && !durum.likeUs.alindi) { durum.likeUs.alindi = 1; l = ver(durum, [{ type: 0, code: 1, amount: 50 }]); } K(kaydet, durum); const w = new Y().u32(0).u32(op); w.odul(l); return w.done(); };
  H['0x01818302'] = ({ payload, durum, kaydet }) => { const tip = new O(payload).i32(); const g = gunluk(durum); g.agent = g.agent || {}; if (g.agent[String(tip)]) return new Y().u32(0).u32(tip).i32(-1).done(); g.agent[String(tip)] = 1; ver(durum, [{ type: 0, code: 1, amount: tip === 2 ? 200 : 20 }, { type: 1, code: 14100003, amount: 2 }]); K(kaydet, durum); return new Y().u32(0).u32(tip).i32(-1).done(); };
  H['0x01818701'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const heroId = o.u32(), cur = o.u32(); durum.ozelHero = durum.ozelHero || {}; const lv = Math.max(Number(durum.ozelHero[String(heroId)]) || 0, cur) + 1; if (!esyaHarcaS(durum, 14100589, 5)) return new Y().u32(18).done(); durum.ozelHero[String(heroId)] = lv; K(kaydet, durum); return new Y().u32(0).u32(heroId).u32(lv).done(); };
  const esyaHarcaS = (d, code, adet) => { if (!envanter.dus(d, code, adet)) return false; try { const g = envanter.guncellemePaketi(d, code, 0); if (g) ekSonra(g.id, g.payload, 'SOSYAL-esya'); } catch (e) { } return true; };
  H['0x01810100'] = () => false;   // CreateChar: oyun-sunucu login dalinda islenir (karakter.js)
  // ================= HERO EDINME (Special combat / enlist) =================
  H['0x01812100'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); const h = satir('BaseHero', id); if (!h || Number(h.isMain) === 1 || !satir('RoleModel', id)) return new Y().u32(4).u32(id).done(); const yeni = heroEkle(id); const lv = anaLv(); try { seviye.heroKayit(durum, id, lv); } catch (e) { } K(kaydet, durum); if (yeni) { ekOnce(0x01180c02, new Y().u32(0).u32(id).u32(lv).u32(0).u32(0).done(), 'HERO-edin'); console.log(`[hero] edinildi ${id} (${String(h.name).trim()})`); } return new Y().u32(0).u32(id).done(); };
  return H;
}
module.exports = { kur, heroEkle, heroSil };
