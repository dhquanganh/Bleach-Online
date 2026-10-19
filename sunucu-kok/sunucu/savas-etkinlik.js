'use strict';
// ETKINLIK SAVAS MODULLERI: Enter_* sahneleri, Arena odul/CD, KingChallenge, GongFuFight, SkyTower,
// TreasureMap, TeamBattle (salon+oda), ExpDuplicate, VoidSoulWorld, SevenKing, CityDefend/TraitorAttack
// dirilme, Hurdle/WorldMap sandik, KillHeros sifirlama. Kaynak: scratchpad/spec-arena.md.
const { Y, O, tablo, satir, json, cv, simdi, gun, gunluk, rnd, sec } = require('./paket');
const statlar = require('./statlar');

const VOID_CHESTS = [14100713, 14100714, 14100715];
const VOID_BOSS_ENEMY_ID = 0x00BB9F5F;
const SKY_TOWERS = tablo('City').liste
  .filter(city => city._id >= 15900001 && city._id <= 15900013)
  .sort((a, b) => a._id - b._id);
const SKY_TOWER_BY_ID = new Map(SKY_TOWERS.map(city => [city._id, city]));
function skyTowerProgress(state) {
  if (state.progress && typeof state.progress === 'object') return state.progress;
  const progress = {};
  const legacy = Math.max(0, Number(state.kat) || 0);
  if (legacy && SKY_TOWERS.length) progress[String(SKY_TOWERS[0]._id)] = legacy;
  state.progress = progress;
  return progress;
}
function voidBossArmy(date = new Date()) {
  const base = Number(cv(62000009, 0)) || 0;
  const openDates = json(cv(62000008, []), []).map(Number).filter(day => day >= 1 && day <= 31);
  const day = openDates.find(value => value >= date.getDate()) || openDates[0];
  const army = day ? satir('EnemyArmy', base + day) : null;
  if (!army) throw new Error(`Void Region boss army not found for day ${day}`);
  return army;
}
function voidBossEnemy() {
  const enemy = satir('Enemy', VOID_BOSS_ENEMY_ID);
  if (!enemy) throw new Error(`Void Region boss enemy ${VOID_BOSS_ENEMY_ID} not found`);
  return enemy;
}
function voidBossHp(date = new Date()) {
  const army = voidBossArmy(date);
  let total = 0;
  for (const field of ['front', 'middle', 'back']) {
    const list = json(army[field], {});
    for (const enemyId of list[field] || []) {
      const enemy = satir('Enemy', enemyId);
      if (!enemy) throw new Error(`Void Region boss enemy ${enemyId} not found`);
      total += Number(enemy.hp) || 0;
    }
  }
  if (!(total > 0)) throw new Error(`Void Region boss army ${army._id} has no HP`);
  return total;
}
function voidInstanceKey(date = new Date()) {
  const days = [4, 8, 12, 16, 20, 24, 28];
  let day = days.filter(value => value <= date.getDate()).pop();
  let year = date.getFullYear(), month = date.getMonth();
  if (!day) { month--; if (month < 0) { month = 11; year--; } day = 28; }
  return `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}
function bosluk(d) {
  const hpMax = voidBossHp();
  let b = d.bosDunya;
  if (!b || b.instance !== voidInstanceKey()) {
    b = d.bosDunya = { instance: voidInstanceKey(), submit: 0, dead: 0, hp: hpMax, hpMax, award: 0, hurt: 0, participated: 0, form: [], players: [] };
  }
  b.submit = Number(b.submit) || 0;
  b.dead = Number(b.dead) || 0;
  b.hurt = Math.max(0, Number(b.hurt) || 0);
  if (Number(b.hpMax) !== hpMax) {
    b.hpMax = hpMax;
    b.hp = Math.max(0, hpMax - b.hurt);
  } else {
    const hp = Number(b.hp);
    b.hp = Number.isFinite(hp) ? Math.max(0, Math.min(hpMax, hp)) : hpMax;
  }
  b.award = Number(b.award) ? 1 : 0;
  b.participated = Number(b.participated) ? 1 : 0;
  if (!Array.isArray(b.form)) b.form = [];
  if (!Array.isArray(b.players)) b.players = [];
  return b;
}
function voidForm(d, mainId) {
  const positions = [1,2,3,6,7,8,11,12,13];
  const selected = [], seen = new Set();
  for (const [hero, raw] of Object.entries(d.kadro || {}).sort((a,b)=>Number(a[1])-Number(b[1]))) {
    const heroId=Number(hero)>>>0, battlePos=Number(raw);
    if(!heroId || !positions.includes(battlePos) || seen.has(battlePos) || selected.length>=5)continue;
    selected.push({heroId,battlePos});seen.add(battlePos);
  }
  const main=Number(mainId)>>>0;
  if(main&&!selected.some(hero=>hero.heroId===main)) {
    const battlePos=[6,...positions].find(pos=>!seen.has(pos));
    if(battlePos)selected.push({heroId:main,battlePos});
  }
  // Void's preview has six consecutive slots; combat uses the original lane positions.
  return selected.map((hero,index)=>({...hero,pos:index+1}));
}
function voidDamageFromStatistics(packet) {
  if (!Buffer.isBuffer(packet) || packet.length < 2) return 0;
  const n = packet.readUInt16BE(0);
  if (n > 32 || 2 + n * 12 + 2 > packet.length) return 0;
  let damage = 0;
  for (let i = 0, p = 2; i < n; i++, p += 12) damage += packet.readUInt32BE(p + 4);
  return Math.max(0, damage);
}
function voidFightResult(d, damage) {
  const b = bosluk(d);
  const inflicted = Math.min(b.hp, Math.max(0, Math.floor(Number(damage) || 0)));
  b.hp -= inflicted;
  b.hurt += inflicted;
  b.participated = 1;
  return inflicted;
}
function voidFinishFight(d, highId, lowId, damage, now = simdi()) {
  const b = bosluk(d);
  const index = b.players.findIndex(player =>
    (Number(player.highId) >>> 0) === (Number(highId) >>> 0) &&
    (Number(player.lowId) >>> 0) === (Number(lowId) >>> 0)
  );
  if (index < 0) return null;
  b.players.splice(index, 1);
  b.dead = now;
  const inflicted = voidFightResult(d, damage);
  return new Y().u32(highId).u32(lowId).i64(inflicted).done();
}
function voidRecoverPlayers(d, now = simdi()) {
  const b = bosluk(d);
  const staleAfter = Math.ceil(voidFightDurationMs() / 1000) + 5;
  const before = b.players.length;
  b.players = b.players.filter(player => {
    const age = now - (Number(player.warTime) || 0);
    return age >= 0 && age <= staleAfter && Number(player.team) < 4;
  });
  return before - b.players.length;
}
function voidCancelFight(d, highId, lowId) {
  const b = bosluk(d);
  const before = b.players.length;
  b.players = b.players.filter(player =>
    (Number(player.highId) >>> 0) !== (Number(highId) >>> 0) ||
    (Number(player.lowId) >>> 0) !== (Number(lowId) >>> 0)
  );
  return b.players.length !== before;
}
function voidFightDurationMs() {
  const seconds = Math.max(1, Math.min(300, Math.floor(Number(cv(62000007, 10)) || 10)));
  return seconds * 2000;
}
function voidTravelDurationMs() {
  const seconds = Math.max(1, Math.min(300, Math.floor(Number(cv(62000007, 10)) || 10)));
  return seconds * 1000;
}
function voidFightEnter(d, payload, mainId, now = simdi()) {
  const b = bosluk(d);
  voidRecoverPlayers(d, now);
  const team = Buffer.isBuffer(payload) && payload.length === 1 ? payload[0] : 0xff;
  const heroId = Number(mainId) >>> 0;
  if (team >= 4 || !b.submit || !b.form.length || !heroId || b.hp <= 0) return new Y().u32(1).done();
  if (b.form.some(hero => !hero.battlePos)) b.form = voidForm(d, mainId);

  const highId = Number(d.roleIdHi) >>> 0;
  const lowId = Number(d.roleIdLo) >>> 0;
  if (b.players.some(player =>
    (Number(player.highId) >>> 0) === highId && (Number(player.lowId) >>> 0) === lowId
  )) return new Y().u32(1).done();

  const player = {
    highId,
    lowId,
    team,
    warTime: now,
    templateId: heroId,
    quality: 2,
    name: d.nick || 'Shinigami',
  };
  b.players = b.players.filter(existing =>
    Number(existing.highId) !== player.highId || Number(existing.lowId) !== player.lowId
  );
  b.players.push(player);
  b.participated = 1;

  return new Y()
    .u32(0)
    .u32(player.highId)
    .u32(player.lowId)
    .u8(player.team)
    .i32(player.warTime)
    .i32(player.templateId)
    .i32(player.quality)
    .utf(player.name)
    .done();
}
function voidRankPacket(d, pendingDamage = 0) {
  const b = bosluk(d);
  const displayDamage = Math.max(0, Math.min(b.hp, Math.floor(Number(pendingDamage) || 0)));
  const shownHurt = b.hurt + displayDamage;
  const rank = shownHurt > 0 ? [{
    highId: Number(d.roleIdHi) >>> 0,
    lowId: Number(d.roleIdLo) >>> 0,
    server: Number(d.server) >>> 0,
    quality: 2,
    hurt: shownHurt,
    name: d.nick || 'Shinigami',
    serverName: String(Number(d.server) || 974),
  }] : [];
  const w = new Y().i64(Math.max(0, b.hp - displayDamage)).i16(rank.length);
  for (const row of rank) {
    w.u32(row.highId).u32(row.lowId).i32(row.server).i32(row.quality).i64(row.hurt)
      .utf(row.name).utf(row.serverName).i32(0).i32(0);
  }
  return w.done();
}
function voidStatusPacket(d) {
  const b = bosluk(d);
  const reports = Array.isArray(b.reports) ? b.reports : [];
  const players = b.players.filter(player => Number(player.team) < 4);
  const form = b.form.filter(hero => Number(hero.heroId) > 0 && Number(hero.pos) > 0);
  const w = new Y().i32(b.submit).i32(b.dead).i64(b.hp).i8(b.award).i8(0).i64(b.hurt).i16(reports.length);
  for (const report of reports) w.utf(report);
  w.raw(voidRankPacket(d).subarray(8));
  w.i16(players.length);
  for (const player of players) {
    w.u32(player.highId).u32(player.lowId).u8(player.team).i32(player.warTime)
      .i32(player.templateId).i32(player.quality).utf(player.name);
  }
  w.i16(form.length);
  for (const hero of form) w.i32(hero.heroId).i32(hero.pos);
  return w.done();
}

function skyTowerFloor(towerId, layerId) {
  const tower = SKY_TOWER_BY_ID.get(Number(towerId) >>> 0);
  const layer = satir('TemplePoint', Number(layerId) >>> 0);
  if (!tower || !layer) return null;
  const start = Number(tower.start) || 0;
  const last = Number(tower.last) || 0;
  const id = Number(layerId) >>> 0;
  if (id < start || id > last) return null;
  return { tower, layer, index: id - start };
}

function skyTowerCanChallenge(towerId, layerId) {
  return !!skyTowerFloor(towerId, layerId);
}

function skyTowerApplyWin(d, towerId, layerId) {
  const floor = skyTowerFloor(towerId, layerId);
  if (!floor) return false;
  const state = d.kule = d.kule || { kat: 0, integral: 0, chest: 0 };
  const progress = skyTowerProgress(state);
  const key = String(floor.tower._id);
  progress[key] = Math.max(Number(progress[key]) || 0, floor.index + 1);
  state.lockedTowerId = floor.tower._id;
  state.kat = progress[key];
  return true;
}

const RAIDERS_DAILY = tablo('RaidersDailyConfig').liste.slice().sort((a, b) => a._id - b._id);
const RAIDERS_DAILY_BY_ID = new Map(RAIDERS_DAILY.map(stage => [stage._id, stage]));
function killHeroState(d) {
  const state = d.raidersDaily = d.raidersDaily || {};
  if (!Array.isArray(state.passed)) state.passed = [];
  if (!state.enterCount || typeof state.enterCount !== 'object') state.enterCount = {};
  if (!state.resetCount || typeof state.resetCount !== 'object') state.resetCount = {};
  const today = gun();
  if (state.day !== today) {
    state.day = today;
    state.enterCount = {};
    state.resetCount = {};
  }
  return state;
}
function killHeroEnterPacket(d) {
  const state = killHeroState(d);
  const passed = RAIDERS_DAILY.filter(stage => state.passed.includes(stage._id));
  const w = new Y().u32(0).u16(passed.length);
  for (const stage of passed) {
    const id = String(stage._id);
    w.u32(stage._id).u8(state.enterCount[id] || 1).u8(state.resetCount[id] || 0);
  }
  const records = state.records || {};
  w.u16(passed.length);
  for (const stage of passed) {
    const record = records[String(stage._id)] || {};
    w.u32(stage._id)
      .utf(record.firstId || '')
      .utf(record.firstName || d.nick || '')
      .utf(record.bestId || '')
      .utf(record.bestName || d.nick || '');
  }
  return w.done();
}
function killHeroApplyWin(d, stageId) {
  const id = Number(stageId) >>> 0;
  if (!RAIDERS_DAILY_BY_ID.has(id)) return null;
  const state = killHeroState(d);
  if (!state.records || typeof state.records !== 'object') state.records = {};
  const key = String(id);
  state.enterCount[key] = Math.min(255, (Number(state.enterCount[key]) || 0) + 1);
  if (!state.passed.includes(id)) state.passed.push(id);
  const record = state.records[key] = state.records[key] || {
    firstId: '',
    firstName: d.nick || '',
    bestId: '',
    bestName: d.nick || '',
  };
  const progress = new Y().u16(1).u32(id).u8(state.enterCount[key]).u8(state.resetCount[key] || 0).done();
  const bestFirst = [
    new Y().u32(2000).u32(id).utf(record.firstId).utf(record.firstName).done(),
    new Y().u32(2001).u32(id).utf(record.bestId).utf(record.bestName).done(),
  ];
  return { progress, bestFirst };
}

function kur(y) {
  const { ekSonra, odulVer, paraHarca, seviye, awardOf, olay } = y;
  const H = {};
  const harca = list => { const p = paraHarca(list); if (p) ekSonra(0x01180105, p, 'ETKINLIK-para'); return !!p; };
  const altin = n => n > 0 ? harca([{ type: 0, code: 1, amount: n }]) : true;
  const gumus = n => n > 0 ? harca([{ type: 0, code: 0, amount: n }]) : true;
  const K = (kaydet, d) => { try { kaydet(d); } catch (e) {} };
  const killHeroResetLimit = () => {
    const account = JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'), 'utf8'));
    const vip = satir('VipConfig', Number(account.vipLevel) || 0);
    return vip ? Math.max(0, Number(vip.dailyChaReset) || 0) : 0;
  };
  const voidPush = d => ekSonra(0x01188b00, voidStatusPacket(d), 'VOID-status');
  const anaId = () => seviye.anaId() >>> 0;
  const anaLv = () => { try { return seviye.anaDurum(JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'), 'utf8'))).lv; } catch (e) { return 1; } };
  const nick = d => d.nick || 'Shinigami';
  const gecerliOdul = list => (list || []).filter(a => a && (([1, 17, 21, 23].includes(a.type) && satir('Article', a.code)) || require('./envanter').odulTemplate(a.type, a.code)));
  const ver = (d, list) => { const l = gecerliOdul(list); if (l.length) odulVer(d, l); return l; };
  const ozet = d => { d.etkinlikSavas = d.etkinlikSavas || {}; return d.etkinlikSavas; };
  const gunlukS = d => gunluk(d);

  // ================= ENTER_* =================
  H['0x01810205'] = ({ durum, kaydet }) => { const p = require('./meyhane').enterPaketi(durum); K(kaydet, durum); return p; }; // Tavern
  H['0x0181020c'] = ({ durum }) => { const s = ozet(durum); return new Y().u32(0).u32(10).u32(1800).u32(1).u32(s.haindirilme || 0).done(); };   // TraitorAttack
  H['0x01810208'] = ({ durum }) => {                                                            // CityDefend
    const w = new Y().u32(0).u8(2).u32(30).utf('Gotei 13').u8(0).u32(Math.max(1, Math.min(159, anaLv()))).f32(1000000).u8(0).u32((ozet(durum).sehirDirilme) || 0);
    w.u16(1).u32(durum.roleIdHi || 0).u32(durum.roleIdLo || 1).i8(0).utf(nick(durum)).u8(3).u32(40100001).u8(0).u32(0).u32(anaId()).u8(2).u16(anaLv()).u32(1000).u8(0);
    w.u16(0).u16(0); return w.done();
  };
  H['0x0181020e'] = ({ durum }) => { ekSonra(0x01186005, new Y().u16(0).u16(0).u32((ozet(durum).onur) || 0).u16(0).done(), 'TAKIM-bilgi'); ekSonra(0x01186500, new Y().bool(true).done(), 'TAKIM-pvp'); return new Y().u32(0).done(); };
  H['0x0181020f'] = () => new Y().u32(0).done();
  H['0x01810210'] = () => new Y().u32(0).done();
  H['0x01810213'] = () => new Y().u32(1).done();                                               // GongFuFight: plate ac
  // ================= SKY TOWER =================
  const kule = d => {
    d.kule = d.kule || { kat: 0, integral: 0, chest: 0 };
    skyTowerProgress(d.kule);
    if (!SKY_TOWER_BY_ID.has(Number(d.kule.lockedTowerId) >>> 0)) d.kule.lockedTowerId = SKY_TOWERS.length ? SKY_TOWERS[0]._id : 0;
    const g = gunlukS(d); g.kule = g.kule || { pve: 0, pvp: 0, pveBuy: 0, pvpBuy: 0, akey: 0 };
    return { k: d.kule, g: g.kule };
  };
  H['0x01810211'] = ({ durum, kaydet }) => {
    const { k, g } = kule(durum); const w = new Y().u32(0).u8(g.pve).u8(g.pvp).u8(g.pveBuy).u8(g.pvpBuy).bool(g.akey);
    const locked = SKY_TOWER_BY_ID.get(Number(k.lockedTowerId) >>> 0) || SKY_TOWERS[0];
    const kuleler = locked ? [locked, ...SKY_TOWERS.filter(c => c._id !== locked._id)] : [];
    w.u16(kuleler.length); kuleler.forEach((c, i) => {
      const cleared = Math.max(0, Number(k.progress[String(c._id)]) || 0);
      const maxLayer = Math.max(0, Number(c.last) - Number(c.start) + 1);
      w.u32(c._id).u8(i === 0 ? Math.min(cleared, maxLayer) : maxLayer);
    });
    K(kaydet, durum);
    w.u16(0).u16(0); return { id: 0x01180212, payload: w.done() };
  };
  H['0x01810203'] = ({ durum }) => killHeroEnterPacket(durum);
  H['0x01810a02'] = ({ payload, durum, kaydet }) => { const mode = new O(payload).u8(); const { g } = kule(durum); const l = mode === 2 ? cv(60340003, [10]) : cv(60340002, [100]); const buy = mode === 2 ? g.pvpBuy : g.pveBuy; if (buy >= l.length) return new Y().u32(1).done(); if (!altin(l[buy])) return new Y().u32(16).done(); if (mode === 2) g.pvpBuy++; else g.pveBuy++; K(kaydet, durum); return new Y().u32(0).u8(mode).u8(mode === 2 ? g.pvp : g.pve).u8(mode === 2 ? g.pvpBuy : g.pveBuy).done(); };
  H['0x01810a04'] = ({ durum, kaydet }) => { const { g } = kule(durum); if (g.akey) return new Y().u32(1).done(); if (!altin(cv(60340004, 100))) return new Y().u32(16).done(); g.akey = 1; const l = ver(durum, [{ type: 0, code: 0, amount: 50000 }, { type: 1, code: 14100003, amount: 2 }]); K(kaydet, durum); const w = new Y().u32(0).u16(1).u16(1).u32(14100003).u32(2); return w.done(); };
  H['0x01810a05'] = ({ durum, kaydet }) => { ver(durum, [{ type: 0, code: 0, amount: 20000 }]); K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01810a06'] = ({ durum }) => { const { k } = kule(durum); return { id: 0x01180a07, payload: new Y().u32(0).u16(k.integral).u32(k.chest).done() }; };
  H['0x01810a07'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const { k } = kule(durum); k.chest = id; ver(durum, [{ type: 0, code: 0, amount: 30000 }, { type: 1, code: 14100003, amount: 1 }]); K(kaydet, durum); return { id: 0x01180a08, payload: new Y().u32(0).u32(id).done() }; };
  // ================= ARENA =================
  const arena = d => { const g = gunlukS(d); g.arena = g.arena || { kutu: 0, ek: 0 }; return g.arena; };
  H['0x01811901'] = ctx => require('./arena-rewards').claim(ctx,y);
  H['0x01811902'] = ({ durum, kaydet }) => { const a = arena(durum); if (!altin(10 + 5 * a.ek)) return new Y().u32(16).done(); a.ek++; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01811903'] = ({ durum, kaydet }) => { if (!altin(5)) return new Y().u32(16).done(); return new Y().u32(0).done(); };
  H['0x01811905'] = () => new Y().u32(0).done();
  // ================= KING CHALLENGE =================
  H['0x01818a04'] = ({ durum, kaydet }) => { const g = gunlukS(durum); if (g.kralKutu) return new Y().u32(1).done(); g.kralKutu = 1; ver(durum, [{ type: 1, code: 14100003, amount: 1 }, { type: 0, code: 0, amount: 10000 }]); K(kaydet, durum); return new Y().u32(0).i8(1).u16(1).u16(1).u32(14100003).u32(1).done(); };
  H['0x01818a05'] = () => new Y().u32(0).i16(0).done();
  H['0x01818a06'] = () => new Y().u32(0).i16(0).done();
  H['0x01818a07'] = ({ durum, kaydet }) => { ozet(durum).kralKadro = { zaman: simdi(), kadro: durum.kadro || {} }; K(kaydet, durum); return new Y().u32(0).done(); };
  // ================= GONGFU FIGHT =================
  const gongfu = d => { d.gongfu = d.gongfu || { grup: 0, kutu: 0, odeme: [], span: 0 }; const g = gunlukS(d); g.gongfu = g.gongfu || { basvuru: 0, ek: 0 }; return { k: d.gongfu, g: g.gongfu }; };
  H['0x01813d01'] = ({ durum, kaydet }) => { const { g } = gongfu(durum); g.basvuru = 1; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01813d03'] = ({ payload, durum, kaydet }) => { const id = new O(payload).u32(); const r = satir('GSPVP_DailyAward', id); if (!r) return new Y().u32(4).done(); const bedel = Number(r.cost) || 0; if (Number(r.costType) === 1 ? !gumus(bedel) : !altin(bedel)) return new Y().u32(13).done(); const { k } = gongfu(durum); k.odeme.push({ ad: nick(durum), q: Number(r.quality) || 1, id }); ver(durum, json(r.f4, [])); K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01813d04'] = ({ durum }) => { const { k } = gongfu(durum); return new Y().u16(1).u32(1).utf(nick(durum)).utf('S1').u32(anaLv()).u32(1000).u32(k.grup).done(); };
  H['0x01813d05'] = ({ durum }) => {
    const herolar = tablo('BaseHero').liste.filter(h => Number(h.isMain) !== 1 && satir('RoleModel', h._id)); const w = new Y();
    const giris = (i, kendi) => { const h = kendi ? null : herolar[(i * 7) % herolar.length]; w.u32(i).utf(kendi ? nick(durum) : (h ? String(h.name).trim() : 'Bot')).utf('S1').u32(kendi ? anaId() : (h ? h._id : 11100001)).u16(0).u32(kendi ? anaLv() : 30 + i).u32(kendi ? 5 : 1 + (i % 5)).u32(kendi ? 5000 : 1000 + i * 100).u32(0).u32(0).u32(kendi ? 100 : i * 10).i8(2); };
    w.u16(18); for (let i = 1; i <= 18; i++) giris(i, i === 1); w.u16(12); for (let i = 1; i <= 12; i++) giris(i, false); return w.done();
  };
  H['0x01813d06'] = () => false;
  H['0x01813d0a'] = ({ durum, kaydet }) => { if (!altin(cv(60350014, 200))) return new Y().u32(16).done(); gongfu(durum).k.span++; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01813d0b'] = ({ durum }) => { const { k } = gongfu(durum); const w = new Y().u16(k.odeme.length); for (const o of k.odeme) w.utf(o.ad).u32(o.q).u32(o.id); return w.done(); };
  H['0x01813d0c'] = ({ durum, kaydet }) => { if (!altin(cv(60350011, 10))) return new Y().u32(16).done(); gongfu(durum).g.ek++; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01813d0e'] = () => new Y().u16(0).done();
  H['0x01813d11'] = ({ payload, durum, kaydet }) => { const idx = new O(payload).u32(); const { k } = gongfu(durum); if (idx < 1 || idx > 5 || (k.kutu & (1 << (idx - 1)))) return new Y().u32(1).done(); k.kutu |= 1 << (idx - 1); const r = satir('GSPVP_Reward', k.grup * 5 + 5000 + idx); ver(durum, r ? json(r.f2, []) : [{ type: 0, code: 0, amount: 10000 }]); K(kaydet, durum); return new Y().u32(0).u32(idx).done(); };
  // ================= TREASURE MAP =================
  const hazine = d => { d.hazine = d.hazine || { quality: 101, status: 0, last: 0, blue: 0, red: 0 }; const g = gunlukS(d); g.hazine = g.hazine || { enter: 0, refresh: 0, vipBuy: 0, robbery: 0, times: 5 }; return { k: d.hazine, g: g.hazine }; };
  const hazineGiris = (d, w) => { const { k } = hazine(d); w.u32(d.roleIdHi || 0).u32(d.roleIdLo || 1).u8(0).u32(anaId()).utf(nick(d)).u32(40100001).u16(anaLv()).utf('').u8(0).u32(k.last).u8(0).u32(k.quality); };
  H['0x01810207'] = ({ durum }) => { const { k, g } = hazine(durum); if (k.status && k.last <= simdi()) { k.status = 0; } const w = new Y().u32(0).u8(g.enter).u8(g.refresh).u32(k.quality).u8(k.status).u8(g.robbery).u8(g.vipBuy).u32(k.blue).u32(k.red).u8(g.times); if (k.status) { w.u16(1); hazineGiris(durum, w); } else w.u16(0); return w.done(); };
  H['0x01811f00'] = ({ durum, kaydet }) => { const { k, g } = hazine(durum); if (g.times < 1) return new Y().u32(1).done(); const dg = satir('Digging', k.quality); k.status = 1; k.last = simdi() + (dg ? Number(dg.digtime) || 1200 : 1200); g.enter++; g.times--; K(kaydet, durum); const w = new Y().u32(0).u16(1); hazineGiris(durum, w); return w.done(); };
  H['0x01811f01'] = ({ durum, kaydet }) => { const { k, g } = hazine(durum); if (!gumus(10000 * (g.refresh + 1))) return new Y().u32(13).done(); const ids = tablo('Digging').ids; k.quality = sec(ids.length ? ids : [101]); g.refresh++; K(kaydet, durum); return new Y().u32(0).u32(k.quality).done(); };
  H['0x01811f02'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); const { k } = hazine(durum); if (!satir('Digging', id)) return new Y().u32(4).done(); const dg = satir('Digging', id); if (!altin(Number(dg.openCost) || 0)) return new Y().u32(16).done(); k.quality = id; K(kaydet, durum); return new Y().u32(0).u32(id).done(); };
  H['0x01811f03'] = ({ durum, kaydet }) => { const { k, g } = hazine(durum); if (!k.status) return new Y().u32(1).done(); const kalan = Math.max(0, k.last - simdi()); if (kalan > 0 && !altin(Math.ceil(kalan / 60))) return new Y().u32(16).done(); const dg = satir('Digging', k.quality); const para = dg ? json(dg.money, []) : []; ver(durum, para.length ? para : [{ type: 0, code: 0, amount: 50000 }]); k.blue += 1; ekSonra(0x01181fa0, new Y().u32(8).u32(k.blue).done(), 'HAZINE-yildiz'); k.status = 0; k.quality = 101; g.refresh = 0; olay.say(durum, 'treasureMap', 1); K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01811f05'] = ({ durum, kaydet }) => { const { g } = hazine(durum); if (!altin(20 + 10 * g.vipBuy)) return new Y().u32(16).done(); g.vipBuy++; g.times++; K(kaydet, durum); return { id: 0x01181f09, payload: new Y().u32(0).done() }; };
  // ================= TEAM BATTLE =================
  const oda = d => { d.takimOda = d.takimOda || { id: 1, pw: '', model: 16100101, mode: 1 }; return d.takimOda; };
  const POS = [1, 6, 7, 8, 11, 12, 13];
  const odaPush = d => {
    const o = oda(d); const w = new Y().u32(o.id).utf(o.pw).u32(o.model).u8(0).u8(0).u16(1);
    w.u8(0).u32(d.roleIdHi || 0).u32(d.roleIdLo || 1).u32(anaId()).utf(nick(d)).u16(anaLv()).u32(5000).bool(true).bool(false).bool(false).u32(0);
    const kadro = d.kadro || {}; const herolar = []; for (const [id, p] of Object.entries(kadro)) if (POS.includes(Number(p)) && satir('BaseHero', Number(id)) && satir('RoleModel', Number(id))) herolar.push([Number(id), Number(p)]);
    if (!herolar.some(h => h[0] === anaId())) herolar.unshift([anaId(), herolar.some(h => h[1] === 1) ? 6 : 1]);
    w.u16(herolar.length); for (const h of herolar) w.u32(h[0]).u8(h[1]);
    ekSonra(0x01180211, w.done(), 'TAKIM-oda');
  };
  const modelGecerli = (mode, id) => mode === 2 ? !!satir('LeagueMapPvp', id) : (!!satir('LeagueMapPve', id) && !!satir('LeaguePointPath', id));
  H['0x01816001'] = ({ payload, durum, kaydet }) => { const r = new O(payload); const mode = r.u8(), model = r.u32(), pw = r.utf(); const o = oda(durum); if (!modelGecerli(mode, model)) return { id: 0x01186003, payload: new Y().u32(1).done() }; o.mode = mode; o.model = model; o.pw = pw; o.id++; K(kaydet, durum); odaPush(durum); return { id: 0x01186003, payload: new Y().u32(0).done() }; };
  H['0x01816002'] = ({ payload, durum }) => { const r = new O(payload); const mode = r.u8(); r.u8(); const id = r.u32(); const o = oda(durum); if (mode) o.mode = mode; if (!modelGecerli(o.mode, o.model)) o.model = o.mode === 2 ? tablo('LeagueMapPvp').ids[0] : tablo('LeagueMapPve').ids[0]; odaPush(durum); return { id: 0x01186004, payload: new Y().u32(0).done() }; };
  H['0x01816003'] = () => ({ id: 0x01186006, payload: Buffer.alloc(0) });
  H['0x01816100'] = ({ payload }) => { const r = new O(payload); const op = r.u8(), a = r.u8(), b = r.u8(); return new Y().u32(0).u8(op).u8(a).u8(b).done(); };
  H['0x01816101'] = ({ payload, durum, kaydet }) => { const m = new O(payload).u32(); const o = oda(durum); if (!modelGecerli(1, m)) return { id: 0x01186105, payload: new Y().u32(1).u16(0).u32(m).done() }; o.model = m; K(kaydet, durum); return { id: 0x01186105, payload: new Y().u32(0).u16(0).u32(m).done() }; };
  H['0x01816102'] = ({ payload, durum, kaydet }) => { const pw = new O(payload).utf(); oda(durum).pw = pw; K(kaydet, durum); return { id: 0x01186106, payload: new Y().u32(0).utf(pw).done() }; };
  H['0x01816103'] = () => ({ id: 0x01186107, payload: new Y().u32(0).done() });
  H['0x01816104'] = () => false;
  H['0x01816105'] = ({ payload }) => { const t = new O(payload).u8(); return { id: 0x01186109, payload: new Y().u32(0).u8(t === 2 ? 0 : 1).done() }; };
  H['0x01816106'] = () => ({ id: 0x0118610a, payload: new Y().u32(0).done() });
  H['0x01816107'] = () => ({ id: 0x0118610c, payload: new Y().u32(0).u16(0).done() });
  H['0x01816108'] = ({ payload, durum, kaydet }) => { const m = new O(payload).u32(); if (modelGecerli(1, m)) { oda(durum).model = m; K(kaydet, durum); } return { id: 0x0118610d, payload: new Y().u32(0).u32(m).done() }; };
  H['0x01816109'] = () => ({ id: 0x0118610e, payload: new Y().u32(0).u32(3).done() });
  H['0x0181610a'] = () => ({ id: 0x0118610f, payload: new Y().u32(0).done() });
  H['0x0181610b'] = () => ({ id: 0x01186111, payload: new Y().u32(0).u32(3).done() });
  // ================= EXP DUPLICATE =================
  const expd = d => { const g = gunlukS(d); g.expd = g.expd || { kul: 0, yenile: {} }; return g.expd; };
  H['0x01818400'] = ({ durum }) => { const e = expd(durum); const rows = tablo('ExpDuplicate').liste.slice(0, 6); const ordu = tablo('EnemyArmy').ids; const w = new Y().i32(e.kul).i16(rows.length); rows.forEach((r, i) => w.i32(ordu[i] || ordu[0] || 0)); return w.done(); };
  H['0x01818401'] = ({ payload, durum }) => { const id = new O(payload).i32(); if (!satir('ExpDuplicate', id)) return new Y().i32(4).done(); const e = expd(durum); return new Y().i32(0).i32(id).i32(e.yenile[String(id)] || 0).i16(0).done(); };
  H['0x01818402'] = ({ payload, durum, kaydet }) => { const id = new O(payload).i32(); if (!satir('ExpDuplicate', id)) return new Y().i32(4).done(); const e = expd(durum); const n = e.yenile[String(id)] || 0; const l = cv(61400003, [1]); if (!altin(l[Math.min(n, l.length - 1)] || 1)) return new Y().i32(16).done(); e.yenile[String(id)] = n + 1; K(kaydet, durum); return new Y().i32(0).i32(id).i32(n + 1).i16(0).done(); };
  // ================= VOID SOUL WORLD =================
  H['0x01818b00'] = ({ durum, kaydet }) => {
    const previous = durum.bosDunya;
    const previousHpMax = previous && Number(previous.hpMax);
    const previousHp = previous && Number(previous.hp);
    const removedPlayers = voidRecoverPlayers(durum);
    const current = bosluk(durum);
    if (removedPlayers || previousHpMax !== current.hpMax || previousHp !== current.hp) K(kaydet, durum);
    return voidStatusPacket(durum);
  };
  H['0x01818b01'] = ({ durum, kaydet }) => {
    const b = bosluk(durum);
    const form = voidForm(durum, anaId());
    if (!form.length) return new Y().u32(1).done();
    b.submit = simdi();
    b.form = form;
    K(kaydet, durum);
    voidPush(durum);
    const w = new Y().u32(0).i32(b.submit).i16(form.length);
    for (const hero of form) w.i32(hero.heroId).i32(hero.pos);
    return w.done();
  };
  H['0x01818b03'] = ({ durum, kaydet }) => { bosluk(durum).dead = 0; K(kaydet, durum); voidPush(durum); return new Y().u32(0).done(); };
  H['0x01818b07'] = ({ durum, kaydet }) => {
    const b = bosluk(durum);
    if (!b.participated || b.award) return new Y().u32(1).done();
    const chest = VOID_CHESTS[Math.floor(Math.random() * VOID_CHESTS.length)];
    ver(durum, [{ type: 0, code: 0, amount: 30000 }, { type: 1, code: chest, amount: 1 }]);
    b.award = 1;
    K(kaydet, durum);
    voidPush(durum);
    return new Y().u32(0).done();
  };
  // ================= SEVEN KING =================
  const ruh = d => { d.yildiz = d.yildiz || {}; if (!Array.isArray(d.yildiz.ruh) || d.yildiz.ruh.length < 8) d.yildiz.ruh = [0, 0, 0, 0, 0, 0, 0, 0]; return d.yildiz.ruh; };
  const yediKral = d => { const g = gunlukS(d); g.yediKral = g.yediKral || { savas: 0, saygi: [0, 0, 0, 0, 0, 0, 0] }; return g.yediKral; };
  H['0x0181020d'] = ({ durum }) => { const k = yediKral(durum); const r = ruh(durum); const w = new Y().u16(k.savas).u32(0).u16(7); for (let i = 0; i < 7; i++) w.u8(k.saygi[i] || 0); w.u16(7); for (let i = 0; i < 7; i++) w.u32(r[i] || 0); return w.done(); };
  H['0x01813802'] = ({ payload, durum, kaydet }) => {
    const o = new O(payload); const tip = o.u32(), adet = Math.max(1, o.u32() || 1); const idx = tip - 82100001; if (idx < 0 || idx > 6) return new Y().u32(4).done();
    const k = yediKral(durum); const r = ruh(durum); const bedava = k.saygi[idx] < 1 ? 1 : 0; const ucretli = Math.max(0, adet - bedava); if (ucretli && !altin(10 * ucretli)) return new Y().u32(16).done();
    k.saygi[idx] += adet; const miktar = 10 * adet; const kritik = Math.random() < 0.1; r[idx + 1] = (r[idx + 1] || 0) + miktar * (kritik ? 2 : 1); K(kaydet, durum);
    return new Y().u32(0).u32(idx + 1).u32(miktar * (kritik ? 2 : 1)).u32(kritik ? 2 : 0).u8(kritik ? 1 : 0).done();
  };
  H['0x01813803'] = () => new Y().u16(0).done();
  // ================= CITY DEFEND / TRAITOR =================
  H['0x01812402'] = ({ durum, kaydet }) => { const s = ozet(durum); if (!altin(1 + (s.sehirDirilme || 0))) return new Y().u32(16).done(); s.sehirDirilme = (s.sehirDirilme || 0) + 1; K(kaydet, durum); return new Y().u32(0).done(); };
  H['0x01813400'] = ({ durum, kaydet }) => { const s = ozet(durum); const l = cv(60240016, [1]); if (!altin(l[Math.min(s.haindirilme || 0, l.length - 1)] || 1)) return new Y().u32(16).done(); s.haindirilme = (s.haindirilme || 0) + 1; K(kaydet, durum); return new Y().u32(0).done(); };
  // ================= SANDIKLAR =================
  const sandikOdulleri = () => [[{ type: 0, code: 0, amount: 5000 }, { type: 1, code: 14100003, amount: 1 }], [{ type: 0, code: 0, amount: 8000 }, { type: 1, code: 14100074, amount: 200 }], [{ type: 0, code: 0, amount: 12000 }, { type: 1, code: 14100010, amount: 2 }]];
  const sandikYaz = (w, kutular) => { w.i16(kutular.length); for (const k of kutular) { w.i16(k.length); for (const x of k) w.i16(x.type).i32(x.code).i32(x.amount); } };
  const kampMi = () => { try { const c = satir('City', Number(y.sonHurdle && y.sonHurdle()) || 0); return c ? Number(c.type) === 2 : true; } catch (e) { return true; } };
  H['0x01810601'] = ({ durum }) => { const w = new Y(); if (kampMi()) w.i32(0); const k = sandikOdulleri(); ozet(durum).sandik = k; sandikYaz(w, k); return w.done(); };
  H['0x01810500'] = ({ durum }) => { const w = new Y().i32(0); const k = sandikOdulleri(); ozet(durum).sandik = k; sandikYaz(w, k); return w.done(); };
  H['0x01810501'] = ({ payload, durum, kaydet }) => { const idx = Math.min(2, new O(payload).u8()); const k = ozet(durum).sandik || sandikOdulleri(); ver(durum, k[idx]); K(kaydet, durum); const w = new Y().i32(0).u8(idx); sandikYaz(w, k); return w.done(); };
  H['0x01810502'] = ({ payload, durum, kaydet }) => {
    const id = new O(payload).i32();
    const city = satir('City', id);
    if (!city || Number(city.type) !== 2) return { id: 0x01180503, payload: new Y().i32(4).i32(id).done() };
    if (!altin(20)) return { id: 0x01180503, payload: new Y().i32(16).i32(id).done() };
    for (const key of Object.keys(durum.instanceProgress || {})) {
      if (key.startsWith(`${id}:`)) delete durum.instanceProgress[key];
    }
    if (durum.instanceCampaign) delete durum.instanceCampaign[id];
    K(kaydet, durum);
    return { id: 0x01180503, payload: new Y().i32(0).i32(id).done() };
  };
  H['0x01810701'] = ({ payload, durum, kaydet }) => {
    const input = new O(payload);
    const tip = input.u8();
    const target = input.u32();
    const state = killHeroState(durum);
    const resetLimit = killHeroResetLimit();
    let ids = [];
    if (tip === 0) {
      const stage = RAIDERS_DAILY_BY_ID.get(target);
      const key = String(target);
      if (stage && state.passed.includes(target) &&
        (Number(state.resetCount[key]) || 0) < resetLimit &&
        (Number(state.enterCount[key]) || 0) > (Number(state.resetCount[key]) || 0)) ids = [target];
    } else if (tip === 1) {
      const city = satir('City', target);
      if (!city || Number(city.type) !== 3) return new Y().u32(4).done();
      ids = RAIDERS_DAILY
        .filter(stage => stage._id >= Number(city.start) && stage._id <= Number(city.last) &&
          state.passed.includes(stage._id) &&
          (Number(state.resetCount[String(stage._id)]) || 0) < resetLimit &&
          (Number(state.enterCount[String(stage._id)]) || 0) > (Number(state.resetCount[String(stage._id)]) || 0))
        .map(stage => stage._id);
    } else {
      return new Y().u32(4).done();
    }
    const resetCost = Math.max(0, Number(cv(60107013, 20)) || 20);
    if (ids.length && !altin(resetCost * ids.length)) return new Y().u32(16).done();
    for (const id of ids) {
      const key = String(id);
      state.resetCount[key] = Math.min(255, (Number(state.resetCount[key]) || 0) + 1);
    }
    if (ids.length) K(kaydet, durum);
    const w = new Y().u32(0).u16(ids.length);
    for (const id of ids) w.u32(id);
    return w.done();
  };
  Object.assign(H,require('./soul-hunt').kur(y).handlers);
  Object.assign(H,require('./protect-seireitei').kur(y).handlers);
  Object.assign(H,require('./cross-server').kur(y).handlers);
  Object.assign(H,require('./conquest').kur(y).handlers);
  return H;
}

module.exports = { kur, voidForm, voidBossHp, voidBossEnemyId: () => VOID_BOSS_ENEMY_ID, voidBossArmyId: date => voidBossArmy(date)._id, voidFightEnter, voidFinishFight, voidRecoverPlayers, voidCancelFight, voidFightDurationMs, voidTravelDurationMs, voidFightResult, voidDamageFromStatistics, voidRankPacket, voidStatusPacket, skyTowerCanChallenge, skyTowerApplyWin, killHeroApplyWin };
