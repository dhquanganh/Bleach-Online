package Processors.Game.Lobby.NightmareTrial.Windows
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.Streamization.NightmareTrial.TUnstreamizerNightmareTrial;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorNightmareOnSelect extends TProcessorLobbyWindow
   {
      
      public static const LevelCount:int = 3;
      
      public static const SlotCount:int = 4;
      
      private var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      private var FLeftMc:MovieClip;
      
      private var FRightMc:MovieClip;
      
      private var FStartLevelTFVec:Vector.<TextField>;
      
      private var FLevelNameTFVec:Vector.<TextField>;
      
      private var FStartStateSpVec:Vector.<Sprite>;
      
      private var FSlotVec:Vector.<Vector.<TUISlot>>;
      
      private var FSelectPanel:Sprite;
      
      private var FSelectInfoView:TSelectInfoView;
      
      private var FLevelSelectVec:Vector.<MovieClip>;
      
      private var FLoginGameBtnVec:Vector.<TUIButton>;
      
      private var FMCGrayVec:Vector.<MovieClip>;
      
      private var FHideElementVec:Vector.<Sprite>;
      
      protected var FUICredits:TUICredits;
      
      protected var FMcPage:Sprite;
      
      protected var FUIPage:TUIPage;
      
      private var FSelectType:int;
      
      private var FData:TNightmareTrialData;
      
      private var FOpenMapInfoViewFun:Function;
      
      private var FUnstreamizer:TUnstreamizerNightmareTrial;
      
      public function TProcessorNightmareOnSelect(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:TUIButton = null;
         var _loc7_:TUISlot = null;
         var _loc8_:Vector.<TUISlot> = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("NightmareTrialMain") as Sprite;
         addChild(this.FMainUI);
         _loc4_ = LevelCount;
         this.FStartLevelTFVec = new Vector.<TextField>();
         this.FLevelNameTFVec = new Vector.<TextField>();
         this.FStartStateSpVec = new Vector.<Sprite>();
         this.FSlotVec = new Vector.<Vector.<TUISlot>>();
         this.FLevelSelectVec = new Vector.<MovieClip>();
         this.FMCGrayVec = new Vector.<MovieClip>();
         this.FLoginGameBtnVec = new Vector.<TUIButton>();
         this.FHideElementVec = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc5_ = this.FMainUI["MC_Level_" + _loc1_];
            _loc5_.gotoAndStop(1);
            this.FMCGrayVec[_loc1_] = _loc5_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = this.FMainUI["BtnGame" + _loc1_];
            _loc6_.OnClick = this.OnSelectLevelFun;
            this.FLoginGameBtnVec[_loc1_] = _loc6_;
            this.FLevelSelectVec[_loc1_] = _loc5_;
            this.FHideElementVec[_loc1_] = _loc5_["MC_Hide"];
            this.FStartLevelTFVec[_loc1_] = _loc5_["MC_Hide"]["TF_Level"];
            this.FLevelNameTFVec[_loc1_] = _loc5_["TFLevelName"];
            this.FStartStateSpVec[_loc1_] = _loc5_["MC_StartState"];
            _loc8_ = new Vector.<TUISlot>();
            _loc3_ = SlotCount;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc7_ = new TUISlot(this);
               _loc7_.Resource = _loc5_["MC_Hide"]["MC_Slot" + _loc2_];
               _loc7_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
               _loc7_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
               TJadeCommon.InitSlot(_loc7_);
               _loc7_.Init();
               _loc8_[_loc2_] = _loc7_;
               _loc2_++;
            }
            this.FSlotVec[_loc1_] = _loc8_;
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["MC_Btns"]["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FSelectPanel = this.FMainUI["MC_MainUI"];
         this.FSelectInfoView = new TSelectInfoView(this,this.FSelectPanel);
         this.FSelectInfoView.Data = this.FData;
         this.FSelectInfoView.OpenMapInfoFun = this.FOpenMapInfoViewFun;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FMainUI["MC_PanelCredits"];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.UpdatePanel();
         this.FMcPage = this.FMainUI["MC_Page"];
         this.FMcPage.visible = false;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMcPage["MC_Left"];
         this.FUIPage.ButtonNext.Substrate = this.FMcPage["MC_Right"];
         this.FUIPage.LabelPage = this.FMcPage["TF_Page"];
         this.FUIPage.PageSize = LevelCount;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FUIPage.Init();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      private function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = LevelCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = SlotCount;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FSlotVec[_loc1_][_loc3_].Update();
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      private function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         _loc2_ = LevelCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FStartLevelTFVec[_loc1_].text = "Lv." + this.FData.NightmareTrialLevelVec[_loc1_].StartLevel.toString();
            this.FLevelNameTFVec[_loc1_].text = this.FData.NightmareTrialLevelVec[_loc1_].TitleName;
            if(this.FData.NightmareTrialLevelVec[_loc1_].IsStart)
            {
               this.FStartStateSpVec[_loc1_].visible = false;
               this.FHideElementVec[_loc1_].visible = true;
               this.FMCGrayVec[_loc1_].gotoAndStop(1);
            }
            else
            {
               this.FStartStateSpVec[_loc1_].visible = true;
               this.FHideElementVec[_loc1_].visible = false;
               this.FMCGrayVec[_loc1_].gotoAndStop(4);
            }
            this.FLoginGameBtnVec[_loc1_].Enabled = this.FData.NightmareTrialLevelVec[_loc1_].IsStart;
            _loc4_ = int(this.FData.NightmareTrialLevelVec[_loc1_].Inventories.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this.FSlotVec[_loc1_][_loc3_];
               _loc5_.Context = null;
               _loc5_.Context = this.FData.NightmareTrialLevelVec[_loc1_].Inventories[_loc3_].GetInventoryByIndex(0);
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      public function ShowSelectViewInfo() : void
      {
         this.FSelectInfoView.Data = this.FData;
         this.FSelectInfoView.ShowView(this.FSelectType);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateExtractSlots();
            this.FSelectInfoView.LogicsPerform_EnterFrame();
            this.FUICredits.UpdatePanel();
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnSelectLevelFun(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:int = 0;
         _loc3_ = this.FLoginGameBtnVec.indexOf(param1 as TUIButton);
         this.FSelectType = _loc3_;
         if(!this.FData.NightmareTrialLevelVec[_loc3_].IsStart)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_InitInfoReq);
         _loc5_ = this.FData.NightmareTrialLevelVec[_loc3_].Id;
         _loc4_.Data.writeUnsignedInt(_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
      }
      
      public function set OpenMapInfoViewFun(param1:Function) : void
      {
         this.FOpenMapInfoViewFun = param1;
      }
      
      public function get OpenMapInfoViewFun() : Function
      {
         return this.FOpenMapInfoViewFun;
      }
      
      public function set Unstreamizer(param1:TUnstreamizerNightmareTrial) : void
      {
         this.FUnstreamizer = param1;
      }
      
      public function get Unstreamizer() : TUnstreamizerNightmareTrial
      {
         return this.FUnstreamizer;
      }
      
      public function Show(param1:TNightmareTrialData) : void
      {
         Visible = true;
         this.FData = param1;
         this.UpdateUI();
      }
   }
}

