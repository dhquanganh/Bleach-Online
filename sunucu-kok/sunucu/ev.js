'use strict';
// EV / BUYUME MODULLERI: Home, GirlFriend, HeroChange, VainTravel, Related, Rebirth, CollectSoul, NijiaStar,
// HellButterfly, QianKunARoll, ProfessionRefine, Smelt, GeneralStar(olu). Kaynak: scratchpad/spec-ev.md.
const { Y, O, tablo, satir, json, cv, simdi, gunluk, rnd, sec } = require('./paket');
const envanter = require('./envanter');

function kur(y) {
  const { ekSonra, ekOnce, odulVer, paraHarca, paraEksik, awardOf, seviye, olay } = y;
  const H = {};
  const harca = list => { const pk = paraHarca(list); if (pk) ekSonra(0x01180105, pk, 'EV-para'); return !!pk; };
  const altin = n => n > 0 ? harca([{ type: 0, code: 1, amount: n }]) : true;
  const gumus = n => n > 0 ? harca([{ type: 0, code: 0, amount: n }]) : true;
  const K = (kaydet, d) => { try { kaydet(d); } catch (e) {} };
  const esyaHarca = (d, code, adet) => { if (!envanter.dus(d, code, adet)) return false; try { const g = envanter.guncellemePaketi(d, code, 0); if (g) ekSonra(g.id, g.payload, 'EV-esya'); } catch (e) {} return true; };
  const maliyetOde = (d, rawCosts) => {
    if (!Array.isArray(rawCosts) || !rawCosts.length) return 4;
    const items = new Map(), currencies = new Map();
    for (const cost of rawCosts) {
      const type = Number(cost && cost.type), amount = Math.floor(Number(cost && cost.amount) || 0);
      if (amount <= 0) return 4;
      if (type === 0) {
        const code = Number(cost.code) >>> 0;
        const key = `${type}:${code}`;
        currencies.set(key, { type, code, amount: (currencies.get(key) || {}).amount + amount });
      } else {
        const code = envanter.odulTemplate(type, Number(cost.code));
        if (!code) return 4;
        items.set(code, (items.get(code) || 0) + amount);
      }
    }
    const itemCosts = Array.from(items, ([code, amount]) => ({ code, amount }));
    if (itemCosts.some(cost => envanter.mevcut(d, cost.code) < cost.amount)) return 18;
    const currencyCosts = Array.from(currencies.values());
    if (currencyCosts.length && typeof paraEksik === 'function') {
      const error = paraEksik(currencyCosts);
      if (error) return error;
    }
    if (currencyCosts.length) {
      const packet = paraHarca(currencyCosts);
      if (!packet) return 1;
      ekSonra(0x01180105, packet, 'EV-para');
    }
    for (const cost of itemCosts) {
      if (!envanter.dus(d, cost.code, cost.amount)) return 18;
      const update = envanter.guncellemePaketi(d, cost.code, 0);
      if (update) ekSonra(update.id, update.payload, 'EV-esya');
    }
    return 0;
  };
  const veri = () => { try { return JSON.parse(require('fs').readFileSync(require('path').join(__dirname, 'veri.json'), 'utf8')); } catch (e) { return {}; } };
  const anaLv = () => { try { return seviye.anaDurum(veri()).lv; } catch (e) { return 1; } };
  const vip = () => Number(veri().vipLevel) || 0;
  const gecerli = list => (list || []).filter(a => a && (([1, 17, 21, 23].includes(Number(a.type)) && satir('Article', a.code)) || envanter.odulTemplate(Number(a.type), Number(a.code))));
  const ver = (d, list) => { const l = gecerli(list); if (l.length) odulVer(d, l); return l; };
  const hero = id => satir('BaseHero', id);
  const heroStatPush = (durum, heroId) => {
    const equipment = require('./ekipman');
    const v = veri();
    const level = (Number(heroId) >>> 0) === (seviye.anaId() >>> 0)
      ? seviye.anaDurum(v).lv
      : seviye.heroSeviye(durum, heroId, v);
    const packet = equipment.statPaketi(durum, heroId, level);
    if (packet) ekSonra(0x01180104, packet, 'DEGISIM-stat');
  };

  // ================= HOME =================
  const ev = d => { d.ev = d.ev || { level: 1, kediTs: 0, kiz: 1, sekil: 1, tofuTs: 0, konusTs: 0 }; const g = gunluk(d); g.ev = g.ev || { kedi: 0, tofu: 0, konus: 0 }; return { k: d.ev, g: g.ev }; };
  H['0x01814200'] = ({ durum, kaydet }) => { const { k } = ev(durum); const nx = satir('HomeLevel', k.level + 1); if (!nx) return new Y().u32(1).done(); const cond = json(nx.addLevelText, []).filter(c => c && c.code); for (const c of cond) if (Number(c.type) === 1 && envanter.mevcut(durum, Number(c.code)) < (Number(c.amount) || 1)) return new Y().u32(18).done(); for (const c of cond) if (Number(c.type) === 1) esyaHarca(durum, Number(c.code), Number(c.amount) || 1); k.level++; olay.say(durum, 'homeUpgrade', 1); K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01814202'] = ({ payload }) => { const tab = new O(payload).u8(); return new Y().u32(0).u8(tab > 1 ? 0 : tab).u16(0).done(); };
  H['0x01814228'] = ({ durum, kaydet }) => { const { k, g } = ev(durum); const hl = satir('HomeLevel', k.level); const lim = hl ? Number(hl.gambleCount) || 11 : 11; if (g.kedi >= lim || k.kediTs > simdi()) return new Y().u32(1).done(); const hf = satir('HomeFortune', Math.max(1, Math.min(160, anaLv()))); ver(durum, [{ type: 0, code: 0, amount: hf ? Number(hf.baseMoney) || 4300 : 4300 }]); g.kedi++; k.kediTs = simdi() + 600; K(kaydet, durum); return new Y().u32(0).u32(k.kediTs).done(); };
  H['0x01814229'] = ({ durum, kaydet }) => { const { k } = ev(durum); const kalan = Math.max(0, k.kediTs - simdi()); if (kalan && !altin(Math.ceil(kalan / 60))) return new Y().u32(16).done(); k.kediTs = simdi(); K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x0181423d'] = ({ durum, kaydet }) => { const { k } = ev(durum); const cur = satir('HomeGirlFriend', k.kiz); const nx = satir('HomeGirlFriend', k.kiz + 1); if (!cur || !nx) return new Y().u32(1).done(); if ((Number(cur.mackTofuNum) || 1) > k.level) return new Y().u32(1).done(); const it = json(cur.description, []); for (const c of it) if (Number(c.type) === 1 && envanter.mevcut(durum, Number(c.code)) < (Number(c.amount) || 1)) return new Y().u32(18).done(); for (const c of it) if (Number(c.type) === 1) esyaHarca(durum, Number(c.code), Number(c.amount) || 1); k.kiz++; K(kaydet, durum); return new Y().u32(0).u32(k.kiz).u32(k.sekil).done(); };
  H['0x0181423e'] = ({ durum, kaydet }) => { const { k, g } = ev(durum); const gf = satir('HomeGirlFriend', k.kiz); const lim = gf ? Number(gf.mackTofuCDTime) || 3 : 3; if (g.tofu >= lim) return new Y().u32(1).done(); const cdDk = gf ? Number(gf.spriteCommunicateNum) || 20 : 20; if (k.tofuTs + cdDk * 60 > simdi()) return new Y().u32(1).done(); const aw = gf ? json(gf.spriteCommunicateCDTime, { type: 3, code: 0, amount: 6 }) : { type: 3, code: 0, amount: 6 }; const od = Array.isArray(aw) ? aw[0] : aw; const l = ver(durum, [od]); const o = l[0] || { type: 1, code: 14100074, amount: 5 }; g.tofu++; k.tofuTs = simdi(); K(kaydet, durum); return new Y().u32(0).u32(g.tofu).u32(k.tofuTs).u16(1).i16(o.type).u32(o.code).u32(o.amount).done(); };
  H['0x0181423f'] = ({ durum, kaydet }) => { const { k } = ev(durum); if (!altin(5)) return new Y().u32(16).done(); k.tofuTs = 0; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01814240'] = ({ payload, durum, kaydet }) => { const tip = new O(payload).u8(); const { k, g } = ev(durum); const gf = satir('HomeGirlFriend', k.kiz); const lim = gf ? Number(gf.f9) || 3 : 3; if (g.konus >= lim) return new Y().u32(1).done(); const cdDk = gf ? Number(gf.f12) || 1 : 1; if (k.konusTs + cdDk * 60 > simdi()) return new Y().u32(1).done(); if (tip === 2) { if (!altin(5)) return new Y().u32(16).done(); } else if (!gumus(1000)) return new Y().u32(13).done(); const mood = 1 + rnd(5); const hm = satir('HomeGirlMood', mood); const aw = hm ? json(tip === 2 ? hm.f2 : hm.f1, null) : null; const od = (Array.isArray(aw) ? aw[0] : aw) || { type: 1, code: 14100074, amount: 79 }; const l = ver(durum, [od]); const o = l[0] || { type: 1, code: 14100074, amount: 79 }; g.konus++; k.konusTs = simdi(); K(kaydet, durum); return new Y().u32(0).u32(g.konus).u32(k.konusTs).u32(mood).u16(1).i16(1).u32(satir('Article', o.code) ? o.code : 14100074).u32(o.amount).done(); };
  H['0x01814241'] = ({ durum, kaydet }) => { const { k } = ev(durum); if (!altin(2)) return new Y().u32(16).done(); k.konusTs = 0; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01814244'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const { k } = ev(durum); if (id < 1 || id > 10 || id > k.kiz) return new Y().u32(1).done(); k.sekil = id; K(kaydet, durum); return new Y().u32(0).u32(id).done(); };
  // ================= HERO CHANGE =================
  const deg = d => { d.degisim = d.degisim || { chip: 0, pill: 0, gpill: 0, chips: {}, city: {}, hero: {}, adv: {} }; const g = gunluk(d); g.degisim = g.degisim || { fight: 0, buy: 0 }; return { k: d.degisim, g: g.degisim }; };
  const infor = d => { const { k, g } = deg(d); const w = new Y().u32(k.chip).u32(k.pill).u32(k.gpill).u32(g.fight).u32(g.buy); const ch = Object.entries(k.chips); w.u16(ch.length); for (const [id, n] of ch) w.u32(Number(id)).u32(n); const ct = Object.entries(k.city).filter(([id]) => tablo('HeroChangeAttr').liste.some(h => Number(h.f9) === Number(id))); w.u16(ct.length); for (const [id, c] of ct) w.i32(Number(id)).i32(c.reset || 0).i32(c.monster || 0).i32(c.relive || 0).i32(c.die || 0).i32(c.best || 0); return w.done(); };
  H['0x01816f00'] = ({ durum }) => infor(durum);
  H['0x01816f01'] = ({ payload, durum, kaydet }) => {
    if (!Buffer.isBuffer(payload) || payload.length < 4) return new Y().i32(4).done();
    const id = new O(payload).u32();
    const { k } = deg(durum);
    const ha = satir('HeroChangeAttr', id);
    if (!ha) return new Y().i32(4).done();
    const stages = json(ha.chipID, []);
    const current = Math.max(0, Math.floor(Number(k.hero[String(id)]) || 0));
    if (current >= stages.length) return new Y().i32(1).done();
    const change = satir('PartnerChange', Number(stages[current]));
    if (!change) return new Y().i32(4).done();
    const requiredLevel = Math.max(0, Number(change.heroLevel) || 0);
    if (seviye.heroSeviye(durum, id, veri()) < requiredLevel) return new Y().i32(1).done();

    const error = maliyetOde(durum, json(change.rewards, null));
    if (error) return new Y().i32(error).done();
    k.hero[String(id)] = current + 1;
    K(kaydet, durum);
    heroStatPush(durum, id);
    return new Y().i32(0).u32(id).u32(current + 1).done();
  };
  H['0x01816f02'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tip = o.i32(), n = Math.max(1, o.i32() || 1); const { k } = deg(durum); if (tip === 0) { if (!gumus((cv(60380001, [80000]))[0] * n)) return new Y().i32(13).done(); } else if (!altin((cv(60380002, [15]))[0] * n)) return new Y().i32(16).done(); k.pill += n; K(kaydet, durum); ekSonra(0x01186f04, new Y().u32(1).u32(k.pill).done(), 'DEGISIM-hap'); return new Y().i32(0).u16(1).u16(1).u32(14100352).u32(n).done(); };
  H['0x01816f03'] = ({ payload, durum, kaydet }) => { const n = Math.max(1, new O(payload).i32() || 1); const { k } = deg(durum); const oran = cv(60380003, 10); if (k.pill < n * oran) return new Y().i32(18).done(); k.pill -= n * oran; k.gpill += n; K(kaydet, durum); ekSonra(0x01186f04, new Y().u32(1).u32(k.pill).done(), 'DEGISIM-hap'); ekSonra(0x01186f04, new Y().u32(2).u32(k.gpill).done(), 'DEGISIM-hap'); return new Y().i32(0).done(); };
  H['0x01816f06'] = ({ durum, kaydet }) => { const { g } = deg(durum); const l = cv(60380005, [20]); if (g.buy >= l.length) return new Y().i32(1).done(); if (!altin(l[g.buy])) return new Y().i32(16).done(); g.buy++; K(kaydet, durum); return new Y().i32(0).done(); };
  const sehir = (k, heroId) => { const ha = satir('HeroChangeAttr', heroId); const cid = ha ? Number(ha.f9) : 0; if (!cid) return null; k.city[String(cid)] = k.city[String(cid)] || { reset: 0, monster: 0, relive: 0, die: 0, best: 0 }; return k.city[String(cid)]; };
  H['0x01816f07'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); const { k } = deg(durum); const c = sehir(k, id); if (!c) return new Y().i32(4).done(); const ha = satir('HeroChangeAttr', id); const l = json(ha.f5, [24]); if (!altin(l[Math.min(c.reset, l.length - 1)] || 24)) return new Y().i32(16).done(); c.reset++; c.monster = 0; K(kaydet, durum); return new Y().i32(0).i32(id).done(); };
  H['0x01816f08'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); const { k } = deg(durum); const c = sehir(k, id); if (!c) return new Y().i32(4).done(); const ha = satir('HeroChangeAttr', id); const l = json(ha.cityID, [50]); if (!altin(l[Math.min(c.relive, l.length - 1)] || 50)) return new Y().i32(16).done(); c.relive++; K(kaydet, durum); return new Y().i32(0).i32(id).done(); };
  H['0x01816f0a'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); const { k, g } = deg(durum); const c = sehir(k, id); if (!c) return new Y().i32(4).done(); g.fight++; c.monster = c.best; const ha = satir('HeroChangeAttr', id); const chip = Number(ha.chipValue) || 0; const l = chip && satir('Article', chip) ? ver(durum, [{ type: 1, code: chip, amount: 5 }]) : []; if (chip) { k.chips[String(chip)] = (k.chips[String(chip)] || 0) + 5; ekSonra(0x01186f06, new Y().u32(chip).u32(envanter.mevcut(durum, chip)).done(), 'HEROCHANGE-fragment-count'); } K(kaydet, durum); const w = new Y().i32(0).i32(id).i32(g.fight); w.odul(l); return w.done(); };
  H['0x01816f0b'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const from = o.u32(), to = o.u32(); const { k } = deg(durum); if (hero(to) && satir('HeroChangeAttr', to)) { k.hero[String(to)] = Math.max(Number(k.hero[String(to)]) || 0, Number(k.hero[String(from)]) || 0); k.hero[String(from)] = 0; K(kaydet, durum); } return { id: 0x01186f00, payload: infor(durum) }; };
  H['0x01816f0c'] = ({ payload, durum, kaydet }) => {
    if (!Buffer.isBuffer(payload) || payload.length < 9) return new Y().i32(4).done();
    const o = new O(payload), id = o.u32(), lv = o.u32();
    o.u8(); // locked-roll flag
    if (lv < 1 || lv > 7 || !satir('BaseHero', id)) return new Y().i32(1).done();
    const { k } = deg(durum);
    const rows = tablo('AdvanceChange').liste;
    if (!rows.length) return new Y().i32(4).done();
    const error = maliyetOde(durum, json(cv(60380011, []), null));
    if (error) return new Y().i32(error).done();
    const row = sec(rows);
    const range = json(row.value, [2, 12]);
    const min = Math.max(1, Number(range[0]) || 1);
    const max = Math.max(min, Number(range[1]) || 12);
    const value = min + rnd(max - min + 1);
    k.adv[id + ':' + lv] = [row._id, value];
    K(kaydet, durum);
    heroStatPush(durum, id);
    return new Y().i32(0).u32(id).u32(lv).u32(row._id).u32(value).done();
  };
  H['0x01816f0d'] = ({ payload, durum, kaydet }) => {
    if (!Buffer.isBuffer(payload) || payload.length < 8) return new Y().i32(4).done();
    const o = new O(payload), id = o.u32(), lv = o.u32(), { k } = deg(durum);
    delete k.adv[id + ':' + lv];
    K(kaydet, durum);
    heroStatPush(durum, id);
    return new Y().i32(0).u32(id).u32(lv).done();
  };
  // Hueco Mundo Attack has its own point-index protocol and persistent daily progression.
  Object.assign(H, require('./hueco-mundo').kur(y));
  // ================= RELATED (bag) =================
  const bag = d => { d.bag = d.bag || { star: {}, status: 0, skill: {}, yardim: {} }; const g = gunluk(d); g.bag = g.bag || { free: 0, gold: 0 }; return { k: d.bag, g: g.bag }; };
  H['0x01818000'] = ({ durum }) => { const { k, g } = bag(durum); const w = new Y().u32(0).u32(Math.max(0, cv(60900001, 1) - g.free)).u32(g.gold).u32(k.status); const st = Object.entries(k.star); w.u16(st.length); for (const [id, s] of st) w.u32(Number(id)).u32(s); return w.done(); };
  H['0x01818002'] = ({ payload, durum, kaydet }) => { const i = new O(payload).u32(); const { k } = bag(durum); if (i > 4 || (k.status & (1 << i))) return new Y().u32(1).done(); const top = Object.values(k.star).reduce((s, x) => s + x, 0); if (top < (cv(60900004, [7, 12, 17, 22, 27]))[i]) return new Y().u32(1).done(); k.status |= 1 << i; const aw = awardOf((cv(60900005, [178]))[i] || 178, i); const l = ver(durum, aw); K(kaydet, durum); const w = new Y().u32(0).u32(k.status); w.odul(l); return w.done(); };
  H['0x01818003'] = ({ payload, durum, kaydet }) => { const tip = new O(payload).u32(); const { g } = bag(durum); if (tip === 0) { if (g.free >= cv(60900001, 1)) return new Y().u32(1).done(); g.free++; } else { if (!altin(20)) return new Y().u32(16).done(); g.gold++; } const l = ver(durum, [{ type: 1, code: 14100589, amount: tip ? 10 : 5 }]); K(kaydet, durum); ekSonra(0x01188009, new Y().u32(Math.max(0, cv(60900001, 1) - g.free)).u32(g.gold).done(), 'BAG-sayac'); const w = new Y().u32(0).u32(tip).u32(tip ? g.gold : Math.max(0, cv(60900001, 1) - g.free)); w.odul(l); return w.done(); };
  H['0x01818006'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const heroId = o.u32(), old = o.u32(); const cur = satir('RelatedPartnerType', old); if (!cur) return new Y().u32(4).done(); const nx = tablo('RelatedPartnerType').liste.find(r => Number(r.type) === Number(cur.type) && Number(r.level) === Number(cur.level) + 1); if (!nx) return new Y().u32(1).done(); const n = Number(cur.materialCount) || 0; if (n && !esyaHarca(durum, cv(60900010, 14100589), n)) return new Y().u32(18).done(); const { k } = bag(durum); k.skill[heroId + ':' + cur.type] = nx._id; K(kaydet, durum); return new Y().u32(0).u32(heroId).u32(old).u32(nx._id).done(); };
  H['0x01818007'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const heroId = o.u32(), pos = o.u32(); const { k } = bag(durum); for (const [p, h] of Object.entries(k.yardim)) if (h === heroId) delete k.yardim[p]; k.yardim[String(pos)] = heroId; K(kaydet, durum); return new Y().u32(0).u32(heroId).u32(pos).done(); };
  H['0x01818008'] = ({ payload, durum, kaydet }) => { const pos = new O(payload).u32(); const { k } = bag(durum); delete k.yardim[String(pos)]; K(kaydet, durum); return new Y().u32(0).u32(pos).done(); };
  // Reincarnation validates and persists its own level, EXP, costs and effects.
  Object.assign(H, require('./reincarnation').kur(y));
  // ================= COLLECT SOUL =================
  const rt = d => { d.ruhTopla = d.ruhTopla || { vip: 0, enerji: 0, free: 0, t: [0, 0, 0], alinan: {} }; return d.ruhTopla; };
  H['0x01818800'] = ({ durum }) => { const r = rt(durum); const w = new Y().u32(0).u32(0).u32(cv(61600007, 100)).u32(r.vip).u32(r.enerji).u32(r.free).u32(r.t[0]).u32(r.t[1]).u32(r.t[2]).u16(0); const al = Object.entries(r.alinan); w.u16(al.length); for (const [id, t] of al) w.u32(Number(id)).u32(t); return w.done(); };
  H['0x01818801'] = ({ payload, durum, kaydet }) => { const flag = new O(payload).u32(); const r = rt(durum); const k = flag === 1 ? 10 : 1; const timerIdx = flag === 0 ? 0 : flag === 2 ? 1 : flag === 3 ? 2 : -1; if (timerIdx >= 0 && r.t[timerIdx] > simdi()) { if (!altin(10)) return new Y().u32(16).done(); } else if (flag === 4 && !altin(50)) return new Y().u32(16).done(); else if (flag === 1 && !gumus(100000)) return new Y().u32(13).done(); const havuz = tablo('SoulCollectionRnd').liste; const cek = []; for (let i = 0; i < k && havuz.length; i++) { const row = sec(havuz); cek.push(row._id); const rw = json(row.reward, null); if (rw) ver(durum, [rw]); } r.enerji += 100 * k; if (timerIdx >= 0) r.t[timerIdx] = simdi() + 3600; K(kaydet, durum); const w = new Y().u32(0).u32(flag).u32(0).u32(cv(61600007, 100)).u32(timerIdx >= 0 ? r.t[timerIdx] : 0).u32(r.enerji).u32(r.free).u16(cek.length); for (const c of cek) w.u32(c); return w.done(); };
  H['0x01818802'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const s = satir('SoulCollectionShop', id); const r = rt(durum); if (!s) return new Y().u32(4).done(); if (Number(s.frequency) === 1 && r.alinan[String(id)]) return new Y().u32(1).done(); if (r.enerji < cv(61600002, 10000)) return new Y().u32(1).done(); r.enerji -= cv(61600002, 10000); const rw = json(s.exchangeReward, null); if (rw) ver(durum, [rw]); if (Number(s.frequency) === 1) r.alinan[String(id)] = simdi(); K(kaydet, durum); return new Y().u32(0).u32(id).u32(simdi()).u32(r.enerji).done(); };
  H['0x01818803'] = ({ durum, kaydet }) => { const r = rt(durum); const l = cv(61600006, [200]); if (r.vip >= l.length) return new Y().u32(1).done(); if (!altin(l[r.vip])) return new Y().u32(16).done(); r.vip++; K(kaydet, durum); return new Y().u32(0).u32(r.vip).u32(0).u32(cv(61600007, 100)).done(); };
  // ================= NIJIA STAR =================
  const yz = d => { d.yildiz = d.yildiz || {}; const z = d.yildiz; if (!Array.isArray(z.ruh) || z.ruh.length < 8) z.ruh = [0, 0, 0, 0, 0, 0, 0, 0]; z.hero = z.hero || {}; return z; };
  const yildizPush = (d, ids) => { const z = yz(d); const w = new Y().u16(ids.length); for (const id of ids) { const s = z.hero[String(id)] || [0, 0, 0, 0, 0, 0, 0]; w.u32(id); for (let i = 0; i < 7; i++) w.i32(s[i] || 0); } ekOnce(0x01183904, w.done(), 'YILDIZ-guncel'); };
  H['0x01813901'] = ({ durum }) => { const z = yz(durum); const w = new Y(); for (let i = 0; i < 8; i++) w.u32(z.ruh[i] || 0); return w.done(); };
  Object.assign(H,require('./hollow-soul-map').kur(y,{statPush:heroStatPush}));
  // ================= HELL BUTTERFLY =================
  const kb = d => { d.kelebek = d.kelebek || { lv: 1, exp: 0, coll: 0, eatTs: 0 }; const g = gunluk(d); g.kelebek = g.kelebek || { eat: 0, comm: 0 }; return { k: d.kelebek, g: g.kelebek }; };
  H['0x01814301'] = ({ payload, durum }) => { const o = new O(payload); const id0 = o.u32(), id1 = o.u32(); const { k, g } = kb(durum); const w = new Y().u32(0).u32(id0).u32(id1).u8(Math.min(255, k.lv)).u32(k.exp).u8(Math.min(255, k.coll)); w.u8(g.eat).u32(k.eatTs).u8(g.comm).u16(0); return w.done(); };
  H['0x01814302'] = ({ payload, durum, kaydet }) => { const tip = new O(payload).u8(); const { g } = kb(durum); const n = tip ? cv(60180002, 10) : 1; const max = vip() > 0 ? 20 : cv(60180001, 10); if (g.comm + n > max) return new Y().u32(1).done(); let gold = 0; for (let i = 0; i < n; i++) { const bm = satir('BuyMoney', g.comm + i + 1); gold += bm ? Number(bm.costGold) || 2 : 2; } if (!altin(gold)) return new Y().u32(16).done(); const bm = satir('BuyMoney', Math.max(1, Math.min(159, anaLv()))); const gumusK = (bm ? Number(bm.money) || 26000 : 26000) * n; ver(durum, [{ type: 0, code: 0, amount: gumusK }]); g.comm += n; K(kaydet, durum); return new Y().u32(0).u8(tip).u32(gumusK).u32(n).done(); };
  H['0x01814303'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tip = o.u8(), id0 = o.u32(), id1 = o.u32(); const { k, g } = kb(durum); if (g.eat >= cv(60180006, 2) || k.eatTs > simdi()) return new Y().u32(1).done(); g.eat++; k.eatTs = simdi() + cv(60180008, 540); const gain = 1; k.exp += gain; const lim = Math.max(1, anaLv()); const bt = satir('Butterfly', k.lv); if (bt && k.lv < lim && k.exp >= Number(bt.upgradeExp)) { k.exp = 0; k.lv++; } ver(durum, [{ type: 0, code: 0, amount: 3000 }]); K(kaydet, durum); const w = new Y().u32(0).u32(id0).u32(id1).u8(tip).u32(3000); if (tip === 0) w.u32(k.exp).u8(Math.min(255, k.lv)).u32(gain); else w.u32(1); return w.done(); };
  H['0x01814304'] = ({ durum, kaydet }) => { const { k } = kb(durum); if (k.lv <= k.coll) return new Y().u32(1).done(); const bf = tablo('ButterflyFeeding').liste.find(r => Number(r.vipLevel) === Math.min(10, vip()) && Number(r.powderLevel) === k.coll + 1) || tablo('ButterflyFeeding').liste.find(r => Number(r.vipLevel) === 0 && Number(r.powderLevel) === k.coll + 1); const rw = bf ? json(bf.f2, []) : [{ type: 0, code: 0, amount: 3000 }]; ver(durum, vip() > 0 ? rw : rw.slice(0, 1)); k.coll++; K(kaydet, durum); return new Y().u32(0).done(); };
  // ================= QIAN KUN (zar) =================
  const zar = d => { d.zar = d.zar || { score: 0, box: [0, 0, 0] }; const g = gunluk(d); g.zar = g.zar || { times: 0 }; return { k: d.zar, g: g.zar }; };
  H['0x01814400'] = ({ durum }) => { const { k, g } = zar(durum); return new Y().u32(0).u32(k.score).u8(g.times).u16(3).u32(k.box[0]).u32(k.box[1]).u32(k.box[2]).u16(0).done(); };
  H['0x01814401'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const cid = o.u32(), tip = o.u8(); const c = satir('HomeGambleCost', cid); if (!c) return new Y().u32(4).done(); const { k, g } = zar(durum); const { k: e } = ev(durum); const hl = satir('HomeLevel', e.level); if (g.times >= (hl ? Number(hl.maxMyGirlfriendInteractive) || 11 : 11)) return new Y().u32(1).done(); if (tip === 1) { if (!altin(Number(c.costGold) || 5)) return new Y().u32(16).done(); k.score += Number(c.costGold) || 5; } else if (!gumus(Number(c.costSilver) || 50000)) return new Y().u32(13).done(); const win = Math.random() < 0.5; if (win) ver(durum, json(tip === 1 ? c.winGold : c.winSilver, [])); g.times++; K(kaydet, durum); return new Y().u32(0).u8(win ? 1 : 0).done(); };
  H['0x01814402'] = ({ payload, durum, kaydet }) => { const idx = new O(payload).u8(); const { k } = zar(durum); const hb = satir('HomeGambleBox', idx); if (!hb || idx < 1 || idx > 3 || k.box[idx - 1]) return new Y().u32(1).done(); if (k.score < Number(hb.needScore)) return new Y().u32(1).done(); const rows = tablo('HomeGamble').liste.filter(r => Number(r.boxID) === idx); const row = rows.length ? sec(rows) : null; const l = ver(durum, row ? json(row.awardBox, []) : [{ type: 0, code: 0, amount: 100000 }]); k.box[idx - 1] = 1; K(kaydet, durum); const w = new Y().u32(0).u8(idx); w.odul(l); return w.done(); };
  // Soul King Palace Refinery validates costs and updates combat stats.
  Object.assign(H, require('./refinery').kur(y));
  // ================= SMELT (sifirlama) =================
  H['0x01818900'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tip = o.u8(), target = o.u32(); const iade = []; if (tip === 0) { const { k } = deg(durum); if (!satir('HeroChangeAttr', target)) return new Y().u32(4).done(); k.hero[String(target)] = 0; } else if (tip === 2) { const k = durum.yenidenDogus = durum.yenidenDogus || { hero: {} }; k.hero = k.hero || {}; const h = k.hero[String(target)]; if (h && h.n) iade.push({ type: 1, code: 14100698, amount: 500 * h.n }); k.hero[String(target)] = { n: 0, pp: 0, ae: 0 }; } const l = ver(durum, iade); K(kaydet, durum); const w = new Y().u32(0).u8(tip).u32(target); w.odul(l); return w.done(); };
  Object.assign(H, require('./hero-stars').kur(y));
  // ================= GENERAL STAR (client hic gondermez) =================
  H['0x01810b00'] = () => new Y().u32(0).done(); H['0x01810b01'] = () => new Y().u32(0).done(); H['0x01810b02'] = () => new Y().u32(0).done();
  return H;
}
module.exports = { kur };
