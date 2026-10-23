'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=process.env.SOUL_STONE_UI_SOURCE||path.resolve(__dirname,'../../cikarim/soul-stone-ui-audit/patched/Processors/Game/Lobby/Jade');
function method(file,name,params,globals={}){
 const s=fs.readFileSync(path.join(root,file+'.as'),'utf8');let a=s.indexOf('function '+name+'(');assert(a>=0);a=s.indexOf('{',a);let b=a+1,d=1;
 while(d){d+=(s[b]==='{')-(s[b]==='}');b++;}
 const body=s.slice(a+1,b-1).replace(/var (\w+):[\w.<>]+/g,'var $1').replace(/ as \w+/g,'').replace(/= parseInt\(([^;]+)\);/g,'= (parseInt($1) || 0);'); // AS int(NaN) == 0
 return vm.runInNewContext('(function('+params+'){'+body+'})',{int:x=>Number(x)|0,uint:x=>Number(x)>>>0,...globals});
}
const input=method('TJadeCombin','OnJadeCombineInputChange','param1');
for(const [max,text,expected] of [[4,'', '1'],[4,'99','4'],[4,'-1','1'],[0,'12','0'],[4,'2','2']]){
 const ui={FCombineMaxNum:max,FTF_CombineJadeNum:{text}};input.call(ui,null);assert.equal(ui.FTF_CombineJadeNum.text,expected);
}
const globals={STATE_READY:0,STATE_MOSAIC:1,STATE_UNQUITE:2};
for(const name of ['EquipmentJadeSlotClick','BackpackJadeSlotsOnClick']){
 const click=method('TJadeMosaic',name,'param1,param2',globals);
 for(const ui of [{FCurrentState:1,FCurrentShowEquipment:{}},{FCurrentState:0,FCurrentShowEquipment:null}])assert.doesNotThrow(()=>click.call(ui,null,{}));
 assert.doesNotThrow(()=>click.call({FCurrentState:0,FCurrentShowEquipment:{}},null,null));
}
for(const [name,callback] of [['PacketPerform_SC_JadeCombine','ApplyCombineResult'],['PacketPerform_SC_EquitJadeMount','ApplyMosaicResult'],['PacketPerform_SC_EquitJadeUnmount','ApplyMosaicResult']]){
 const calls=[];const ui={FProcessorWindowJade:{[callback](code){calls.push(code);}}};
 const fn=method('TProcessorJade',name,'param1',{EffectGenerateTextByErrorCode:code=>calls.push('error:'+code)});
 fn.call(ui,{Data:{readUnsignedByte:()=>4,readUnsignedInt:()=>4}});
 assert.deepEqual(calls,[4,'error:4'],'Errors unlock and update the requesting scene even when another tab is visible');
}
const cancel=method('TJadeCombin','PopTipBack','',{STATE_READY:0});
const ui={FWaiting:true,FCurrentState:1};cancel.call(ui);assert.equal(ui.FWaiting,false);assert.equal(ui.FCurrentState,0);
const sockets={CONST_JADE:{MAX_MosaicJadeCount:4},CAN_MOSAIC:1,LOCKED:2,MOSAICED:3};
const socketUI={FEquipmentJadeSlots:Array.from({length:4},()=>({Context:null})),FMC_EquipmentJadesLock:Array.from({length:4},()=>({gotoAndStop(){}})),FSingleEquipmentSlots:{}};
socketUI.SetSlotByEquipment=method('TJadeMosaic','SetSlotByEquipment','param1',sockets);
socketUI.UpdateEquipmentJadeSlot=method('TJadeMosaic','UpdateEquipmentJadeSlot','',sockets);
for(const count of [5,1,0]){
 socketUI.FCurrentShowEquipment={HoleQuantity:12,HoleAdditionalQuantity:0,GiftedStoneItems:{Count:count,GetGiftedStoneByIndex:i=>({id:i})}};
 socketUI.UpdateEquipmentJadeSlot();assert.equal(socketUI.FEquipmentJadeSlots.filter(x=>x.Context!==null).length,Math.min(4,count));
}
for(const [file,constant] of [['TJadeMosaic','MAX_JadeSlotCount'],['TJadeCombin','MAX_JadeCombineSlotCount']]){
 const refresh=method(file,'UpdateBackpackJade','',{CONST_JADE:{[constant]:4}});
 const ui={FPageIndex:9,FJadeLevelComboBoxSelectIndex:0,FJadeTypeComboBoxSelectIndex:0,FSelectJadeUsetoShow:{Count:1,Sort(){},GetInventoryByIndex(){return {id:1};}},SelectCanShowJade(){},SetupJadePage(){},FBackpackSlots:Array.from({length:4},()=>({Context:null}))};
 refresh.call(ui);assert.equal(ui.FPageIndex,0);assert(ui.FBackpackSlots[0].Context);
 ui.FSelectJadeUsetoShow.Count=0;refresh.call(ui);assert(ui.FBackpackSlots.every(x=>x.Context===null));
}
// Response failures must release the request guard; successful animation owns
// it until its final frame so animation completion cannot unlock a later request.
const update=method('TJadeCombin','Update','',{STATE_READY:0,STATE_WAITBACK:1,CONST_SYSTEMLANGUAGE:{}});
for(const code of [3,4]){
 const ui={FCurrentState:1,FResultCode:code,FWaiting:true,FType:0,FFlyText(){},SetButton(){},UpdateBackpackJade(){}};
 update.call(ui);assert.equal(ui.FWaiting,false);assert.equal(ui.FCurrentState,0);
}
console.log('PASS Soul Stone UI: input limits, empty slots, duplicate-request guards, error recovery, tab-safe replies, cancellation. Executes patched frontend method bodies.');
