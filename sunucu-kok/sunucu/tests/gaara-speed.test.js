// Audit the installed AS3 expressions; simulated FPS is not a live benchmark.
'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const base=path.resolve(__dirname,'../../cikarim/gaara-swimsuit');
const role=fs.readFileSync(path.join(base,'verify/scripts/Processors/Game/Battle/Character/TRole.as'),'utf8');
const clock=fs.readFileSync(path.join(base,'speed-audit/scripts/Processors/Game/Battle/TBattleHandle.as'),'utf8');
function body(source,name){const start=source.indexOf('function '+name+'(');assert(start>=0,name);let p=source.indexOf('{',start),end=p+1,depth=1;for(;depth;end++){if(source[end]==='{')depth++;if(source[end]==='}')depth--;}return source.slice(p+1,end-1);}
const raw=fs.readFileSync(path.join(base,'speed-audit/source.swf'));const decoded=raw.subarray(0,3).toString()==='CWS'?Buffer.concat([raw.subarray(0,8),require('node:zlib').inflateSync(raw.subarray(8))]):raw;const offset=8+Math.ceil((5+4*(decoded[8]>>3))/8);const baseFps=decoded.readUInt16LE(offset)/256;
const setRate=body(clock,'SetPlaybackRate');
const ctx={FPlaybackClock:0,PlaybackTime:0,FPlaybackReal:0,getTimer:()=>1000,FPlaybackRate:1,FPlaybackActive:true,FPlaybackStage:{frameRate:baseFps},FPlaybackBaseFps:baseFps,value:2};
vm.runInNewContext(setRate,ctx);assert.equal(ctx.FPlaybackRate,2);assert.equal(ctx.FPlaybackStage.frameRate,baseFps*2);
ctx.value=1;vm.runInNewContext(setRate,ctx);assert.equal(ctx.FPlaybackStage.frameRate,baseFps);
const player=body(role,'PlayGaaraVfxAsset');const expression=player.match(/var elapsed:int = ([^;]+);/)[1];assert(expression.includes('caster.FFrameIndex'));assert(!expression.includes('getTimer'));
const manifest=JSON.parse(fs.readFileSync(path.join(base,'vfx.json'),'utf8'));const checks=[];
for(const key of manifest.effects.Yzwoailuo_aoyi){
 const length=manifest.clips[key].timeline.length;
 const elapsed=(frame)=>vm.runInNewContext(expression,{Math,caster:{FFrameIndex:frame},castFrame:0,delay:0});
 for(const fps of [baseFps,baseFps*2]){let frame=0;while(elapsed(frame)<length*40)frame++;const seconds=frame/fps;assert.equal(seconds,length/fps);checks.push({clip:key,deliveredFps:fps,seconds});}
 assert.equal(elapsed(42),1680); // Same actor frame always gives same effect pose, including after a stall.
}
assert(!player.includes('copyPixels'));
const result={installedClient:JSON.parse(fs.readFileSync(path.resolve(base,'../../kaynak/login.gogames.me/public/client-release.json'),'utf8')).version,actualFpsMeasured:false,swfHeaderFps:baseFps,configuredX1Fps:baseFps,configuredX2Fps:baseFps*2,checks,conclusion:'x2 is enabled through stage FPS; missed stage frames slow both actor and Gaara VFX. Live FPS is required to distinguish actual render stalls from atlas loading misses.'};
fs.writeFileSync(path.join(base,'speed-audit/result.json'),JSON.stringify(result,null,2)+'\n');
console.log('PASS installed speed toggle, native base/x2 FPS, both surf layers, frame sync, no per-frame bitmap copy');console.log(JSON.stringify(checks));
