package Processors.Game.Lobby.NightmareTrial
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.SLogicsCore;
   import Logics.Streamization.NightmareTrial.TUnstreamizerNightmareTrial;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.NightmareTrial.Windows.TProcessorNightmareOnSelect;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_NIGHTMARETRIAL;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class TProcessorNightmareTrialMain extends TProcessorLobbyWindows
   {
      
      protected var WINDOW_WIDTH:int = 1250;
      
      protected var WINDOW_HEIGHT:int = 650;
      
      protected var FBounds:TBounds;
      
      protected var FLayerMask:Sprite;
      
      protected var FOnSelectView:TProcessorNightmareOnSelect;
      
      protected var FData:TNightmareTrialData;
      
      protected var FUnstreamizer:TUnstreamizerNightmareTrial;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnShowHeroDescription:Function;
      
      protected var FOnOpenMapInfoViewFun:Function;
      
      public function TProcessorNightmareTrialMain(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         this.FData = SLogicsCore.NightmareTrialData;
         this.FUnstreamizer = new TUnstreamizerNightmareTrial(this.FData);
         this.FOnSelectView = new TProcessorNightmareOnSelect(this);
         this.FOnSelectView.OnClose = this.CloseWindows;
         this.FOnSelectView.Unstreamizer = this.FUnstreamizer;
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = this.WINDOW_WIDTH;
         this.FBounds.Height = this.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FOnSelectView,this.FBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_NIGHTMARETRIAL.RESOURCESID_Swf_NightmareTrial);
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
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_InitInfoRet,this.PacketPerform_SC_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_ResetRet,this.PacketPerform_SC_ResetRet);
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_CitySelectRet,this.PacketPerform_SC_SelectCityRet);
      }
      
      protected function PacketPerform_SC_InitInfoRet(param1:TPacket) : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FUnstreamizer.NightmareInfo_Ret(param1.Data);
         this.FOnSelectView.Show(this.FData);
         this.FOnSelectView.ShowSelectViewInfo();
      }
      
      protected function PacketPerform_SC_ResetRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizer.NightmareReset_Ret(param1.Data);
         }
         this.FOnSelectView.Show(this.FData);
         this.FOnSelectView.ShowSelectViewInfo();
      }
      
      protected function PacketPerform_SC_SelectCityRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.PacketReqSuc(param1))
         {
            _loc2_ = int(param1.Data.readUnsignedInt());
            _loc3_ = int(param1.Data.readUnsignedInt());
            this.FData.GetNightmareTrialLevelVo(_loc2_).SelectInfoVo.CurrentCityId = _loc3_;
            this.FOnOpenMapInfoViewFun(_loc2_,_loc3_);
         }
         this.FOnSelectView.Show(this.FData);
         this.FOnSelectView.ShowSelectViewInfo();
      }
      
      protected function PacketReqSuc(param1:TPacket) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return false;
         }
         return true;
      }
      
      protected function CloseWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function CancleMask(param1:Object) : void
      {
         this.FLayerMask.visible = false;
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
      
      public function get OnOpenMapInfoViewFun() : Function
      {
         return this.FOnOpenMapInfoViewFun;
      }
      
      public function set OnOpenMapInfoViewFun(param1:Function) : void
      {
         this.FOnOpenMapInfoViewFun = param1;
         this.FOnSelectView.OpenMapInfoViewFun = this.FOnOpenMapInfoViewFun;
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
            this.FOnSelectView.Load();
            this.FUnstreamizer.InitStaticConfigData();
            return;
         }
         this.FOnSelectView.Show(this.FData);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

