package Processors.Game.Lobby.KingChallenge
{
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.KingChallenge.TKingChallenge;
   import Logics.Streamization.KingChallenge.TUnsteamizerKingChallenge;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorKingChallenge extends TProcessorLobbyPlate
   {
      
      protected const RESOURCESID_Swf:uint = 1023410176;
      
      protected var FMainWin:TProcessorWindowKingChallenge;
      
      protected var FUnstreamizer:TUnsteamizerKingChallenge;
      
      protected var FData:TKingChallenge;
      
      protected var FInited:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnSetKingChallengeNpc:Function;
      
      public function TProcessorKingChallenge(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowKingChallenge(this);
         this.FMainWin.CurGroup = 1000;
         this.FMainWin.OnReturn = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FData = new TKingChallenge();
         this.FUnstreamizer = new TUnsteamizerKingChallenge(this.FData);
         this.FInited = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_InitRet,this.PacketPerform_SC_KingChallengeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_InitFightRet,this.PacketPerform_SC_KingChallenge_InitFightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_RankRet,this.PacketPerform_SC_KingChallengeRankRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_UploadRet,this.PacketPerform_SC_KingChallenge_UploadRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_FightRet,this.PacketPerform_SC_KingChallenge_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_BoxAwardRet,this.PacketPerform_SC_KingChallenge_BoxAwardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_BettingRet,this.PacketPerform_SC_KingChallenge_BettingRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_BettingAwardRet,this.PacketPerform_SC_KingChallenge_BettingAwardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_KingChallenge_NpcRet,this.PacketPerform_SC_KingChallenge_NpcRet);
      }
      
      protected function PacketPerform_SC_KingChallenge_BettingAwardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText02));
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText01));
         this.FUnstreamizer.BettingRet(param1.Data);
         this.FMainWin.Data = this.FData;
      }
      
      protected function PacketPerform_SC_KingChallenge_BettingRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText04));
         this.FUnstreamizer.BettingRet(param1.Data);
         this.FMainWin.Data = this.FData;
      }
      
      protected function PacketPerform_SC_KingChallenge_BoxAwardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText06));
            return;
         }
         this.FData.UserBaseInfo.AwardStatus = param1.Data.readByte();
         SToolReward.ShowReward(param1.Data);
         this.FMainWin.Data = this.FData;
      }
      
      protected function PacketPerform_SC_KingChallenge_UploadRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText11));
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.King_SystemLanguageText10));
      }
      
      protected function PacketPerform_SC_KingChallengeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.InitRet(param1.Data);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FMainWin.Data = this.FData;
         this.FMainWin.Visible = true;
      }
      
      protected function PacketPerform_SC_KingChallenge_InitFightRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.BaseRet(param1.Data);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FMainWin.Data = this.FData;
         this.FMainWin.Visible = true;
      }
      
      protected function PacketPerform_SC_KingChallenge_FightRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.FightRet(param1.Data);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FMainWin.Data = this.FData;
         this.FMainWin.UpdateLine();
         this.FMainWin.Visible = true;
      }
      
      protected function PacketPerform_SC_KingChallengeRankRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.RankRet(param1.Data);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FMainWin.Data = this.FData;
      }
      
      protected function PacketPerform_SC_KingChallenge_NpcRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = param1.Data.readUnsignedInt();
         _loc3_ = param1.Data.readUTF();
         if(this.FOnSetKingChallengeNpc != null)
         {
            this.FOnSetKingChallengeNpc(_loc3_,_loc4_);
         }
      }
      
      protected function ShutDownWindows() : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(this);
         }
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function get OnSetKingChallengeNpc() : Function
      {
         return this.FOnSetKingChallengeNpc;
      }
      
      public function set OnSetKingChallengeNpc(param1:Function) : void
      {
         this.FOnSetKingChallengeNpc = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(this.FMainWin != null)
         {
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         this.FMainWin.Visible = true;
         this.FUnstreamizer.InitReq(this.FMainWin.CurGroup);
         this.FUnstreamizer.FightReq(this.FMainWin.CurGroup);
         this.FUnstreamizer.RankReq(this.FMainWin.CurGroup);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

