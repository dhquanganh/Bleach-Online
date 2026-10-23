'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const base=path.resolve(__dirname,'../../cikarim/void-loading-reference/verify/scripts');
function body(file,name){const source=fs.readFileSync(path.join(base,file),'utf8');let p=source.indexOf('{',source.indexOf('function '+name+'(')),i=p+1,n=1;for(;n;i++){if(source[i]==='{')n++;if(source[i]==='}')n--;}return source.slice(p+1,i-1).replace(/\b(var\s+\w+)\s*:\s*\w+(?:\.<\w+>)?/g,'$1');}
const moduleFile='Processors/Game/Lobby/ModuleLoader/TProcessorModuleLoader.as';
const progress=body(moduleFile,'LogicsPerform_ProgressPercentage'),start=body(moduleFile,'PerformTweenOperOnStart');
for(const pending of [0,5]){
 let deactivated=0;const ctx={Visible:true,FMax:12,FCurrent:3};const env={ctx,TBattleHandle:{VoidResourceLoading:true},BarrierDeactuate:()=>deactivated++,SResourcesCore:{PrimaryCount:pending,PrimaryPercentage:50}};
 vm.runInNewContext('(function(){'+progress+'}).call(ctx)',env);assert.equal(ctx.Visible,false);assert.equal(ctx.FMax,0);assert.equal(deactivated,1);
 vm.runInNewContext('(function(param1){'+start+'}).call(ctx,null)',env);assert.equal(ctx.Visible,false);
}
const native=fs.readFileSync(path.join(base,'Processors/Game/Battle/TProcessorBattleLoading.as'),'utf8');assert(native.includes('RESOURCESID_SwfVital_BattleLoading'));assert(native.includes('RESOURCE_ClassName_MC_BattleLoad'));assert(!body('Processors/Game/Battle/TProcessorBattleLoading.as','ResourcesPerform_UIWait').includes('SResourcesCore.Loading'));
const handle=fs.readFileSync(path.join(base,'Processors/Game/Battle/TBattleHandle.as'),'utf8');assert(handle.includes('VoidResourceLoading = param1 && this.FEnterType == ENTER_TYPE_VOIDSOULWORLD'));assert(body('Processors/Game/Battle/TBattleHandle.as','ProcessorOnCloseLoad').includes('VoidResourceLoading = false'));
console.log('PASS compiled Void loading: native resource/screen, generic progress and delayed tween suppressed, completion releases suppression, secondary downloads do not block UI.');
