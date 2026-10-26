'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=path.join(__dirname,'cikarim/alliance-war/verify/scripts/Processors/Game/Lobby/TeamBattle');
function method(file,name,globals={}){const source=fs.readFileSync(path.join(root,file),'utf8'),start=source.indexOf('function '+name+'('),brace=source.indexOf('{',start);assert.ok(start>=0);let depth=1,end=brace+1;while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}return vm.runInNewContext('('+source.slice(start,end).replace(/:\s*[\w.]+/g,'')+')',globals);}
test('compiled Alliance buttons use native halls, native room refresh and Honor Shop',()=>{
 const nativeRoot=path.join(__dirname,'cikarim/alliance-war/native-ui/verify/scripts/Processors/Game/Lobby/TeamBattle');
 const source=fs.readFileSync(path.join(nativeRoot,'TProcessorTeamBattle.as'),'utf8');
 assert.doesNotMatch(source,/openAllianceWar/);
 assert.match(source,/PacketAcquire\(CONST_NETWORK.PACKETID_CS_Enter_TeamBattle_PVE\)/);
 assert.match(source,/PacketAcquire\(CONST_NETWORK.PACKETID_CS_Enter_TeamBattle_PVP\)/);
 assert.match(source,/PacketAcquire\(25256720\)/);
 assert.match(source,/this.FProcessorHonorShop.Mount\(\)/);
 assert.match(source,/this.FProcessorRoom.RefreshRoom\(\)/);
 assert.match(source,/allianceWarNativeOpened/);
 assert.match(source,/allianceWarNativeClosed/);
 assert.match(fs.readFileSync(path.join(nativeRoot,'Room/TProcessorWindowRoom.as'),'utf8'),/PacketAcquire\(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_StartBattlePVE\)/);
});
test('compiled native Auto-Battle follows real opening status and early status packets are safe before assets load',()=>{
 const update=method('TProcessorWindowTeamBattleChoose.as','Update'),set=method('TProcessorWindowTeamBattleChoose.as','SetPvpStatus');let refreshed=0;
 const target={FInitialization:false,FMC_TeamBattleChoose:{play(){}},FBtn_AutoPVP:{Enabled:false},FBtn_EnterPVP:{Enabled:false},FTeamBattle:{PvpStatus:true},ProcessorUpdateUI(){refreshed++;}};
 update.call(target);assert.equal(refreshed,0);target.FInitialization=true;update.call(target);assert.equal(target.FBtn_AutoPVP.Enabled,true);set.call(target,false);assert.equal(target.FBtn_AutoPVP.Enabled,false);assert.equal(target.FBtn_EnterPVP.Enabled,false);set.call(target,true);assert.equal(target.FBtn_AutoPVP.Enabled,true);assert.equal(target.FBtn_EnterPVP.Enabled,true);
});
