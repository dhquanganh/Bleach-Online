'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),path=require('path'),vm=require('vm');
const root=path.join(__dirname,'cikarim/titles/verify/scripts/Processors/Game/Lobby/Achievement');
function method(file,name,globals){const source=fs.readFileSync(path.join(root,file),'utf8'),start=source.indexOf('function '+name+'('),brace=source.indexOf('{',start);let depth=1,end=brace+1;while(depth){if(source[end]==='{')depth++;if(source[end]==='}')depth--;end++;}const head=source.slice(start,brace).replace(/:\s*(?:Vector\.<[^>]+>|[\w.]+)/g,''),body=source.slice(brace,end).replace(/:\s*(?:Vector\.<[^>]+>|[\w.]+)/g,'');return vm.runInNewContext('('+head+body+')',{int:Number,uint:Number,Math,Number,...globals});}
function bytes(buffer){let p=0;return {readUnsignedShort(){const n=buffer.readUInt16BE(p);p+=2;return n;},readUnsignedInt(){const n=buffer.readUInt32BE(p);p+=4;return n;},readByte(){return buffer.readInt8(p++);},get position(){return p;}};}
function title(id){return {ID:id,IfGetTitle:false,AchievementInfor:{AchievementSchedules:[{Value:2,CurrentSchedule:0},{Value:3,CurrentSchedule:0}],Rewards:{Count:0}}};}
function context(titles){const equipped=[],data={Count:titles.length,GetAchievementByIndex:i=>({Title:titles[i]})},Character={AchievementData:data,CurrentEquipTitles:{Clear(){equipped.length=0;},Add(t){equipped.push(t);}}};const ctx={GotTitleByID:id=>titles.find(t=>t.ID===id),FProcessorWindowAchievement:{Update(){}},FOnChangeTitle:null};const globals={SLogicsCore:{Character},Visible:false};for(const name of ['ChangeCurrentEquipTitle','AddAlreadyGetAchievementTitle','PacketPerform_SC_AchievementTitleInforRet'])ctx[name]=method('TProcessorAchievement.as',name,globals);return {ctx,equipped};}
test('compiled frontend reads full ownership sync, clears stale flags and equips only server-supplied valid titles',()=>{
 const a=title(1),b=title(2);b.IfGetTitle=true;const {ctx,equipped}=context([a,b]);const {Y}=require('./sunucu/paket');const data=bytes(new Y().u16(1).u32(1).u16(1).u32(1).i8(0).u32(1234).done());ctx.PacketPerform_SC_AchievementTitleInforRet({Data:data});assert.equal(a.IfGetTitle,true);assert.equal(a.TargetTime,1234);assert.equal(b.IfGetTitle,false);assert.deepEqual(equipped,[a]);assert.equal(data.position,17);
});
test('compiled frontend skips unknown records without losing stream alignment; schedule totals reset for each title',()=>{
 const a=title(1),b=title(2),{ctx}=context([a,b]),{Y}=require('./sunucu/paket');const packet=new Y().u32(99).i8(0).u32(111).u32(1).i8(0).u32(222).u32(2).i8(1).u32(333).done(),data=bytes(packet);ctx.AddAlreadyGetAchievementTitle(data,3);assert.equal(data.position,packet.length);assert.equal(a.TargetTime,222);assert.equal(b.TargetTime,333);assert.equal(b.IfOverTime,true);assert.equal(a.AchievementInfor.CurrentSchedule,5);assert.equal(b.AchievementInfor.CurrentSchedule,5);
});
test('compiled frontend equip error returns before reading a success list or modifying current title',()=>{
 let changed=false,error;const fn=method('TProcessorAchievement.as','PacketPerform_SC_EquipAchievenmentTitleRet',{EffectGenerateTextByErrorCode:n=>error=n,Visible:false});const packet=Buffer.alloc(4);packet.writeUInt32BE(4);fn.call({ChangeCurrentEquipTitle(){changed=true;}},{Data:bytes(packet)});assert.equal(error,4);assert.equal(changed,false);
});
test('compiled frontend countdown clamps expiry instead of wrapping into a huge unsigned duration',()=>{
 const fn=method('TProcessorWindowTitle.as','UpdateLimitTime',{STimingCore:{ServerTick:1000},TUtilityTiming:{fomatTime:n=>String(n)}}),field={},t={IfTimeLimit:true,TargetTime:999};fn(field,t);assert.equal(field.text,'Expired');assert.equal(t.IfOverTime,true);fn(field,{IfTimeLimit:true,TargetTime:1060});assert.equal(field.text,'60');
});

test('compiled polling refreshes title expiry in the background and achievement progress only while viewing own panel',()=>{
 const requests=[],network={PacketAcquire:id=>({id}),Transceiver:{PacketTransmit:p=>requests.push(p.id)}},constants={PACKETID_CS_AchievenmentTitleInforReq:1,PACKETID_CS_AchievementInforReq:2};const fn=method('TProcessorAchievement.as','PollTitles',{SNetworkCore:network,CONST_NETWORK:constants,Visible:true});fn.call({FTitleReady:true,FShowOther:false},null);assert.deepEqual(requests,[1,2]);requests.length=0;fn.call({FTitleReady:true,FShowOther:true},null);assert.deepEqual(requests,[1]);
});
test('compiled other-player error is handled without trying to parse an absent profile',()=>{
 let error;const fn=method('TProcessorAchievement.as','PacketPerform_SC_OtherAchievenmentInforRet',{EffectGenerateTextByErrorCode:n=>error=n});const packet=Buffer.alloc(4);packet.writeUInt32BE(4);fn.call({},{Data:bytes(packet)});assert.equal(error,4);
});
