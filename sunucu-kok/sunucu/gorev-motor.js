'use strict';
// GOREV MOTORU — gercek, durum-tabanli quest sistemi (replay/all-finished DEGIL).
//
// Protokol (client kaynagindan dogrulandi):
//   CS_Task_QuestActionReq 0x01811201 = [i32 questId][i8 actionId]  (ACCEPT=0 COMPLETE=1 CANCEL=2)
//   SC_Task_QuestActionRet 0x01181201 = [u32 result][u32 questId][i8 actionId]  (result 0=basari)
//   SC_Task_AlreadyAcceptTaskRet 0x01181202 = [u16 n] + n x ([u32 questId][u16 killTime])
//   SC_Task_AlreadyFinishTaskRet 0x01181203 = [i16 n] + n x [i32 questId]
//   SC_Task_SendTaskSchedule     0x01181204 = [u32 questId][u32 currentKillTime]
//   SC_Task_CompleteSendInfor    0x01181200 = tetik (bos)
// Client (TUnstreamizerQuests): eventType 1 (JustRun/konusma) -> hemen TASKBACK; digerlerinde
//   CurrentKillTime >= Task.complete.value ise TASKBACK (teslim edilebilir), degilse TASKING.
//
// KURALLAR (ESKIDEN yoktu: her gorev seviye bakilmadan kabul ediliyor, killTime=65535 ile aninda bitiyordu):
//   ACCEPT   : ana hero seviyesi >= Task.accept, on gorev (preTaskId) bitmis olmali, zaten kabul/bitmis olmamali.
//   ILERLEME : eventType 2 -> BlockPoint/SinglePointPath victory; eventType 4 -> completed Single instance ID.
//              eventType 3,5..14 -> olay sayaci (arena, ekipman, kultivasyon, ev...) kabul anindaki tabana gore delta.
//              eventType 1 -> sartsiz.
//   COMPLETE : ilerleme >= value degilse RED (result 1). Odul: para/esya + PARTNER (type 4 -> oyun-sunucu kadroya katar).
// Kalicilik: durum.gorev = { kabul:{questId:{kill,taban}}, biten:[questId,...] } -> oyuncu.json + oyun.db.
const fs = require('fs');
const path = require('path');
const olay = require('./olay');
const { satir, tablo } = require('./paket');

const TASK_JSON = path.join(__dirname, '..', 'cikarim', 'veri-json', 'Task.json');
const ACCEPT = 0, COMPLETE = 1, CANCEL = 2;
const HATA = { GENEL: 1 };
// eventType -> olay anahtari (savas tipleri 2/4 disinda)
const OLAY_ANAHTAR = { 3: 'arenaFight', 5: 'fortifyEquip', 6: 'gemInlay', 7: 'cultivate', 8: 'spiritForge', 9: 'enchant', 10: 'treasureMap', 11: 'beautyGame', 12: 'girlfriendExchange', 13: 'girlfriendParty', 14: 'konso' };
const SAVAS_TIP = new Set([2, 4]);

const TASKS = new Map(); // questId(uint) -> { rewards, eventType, accept, pre, campId, value, ad }
try {
  for (const t of JSON.parse(fs.readFileSync(TASK_JSON, 'utf8'))) {
    const id = parseInt(t.id, 16) >>> 0;
    if (!id) continue;
    let rewards = [];
    try { const r = JSON.parse(t.rewards || '{}'); if (Array.isArray(r.rewards)) rewards = r.rewards; } catch {}
    let c = {}; try { c = JSON.parse(t.complete || '{}') || {}; } catch {}
    TASKS.set(id, {
      rewards, eventType: t.eventType | 0, accept: Number(t.accept) || 0, pre: Number(t.preTaskId) || 0,
      campId: Number(c.campId) || 0, value: Math.max(1, Number(c.value) || 1), ad: t.name || '',
    });
  }
} catch (e) { console.log('[gorev] Task.json okunamadi:', e.message); }
console.log(`[gorev] motor: ${TASKS.size} gorev yuklendi (durum-tabanli, seviye/on-gorev/kill kontrollu)`);

function anaSeviye() { try { return Number(require('./seviye').anaDurum().lv) || 1; } catch (e) { return 1; } }

function durumGorev(durum) {
  if (!durum.gorev || typeof durum.gorev !== 'object') durum.gorev = { kabul: {}, biten: [] };
  if (!durum.gorev.kabul || typeof durum.gorev.kabul !== 'object') durum.gorev.kabul = {};
  if (!Array.isArray(durum.gorev.biten)) durum.gorev.biten = [];
  // eski kayit (kabul[id] = 1) -> yeni sekil
  for (const k of Object.keys(durum.gorev.kabul)) if (!durum.gorev.kabul[k] || typeof durum.gorev.kabul[k] !== 'object') durum.gorev.kabul[k] = { kill: 0, taban: 0 };
  return durum.gorev;
}

/** Kabul edilmis gorevin guncel ilerlemesi (client bunu Task.complete.value ile karsilastirir). */
function ilerleme(durum, questId) {
  const g = durumGorev(durum); const k = g.kabul[String(questId)]; const t = TASKS.get(questId >>> 0);
  if (!k || !t) return 0;
  if (t.eventType === 1) return t.value;
  if (t.eventType === 4 && t.value === 1 && !(Number(k.kill) > 0) && instanceTamamMi(durum,t.campId)) k.kill = 1;
  if (SAVAS_TIP.has(t.eventType)) return Number(k.kill) || 0;
  const anahtar = OLAY_ANAHTAR[t.eventType];
  if (!anahtar) return t.value;                                   // bilinmeyen tip: kilitleme
  return Math.max(0, olay.oku(durum, anahtar) - (Number(k.taban) || 0));
}
function tamamMi(durum, questId) { const t = TASKS.get(questId >>> 0); return t ? ilerleme(durum, questId) >= t.value : false; }

// 0x01181202: kabul edilmis (devam eden) gorevler — GERCEK kill sayisi
function kabulPaketi(durum) {
  const g = durumGorev(durum);
  const ids = Object.keys(g.kabul).map(Number).filter(Boolean);
  const b = Buffer.alloc(2 + ids.length * 6);
  b.writeUInt16BE(ids.length & 0xffff, 0);
  ids.forEach((id, i) => { b.writeUInt32BE(id >>> 0, 2 + i * 6); b.writeUInt16BE(Math.min(65535, ilerleme(durum, id)), 6 + i * 6); });
  return b;
}
// 0x01181203: bitmis gorevler
function bitenPaketi(durum) {
  const g = durumGorev(durum);
  const ids = g.biten.map(Number).filter(Boolean);
  const b = Buffer.alloc(2 + ids.length * 4);
  b.writeInt16BE(ids.length & 0x7fff, 0);
  ids.forEach((id, i) => b.writeUInt32BE(id >>> 0, 2 + i * 4));
  return b;
}
// 0x01181201
function actionRet(result, questId, actionId) {
  const b = Buffer.alloc(9);
  b.writeUInt32BE(result >>> 0, 0);
  b.writeUInt32BE(questId >>> 0, 4);
  b.writeInt8(actionId | 0, 8);
  return b;
}
// 0x01181204
function schedulePaketi(questId, kill) {
  const b = Buffer.alloc(8);
  b.writeUInt32BE(questId >>> 0, 0);
  b.writeUInt32BE(kill >>> 0, 4);
  return b;
}

// CS 0x01811201 isle -> { ret, schedule?, oduller?, degisti?, sebep? }
function aksiyon(durum, payload) {
  if (!payload || payload.length < 5) return null;
  const questId = payload.readInt32BE(0) >>> 0;
  const actionId = payload.readInt8(4);
  const g = durumGorev(durum);
  const t = TASKS.get(questId);

  if (actionId === ACCEPT) {
    if (!t) return { ret: actionRet(HATA.GENEL, questId, ACCEPT), sebep: 'tanimsiz gorev' };
    if (g.biten.includes(questId)) return { ret: actionRet(HATA.GENEL, questId, ACCEPT), sebep: 'zaten bitmis' };
    if (g.kabul[String(questId)]) return { ret: actionRet(0, questId, ACCEPT), schedule: schedulePaketi(questId, ilerleme(durum, questId)) };
    const lv = anaSeviye();
    if (lv < t.accept) { console.log(`[gorev] RED "${t.ad}": seviye ${lv} < ${t.accept}`); return { ret: actionRet(HATA.GENEL, questId, ACCEPT), sebep: `seviye ${lv} < ${t.accept}` }; }
    if (t.pre && !g.biten.includes(t.pre)) { console.log(`[gorev] RED "${t.ad}": on gorev ${t.pre} bitmemis`); return { ret: actionRet(HATA.GENEL, questId, ACCEPT), sebep: 'on gorev bitmemis' }; }
    const anahtar = OLAY_ANAHTAR[t.eventType];
    g.kabul[String(questId)] = { kill: 0, taban: anahtar ? olay.oku(durum, anahtar) : 0 };
    console.log(`[gorev] kabul "${t.ad}" (tip ${t.eventType}${SAVAS_TIP.has(t.eventType) ? ', stage ' + t.campId : anahtar ? ', olay ' + anahtar : ''}, hedef ${t.value})`);
    return { ret: actionRet(0, questId, ACCEPT), schedule: schedulePaketi(questId, ilerleme(durum, questId)), degisti: true };
  }
  if (actionId === COMPLETE) {
    if (!g.kabul[String(questId)] || !t) return { ret: actionRet(HATA.GENEL, questId, COMPLETE), sebep: 'kabul edilmemis' };
    if (!tamamMi(durum, questId)) { console.log(`[gorev] RED teslim "${t.ad}": ilerleme ${ilerleme(durum, questId)}/${t.value}`); return { ret: actionRet(HATA.GENEL, questId, COMPLETE), schedule: schedulePaketi(questId, ilerleme(durum, questId)), sebep: 'sart saglanmadi' }; }
    delete g.kabul[String(questId)];
    if (!g.biten.includes(questId)) g.biten.push(questId);
    console.log(`[gorev] teslim "${t.ad}" -> ${t.rewards.length} odul`);
    return { ret: actionRet(0, questId, COMPLETE), oduller: t.rewards.map(x => ({ ...x })), degisti: true };
  }
  if (actionId === CANCEL) {
    if (g.kabul[String(questId)]) { delete g.kabul[String(questId)]; return { ret: actionRet(0, questId, CANCEL), degisti: true }; }
    return { ret: actionRet(HATA.GENEL, questId, CANCEL) };
  }
  return { ret: actionRet(HATA.GENEL, questId, actionId) };
}

/** Bir stage (blockPointId) kazanildi: o stage'i isteyen kabul edilmis gorevlerin kill sayaci artar. Donus: [{questId, kill}] */
function savasKazanildi(durum, bpId, adet) {
  const g = durumGorev(durum); const out = [];
  const bp = Number(bpId) >>> 0; if (!bp) return out;
  for (const [id, k] of Object.entries(g.kabul)) {
    const t = TASKS.get(Number(id) >>> 0);
    if (!t || t.eventType !== 2 || t.campId !== bp) continue;
    k.kill = Math.min(65535, (Number(k.kill) || 0) + Math.max(1, adet | 0));
    out.push({ questId: Number(id) >>> 0, kill: k.kill });
    console.log(`[gorev] "${t.ad}": stage ${bp} kazanildi -> ${k.kill}/${t.value}`);
  }
  return out;
}
function instanceTamamMi(durum, campaignId) {
  const single=satir('Single',campaignId);if(!single)return false;
  if(Number((durum.instanceStars||{})[campaignId])>0)return true;
  return tablo('City').liste.some(city=>Number(city.type)===2&&campaignId>=Number(city.start)&&campaignId<=Number(city.last)&&Number((durum.instanceProgress||{})[`${city._id}:${campaignId}`])>Number(single.endId));
}
// eventType 4 uses Single.id (15200001), not SinglePointPath.id (152010xx).
// Also repair accepted one-clear quests already stranded by the old ID mismatch.
function instanceKazanildi(durum) {
  const out=[];const g=durumGorev(durum);
  for(const [id,k]of Object.entries(g.kabul)) {
    const task=TASKS.get(Number(id));
    if(!task||task.eventType!==4||task.value!==1||Number(k.kill)>=task.value||!instanceTamamMi(durum,task.campId))continue;
    k.kill=task.value;out.push({questId:Number(id),kill:k.kill});
  }
  return out;
}

// Olay sayaci degisince (arena/ekipman/ev...) o olaya bagli kabul edilmis gorevlere SendTaskSchedule push'u.
olay.abone((durum, anahtar) => {
  const out = []; const g = durumGorev(durum);
  for (const id of Object.keys(g.kabul)) {
    const t = TASKS.get(Number(id) >>> 0);
    if (!t || OLAY_ANAHTAR[t.eventType] !== anahtar) continue;
    out.push({ id: 0x01181204, payload: schedulePaketi(Number(id), ilerleme(durum, Number(id))), kaynak: 'GOREV-schedule' });
  }
  return out;
});

module.exports = { kabulPaketi, bitenPaketi, actionRet, schedulePaketi, aksiyon, durumGorev, savasKazanildi, instanceKazanildi, instanceTamamMi, ilerleme, tamamMi, TASKS, OLAY_ANAHTAR };
