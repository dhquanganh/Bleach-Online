"""Patch tournament requests, stale state, reward slots and local battle replay."""
from pathlib import Path
BASE=Path(__file__).resolve().parent
ROOT=BASE/'original/scripts';OUT=BASE/'patched'
def edit(name,changes,root=ROOT):
 text=(root/name).read_text(encoding='utf-8')
 for a,b in changes:
  assert a in text,(name,a)
  text=text.replace(a,b)
 p=OUT/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
data='Logics/KingChallenge/TKingChallenge.as'
edit(data,[('protected var FPlayerNames','public static var RequestPending:Boolean = false;\n      protected var FPlayerNames'),('_loc1_[this.FPlayersInfo[_loc3_].Position] = this.FPlayersInfo[_loc3_].UserName;','if(this.FPlayersInfo[_loc3_].Position < 8) _loc1_[this.FPlayersInfo[_loc3_].Position] = this.FPlayersInfo[_loc3_].UserName;')])
stream='Logics/Streamization/KingChallenge/TUnsteamizerKingChallenge.as'
edit(stream,[
 ('this.FData.PlayersInfo.length = 0;','this.FData.PlayersInfo.length = 0;\n         this.FData.FightsInfo.length = 0;'),
 ('this.FData.SeasonStatus = param1.readUnsignedInt();','this.FData.BettingsInfo.length = 0;\n         this.FData.SeasonStatus = param1.readUnsignedInt();'),
 ('_loc4_.AttUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).AttUserInfo;','if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null) _loc4_.AttUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).AttUserInfo;'),
 ('_loc4_.DefUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).DefUserInfo;','if(this.FData.FindFightInfoById(_loc4_.FighterNum) != null) _loc4_.DefUserInfo = this.FData.FindFightInfoById(_loc4_.FighterNum).DefUserInfo;'),
 ('this.FData.UserBaseInfo.Group = param1.readByte();','this.FData.UserBaseInfo.Group = param1.readUnsignedByte() * 1000;'),
 ('this.BaseReq();','if(param1.bytesAvailable >= 4)\n         {\n            var roundStart:uint = param1.readUnsignedInt();\n            for each(var fight:TFighterInfo in this.FData.FightsInfo) fight.GambleTimeEnd = roundStart + (fight.FightNum % 1000 < 4 ? 0 : (fight.FightNum % 1000 < 6 ? 300 : 600));\n         }\n         this.BaseReq();'),
 ('_loc2_ = 4;','_loc2_ = 1;'),
 ('_loc4_.Data.writeInt(_loc3_ + 1);','_loc4_.Data.writeInt(param1 >= 1000 ? param1 / 1000 : param1);')])
processor='Processors/Game/Lobby/KingChallenge/TProcessorKingChallenge.as'
edit(processor,[
 ('import Resources.Constants.CONST_NETWORK;','import Resources.Constants.CONST_NETWORK;\n   import Resources.Constants.CONST_BATTLE;'),
 ('protected var FInited:Boolean;','protected var FInited:Boolean;\n      public var OnInitBattle:Function;\n      public var OnSetBattleStatus:Function;'),
 ('override protected function PacketRegisterRoutines() : void','override protected function ResourcesPerform_UIFinalize() : void\n      {\n         super.ResourcesPerform_UIFinalize();\n         this.FUnstreamizer.InitReq(this.FMainWin.CurGroup / 1000);\n         this.FUnstreamizer.FightReq(this.FMainWin.CurGroup / 1000);\n         this.FUnstreamizer.RankReq(this.FMainWin.CurGroup / 1000);\n      }\n      \n      override protected function PacketRegisterRoutines() : void'),
 ('FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_InitRet','FPacketRoutines.Register(0x01188a09,this.PacketPerform_Replay);\n         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_InitRet'),
 ('_loc2_ = param1.Data.readUnsignedInt();','TKingChallenge.RequestPending = false;\n         _loc2_ = param1.Data.readUnsignedInt();'),
 ('protected function ShutDownWindows() : void','protected function PacketPerform_Replay(packet:TPacket) : void\n      {\n         TKingChallenge.RequestPending = false;\n         var code:uint = packet.Data.readUnsignedInt();\n         if(code != 0) { EffectGenerateTextByErrorCode(code); return; }\n         if(this.OnSetBattleStatus != null) this.OnSetBattleStatus(this,CONST_BATTLE.BattleType_KingChallenge,0);\n         if(this.OnInitBattle != null) this.OnInitBattle(this);\n      }\n      \n      protected function ShutDownWindows() : void'),
 ('this.FUnstreamizer.InitReq(this.FMainWin.CurGroup);','this.FUnstreamizer.InitReq(this.FMainWin.CurGroup / 1000);'),
 ('this.FUnstreamizer.RankReq(this.FMainWin.CurGroup);','this.FUnstreamizer.RankReq(this.FMainWin.CurGroup / 1000);')])
window='Processors/Game/Lobby/KingChallenge/TProcessorWindowKingChallenge.as'
edit(window,[
 ('protected var FCurGroup:uint;','protected var FCurGroup:uint;\n      protected var FNextRefresh:int = 0;'),
 ('this.FCurGroup = (_loc2_ + 1) * 1000;','this.FCurrentPage = 0;\n         this.FDetailWin.Visible = false;\n         this.FGamlbeWin.Visible = false;\n         this.FCurGroup = (_loc2_ + 1) * 1000;'),
 ('_loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_UploadReq);','if(TKingChallenge.RequestPending || this.FData.SeasonStatus != 0) return;\n         TKingChallenge.RequestPending = true;\n         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_UploadReq);'),
 ('this.FData.UserBaseInfo.Group = this.FCurGroup;','if(this.FData.UserBaseInfo.Group == 0) this.FData.UserBaseInfo.Group = this.FCurGroup;'),
 ('this.FMainScene["KilledFlag"].visible = true;','this.FMainScene["KilledFlag"].visible = false;'),
 ('this.FMainScene["Name"].text = "";','this.FMainScene["Name"].text = "Chờ quán quân";'),
 ('FightNum - this.FCurGroup < 8','FightNum - this.FCurGroup < 7'),
 ('if(this.FData.FightsInfo[_loc2_].AttUserInfo != null)','if(this.FData.FightsInfo[_loc2_].AttUserInfo != null && this.FData.FightsInfo[_loc2_].DefUserInfo != null)'),
 ('_loc3_ = _loc4_.RoleHead;','if(_loc4_ == null) continue;\n                        _loc3_ = _loc4_.RoleHead;'),
 ('this.FDetailWin.LogicsPerform();','if(STimingCore.ServerTick >= this.FNextRefresh && !TKingChallenge.RequestPending)\n            {\n               this.FNextRefresh = STimingCore.ServerTick + 10;\n               this.FUnstreamizer.InitReq(this.FCurGroup / 1000);\n               this.FUnstreamizer.FightReq(this.FCurGroup / 1000);\n               this.FUnstreamizer.RankReq(this.FCurGroup / 1000);\n            }\n            this.FDetailWin.LogicsPerform();'),
 ('this.FPageUI.PageSize = 5;\n         this.FPageUI.TotalQuantity','this.FCurrentPage = Math.max(0,Math.min(this.FCurrentPage,Math.ceil(this.FData.RankData.length / 5) - 1));\n         this.FPageUI.PageSize = 5;\n         this.FPageUI.TotalQuantity'),
 ('this.FData = param1;\n         this.FUnstreamizer','this.FData = param1;\n         if(this.FMainScene == null) return;\n         this.FUnstreamizer'),
 ('this.UpdateUI();\n         this.FGamlbeWin.Data','this.UpdateUI();\n         this.UpdateLine();\n         this.FBtn_UpLoad.Enabled = this.FData.SeasonStatus == 0 && !TKingChallenge.RequestPending;\n         if(this.FDetailWin.Visible && this.FData.FindFightInfoById(this.FCurFight) != null) this.FDetailWin.Data = this.FData.FindFightInfoById(this.FCurFight);\n         this.FGamlbeWin.Data'),
 ('this.FMC_ButtonBar.gotoAndPlay(1);','this.FMC_ButtonBar.gotoAndStop(this.FMC_ButtonBar.totalFrames);')])
detail='Processors/Game/Lobby/KingChallenge/TUIDetail.as'
edit(detail,[
 ('         this.Btn_Close = new TUIButton();\n         this.Btn_Close.Substrate = this.FMain["Btn_Close"];\n         this.Btn_Close.OnClick = this.ProcessorHide;',''),
 ('this.FMain = param1;\n         addChild(this.FMain);','this.FMain = param1;\n         addChild(this.FMain);\n         this.Btn_Close = new TUIButton();\n         this.Btn_Close.Substrate = this.FMain["Btn_Close"];\n         this.Btn_Close.OnClick = this.ProcessorHide;'),
 ('import Logics.KingChallenge.TFighterInfo;','import Logics.KingChallenge.TFighterInfo;\n   import Logics.KingChallenge.TKingChallenge;'),
 ('this.Reset();','this.Reset();\n         if(this.FData == null || this.FData.AttUserInfo == null || this.FData.DefUserInfo == null)\n         {\n            this.FBtn_CheckReport.Enabled = false;\n            this.FBtn_Ok.Enabled = false;\n            this.FBtn_Ok1.Enabled = false;\n            return;\n         }'),
 ('this.FBtn_CheckReport.Enabled = true;','this.FBtn_CheckReport.Enabled = this.FData.Report.length > 0;'),
 ('this.FBtn_Ok.Enabled = true;','this.FBtn_Ok.Enabled = STimingCore.ServerTick < this.FData.GambleTimeEnd && !TKingChallenge.RequestPending;'),
 ('this.FBtn_Ok1.Enabled = true;','this.FBtn_Ok1.Enabled = STimingCore.ServerTick < this.FData.GambleTimeEnd && !TKingChallenge.RequestPending;'),
 ('_loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingReq);','if(TKingChallenge.RequestPending || this.FData.Ret != -1 || STimingCore.ServerTick >= this.FData.GambleTimeEnd) return;\n         TKingChallenge.RequestPending = true;\n         this.FBtn_Ok.Enabled = false; this.FBtn_Ok1.Enabled = false;\n         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingReq);'),
 ('SExternalCore.NavigateToBattleReportUrl(this.FData.Report);','if(TKingChallenge.RequestPending || this.FData.Report.length == 0) return;\n         TKingChallenge.RequestPending = true;\n         var packet:TPacket = SNetworkCore.PacketAcquire(0x01818a09);\n         packet.Data.writeUTF(this.FData.Report);\n         SNetworkCore.Transceiver.PacketTransmit(packet);')])
gamble='Processors/Game/Lobby/KingChallenge/TUIMyGamble.as'
edit(gamble,[
 ('import Logics.KingChallenge.TBettingInfo;','import Logics.KingChallenge.TBettingInfo;\n   import Logics.KingChallenge.TKingChallenge;'),
 ('this.FBtns_Get[_loc1_].Visible = this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].RewardStatus == 0 ? true : false;','this.FBtns_Get[_loc1_].Visible = this.FBtns_Get[_loc1_].Enabled && this.FData[ITEM_MAX * this.FCurrentPage + _loc1_].RewardStatus == 0;\n               this.FBtns_Get[_loc1_].Enabled = this.FBtns_Get[_loc1_].Visible && !TKingChallenge.RequestPending;'),
 ('_loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingAwardReq);','if(TKingChallenge.RequestPending) return;\n         TKingChallenge.RequestPending = true;\n         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BettingAwardReq);'),
 ('this.FData = param1;','this.FData = param1;\n         this.FCurrentPage = Math.max(0,Math.min(this.FCurrentPage,Math.ceil(this.FData.length / ITEM_MAX) - 1));')])
prize='Processors/Game/Lobby/KingChallenge/TUIPrizeList.as'
text=(ROOT/prize).read_text(encoding='utf-8')
start=text.index('         this.FBtn_Get.Enabled =');end=text.index('\n      }',start)
old=text[start:end]
new='''         this.FBtn_Get.Enabled = this.FData.AwardStatus == 0;
         this.FBtn_Get.Visible = this.FData.AwardStatus == 0;
         this.FMain["ReciveFlag"].visible = this.FData.AwardStatus == 1;
         for(var rank:uint = 0; rank < 4; rank++)
         {
            var prizes:TInventories = new TInventories();
            var ids:Object = TUtilityLobby.GetConfigValue(61900009 + this.FData.Group / 1000 - 1);
            SToolReward.GetAwardsByAwardID(ids[rank],prizes);
            for(var column:uint = 0; column < 4; column++)
               this.FSlots[rank * 4 + column].Context = column < prizes.Count ? prizes.GetInventoryByIndex(column) : null;
         }'''
edit(prize,[(old,new),('import Logics.KingChallenge.TUserBaseInfo;','import Logics.KingChallenge.TUserBaseInfo;\n   import Logics.KingChallenge.TKingChallenge;'),('_loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BoxAwardReq);','if(TKingChallenge.RequestPending || this.FData.AwardStatus != 0) return;\n         TKingChallenge.RequestPending = true;\n         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_KingChallenge_BoxAwardReq);')])
edit('Processors/Game/Lobby/TProcessorLobby.as',[
 ('this.FMountPointShortcuts.Visible = _loc1_;','this.FMountPointShortcuts.Visible = _loc1_ && this.FProcessorPlateActive != this.FProcessorKingChallenge;\n         this.FMountPointShortcutsSpecial.Visible = _loc1_ && this.FProcessorPlateActive != this.FProcessorKingChallenge;\n         this.FMountPointIcons.Visible = _loc1_ && this.FProcessorPlateActive != this.FProcessorKingChallenge;'),
 ('this.FProcessorEffect.ImportUserAutomaticallyFind(param2);','this.FProcessorEffect.ImportUserAutomaticallyFind(param2 && this.FProcessorPlateActive != this.FProcessorKingChallenge);'),
 ('this.FProcessorPlateActive = param1;','this.FProcessorPlateActive = param1;\n         if(param1 == this.FProcessorKingChallenge) this.FProcessorEffect.ImportUserAutomaticallyFind(false);'),
 ('this.FProcessorPlateActive.ChatOptionsSetup(this.FChatOptions);','this.FProcessorPlateActive.ChatOptionsSetup(this.FChatOptions);\n            if(this.FProcessorPlateActive == this.FProcessorKingChallenge) this.FChatOptions.ChatStatus = CONST_CHAT.MODE_None;'),
 ('this.FProcessorKingChallenge.OnEnterTown = this.ProcessorsOnReturnTown;','this.FProcessorKingChallenge.OnEnterTown = this.ProcessorsOnReturnTown;\n         this.FProcessorKingChallenge.OnInitBattle = this.ProcessorLobbyOnInitBattle;\n         this.FProcessorKingChallenge.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;'),
 ('case CONST_BATTLE.BattleType_ExpDuplicate:','case CONST_BATTLE.BattleType_KingChallenge:\n               this.ProcessorPlateSwitch(this.FProcessorKingChallenge);\n               break;\n            case CONST_BATTLE.BattleType_ExpDuplicate:')],BASE/'lobby-original/scripts')
print('Tournament client patches prepared')
