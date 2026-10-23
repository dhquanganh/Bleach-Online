const fs=require('node:fs'),assert=require('node:assert/strict'),vm=require('node:vm');
const path=require('node:path');
const base=path.resolve(__dirname,'../../cikarim/void-battle-loading');
const source=fs.readFileSync(path.join(base,'verify/scripts/Processors/Game/Battle/TBattleHandle.as'),'utf8');
function body(name){const start=source.indexOf('function '+name+'(');assert(start>=0);let p=source.indexOf('{',start),depth=1,i=p+1;for(;depth;i++){if(source[i]==='{')depth++;if(source[i]==='}')depth--;}return source.slice(p+1,i-1);}
for(const replay of [false,true])for(const type of [1,2]){
 const calls=[],loader={StartPlayerLoad(){calls.push('start')},set Visible(v){calls.push('visible:'+v)}};
 const ctx={FIsReplay:replay,FEnterType:type,FProcessorBattleLoading:loader,ProcessorOnLoadingCompleted(){calls.push('completed')},ProcessorOnCloseLoad(){calls.push('close')}};
 vm.runInNewContext('(function(){'+body('ProcessorStartBattleLoad')+'}).call(ctx)',{ctx,ENTER_TYPE_VIDEO:2,addChild(x){assert.equal(x,loader);calls.push('mount')}});
 assert.deepEqual(calls,replay&&type!==2?['completed','close']:['mount','start','visible:true']);
}
const init=body('InitBattleHandle');assert(init.indexOf('addChild(this.FProcessorBattleLoading)')>init.indexOf('new TProcessorBattleLoading'));
assert(init.indexOf('addChild(this.FProcessorBattleLoading)')<init.indexOf('this.FProcessorBattleLoading.Load()'));
const check=body('CheckResources');assert(check.indexOf('this.ProcessorStartBattleLoad()')<check.indexOf('this.ProcessorLoadResources()'));
assert(body('ProcessorBattleInfo').includes('addChild(this.FProcessorBattleLoading)'));
assert(body('ProcessorOnCloseLoad').includes('this.FProcessorBattleLoading.Reset()'));
console.log('PASS compiled battle loading: mounted before first load and asset requests, replay/video paths, overlay restored over new stage and native reset retained.');
