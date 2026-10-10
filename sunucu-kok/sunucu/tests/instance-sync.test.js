'use strict';
const assert = require('assert');
const { tablo, satir } = require('../paket');
const battle = require('../savas');
const handlers = require('../handlers');
const cities = tablo('City').liste.filter(city => Number(city.type) === 2);
const request = (city, campaign) => {
  const b = Buffer.alloc(8); b.writeUInt32BE(city, 0); b.writeUInt32BE(campaign, 4); return b;
};
let stages = 0;
for (const city of cities) {
  for (let campaignId = Number(city.start); campaignId <= Number(city.last); campaignId++) {
    const campaign = satir('Single', campaignId);
    assert(campaign);
    const state = {};
    const payload = request(city._id, campaignId);
    for (let id = Number(campaign.startId); id <= Number(campaign.endId); id++) {
      assert.equal(battle.stageIdCoz(payload, state), id);
      const point = satir('SinglePointPath', id);
      const armyIds = JSON.parse(point.army).army;
      const expected = armyIds.flatMap(aid => {
        const army = satir('EnemyArmy', aid);
        return ['front', 'middle', 'back'].flatMap(key => army[key] ? JSON.parse(army[key])[key] || [] : []);
      });
      const team = battle.stageDusmanlari(id);
      assert(team, `Missing team ${id}`);
      assert.deepEqual(team.birimler.map(unit => unit.id), expected, `Wrong enemies ${id}`);
      assert(battle.instanceStageWon(state, payload, id));
      const packet = handlers.byReq['0x01810201']({ durum: state });
      let pos = 6 + packet.readUInt16BE(4) * 5;
      pos += 2 + packet.readUInt16BE(pos) * 7;
      const count = packet.readUInt16BE(pos); pos += 2;
      assert.equal(count, cities.length);
      let found = false;
      for (let i = 0; i < count; i++, pos += 9) {
        if (packet.readUInt32BE(pos) !== city._id) continue;
        found = true;
        assert.equal(packet[pos + 4], campaignId === Number(city.last) ? 1 : 0);
        assert.equal(packet[pos + 5], id + 1 - Number(campaign.startId));
      }
      assert(found); assert.equal(pos, packet.length);
      stages++;
    }
    assert.equal(battle.stageIdCoz(payload,state),0);
    assert.equal(state.instanceStars[campaignId],3);
    assert.equal(battle.instanceStageWon(state,payload,Number(campaign.endId)),false);
    assert.equal(battle.stageNextLayer(payload,true,Number(campaign.endId)),null);
    assert.equal(battle.stageAssessment(payload,true,Number(campaign.endId)).payload.readUInt32BE(8),campaignId);
    assert.equal(battle.stageAssessment(payload,false,Number(campaign.endId)),null);
    assert.equal(battle.stageAssessment(payload,true,Number(campaign.startId)),null);
    const reload=JSON.parse(JSON.stringify(state));assert.equal(battle.stageIdCoz(payload,reload),0);
    assert.throws(()=>battle.fightFrames(0x01810202,payload,reload),/Instance is complete/,'completed instance must not fall back to the previous battle');
    assert.equal(battle.stageNextLayer(payload,false,Number(campaign.endId)),null);
    assert(battle.stageNextLayer(payload,true,Number(campaign.endId)-1));
    const bag=handlers.byReq['0x01810201']({durum:reload});let pos=6+bag.readUInt16BE(4)*5,count=bag.readUInt16BE(pos);pos+=2;
    let rating=0;for(let i=0;i<count;i++,pos+=7)if(bag.readUInt32BE(pos)===campaignId)rating=bag[pos+6];
    assert.equal(rating,3,'completion stars survive reload');
  }
}
console.log(`PASS ${stages} instance stages across ${cities.length} cities: enemy teams, progression, final Single assessment ID, completion stars/reload, no next-layer packet after completion and no repeated reward battle.`);
const city = cities[0], easy = satir('Single', city.start), hard = satir('Single', city.last);
const switching = {
  instanceCampaign: { [city._id]: Number(city.start) },
  instanceProgress: { [`${city._id}:${city.start}`]: Number(easy.startId) + 3 },
};
const hardRequest = request(city._id, Number(city.last));
assert.equal(battle.stageIdCoz(hardRequest, switching), Number(hard.startId) + 3);
assert(battle.instanceStageWon(switching, hardRequest, Number(hard.startId) + 3));
assert.equal(battle.stageIdCoz(request(city._id, Number(city.start)), switching), Number(easy.startId) + 4);
const env = require('../envanter'), gear = require('../ekipman');
const state = JSON.parse(require('fs').readFileSync(require('path').join(__dirname, '../oyuncu.json'), 'utf8'));
const code = 14100161, prior = env.mevcut(state, code);
env.ekle(state, [{ code, amount: 2 }]);
assert.equal(env.mevcut(state, code), prior + 2);
const bag = env.loadBagPaketi(state);
assert.equal(gear.kayitlariOku(bag, 5).son, bag.length);
assert(env.liste(state).some(item => item.code === code && item.amount === prior + 2));
console.log('PASS Easy/Hard shared layer and complete inventory packet after a persistent reward grant; no player files changed.');
