package Processors.Game.Lobby.GongFuFight
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.GongFuFight.*;
   import Logics.Streamization.GongFuFight.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorPlateGongFuFight extends TProcessorLobbyPlate
   {
      
      public static var FightPending:Boolean = false;
      
      protected var FReplay:Boolean = false;
      
      protected var FWindowMainUI:TWindowMainUI;
      
      protected var FBoundMainUI:TBounds;
      
      protected var FGongFuData:TGongFuFightData;
      
      protected var FUnstreamizerGongFuFight:TUnstreamizerGongFuFight;
      
      protected var FOnReturnMainScene:Function;
      
      protected var FOnSendMessageToWindow:Function;
      
      protected var FOnOpenGongFuFightWindow:Function;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FBattleBack:Boolean;
      
      protected var FOnSetBattlePacket:Function;
      
      protected var FOnOpenTokenShop:Function;
      
      protected var FOnOpenStoneShop:Function;
      
      protected var FBattleType:int;
      
      protected var FTargetIndex:uint;
      
      public function TProcessorPlateGongFuFight(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowMainUI = new TWindowMainUI(this);
         this.FWindowMainUI.OnClose = this.ProcessorWindowOnClose;
         this.FBoundMainUI = new TBounds();
         this.FGongFuData = SLogicsCore.GongFuFightData;
         this.FUnstreamizerGongFuFight = new TUnstreamizerGongFuFight();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFight);
         this.FWindowMainUI.GongFuData = this.FGongFuData;
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_ApplyRet,this.PacketPerform_SC_ApplyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_FightRet,this.PacketPerform_SC_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_PayRet,this.PacketPerform_SC_GongFuFightPay);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_RankInforRet,this.PacketPerform_SC_GongFuFightRankInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_ChallengeListRet,this.PacketPerform_SC_GongFuFight_ChallengeListRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_BaseInforRet,this.PacketPerform_SC_GongFuFightBaseInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_ResetNotify,this.PacketPerform_SC_GongFuFightResetNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_PayRecordRet,this.PacketPerform_SC_GongFuFightPayRecord);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_AddFightTimeRet,this.PacketPerform_SC_GongFuFightAddFightTime);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_TryInRet,this.PacketPerform_SC_GongFuFightTryIn);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_OpenBeyondLevelFightRet,this.PacketPerform_SC_GongFuFightOpenBeyondLevelFight);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_SeasonInforRet,this.PacketPerform_SC_SeasonInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_FightRecordRet,this.PacketPerform_SC_FightRecordRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_UpdateFightRecord,this.PacketPerform_SC_UpdateFightRecord);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_GongFuFight_ReciveBox,this.PacketPerform_SC_FightReviveBox);
      }
      
      protected function PacketPerform_SC_ApplyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc2_ = param1.Data.readUnsignedInt();
         FightPending = false;
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_17);
         EffectGenerateText(_loc3_);
         this.FGongFuData.GongFuFightBaseInfor.IfApplyToday = true;
         if(Visible)
         {
            this.FWindowMainUI.ApplySuccess();
         }
         else if(this.FOnSendMessageToWindow != null)
         {
            this.FOnSendMessageToWindow(this,CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_Apply,null);
         }
      }
      
      protected function PacketPerform_SC_FightRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = param1.Data.readUnsignedInt();
         FightPending = false;
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FBattleType = _loc3_.readByte();
         this.FReplay = this.FBattleType == 2;
         this.FTargetIndex = _loc3_.readUnsignedInt();
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_GongFuFight,CONST_MUSIC.ID_SCENE_GongFuFight);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
            FightPending = true;
         }
      }
      
      protected function PacketPerform_SC_GongFuFightPay(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_16);
         EffectGenerateText(_loc3_);
         if(this.FOnSendMessageToWindow != null)
         {
            this.FOnSendMessageToWindow(this,CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_Pay,null);
         }
         if(Visible)
         {
            this.FWindowMainUI.PaySuccess();
         }
         this.PayRecordInforReq();
      }
      
      protected function PacketPerform_SC_GongFuFightRankInfor(param1:TPacket) : void
      {
         this.FGongFuData.GongFuFightRankEffectNum = 0;
         this.FGongFuData.GongFuFightRankInfors.length = 0;
         this.FUnstreamizerGongFuFight.UnstreamizationPerformRankInfor(param1.Data,this.FGongFuData,null);
         if(this.FOnSendMessageToWindow != null)
         {
            this.FOnSendMessageToWindow(this,CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_RankRecord,null);
         }
      }
      
      protected function PacketPerform_SC_GongFuFight_ChallengeListRet(param1:TPacket) : void
      {
         var diagnostic:TPacket;
         this.FGongFuData.PlayerNormalGroups.length = 0;
         this.FGongFuData.PlayerSuperLevelGroups.length = 0;
         try
         {
            this.FUnstreamizerGongFuFight.UnstreamizationPerformChallengeList(param1.Data,this.FGongFuData,null);
         }
         catch(error:Error)
         {
            diagnostic = SNetworkCore.PacketAcquire(25293569);
            diagnostic.Data.writeUTF("CrossList " + error.toString() + " " + error.getStackTrace());
            SNetworkCore.Transceiver.PacketTransmit(diagnostic);
            this.FGongFuData.Inited = false;
            throw error;
         }
         this.SetPlayerType(this.FGongFuData.PlayerNormalGroups,CONST_GONGFUFIGHT.GongFuFightPlayerType_Normal);
         this.SetPlayerType(this.FGongFuData.PlayerSuperLevelGroups,CONST_GONGFUFIGHT.GongFuFightPlayerType_SuperLevel);
         this.ReCountChallengeLisPlayerState(this.FGongFuData.PlayerNormalGroups);
         this.FGongFuData.Inited = true;
         if(!FIsResourcesLoadCompleted || !this.Visible)
         {
            return;
         }
         this.FWindowMainUI.Visible = true;
         this.FWindowMainUI.Update();
         this.FWindowMainUI.OpenView();
      }
      
      protected function ReCountChallengeLisPlayerState(param1:Vector.<TGongFuFightPlayerGroup>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TGongFuFightPlayerGroup = null;
         var _loc7_:TGongFuFightPlayerInfor = null;
         var _loc8_:Boolean = true;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc5_ = int(_loc6_.PlayersInfor.length);
            if(!_loc8_)
            {
               break;
            }
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_ = _loc6_.PlayersInfor[_loc4_];
               if(_loc7_.State != CONST_GONGFUFIGHT.PlayerState_Killed)
               {
                  _loc7_.State = CONST_GONGFUFIGHT.PlayerState_CanChallenge;
                  _loc8_ = false;
               }
               _loc4_++;
            }
            _loc2_++;
         }
      }
      
      protected function ChallengeListTest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = new ByteArray();
         _loc1_ = 0;
         while(_loc1_ < 18)
         {
            _loc3_.writeInt(_loc1_);
            TUtilityString.FlushUTF(_loc3_,"PlayerName:" + _loc1_);
            TUtilityString.FlushUTF(_loc3_,"ServerName:" + _loc1_);
            _loc3_.writeUnsignedInt(11100001 + _loc1_ % 6);
            _loc3_.writeShort(0);
            _loc3_.writeUnsignedInt(_loc1_);
            _loc3_.writeUnsignedInt(_loc1_ % 5);
            _loc3_.writeUnsignedInt(_loc1_ + 1000);
            _loc3_.writeUnsignedInt(0);
            _loc3_.writeUnsignedInt(2000153);
            _loc3_.writeUnsignedInt(_loc1_ + 1000000);
            _loc3_.writeByte(CONST_GONGFUFIGHT.PlayerState_Safe);
            _loc1_++;
         }
         _loc3_.position = 0;
         this.FGongFuData.PlayerNormalGroups.length = 0;
         this.FUnstreamizerGongFuFight.UnstreamizationPerformChallengeList(_loc3_,this.FGongFuData.PlayerNormalGroups,CONST_GONGFUFIGHT.GroupsPlayerNum);
         this.FUnstreamizerGongFuFight.UnstreamizationPerformLayerAward(null,this.FGongFuData,null);
         this.ReCountChallengeLisPlayerState(this.FGongFuData.PlayerNormalGroups);
         _loc1_ = 0;
         while(_loc1_ < 12)
         {
            _loc3_.writeInt(_loc1_);
            TUtilityString.FlushUTF(_loc3_,"PlayerName:" + _loc1_);
            TUtilityString.FlushUTF(_loc3_,"ServerName:" + _loc1_);
            _loc3_.writeUnsignedInt(11100001 + _loc1_ % 6);
            _loc3_.writeShort(0);
            _loc3_.writeUnsignedInt(_loc1_);
            _loc3_.writeUnsignedInt(_loc1_ % 5);
            _loc3_.writeUnsignedInt(_loc1_ + 1000);
            _loc3_.writeUnsignedInt(0);
            _loc3_.writeUnsignedInt(2000153);
            _loc3_.writeUnsignedInt(_loc1_ + 1000000);
            _loc3_.writeByte(2);
            _loc3_.writeUnsignedInt(2000153);
            _loc1_++;
         }
         _loc3_.position = 0;
         this.FGongFuData.PlayerSuperLevelGroups.length = 0;
         this.FUnstreamizerGongFuFight.UnstreamizationPerformChallengeList(_loc3_,this.FGongFuData.PlayerSuperLevelGroups,CONST_GONGFUFIGHT.GroupsSuperLevelPlayerNum);
      }
      
      protected function PacketPerform_SC_GongFuFightBaseInfor(param1:TPacket) : void
      {
         this.FUnstreamizerGongFuFight.UnstreamizationPerformBaseInfor(param1.Data,this.FGongFuData.GongFuFightBaseInfor,null);
         if(FIsResourcesLoadCompleted && this.Visible && this.FGongFuData.PlayerNormalGroups.length == 5)
         {
            this.ReCountChallengeLisPlayerState(this.FGongFuData.PlayerNormalGroups);
            this.SetPlayerType(this.FGongFuData.PlayerSuperLevelGroups,CONST_GONGFUFIGHT.GongFuFightPlayerType_SuperLevel);
            this.FWindowMainUI.Update();
         }
      }
      
      protected function PacketPerform_SC_GongFuFightResetNotify(param1:TPacket) : void
      {
         this.FGongFuData.Inited = false;
         this.ReqSeasonInfor();
         this.ReqBaseInfor();
         if(Visible)
         {
            this.ProcessorWindowOnClose(this);
         }
      }
      
      protected function PacketPerform_SC_GongFuFightPayRecord(param1:TPacket) : void
      {
         this.FUnstreamizerGongFuFight.UnstreamizationPerformPayRecord(param1.Data,this.FGongFuData,null);
         if(this.FOnSendMessageToWindow != null)
         {
            this.FOnSendMessageToWindow(this,CONST_GONGFUFIGHT.GONGFUFIGHTMESSAGE_PayRecord,null);
         }
      }
      
      protected function PacketPerform_SC_GongFuFightAddFightTime(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FWindowMainUI.AddTime();
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_18);
         EffectGenerateText(_loc3_);
      }
      
      protected function PacketPerform_SC_GongFuFightTryIn(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedByte();
         this.FGongFuData.GongFuFightBaseInfor.GongFuFightState = _loc2_;
      }
      
      protected function PacketPerform_SC_GongFuFightOpenBeyondLevelFight(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         ++this.FGongFuData.GongFuFightBaseInfor.SpanFightFlag;
         this.FWindowMainUI.AddBeyondChanllgeFight();
      }
      
      protected function PacketPerform_SC_SeasonInforRet(param1:TPacket) : void
      {
         var _loc2_:TGongFuFightBaseInfor = null;
         var _loc3_:ByteArray = null;
         _loc2_ = this.FGongFuData.GongFuFightBaseInfor;
         _loc3_ = param1.Data;
         _loc2_.SeasonState = _loc3_.readUnsignedInt();
         _loc2_.SeasonOpenTime = _loc3_.readUnsignedInt();
         _loc2_.SeasonResetTime = _loc3_.readUnsignedInt();
         _loc2_.SeasonCloseTime = _loc3_.readUnsignedInt();
         _loc2_.FightZoneID = _loc3_.readUnsignedInt();
         this.FUnstreamizerGongFuFight.UnstreamizationPerformWorkTimes(null,this.FGongFuData.GongFuFightBaseInfor,null);
         this.FUnstreamizerGongFuFight.UnstreamizationPerformPayInfor(null,this.FGongFuData,null);
      }
      
      protected function PacketPerform_SC_FightRecordRet(param1:TPacket) : void
      {
         this.FUnstreamizerGongFuFight.UnstreamizationPerformFightRecord(param1.Data,this.FGongFuData,null);
      }
      
      protected function PacketPerform_SC_UpdateFightRecord(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SC_FightReviveBox(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_19);
         EffectGenerateText(_loc4_);
         _loc3_ = param1.Data.readUnsignedInt();
         this.FGongFuData.GongFuFightBaseInfor.BoxState |= 1 << _loc3_ - 1;
         this.FWindowMainUI.ReciveBox();
      }
      
      protected function PacketPerform_CS_TryIntoGongFuFight() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_TryIn);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ChallengeListReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_ChallengeListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ReqFightRecord() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_FightRecordReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PayRecordInforReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_PayRecordReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ReqBaseInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_BaseInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ReqSeasonInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_SeasonInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function RankRecordInforReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_RankInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function CheckIfCanBattle() : Boolean
      {
         return this.FGongFuData.GongFuFightBaseInfor.SeasonState == CONST_GONGFUFIGHT.SeasonState_Open && this.FGongFuData.GongFuFightBaseInfor.IfApplyToday;
      }
      
      protected function CheckIfTimeHit(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         _loc3_ = STimingCore.ServerTime % CONST_COMMON.SecondPerDay;
         return _loc3_ >= param1 && _loc3_ <= param2;
      }
      
      protected function SetPlayerType(param1:Vector.<TGongFuFightPlayerGroup>, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TGongFuFightPlayerGroup = null;
         var _loc8_:TGongFuFightPlayerInfor = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param1[_loc3_];
            _loc6_ = int(_loc7_.PlayersInfor.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = _loc7_.PlayersInfor[_loc5_];
               _loc8_.Type = param2;
               if(param2 == CONST_GONGFUFIGHT.GongFuFightPlayerType_SuperLevel && _loc8_.State != CONST_GONGFUFIGHT.PlayerState_Killed && this.CheckIfCanBattle())
               {
                  _loc8_.State = CONST_GONGFUFIGHT.PlayerState_CanChallenge;
               }
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      protected function GetPlayerByIndex(param1:Vector.<TGongFuFightPlayerGroup>, param2:int) : TGongFuFightPlayerInfor
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TGongFuFightPlayerGroup = null;
         var _loc8_:TGongFuFightPlayerInfor = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         loop0:
         while(true)
         {
            if(_loc3_ >= _loc4_)
            {
               return _loc8_;
            }
            _loc7_ = param1[_loc3_];
            _loc6_ = int(_loc7_.PlayersInfor.length);
            _loc5_ = 0;
            while(true)
            {
               if(false)
               {
                  break loop0;
               }
               if(_loc5_ >= _loc6_)
               {
                  break;
               }
               _loc8_ = _loc7_.PlayersInfor[_loc5_];
               if(_loc8_.PlayerIndex == param2)
               {
                  break loop0;
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return _loc8_;
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
      }
      
      public function set OnReturnMainScene(param1:Function) : void
      {
         this.FOnReturnMainScene = param1;
      }
      
      public function set OnSendMessageToWindow(param1:Function) : void
      {
         this.FOnSendMessageToWindow = param1;
      }
      
      public function set OnOpenGongFuFightWindow(param1:Function) : void
      {
         this.FWindowMainUI.OnOpenGongFuFightWindow = param1;
         this.FOnOpenGongFuFightWindow = param1;
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function set BattleBack(param1:Boolean) : void
      {
         this.FBattleBack = param1;
      }
      
      public function set OnOpenTokenShop(param1:Function) : void
      {
         this.FOnOpenTokenShop = param1;
         this.FWindowMainUI.OnOpenTokenShop = param1;
      }
      
      public function set OnOpenStoneShop(param1:Function) : void
      {
         this.FOnOpenStoneShop = param1;
         this.FWindowMainUI.OnOpenStoneShop = param1;
      }
      
      public function set OnSetBattlePacket(param1:Function) : void
      {
         this.FOnSetBattlePacket = param1;
      }
      
      public function set BattleResult(param1:Boolean) : void
      {
         FightPending = false;
         if(this.FReplay)
         {
            this.FReplay = false;
            this.ReqFightRecord();
            return;
         }
         var _loc2_:TGongFuFightPlayerInfor = null;
         if(param1)
         {
            switch(this.FBattleType)
            {
               case CONST_GONGFUFIGHT.GongFuFightPlayerType_Normal:
                  _loc2_ = this.GetPlayerByIndex(this.FGongFuData.PlayerNormalGroups,this.FTargetIndex);
                  break;
               case CONST_GONGFUFIGHT.GongFuFightPlayerType_SuperLevel:
                  _loc2_ = this.GetPlayerByIndex(this.FGongFuData.PlayerSuperLevelGroups,this.FTargetIndex);
            }
            if(_loc2_ != null)
            {
               _loc2_.State = CONST_GONGFUFIGHT.PlayerState_Killed;
            }
            this.ReCountChallengeLisPlayerState(this.FGongFuData.PlayerNormalGroups);
            this.SetPlayerType(this.FGongFuData.PlayerSuperLevelGroups,CONST_GONGFUFIGHT.GongFuFightPlayerType_SuperLevel);
         }
         this.ReqFightRecord();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         FightPending = false;
         if(!FIsResourcesLoadCompleted)
         {
            this.FUnstreamizerGongFuFight.UnstreamizationPerformWorkTimes(null,this.FGongFuData.GongFuFightBaseInfor,null);
            this.FWindowMainUI.Load();
            return;
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_GONGFUFIGHT;
         if(!this.FGongFuData.Inited)
         {
            this.PayRecordInforReq();
            this.RankRecordInforReq();
            this.ReqFightRecord();
            this.ChallengeListReq();
         }
         else
         {
            this.ReqBaseInfor();
            this.ChallengeListReq();
            this.FWindowMainUI.OpenView();
            this.FWindowMainUI.Update();
            this.FWindowMainUI.Visible = true;
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(FIsResourcesLoadCompleted)
         {
            this.FWindowMainUI.Reset();
         }
      }
      
      public function EnterGongFuFight() : void
      {
         var _loc1_:TPacket = null;
         if(this.FGongFuData.GongFuFightBaseInfor.SeasonState == CONST_GONGFUFIGHT.SeasonState_Close)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_35));
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_GONGFUFIGHT)
         {
            _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_GongFuFight);
            SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         }
      }
   }
}

