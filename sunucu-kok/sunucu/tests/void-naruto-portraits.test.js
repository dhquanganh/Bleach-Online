'use strict';
const fs=require('node:fs'),path=require('node:path'),vm=require('node:vm'),assert=require('node:assert/strict');
const source=fs.readFileSync(path.resolve(__dirname,'../../cikarim/void-naruto-bosses/verify/scripts/Processors/Game/Lobby/VoidSoulWorld/TProcessorMonsterHead.as'),'utf8');
function body(name){let p=source.indexOf('{',source.indexOf('function '+name+'(')),i=p+1,n=1;for(;n;i++){if(source[i]==='{')n++;if(source[i]==='}')n--;}return source.slice(p+1,i-1).replace(/\b(var\s+\w+)\s*:\s*\w+(?:\.<\w+>)?/g,'$1').replace(/\s+as\s+(TEnemy|TRoleModel)/g,'');}
for(const enemy of [null,{HeroIcon:11120970}]){
 const requests=[],ctx={SlotCount:0,FBtms:[{},{}],FMainUI:{MC_Slot_6:{}},FEnemyBins:{GetDatebaseByIdentifier:()=>enemy},FRoleModel:{GetDatebaseByIdentifier:id=>{assert.equal(id,11120970);return {RoleHead:123}}}};
 vm.runInNewContext('(function(enemyId){'+body('UpdateBoss')+'}).call(ctx,11120970)',{ctx,SResourcesCore:{TexturesHeadIcon:{LoadAutoSecondary:id=>requests.push(id)}}});
 assert.deepEqual(requests,[123]);
 const texture={GetAnimationSequenceByIndex:()=>({GetAnimationFrameByIndex:()=>({Surface:'portrait'})})};
 vm.runInNewContext('(function(param1,param2,param3){'+body('EnemyArmyPicArrive')+'}).call(ctx,null,texture,123)',{ctx,texture});
 assert.equal(ctx.FBtms[1].bitmapData,'portrait');
 ctx.FBtms[1].bitmapData=null;
 vm.runInNewContext('(function(param1,param2,param3){'+body('EnemyArmyPicArrive')+'}).call(ctx,null,texture,999)',{ctx,texture});
 assert.equal(ctx.FBtms[1].bitmapData,null);
}
console.log('PASS compiled Void boss portraits: Enemy and Naruto IDs, texture mount and stale head callback rejection.');
