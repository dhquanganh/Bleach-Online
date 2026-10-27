package Processors.Game.Lobby.CrashJade
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.CrashJade.TCrashJadeData;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class TProcessorWindowCompose extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FSlot:TUISlot;
      
      protected var FTFChipNum:TextField;
      
      protected var FComposeLevelLimit:TextField;
      
      protected var FBtnSubValue:TUIButton;
      
      protected var FBtnAddValue:TUIButton;
      
      protected var FBtnCompse:TUIButton;
      
      protected var FTFCostNum:TextField;
      
      protected var FTFPulletNum:TextField;
      
      protected var FBtnClose:TUIButton;
      
      protected var FMaxComposeNum:int;
      
      protected var FCurrentComopseNum:int;
      
      protected var FComposeRate:int;
      
      protected var FSwallowPelletLevelLimit:int;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      public function TProcessorWindowCompose(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.FSlot.Update();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("ComposeChip") as Sprite;
         addChild(this.FMainUI);
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI["SlotDes"];
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlot.IsSelected = false;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FTFChipNum = this.FMainUI["TFNum"];
         this.FComposeLevelLimit = this.FMainUI["LevelLimit"];
         this.FBtnSubValue = new TUIButton();
         this.FBtnSubValue.Substrate = this.FMainUI["BTN_Reduce"];
         this.FBtnSubValue.OnClick = this.BtnSubValueOnClick;
         this.FBtnAddValue = new TUIButton();
         this.FBtnAddValue.Substrate = this.FMainUI["BTN_Increase"];
         this.FBtnAddValue.OnClick = this.BtnAddValueOnClick;
         this.FBtnCompse = new TUIButton();
         this.FBtnCompse.Substrate = this.FMainUI["btnCompose"];
         this.FBtnCompse.OnClick = this.BtnComposeOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["BtnClose"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTFPulletNum = this.FMainUI["ComposeNum"];
         this.FTFPulletNum.autoSize = "left";
         this.FTFPulletNum.selectable = true;
         this.FTFPulletNum.type = TextFieldType.INPUT;
         this.FTFPulletNum.restrict = "0-9";
         this.FTFPulletNum.maxChars = 6;
         this.FTFPulletNum.addEventListener(Event.CHANGE,this.TextChange);
         this.FTFCostNum = this.FMainUI["CostNum"];
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_ChipNeed) as TConfigValue;
         this.FComposeRate = _loc1_.Value as int;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_SwalloPelletLevelLimit) as TConfigValue;
         this.FSwallowPelletLevelLimit = _loc1_.Value as int;
         super.ResourcesPerform_UIDispatch();
      }
      
      public function UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderingUI() : void
      {
         this.FTFChipNum.text = this.FCrashJadeData.ChipNum.toString();
         this.FComposeLevelLimit.text = this.FSwallowPelletLevelLimit.toString();
      }
      
      protected function SetCurrentComposeNum(param1:int) : void
      {
         this.FCurrentComopseNum = param1;
         this.FTFPulletNum.text = this.FCurrentComopseNum.toString();
         this.FTFCostNum.text = (this.FCurrentComopseNum * this.FComposeRate).toString();
      }
      
      protected function BtnSubValueOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentComopseNum = this.FCurrentComopseNum <= 0 ? this.FCurrentComopseNum : int(this.FCurrentComopseNum - 1);
         this.SetCurrentComposeNum(this.FCurrentComopseNum);
      }
      
      protected function BtnAddValueOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentComopseNum = this.FCurrentComopseNum >= this.FMaxComposeNum ? this.FCurrentComopseNum : int(this.FCurrentComopseNum + 1);
         this.SetCurrentComposeNum(this.FCurrentComopseNum);
      }
      
      protected function BtnComposeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_ComposeReq);
         _loc3_.Data.writeUnsignedInt(this.FCurrentComopseNum);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function TextChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(this.FTFPulletNum.text);
         if(_loc2_ > this.FMaxComposeNum)
         {
            this.SetCurrentComposeNum(this.FMaxComposeNum);
         }
         else
         {
            this.SetCurrentComposeNum(_loc2_);
         }
      }
      
      public function Show(param1:TCrashJadeData) : void
      {
         this.FCrashJadeData = param1;
         this.Visible = true;
         this.FSlot.Context = param1.CrashJadePellet;
         this.FSlot.Resource["TF_CrashLevel"].text = "";
         this.RenderingUI();
         this.FMaxComposeNum = this.FCrashJadeData.ChipNum / this.FComposeRate;
         this.SetCurrentComposeNum(this.FCurrentComopseNum);
      }
      
      public function ComposeNotify() : void
      {
         this.RenderingUI();
         this.FMaxComposeNum = this.FCrashJadeData.ChipNum / this.FComposeRate;
         this.FCurrentComopseNum = this.FCurrentComopseNum >= this.FMaxComposeNum ? this.FMaxComposeNum : this.FCurrentComopseNum;
         this.SetCurrentComposeNum(this.FCurrentComopseNum);
      }
      
      public function Reset() : void
      {
         this.FSlot.Context = null;
      }
   }
}

