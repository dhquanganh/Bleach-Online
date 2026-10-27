package Processors.Game.Lobby.RelatedPartner
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.*;
   import Logics.RelatedPartner.TRelatedPartnerHero;
   import Logics.RelatedPartner.TRelatedPartnerHeros;
   import Logics.SLogicsCore;
   import Logics.Streamization.RelatedPartner.TUnstreamizerRelatedPartnerTrain;
   import Logics.Streamization.RelatedPartner.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.RelatedPartner.BattleReady.TWindowPartnerBattleReady;
   import Resources.Constants.*;
   import flash.utils.ByteArray;
   
   public class TProcessorRelatedPartner extends TProcessorLobbyWindows
   {
      
      protected static const PartnerWindow_Width:int = 684;
      
      protected static const PartnerWindow_Height:int = 445;
      
      protected static const ReadyWindow_Width:int = 670;
      
      protected static const ReadyWindow_Height:int = 570;
      
      protected var FProcessorWindowPartner:TProcessorWindowRelatedPartner;
      
      protected var FWindowBattleReady:TWindowPartnerBattleReady;
      
      protected var FPartnerBounds:TBounds;
      
      protected var FReadyBounds:TBounds;
      
      protected var FIsReadyInit:Boolean;
      
      protected var FUnstreamizerTrain:TUnstreamizerRelatedPartnerTrain;
      
      protected var FHeroInfo:TPartnerTrainHeroPointVO;
      
      protected var FHeroDatas:TRelatedPartnerHeros;
      
      protected var FOnAssistanceView:Function;
      
      protected var FOnAssistanceViewClose:Function;
      
      protected var FOnUpdateAssistanceView:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnShowHeroDescription:Function;
      
      public function TProcessorRelatedPartner(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowPartner = new TProcessorWindowRelatedPartner(this);
         this.FProcessorWindowPartner.OnAssistance = this.OnAssistance;
         this.FProcessorWindowPartner.OnAssistanceClose = this.OnAssistanceClose;
         this.FProcessorWindowPartner.OnClose = this.WindowOnClose;
         this.FProcessorWindowPartner.OnShowHeroDescription = this.ProcessorOnShowHeroDescription;
         this.FProcessorWindowPartner.OnBattleReady = this.OnBattleReady;
         this.FWindowBattleReady = new TWindowPartnerBattleReady(this);
         this.FWindowBattleReady.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FWindowBattleReady.SwitchFunction = this.ProcessorOnSwitchFunction;
         this.FWindowBattleReady.Visible = false;
         this.FPartnerBounds = new TBounds();
         this.FPartnerBounds.Width = PartnerWindow_Width;
         this.FPartnerBounds.Height = PartnerWindow_Height;
         this.FReadyBounds = new TBounds();
         this.FReadyBounds.Width = ReadyWindow_Width;
         this.FReadyBounds.Height = ReadyWindow_Height;
         ComponentBoundsCenter(this.FProcessorWindowPartner,this.FPartnerBounds);
         ComponentBoundsCenter(this.FWindowBattleReady,this.FReadyBounds);
         this.FUnstreamizerTrain = new TUnstreamizerRelatedPartnerTrain();
         this.FHeroInfo = new TPartnerTrainHeroPointVO();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_RELATEDPARTNER.RESOURCESID_Swf_Related);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_PointInfoRet,this.PacketPerform_SC_PointInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_FightRet,this.PacketPerform_SC_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_RewardRet,this.PacketPerform_SC_RewardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_DailyTrainRet,this.PacketPerform_SC_DailyTrainRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_StarNotifyRet,this.PacketPerform_SC_StarNotifyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_SkillInfoRet,this.PacketPerform_SC_SkillInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_LevelupRet,this.PacketPerform_SC_LevelupRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_HeroHelpRet,this.PacketPerform_SC_HeroHelpRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_HeroHelpCancelRet,this.PacketPerform_SC_HeroHelpCancelRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Related_UpdateCountRet,this.PacketPerform_SC_UpdateCountRet);
      }
      
      protected function WindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function PacketPerform_SC_PointInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FHeroInfo.Reset();
         this.FUnstreamizerTrain.UnstreamizationPerform_TrainInfo(param1.Data,this.FHeroInfo,null);
         this.FProcessorWindowPartner.UpdateTrain(this.FHeroInfo);
         this.FProcessorWindowPartner.TrainStarStatus = this.FHeroInfo.StarRewardStatus;
      }
      
      protected function PacketPerform_SC_FightRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.OnBattleEnter();
      }
      
      protected function PacketPerform_SC_RewardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TPartnerTrainStarRewardVO = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = new TPartnerTrainStarRewardVO();
         this.FUnstreamizerTrain.UnstreamizationPerform_StarReward(param1.Data,_loc3_,null);
         this.FProcessorWindowPartner.TrainStarStatus = _loc3_.StarRewardStatus;
      }
      
      protected function PacketPerform_SC_DailyTrainRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerTrain.UstreamizationPerform_DailyReward(param1.Data,this.FHeroInfo,null);
         this.FProcessorWindowPartner.UpdateTrain(this.FHeroInfo);
      }
      
      protected function PacketPerform_SC_StarNotifyRet(param1:TPacket) : void
      {
         var _loc2_:TRelatedPartnerHero = null;
         this.FUnstreamizerTrain.UnstreamizationPerform_StarNotify(param1.Data,this.FHeroInfo,null);
         this.FProcessorWindowPartner.UpdateTrain(this.FHeroInfo);
         if(this.FHeroInfo.SkillId != 0)
         {
            _loc2_ = TRelatedPartnerCommon.HeroDatas.GetHeroDataByIdentifier(this.FHeroInfo.HeroId);
            _loc2_.SetSkillActive(this.FHeroInfo.SkillId);
         }
      }
      
      protected function PacketPerform_SC_SkillInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         TRelatedPartnerCommon.HeroDatas.IsInit = true;
         this.FHeroDatas = TRelatedPartnerCommon.HeroDatas;
         this.FHeroDatas.ClearSkill();
         this.FUnstreamizerTrain.UnstreamizationPerform_HeroData(param1.Data,this.FHeroDatas,null);
         if(this.FOnUpdateAssistanceView != null)
         {
            this.FOnUpdateAssistanceView(CONST_RELATEDPARTNER.Type_SetInfo);
         }
         this.FProcessorWindowPartner.UpdateHeros();
      }
      
      protected function PacketPerform_SC_LevelupRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = new Object();
         this.FUnstreamizerTrain.UnstreamizationPerform_Levelup(param1.Data,_loc3_);
         this.FProcessorWindowPartner.UpdateDetailPage(_loc3_.HeroSkill);
         this.FProcessorWindowPartner.UpdatePropertyTip(_loc3_.HeroSkill);
      }
      
      protected function PacketPerform_SC_HeroHelpRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = SLogicsCore.Character.Heros;
         _loc5_ = int(param1.Data.readUnsignedInt());
         _loc6_ = int(param1.Data.readUnsignedInt());
         _loc3_ = _loc4_.GetHeroByIdentifier(_loc5_);
         _loc3_.RelatedPartnerPos = _loc6_;
         if(this.FOnUpdateAssistanceView != null)
         {
            this.FOnUpdateAssistanceView(CONST_RELATEDPARTNER.Type_SetAssistance,_loc3_);
         }
         this.RefreshHeroInfo();
      }
      
      protected function PacketPerform_SC_HeroHelpCancelRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc3_ = param1.Data.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc2_ = int(param1.Data.readUnsignedInt());
         this.FUnstreamizerTrain.UnstreamizationPerform_HelpCancel(_loc2_,SLogicsCore.Character.Heros);
         if(this.FOnUpdateAssistanceView != null)
         {
            this.FOnUpdateAssistanceView(CONST_RELATEDPARTNER.Type_SetDismount,_loc2_);
         }
         this.RefreshHeroInfo();
      }
      
      protected function PacketPerform_SC_UpdateCountRet(param1:TPacket) : void
      {
         this.FUnstreamizerTrain.UnstreamizationPerform_UpdateCount(param1.Data,this.FHeroInfo,null);
         this.FProcessorWindowPartner.UpdateTrain(this.FHeroInfo);
      }
      
      protected function RefreshHeroInfo() : void
      {
         var _loc1_:THeros = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc1_ = TRelatedPartnerCommon.GetMountedHeros();
         _loc2_ = _loc1_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Account_CharBaseAttributeReq);
            _loc5_ = _loc4_.Data;
            _loc5_.writeUnsignedInt(_loc1_.GetHeroByIndex(_loc3_).Identifier);
            SNetworkCore.Transceiver.PacketTransmit(_loc4_);
            _loc3_++;
         }
      }
      
      protected function OnAssistance(param1:Object) : void
      {
         if(this.FOnAssistanceView != null)
         {
            this.FOnAssistanceView(param1);
         }
      }
      
      protected function OnAssistanceClose() : void
      {
         if(this.FOnAssistanceViewClose != null)
         {
            this.FOnAssistanceViewClose();
         }
      }
      
      protected function OnBattleReady(param1:int, param2:int) : void
      {
         this.FWindowBattleReady.PveId = param1;
         this.FWindowBattleReady.StarId = param2;
         if(!this.FIsReadyInit)
         {
            this.FWindowBattleReady.Load();
            this.FIsReadyInit = true;
         }
         else
         {
            this.FWindowBattleReady.Show();
         }
      }
      
      protected function OnBattleEnter() : void
      {
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function ProcessorOnShowHeroDescription(param1:Object, param2:uint) : void
      {
         if(this.FOnShowHeroDescription != null)
         {
            this.FOnShowHeroDescription(param1,param2);
         }
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnSwitchFunction() : void
      {
         this.FWindowBattleReady.Close();
      }
      
      public function get OnAssistanceView() : Function
      {
         return this.FOnAssistanceView;
      }
      
      public function set OnAssistanceView(param1:Function) : void
      {
         this.FOnAssistanceView = param1;
      }
      
      public function get OnAssistanceViewClose() : Function
      {
         return this.FOnAssistanceViewClose;
      }
      
      public function set OnAssistanceViewClose(param1:Function) : void
      {
         this.FOnAssistanceViewClose = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnUpdateAssistanceView() : Function
      {
         return this.FOnUpdateAssistanceView;
      }
      
      public function set OnUpdateAssistanceView(param1:Function) : void
      {
         this.FOnUpdateAssistanceView = param1;
      }
      
      public function set OnShowHeroDescription(param1:Function) : void
      {
         this.FOnShowHeroDescription = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPartner.Load();
         }
         this.FProcessorWindowPartner.Show();
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(Visible)
         {
            this.FWindowBattleReady.ProcessorChangePosition();
         }
      }
   }
}

