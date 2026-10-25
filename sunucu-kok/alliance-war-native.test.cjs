'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path'),vm=require('node:vm');
const root=path.join(__dirname,'cikarim/alliance-war/verify/scripts/Processors/Game/Lobby/TeamBattle');
function method(file,name,globals={}){const source=fs.readFileSync(path.join(root,file),'utf8'),start=source.indexOf('function '+name+'('),brace=source.indexOf('{',start);assert.ok(start>=0);let depth=1,end=brace+1;while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}return vm.runInNewContext('('+source.slice(start,end).replace(/:\s*[\w.]+/g,'')+')',globals);}
test('compiled native Alliance main screen retains its original entry and bridges each working button',()=>{
 const source=fs.readFileSync(path.join(root,'TProcessorTeamBattle.as'),'utf8');assert.match(source,/this\.ProcessorEnterTeamBattleReq\(\)/);assert.match(source,/import flash\.external\.ExternalInterface;/,'Native button must resolve the Flash API instead of an undefined dynamic global');
 const calls=[],globals={ExternalInterface:{available:true,call:(...args)=>calls.push(args)}};
 const choose=fs.readFileSync(path.join(root,'TProcessorWindowTeamBattleChoose.as'),'utf8');
 assert.match(choose,/this\.FBtn_EnterPVE\.OnClick = this\.Btn_EnterPVEOnClick/);
 assert.match(source,/this\.FProcessorWindowTeamBattleChoose\.OnEnterHallPVE = this\.ProcessorOnEnterHallPVE/);
 method('TProcessorWindowTeamBattleChoose.as','Btn_EnterPVEOnClick').call({FOnEnterHallPVE:method('TProcessorTeamBattle.as','ProcessorOnEnterHallPVE',globals).bind({})},{},null);
 assert.deepEqual(calls.pop(),['openAllianceWar','campaign'],'Compiled Enter Campaign click must reach the launcher bridge');
 for(const [name,tab] of [['ProcessorOnEnterHallPVE','campaign'],['ProcessorOnEnterHallPVP','battle'],['ProcessorOnAutoPVP','auto'],['ProcessorOnMallHonor','shop']]){method('TProcessorTeamBattle.as',name,globals)({});assert.deepEqual(calls.pop(),['openAllianceWar',tab]);}
});
test('compiled native Auto-Battle follows real opening status and early status packets are safe before assets load',()=>{
 const update=method('TProcessorWindowTeamBattleChoose.as','Update'),set=method('TProcessorWindowTeamBattleChoose.as','SetPvpStatus');let refreshed=0;
 const target={FInitialization:false,FMC_TeamBattleChoose:{play(){}},FBtn_AutoPVP:{Enabled:false},FBtn_EnterPVP:{Enabled:false},FTeamBattle:{PvpStatus:true},ProcessorUpdateUI(){refreshed++;}};
 update.call(target);assert.equal(refreshed,0);target.FInitialization=true;update.call(target);assert.equal(target.FBtn_AutoPVP.Enabled,true);set.call(target,false);assert.equal(target.FBtn_AutoPVP.Enabled,false);assert.equal(target.FBtn_EnterPVP.Enabled,false);set.call(target,true);assert.equal(target.FBtn_AutoPVP.Enabled,true);assert.equal(target.FBtn_EnterPVP.Enabled,true);
});
