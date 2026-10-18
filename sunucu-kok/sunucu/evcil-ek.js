'use strict';
// EVCIL (Mod Soul) MODULLERI: Enter_Pet, Pet (etkilesim/hediye), PetStudy (yap/tak/miras/rutbe/yika/depo),
// PetTrain (egitim), FightPet (klan bossu sahnesi), Companion (bu surumde olu). Kaynak: scratchpad/spec-evcil.md.
// Durum: durum.pet = { fish, fishCd, buyFish, buyStore, feed, mask, trainCd, extend, pool, train{0..2}, vice[], seq, heroPet{} }
const { Y, O, tablo, satir, json, cv, simdi, gunluk, sec } = require('./paket');
const envanter = require('./envanter');

const FIGHT_PET_BOSSES = {
  1: [12910030, 'Evil Spirit Shinigami'],
  2: [12920030, 'Evil Spirit Quincy'],
  3: [12930030, 'Evil Spirit Arrancar'],
};
function fightPetState(durum) {
  const daily = gunluk(durum);
  daily.klanBoss = daily.klanBoss || { hp: {}, moral: 0, dirilme: 0 };
  daily.klanBoss.hp = daily.klanBoss.hp || {};
  daily.klanBoss.pendingGoldRewards = daily.klanBoss.pendingGoldRewards || {};
  if (!daily.klanBoss.damageByClan) {
    const legacyDamage = Math.max(0, Number(daily.klanBoss.hasar) || 0);
    const legacyClan = Math.max(1, Math.min(3, Number(daily.klanBoss.klan) || 1));
    daily.klanBoss.damageByClan = {};
    if (legacyDamage > 0) {
      const key = fightPetPlayerKey(durum);
      daily.klanBoss.damageByClan[legacyClan] = {
        [key]: {
          highId: Number(durum.roleIdHi) >>> 0,
          lowId: Number(durum.roleIdLo) >>> 0,
          name: durum.nick || 'Shinigami',
          damage: legacyDamage,
        },
      };
    }
  }
  return daily.klanBoss;
}
function fightPetPlayerKey(durum) {
  return `${Number(durum.roleIdHi) >>> 0}:${Number(durum.roleIdLo) >>> 0}`;
}
function fightPetPendingGold(durum) {
  const state = fightPetState(durum);
  return Math.max(0, Number(state.pendingGoldRewards[fightPetPlayerKey(durum)]) || 0);
}
function fightPetClaimGold(durum, amount) {
  const state = fightPetState(durum);
  const key = fightPetPlayerKey(durum);
  const pending = fightPetPendingGold(durum);
  const claimed = Math.min(pending, Math.max(0, Math.floor(Number(amount) || 0)));
  if (claimed === pending) delete state.pendingGoldRewards[key];
  else state.pendingGoldRewards[key] = pending - claimed;
  return claimed;
}
function fightPetReset(state, clan, maxHp) {
  state.hp[clan] = maxHp;
  state.hasar = 0;
  if (state.damageByClan) state.damageByClan[clan] = {};
  state.moral = 0;
  state.dirilme = 0;
}
function fightPetInfo(durum) {
  const state = fightPetState(durum);
  const clan = Math.max(1, Math.min(3, Number(state.klan) || 1));
  const [enemyId, name] = FIGHT_PET_BOSSES[clan];
  const enemy = satir('Enemy', enemyId);
  if (!enemy) throw new Error(`FightPet enemy template ${enemyId} is missing`);
  const maxHp = Math.max(1, Number(enemy.hp) || 10000000);
  state.damageByClan[clan] = state.damageByClan[clan] || {};
  state.hasar = Object.values(state.damageByClan[clan]).reduce((total, player) => total + (Number(player.damage) || 0), 0);
  if (state.hp[clan] === undefined) state.hp[clan] = maxHp;
  state.hp[clan] = Math.max(0, Math.min(maxHp, Number(state.hp[clan]) || 0));
  if (state.hp[clan] <= 0) fightPetReset(state, clan, maxHp);
  return { state, clan, enemyId, name, hp: state.hp[clan], maxHp, damageByPlayer: state.damageByClan[clan] };
}
function fightPetApplyDamage(durum, damage) {
  const info = fightPetInfo(durum);
  const requested = Number.isFinite(Number(damage)) ? Math.max(0, Math.floor(Number(damage))) : 0;
  const applied = Math.min(info.hp, requested);
  info.hp -= applied;
  info.state.hp[info.clan] = info.hp;
  const highId = Number(durum.roleIdHi) >>> 0;
  const lowId = Number(durum.roleIdLo) >>> 0;
  const key = fightPetPlayerKey(durum);
  const contributor = info.damageByPlayer[key] || { highId, lowId, name: durum.nick || 'Shinigami', damage: 0 };
  contributor.damage = Math.max(0, Number(contributor.damage) || 0) + applied;
  contributor.name = durum.nick || contributor.name;
  info.damageByPlayer[key] = contributor;
  const ranking = Object.values(info.damageByPlayer).sort((a, b) => b.damage - a.damage);
  info.state.hasar = ranking.reduce((total, player) => total + player.damage, 0);
  const defeated = info.hp <= 0;
  const reportedHp = Math.max(0, info.hp);
  const winner = ranking[0] || null;
  const goldReward = defeated && winner ? Math.floor(winner.damage / 100) : 0;
  const winnerIsCurrentPlayer = !!winner && winner.highId === highId && winner.lowId === lowId;
  if (goldReward > 0) {
    info.state.pendingGoldRewards[`${winner.highId}:${winner.lowId}`] =
      (Number(info.state.pendingGoldRewards[`${winner.highId}:${winner.lowId}`]) || 0) + goldReward;
  }
  const rank = new Y().u32(0).u32(info.state.hasar).u16(ranking.length);
  for (const player of ranking) rank.utf(player.name).u32(0).u32(player.damage);
  if (defeated) fightPetReset(info.state, info.clan, info.maxHp);
  return {
    ...info,
    hp: reportedHp,
    applied,
    defeated,
    winner,
    winnerIsCurrentPlayer,
    goldReward,
    monsterPacket: new Y().u32(info.enemyId).u32(reportedHp).utf(info.name).done(),
    rankPacket: rank.done(),
  };
}

const petRow = (tpl, lvl) => satir('PetLevelUp', tpl * 1000 + lvl);
const needExp = (tpl, lvl) => { const r = petRow(tpl, lvl); return r ? Number(r.petResourceID) || 0 : 0; };   // JSON etiketi kaymis: petResourceID = NeedExp
const maxMi = (tpl, lvl) => { const r = petRow(tpl, lvl); return !r || Number(r.isMaxLevel) === 1 || !petRow(tpl, lvl + 1); };
function seviyele(p) { let t = 0; while (!maxMi(p.tpl, p.lvl) && p.exp >= needExp(p.tpl, p.lvl + 1) && t++ < 200) { p.exp -= needExp(p.tpl, p.lvl + 1); p.lvl++; } if (maxMi(p.tpl, p.lvl)) p.exp = Math.min(p.exp, Math.max(0, needExp(p.tpl, p.lvl) - 1)); }
function toplamExp(tpl, lvl) { const r = petRow(tpl, lvl); const t = r ? json(r.sourcePet, 0) : 0; return typeof t === 'number' ? t : 0; }

function depo(d) {
  d.pet = d.pet || {}; const p = d.pet;
  p.fishCd = Number(p.fishCd) || 0; p.buyStore = Number(p.buyStore) || 0; p.feed = Number(p.feed) || 0; p.mask = Number(p.mask) || 0; p.extend = Number(p.extend) || 0; p.pool = Number(p.pool) || 0;
  p.train = p.train || {}; p.vice = Array.isArray(p.vice) ? p.vice : []; p.seq = Number(p.seq) || 1; p.heroPet = p.heroPet || {};
  const g = gunluk(d); g.pet = g.pet || { fish: 0, buyFish: 0, trainCd: 0 };
  return { p, g: g.pet };
}
function anaPetler(d) {
  let out = [];
  try { const ev = require('./evcil'); const dep = ev.depo(d); for (const [id, x] of Object.entries(dep.petler || dep || {})) { const pid = Number(id); if (pid >= 1101 && pid <= 1115 && x && typeof x === 'object') { const lvl = Math.max(1, Number(x.level || x.lvl) || 1); if (petRow(pid, lvl)) out.push({ id: pid, lvl, exp: Number(x.exp) || 0 }); } } } catch (e) {}
  if (!out.some(x => x.id === 1101)) out.unshift({ id: 1101, lvl: 1, exp: 0 });
  return out;
}
function bul(p, hi, lo) { return p.vice.find(v => v.hi === hi && v.lo === lo) || null; }
function slotBul(p, hi, lo) { for (const [s, t] of Object.entries(p.train)) if (t && t.hi === hi && t.lo === lo) return { s, t }; return null; }

function kur(y) {
  const { ekSonra, odulVer, paraHarca, paraIcinOdul, awardOf, seviye } = y;
  const H = {};
  const harca = list => { const pk = paraHarca(list); if (pk) ekSonra(0x01180105, pk, 'PET-para'); return !!pk; };
  const altin = n => n > 0 ? harca([{ type: 0, code: 1, amount: n }]) : true;
  const gumus = n => n > 0 ? harca([{ type: 0, code: 0, amount: n }]) : true;
  const K = (kaydet, d) => { try { kaydet(d); } catch (e) {} };
  const esyaHarca = (d, code, adet) => { if (!envanter.dus(d, code, adet)) return false; try { const g = envanter.guncellemePaketi(d, code, 0); if (g) ekSonra(g.id, g.payload, 'PET-esya'); } catch (e) {} return true; };
  const anaLv = () => { try { return seviye.anaDurum(JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'), 'utf8'))).lv; } catch (e) { return 1; } };
  const kapasite = d => { const lv = anaLv(); const l = cv(60400007, [{ 30: 5 }, { 50: 10 }, { 70: 20 }, { 160: 20 }]); let k = 0; for (const o of l) for (const [lim, n] of Object.entries(o)) if (lv >= Number(lim)) k = Math.max(k, Number(n)); return k + depo(d).p.buyStore; };
  const vip = () => { try { return Number(JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'), 'utf8')).vipLevel) || 0; } catch (e) { return 0; } };

  // ---- Enter_Pet ----
  H['0x01810215'] = ({ durum, kaydet }) => {
    const { p, g } = depo(durum);
    const w = new Y().u32(0).u32(g.fish).u32(p.fishCd).u32(g.buyFish).u32(p.buyStore).u32(0).u32(p.feed).u32(p.mask).u32(g.trainCd).u32(p.extend).u32(p.pool);
    const l = Object.entries(p.train).filter(([s, t]) => t && Number(s) <= 2 && satir('VicePetTrain', t.tip) && bul(p, t.hi, t.lo));
    w.u16(l.length); for (const [s, t] of l) w.u32(Number(s)).u32(t.hi).u32(t.lo).u32(t.tip).u32(Math.min(3, t.idx)).u32(t.end);
    K(kaydet, durum); return w.done();
  };
  // ---- Pet ----
  H['0x01817100'] = ({ durum }) => { const { p } = depo(durum); const ana = anaPetler(durum); const w = new Y().u32(0).u16(ana.length); for (const a of ana) w.u32(a.id).u32(a.lvl).u32(a.exp); const v = p.vice.filter(x => petRow(x.tpl, x.lvl)); w.u16(v.length); for (const x of v) w.u32(x.hi).u32(x.lo).u32(x.tpl).u32(x.lvl).u32(x.exp); return w.done(); };
  H['0x01817101'] = ({ durum, kaydet }) => { const { p, g } = depo(durum); if (p.fishCd > simdi() || g.fish >= cv(60400014, 5) + g.buyFish) return new Y().u32(1).done(); g.fish++; p.fishCd = simdi() + 600; odulVer(durum, [{ type: 23, code: 14100426, amount: 10 }]); y.olay.say(durum, 'petInteract', 1); K(kaydet, durum); return new Y().u32(0).u32(p.fishCd).u16(1).u16(23).u32(14100426).u32(10).done(); };
  H['0x01817102'] = ({ durum, kaydet }) => { const { p } = depo(durum); const kalan = Math.max(0, p.fishCd - simdi()); if (kalan && !altin(cv(60400002, 2) * Math.ceil(kalan / 60))) return new Y().u32(16).done(); p.fishCd = 0; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01817103'] = ({ durum, kaydet }) => { const { g } = depo(durum); const l = cv(60400003, [20]); if (g.buyFish >= Math.min(9, vip() > 0 ? 9 : cv(60400021, 3))) return new Y().u32(1).done(); if (!altin(l[Math.min(g.buyFish, l.length - 1)])) return new Y().u32(16).done(); g.buyFish++; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01817104'] = ({ payload, durum, kaydet }) => {
    const id = new O(payload).u32(); const bag = satir('PetFamilyBag', id); if (!bag) return new Y().u32(4).done(); const { p } = depo(durum);
    const bit = id - 1300001; if (bit < 0 || (p.mask & (1 << bit))) return new Y().u32(1).done();
    if (anaLv() < Number(bag.useerLevel) || p.vice.length < Number(bag.vicePetNum)) return new Y().u32(1).done();
    const aw = satir('Award', Number(bag.award)); const liste = aw ? (json(aw.fixed, {}).fixed || []) : awardOf(Number(bag.award), 0);
    p.mask |= (1 << bit); odulVer(durum, liste); K(kaydet, durum); const w = new Y().u32(0).u32(id); w.odul(liste); return w.done();
  };
  // ---- PetStudy ----
  H['0x01817400'] = ({ payload, durum, kaydet }) => {
    const tpl = new O(payload).u32(); const m = satir('VicePetMake', tpl); if (!m || !petRow(tpl, 1)) return new Y().u32(4).done(); const { p } = depo(durum);
    if (p.vice.length >= kapasite(durum)) return new Y().u32(1).done();
    const cond = json(m.needSilver, []); if (cond.length >= 2 && envanter.mevcut(durum, Number(cond[0])) < Number(cond[1])) return new Y().u32(18).done();
    if (!gumus(Number(m.pathWay) || 0)) return new Y().u32(13).done();
    if (cond.length >= 2) esyaHarca(durum, Number(cond[0]), Number(cond[1]));
    const v = { hi: 1, lo: p.seq++, tpl, lvl: 1, exp: 0 }; p.vice.push(v); K(kaydet, durum); console.log(`[pet] yeni mod soul ${tpl}`);
    return new Y().u32(0).u32(v.hi).u32(v.lo).u32(tpl).done();
  };
  H['0x01817401'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const hi = o.u32(), lo = o.u32(), hero = o.u32(); const { p } = depo(durum); if (!bul(p, hi, lo)) return new Y().u32(4).done(); for (const [h, v] of Object.entries(p.heroPet)) if (v && v.hi === hi && v.lo === lo) delete p.heroPet[h]; p.heroPet[String(hero)] = { hi, lo }; K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(hero).done(); };
  H['0x01817402'] = ({ payload, durum, kaydet }) => { const hero = new O(payload).u32(); const { p } = depo(durum); delete p.heroPet[String(hero)]; K(kaydet, durum); return new Y().u32(0).u32(hero).done(); };
  H['0x01817403'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const i = p.vice.findIndex(v => v.hi === hi && v.lo === lo); if (i < 0) return new Y().u32(4).done(); p.vice.splice(i, 1); for (const [h, v] of Object.entries(p.heroPet)) if (v && v.hi === hi && v.lo === lo) delete p.heroPet[h]; K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).done(); };
  H['0x01817404'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); if (!v) return new Y().u32(4).done();
    let kul = 0; let t = 0; while (p.pool - kul > 0 && !maxMi(v.tpl, v.lvl) && t++ < 500) { const n = needExp(v.tpl, v.lvl + 1) - v.exp; const al = Math.min(n, p.pool - kul); v.exp += al; kul += al; seviyele(v); }
    p.pool -= kul; K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(v.lvl).u32(v.exp).u32(v.tpl).u32(p.pool).done();
  };
  H['0x01817405'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); if (!v) return new Y().u32(4).done();
    const r = satir('VicePetRankUp', v.tpl); if (!r || !petRow(Number(r.nextPetId), v.lvl)) return new Y().u32(1).done();
    if (v.lvl < Number(r.needSilver)) return new Y().u32(1).done();   // needSilver etiketi = PetLevel
    const cond = json(r.petLevel, []); if (cond.length >= 2 && envanter.mevcut(durum, Number(cond[0])) < Number(cond[1])) return new Y().u32(18).done();
    if (!gumus(Number(r.f3) || 0)) return new Y().u32(13).done(); if (cond.length >= 2) esyaHarca(durum, Number(cond[0]), Number(cond[1]));
    v.tpl = Number(r.nextPetId); K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(v.tpl).done();
  };
  H['0x01817406'] = ({ durum, kaydet }) => { const { p } = depo(durum); const l = cv(60400008, [50, 100, 200, 500]); if (p.buyStore >= 4) return new Y().u32(1).done(); if (!altin(l[p.buyStore] || 500)) return new Y().u32(16).done(); p.buyStore++; K(kaydet, durum); return new Y().u32(0).u32(p.buyStore).done(); };
  H['0x01817407'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); if (!v) return new Y().u32(4).done();
    const row = petRow(v.tpl, v.lvl); const base = row && Number(row.f11) ? Number(row.f11) : v.tpl; const geri = Math.floor((toplamExp(v.tpl, v.lvl) + v.exp) * cv(60400025, 0.6));
    const tavan = p.extend > 0 ? (cv(60400023, [40000]))[Math.min(p.extend - 1, 10)] : cv(60400022, 20000); p.pool = Math.min(tavan, p.pool + geri);
    const iade = []; let t = base; let guard = 0; while (t !== v.tpl && guard++ < 10) { const r = satir('VicePetRankUp', t); if (!r) break; const cond = json(r.petLevel, []); if (cond.length >= 2) iade.push({ type: 1, code: Number(cond[0]), amount: Number(cond[1]) }); t = Number(r.nextPetId); }
    v.tpl = base; v.lvl = 1; v.exp = 0; if (iade.length) odulVer(durum, iade); K(kaydet, durum);
    const w = new Y().u32(0).u32(hi).u32(lo).u32(base).u32(p.pool).u32(geri); w.odul(iade.filter(i => satir('Article', i.code))); return w.done();
  };
  H['0x01817408'] = ({ durum, kaydet }) => { const { p } = depo(durum); const l = cv(60400024, [5]); if (p.extend >= 11) return new Y().u32(1).done(); if (!altin(l[Math.min(p.extend, l.length - 1)])) return new Y().u32(16).done(); p.extend++; K(kaydet, durum); return new Y().u32(0).u32(p.extend).done(); };
  // ---- PetTrain ----
  H['0x01817300'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const hi = o.u32(), lo = o.u32(), tip = o.u32(), idx = Math.min(3, o.u32()), slot = Math.min(2, o.u32()); const { p } = depo(durum);
    const v = bul(p, hi, lo); const tr = satir('VicePetTrain', tip); if (!v || !tr || slotBul(p, hi, lo) || p.train[String(slot)]) return new Y().u32(1).done();
    if (!gumus(Number(tr.silver) || 0)) return new Y().u32(13).done(); const g = (json(tr.vipLimit, [0]))[idx] || 0; if (g && !altin(g)) return new Y().u32(16).done();
    const t = { hi, lo, tip, idx, end: simdi() + (Number(tr.needTime) || 43200) }; p.train[String(slot)] = t; K(kaydet, durum);
    return new Y().u32(0).u32(slot).u32(hi).u32(lo).u32(tip).u32(idx).u32(t.end).done();
  };
  H['0x01817301'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); const s = slotBul(p, hi, lo); if (!v || !s) return new Y().u32(4).done(); const tr = satir('VicePetTrain', s.t.tip); const total = tr ? Number(tr.needTime) || 43200 : 43200; const gecen = Math.max(0, total - Math.max(0, s.t.end - simdi())); const kaz = tr ? Math.floor(Number(tr.getExp) * ((json(tr.f4, [100]))[s.t.idx] || 100) / 100 * gecen / total) : 0; v.exp += kaz; seviyele(v); delete p.train[s.s]; K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(v.exp).u32(v.lvl).done(); };
  H['0x01817302'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p, g } = depo(durum); const s = slotBul(p, hi, lo); if (!s) return new Y().u32(4).done(); const kalan = Math.max(0, s.t.end - simdi()); if (kalan && !altin(cv(60400012, 10) * Math.ceil(kalan / 3600))) return new Y().u32(16).done(); s.t.end = simdi(); g.trainCd++; K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).done(); };
  H['0x01817303'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); const s = slotBul(p, hi, lo); if (!v || !s) return new Y().u32(4).done(); if (s.t.end > simdi()) return new Y().u32(1).done(); const tr = satir('VicePetTrain', s.t.tip); const kaz = tr ? Math.floor(Number(tr.getExp) * ((json(tr.f4, [100]))[s.t.idx] || 100) / 100) : 0; v.exp += kaz; seviyele(v); delete p.train[s.s]; y.olay.say(durum, 'petTrain', 1); K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(v.lvl).u32(v.exp).u32(kaz).done(); };
  H['0x01817304'] = () => new Y().u32(1).done();
  H['0x01817305'] = ({ payload, durum, kaydet }) => { const o = new O(payload); const tip = o.u32(), hi = o.u32(), lo = o.u32(); const { p } = depo(durum); const v = bul(p, hi, lo); if (!v) return new Y().u32(4).done(); const iste = tip ? cv(60400026, 50) : 1; const kart = Math.min(iste, envanter.mevcut(durum, 14120003)); if (!kart) return new Y().u32(18).done(); esyaHarca(durum, 14120003, kart); v.exp += kart * cv(60400027, 50544); seviyele(v); K(kaydet, durum); return new Y().u32(0).u32(hi).u32(lo).u32(v.lvl).u32(v.exp).u32(kart).done(); };
  // ---- FightPet (klan bossu) ----
  const boss = d => fightPetState(d);
  H['0x01810209'] = ({ payload, durum, kaydet }) => {
    const clan = Math.max(1, Math.min(3, new O(payload).u8() || 1)); const b = boss(durum); b.klan = clan; const info = fightPetInfo(durum);
    const pendingGold = fightPetPendingGold(durum);
    if (pendingGold > 0) {
      const update = paraIcinOdul([{ type: 0, code: 1, amount: pendingGold }]);
      if (update) {
        fightPetClaimGold(durum, pendingGold);
        ekSonra(0x01180105, update, 'FIGHTPET-GoldReward-pending');
        ekSonra(0x0118260A, new Y().u32(pendingGold).done(), 'FIGHTPET-GoldReward-notice');
      } else {
        console.log(`[fightpet] ${pendingGold} Gold reward for ${durum.nick || 'player'} remains pending`);
      }
    }
    K(kaydet, durum);
    ekSonra(0x01182601, new Y().u32(info.enemyId).u32(info.hp).utf(info.name).done(), 'BOSS-bilgi'); ekSonra(0x01182603, new Y().u32(1).done(), 'BOSS-oyuncu');
    const rank = new Y().u32(0).u32(Number(b.hasar) >>> 0).u16(b.hasar ? 1 : 0);
    if (b.hasar) rank.utf(durum.nick || 'Shinigami').u32(0).u32(Number(b.hasar) >>> 0);
    ekSonra(0x01182602, rank.done(), 'BOSS-sira');
    return new Y().u32(0).i16(b.moral).u32(0).u32(1800).u32(b.dirilme).done();
  };
  H['0x01812600'] = () => false;
  H['0x01812605'] = ({ durum, kaydet }) => { const b = boss(durum); const l = cv(60210009, [5]); if (b.moral >= 8) return new Y().u32(1).done(); if (!altin(l[Math.min(b.moral, l.length - 1)])) return new Y().u32(16).done(); b.moral++; K(kaydet, durum); return new Y().u32(0).i8(b.moral).done(); };
  H['0x01812606'] = ({ durum, kaydet }) => { const b = boss(durum); const l = cv(60210018, [1]); if (!altin(l[Math.min(b.dirilme, l.length - 1)] || 1)) return new Y().u32(16).done(); b.dirilme++; K(kaydet, durum); return new Y().u32(0).done(); };
  // ---- Companion: bu client'ta olu (tablolar pakette yok) ----
  for (const op of ['0x01817b00', '0x01817b01', '0x01817b02', '0x01817b03', '0x01817b04', '0x01817b05', '0x01817b06']) H[op] = () => new Y().u32(1).done();
  H['0x01817b07'] = () => false;
  return H;
}
module.exports = { kur, depo, anaPetler, fightPetInfo, fightPetApplyDamage, fightPetPendingGold, fightPetClaimGold };
