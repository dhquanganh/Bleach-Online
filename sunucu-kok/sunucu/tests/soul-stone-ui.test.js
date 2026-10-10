'use strict';
// Exercise the patched Flash methods against replaced equipment references and slot models.
const assert = require('assert'), fs = require('fs'), path = require('path'), vm = require('vm');
const file = path.resolve(__dirname,'../../cikarim/soul-stone-refresh/patched/Processors/Game/Lobby/Jade/TJadeMosaic.as');
const source = fs.readFileSync(file,'utf8');
function method(name) {
  const start = source.indexOf(`function ${name}(`);
  assert(start >= 0);
  const brace = source.indexOf('{',start);
  let depth = 1, end = brace + 1;
  while(depth) { if(source[end]==='{') depth++; if(source[end]==='}') depth--; end++; }
  return source.slice(brace+1,end-1).replace(/var (\w+):[\w.<>]+/g,'var $1').replace(/ as TEquipment/g,'');
}
const collection = items => ({ Count: items.length, GetInventoryByIndex: i=>items[i], GetGiftedStoneByIndex: i=>items[i] });
const equip = stones => ({ Identifier: 42, HoleQuantity: 4, HoleAdditionalQuantity: 0, GiftedStoneItems: collection(stones) });
const slots = Array.from({length:4},()=>({Context:null,rendered:null,Update(){this.rendered=this.Context;}}));
const locks = slots.map(()=>({gotoAndStop(value){this.state=value;}}));
const context = { CONST_JADE:{MAX_MosaicJadeCount:4}, CAN_MOSAIC:1,LOCKED:2,MOSAICED:3,STATE_READY:0,STATE_MOSAIC:1,STATE_UNQUITE:2,
  TJadeCommon:{ProcessorUpdateSlotsRenderingState: items=>items.forEach(s=>s.Update())} };
const ui = {
  FCurrentState:0,FCurrentShowTagIndex:0,FCurrentShowEquipment:equip([{id:1},{id:2}]),FCurrentClickSingleEquip:null,
  FSingleEquipmentSlots:{Context:null},FEquipmentJadeSlots:slots,FMC_EquipmentJadesLock:locks,FBackpackSlots:[],
  FCurrentShowEquipmentBag:collection([]),latest:null,
  SelectEquipmentsByTabIndex(){this.FCurrentShowEquipmentBag=collection([this.latest]);},
  OnSwitchTab(){},UpdateJadeRecommend(){},UpdateBackpackJade(){},
};
for(const name of ['SetSlotByEquipment','UpdateEquipmentJadeSlot','Update']) ui[name]=vm.runInNewContext(`(function(param1){${method(name)}})`,context);
for(const stones of [[{id:2}],[],[{id:3}],[]]) {
  ui.latest=equip(stones);
  ui.Update();
  assert.strictEqual(ui.FCurrentShowEquipment,ui.latest);
  assert.deepStrictEqual(slots.map(s=>s.rendered&&s.rendered.id),[...stones.map(s=>s.id),...Array(4-stones.length).fill(null)]);
  assert.deepStrictEqual(locks.map(l=>l.state),[...stones.map(()=>3),...Array(4-stones.length).fill(1)]);
}
console.log('PASS Flash Soul Stone refresh: rebind updated equipment, remove one/multiple/last stone, clear icons, render empty sockets, re-embed then remove.');
