'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const root=path.resolve(__dirname,'../../cikarim/susano-team-fix');
const source=fs.readFileSync(path.join(root,'verify/scripts/Processors/Game/Battle/TBattleHandle.as'),'utf8');
function body(text,name){let a=text.indexOf('{',text.indexOf('function '+name+'(')),p=a+1,n=1;for(;n;p++){if(text[p]==='{')n++;if(text[p]==='}')n--;}return text.slice(a+1,p-1).replace(/var (\w+):[\w.<>]+/g,'var $1');}
const constants={COMMON_EffectVect:[],RESOURCE_Battle:1,Public_Effect_AngerRing:2,BattlePetEffectId:3,Effect_CITYDEFEND_BOOM:4};
['FightIdle','Attack','Skill','Attacked','Run'].forEach((name,i)=>constants['RESOURCE_ActiveType_'+name]=(10+i).toString(16).padStart(2,'0'));
for(const [type,id,initialized] of [[1,15101001,false],[1,15101002,true],[7,0,true],[2,0,true],[3,0,true],[4,0,true]]){
 const loaded=[],events=[];const repo={LoadPrimary:()=>{},LoadSecondary:()=>{}};
 const run=vm.runInNewContext('(function(){'+body(source,'ProcessorLoadResources')+'})',{uint:x=>Number(x)>>>0,CONST_BATTLE:constants,ENTER_TYPE_NODAL:1,ENTER_TYPE_CITYDEFEND:2,ENTER_TYPE_REPLAY:3,ENTER_TYPE_VIDEO:4,SLogicsCore:{Nodal:{GetMissionStarByID:()=>0}},SResourcesCore:{TexturesSwfBattle:repo,TexturesSkill:repo,TexturesLargeIcon:repo,TexturesBackgroundIcon:repo,TexturesModel:{LoadPrimary:id=>{loaded.push(id);events.push('model')}}}});
 const models=[11120930,11120950,11120970];run.call({FIsInitialization:initialized,FEnterType:type,FEnterId:id,FModelVect:models,FLargeVect:[],FSkillVect:[],FBackgroundVect:[],Load:()=>events.push('load')});
 for(const model of models)for(let seq=10;seq<=14;seq++)assert(loaded.includes((model*256+seq)>>>0),'all native sequences ready: '+model+'/'+seq);
 assert.equal(loaded.length,15);assert.equal(events[events.length-1],'load');
}
const active=fs.readFileSync(path.join(root,'dependencies/scripts/Processors/Game/Battle/Character/TActive.as'),'utf8');
const play=vm.runInNewContext('(function(){'+body(active,'PlaySkill')+'})',{uint:x=>Number(x)>>>0,TYPE_ACTIVE_SKILL:1});
const context={FId:11120970,FSkillId:13121309,FTextureSkill:{Count:7,GetAnimationSequenceByIndex:index=>{assert.equal(index,6);return 'original-susano';}}};play.call(context);assert.equal(context.FCurSequence,'original-susano');
console.log('PASS compiled model preload across tutorial, later battles, Void, City Defend and replay/video; native Susano sequence 6 retained.');
