'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.resolve(__dirname,'../../cikarim/void-entry-constant/verify/scripts/Processors/Game/Battle/TBattleHandle.as'),'utf8');
let a=source.indexOf('{',source.indexOf('function LogicsPerform(')),p=a+1,n=1;for(;n;p++){if(source[p]==='{')n++;if(source[p]==='}')n--;}
const body=source.slice(a+1,p-1).replace('super.LogicsPerform();','');
const noop=()=>{};const globals={PulsePlaybackTimers:noop,UpdatePlaybackButton:noop,ENTER_TYPE_VOIDSOULWORLD:7,FAutoCloseBattle:false,FRMAE_INDEX_START:1,TEffectControl:{UpdataRoleEffect:noop,UpdataPublicEffect:noop,UpdataSpecialChainEffect:noop}};
const run=vm.runInNewContext('(function(){'+body+'})',globals);
function create(type){let started=0;const ctx={Visible:true,FEnterType:type,FVoidPlaybackStarted:false,FProcessorWindowWin:null,FProcessorWindowWinOrg:null,FKnifeOfKillSoulInforTip:null,FMC_BattleReady:{visible:true,currentFrame:1,totalFrames:100,gotoAndStop:noop,stop:noop},FBT_Skip:{},FIsCanSkip:false,VoidTrace:noop,FBattleStage:{StartBattle:()=>started++}};return {ctx,started:()=>started};}
for(const first of [85,86,99,100]){const t=create(7);t.ctx.FMC_BattleReady.currentFrame=first;run.call(t.ctx);run.call(t.ctx);t.ctx.FMC_BattleReady.currentFrame=100;run.call(t.ctx);assert.equal(t.started(),1,'starts exactly once even if timer misses cue at '+first);}
const before=create(7);before.ctx.FMC_BattleReady.currentFrame=84;run.call(before.ctx);assert.equal(before.started(),0);
const other=create(1);other.ctx.FMC_BattleReady.currentFrame=86;run.call(other.ctx);assert.equal(other.started(),0);other.ctx.FMC_BattleReady.currentFrame=85;run.call(other.ctx);assert.equal(other.started(),1,'other battle modes keep native trigger');
assert(source.includes('this.FVoidPlaybackStarted = false;'));
console.log('PASS compiled Void start cue: exact/skipped/last frames, no duplicate start, no early start, other battle paths retained.');
