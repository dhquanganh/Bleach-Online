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
const envanter = require('./envanter');
const heroTalents = require('./hero-talents');
const heroSkills = require('./hero-skills');
const partnerSkills = require('./partner-skills');
const weaponSkills = require('./weapon-skills');
const narutoCombat = require('./naruto-combat');
const jiraiyaCombat = require('./jiraiya-combat');
const obitoCombat = require('./obito-combat');
const painCombat = require('./pain-combat');
const hashCombat = require('./hashirama-combat');
const mechaCombat = require('./mecha-combat');
const itachiCombat = require('./itachi-combat');
const sasukeCombat = require('./sasuke-combat');

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
  if(h&&!require('./retired-heroes').allowed(idNum(h.id)))return false;
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
  // Missing active-skill effects disable that skill in dusmanBirim; they must
  // not remove the enemy from the stage formation shown by the client.
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
  if(!require('./retired-heroes').allowed(id))return null;
  const h = heroById.get(id);
  if (!h) {
    const e = enemyById.get(id);
    if (!e) return null;
    const u = dusmanBirim(e, pos);
    if (localBattleEffects && u.skill && !DOKU.has(u.skill >>> 0)) {
      u.skillEffect = u.normal;
      u.skillId = u.normal;
      u.skillHealsVisually = false;
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
  const skillValid = aktif && eff[String(aktif)] != null && skillSet.has(aktif);
  const skillOk = skillValid && (!localBattleEffects || DOKU.has(aktif >>> 0));
  const ol = k && typeof k === 'object' ? k : (k > 0 ? k : 1);
  let hp, atk, def = 0, anger = 50;
  if (stat) {
    const hpOlcek = typeof ol === 'object' ? ol.life : ol;
    const atkOlcek = typeof ol === 'object' ? ol.genel : ol;
    def = Math.max(0, Math.round(stat.def * atkOlcek));
    hp = Math.max(1, Math.round(stat.hp * hpOlcek));
    atk = Math.max(1, Math.round(stat.atk * atkOlcek));
    anger = stat.anger == null ? 50 : stat.anger;
  } else {
    const growth = require('./seviye').buyumeTemeli(id, lv);
    if (!growth) return null;
    hp = Math.max(600, Math.round(growth.life * 6));
    atk = Math.max(20, Math.round(growth.combat * 0.6));
  }
  const talent = heroTalents.effect(id);
  const rates = stat || heroTalents.rates(id);
  if (!stat) {
    const growth = require('./seviye').buyumeTemeli(id, lv);
    const combat = Math.max(growth.power * (1 + (talent.power || 0)), growth.agile * (1 + (talent.agile || 0)), growth.intelligence * (1 + (talent.intelligence || 0)));
    atk = Math.max(1, Math.round(atk * (combat / growth.combat) * (1 + (talent.attack || 0))));
    hp = Math.max(1, Math.round(hp * (1 + (talent.life || 0)) * (1 + (talent.hp || 0))));
    def = Math.round(def * (1 + (talent.defense || 0)));
  }
  return {
    camp: 0, pos, id, hp, maxHp: hp, anger, atk, def,
    profession: Number(h.profession), sex: Number(h.sex),
    ...Object.fromEntries(['hitRate','dodgeRate','critRate','blockRate','punchRate','helpRate','wreckRate','antiknockRate'].map(field => [field, rates[field]])),
    damageBonus: stat ? stat.damageBonus : rates.hurtRate,
    damageReduction: stat ? stat.damageReduction : rates.avoidHurtRate,
    magicAtk: stat && stat.magicAtk != null ? Math.max(0,Math.round(stat.magicAtk * (typeof ol==='object'?ol.genel:ol))) : atk,
    recoverRate: stat ? stat.recoverRate : rates.recoverRate,
    controlRate: stat ? stat.controlRate : 0, controlResist: stat ? stat.controlResist : 0,
    furyEffect: stat ? stat.furyEffect : 0, furyResist: stat ? stat.furyResist : 0,
    speed: stat ? stat.speed : Math.max(0, ((Number(h.speed) || 0) + (Number(h.speedGrow) || 0) * Math.max(0, lv - 1)) * (1 + (talent.speed || 0))),
    buff: skillValid ? skillBuff(aktif) : null,
    normal, skill: skillValid ? aktif : 0, skillEffect: skillOk ? aktif : normal,
    skillHealsVisually: !!(skillOk && JSON.stringify(eff[String(aktif)]).includes('"friendhp"')),
    skillId: localBattleEffects ? (skillOk ? aktif : normal) : (aktif || normal),
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
  const rates = tryParse(e.rates) || {};
  const hp = Math.max(200, Number(e.hp) || 500);
  const guc = Math.max(Number(a.strength) || 0, Number(a.agility) || 0, Number(a.intellect) || 0);
  return {
    camp: 1, pos, id: idNum(e.id), hp, maxHp: hp, anger: e.anger == null ? 50 : (Number(e.anger) || 0),
    profession: Number(e.profession), sex: Number(e.sex),
    hitRate: rates.hit == null ? 1 : Number(rates.hit), dodgeRate: Number(rates.dodgy) || 0,
    critRate: Number(rates.fatal) || 0, blockRate: Number(rates.block) || 0,
    punchRate: Number(rates.joint) || 0, helpRate: Number(rates.recourse) || 0,
    damageReduction: Number(rates.avoidhurtrate) || 0,
    damageMultiplier: rates.hurt == null ? 1 : Number(rates.hurt),
    recoverRate: Number(rates.recover) || 0,
    speed: Math.max(0, Number(e.speed) || 0),
    atk: Math.max(5, Math.round(guc * 0.45)),
    def: Math.max(Number(d.strength) || 0, Number(d.agility) || 0, Number(d.intellect) || 0),
    buff: skillOk ? skillBuff(skill) : null,
    normal, skill: skillOk ? skill : 0, skillId: skill || normal,
    skillHealsVisually: !!(skillOk && JSON.stringify(eff[String(skill)]).includes('"friendhp"')),
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
      let stageId = savedStage || (Number(campaign.startId) >>> 0);
      // Flash keeps one LayerIndex per city when switching Easy/Hard.
      const selectedId = Number(durum && durum.instanceCampaign && durum.instanceCampaign[cityId]);
      const selected = singleById.get(selectedId);
      const selectedStage = Number(durum && durum.instanceProgress && durum.instanceProgress[`${cityId}:${selectedId}`]);
      if (selected && selectedId !== bpId && selectedStage &&
        selectedId >= Number(city.start) && selectedId <= Number(city.last)) {
        stageId = Number(campaign.startId) + selectedStage - Number(selected.startId);
      }
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
  const current = stageIdCoz(payload, durum);
  if (stageId !== current) return false;
  durum.instanceProgress[key] = stageId + 1;
  if (stageId === Number(campaign.endId)) {
    durum.instanceStars = durum.instanceStars || {};
    durum.instanceStars[campaignId] = 3;
  }
  durum.instanceCampaign = durum.instanceCampaign || {};
  durum.instanceCampaign[cityId] = campaignId;
  return true;
}
function stageAssessment(payload, won, resolvedStageId = 0) {
  if (!won || !Buffer.isBuffer(payload) || payload.length < 8) return null;
  const cityId = payload.readUInt32BE(0) >>> 0;
  const stageId = resolvedStageId || stageIdCoz(payload);
  const city = cityById.get(cityId);
  if (!stageId || !city || ![1, 2].includes(Number(city.type))) return null;
  let assessmentId = stageId;
  if (Number(city.type) === 2) {
    const campaign = Single.find(row => idNum(row.id) >= Number(city.start) && idNum(row.id) <= Number(city.last) && stageId >= Number(row.startId) && stageId <= Number(row.endId));
    if (!campaign || stageId !== Number(campaign.endId)) return null;
    // Flash resolves this ID through Single, not SinglePointPath, to open
    // the completion/chest window and unlock the next difficulty/map.
    assessmentId = idNum(campaign.id);
  }
  const body = Buffer.alloc(13);
  body.writeUInt32BE(0, 0);
  body.writeUInt32BE(cityId, 4);
  body.writeUInt32BE(assessmentId, 8);
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
  if (!campaign || stageId === Number(campaign.endId)) return null;
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
  curHealth: u.hp, totalHealth: u.maxHp, curAnger: u.anger, skillId: u.skillId,
  name: u.isim || '', rebirthNum: (u.rebirth || {}).n || 0,
});

// Tek bir vurus (active) uret + HP/ofkeyi guncelle
function validSkillTargets(u, opponents) {
  if (!u.strictSkillTargets) return true;
  const plan = heroSkills.get(u.skill);
  return !plan || plan.healOnly || heroSkills.select(opponents, plan.target, () => 0, false).length > 0;
}
function vurus(u, hedef, bitir, opponents = [hedef], random = Math.random, extra = false, allies = [u], attackSpec = null) {
  const rebirth = require('./reincarnation');
  const talent = heroTalents.effect(u.id);
  let skillAt = attackSpec ? attackSpec.activeType === kodek.ACTIVE.SKILL : !extra && !!u.skill && !u.barrierMysteryBlocked && !heroSkills.status(u,'silence') && !heroSkills.status(u,'chaos') && (u.anger >= 100 || talent.normalSkill);
  if (!attackSpec && skillAt && !validSkillTargets(u, opponents)) skillAt = false;
  if(!attackSpec&&skillAt&&u.painContext){
    const ctx=u.painContext,cost=painCombat.mysteryCost(ctx,u,{});
    if(!hashCombat.canMystery(ctx,u)||!painCombat.canMystery(ctx,u,{})||ctx.chakra[u.camp]<cost)skillAt=false;
    else{ctx.chakra[u.camp]-=cost;painCombat.spendMystery(ctx,u,{});}
  }
  const painCostRecords=(attackSpec ? attackSpec.id===narutoCombat.standard(u,allies)?.id : !skillAt) ? painCombat.beforeStandard(u) : [];
  const plan = !attackSpec && skillAt ? heroSkills.get(u.skill) : null;
  const eff = attackSpec ? attackSpec.id : skillAt ? (u.skillEffect || u.skill) : u.normal;
  const targets = [{ cmd: kodek.CMD.NONE, targetCamp: u.camp, targetPos: u.pos, reportTargetStatus: 0, result: {} }];
  const reactions = [];
  const appendHit = (list, victim, result, status) => {
    list.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:status>>>0,result:{hurtHp:result.damage,hurtAnger:0}});
    if (result.recovered) list.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:-result.recovered,hurtAnger:0}});
    if (result.clearShield || result.absorbed) list.push({cmd:kodek.CMD.SHIELD,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:victim.shield||0}});
    if (result.clearBuffs) heroSkills.remove(victim,false,list);
  };
  const aoe = !skillAt && rebirth.proc(u, 4, random);
  const selected = heroTalents.selectTargets(u, opponents);
  const victims = attackSpec ? (attackSpec.summon || attackSpec.support ? [] : itachiCombat.targets(u.itachiContext||{random},u,attackSpec,hedef,opponents) || mechaCombat.targets(u.mechaContext||{random},attackSpec,hedef,opponents) || hashCombat.targets(u.hashContext||{random},attackSpec,hedef,opponents) || painCombat.targetList(attackSpec,hedef,opponents) || obitoCombat.targets(attackSpec,hedef,opponents) || (attackSpec.target === 'all' ? opponents.filter(target=>target.hp>0) : typeof attackSpec.target === 'number' ? [hedef,...opponents.filter(target=>target!==hedef&&target.hp>0)].slice(0,attackSpec.target) : [hedef])) : plan && plan.healOnly ? [] : plan ? heroSkills.select(opponents,plan.target,random,!u.strictSkillTargets)
    : aoe ? opponents.filter(target => target.hp > 0) : talent.highestAttackTargets && !skillAt ? selected : [hedef];
  mechaCombat.beforeAttack(u,attackSpec,targets);
  const hitTargets = [];
  // Spend rage before restoration: Urahara/Unohana recover it after casting.
  const rageRecords = [];
  if (!attackSpec) heroSkills.changeFury(u,extra ? 0 : skillAt ? (talent.normalSkill && u.anger < 100 ? 0 : -100) : 50,rageRecords);
  const triple = rebirth.proc(u, 2, random);
  const ignoreDefense = rebirth.proc(u, 5, random);
  // Offensive scaling is independent of the defense/resistance used by the move.
  const castAttack = attackSpec && attackSpec.attackStat === 'atk' ? heroSkills.value(u,'atk') : attackSpec && attackSpec.damageType === 'mixed' ? (heroSkills.value(u,'atk') + heroSkills.value(u,'magicAtk')) / 2 : attackSpec && attackSpec.damageType === 'ninjutsu' ? heroSkills.value(u,'magicAtk') : heroSkills.value(u,'atk');
  let painPrimaryDamage=0;
  for (const victim of victims) {
    if(victim.mechaContext)mechaCombat.onAttacked(victim.mechaContext,victim);
    const bypass=attackSpec&&attackSpec.ignoreDefensiveSkills;
    const guaranteed=attackSpec?.unavoidable || skillAt&&painCombat.active(u,'painUnavoidableUntil')&&painCombat.isRinnegan(u);
    const painTechniqueCredited=painCombat.isPain(victim)&&victim.hp>0;
    if(painTechniqueCredited){const notices=[];painCombat.points(victim,victim.painFinal?1:.5,notices);reactions.push(painCombat.passive(victim,notices));}
    const kamuiProtected=!bypass&&obitoCombat.fatalLimit(victim,!skillAt);
    if(!bypass&&!guaranteed&&(itachiCombat.evade(victim.itachiContext,victim,attackSpec,random)||mechaCombat.evade(victim.mechaContext||{round:victim.battleRound,mechaTriggers:[]},victim,attackSpec,random)||obitoCombat.evade(victim,random))){
      const notice=[];if(!mechaCombat.isMecha(victim))obitoCombat.label(notice,victim,11);reactions.push(obitoCombat.passive(victim,notice));
      targets.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.TARGET_EFFECT>>>0,result:{hurtHp:0,hurtAnger:0}});
      continue;
    }
    const chance = value => Math.max(0, Math.min(1, Number(value) || 0));
    const hitChance = chance((u.hitRate == null ? 1 : heroSkills.value(u,'hitRate')) - heroSkills.value(victim,'dodgeRate'));
    if (!bitir && !guaranteed && !talent.guaranteedHit && hitChance < 1 && random() >= hitChance) {
      itachiCombat.evaded(victim);
      targets.push({cmd:kodek.CMD.ATTACK,targetCamp:victim.camp,targetPos:victim.pos,reportTargetStatus:ST.TARGET_EFFECT>>>0,result:{hurtHp:0,hurtAnger:0}});
      continue;
    }
    hitTargets.push(victim);
    const resistance=(victim.resistance == null ? heroSkills.value(victim,'def') : heroSkills.value(victim,'resistance'))*Math.max(0,1-.1*(victim.jiraiyaResistanceStacks||0));
    const attack = castAttack, defense = (attackSpec && attackSpec.damageType === 'mixed' ? (heroSkills.value(victim,'def') + resistance) / 2 : attackSpec && attackSpec.damageType === 'ninjutsu' ? resistance : heroSkills.value(victim,'def')) * (1-Math.max(0,Math.min(1,heroSkills.value(u,'ignoreDefense'))));
    let dmg = Math.round(attack * (attackSpec ? attackSpec.multiplier : skillAt ? (plan ? plan.multiplier : 1.8) : (talent.normalMultiplier || 1)) * (0.92 + random() * 0.16) * (triple ? 3 : 1));
    if(attackSpec&&attackSpec.superArmorBonus&&(heroSkills.armor(victim)||(painCombat.isPain(victim)&&victim.painFinal)))dmg=Math.round(dmg*(1+attackSpec.superArmorBonus));
    if (victim.cloneOwner && (attackSpec && attackSpec.element || u.element) === 'lightning') dmg = Math.round(dmg * (1 - narutoCombat.config.cloneLightningReduction));
    const critical = hashCombat.active(u,'hashSealUntil') || !((victim.rebirth || {}).n > 0 && (victim.rebirth || {}).ae === 9) && random() < chance(heroSkills.value(u,'critRate')+(attackSpec?.critBonus||0));
    if (critical) dmg = Math.round(dmg * Math.max(0,1.5+(hashCombat.active(u,'hashSealUntil')?0:heroSkills.value(u,'critDamage'))));
    const breakDefense = chance(heroSkills.value(u,'wreckRate')) > 0 && random() < chance(heroSkills.value(u,'wreckRate'));
    if (defense > 0 && !ignoreDefense && !breakDefense) dmg = Math.round(dmg * attack / Math.max(1,attack + defense*(1-chance(attackSpec&&attackSpec.ignoreDefense))));
    const blocked = !bypass && chance(heroSkills.value(victim,'blockRate')) > 0 && random() < chance(heroSkills.value(victim,'blockRate'));
    if (blocked) dmg = Math.round(dmg * .5);
    dmg = Math.max(1, dmg);
    if (bitir) dmg = Math.max(dmg, victim.hp);
    dmg = Math.max(0, Math.round(dmg * Math.max(0, 1 + heroSkills.value(u,'damageBonus')) * (1 - chance(heroSkills.value(victim,'damageReduction'))) * Math.max(0,1+heroSkills.value(victim,'vulnerability')) * weaponSkills.damageMultiplier(u,victim) * (u.damageMultiplier == null ? 1 : Math.max(0, u.damageMultiplier))));
    if(attackSpec?.mechaSweep)dmg=Math.round(dmg*(attackSpec.mechaSplashWeights?.get(victim)||1));
    if(attackSpec?.hashGolem)dmg=Math.round(dmg*(attackSpec.hashSplashWeights?.get(victim)||1));
    if(attackSpec?.painChase){if(victim===hedef)painPrimaryDamage=dmg;else dmg=Math.round(painPrimaryDamage*.3);}
    if (hashCombat.fireImmune(victim,attackSpec,u) || !bypass&&(heroSkills.status(victim,'invincible') || !skillAt && heroSkills.status(victim,'void'))) dmg = 0;
    if (u.maxHitDamage) dmg = Math.min(u.maxHitDamage, dmg);
    // Local aid rule: a living ally with Help rate intercepts half a normal hit.
    // Both HP changes are transmitted, so rendered HP and server HP stay equal.
    const helper = !bypass && !skillAt && !extra && !bitir && opponents.find(other => other !== victim && !victims.includes(other) && other.camp === victim.camp && other.hp > 0 && !heroSkills.status(other,'invincible') && chance(heroSkills.value(other,'helpRate')) > 0 && random() < chance(heroSkills.value(other,'helpRate')));
    if (helper) {
      const shared = Math.floor(dmg / 2); dmg -= shared;
      const aided = rebirth.hit(u, helper, Math.round(shared * (1 - chance(heroSkills.value(helper,'damageReduction')))), random);
      if(u.hashContext){const notices=[],events=[];hashCombat.onDamage(u.hashContext,u,helper,aided,attackSpec,notices,events);if(notices.length)reactions.push(hashCombat.passive(helper,notices));reactions.push(...events);}
      appendHit(targets,helper,aided,ST.TARGET_EFFECT | ST.HIT | ST.HELP | (helper.hp<=0?ST.DIED:0));
    }
    const immune = hashCombat.fireImmune(victim,attackSpec,u) || !bypass&&(heroSkills.status(victim,'invincible') || !skillAt && heroSkills.status(victim,'void'));
    if(kamuiProtected&&dmg>=victim.hp){const notice=[];obitoCombat.label(notice,victim,12);reactions.push(obitoCombat.passive(victim,notice));}
    if(kamuiProtected)dmg=Math.min(dmg,Math.max(0,victim.hp-1));
    if(victim.sasukeContext&&!bypass&&!immune)dmg=sasukeCombat.beforeDamage(victim.sasukeContext,u,victim,attackSpec||{prompt:skillAt},dmg);
    if(victim.itachiContext&&!bypass&&!immune)dmg=itachiCombat.beforeDamage(victim.itachiContext,u,victim,attackSpec||{prompt:skillAt},dmg);
    const result = immune ? {damage:0} : rebirth.hit(u, victim, dmg, random,bypass,kamuiProtected);
    if(u.sasukeContext)sasukeCombat.onDamage(u.sasukeContext,u,victim,result.damage,critical);
    if(u.itachiContext){const notices=[];itachiCombat.onDamage(u.itachiContext,u,victim,result,attackSpec,notices,critical);if(notices.length)reactions.push(painCombat.passive(u,notices));}
    const status = (ST.TARGET_EFFECT | ST.HIT | (critical ? ST.CRIT : 0) | (blocked ? ST.BLOCK : 0) | (victim.hp <= 0 ? ST.DIED : 0)) >>> 0;
    appendHit(targets,victim,result,status);
    if(u.painContext){const notices=[];painCombat.onHit(u.painContext,u,victim,{...result,painTechniqueCredited},critical,notices);if(notices.length)reactions.push(painCombat.passive(u,notices));}
    if(u.hashContext){const notices=[],events=[];hashCombat.onDamage(u.hashContext,u,victim,result,attackSpec,notices,events);mechaCombat.onDamage(u.hashContext,u,victim,result,attackSpec,notices);if(notices.length)reactions.push(hashCombat.passive(victim,notices));reactions.push(...events);}
    const passiveRecords = [];
    partnerSkills.trigger('hpLoss',victim,opponents,allies,[u],passiveRecords,random);
    if (victim.hp > 0 && !immune) partnerSkills.trigger('hit',victim,opponents,allies,[u],passiveRecords,random);
    if (passiveRecords.length) reactions.push({activeCamp:victim.camp,activePos:victim.pos,skillEffectId:0,activeType:4,targets:passiveRecords});
    if (heroSkills.status(victim,'freeze') && result.damage > 0) heroSkills.removeField(victim,'freeze',targets);
    reactions.push(...obitoCombat.checkRage(victim));
    if (!bypass && heroSkills.status(victim,'reflect') && result.damage > 0 && u.hp > 0) {
      let reflected = Math.min(u.hp,result.damage);
      u.hp -= reflected;
      if(u.hashContext){const notices=[],events=[];hashCombat.onDamage(u.hashContext,victim,u,{damage:reflected},null,notices,events);if(notices.length)reactions.push(hashCombat.passive(u,notices));reactions.push(...events);}
      targets.push(heroSkills.hpRecord(u,reflected,false));
    }
    if (blocked && victim.hp > 0) {
      // TBattleStage resolves every BLOCK flag through an Active_Block record.
      // Omitting it interrupts command construction for the rest of the attack.
      let counterDamage = 0;
      const counterTargets = [];
      if (!extra && u.hp > 0 && random() < chance(heroSkills.value(victim,'antiknockRate'))) {
        const counterAtk=heroSkills.value(victim,'atk');
        const amount = heroSkills.status(u,'invincible') ? 0 : Math.max(0, Math.round(counterAtk * counterAtk / Math.max(1,counterAtk + heroSkills.value(u,'def')) * Math.max(0,1 + heroSkills.value(victim,'damageBonus')) * (1 - chance(heroSkills.value(u,'damageReduction')))));
        const counterResult = heroSkills.status(u,'invincible') ? {damage:0} : rebirth.hit(victim,u,amount,random);
        counterDamage = counterResult.damage;
        if(u.hashContext){const notices=[],events=[];hashCombat.onDamage(u.hashContext,victim,u,counterResult,null,notices,events);if(notices.length)reactions.push(hashCombat.passive(u,notices));reactions.push(...events);}
        appendHit(counterTargets,u,counterResult,ST.HIT | (u.hp<=0?ST.DIED:0));
        victim.verdi = (victim.verdi || 0) + counterDamage;
      }
      if (!counterTargets.length) counterTargets.push({cmd:kodek.CMD.ATTACK,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:0,hurtAnger:0}});
      // Native TBattleStage passes two references to the original attacker for a
      // block reaction. Match that two-slot result vector, even when the block
      // deals no counter damage, or TRole indexes past the result vector (#1125).
      if(counterTargets.length===1)counterTargets.push({cmd:kodek.CMD.ATTACK,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:0,hurtAnger:0}});
      reactions.push({activeCamp:victim.camp,activePos:victim.pos,skillEffectId:victim.normal,activeType:3,targets:counterTargets});
    }
  }
  targets.push(...rageRecords);
  if (plan) {
    const effectRecords = [];
    heroSkills.apply(plan,u,allies,opponents,hitTargets,effectRecords,random);
    const mainHeals = plan.healOnly && u.skillHealsVisually!==false ? effectRecords.filter(record=>record.cmd===kodek.CMD.ATTACK && record.result.hurtHp<0) : [];
    targets.push(...mainHeals);
    const immediate = effectRecords.filter(record=>!mainHeals.includes(record));
    if(immediate.length)reactions.push({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:immediate});
  }
  const attackPassive = [];
  if(u.hp>0)partnerSkills.trigger('attack',u,allies,opponents,hitTargets,attackPassive,random);
  const outgoingDamage=targets.filter(record=>record.targetCamp!==u.camp).reduce((sum,record)=>sum+Math.max(0,Number(record.result.hurtHp)||0),0);
  weaponSkills.after(u,allies,opponents,hitTargets,outgoingDamage,attackPassive,random);
  if(attackPassive.length)reactions.push({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:attackPassive});
  if (!attackSpec && skillAt && !plan && u.buff && u.buff.id > 0) targets.push({
    cmd:kodek.CMD.ATTRBUFF,targetCamp:u.buff.kendine?u.camp:hedef.camp,targetPos:u.buff.kendine?u.pos:hedef.pos,
    reportTargetStatus:ST.HIT>>>0,result:{buffId:u.buff.id,buffTurn:u.buff.tur}
  });
  if (!extra && rebirth.proc(u,10,random)) {
    const alive = opponents.filter(target => target.hp > 0);
    if (alive.length >= 2) {
      const first=alive[0],second=alive[1],oldFirst=first.pos,oldSecond=second.pos;
      targets.push({cmd:kodek.CMD.POSITION,targetCamp:first.camp,targetPos:oldFirst,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:oldSecond}});
      targets.push({cmd:kodek.CMD.POSITION,targetCamp:second.camp,targetPos:oldSecond,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:oldFirst}});
      first.pos=oldSecond;second.pos=oldFirst;
    }
  }
  // Rasen Shuriken applies reflected damage after its animation completes.
  // Killing the caster inside its own impact effect sets FIsDie before Flash
  // can invoke the skill completion callback, permanently stopping the report.
  if (attackSpec && (attackSpec.id === narutoCombat.config.mystery.id || obitoCombat.isObito(u) || painCombat.isPain(u) || hashCombat.isHash(u) || mechaCombat.isMecha(u) || itachiCombat.isItachi(u) || sasukeCombat.isSasuke(u))) {
    const reflected=targets.filter(row=>row.cmd===kodek.CMD.ATTACK&&row.targetCamp===u.camp&&row.targetPos===u.pos&&row.result.hurtHp>0);
    if(reflected.length){
      for(const row of reflected)targets.splice(targets.indexOf(row),1);
      reactions.unshift({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:reflected});
    }
  }
  return {activeCamp:u.camp,activePos:u.pos,skillEffectId:eff,activeType:attackSpec?attackSpec.activeType:extra?kodek.ACTIVE.NORMAL_EX:skillAt?kodek.ACTIVE.SKILL:kodek.ACTIVE.NORMAL,targets,reactions,comboTarget:victims[0],beforeFrames:painCostRecords.length?[painCombat.passive(u,painCostRecords)]:[]};
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
  return units.slice().sort((a,b) => heroSkills.value(b,'speed') - heroSkills.value(a,'speed') || a.camp-b.camp || a.pos-b.pos);
}

function playerTeam(options = {}) {
  const ana = anaHero(); if (!ana || !ana.id) return [];
  let kadro = {}, nick = '', durumK = {};
  try { const d = options.playerState || require('./durum').yukle() || {}; durumK = d; kadro = d.kadro || {}; nick = d.nick || ''; } catch (e) { }
  let lv = 99; try { lv = Number(JSON.parse(fs.readFileSync(require('./runtime-path')('veri.json'), 'utf8')).level) || 99; } catch (e) { }
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
  if (!bas) return [];
  p1.push(bas);
  const selectedSkill = require('./beceri').ana(durumK);
  const selectedRow = SkillConfig.find(row=>idNum(row.id)===selectedSkill);
  if (selectedRow && heroSkills.get(selectedSkill)) {
    const animationId = Number(selectedRow.skillId) || selectedSkill;
    const effects = tryParse((heroById.get(ana.id)||{}).attackEffect) || {};
    bas.skill=selectedSkill; bas.skillId=selectedSkill;
    bas.skillEffect=effects[String(animationId)]!=null?animationId:bas.normal;
  }
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
    if (!statPaketleri.has(unit.id >>> 0)) {
      unit.damageBonus = (unit.damageBonus || 0) + (bonus[18] || 0);
      unit.damageReduction = (unit.damageReduction || 0) + (bonus[19] || 0);
    }
  }
  for (const unit of p1) {
    unit.partnerSkills = partnerSkills.unlocked(durumK, unit.id);
    unit.weaponSkills = weaponSkills.equipped(durumK, unit.id);
  }
  return p1;
}

function kadroRapor(bpId, arenaRakip, enemyOverride, options = {}) {
  SON_OYUNCU_HASARI = 0;
  const durumK = options.playerState || require('./durum').yukle() || {};
  const p1 = playerTeam(options);
  if (!p1.length) return null;
  if(options.playerStatBoost && ['atk','def','maxHp'].includes(options.playerStatBoost.field)) {
    const field=options.playerStatBoost.field,factor=1+Math.max(0,Number(options.playerStatBoost.percent)||0)/100;
    for(const unit of p1){unit[field]=Math.min(1000000000,Math.round(unit[field]*factor));if(field==='maxHp')unit.hp=unit.maxHp;}
  }
  // Event bots use their own levels and formations through the same combat engine.
  if (options.playerUnits) p1.splice(0, p1.length, ...options.playerUnits);
  if (options.maxHitDamage) for (const unit of p1) unit.maxHitDamage = options.maxHitDamage;
  // Arena botu varsa onun gercek kahraman kadrosunu, diger savaslarda stage dusmanlarini kullan.
  // Stage kadrosu bulunmayan diger modlarda varsayilan dusmana dusulur.
  const st = enemyOverride || (!arenaRakip && bpId ? stageDusmanlari(bpId) : null);
  const p2 = arenaRakip && arenaRakip.units
    ? arenaRakip.units.map(unit => ({ ...unit, camp: 1 }))
    : arenaRakip
    ? arenaRakip.heroes.map((id, i) => {
      const pos = Array.isArray(arenaRakip.positions) ? arenaRakip.positions[i] : [1, 6, 11][i];
      const u = heroBirim(id, pos, arenaRakip.baseLevel || arenaRakip.level, null, null, 0, true);
      if (!u) return null;
      u.camp = 1;
      return u;
    }).filter(Boolean)
    : (st && st.birimler.length) ? st.birimler : [dusmanBirim(ENEMY, 6)];
  if (st) console.log(`[savas] stage ${bpId} "${st.ad}" -> ${p2.length} dusman: ${p2.map(u => u.id + '@pos' + u.pos).join(', ')}`);
  if (arenaRakip) console.log(`[arena] ${arenaRakip.name} lv${arenaRakip.level} -> ${p2.length} hero${arenaRakip.units ? ' (saved account)' : ', power x' + arenaRakip.power}`);

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
  for (const unit of p1.concat(p2)) unit.strictSkillTargets = !!options.strictSkillTargets;
  narutoCombat.prepareClones([p1,p2]);
  const chaseContext = narutoCombat.create([p1,p2], {random:options.random});
  // roller simulasyondan ONCE (curHealth = baslangic HP'si)
  const roles1 = p1.map(rolBilgisi), roles2 = p2.map(rolBilgisi);
  const initialActives = [];
  for (const unit of p1.concat(p2)) {
    unit.pvp = !!arenaRakip;
    if (!unit.partnerSkills) unit.partnerSkills = unit.camp === 0 ? partnerSkills.unlocked(durumK,unit.id) : [];
    if (!unit.weaponSkills) unit.weaponSkills = unit.camp === 0 ? weaponSkills.equipped(durumK,unit.id) : [];
    const records = [];
    partnerSkills.trigger('start',unit,unit.camp===0?p1:p2,unit.camp===0?p2:p1,[],records);
    partnerSkills.trigger('hpLoss',unit,unit.camp===0?p1:p2,unit.camp===0?p2:p1,[],records);
    weaponSkills.start(unit,records);
    initialActives.push(...heroSkills.eventFrames(unit,records));
  }
  for (const [team, roles] of [[p1,roles1],[p2,roles2]]) team.forEach((unit,index)=>{
    roles[index].curHealth=unit.hp; roles[index].totalHealth=unit.maxHp;
  });
  const deathTriggered = new Set(p1.concat(p2).filter(unit=>unit.hp<=0));
  const appendDeaths = actives => {
    for(const revival of painCombat.revivals(chaseContext)){
      deathTriggered.delete(revival.unit);
      actives.push(painCombat.passive(revival.unit,revival.records),painCombat.visual(revival.unit,revival.animation));
      if(revival.move){
        const opponents=chaseContext.teams[1-revival.unit.camp],target=opponents.find(v=>v.hp>0&&!v.auxiliary);
        if(target)perform(revival.unit,target,opponents,chaseContext.teams[revival.unit.camp],actives,revival.move);
      }
    }
    jiraiyaCombat.noteDeaths(chaseContext);
    let unit;
    while ((unit=p1.concat(p2).find(other=>other.hp<=0&&!deathTriggered.has(other)))) {
      deathTriggered.add(unit);
      const records=[];
      partnerSkills.trigger('death',unit,unit.camp===0?p1:p2,unit.camp===0?p2:p1,[],records);
      if(records.length)actives.push({activeCamp:unit.camp,activePos:unit.pos,skillEffectId:0,activeType:5,targets:records});
    }
    for(const survivor of p1.concat(p2))actives.push(...obitoCombat.checkRage(survivor));
  };
  const turns = [];
  let performDepth=0,reactiveEnabled=false,drainingMysteries=false;
  const perform = (u,target,opponents,allies,actives,spec=null,bitir=false,prepared=false) => {
    itachiCombat.beforeAction(chaseContext,u);
    sasukeCombat.beforeAction(chaseContext,u,spec);
    performDepth++;
    const random=options.random || Math.random;
    const strike=(actor,victim,move,isChase=false)=> {
      const beforeFrames=[];
      move=obitoCombat.prepareMove(chaseContext,actor,victim,move);
      move=painCombat.prepareMove(chaseContext,actor,move);
      move=hashCombat.prepareMove(chaseContext,actor,move);
      move=mechaCombat.prepareMove(chaseContext,actor,victim,move);
      move=sasukeCombat.prepareMove(actor,move);
      if(move&&move.obitoBefore)beforeFrames.push(...move.obitoBefore);
      const frame=vurus(actor,victim,bitir,opponents,random,isChase,allies,move ? narutoCombat.attackSpec(move,isChase) : null);
      frame.beforeFrames=[...beforeFrames,...(frame.beforeFrames||[])];
      if(move){
        const hit=opponents.filter(v=>frame.targets.some(r=>r.cmd===kodek.CMD.ATTACK&&r.targetCamp===v.camp&&r.targetPos===v.pos&&(r.reportTargetStatus&ST.HIT)));
        jiraiyaCombat.afterHit(chaseContext,actor,hit,move,frame.targets);
        obitoCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        painCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        hashCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        mechaCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        itachiCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        sasukeCombat.afterHit(chaseContext,actor,victim,hit,move,frame);
        itachiCombat.cleanse(chaseContext);
      }
      actor.verdi=(actor.verdi||0)+frame.targets.filter(row=>row.targetCamp!==actor.camp).reduce((sum,row)=>sum+Math.max(0,Number(row.result.hurtHp)||0),0);
      return frame;
    };
    const frame=strike(u,target,spec);
    if(chaseContext.barrierExpired){jiraiyaCombat.label(frame.targets,u,9);chaseContext.barrierExpired=false;}
    if(spec && spec.summon) {
      const records=narutoCombat.summon(u,allies);
      if(records.length) frame.reactions.push({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:records});
    }
    actives.push(...frame.beforeFrames,frame,...frame.reactions);
    actives.push(...narutoCombat.resolve(chaseContext,u,frame.comboTarget||target,frame,spec,(actor,victim,move)=>strike(actor,victim,move,true)));
    const isMystery=spec?spec.prompt:frame.activeType===kodek.ACTIVE.SKILL;
    const additional=isMystery?jiraiyaCombat.mysteryUsed(chaseContext,u,spec||{}):null;
    appendDeaths(actives);
    for(const request of sasukeCombat.triggers(chaseContext)){
      const enemies=chaseContext.teams[1-request.unit.camp],victim=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(victim&&performDepth<24)perform(request.unit,victim,enemies,chaseContext.teams[request.unit.camp],actives,request.move);
    }
    for(const request of itachiCombat.triggers(chaseContext)){
      if(request.visual){actives.push(painCombat.visual(request.unit,request.move));continue;}
      const enemies=chaseContext.teams[1-request.unit.camp],victim=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(victim&&performDepth<24)perform(request.unit,victim,enemies,chaseContext.teams[request.unit.camp],actives,{...request.move,activeType:kodek.ACTIVE.NORMAL_EX});
    }
    for(const request of mechaCombat.triggers(chaseContext)){
      const enemies=chaseContext.teams[1-request.unit.camp],victim=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(victim){actives.push(painCombat.visual(request.unit,mechaCombat.config.jet));perform(request.unit,victim,enemies,chaseContext.teams[request.unit.camp],actives,request.move);}
    }
    const mechaBomb=mechaCombat.additional(u,spec);
    if(mechaBomb&&opponents.some(v=>v.hp>0))perform(u,opponents.find(v=>v.hp>0),opponents,allies,actives,mechaBomb);
    const woodGolem=hashCombat.additional(chaseContext,u,spec);
    if(woodGolem&&opponents.some(v=>v.hp>0))perform(u,opponents.find(v=>v.hp>0),opponents,allies,actives,woodGolem);
    if(isMystery){
      if(additional){jiraiyaCombat.label(frame.targets,u,1,2);perform(u,target,opponents,allies,actives,additional);}
      const revived=jiraiyaCombat.revivals(chaseContext);
      if(revived.length){
        actives.push({activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:revived.map(r=>r.record)});
        for(const {unit} of revived){deathTriggered.delete(unit);const records=[];jiraiyaCombat.label(records,unit,7,30);actives.push(jiraiyaCombat.visual(unit,jiraiyaCombat.config.revival,records));}
      }
    }
    // Finish the entire hit/chase/revival chain before selecting a newly unlocked Mystery.
    if(--performDepth===0)drainReactiveMysteries(actives);
    return frame;
  };
  const drainReactiveMysteries = actives => {
    if(!reactiveEnabled||drainingMysteries)return;
    drainingMysteries=true;
    try {
      // Re-evaluate profiles, targets and resources after every cast. All spends go
      // through the same cooldown/action checks as the opening Mystery phase.
      let cast;
      do {
        cast=false;
        for(const u of initiative(p1.concat(p2))){
          if(!hashCombat.isHash(u)&&!painCombat.isPain(u)&&!obitoCombat.isObito(u)&&!mechaCombat.isMecha(u)&&!itachiCombat.isItachi(u)&&!sasukeCombat.isSasuke(u))continue;
          const opponents=chaseContext.teams[1-u.camp],allies=chaseContext.teams[u.camp];
          const target=opponents.find(v=>v.hp>0&&!v.auxiliary&&!itachiCombat.active(v,'itachiHidingUntil'));
          if(!target)continue;
          const spec=narutoCombat.useMystery(chaseContext,u,()=>{});
          if(!spec)continue;
          cast=true;
          perform(u,target,opponents,allies,actives,spec,false,true);
        }
      }while(cast);
    } finally {drainingMysteries=false;}
  };
  for (let t = 1; t <= MAX_TUR; t++) {
    reactiveEnabled=false;
    narutoCombat.startRound(chaseContext,t);
    mechaCombat.roundStart(chaseContext);
    itachiCombat.roundStart(chaseContext);
    const sasukeRounds=sasukeCombat.roundStart(chaseContext);
    let arenaFinisher = 0;
    if (arenaRakip && t === MAX_TUR) {
      const hpRatio = team => {
        const maxHp = team.reduce((sum, u) => sum + u.maxHp, 0);
        return maxHp ? team.reduce((sum, u) => sum + Math.max(0, u.hp), 0) / maxHp : 0;
      };
      arenaFinisher = hpRatio(p2) > hpRatio(p1) ? 1 : 0;
    }
    const actives = t===1 ? [...initialActives] : [];
    for(const request of sasukeRounds){
      const enemies=chaseContext.teams[1-request.unit.camp],target=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(target)perform(request.unit,target,enemies,chaseContext.teams[request.unit.camp],actives,request.move);
    }
    for(const request of mechaCombat.roundRequests(chaseContext)){
      const enemies=chaseContext.teams[1-request.unit.camp],target=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(target)perform(request.unit,target,enemies,chaseContext.teams[request.unit.camp],actives,request.move);
    }
    actives.push(...hashCombat.roundStart(chaseContext));
    actives.push(...obitoCombat.roundStart(chaseContext));
    for(const request of painCombat.roundStart(chaseContext)){
      if(request.unit.hp<=0||request.unit.painFinal)continue;
      const opponents=chaseContext.teams[1-request.unit.camp],target=opponents.find(v=>v.hp>0&&!v.auxiliary);
      if(target)perform(request.unit,target,opponents,chaseContext.teams[request.unit.camp],actives,request.move);
    }
    for(const u of p1.concat(p2))if(u.hp>0)deathTriggered.delete(u);
    actives.push(...jiraiyaCombat.roundStart(chaseContext));
    for (const unit of p1.concat(p2)) {
      unit.battleRound=t;
      if(unit.hp<=0)continue;
      const records=[];
      partnerSkills.trigger('round',unit,unit.camp===0?p1:p2,unit.camp===0?p2:p1,[],records);
      actives.push(...heroSkills.eventFrames(unit,records));
    }
    actives.push(...heroSkills.startRound(p1.concat(p2)));
    appendDeaths(actives);
    // Opening Mysteries have priority; prompt skills retain their independent action.
    for (const u of initiative(p1.concat(p2))) {
      const opponents=u.camp===0?p2:p1,allies=u.camp===0?p1:p2;
      const target=opponents.find(other=>other.hp>0 && !other.cloneOwner) || opponents.find(other=>other.hp>0);
      if(!target) continue;
      for(let attempt=0;attempt<(painCombat.isPain(u)&&u.painFinal?2:1);attempt++){
        const selected=opponents.find(other=>other.hp>0&&!other.auxiliary&&!itachiCombat.active(other,'itachiHidingUntil'));if(!selected)break;
        const spec=narutoCombat.useMystery(chaseContext,u,()=>{});
        if(!spec)break;
        perform(u,selected,opponents,allies,actives,spec,false,true);
      }
    }
    reactiveEnabled=true;
    drainReactiveMysteries(actives);
    for (const u of initiative(p1.concat(p2))) {
      if (u.hp <= 0) continue;
      // Sage Shadow Clone is a full combatant. Other auxiliary clones keep the
      // legacy skip rule used by their owning characters.
      if ((u.cloneOwner && u.id !== narutoCombat.config.cloneId) || u.auxiliary || narutoCombat.disabled(u)) continue;
      if (['stun','fossilize','void','freeze'].some(field=>heroSkills.status(u,field))) continue;
      const canSkill = hashCombat.canMystery(chaseContext,u) && !narutoCombat.profile(u) && painCombat.canMystery(chaseContext,u,{}) && chaseContext.chakra[u.camp]>=painCombat.mysteryCost(chaseContext,u,{}) && u.skill && validSkillTargets(u, u.camp === 0 ? p2 : p1) && !heroSkills.status(u,'silence') && !heroSkills.status(u,'chaos') && !jiraiyaCombat.blocksMystery(chaseContext,u,null) && (u.anger >= 100 || heroTalents.effect(u.id).normalSkill);
      if(!canSkill&&painCombat.active(u,'painHorrorUntil'))continue;
      if(!canSkill&&sasukeCombat.active(u,'sasukeFearUntil'))continue;
      if(!hashCombat.canStandard(u))continue;
      if(!narutoCombat.profile(u)&&u.hashStandardLossRound===t&&u.hashStandardLoss>0){u.hashStandardLoss--;continue;}
      if (!canSkill && heroSkills.status(u,'disarm')) continue;
      const ayakta = (u.camp === 0 ? p2 : p1).filter(x => x.hp > 0);
      const rakip = heroTalents.selectTargets(u, ayakta)[0];
      if (!rakip) break;
      const bitir = options.forceWin !== false && t === MAX_TUR && (arenaRakip ? u.camp === arenaFinisher : u.camp === 0);
      const allies = u.camp === 0 ? p1 : p2;
      const opponents = heroSkills.status(u,'chaos') ? p1.concat(p2).filter(other=>other!==u&&!other.auxiliary&&other.camp===u.camp) : u.camp === 0 ? p2 : p1;
      if (!opponents.some(other=>other.hp>0)) continue;
      const target = heroSkills.status(u,'chaos') ? heroSkills.select(opponents,'random1',options.random||Math.random)[0] : rakip;
      const spec=narutoCombat.useStandard(chaseContext,u,allies);
      if(narutoCombat.profile(u) && !spec) continue;
      u.barrierMysteryBlocked=jiraiyaCombat.blocksMystery(chaseContext,u,null);
      if(!narutoCombat.profile(u)&&!canSkill)chaseContext.primaryActions.set(u,t);
      const act = perform(u,target,opponents,allies,actives,spec,bitir);
      // Rage can grant further standards on a kill; every extra consumes a credit.
      while((mechaCombat.isMecha(u)?mechaCombat.available(chaseContext,u):hashCombat.isHash(u)?hashCombat.available(chaseContext,u):obitoCombat.isObito(u)&&obitoCombat.available(chaseContext,u))&&u.hp>0&&!narutoCombat.disabled(u)&&!heroSkills.status(u,'disarm')&&hashCombat.canStandard(u)){
        const next=heroSkills.select(opponents,'low',options.random||Math.random)[0];
        if(!next)break;
        const extraSpec=narutoCombat.useStandard(chaseContext,u,allies);
        if(!extraSpec)break;
        perform(u,next,opponents,allies,actives,extraSpec,bitir);
      }
      // Combo is BASEATTRIBUTEINDEX_Punch (14), not a fixed global chance.
      // Extra attacks neither spend nor generate rage and never chain recursively.
      if (!spec && act.activeType === kodek.ACTIVE.NORMAL && u.hp > 0 && !heroSkills.status(u,'disarm') && (options.random || Math.random)() < Math.max(0, Math.min(1, heroSkills.value(u,'punchRate')))) {
        const next = heroTalents.selectTargets(u, opponents)[0];
        if (next) {
          const combo = vurus(u, next, false, opponents, options.random || Math.random, true, allies);
          u.verdi += combo.targets.filter(target => target.targetCamp !== u.camp).reduce((sum,target) => sum + Math.max(0, Number(target.result.hurtHp) || 0),0);
          actives.push(...(combo.beforeFrames||[]),combo);
          actives.push(...combo.reactions);
          appendDeaths(actives);
        }
      }
      // Ordinary Bleach combo attacks also grant TP and may unlock a ninja form.
      drainReactiveMysteries(actives);
      if (p2.every(x => x.hp <= 0)) break;
    }
    reactiveEnabled=false;
    actives.push(...sasukeCombat.endRound(chaseContext));
    actives.push(...hashCombat.endRound(chaseContext));
    actives.push(...heroSkills.endRound(p1.concat(p2)));
    appendDeaths(actives);
    for(const unit of p1.concat(p2))if(unit.hp>0){
      const records=[];
      partnerSkills.trigger('roundEnd',unit,unit.camp===0?p1:p2,unit.camp===0?p2:p1,[],records);
      actives.push(...heroSkills.eventFrames(unit,records));
    }
    if (actives.length) turns.push({ curTurn: t, actives });
    if (p2.every(x => x.hp <= 0) || p1.every(x => x.hp <= 0)) break;
  }
  // Savas istatistigi: client "Battle Stats"a basinca CS 0x01548002 ile ISTIYOR (payload yok).
  const ist = u => ({ heroId: u.id, hurt: u.verdi || 0, remainHp: u.maxHp > 0 ? Math.max(0, u.hp) / u.maxHp : 0 });
  SON_OYUNCU_HASARI = p1.reduce((sum, unit) => sum + (unit.verdi || 0), 0);
  SON_ISTATISTIK = kodek.encodeStatistics(p1.map(ist), p2.map(ist));
  return {
    chaseTrace: chaseContext.trace,
    chakra: chaseContext.chakra,
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
  const snapshot = durum ? JSON.parse(JSON.stringify(durum)) : null;
  if (snapshot && Array.isArray(snapshot.bosDunya?.form) && snapshot.bosDunya.form.length) {
    snapshot.kadro = Object.fromEntries(snapshot.bosDunya.form.map(hero => [String(hero.heroId),hero.battlePos || hero.pos]));
  }
  const boss=require('./void-region-config').enemy();
  const currentHp=Number(snapshot?.bosDunya?.hp)||Number(boss.hp);
  const unit=boss.source==='naruto'
    ? heroBirim(boss._id,6,Number(boss.level)||100,null,null,0,true)
    : dusmanBirim({...boss,hp:Math.max(1,Math.min(1000000000,currentHp))},6);
  if(!unit)throw new Error('Void Region boss has no playable combat data');
  unit.camp=1;
  unit.hp=unit.maxHp=Math.max(1,Math.min(1000000000,currentHp));
  const customStats=boss.source==='naruto'?require('./void-region-config').view().effectiveStats:require('./void-region-config').read().stats;
  for(const field of ['atk','def','speed','level'])if(customStats[field]!==undefined)unit[field]=customStats[field];
  for(const field of ['hp','maxHp','atk','def','speed','magicAtk'])if(Number.isFinite(unit[field]))unit[field]=Math.max(0,Math.min(1000000000,unit[field]));
  const report = kadroRapor(0, null, {ad:'Void Region: '+boss.name,birimler:[unit]}, { scaleEnemy: false, forceWin: false, requireEnemyDefeated:true,strictSkillTargets:true, ...(snapshot ? { playerState: snapshot } : {}) });
  if (!report) throw new Error('Unable to build the player battle report for Void Region');

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

function illusionBattle(playerState, bot = null) {
  const cfg = require('./infinite-illusion-config.json');
  const boss = heroBirim(cfg.bossHeroId, 6, cfg.bossLevel, null, null, 0, true);
  if (!boss) throw Error('Infinite Illusion boss has no playable model');
  boss.camp = 1;
  boss.hp = boss.maxHp = cfg.bossHp;
  boss.atk = cfg.bossAttack;
  boss.def = cfg.bossDefense;
  const options = {playerState, scaleEnemy:false, forceWin:false, requireEnemyDefeated:true, battleDataVersion:4, maxHitDamage:0x7fffffff};
  if (bot) {
    const level = Math.max(1, Math.min(159, 100 + bot.levelOffset));
    options.playerUnits = bot.heroes.map((id, i) => heroBirim(id, bot.positions[i], level, null, null, 0, true)).filter(Boolean);
    for (const unit of options.playerUnits) {
      unit.atk = Math.round(unit.atk * bot.power * cfg.botAttackMultiplier);
      unit.hp = unit.maxHp = Math.round(unit.maxHp * bot.power * cfg.botHealthMultiplier);
    }
    if (!options.playerUnits.length) throw Error('Infinite Illusion bot has no playable formation');
  }
  const previousStats = SON_ISTATISTIK, previousDamage = SON_OYUNCU_HASARI;
  try {
    const report = kadroRapor(0, null, {ad:'Infinite Illusion — Muken Aizen', birimler:[boss]}, options);
    if (!report) throw Error('Cannot simulate Infinite Illusion');
    // HP lost is authoritative, including overkill, healing and shields.
    return {...report, damage:Math.min(cfg.bossHp, Math.max(0, cfg.bossHp - boss.hp))};
  } finally {
    // Scheduled bot fights must not replace the player's Battle Stats panel.
    if (bot) { SON_ISTATISTIK = previousStats; SON_OYUNCU_HASARI = previousDamage; }
  }
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
// Arena resolves a real saved account; other requests resolve their own stage.
let sonStage = 0;   // GoldFastAutoBattle payload'i sadece [u8] -> en son girilen stage kullanilir
function fightFrames(reqId, payload, durum = null) {
  if ((reqId >>> 0) === 0x01811904) return require('./arena-real').frames(payload);
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
  if (hurdleChallenge && stageCityType(hurdleCityId) === 2 && !stageIdCoz(payload, durum)) {
    throw new Error('Instance is complete or the stage is invalid; reset before challenging again');
  }
  const stageBattle = !!stageById(bpId);
  if (bpId && !heroChangeFight) sonStage = bpId;
  const arenaRakip = null;
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
  if (!isAutoBattle(reqId) || !Buffer.isBuffer(payload) || payload.length !== 10) {
    throw new Error('Invalid world-map Auto-Battle request');
  }
  // World-map requests name their stage explicitly; never reward a stale selection.
  const bpId = stageIdCoz(payload);
  const cityId = payload.readUInt32BE(0);
  const city = cityById.get(cityId);
  if (!city || Number(city.type) !== 1 || !bpId || !worldMapLevel(bpId) ||
      Number(blockById.get(bpId).campaign) !== cityId) {
    throw new Error('Invalid world-map Auto-Battle stage');
  }
  const n = payload.readUInt16BE(8);
  if (n < 1 || n > 50) throw new Error('Invalid world-map Auto-Battle count');
  if (bpId) sonStage = bpId;
  const turlar = [], totals = new Map();
  for (let i = 0; i < n; i++) {
    const o = bpId ? stageOdulleri(bpId) : [];   // sans havuzu her tur yeniden atilir
    turlar.push({ dalgalar: [o], son: [] });
    for (const x of o) {
      const key = `${x.type}:${x.code}`;
      const total = totals.get(key);
      if (total) total.amount += x.amount;
      else totals.set(key, { ...x });
    }
  }
  const toplam = [...totals.values()];
  console.log(`[savas] oto-savas: stage ${bpId} x${n} tur, ${toplam.length} odul girdisi`);
  return [{
    id: 0x01180505,
    // Rewards are committed immediately; Flash expects remaining seconds, not milliseconds.
    payload: kodek.encodeAutoBattle({ costTimer: 0, isWorldLevel: 0, turlar }),
    odul: toplam,
    stageId: bpId,
    count: n,
    vitalityCost: Math.max(0, Number(blockById.get(bpId).spirit) || 0) * n,
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
  'PACKETID_CS_LOBBY_WorldMap_AutoBattle',
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
  illusionBattle,
  worldMapLevel, worldMapScale, stageArmyDusmanlari, cityDefendBattle, heroBirim, initiative, vurus, isFight, fightAck, fightFrames, fightPetFrames, sonOyuncuHasari, voidFightFrames,
  isAutoBattle, autoBattleFrames, FIGHT_OPS, synthReport, stageDusmanlari, stageIdCoz,
  instanceStageWon, stageAssessment, stageNextLayer, stageCityType, raidersDailyStageId,
  isRaidersDailyCity, skyTowerStageId, stageOdulleri, kadroRapor, sonIstatistik,
  heroChangeStageId, heroChangeFragmentId, syncHeroChangeInfo, heroChangeInfoPacket, heroChangeAttempt, heroChangeWon,
  heroChangeReset, heroChangeOneKey, playerTeam, HERO, ENEMY,
};
