'use strict';
// Bleach SAVAS motoru — fight istegine karsilik gecerli bir savas raporu + sonuc uretir.
// Iki mod:
//   1) REPLAY  : sunucu/savas/*.bin altinda yakalanmis GERCEK rapor varsa onu oynatir (en guvenli).
//   2) SENTEZ  : DB'den dogrulanmis hero+dusman ile aninda-kazanan rapor uretir.
// RoleId'ler Enemy∩RoleModel kesisiminden secilir (client mutlaka cozer) -> release build'de sessiz durma olmaz.

const fs = require('fs');
const path = require('path');
const kodek = require('./kodek');
const statlar = require('./statlar');
const arenaBot = require('./arena-bot');
const envanter = require('./envanter');

const VJSON = path.join(__dirname, '..', 'cikarim', 'veri-json');
const REPLAY_DIR = path.join(__dirname, 'savas');
const DIVIDER = 12101000; // HEROENEMY_DividingID

function loadJSON(f) { try { return JSON.parse(fs.readFileSync(path.join(VJSON, f), 'utf8')); } catch { return null; } }
function idNum(hex) { const n = parseInt(hex, 16); return Number.isFinite(n) ? n : 0; }
function tryParse(s) { try { return JSON.parse(s); } catch { return null; } }

// ---- DB yukle ----
const BaseHero = loadJSON('BaseHero.json') || [];
const RoleModel = loadJSON('RoleModel.json') || [];
const City = loadJSON('City.json') || [];
const Single = loadJSON('Single.json') || [];
const Enemy = loadJSON('Enemy.json') || [];
const BlockPoint = loadJSON('BlockPoint.json') || [];
const SinglePointPath = loadJSON('SinglePointPath.json') || [];
const TemplePoint = loadJSON('TemplePoint.json') || [];
const SkillConfig = loadJSON('SkillConfig.json') || loadJSON('skills.json') || [];
const ChangeHeroPoint = loadJSON('ChangeHeroPoint.json') || [];
const HeroChangeAttr = loadJSON('HeroChangeAttr.json') || [];

const roleModelSet = new Set(RoleModel.map(r => idNum(r.id)));
const skillSet = new Set(SkillConfig.map(s => idNum(s.id)));
const heroById = new Map(BaseHero.map(h => [idNum(h.id), h]));
const enemyById = new Map(Enemy.map(e => [idNum(e.id), e]));

// ---- kazanan hero sec (ana rol 11100001 tercih) ----
function heroValid(h) {
  if (!h) return false;
  const eff = tryParse(h.attackEffect); if (!eff) return false;
  const na = h.normalAttack, sk = h.active || h.skillId;
  if (eff[String(na)] == null) return false;
  if (sk == null || !skillSet.has(Number(sk))) return false;
  return roleModelSet.has(idNum(h.id));
}
function pickHero() {
  const pref = heroById.get(11100001);
  if (heroValid(pref)) return pref;
  for (const h of BaseHero) if (heroValid(h)) return h;
  return pref || BaseHero[0];
}

// ---- gecerli dusman sec: BlockPoint.roleModel listelerinden Enemy∩RoleModel olan ilk uygun ----
function enemyValid(id) {
  if (!(id > DIVIDER)) return false;
  if (!roleModelSet.has(id)) return false;
  const e = enemyById.get(id); if (!e) return false;
  const eff = tryParse(e.effects); if (!eff) return false;
  if (eff[String(e.normal)] == null) return false;
  if (e.skill == null || !skillSet.has(Number(e.skill))) return false;
  if (eff[String(e.skill)] == null) return false;
  return true;
}
function pickEnemy() {
  // 1) gercek stage dusmanlari (BlockPoint.roleModel)
  for (const bp of BlockPoint) {
    const list = tryParse(bp.roleModel);
    if (Array.isArray(list)) for (const id of list) if (enemyValid(Number(id))) return enemyById.get(Number(id));
  }
  // 2) dogrudan kesisim
  for (const e of Enemy) if (enemyValid(idNum(e.id))) return e;
  return Enemy[0];
}

const HERO = pickHero();
const ENEMY = pickEnemy();
console.log(`[savas] kazanan hero=${HERO ? idNum(HERO.id) : '?'} (${HERO && HERO.name}) | dusman=${ENEMY ? idNum(ENEMY.id) : '?'} (${ENEMY && ENEMY.name}) | RoleModel=${roleModelSet.size} Enemy=${enemyById.size} Skill=${skillSet.size}`);

// ---- REPLAY deposu: gercek yakalanmis rapor+sonuc ciftleri (NN.report.bin / NN.result.bin) ----
let REPLAYS = []; // [{report, result, stats}]
try {
  if (fs.existsSync(REPLAY_DIR)) {
    const reps = fs.readdirSync(REPLAY_DIR).filter(f => /\.report\.bin$/i.test(f)).sort();
    for (const rf of reps) {
      const idx = rf.replace(/\.report\.bin$/i, '');
      const pair = { report: fs.readFileSync(path.join(REPLAY_DIR, rf)) };
      const resf = path.join(REPLAY_DIR, idx + '.result.bin');
      const stf = path.join(REPLAY_DIR, idx + '.stats.bin');
      if (fs.existsSync(resf)) pair.result = fs.readFileSync(resf);
      if (fs.existsSync(stf)) pair.stats = fs.readFileSync(stf);
      REPLAYS.push(pair);
    }
  }
} catch { }
if (REPLAYS.length) console.log(`[savas] REPLAY: ${REPLAYS.length} gercek savas (rapor+sonuc) -> oynatilacak`);
let replayIdx = 0;

// ============ BUFF SECIMI (skill -> BuffEffect) ============
// Client buff satirini BuffEffect tablosundan cozuyor (TRole.AddBuffs:1677 null-KONTROLLU;
// bilinmeyen id sessizce dusuyor, crash yok). ANCAK buffId veya buffTurn SIFIR olursa satir
// "buff ekle" degil DelSameTypeBuffIndex ile "o tipteki TUM bufflari SIL" anlamina geliyor
// (TRole.as:1716) -> ikisi de mutlaka > 0 olmali.
// Skill -> buff eslemesi DB'de YOK (SkillConfig'de buff alani yok); sadece desc metninden
// turetilebiliyor. Yakalanan 3 gercek cift bu yontemle birebir uretiliyor:
//   13100033 "own hit rate"      -> 13500037 (alter 22)
//   13110003 "own ... damage rate"-> 13500054 (alter 28)
//   13160036 "caster's Defense"  -> 13500011 (alter 17,21)
const BuffEffect = loadJSON('BuffEffect.json') || [];
const buffKayit = BuffEffect.map(b => ({
  id: idNum(b.id), tip: Number(b.buffType) || 0, devam: Number(b.continued) || 0,
  alter: ((tryParse(b.alter) || {}).alter) || [], ad: b.name || '',
})).filter(b => b.id > 0);

// CONST_COMMON.BASEATTRIBUTENAME_* (BASEATTRIBUTEINDEX_* ile AYNI SEY DEGIL)
const ATTR_ANAHTAR = [
  [/hit rate|accuracy/i, [22]],
  [/dodge/i, [23]],
  [/crit/i, [24]],
  [/block/i, [25]],
  [/punch/i, [26]],
  [/damage rate|damage by|hurt rate/i, [28]],
  [/avoid|damage reduction/i, [29]],
  [/defen[cs]e/i, [17, 19, 21]],
  [/attack/i, [16, 18, 20]],
  [/speed/i, [11]],
  [/anger|rage/i, [104]],
  [/recover/i, [34]],
];
const skillDesc = new Map();
for (const s of SkillConfig) {
  const id = idNum(s.id), sid = Number(s.skillId) || 0;
  const d = String(s.desc || '').replace(/<[^>]*>/g, '').trim();
  if (!d) continue;
  if (!skillDesc.has(id)) skillDesc.set(id, d);
  if (sid && !skillDesc.has(sid)) skillDesc.set(sid, d);
}
const buffCache = new Map();
function skillBuff(skillId) {
  const k = skillId >>> 0;
  if (buffCache.has(k)) return buffCache.get(k);
  let sonuc = null;
  const d = skillDesc.get(k);
  if (d) {
    let attrs = null;
    for (const [re, a] of ATTR_ANAHTAR) if (re.test(d)) { attrs = a; break; }
    if (attrs) {
      // "increase own/caster" -> kendine pozitif (tip 7); "decrease/reduce enemy" -> tip 8
      const dusur = /decrease|reduce|lower/i.test(d) && !/own|caster|self/i.test(d);
      const tip = dusur ? 8 : 7;
      const aday = buffKayit
        .filter(b => b.tip === tip && b.devam === 0 && b.alter.some(x => attrs.includes(x)))
        .map(b => ({ b, skor: b.alter.filter(x => attrs.includes(x)).length }))
        .sort((x, y) => (y.skor - x.skor) || (x.b.id - y.b.id));
      if (aday.length) {
        const m = d.match(/(\d+)\s*rounds?/i);
        sonuc = {
          id: aday[0].b.id, tur: Math.max(1, Math.min(m ? Number(m[1]) || 3 : 3, 20)),
          kendine: !dusur, ad: aday[0].b.ad
        };
      }
    }
  }
  buffCache.set(k, sonuc);
  return sonuc;
}

// ---- Sentez: aninda-kazanan rapor ----
function synthReport(stageId = 0, stageStatScale = 1) {
  const heroId = idNum(HERO.id);
  const heroSkill = Number(HERO.active || HERO.skillId || 13100001);
  const heroHp = Number(HERO.life || 1000) || 1000;
  const stage = stageId ? stageDusmanlari(stageId) : null;
  const stageEnemy = stage && stage.birimler[0];
  const enemy = stageEnemy ? { ...stageEnemy } : dusmanBirim(ENEMY, 1);
  enemy.maxHp = Math.max(1, Math.round(enemy.maxHp * stageStatScale));
  enemy.hp = enemy.maxHp;
  const enemyId = enemy.id;
  const enemyHp = enemy.maxHp;
  const heroNormalEff = Number(HERO.normalAttack || 13100114);

  const info = {
    version: 2,
    player1: { roles: [{ pos: 1, roleId: heroId, quality: Number(HERO.quality) || 2, level: 1, curHealth: heroHp, totalHealth: heroHp, curAnger: 0, skillId: heroSkill, name: 'Player' }] },
    player2: { roles: [{ pos: enemy.pos, roleId: enemyId, quality: enemy.quality, level: enemy.level, curHealth: enemyHp, totalHealth: enemyHp, curAnger: 0, skillId: enemy.skillId, name: enemy.isim || ENEMY.name || 'Enemy' }] },
    turns: [
      {
        curTurn: 1, actives: [
          {
            activeCamp: 0, activePos: 1, skillEffectId: heroNormalEff, activeType: kodek.ACTIVE.NORMAL, targets: [
              { cmd: kodek.CMD.ATTACK, targetCamp: 1, targetPos: enemy.pos, reportTargetStatus: 0, result: { hurtHp: enemyHp, hurtAnger: 0 } }
            ]
          }
        ]
      }
    ]
  };
  return kodek.encodeBattleReport(info);
}

// --- Char paketinden ana hero: id, FightPosition, YAKALAMA seviyesi ve gercek stat ---
// Blok yurume/cozme/olcekleme statlar.js'te; herolar.js de ayni modulu kullaniyor ki
// client'in ekranda gosterdigi stat ile savastaki hasar birbirini tutsun.
function anaHero() {
  const a = statlar.anaKaynak();
  if (!a || !a.id) return null;
  return { id: a.id, pos: a.pos, lv: a.lv, stat: statlar.blokOku(a.blok) };
}

// ============================ SAVAS SIMULASYONU ============================
// Gercek yakalanmis raporlardan (savas/*.report.bin) cikarilan KURALLAR:
//  * Rapor surumu "3" (rol basina ek rebirthNum baytı).
//  * Her active 3 hedef satiri tasir:
//      1) cmd=NONE  -> vuranin KENDISI, status 0            (animasyon tetigi)
//      2) cmd=ATTACK-> hedef, status TARGET_EFFECT|HIT      (kritikse +CRIT)
//      3) cmd=ATTACK-> vuranin kendisi, status HIT, hurtHp=0, hurtAnger
//  * HIT biti olmayan satir client'ta DODGE olarak oynatilir -> hasar uygulanmaz.
//  * Ofke: baslangic 50. hurtAnger NEGATIF = kazanc (normal vurus -50),
//    POZITIF = harcama (skill +100). 100'e ulasinca skill (activeType=2) atilir.
//  * Turlar: once camp0 birimleri (pos artan), sonra camp1.
const ST = kodek.ST;

// Deterministik olmayan ama kontrollu ufak varyans (her savas birebir ayni gorunmesin)
let tohum = (Date.now() ^ 0x5bf03635) >>> 0;
function rnd() { tohum = (tohum * 1103515245 + 12345) & 0x7fffffff; return (tohum >>> 8) / 8388608; }

// Yerelde DOKUSU BULUNAN efekt id'leri (Resources/Textures/Skill/<ID 8-hex>.TexClient).
// Client animasyonu TexturesSkill.LoadPrimary(effectId) ile yukluyor; dosya yoksa vurus
// sessizce efektsiz oynuyor. Canli CDN bu dosyalarin cogunu artik servis etmiyor (404),
// bu yuzden en azindan MEVCUT olani tercih ediyoruz.
const DOKU = (() => {
  const s = new Set();
  try {
    const dizin = path.join(__dirname, '..', 'kaynak', 'login.gogames.me', 'public',
      '2017112917', 'Resources', 'Textures', 'Skill');
    for (const f of fs.readdirSync(dizin)) {
      const m = /^([0-9A-Fa-f]{8})\.TexClient$/.exec(f);
      if (m) s.add(parseInt(m[1], 16) >>> 0);
    }
  } catch (e) { }
  return s;
})();
console.log(`[savas] yerelde dokusu olan skill efekti: ${DOKU.size}`);

// attackEffect/effects haritasindan client'in COZEBILECEGI bir efekt id'si sec.
// Client efekti rolun KENDI haritasindan okur; haritada olmayan id -> animasyon kirilir,
// bu yuzden baska bir karakterin efekti konulamaz. Haritadaki adaylar arasinda once
// dokusu yerelde bulunani seciyoruz ki vurus gorsel olarak bos gecmesin.
function efektSec(harita, tercih) {
  if (!harita) return 0;
  const adaylar = Object.keys(harita).map(Number).filter(n => Number.isFinite(n) && n > 0);
  if (tercih && harita[String(tercih)] != null && DOKU.has(tercih >>> 0)) return Number(tercih);
  const dokulu = adaylar.find(n => DOKU.has(n >>> 0));
  if (dokulu) return dokulu;
  if (tercih && harita[String(tercih)] != null) return Number(tercih);   // doku yok: yine de gecerli id
  return adaylar.length ? adaylar[0] : 0;
}

// stat = char paketinden okunan gercek attribute blogu (client'in gosterdigi degerler).
// k    = bu heronun guc olcegi (statlar.olcek). Char paketine yazilan blok da AYNI
//        katsayiyla olceklendigi icin ekrandaki stat ile savas birebir ortusur.
// Yoksa BaseHero sablonu + seviye buyumesi ile hesaplanir.
function heroBirim(id, pos, lv, isim, stat, k, localBattleEffects = false) {
  const h = heroById.get(id);
  if (!h) {
    const e = enemyById.get(id);
    if (!e) return null;
    const u = dusmanBirim(e, pos);
    if (localBattleEffects && u.skill && !DOKU.has(u.skill >>> 0)) {
      u.skill = 0;
      u.skillId = u.normal;
      u.buff = null;
    }
    const baseLevel = Math.max(1, Number(e.level) || 1);
    const ratio = Math.max(0.5, Math.min(2, (Number(lv) || baseLevel) / baseLevel));
    u.camp = 0;
    u.level = Number(lv) || baseLevel;
    u.hp = u.maxHp = Math.max(1, Math.round(u.maxHp * ratio));
    u.atk = Math.max(1, Math.round(u.atk * ratio));
    if (isim) u.isim = isim;
    return u;
  }
  const eff = tryParse(h.attackEffect); if (!eff) return null;
  const normal = efektSec(eff, Number(h.normalAttack) || 0); if (!normal) return null;
  const aktif = Number(h.active) || 0;
  const skillOk = aktif && eff[String(aktif)] != null && skillSet.has(aktif) &&
    (!localBattleEffects || DOKU.has(aktif >>> 0));
  const ol = k && typeof k === 'object' ? k : (k > 0 ? k : 1);
  let hp, atk, def = 0, anger = 50;
  if (stat) {
    const hpOlcek = typeof ol === 'object' ? ol.life : ol;
    const atkOlcek = typeof ol === 'object' ? ol.genel : ol;
    def = Math.max(0, Math.round(stat.def * atkOlcek));
    hp = Math.max(1, Math.round(stat.hp * hpOlcek));
    atk = Math.max(1, Math.round(stat.atk * atkOlcek));
    anger = stat.anger || 50;
  } else {
    const growth = require('./seviye').buyumeTemeli(id, lv);
    if (!growth) return null;
    hp = Math.max(600, Math.round(growth.life * 6));
    atk = Math.max(20, Math.round(growth.combat * 0.6));
  }
  return {
    camp: 0, pos, id, hp, maxHp: hp, anger, atk, def,
    speed: stat ? stat.speed : Math.max(0, (Number(h.speed) || 0) + (Number(h.speedGrow) || 0) * Math.max(0, lv - 1)),
    buff: skillOk ? skillBuff(aktif) : null,
    normal, skill: skillOk ? aktif : 0, skillId: localBattleEffects ? (skillOk ? aktif : normal) : (aktif || normal),
    quality: Number(h.quality) || 2, level: lv, isim: isim != null && isim !== '' ? isim : (h.name || ''),
  };
}

function dusmanBirim(e, pos) {
  const eff = tryParse(e.effects) || {};
  const normal = efektSec(eff, Number(e.normal) || 0);
  const skill = Number(e.skill) || 0;
  const skillOk = skill && eff[String(skill)] != null && skillSet.has(skill);
  const a = tryParse(e.attacks) || {};
  const d = tryParse(e.defenses) || {};
  const hp = Math.max(200, Number(e.hp) || 500);
  const guc = Math.max(Number(a.strength) || 0, Number(a.agility) || 0, Number(a.intellect) || 0);
  return {
    camp: 1, pos, id: idNum(e.id), hp, maxHp: hp, anger: Number(e.anger) || 50,
    speed: Math.max(0, Number(e.speed) || 0),
    atk: Math.max(5, Math.round(guc * 0.45)),
    def: Math.max(Number(d.strength) || 0, Number(d.agility) || 0, Number(d.intellect) || 0),
    buff: skillOk ? skillBuff(skill) : null,
    normal, skill: skillOk ? skill : 0, skillId: skill || normal,
    quality: Number(e.quality) || 3, level: Number(e.level) || 1, isim: '',
  };
}

// ============ STAGE DUSMANLARI (stage config -> EnemyArmy -> Enemy) ============
// Zincir, TBlockPoint.as / TEnemyArmy.as'ten birebir:
//   CS_Enter_Hurdle (0x01810202) payload = [u32 cityId][u32 blockPointId]
//   BlockPoint.army   = {"army":[EnemyArmy id...]}
//   RaidersDailyConfig.enemyId = {"army":[EnemyArmy id...]}
//   EnemyArmy.front/middle/back = {"front":[Enemy id...]}
//   POZISYON (TEnemyArmy.MakeEnemyVect): front=1, middle=6, back=11; sirada her ek dusman +1.
// NOT: BlockPoint.roleModel TEK bir int (savas sahnesi modeli), dusman listesi DEGIL —
// eski pickEnemy onu liste sanip hep ayni dusmana (Murciélago) dusuyordu.
const EnemyArmy = loadJSON('EnemyArmy.json') || [];
const armyById = new Map(EnemyArmy.map(a => [idNum(a.id), a]));
const Award = loadJSON('Award.json') || [];
const awardById = new Map(Award.map(a => [idNum(a.id), a]));
const blockById = new Map(BlockPoint.map(b => [idNum(b.id), b]));
const singlePointById = new Map(SinglePointPath.map(p => [idNum(p.id), p]));
const templePointById = new Map(TemplePoint.map(p => [idNum(p.id), p]));
const changeHeroPointById = new Map(ChangeHeroPoint.map(p => [idNum(p.id), p]));
const cityById = new Map(City.map(c => [idNum(c.id), c]));
const singleById = new Map(Single.map(s => [idNum(s.id), s]));
const heroChangeByHeroId = new Map(HeroChangeAttr.map(attr => [idNum(attr.id), attr]));
const SKY_TOWERS = City
  .filter(city => idNum(city.id) >= 15900001 && idNum(city.id) <= 15900013)
  .sort((a, b) => idNum(a.id) - idNum(b.id));
const raidersDailyById = new Map((loadJSON('RaidersDailyConfig.json') || []).map(stage => [idNum(stage.id), stage]));
function stageById(id) {
  return blockById.get(id >>> 0) || singlePointById.get(id >>> 0) ||
    templePointById.get(id >>> 0) || raidersDailyById.get(id >>> 0) ||
    changeHeroPointById.get(id >>> 0) || null;
}

const HERO_CHANGE_FIGHT_REQ = 0x01816f09;
const HERO_CHANGE_INFO_RET = 0x01186f00;
function heroChangeCity(heroId) {
  const attr = heroChangeByHeroId.get(heroId >>> 0);
  const cityId = Number(attr && (attr.f9 !== undefined ? attr.f9 : attr.cityID)) >>> 0;
  return cityId ? cityById.get(cityId) || null : null;
}
function heroChangeFragmentId(payload) {
  if (!Buffer.isBuffer(payload) || payload.length < 4) return 0;
  const attr = heroChangeByHeroId.get(payload.readUInt32BE(0) >>> 0);
  const fragmentId = Number(attr && attr.chipValue) >>> 0;
  return fragmentId && envanter.article(fragmentId) ? fragmentId : 0;
}
function heroChangeProgress(durum, cityId) {
  const entry = durum && durum.heroChange && durum.heroChange.progress &&
    durum.heroChange.progress[String(cityId >>> 0)];
  if (typeof entry === 'number') return Math.max(0, Math.floor(entry));
  return Math.max(0, Math.floor(Number(entry && entry.currentMonsterNum) || 0));
}
function heroChangeStageId(payload, durum = null) {
  // Flash sends only the hero ID; infer the active point from that hero's saved city progress.
  if (!Buffer.isBuffer(payload) || payload.length < 4) return 0;
  const heroId = payload.readUInt32BE(0) >>> 0;
  const city = heroChangeCity(heroId);
  if (!city) return 0;
  const index = heroChangeProgress(durum, Number(city.id && idNum(city.id)) || 0);
  const stageId = (Number(city.start) || 0) + index;
  if (!stageId || stageId > Number(city.last) || !changeHeroPointById.has(stageId)) return 0;
  return stageDusmanlari(stageId) ? stageId : 0;
}
function syncHeroChangeInfo(durum, payload) {
  if (!durum || !Buffer.isBuffer(payload) || payload.length < 22) return false;
  let offset = 20;
  const chipCount = payload.readInt16BE(offset);
  offset += 2;
  if (chipCount < 0 || chipCount > 4096 || offset + chipCount * 8 + 2 > payload.length) return false;
  offset += chipCount * 8;
  const progressCount = payload.readInt16BE(offset);
  offset += 2;
  if (progressCount < 0 || progressCount > 4096 || offset + progressCount * 24 > payload.length) return false;
  const progress = {};
  for (let i = 0; i < progressCount; i++) {
    const cityId = payload.readUInt32BE(offset) >>> 0;
    const currentResetTime = payload.readInt32BE(offset + 4);
    const currentMonsterNum = payload.readInt32BE(offset + 8);
    const currentReliveTime = payload.readInt32BE(offset + 12);
    const currentDieTime = payload.readInt32BE(offset + 16);
    const highestRecord = payload.readInt32BE(offset + 20);
    offset += 24;
    if (!cityId || currentResetTime < 0 || currentMonsterNum < 0 ||
      currentReliveTime < 0 || currentDieTime < 0 || highestRecord < 0) return false;
    progress[String(cityId)] = {
      currentResetTime, currentMonsterNum, currentReliveTime, currentDieTime, highestRecord,
    };
  }
  const heroChange = durum.heroChange || (durum.heroChange = {});
  const prior = heroChange.progress || {};
  heroChange.progress = { ...prior, ...progress };
  if (progressCount) {
    heroChange.fightTime = payload.readUInt32BE(12);
    heroChange.buyTime = payload.readUInt32BE(16);
  }
  return progressCount > 0;
}
function heroChangeInfoPacket(durum) {
  const cityIds = Array.from(new Set(HeroChangeAttr
    .map(attr => Number(attr.f9 !== undefined ? attr.f9 : attr.cityID) >>> 0)
    .filter(Boolean))).sort((a, b) => a - b);
  const chipIds = Array.from(new Set(HeroChangeAttr.map(attr => Number(attr.chipValue) >>> 0).filter(Boolean)))
    .sort((a, b) => a - b);
  const progress = durum && durum.heroChange && durum.heroChange.progress || {};
  const heroChange = durum && durum.heroChange || {};
  const degisim = durum && durum.degisim || {};
  const envanter = require('./envanter');
  const packet = Buffer.alloc(24 + chipIds.length * 8 + cityIds.length * 24);
  packet.writeUInt32BE(Math.max(0, Number(degisim.chip) || 0) >>> 0, 0);
  packet.writeUInt32BE(envanter.mevcut(durum, 14100352) >>> 0, 4);
  packet.writeUInt32BE(envanter.mevcut(durum, 14100353) >>> 0, 8);
  packet.writeUInt32BE(Math.max(0, Number(heroChange.fightTime) || 0) >>> 0, 12);
  packet.writeUInt32BE(Math.max(0, Number(heroChange.buyTime) || 0) >>> 0, 16);
  packet.writeUInt16BE(chipIds.length, 20);
  let offset = 22;
  for (const chipId of chipIds) {
    packet.writeUInt32BE(chipId, offset);
    packet.writeUInt32BE(envanter.mevcut(durum, chipId) >>> 0, offset + 4);
    offset += 8;
  }
  packet.writeUInt16BE(cityIds.length, offset);
  offset += 2;
  for (const cityId of cityIds) {
    const entry = progress[String(cityId)] || {};
    packet.writeInt32BE(cityId, offset);
    packet.writeInt32BE(Math.max(0, Number(entry.currentResetTime) || 0), offset + 4);
    packet.writeInt32BE(Math.max(0, Number(entry.currentMonsterNum) || 0), offset + 8);
    packet.writeInt32BE(Math.max(0, Number(entry.currentReliveTime) || 0), offset + 12);
    packet.writeInt32BE(Math.max(0, Number(entry.currentDieTime) || 0), offset + 16);
    packet.writeInt32BE(Math.max(0, Number(entry.highestRecord) || 0), offset + 20);
    offset += 24;
  }
  return packet;
}
function heroChangeAttempt(durum) {
  const heroChange = durum.heroChange || (durum.heroChange = {});
  heroChange.fightTime = Math.max(0, Number(heroChange.fightTime) || 0) + 1;
  return heroChange.fightTime;
}
function heroChangeWon(durum, payload, stageId) {
  if (!durum || !Buffer.isBuffer(payload) || payload.length < 4 || !stageId) return false;
  const city = heroChangeCity(payload.readUInt32BE(0));
  if (!city || stageId < Number(city.start) || stageId > Number(city.last)) return false;
  const cityId = idNum(city.id);
  const index = stageId - Number(city.start);
  const heroChange = durum.heroChange || (durum.heroChange = {});
  const progress = heroChange.progress || (heroChange.progress = {});
  const prior = progress[String(cityId)] || {};
  progress[String(cityId)] = {
    ...prior,
    currentMonsterNum: index + 1,
    highestRecord: Math.max(Number(prior.highestRecord) || 0, index + 1),
  };
  return true;
}
function heroChangeReset(durum, heroId) {
  const city = heroChangeCity(heroId);
  if (!durum || !city) return false;
  const heroChange = durum.heroChange || (durum.heroChange = {});
  const progress = heroChange.progress || (heroChange.progress = {});
  const cityId = idNum(city.id);
  const prior = progress[String(cityId)] || {};
  progress[String(cityId)] = { ...prior, currentMonsterNum: 0 };
  return true;
}
function heroChangeOneKey(durum, heroId) {
  const city = heroChangeCity(heroId);
  if (!durum || !city) return false;
  const heroChange = durum.heroChange || (durum.heroChange = {});
  const progress = heroChange.progress || (heroChange.progress = {});
  const cityId = idNum(city.id);
  const prior = progress[String(cityId)] || {};
  progress[String(cityId)] = {
    ...prior,
    currentMonsterNum: Math.max(0, Number(prior.highestRecord) || 0),
  };
  return true;
}

function jliste(s, anahtar) {
  const o = tryParse(s);
  if (!o) return [];
  const v = Array.isArray(o) ? o : o[anahtar];
  return Array.isArray(v) ? v.map(Number).filter(n => n > 0) : [];
}
function stageArmyIds(stage) {
  if (stage && stage.enemyId) return jliste(stage.enemyId, 'army');
  if (stage && stage.army) return jliste(stage.army, 'army');
  return jliste(stage && stage.battleScene, 'army');
}

function raidersDailyStageId(payload) {
  if (!Buffer.isBuffer(payload) || payload.length < 8) return 0;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const stageId = payload.readUInt32BE(4) >>> 0;
  const city = cityById.get(cityId);
  if (!city || Number(city.type) !== 3 || !raidersDailyById.has(stageId) ||
    stageId < Number(city.start) || stageId > Number(city.last)) return 0;
  return stageId;
}

function isRaidersDailyCity(cityId) {
  const city = cityById.get(cityId >>> 0);
  return !!city && Number(city.type) === 3 && raidersDailyById.has(Number(city.start) >>> 0);
}

// Bir BlockPoint'in dusman kadrosu. Client'in cozemeyecegi id'ler elenir (yoksa savas donar).
function worldMapLevel(stageId) {
  const point=blockById.get(stageId >>> 0);
  const city=point && cityById.get(Number(point.campaign));
  if(!city || Number(city.type)!==1) return 0;
  const first=blockById.get(Number(city.start)),last=blockById.get(Number(city.last));
  if(!first || !last) return 0;
  const low=Math.max(1,Number(first.level)||1),high=Math.max(low,Number(last.level)||low);
  const count=Number(city.last)-Number(city.start);
  const progress=Math.max(0,Math.min(count,stageId-Number(city.start)));
  return count>0?Math.round(low+(high-low)*progress/count):low;
}
function worldMapScale(unit,level) {
  const factor=Math.pow(level/Math.max(1,Number(unit.level)||1),2);
  for(const field of ['maxHp','atk','def','speed']) unit[field]=Math.min(1000000000,Math.max(field==='maxHp'?100:field==='atk'?1:0,Math.round(unit[field]*factor)));
  unit.hp=unit.maxHp;unit.level=level;
  return unit;
}
function stageDusmanlari(bpId) {
  const bp = stageById(bpId); if (!bp) return null;
  const out = stageArmyDusmanlari(stageArmyIds(bp));
  if (!out.length) return null;
  const stageLevel = stageSeviye(bpId, bp);
  const mapLevel = worldMapLevel(bpId);
  if(mapLevel > 0) {
    for(const unit of out) worldMapScale(unit,mapLevel);
    return {birimler:out.slice(0,9),ad:bp.name||''};
  }
  if (stageLevel > 0) {
    for (const unit of out) {
      const enemyLevel = Math.max(1, Number(unit.level) || 1);
      const scale = Math.max(1, stageLevel / enemyLevel);
      if (scale > 1) {
        unit.hp = unit.maxHp = Math.max(1, Math.round(unit.maxHp * scale));
        unit.atk = Math.max(1, Math.round(unit.atk * scale));
        unit.def = Math.max(0, Math.round(unit.def * scale));
      }
      unit.level = Math.max(enemyLevel, stageLevel);
    }
  }
  return { birimler: out.slice(0, 9), ad: bp.name || '' };
}
function stageSeviye(stageId, stage) {
  const mapLevel=worldMapLevel(stageId);if(mapLevel>0)return mapLevel;
  if (raidersDailyById.has(stageId >>> 0)) return Math.max(0, Number(stage.level) || 0);
  if (singlePointById.has(stageId >>> 0)) {
    const campaign = Single.find(row => stageId >= Number(row.startId) && stageId <= Number(row.endId));
    return Math.max(0, Number(campaign && campaign.level) || 0);
  }
  return Math.max(0, Number(stage.level) || 0);
}
function stageArmyDusmanlari(armyIds) {
  const out = [];
  const ekle = (idler, basPos) => {
    let pos = basPos;
    for (const id of idler) {
      if (!out.some(u => u.id === id) && enemyValid(id)) out.push(dusmanBirim(enemyById.get(id), pos));
      pos++;                       // gecersiz olsa da pozisyon ilerler (dizilim korunur)
    }
  };
  for (const aid of armyIds) {
    const a = armyById.get(aid); if (!a) continue;
    ekle(jliste(a.front, 'front'), 1);
    ekle(jliste(a.middle, 'middle'), 6);
    ekle(jliste(a.back, 'back'), 11);
  }
  return out.slice(0, 9);
}

// Fight isteginden stage id'si (Enter_Hurdle / WorldMap_AutoBattle: 2. u32).
// Single instance point'leri BlockPoint'te degil SinglePointPath'te tanimlidir.
function stageIdCoz(payload, durum = null) {
  if (!payload || payload.length < 8) return 0;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const bpId = payload.readUInt32BE(4) >>> 0;
  if (raidersDailyById.has(bpId)) return raidersDailyStageId(payload);
  const city = cityById.get(cityId);
  if (city && Number(city.type) === 1) {
    if (bpId < Number(city.start) || bpId > Number(city.last) || !blockById.has(bpId)) return 0;
  } else if (city && Number(city.type) === 2) {
    const campaign = singleById.get(bpId);
    if (campaign && bpId >= Number(city.start) && bpId <= Number(city.last)) {
      const progressKey = `${cityId}:${bpId}`;
      const savedStage = Number(durum && durum.instanceProgress && durum.instanceProgress[progressKey]) >>> 0;
      const stageId = savedStage || (Number(campaign.startId) >>> 0);
      return stageId >= Number(campaign.startId) && stageId <= Number(campaign.endId) &&
        singlePointById.has(stageId) ? stageId : 0;
    }
    const campaignForPoint = Single.find(row => {
      const id = idNum(row.id);
      return id >= Number(city.start) && id <= Number(city.last) &&
        bpId >= Number(row.startId) && bpId <= Number(row.endId);
    });
    if (!campaignForPoint || !singlePointById.has(bpId)) return 0;
  }
  return stageById(bpId) ? bpId : 0;
}
function instanceStageWon(durum, payload, stageId) {
  if (!durum || !Buffer.isBuffer(payload) || payload.length < 8 || !stageId) return false;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const campaignId = payload.readUInt32BE(4) >>> 0;
  const campaign = singleById.get(campaignId);
  const city = cityById.get(cityId);
  if (!campaign || !city || Number(city.type) !== 2 ||
    campaignId < Number(city.start) || campaignId > Number(city.last) ||
    stageId < Number(campaign.startId) || stageId > Number(campaign.endId)) return false;
  durum.instanceProgress = durum.instanceProgress || {};
  const key = `${cityId}:${campaignId}`;
  const current = Number(durum.instanceProgress[key]) || Number(campaign.startId);
  if (stageId !== current) return false;
  durum.instanceProgress[key] = Math.min(Number(campaign.endId), stageId + 1);
  return true;
}
function stageAssessment(payload, won, resolvedStageId = 0) {
  if (!won || !Buffer.isBuffer(payload) || payload.length < 8) return null;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const stageId = resolvedStageId || stageIdCoz(payload);
  const city = cityById.get(cityId);
  if (!stageId || !city || ![1, 2].includes(Number(city.type))) return null;
  const body = Buffer.alloc(13);
  body.writeUInt32BE(0, 0);
  body.writeUInt32BE(cityId, 4);
  body.writeUInt32BE(stageId, 8);
  body.writeUInt8(3, 12);
  return { id: Number(city.type) === 2 ? 0x01180600 : 0x01180500, payload: body };
}
function stageNextLayer(payload, won, resolvedStageId = 0) {
  if (!won || !Buffer.isBuffer(payload) || payload.length < 8) return null;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const stageId = resolvedStageId || stageIdCoz(payload);
  const city = cityById.get(cityId);
  if (!stageId || !city || Number(city.type) !== 2) return null;
  const campaign = Single.find(row => {
    const id = idNum(row.id);
    return id >= Number(city.start) && id <= Number(city.last) &&
      stageId >= Number(row.startId) && stageId <= Number(row.endId);
  });
  if (!campaign) return null;
  const body = Buffer.alloc(12);
  body.writeUInt32BE(0, 0);
  body.writeUInt32BE(cityId, 4);
  body.writeUInt32BE(idNum(campaign.id), 8);
  return { id: 0x01180603, payload: body };
}
function stageCityType(cityId) {
  const city = cityById.get(cityId >>> 0);
  return city ? Number(city.type) || 0 : 0;
}
function skyTowerStageId(payload) {
  if (!Buffer.isBuffer(payload) || payload.length < 10 || payload.readUInt8(0) !== 1) return 0;
  const towerId = payload.readUInt32BE(2) >>> 0;
  const layerId = payload.readUInt32BE(6) >>> 0;
  const tower = cityById.get(towerId);
  const point = templePointById.get(layerId);
  if (!tower || !point || layerId < Number(tower.start) || layerId > Number(tower.last)) return 0;
  return layerId;
}
function skyTowerStatScale(layerId) {
  const id = Number(layerId) >>> 0;
  let floorsBefore = 0;
  for (const tower of SKY_TOWERS) {
    const start = Number(tower.start) >>> 0;
    const last = Number(tower.last) >>> 0;
    if (id >= start && id <= last && templePointById.has(id)) {
      const floorIndex = floorsBefore + id - start;
      return 2 * (1 + floorIndex * 0.01);
    }
    if (last >= start) floorsBefore += last - start + 1;
  }
  return 1;
}

const rolBilgisi = u => ({
  pos: u.pos, roleId: u.id, quality: u.quality, level: u.reportLevel || u.level,
  curHealth: u.hp, totalHealth: u.maxHp, curAnger: 50, skillId: u.skillId,
  name: u.isim || '', rebirthNum: (u.rebirth || {}).n || 0,
});

// Tek bir vurus (active) uret + HP/ofkeyi guncelle
function vurus(u, hedef, bitir, opponents = [hedef], random = Math.random) {
  const rebirth = require('./reincarnation');
  const skillAt = !!u.skill && u.anger >= 100;
  const eff = skillAt ? u.skill : u.normal;
  const targets = [{ cmd: kodek.CMD.NONE, targetCamp: u.camp, targetPos: u.pos, reportTargetStatus: 0, result: {} }];
  const aoe = !skillAt && rebirth.proc(u, 4, random);
  const victims = aoe ? opponents.filter(target => target.hp > 0) : [hedef];
  const triple = rebirth.proc(u, 2, random);
  const ignoreDefense = rebirth.proc(u, 5, random);
  for (const victim of victims) {
    let dmg = Math.round(u.atk * (skillAt ? 1.8 : 1) * (0.92 + random() * 0.16) * (triple ? 3 : 1));
    const critical = !((victim.rebirth || {}).n > 0 && (victim.rebirth || {}).ae === 9) && random() < 0.15;
    if (critical) dmg = Math.round(dmg * 1.5);
    if (victim.def > 0 && !ignoreDefense) dmg = Math.round(dmg * u.atk / (u.atk + victim.def));
    dmg = Math.max(1, dmg);
    if (bitir) dmg = Math.max(dmg, victim.hp);
    dmg = Math.max(0, Math.round(dmg * (1 + (u.damageBonus || 0)) * (1 - (victim.damageReduction || 0)) * (u.damageMultiplier || 1)));
    const result = rebirth.hit(u, victim, dmg, random);
    const status = (ST.TARGET_EFFECT | ST.HIT | (critical ? ST.CRIT : 0)) >>> 0;
    targets.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:status,result:{hurtHp:result.damage,hurtAnger:0}});
    if (result.recovered) targets.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:-result.recovered,hurtAnger:0}});
    if (result.clearShield || result.absorbed) targets.push({cmd:kodek.CMD.SHIELD,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:victim.shield||0}});
    if (result.clearBuffs) targets.push({cmd:kodek.CMD.ATTRBUFF,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});
  }
  if (skillAt && u.buff && u.buff.id > 0) targets.push({
    cmd:kodek.CMD.ATTRBUFF,targetCamp:u.buff.kendine?u.camp:hedef.camp,targetPos:u.buff.kendine?u.pos:hedef.pos,
    reportTargetStatus:ST.HIT>>>0,result:{buffId:u.buff.id,buffTurn:u.buff.tur}
  });
  if (rebirth.proc(u,10,random)) {
    const alive = opponents.filter(target => target.hp > 0);
    if (alive.length >= 2) {
      const first=alive[0],second=alive[1],oldFirst=first.pos,oldSecond=second.pos;
      targets.push({cmd:kodek.CMD.POSITION,targetCamp:first.camp,targetPos:oldFirst,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:oldSecond}});
      targets.push({cmd:kodek.CMD.POSITION,targetCamp:second.camp,targetPos:oldSecond,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:oldFirst}});
      first.pos=oldSecond;second.pos=oldFirst;
    }
  }
  const anger=skillAt?100:-50;
  u.anger=Math.max(0,Math.min(100,u.anger-anger));
  targets.push({cmd:kodek.CMD.ATTACK,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:0,hurtAnger:anger}});
  return {activeCamp:u.camp,activePos:u.pos,skillEffectId:eff,activeType:skillAt?kodek.ACTIVE.SKILL:kodek.ACTIVE.NORMAL,targets};
}

// --- WORLD MAP ZORLUK DENGESI ---
// World Map dusmanlari oyuncu gucune gore yumusak olceklenir; diger stage turleri
// kendi Enemy.level/HP/attack degerlerini korur ve instance stage level'i dusuk kalan
// dusmanlar icin yalniz yukari dogru bir alt sinir uygular.
const HEDEF_TUR = 4;
function dengele(p1, p2, power = 1, preserveStageDifficulty = false) {
  if (!p1.length || !p2.length) return null;
  const kuvvet = Math.max(0.5, Math.min(2, Number(power) || 1));
  const takimDps = p1.reduce((s, u) => s + u.atk, 0);
  const takimHp = p1.reduce((s, u) => s + u.maxHp, 0);
  const dusHp = Math.max(1, p2.reduce((s, u) => s + u.maxHp, 0));
  const dusAtk = Math.max(1, p2.reduce((s, u) => s + u.atk, 0));
  const hpRatio = (takimDps * HEDEF_TUR) / dusHp;
  const hpScale = preserveStageDifficulty ? Math.sqrt(hpRatio) : hpRatio;
  const kHp = Math.max(1, hpScale) * kuvvet;
  // Dusman turda takimin ~%12'sini goturebilsin; ama tek vurus bir heroyu yatirmasin
  const enZayif = Math.min(...p1.map(u => u.maxHp));
  const enSertDusman = Math.max(...p2.map(u => u.atk), 1);
  const tavan = (enZayif * 0.22) / enSertDusman;
  const kAtk = Math.max(1, Math.min((takimHp * 0.10) / dusAtk, Math.max(1, tavan))) * kuvvet;
  for (const u of p2) {
    u.hp = u.maxHp = Math.max(50, Math.round(u.maxHp * kHp));
    u.atk = Math.max(5, Math.round(u.atk * kAtk));
  }
  return { kHp, kAtk };
}

// --- OYUNCUNUN KADROSUNDAN gercek akisli savas raporu uret ---
// Replay modu eski hesabin kadrosunu oynatiyordu; Formation'a eklenen herolar savasa gelmiyordu.
const MAX_TUR = 24;
let SON_ISTATISTIK = null;                 // en son uretilen savasin istatistik paketi
let SON_OYUNCU_HASARI = 0;
function sonIstatistik() { return SON_ISTATISTIK; }
function sonOyuncuHasari() { return SON_OYUNCU_HASARI; }
// Speed bonuses affect initiative; stable camp/slot order resolves equal speeds.
function initiative(units) {
  return units.slice().sort((a,b) => (Number(b.speed)||0) - (Number(a.speed)||0) || a.camp-b.camp || a.pos-b.pos);
}

function kadroRapor(bpId, arenaRakip, enemyOverride, options = {}) {
  SON_OYUNCU_HASARI = 0;
  const ana = anaHero(); if (!ana || !ana.id) return null;
  let kadro = {}, nick = '', durumK = {};
  try { const d = options.playerState || require('./durum').yukle() || {}; durumK = d; kadro = d.kadro || {}; nick = d.nick || ''; } catch (e) { }
  let lv = 99; try { lv = Number(JSON.parse(fs.readFileSync(path.join(__dirname, 'veri.json'), 'utf8')).level) || 99; } catch (e) { }
  // Partnerlerin KENDI kalici seviyesi (seviye.js); kaydi yoksa ana seviye.
  const lvOf = id => { try { return require('./seviye').heroSeviye(durumK, id) || lv; } catch (e) { return lv; } };

  const ekipman = require('./ekipman');
  const statPaketleri = new Set();
  const combatStat = (id, level) => {
    const packet = ekipman.statPaketi(durumK, id, level);
    const stat = packet ? statlar.blokOku(packet.subarray(4)) : null;
    if (stat) statPaketleri.add(id >>> 0);
    return stat;
  };
  const p1 = [];
  // Olcek: yakalanan blok ana heronun YAKALAMA seviyesindeki stati -> guncel level'e buyur.
  // Ayni katsayi char paketine de yaziliyor (herolar.js) -> ekrandaki stat ile savas ortusur.
  const kOl = (id, l) => statlar.olcekler(id, l || lv, ana.id, ana.lv);
  const anaPos = Number(kadro[String(ana.id)]) > 0 ? Number(kadro[String(ana.id)]) : (ana.pos || 6);
  const anaStat = combatStat(ana.id, lv);
  const bas = heroBirim(ana.id, anaPos, lv, nick, anaStat || ana.stat, anaStat ? 1 : kOl(ana.id, lv));
  if (!bas) return null;
  p1.push(bas);
  for (const [k, p] of Object.entries(kadro)) {
    const id = Number(k), pos = Number(p);
    if (!id || pos <= 0 || p1.some(t => t.id === id)) continue;
    const l = lvOf(id);
    const stat = combatStat(id, l);
    const u = heroBirim(id, pos, l, null, stat || ana.stat, stat ? 1 : kOl(id, l));
    if (u) p1.push(u);
  }
  for (const unit of p1) {
    unit.rebirth = require('./reincarnation').record(durumK, unit.id);
    const bonus = ekipman.bonuslar(durumK, unit.id);
    if (!statPaketleri.has(unit.id >>> 0)) {
      const hp = Math.max(0, bonus[5] || 0) + Math.max(0, bonus[3] || 0) * 6;
      unit.hp += hp;
      unit.maxHp += hp;
      unit.atk += Math.max(0, bonus[6] || 0, bonus[7] || 0);
      unit.def = Math.max(0, unit.def || 0) + Math.max(0, bonus[8] || 0, bonus[9] || 0);
    }
    unit.damageBonus = bonus[18] || 0;
    unit.damageReduction = bonus[19] || 0;
  }
  if(options.playerStatBoost && ['atk','def','maxHp'].includes(options.playerStatBoost.field)) {
    const field=options.playerStatBoost.field,factor=1+Math.max(0,Number(options.playerStatBoost.percent)||0)/100;
    for(const unit of p1){unit[field]=Math.min(1000000000,Math.round(unit[field]*factor));if(field==='maxHp')unit.hp=unit.maxHp;}
  }
  // Arena botu varsa onun gercek kahraman kadrosunu, diger savaslarda stage dusmanlarini kullan.
  // Stage kadrosu bulunmayan diger modlarda varsayilan dusmana dusulur.
  const st = enemyOverride || (!arenaRakip && bpId ? stageDusmanlari(bpId) : null);
  const p2 = arenaRakip
    ? arenaRakip.heroes.map((id, i) => {
      const pos = Array.isArray(arenaRakip.positions) ? arenaRakip.positions[i] : [1, 6, 11][i];
      const u = heroBirim(id, pos, arenaRakip.baseLevel || arenaRakip.level, null, null, 0, true);
      if (!u) return null;
      u.camp = 1;
      return u;
    }).filter(Boolean)
    : (st && st.birimler.length) ? st.birimler : [dusmanBirim(ENEMY, 6)];
  if (st) console.log(`[savas] stage ${bpId} "${st.ad}" -> ${p2.length} dusman: ${p2.map(u => u.id + '@pos' + u.pos).join(', ')}`);
  if (arenaRakip) console.log(`[arena] ${arenaRakip.name} lv${arenaRakip.level} -> ${p2.length} hero, power x${arenaRakip.power}`);

  if (options.scaleEnemy !== false && !worldMapLevel(bpId)) {
    const denge = dengele(p1, p2, arenaRakip ? arenaRakip.power : 1, !!st && !arenaRakip);
    if (denge) console.log(`[savas] denge: dusman hp x${denge.kHp.toFixed(1)} atk x${denge.kAtk.toFixed(1)}`);
  }
  // Cross Server only: keep the previous bot baseline, then apply row difficulty.
  if (arenaRakip && Number(arenaRakip.crossStatScale) > 0) {
    const factor = Number(arenaRakip.crossStatScale);
    for (const unit of p2) {
      for (const field of ['maxHp','atk','def','speed']) unit[field] = Math.min(1000000000, Math.max(0, Math.round(unit[field] * factor)));
      unit.atk = Math.min(1000000000, Math.round(unit.atk * (Number(arenaRakip.crossAttackScale) || 1)));
      unit.hp = unit.maxHp;
      unit.level = arenaRakip.level;
    }
  }
  const stageStatScale = Math.max(1, Number(options.stageStatScale) || 1);
  if (stageStatScale > 1 && !arenaRakip) {
    for (const unit of p2) {
      const enemy = enemyById.get(unit.id);
      const defenses = tryParse(enemy && enemy.defenses) || {};
      const defense = Math.max(
        Number(defenses.strength) || 0,
        Number(defenses.agility) || 0,
        Number(defenses.intellect) || 0,
      );
      unit.hp = unit.maxHp = Math.max(1, Math.round(unit.maxHp * stageStatScale));
      unit.atk = Math.max(1, Math.round(unit.atk * stageStatScale));
      unit.def = Math.max(0, Math.round(defense * stageStatScale));
    }
  }
  const enemyAttackScale = Math.max(0, Number(options.enemyAttackScale) || 1);
  if (enemyAttackScale !== 1 && !arenaRakip) {
    for (const unit of p2) {
      unit.atk = Math.max(1, Math.round(unit.atk * enemyAttackScale));
    }
  }
  // Hueco Mundo carries surviving HP between points; other modes start at full HP.
  for (const [team, rates] of [[p1, options.playerHpRates], [p2, options.enemyHpRates]]) {
    if (rates) for (const unit of team) {
      const rate = rates[String(unit.id)];
      if (Number.isFinite(rate)) unit.hp = Math.max(0, Math.round(unit.maxHp * Math.max(0, Math.min(100, rate)) / 100));
    }
  }
  // roller simulasyondan ONCE (curHealth = baslangic HP'si)
  const roles1 = p1.map(rolBilgisi), roles2 = p2.map(rolBilgisi);
  const sirali = arr => arr.slice().sort((a, b) => a.pos - b.pos);
  const turns = [];
  for (let t = 1; t <= MAX_TUR; t++) {
    let arenaFinisher = 0;
    if (arenaRakip && t === MAX_TUR) {
      const hpRatio = team => {
        const maxHp = team.reduce((sum, u) => sum + u.maxHp, 0);
        return maxHp ? team.reduce((sum, u) => sum + Math.max(0, u.hp), 0) / maxHp : 0;
      };
      arenaFinisher = hpRatio(p2) > hpRatio(p1) ? 1 : 0;
    }
    const actives = [];
    for (const u of initiative(p1.concat(p2))) {
      if (u.hp <= 0) continue;
      const ayakta = (u.camp === 0 ? p2 : p1).filter(x => x.hp > 0);
      const rakip = sirali(ayakta)[0];
      if (!rakip) break;
      const bitir = options.forceWin !== false && t === MAX_TUR && (arenaRakip ? u.camp === arenaFinisher : u.camp === 0);
      const act = vurus(u, rakip, bitir, u.camp === 0 ? p2 : p1);
      // targets[1] = hasar satiri (targets[0] self-trigger) -> istatistik icin topla
      u.verdi = (u.verdi || 0) + act.targets.filter(target => target.targetCamp !== u.camp).reduce((sum, target) => sum + Math.max(0, Number(target.result.hurtHp) || 0), 0);
      actives.push(act);
      if (p2.every(x => x.hp <= 0)) break;
    }
    if (actives.length) turns.push({ curTurn: t, actives });
    if (p2.every(x => x.hp <= 0) || p1.every(x => x.hp <= 0)) break;
  }
  // Savas istatistigi: client "Battle Stats"a basinca CS 0x01548002 ile ISTIYOR (payload yok).
  const ist = u => ({ heroId: u.id, hurt: u.verdi || 0, remainHp: u.maxHp > 0 ? Math.max(0, u.hp) / u.maxHp : 0 });
  SON_OYUNCU_HASARI = p1.reduce((sum, unit) => sum + (unit.verdi || 0), 0);
  SON_ISTATISTIK = kodek.encodeStatistics(p1.map(ist), p2.map(ist));
  return {
    payload: kodek.encodeBattleReport({ version: options.battleDataVersion || 3, player1: { roles: roles1 }, player2: { roles: roles2 }, turns }),
    remainingHp: p1.concat(p2).map(unit => ({ camp: unit.camp, id: unit.id, rate: Math.max(0, unit.hp) / unit.maxHp })),
    won: arenaRakip
      ? p2.every(x => x.hp <= 0) && p1.some(x => x.hp > 0)
      : (options.requireEnemyDefeated
        ? p1.some(x => x.hp > 0) && p2.every(x => x.hp <= 0)
        : (options.reportLossWhenDefeated ? p1.some(x => x.hp > 0) : true)),
  };
}

function voidFightFrames(durum = null) {
  SON_ISTATISTIK = null;
  SON_OYUNCU_HASARI = 0;
  const voidStageId = 15102099;
  const snapshot = durum ? JSON.parse(JSON.stringify(durum)) : null;
  if (snapshot && snapshot.bosDunya && snapshot.bosDunya.form.length) {
    snapshot.kadro = Object.fromEntries(snapshot.bosDunya.form.map(hero => [String(hero.heroId),hero.battlePos || hero.pos]));
  }
  const report = kadroRapor(voidStageId, null, null, { scaleEnemy: false, forceWin: false, ...(snapshot ? { playerState: snapshot } : {}) });
  if (!report) throw new Error('Unable to build the player battle report for Void Region');
  const enemies = stageDusmanlari(voidStageId);
  if (!enemies || enemies.birimler.length !== 1 ||
    enemies.birimler[0].id !== require('./savas-etkinlik').voidBossEnemyId()) {
    throw new Error('Void Region copied stage must contain exactly one Ulquiorra');
  }

  return [
    { id: kodek.OP.REPORT, payload: report.payload },
    { id: kodek.OP.RESULT, payload: kodek.encodeSingleResult(report.won, []) },
  ];
}

function fightPetFrames(enemyId, currentHp) {
  SON_ISTATISTIK = null;
  SON_OYUNCU_HASARI = 0;
  const enemy = enemyById.get(Number(enemyId) >>> 0);
  if (!enemy) throw new Error(`FightPet enemy ${enemyId} not found`);
  const hp = Math.max(1, Math.min(Number(enemy.hp) || 1, Number(currentHp) || 1));
  const bossUnit = dusmanBirim({ ...enemy, hp }, 6);
  bossUnit.atk = Math.max(1, Math.round(bossUnit.atk * 1.5));
  bossUnit.damageMultiplier = 100;
  const report = kadroRapor(0, null, {
    ad: enemy.name || 'Evil Spirit',
    birimler: [bossUnit],
  }, {
    scaleEnemy: false,
    forceWin: false,
    reportLossWhenDefeated: true,
  });
  if (!report) throw new Error('Unable to build the player battle report for FightPet');
  return [
    { id: kodek.OP.REPORT, payload: report.payload },
    { id: kodek.OP.RESULT, payload: kodek.encodeSingleResult(report.won, []) },
  ];
}

// Protect Seireitei fights the configured gate, with its persistent remaining HP.
function cityDefendBattle(enemyId,currentHp,playerState) {
  SON_OYUNCU_HASARI=0;SON_ISTATISTIK=null;
  const enemy=enemyById.get(Number(enemyId)>>>0);if(!enemy)throw Error('Unknown CityDefend gate');
  const balance=require('./protect-seireitei-config.json');
  const hp=Math.max(1,Math.min(balance.bossMaxHp,currentHp));
  const unit=dusmanBirim({...enemy,hp},6);
  unit.atk*=balance.attackMultiplier;unit.def*=balance.defenseMultiplier;
  // Gate RoleModel rows only exist up to level 150; use the shared gate model
  // while retaining the actual level and all combat stats from the requested row.
  unit.id=Number(enemyId)<12820000?12810001:12820001;
  unit.hp=unit.maxHp=hp;
  unit.isim=enemy.name;

  const report=kadroRapor(0,null,{ad:enemy.name,birimler:[unit]},{playerState,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
  if(!report)throw Error('Unable to create CityDefend battle');
  return {...report,damage:SON_OYUNCU_HASARI};
}

// ============ SAVAS ODULLERI (EnemyArmy.awardId -> Award) ============
// Yakalanan gercek sonuc paketleri Award tablosuyla BIREBIR tutuyor:
//   stage 15101003 -> army 20101032 -> Award 21101008 fixed [type2:125, type0:266]
//   yakalanan paket: type2 125, type0 266   (15101007 ve 15101011 de ayni sekilde dogrulandi)
// Award.fixed = kesin odul, Award.f1 = {"rewards":[{rate, value:[...]}]} sansli havuz (TAward.as).
// NOT: yakalamalarda ayrica type17/14100279 ("Ice Crystal") vardi; o item hicbir Award kaydinda
// gecmiyor ve aciklamasi "Obtained from stage during event" -> donemsel event drop'u, DB'den
// turetilemez. Uydurmak yerine atlandi.
function stageOdulleri(bpId) {
  const bp = stageById(bpId); if (!bp) return [];
  const out = [];
  const ekle = x => {
    const o = { type: Number(x.type) || 0, code: Number(x.code) || 0, amount: Number(x.amount) || 1 };
    if (o.amount > 0) out.push(o);
  };
  const awardIds = stageArmyIds(bp).map(aid => {
    const army = armyById.get(aid);
    return army ? Number(army.awardId) >>> 0 : 0;
  }).filter(Boolean);
  for (const awardId of awardIds) {
    const w = awardById.get(awardId); if (!w) continue;
    const fx = tryParse(w.fixed);
    for (const x of ((fx && fx.fixed) || [])) ekle(x);
    const rn = tryParse(w.f1);                        // sansli havuz: her grup kendi rate'i ile
    for (const g of ((rn && rn.rewards) || [])) {
      if (rnd() > (Number(g.rate) || 0)) continue;
      for (const x of (g.value || [])) ekle(x);
    }
  }
  return out.slice(0, 16);
}

// fight istegine karsilik gonderilecek frame'ler: [{id,payload}, ...]
// Arena istegi kendi secili botunu, diger savas istekleri ilgili stage dusmanini kurar.
let sonStage = 0;   // GoldFastAutoBattle payload'i sadece [u8] -> en son girilen stage kullanilir
function fightFrames(reqId, payload, durum = null) {
  SON_ISTATISTIK = null;
  const heroChangeFight = (reqId >>> 0) === HERO_CHANGE_FIGHT_REQ;
  const heroChangeStage = heroChangeFight ? heroChangeStageId(payload, durum) : 0;
  if (heroChangeFight && !heroChangeStage) throw new Error('Invalid Hero Change stage for requested hero');
  const voidBoss = (reqId >>> 0) === 0x01818b02;
  const towerChallenge = (reqId >>> 0) === 0x01810a01;
  const hurdleChallenge = (reqId >>> 0) === 0x01810202;
  const hurdleCityId = hurdleChallenge && Buffer.isBuffer(payload) && payload.length >= 4
    ? payload.readUInt32BE(0) >>> 0 : 0;
  const raidersChallenge = hurdleChallenge && isRaidersDailyCity(hurdleCityId);
  const raidersStageId = raidersChallenge ? raidersDailyStageId(payload) : 0;
  if (raidersChallenge && !raidersStageId) throw new Error('Invalid Meru Realm stage payload');
  const towerPve = towerChallenge && payload && payload.length >= 1 && payload.readUInt8(0) === 1;
  const towerStageId = towerPve ? skyTowerStageId(payload) : 0;
  if (towerPve && !towerStageId) throw new Error('Invalid Trial Tower PVE stage payload');
  const bpId = heroChangeFight ? heroChangeStage
    : voidBoss || towerChallenge ? (towerPve ? towerStageId : 0)
    : (raidersChallenge ? raidersStageId : (stageIdCoz(payload, durum) || sonStage));
  const stageBattle = !!stageById(bpId);
  if (bpId && !heroChangeFight) sonStage = bpId;
  const durumArena = (reqId >>> 0) === 0x01811904 ? require('./durum').yukle() : null;
  const arenaRakip = (reqId >>> 0) === 0x01811904
    ? arenaBot.selected(
      payload,
      require('./seviye').anaDurum().lv,
      arenaBot.playerHeroes(durumArena, require('./seviye').anaId())
    )
    : null;
  // 1) Oyuncunun kendi kadrosu varsa ondan uret (Formation savasa yansisin)
  try {
    const worldMapStage = blockById.has(bpId);
    const stageStatScale = worldMapStage ? 1
      : towerPve ? skyTowerStatScale(towerStageId) : 1;
    const r = kadroRapor(bpId, arenaRakip, null, {
      ...(stageBattle ? { reportLossWhenDefeated: true, requireEnemyDefeated: true } : {}),
      scaleEnemy: !stageBattle,
      stageStatScale,
      enemyAttackScale: 1,
    });
    if (r) {
      const odul = arenaRakip || voidBoss || (stageBattle && !r.won) ? [] : stageOdulleri(bpId);
      const heroChangeFragment = heroChangeFight && r.won ? heroChangeFragmentId(payload) : 0;
      if (heroChangeFight && r.won && !heroChangeFragment) {
        throw new Error(`Missing valid Hero Change fragment for hero ${payload.readUInt32BE(0) >>> 0}`);
      }
      if (heroChangeFragment) odul.push({ type: 1, code: heroChangeFragment, amount: 1 });
      if (odul.length) console.log(`[savas] odul: ${odul.map(o => 't' + o.type + ':' + (o.code || '-') + 'x' + o.amount).join(' ')}`);
      return [
        { id: kodek.OP.REPORT, payload: r.payload },
        {
          id: kodek.OP.RESULT,
          payload: kodek.encodeSingleResult(r.won, odul),
          odul,
          won: r.won,
          stageId: bpId,
          heroChangeFragmentId: heroChangeFragment,
        },
      ];
    }
  } catch (e) { console.log('[savas] kadro raporu hatasi:', e.message); }
  if (towerPve) throw new Error(`Unable to build the Trial Tower battle report for stage ${bpId}`);
  if (raidersChallenge) throw new Error(`Unable to build the Meru Realm battle report for stage ${raidersStageId}`);
  if (stageBattle) throw new Error(`Unable to build the stage battle report for stage ${bpId}`);
  if (REPLAYS.length) {
    const pr = REPLAYS[replayIdx % REPLAYS.length]; replayIdx++;
    const frames = [{ id: kodek.OP.REPORT, payload: pr.report }];
    frames.push({ id: kodek.OP.RESULT, payload: voidBoss ? kodek.encodeSingleResult(true, []) : (pr.result || kodek.encodeSingleResult(true, [])) });
    return frames; // gercek rapor + gercek sonuc (garantili dogru)
  }
  // SENTEZ (yakalama yoksa): aninda-kazanan
  return [
    {
      id: kodek.OP.REPORT,
      payload: synthReport(bpId, stageById(bpId) ? 5 * (towerPve ? skyTowerStatScale(towerStageId) : 1) : 1),
    }, // 0x01458000
    { id: kodek.OP.RESULT, payload: kodek.encodeSingleResult(true, []) }, // 0x01458001 win
  ];
}

// ---- OTO-SAVAS (WorldMap_AutoBattle): N turu TEK pakette dondurur ----
// Istek: [u32 cityId][u32 blockPointId][u16 tekrar]  (yakalamada 000a = 10 savas)
// Tek savas raporu yerine AutoBattleInfo gonderilir; client oradaki tur listesini
// sirayla oynatip her turun odulunu gosterir.
const OTO_OPS = new Set([0x01810504]);
function isAutoBattle(reqId) { return OTO_OPS.has(reqId >>> 0); }
function autoBattleFrames(reqId, payload) {
  const bpId = stageIdCoz(payload) || sonStage;
  if (bpId) sonStage = bpId;
  let n = (payload && payload.length >= 10) ? payload.readUInt16BE(8) : 1;
  n = Math.max(1, Math.min(n || 1, 50));
  const turlar = [], toplam = [];
  for (let i = 0; i < n; i++) {
    const o = bpId ? stageOdulleri(bpId) : [];   // sans havuzu her tur yeniden atilir
    turlar.push({ dalgalar: [o], son: [] });
    for (const x of o) toplam.push(x);
  }
  console.log(`[savas] oto-savas: stage ${bpId} x${n} tur, ${toplam.length} odul girdisi`);
  return [{
    id: 0x01180505,
    payload: kodek.encodeAutoBattle({ costTimer: n * 1000, isWorldLevel: 0, turlar }),
    odul: toplam,
  }];
}

// ---- Fight tetikleyen CS opcode kumesi (cs_opcodes.json'dan isimle cozulur) ----
const FIGHT_NAMES = new Set([
  'PACKETID_CS_Enter_Hurdle',
  'PACKETID_CS_BattleStart',
  'PACKETID_CS_Arena_Fight_Req', 'PACKETID_CS_TreasureMap_FightReq',
  'PACKETID_CS_FightPet_FightReq', 'PACKETID_CS_CityDefend_FightReq',
  'PACKETID_CS_TraitorAttack_BattleReq', 'PACKETID_CS_SevenKing_FightReq',
  'PACKETID_CS_SkyTower_AutoBattle_Req', 'PACKETID_CS_SkyTower_Challenge_Req',
  'PACKETID_CS_GongFuFight_FightReq', 'PACKETID_CS_HeroChange_FightReq',
  'PACKETID_CS_VainTravel_BattleReq', 'PACKETID_CS_Related_FightReq',
  'PACKETID_CS_OrgPointMap_AutoFightReq', 'PACKETID_CS_ExpDuplicate_FightReq',
  'PACKETID_CS_KingChallenge_InitFightReq', 'PACKETID_CS_KingChallenge_FightReq',
  'PACKETID_CS_LOBBY_WorldMap_AutoBattle', 'PACKETID_CS_LOBBY_WorldMap_GoldFastAutoBattle',
  'PACKETID_CS_LOBBY_Hurdle_EnterNextLayer',
]);
const FIGHT_OPS = new Set();
try {
  const cs = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'cikarim', 'db', 'cs_opcodes.json'), 'utf8'));
  for (const e of (cs.hepsi || [])) if (FIGHT_NAMES.has(e.ad)) FIGHT_OPS.add(parseInt(e.op, 16) >>> 0);
} catch { }
console.log(`[savas] fight opcode sayisi: ${FIGHT_OPS.size}`);

function isFight(reqId) { return FIGHT_OPS.has(reqId >>> 0); }

function fightAck(reqId, payload) {
  const body = Buffer.isBuffer(payload) ? payload : Buffer.alloc(0);
  if ((reqId >>> 0) === HERO_CHANGE_FIGHT_REQ) {
    if (body.length < 4) return null;
    return Buffer.concat([Buffer.alloc(4), body.subarray(0, 4), Buffer.alloc(4)]);
  }
  if (body.length < 4 || body.length > 32) return null;
  return Buffer.concat([Buffer.alloc(4), body, Buffer.alloc(2)]);
}

module.exports = {
  worldMapLevel, worldMapScale, stageArmyDusmanlari, cityDefendBattle, heroBirim, initiative, vurus, isFight, fightAck, fightFrames, fightPetFrames, sonOyuncuHasari, voidFightFrames,
  isAutoBattle, autoBattleFrames, FIGHT_OPS, synthReport, stageDusmanlari, stageIdCoz,
  instanceStageWon, stageAssessment, stageNextLayer, stageCityType, raidersDailyStageId,
  isRaidersDailyCity, skyTowerStageId, stageOdulleri, kadroRapor, sonIstatistik,
  heroChangeStageId, heroChangeFragmentId, syncHeroChangeInfo, heroChangeInfoPacket, heroChangeAttempt, heroChangeWon,
  heroChangeReset, heroChangeOneKey, HERO, ENEMY,
};
