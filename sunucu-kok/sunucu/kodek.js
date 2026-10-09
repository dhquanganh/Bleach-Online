'use strict';
// Bleach protokol kodek — AS3 TUnstreamizer* siniflarindan birebir cikarilmis codec.
// Savas raporu (0x01458000) encode/decode + SingleBattleResult (0x01458001).
// Tum sayilar BIG-ENDIAN; UTF = u16 len + utf8 bytes (TUtilityString.FetchUTF).

// ---- BE Writer ----
class W {
  constructor() { this.parts = []; this.len = 0; }
  _p(b) { this.parts.push(b); this.len += b.length; return this; }
  i8(v) { return this._p(Buffer.from([v & 0xff])); }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(v << 16 >> 16); return this._p(b); }
  u16(v) { const b = Buffer.alloc(2); b.writeUInt16BE(v & 0xffff); return this._p(b); }
  i32(v) { const b = Buffer.alloc(4); b.writeInt32BE(v | 0); return this._p(b); }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); return this._p(b); }
  f32(v) { const b = Buffer.alloc(4); b.writeFloatBE(Number(v) || 0); return this._p(b); }
  utf(s) { const t = Buffer.from(String(s == null ? '' : s), 'utf8'); const h = Buffer.alloc(2); h.writeUInt16BE(t.length & 0xffff); return this._p(h)._p(t); }
  done() { return Buffer.concat(this.parts, this.len); }
}

// ---- BE Reader ----
class R {
  constructor(buf) { this.b = buf; this.o = 0; }
  i8() { const v = this.b.readInt8(this.o); this.o += 1; return v; }
  u8() { const v = this.b.readUInt8(this.o); this.o += 1; return v; }
  i16() { const v = this.b.readInt16BE(this.o); this.o += 2; return v; }
  u16() { const v = this.b.readUInt16BE(this.o); this.o += 2; return v; }
  i32() { const v = this.b.readInt32BE(this.o); this.o += 4; return v; }
  u32() { const v = this.b.readUInt32BE(this.o); this.o += 4; return v; }
  utf() { const n = this.b.readUInt16BE(this.o); this.o += 2; const s = this.b.toString('utf8', this.o, this.o + n); this.o += n; return s; }
  eof() { return this.o >= this.b.length; }
}

// CMD sabitleri (TTargetInfo)
const CMD = { NONE: 0, ATTACK: 1, ATTRBUFF: 2, HURTBUFF: 3, CONTROLBUFF: 4, POSITION: 5, STATUS: 6, ATTACKEX: 7, SHIELD: 8, FLOAT: 9 };
// ActiveType (CONST_BATTLE)
const ACTIVE = { NORMAL: 1, SKILL: 2, NORMAL_EX: 7 };
// TargetStatus bit maskesi (CONST_BATTLE.ActiveType_*) — client render mantigi:
//   if (TargetStatus & Hit) { ChangeHP(HurtHp); ... } else ActivePlay(TYPE_ACTIVE_DODGE)
// HIT biti YOKSA vurus DODGE olarak oynatilir ve hasar uygulanmaz. Gercek raporlarda
// hasar hedefi = TARGET_EFFECT|HIT (0x82000000), kritik = +CRIT (0xC2000000),
// vuranin kendi ofke satiri = sadece HIT (0x02000000).
const ST = {
  IMM_CTRL: 4, IMM_CALM: 8, INVINCIBLE: 2097152, BEAT_BACK: 4194304,
  HIT: 33554432,          // 0x02000000
  CRIT: 67108864,         // 0x04000000
  BLOCK: 134217728,       // 0x08000000
  HELP: 268435456,        // 0x10000000
  PUNCH: 536870912,       // 0x20000000
  DIED: 1073741824,       // 0x40000000
  TARGET_EFFECT: 2147483648, // 0x80000000
};
// Opcode'lar
const OP = { REPORT: 0x01458000, RESULT: 0x01458001, STATISTICS: 0x01458002 };

// ---- Result yaz (cmd'e gore) ----
function writeResult(w, cmd, r) {
  r = r || {};
  if (cmd === CMD.ATTACK || cmd === CMD.ATTACKEX) { w.i32(r.hurtHp || 0); w.i32(r.hurtAnger || 0); }
  else if (cmd === CMD.HURTBUFF) { w.i32(r.hurtHp || 0); w.i32(r.hurtAnger || 0); w.u32(r.buffId || 0); }
  else if (cmd === CMD.CONTROLBUFF || cmd === CMD.ATTRBUFF || cmd === CMD.SHIELD || cmd === CMD.POSITION || cmd === CMD.FLOAT) { w.u32(r.buffId || 0); w.u32(r.buffTurn || 0); }
  // STATUS(6) / NONE(0): bos
}
function readResult(rd, cmd) {
  const r = { cmd };
  if (cmd === CMD.ATTACK || cmd === CMD.ATTACKEX) { r.hurtHp = rd.i32(); r.hurtAnger = rd.i32(); }
  else if (cmd === CMD.HURTBUFF) { r.hurtHp = rd.i32(); r.hurtAnger = rd.i32(); r.buffId = rd.u32(); }
  else if (cmd === CMD.CONTROLBUFF || cmd === CMD.ATTRBUFF || cmd === CMD.SHIELD || cmd === CMD.POSITION || cmd === CMD.FLOAT) { r.buffId = rd.u32(); r.buffTurn = rd.u32(); }
  return r;
}

function writeRole(w, r, version) {
  w.i8(r.pos || 0);
  w.u32(r.roleId >>> 0);
  w.i8(r.quality || 1);
  w.i16(r.level || 1);
  w.i32(r.curHealth | 0);
  w.i32(r.totalHealth | 0);
  w.i32(r.curAnger | 0);
  w.i32(r.skillId | 0);
  w.utf(r.name || '');
  if (version > 2) w.i8(r.rebirthNum || 0);
}
function writeGroup(w, g, version) {
  w.i32(g.knifeOfKillSoulID || 0);
  w.i32(g.knifeSoulID || 0);
  w.i32(g.bloodAddRate || 0);
  const roles = g.roles || [];
  w.i16(roles.length);
  for (const r of roles) writeRole(w, r, version);
}
function writeActive(w, a) {
  w.i8(a.activeCamp || 0);
  w.i8(a.activePos || 0);
  w.i32(a.skillEffectId | 0);
  w.i32(a.activeType | 0);
  const ts = a.targets || [];
  w.i16(ts.length);
  for (const t of ts) {
    w.i8(t.cmd | 0);
    w.i8(t.targetCamp || 0);
    w.i8(t.targetPos || 0);
    w.u32(t.reportTargetStatus >>> 0);
    writeResult(w, t.cmd | 0, t.result);
  }
}

// ---- Savas raporu encode ----
function encodeBattleReport(info) {
  const version = Number(info.version != null ? info.version : 2);
  const w = new W();
  w.utf(String(version));
  writeGroup(w, info.player1, version);
  writeGroup(w, info.player2, version);
  const turns = info.turns || [];
  w.i16(turns.length);
  for (const t of turns) {
    w.i32(t.curTurn | 0);
    const as = t.actives || [];
    w.i16(as.length);
    for (const a of as) writeActive(w, a);
  }
  return w.done();
}

// ---- Savas raporu decode (yakalanan gercek raporu anlamak icin) ----
function decodeBattleReport(buf) {
  const rd = new R(buf);
  const version = Number(rd.utf());
  const readGroup = () => {
    const g = { knifeOfKillSoulID: rd.i32(), knifeSoulID: rd.i32(), bloodAddRate: rd.i32(), roles: [] };
    const n = rd.i16();
    for (let i = 0; i < n; i++) {
      const r = { pos: rd.i8(), roleId: rd.u32(), quality: rd.i8(), level: rd.i16(), curHealth: rd.i32(), totalHealth: rd.i32(), curAnger: rd.i32(), skillId: rd.i32(), name: rd.utf() };
      if (version > 2) r.rebirthNum = rd.i8();
      g.roles.push(r);
    }
    return g;
  };
  const player1 = readGroup();
  const player2 = readGroup();
  const turns = [];
  const tn = rd.i16();
  for (let i = 0; i < tn; i++) {
    const t = { curTurn: rd.i32(), actives: [] };
    const an = rd.i16();
    for (let j = 0; j < an; j++) {
      const a = { activeCamp: rd.i8(), activePos: rd.i8(), skillEffectId: rd.i32(), activeType: rd.i32(), targets: [] };
      const tgn = rd.i16();
      for (let k = 0; k < tgn; k++) {
        const cmd = rd.i8();
        const tg = { cmd, targetCamp: rd.i8(), targetPos: rd.i8(), reportTargetStatus: rd.u32() };
        tg.result = readResult(rd, cmd);
        a.targets.push(tg);
      }
      t.actives.push(a);
    }
    turns.push(t);
  }
  return { version, player1, player2, turns, _consumed: rd.o, _total: buf.length };
}

// ---- SingleBattleResult encode ----
// TBattleHandle.PacketPerform_SC_SingleBattleResult:
//   [i32 result=0][i8 win] + TUnstreamizerRewards
// TUnstreamizerRewards = [i16 count] + count x TUnstreamizerItem
// TUnstreamizerItem    = [i16 Type][i32 ID][i32 Count]   -> 10 bayt
// Yakalanan 7 gercek sonuc paketiyle dogrulandi: 37B = 7 + 3x10, 47B = 7 + 4x10.
// (Eskiden count=0 yazilip item hic gonderilmiyordu -> "Loot all" bos donuyordu.)
function encodeSingleResult(win, rewards) {
  const w = new W();
  w.i32(0);            // result = 0 (basari); !=0 ise client paketi tamamen yok sayar
  w.i8(win ? 1 : 0);
  const items = Array.isArray(rewards) ? rewards.slice(0, 64) : [];
  w.i16(items.length);
  for (const it of items) {
    w.i16((it.type || 0) | 0);                      // TItem.Type  (Award fixed "type")
    w.i32((it.code != null ? it.code : it.id || 0) | 0);   // TItem.ID    (0 = para birimi)
    w.i32((it.amount != null ? it.amount : it.count || 1) | 0); // TItem.Count
  }
  return w.done();
}

// ---- BattleStatistics encode (SC 0x01458002) ----
// TUnstreamizerBattleStatistics: [i16 n][n x (u32 HeroId, u32 Hurt, f32 RemainHp)] = BIZ,
// hemen ardindan ayni yapi = DUSMAN.
// RemainHp bir 0..1 ORANI, mutlak HP degil (TStatisticsItem.SetHpRate:
//   FBarHpRate.scaleX = param1 > 0 ? (param1 > 1 ? 1 : param1) : 0)
// Hurt ise mutlak hasar (SetHurt metni dogrudan basiyor).
function encodeStatistics(bizim, dusman) {
  const w = new W();
  const grup = list => {
    const a = Array.isArray(list) ? list.slice(0, 32) : [];
    w.i16(a.length);
    for (const x of a) {
      w.u32(x.heroId >>> 0);
      w.u32(Math.max(0, Math.round(Number(x.hurt) || 0)) >>> 0);
      w.f32(Math.max(0, Math.min(1, Number(x.remainHp) || 0)));
    }
  };
  grup(bizim); grup(dusman);
  return w.done();
}

// ---- AutoBattleInfo encode (SC_LOBBY_WorldMap_AutoBattleInfo = 0x01180505) ----
// DIKKAT: cevap opcode'u istegin swap'i DEGIL!
//   CS WorldMap_AutoBattle = WORLDMAP_Base + 4 (0x01810504)
//   SC AutoBattleInfo      = WORLDMAP_Base + 5 (0x01180505)
// Swap ile uretilen 0x01180504 = ContinueAutoInfo; oraya bos paket gidince client
// GetDatebase(City, 0).Type okuyor -> null exception (TProcessorLargeWorldMap:310).
//
// Duzen (PacketPerform_SC_AutoBattleInfo once u32 result okur, gerisini
// TUnstreamizerAutoBattleInfo'ya devreder):
//   [u32 result][i32 CostTimer][i8 IsWorldLevel][i16 turSayisi]
//   her tur: [i16 dalgaSayisi] + dalgaSayisi x Rewards + 1 x Rewards (tur sonu odulu)
//   Rewards = [i16 n] + n x TItem(10B: i16 Type, i32 ID, i32 Count)
// Yakalanan 471B gercek pakette birebir dogrulandi (10 tur, dalga=1, 3 odul + 1 son odul).
function odulYaz(w, items) {
  const a = Array.isArray(items) ? items.slice(0, 64) : [];
  w.i16(a.length);
  for (const it of a) {
    w.i16((it.type || 0) | 0);
    w.i32((it.code != null ? it.code : it.id || 0) | 0);
    w.i32((it.amount != null ? it.amount : it.count || 1) | 0);
  }
}
function encodeAutoBattle(bilgi) {
  const w = new W();
  w.u32(0);                                   // result = 0 (!=0 ise client hata metni basip cikar)
  w.i32(Number(bilgi.costTimer) || 0);
  w.i8(bilgi.isWorldLevel ? 1 : 0);
  const turlar = (bilgi.turlar || []).slice(0, 200);
  w.i16(turlar.length);
  for (const t of turlar) {
    const dalgalar = t.dalgalar || [];
    w.i16(dalgalar.length);
    for (const d of dalgalar) odulYaz(w, d);
    odulYaz(w, t.son || []);
  }
  return w.done();
}

module.exports = { W, R, CMD, ACTIVE, ST, OP, encodeBattleReport, decodeBattleReport, encodeSingleResult, encodeStatistics, encodeAutoBattle };
