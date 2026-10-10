'use strict';
const assert=require('assert'),quest=require('../gorev-motor'),battle=require('../savas');
const id=16100051,campaign=15200001,city=15210001,start=15201001,end=15201013;
const state=()=>({gorev:{kabul:{[id]:{kill:0,taban:0}},biten:[]}});
const request=Buffer.alloc(8);request.writeUInt32BE(city,0);request.writeUInt32BE(campaign,4);
let d=state();
assert.equal(quest.TASKS.get(id).eventType,4);assert.equal(quest.TASKS.get(id).campId,campaign);
assert.deepEqual(quest.savasKazanildi(d,start,1),[]);assert(!quest.tamamMi(d,id));
for(let stage=start;stage<=end;stage++){
  assert(battle.instanceStageWon(d,request,stage));
  const changed=quest.instanceKazanildi(d);
  if(stage<end){assert.deepEqual(changed,[]);assert(!quest.tamamMi(d,id));}
  else{assert.deepEqual(changed,[{questId:id,kill:1}]);assert(quest.tamamMi(d,id));}
}
assert.deepEqual(quest.instanceKazanildi(d),[],'completion must be idempotent');
const schedule=quest.schedulePaketi(id,1);assert.equal(schedule.readUInt32BE(0),id);assert.equal(schedule.readUInt32BE(4),1);
const repaired=state();repaired.instanceStars={[campaign]:3};assert.deepEqual(quest.instanceKazanildi(repaired),[{questId:id,kill:1}]);
const reload=state();reload.instanceProgress={[`${city}:${campaign}`]:end+1};assert(quest.tamamMi(reload,id));assert.equal(quest.kabulPaketi(reload).readUInt16BE(6),1);
const lost=state();lost.instanceProgress={[`${city}:${campaign}`]:end};assert(!quest.tamamMi(lost,id));
const wrong=state();wrong.instanceStars={[campaign+1]:3};assert.deepEqual(quest.instanceKazanildi(wrong),[]);
const action=Buffer.alloc(5);action.writeUInt32BE(id,0);action[4]=1;
assert.equal(quest.aksiyon(lost,action).ret.readUInt32BE(0),1);
const submitted=quest.aksiyon(repaired,action);assert.equal(submitted.ret.readUInt32BE(0),0);assert(submitted.oduller.length);assert(repaired.gorev.biten.includes(id));
assert.equal(quest.aksiyon(repaired,action).ret.readUInt32BE(0),1,'no duplicate reward');
console.log('PASS instance quest: final victory, correct campaign ID, immediate schedule, saved completion recovery, loss/wrong difficulty, NPC submission and no duplicate rewards.');
