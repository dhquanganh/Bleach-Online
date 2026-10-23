'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=process.env.SOUL_STONE_UI_SOURCE||path.resolve(__dirname,'../../cikarim/soul-stone-window-fix/patched/Processors/Game/Lobby/Jade');
function method(file,name,params='',globals={}){
 const s=fs.readFileSync(path.join(root,file+'.as'),'utf8');let a=s.indexOf('function '+name+'(');assert(a>=0,name);a=s.indexOf('{',a);let b=a+1,d=1;
 while(d){d+=(s[b]==='{')-(s[b]==='}');b++;}
 const body=s.slice(a+1,b-1).replace(/var (\w+):[\w.<>]+/g,'var $1').replace(/ as \w+/g,'').replace(/= parseInt\(([^;]+)\);/g,'= (parseInt($1) || 0);');
 return vm.runInNewContext('(function('+params+'){'+body+'})',{int:x=>Number(x)|0,uint:x=>Number(x)>>>0,...globals});
}
const update=method('TJadeCombin','Update','',{STATE_READY:0,STATE_WAITBACK:1,CONST_SYSTEMLANGUAGE:{}});
for(const code of [0,3,4]){
 let effects=0,texts=0,resets=0;
 const ui={FCurrentState:1,FReplyReady:false,FRequestSent:true,FResultCode:code,FWaiting:true,FType:0,
  FSelectBox:{visible:true},FCombineEffect:{gotoAndPlay(){effects++;}},ResetCombineJade(){resets++;},ResetCombine(){},
  FFlyText(){texts++;},SetButton(){},UpdateBackpackJade(){}};
 update.call(ui);assert.equal(ui.FCurrentState,1);assert.equal(ui.FWaiting,true);assert.equal(ui.FRequestSent,true);assert.equal(effects+texts+resets,0,'Switch/refresh cannot consume a stale result');
 ui.FReplyReady=true;update.call(ui);assert.equal(ui.FCurrentState,0);assert.equal(ui.FRequestSent,false);assert.equal(ui.FWaiting,code===0);assert.equal(effects,code===0?1:0);
}
// Cancelling an auto-synthesize dialog is distinct from an actual sent request.
const confirm=method('TJadeCombin','PopTipOk','param1,param2',{STATE_WAITBACK:1});
let sent=0;const auto={FRequestSent:false,FReplyReady:false,FWaiting:true,FOnCombine(){sent++;}};
confirm.call(auto,null,4);assert.equal(sent,1);assert.equal(auto.FRequestSent,true);confirm.call(auto,null,4);assert.equal(sent,1);
const globals={STATE_READY:0,STATE_MOSAIC:1,STATE_UNQUITE:2,CONST_SYSTEMLANGUAGE:{},CONST_JADE:{MAX_HeroCount:8},SLogicsCore:{Character:{Heros:{Count:0}}},TJadeCommon:{ProcessorUpdateSlotsRenderingState(){}}};
const mosaicUpdate=method('TJadeMosaic','Update','',globals);
for(const state of [1,2]){
 let notices=0;const ui={FCurrentState:state,FReplyReady:false,FResultCode:0,FCurrentShowTagIndex:-1,FCurrentShowEquipment:null,FCurrentClickSingleEquip:null,
  FFlyText(){notices++;},UpdateHerosTag(){},OnSwitchTab(){},SetupHeroListPage(){},UpdateEquipmentJadeSlot(){},UpdateJadeRecommend(){},UpdateBackpackJade(){}};
 mosaicUpdate.call(ui);assert.equal(ui.FCurrentState,state);assert.equal(notices,0);
 ui.FReplyReady=true;mosaicUpdate.call(ui);assert.equal(ui.FCurrentState,0);assert.equal(notices,1);
}
let closed=0;const close=method('TProcessorWindowJade','OnCloseWindow','param1',{ProcessorWindowClose(){closed++;}});
const window={Visible:true,stage:null,Reset(){throw Error('reset regression');}};
assert.throws(()=>close.call(window,null),/reset regression/);assert.equal(window.Visible,false);assert.equal(closed,1,'Close notification survives a reset error');
const filter=method('TJadeCommon','GetSpecialJade','param1,param2,param3,param4',{SResourcesCore:{ResourceBin:{GetDatebase:(table,id)=>id===14500004?{}:null}},CONST_DATEBASEVO:{RESOURCEID_BaseStone:1}});
const rows=[null,{IDTemplate:14100698,Quantity:2,RequirementLevel:1,CategorySecond:95},{IDTemplate:14500004,Quantity:0,RequirementLevel:4,CategorySecond:1},{IDTemplate:14500004,Quantity:5,RequirementLevel:4,CategorySecond:1}];
const selected=[];filter({Count:rows.length,GetInventoryByIndex:i=>rows[i]},{Add:x=>selected.push(x)},-1,-1);assert.deepEqual(selected,[rows[3]]);
console.log('PASS Soul Stone window: no fake response on tab refresh, real reply recovery, auto-confirm deduplication, fail-safe close, valid/nonempty stone filtering. Executes frontend method bodies.');
