package Processors.Game.Lobby.KillHeros
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.KillHero.*;
   import Logics.Streamization.KillHero.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorKillHeros extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_KillHeros:int = 864;
      
      protected static const SIZE_HEIGHT_KillHeros:int = 532;
      
      protected static const SIZE_WindowBarrierChoose_Width:Number = 608;
      
      protected static const SIZE_WindowBarrierChoose_Height:Number = 500;
      
      protected static const RESOURCESSTATE_Request:int = 0;
      
      protected static const RESOURCESSTATE_Wait:int = 1;
      
      protected static const RESOURCESSTATE_Dispatch:int = 2;
      
      public static const ENTER_TYPE_TRIALS:int = CONST_BATTLE.BattleType_KillHero;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected var FProcessorWindowKillHeros:TProcessorWindowKillHeros;
      
      protected var FProcessorWindowBarrierChoose:TProcessorWindowBarrierChoose;
      
      protected var FBoundsKillHeros:TBounds;
      
      protected var FBoundsWindowBarrierChoose:TBounds;
      
      protected var FKillHeroInfo:TKillHero;
      
      protected var FUnstreamizerKillHero:TUnstreamizerKillHero;
      
      protected var FRaidersDailyConfigBins:TBins;
      
      protected var FCityBins:TBins;
      
      protected var FBattleType:int;
      
      protected var FCityID:int;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnAddPopTips:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnOpenTacticalDeployment:Function;
      
      protected var FOnOpenSkill:Function;
      
      public function TProcessorKillHeros(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowKillHeros = new TProcessorWindowKillHeros(this);
         this.FProcessorWindowKillHeros.OnClose = this.ProcessorWindowKillHerosOnClose;
         this.FProcessorWindowKillHeros.OnInventoryOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowKillHeros.OnInventoryOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowKillHeros.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowKillHeros.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowKillHeros.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowKillHeros.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowKillHeros.OnFight = this.ProcessorOnKillHerosFight;
         this.FProcessorWindowKillHeros.OnUpdateCityID = this.ProcessorOnUpdataCityId;
         this.FProcessorWindowBarrierChoose = new TProcessorWindowBarrierChoose(this);
         this.FProcessorWindowBarrierChoose.OnChangeTeammate = this.ProcessorOnChangeTeammate;
         this.FProcessorWindowBarrierChoose.OnChangeSkill = this.ProcessorOnChangeSkill;
         this.FProcessorWindowBarrierChoose.OnBattle = this.ProcessorOnBattle;
         this.FProcessorWindowBarrierChoose.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorWindowBarrierChoose.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.OnAddPopTips = this.FOnAddPopTips;
         this.FBoundsKillHeros = new TBounds();
         this.FBoundsKillHeros.Width = SIZE_WIDTH_KillHeros;
         this.FBoundsKillHeros.Height = SIZE_HEIGHT_KillHeros;
         ComponentBoundsCenter(this.FProcessorWindowKillHeros,this.FBoundsKillHeros);
         this.FBoundsKillHeros = null;
         this.FBoundsWindowBarrierChoose = new TBounds();
         this.FBoundsWindowBarrierChoose.Width = SIZE_WindowBarrierChoose_Width;
         this.FBoundsWindowBarrierChoose.Height = SIZE_WindowBarrierChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowBarrierChoose,this.FBoundsWindowBarrierChoose);
         this.FBoundsWindowBarrierChoose = null;
         this.FKillHeroInfo = new TKillHero();
         this.FUnstreamizerKillHero = new TUnstreamizerKillHero();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_KILLHERO.RESOURCESID_KillHero);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FRaidersDailyConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_KillHeros_Notify,this.PacketPerform_SC_Notify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_KillHeros_ResetRet,this.PacketPerform_SC_ResetRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_KillHeros_BestFirstNotify,this.PacketPerform_SC_BestFirstNotify);
      }
      
      protected function PacketPerform_SC_EnterKillHero(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerKillHero.Unstreamize(param1,this.FKillHeroInfo,SResourcesCore.ResourceBin);
         this.FProcessorWindowKillHeros.SetKillHeroData(this.FKillHeroInfo);
         this.FProcessorWindowKillHeros.Visible = true;
      }
      
      protected function PacketPerform_SC_Notify(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerKillHero.UnstreamizationNotify(_loc2_,this.FKillHeroInfo,SResourcesCore.ResourceBin);
         if(this.IsInit)
         {
            this.FProcessorWindowKillHeros.Updata();
         }
      }
      
      protected function PacketPerform_SC_ResetRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         _loc6_ = param1.Data;
         _loc3_ = int(_loc6_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = int(_loc6_.readUnsignedShort());
         _loc4_ = new Vector.<uint>(_loc5_);
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc4_.push(_loc6_.readUnsignedInt());
            _loc2_++;
         }
         this.FProcessorWindowKillHeros.ResetKillHeroData(_loc4_);
      }
      
      protected function PacketPerform_SC_BestFirstNotify(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerKillHero.UnstreamizationBestFirstNotify(_loc2_,this.FKillHeroInfo,null);
         if(this.Visible)
         {
            this.FProcessorWindowKillHeros.SetKillHeroData(this.FKillHeroInfo,true);
         }
      }
      
      protected function get IsInit() : Boolean
      {
         return this.FKillHeroInfo.IsInit;
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         this.FProcessorWindowKillHeros.OnEffectText = param1;
         FOnEffectText = param1;
      }
      
      protected function ProcessorOnBattle(param1:Object, param2:int) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TCity = null;
         _loc7_ = this.FCityBins.GetDatebaseByIdentifier(this.FCityID) as TCity;
         if(_loc7_ == null)
         {
            return;
         }
         _loc5_ = this.FCityID;
         _loc6_ = param2;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Hurdle);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(_loc5_);
         _loc4_.writeInt(_loc6_);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorOnChangeTeammate(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
      }
      
      protected function ProcessorOnChangeSkill(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_KillHeros,param3,false);
      }
      
      protected function LevelUpUpdateKillHero() : void
      {
         var _loc1_:TSingleKillHero = null;
         var _loc2_:uint = 0;
         var _loc3_:TRaidersDailyConfig = null;
         if(this.FKillHeroInfo != null)
         {
            _loc1_ = this.FKillHeroInfo.GetSingleKillHeroById(this.FKillHeroInfo.CurHeroId);
            if(_loc1_ == null)
            {
               return;
            }
            if(_loc1_.IsPassed)
            {
               _loc3_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(this.FKillHeroInfo.CurHeroId) as TRaidersDailyConfig;
               _loc2_ = _loc3_.NextHard;
               _loc3_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(_loc2_) as TRaidersDailyConfig;
               if(_loc3_ != null)
               {
                  this.FKillHeroInfo.CurHeroId = _loc2_;
                  this.FProcessorWindowKillHeros.SetKillHeroData(this.FKillHeroInfo);
               }
            }
         }
      }
      
      protected function ProcessorOnKillHerosFight(param1:Object, param2:TNodal, param3:int, param4:int, param5:int) : void
      {
         this.FProcessorWindowBarrierChoose.UpDataBarrierChoose(param1,param2,param3,param4,param5);
         this.FProcessorWindowBarrierChoose.Visible = true;
         this.FProcessorWindowBarrierChoose.Mount();
      }
      
      protected function ProcessorOnUpdataCityId(param1:Object, param2:int) : void
      {
         var _loc3_:TCity = null;
         _loc3_ = this.FCityBins.GetDatebaseByIdentifier(param2) as TCity;
         if(_loc3_ != null)
         {
            this.FCityID = param2;
         }
      }
      
      protected function ProcessorWindowKillHerosOnClose(param1:Object) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
         ProcessorClose();
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function get OnEnterTown() : Function
      {
         return this.FOnEnterTown;
      }
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
         this.FProcessorWindowKillHeros.OnAddPopTips = param1;
      }
      
      public function get ProcessorWindowKillHeros() : TProcessorWindowKillHeros
      {
         return this.FProcessorWindowKillHeros;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnOpenTacticalDeployment() : Function
      {
         return this.FOnOpenTacticalDeployment;
      }
      
      public function set OnOpenTacticalDeployment(param1:Function) : void
      {
         this.FOnOpenTacticalDeployment = param1;
      }
      
      public function get OnOpenSkill() : Function
      {
         return this.FOnOpenSkill;
      }
      
      public function set OnOpenSkill(param1:Function) : void
      {
         this.FOnOpenSkill = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowKillHeros.Load();
            this.FProcessorWindowBarrierChoose.Load();
            return;
         }
         this.FProcessorWindowBarrierChoose.Visible = false;
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_KILLHEROS;
         if(param1 != null)
         {
            this.PacketPerform_SC_EnterKillHero(param1);
         }
         if(this.IsInit)
         {
            this.LevelUpUpdateKillHero();
            this.FProcessorWindowKillHeros.Updata();
            this.FProcessorWindowKillHeros.visible = true;
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenKillHero);
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_KillHeros);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowKillHeros.visible = false;
         this.FProcessorWindowBarrierChoose.Visible = false;
         this.FProcessorWindowKillHeros.Reset();
         this.FProcessorWindowBarrierChoose.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseKillHero);
      }
      
      public function UpdateKillHero(param1:Boolean, param2:uint) : void
      {
         var _loc3_:TSingleKillHero = null;
         var _loc4_:uint = 0;
         var _loc5_:TRaidersDailyConfig = null;
         if(!param1)
         {
            return;
         }
         if(param2 > this.FKillHeroInfo.CurHeroId)
         {
            return;
         }
         _loc3_ = this.FKillHeroInfo.GetSingleKillHeroById(param2);
         if(_loc3_ != null)
         {
            _loc3_.EnterCount += 1;
            _loc5_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(param2) as TRaidersDailyConfig;
            _loc4_ = _loc5_.NextHard;
            _loc3_.IsPassed = true;
            _loc5_ = this.FRaidersDailyConfigBins.GetDatebaseByIdentifier(_loc4_) as TRaidersDailyConfig;
            _loc3_ = this.FKillHeroInfo.GetSingleKillHeroById(_loc4_);
            if(_loc3_ == null)
            {
               return;
            }
            if(!_loc3_.IsPassed)
            {
               if(_loc5_ != null)
               {
                  this.FKillHeroInfo.CurHeroId = _loc4_;
               }
               this.FProcessorWindowKillHeros.SetKillHeroData(this.FKillHeroInfo,true,this.FKillHeroInfo.CurHeroId);
            }
            else
            {
               this.FProcessorWindowKillHeros.SetKillHeroData(this.FKillHeroInfo,true,_loc4_);
            }
         }
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(this.FProcessorWindowBarrierChoose.Visible)
         {
            this.FProcessorWindowBarrierChoose.UpDateUI();
         }
      }
   }
}

