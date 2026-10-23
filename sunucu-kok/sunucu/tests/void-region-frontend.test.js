'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=process.env.VOID_UI_SOURCE||path.resolve(__dirname,'../../cikarim/void-entry-constant/patched/Processors/Game/Lobby/VoidSoulWorld');
function method(file,name,params='',globals={}){
 const selected=path.join(root,file+'.as');
 const fallback=path.resolve(__dirname,'../../cikarim/void-entry-unblock/patched/Processors/Game/Lobby/VoidSoulWorld',file+'.as');
 const s=fs.readFileSync(fs.existsSync(selected)?selected:fallback,'utf8');let a=s.indexOf('function '+name+'(');assert(a>=0,name);a=s.indexOf('{',a);let b=a+1,d=1;
 while(d){d+=(s[b]==='{')-(s[b]==='}');b++;}
 const body=s.slice(a+1,b-1).replace(/var (\w+):[\w.<>]+/g,'var $1').replace(/ as [\w.<>]+/g,'');
 return vm.runInNewContext('(function('+params+'){'+body+'})',{int:x=>Number(x)|0,uint:x=>Number(x)>>>0,...globals});
}
assert(fs.readFileSync(path.join(root,'TProcessorVoidSoulWorld.as'),'utf8').includes('import Resources.Constants.CONST_BATTLE;'),'native battle constant must be imported; injecting a mock constant alone masks Flash #1065');
// Derive identifier order from native login deserialization, rather than assuming it.
const dependency=path.resolve(__dirname,'../../cikarim/void-entry-unblock/dependencies/scripts/Logics');
const coerce=fs.readFileSync(path.join(dependency,'Characters/TCharacter.as'),'utf8');
assert(/FIdentifier0 = param1;[\s\S]*?FIdentifier1 = param2;/.test(coerce));
const login=fs.readFileSync(path.join(dependency,'Streamization/Characters/TUnstreamizerCharacter.as'),'utf8');
assert(login.includes('_loc6_.Coerce(_loc4_,_loc5_)'));
assert(login.indexOf('_loc4_ = param1.readUnsignedInt()') < login.indexOf('_loc5_ = param1.readUnsignedInt()'));
let order=[];
const enter=method('TProcessorVoidSoulWorld','PacketPerform_SC_FightEnterRet','param1',{
 SLogicsCore:{Character:{Identifier0:5,Identifier1:8}},CONST_BATTLE:{BattleType_VoidSoulWorld:7},CONST_MUSIC:{ID_SCENE_OrganizationalWar:9},FIsResourcesLoadCompleted:true,EffectGenerateTextByErrorCode:code=>order.push('error:'+code)});
for(const [code,high,own] of [[0,5,true],[0,6,false],[1,5,false]]){
 order=[];let index=0;const packet={Data:{position:0,readUnsignedInt(){this.position+=4;return [code,high,8][index++];}}};
 const ui={FMainWin:{EntryPending:true,Visible:true,AddLast:front=>order.push('player:'+front)},FUnstreamizer:{FightEnterRet(){order.push('decode');return 2;}},FOnSetBattleStatus(...args){assert.equal(args[1],7);order.push('status');},FOnInitBattle(){order.push('battle');}};
 enter.call(ui,packet);assert.equal(ui.FMainWin.EntryPending,false);
 assert.deepEqual(order,code?['error:1']:own?['decode','player:2','status','battle']:['decode','player:2']);assert.equal(ui.FMainWin.Visible,!own);
}
const pointer=method('TProcessorVoidSoulWorldMainWin','OnBattlePointerClick','event');
for(let front=0;front<4;front++){
 const calls=[],ui={FMainUI:{},FFrontControllerList:Array.from({length:4},(_,i)=>({RequestFight(){calls.push(i);}}))};
 for(let i=0;i<4;i++)ui.FMainUI['MC_Pointer_'+i]={};let stopped=false;
 pointer.call(ui,{currentTarget:ui.FMainUI['MC_Pointer_'+front],stopImmediatePropagation(){stopped=true;}});assert.deepEqual(calls,[front]);assert(stopped);
}
const calls=[],role={Model:1234,RoleHead:5678};
const bossUpdate=method('TProcessorVoidSoulWorldMainWin','UpdateBossModel','',{
 SResourcesCore:{ResourceBin:{GetDatebase:(table,id)=>{assert.equal(id,123);return role;}},TexturesHeadIcon:{LoadAutoSecondary:id=>calls.push('head:'+id)}},CONST_DATEBASEVO:{RESOURCEID_RoleModel:1},CONST_MAP:{DIRECTION_RIGHT:1},TUtilityTexture:{QueryTwoDirectionShowCase(direction,model,info){assert.equal(model,1234);info.TextureID=77;info.Scalx=1;}}});
const ui={FServerBoss:{enemyId:999,roleId:123,hp:20000000000,revision:2},FRenderedBossRevision:0,FQureyMoudleInfor:{},FSpriteMoudle:{ChangeRoleMoudle:id=>calls.push('model:'+id)},FBossHead:{bitmapData:{}},FMonsterHead:{UpdateBoss:id=>calls.push('enemy:'+id)},FMainUI:{MC_BossHead:{}},SetServerBossName(){calls.push('name');}};
bossUpdate.call(ui);assert.equal(ui.FBossTotalHP,20000000000);assert.deepEqual(calls,['model:77','head:5678','enemy:999','name']);bossUpdate.call(ui);assert.equal(calls.length,4,'Same boss revision reuses model/head');
console.log('PASS Void frontend: all four clickable pointers, admission decode, own/other/error routing, native status-before-battle transition, server-selected model/head/HP and cached revision. Executes frontend bodies.');
