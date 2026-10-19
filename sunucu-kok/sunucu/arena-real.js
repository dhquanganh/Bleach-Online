'use strict';
// Only the authenticated parent supplies opponents. Never fall back to generated units.
let roster = [];
let ownRank = 0;
let reward = null;
const commit = require('./arena-result-rpc').createClient();
function update(rows,settlement=null) {
  reward=settlement;
  ownRank = (Array.isArray(rows) ? rows : []).find(row => row.accountId === process.env.BLEACH_ACCOUNT_ID)?.ranking || 0;
  roster = (Array.isArray(rows) ? rows : []).filter(row => row.accountId && row.accountId !== process.env.BLEACH_ACCOUNT_ID && row.units && row.units.length);
}
function list() { return roster.slice(0, 8); }
function selected(payload) {
  if (!Buffer.isBuffer(payload) || payload.length < 8) return null;
  return list().find(row => row.id0 === payload.readUInt32BE(0) && row.id1 === payload.readUInt32BE(4)) || null;
}
function frames(payload) {
  const opponent = selected(payload);
  if (!opponent) throw Error('Arena opponent is unavailable');
  const savas = require('./savas'), kodek = require('./kodek');
  const result = savas.kadroRapor(0, { ...opponent, units: structuredClone(opponent.units) }, null, {
    scaleEnemy: false, forceWin: false, strictSkillTargets: true,
  });
  if (!result) throw Error('Unable to build Arena battle');
  return [{ id: kodek.OP.REPORT, payload: result.payload },
    { id: kodek.OP.RESULT, payload: kodek.encodeSingleResult(result.won, []), won: result.won, odul: [] }];
}
module.exports = { update, list, selected, frames, commit, rank: () => ownRank, reward: () => reward };
