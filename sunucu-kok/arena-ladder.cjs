'use strict';

// One document makes exchanging both ranks atomic, including on standalone MongoDB.
function createLadder(db) {
  const collection = db.collection('arenaRankings');
  return async function apply(rows, battle = null, members = rows.map(row=>row.accountId)) {
    const ids = rows.map(row => row.accountId);
    if (new Set(ids).size !== ids.length) throw Error('Duplicate Arena account');
    if (battle && (typeof battle.id !== 'string' || !battle.id || typeof battle.won !== 'boolean' ||
      battle.accountId === battle.opponentId || !ids.includes(battle.accountId) || !ids.includes(battle.opponentId))) {
      throw Error('Invalid Arena result');
    }
    try {
      await collection.updateOne({_id:'global'}, {$setOnInsert:{revision:0,order:ids,recentBattles:[]}}, {upsert:true});
    } catch (error) { if (error.code !== 11000) throw error; }
    for (let attempt = 0; attempt < 32; attempt++) {
      const old = await collection.findOne({_id:'global'});
      if (!old) throw Error('Arena ranking unavailable');
      // A failed character snapshot must not erase an account's earned place.
      const live = new Set(members), seen = new Set();
      const order = [...old.order, ...ids].filter(id => live.has(id) && !seen.has(id) && seen.add(id));
      const recent = old.recentBattles || [];
      const previous = battle && recent.find(result => result.id === battle.id);
      if (previous && ['accountId','opponentId','won'].some(key => previous[key] !== battle[key])) throw Error('Arena result ID conflict');
      const duplicate = !!previous;
      let promoted = false;
      if (battle && !duplicate && battle.won) {
        const attacker = order.indexOf(battle.accountId), defender = order.indexOf(battle.opponentId);
        if (attacker > defender) {
          [order[attacker],order[defender]] = [order[defender],order[attacker]];
          promoted = true;
        }
      }
      const changed = JSON.stringify(order) !== JSON.stringify(old.order) || battle && !duplicate;
      if (changed) {
        const result = await collection.updateOne({_id:'global',revision:old.revision}, {$set:{
          revision:old.revision+1,order,
          // Deduplicate IPC retries within the recent battle window, without growing the document forever.
          recentBattles:battle && !duplicate ? [...recent,battle].slice(-2048) : recent,
        }});
        if (!result.matchedCount) continue;
      }
      const ranks = new Map(order.map((id,index) => [id,index+1]));
      return {rows:rows.map(row => ({...row,ranking:ranks.get(row.accountId)})).sort((a,b)=>a.ranking-b.ranking),promoted,duplicate};
    }
    throw Error('Arena ranking changed too often; retry the challenge');
  };
}
module.exports = {createLadder};
