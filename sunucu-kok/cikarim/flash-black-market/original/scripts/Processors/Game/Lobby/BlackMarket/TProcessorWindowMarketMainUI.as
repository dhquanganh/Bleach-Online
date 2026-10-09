package Processors.Game.Lobby.BlackMarket
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.BlackMarket.TBlackMarketTotalData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowMarketMainUI extends TProcessorLobbyWindow
   {
      
      protected static const TabIndex_BlackMarket:int = 0;
      
      protected static const TabIndex_SecretMarket:int = 1;
      
      protected var FUITab:TUITab;
      
      protected var FMainUI:Sprite;
      
      protected var FUIPage:TUIPage;
      
      protected var FLanternLeft:MovieClip;
      
      protected var FLanternRight:MovieClip;
      
      protected var FProcessorWindowBlackMarket:TProcessorWindowBlackMarket;
      
      protected var FProcessorWindowScretMarket:TProcessorWindowSecretMarket;
      
      protected var FGoodsSlots:Vector.<TUISlot>;
      
      protected var FBtnClose:TUIButton;
      
      protected var FCurrentTabIndex:int;
      
      protected var FBlackMarketTotalData:TBlackMarketTotalData;
      
      public function TProcessorWindowMarketMainUI(param1:TUIComponent)
      {
         super(param1);
         this.FProcessorWindowBlackMarket = new TProcessorWindowBlackMarket(this);
         this.FProcessorWindowScretMarket = new TProcessorWindowSecretMarket(this);
         this.FProcessorWindowScretMarket.OnMarketClose = this.CloseSecretMarket;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            if(this.IfJumpTriggerTime(this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime,this.FBlackMarketTotalData.BlackMarketData.FlushTime) && this.FBlackMarketTotalData.BlackMarketData.RequestNewFlushTime != this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime)
            {
               this.ReqMarketGoodsInfor(CONST_BLACKMARKET.MarketID_BlackMarket);
               this.FBlackMarketTotalData.BlackMarketData.RequestNewFlushTime = this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime;
               this.FBlackMarketTotalData.BlackMarketData.Inited = false;
            }
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("BlackMarketUI") as Sprite;
         addChild(this.FMainUI);
         this.FLanternLeft = this.FMainUI["LanternLeft"];
         this.FLanternRight = this.FMainUI["LanternRight"];
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(this.FMainUI["MC_Tab_0"],0);
         this.FUITab.SetTabByIndex(this.FMainUI["MC_Tab_1"],1);
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FProcessorWindowBlackMarket.UIDispatch(this.FMainUI["ItemPanle"],this.FMainUI["CounterTimePanle"]);
         this.FProcessorWindowScretMarket.UIDispatch(this.FMainUI["ItemPanle"],this.FMainUI["CounterTimePanle"]);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_Page"]["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_Page"]["MC_PageRight"];
         this.FUIPage.LabelPage = this.FMainUI["MC_Page"]["TF_Page"];
         this.FUIPage.PageSize = 10;
         this.FUIPage.Init();
         this.FGoodsSlots = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < 10)
         {
            _loc1_ = this.FMainUI["ItemPanle"]["Item" + _loc2_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc1_["MC_Slot"];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FGoodsSlots.push(_loc3_);
            _loc2_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FMainUI.visible = false;
         super.ResourcesPerform_UILocations();
      }
      
      protected function SetupLantern(param1:Boolean) : void
      {
         if(param1)
         {
            this.FLanternLeft.play();
            this.FLanternRight.play();
         }
         else
         {
            this.FLanternLeft.gotoAndStop(1);
            this.FLanternRight.gotoAndStop(1);
         }
      }
      
      protected function IfJumpTriggerTime(param1:int, param2:Vector.<int>) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         _loc5_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         _loc5_ = STimingCore.ServerTick - _loc5_;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = param2[_loc3_] * CONST_COMMON.SecondPerHour + _loc5_;
            if(param1 < _loc6_ && STimingCore.ServerTick > _loc6_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function ReqMarketGoodsInfor(param1:int) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_InitDataReq);
         _loc2_.Data.writeInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function CheckIfFlushGoods() : Boolean
      {
         switch(this.FCurrentTabIndex)
         {
            case TabIndex_BlackMarket:
               if(!this.FBlackMarketTotalData.BlackMarketData.Inited || this.IfJumpTriggerTime(this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime,this.FBlackMarketTotalData.BlackMarketData.FlushTime))
               {
                  return true;
               }
               return false;
               break;
            case TabIndex_SecretMarket:
               return !this.FBlackMarketTotalData.SecretMarketData.Inited;
            default:
               return false;
         }
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         var _loc2_:Boolean = false;
         this.FCurrentTabIndex = param1;
         _loc2_ = this.CheckIfFlushGoods();
         if(_loc2_)
         {
            switch(param1)
            {
               case TabIndex_BlackMarket:
                  this.ReqMarketGoodsInfor(CONST_BLACKMARKET.MarketID_BlackMarket);
                  this.FBlackMarketTotalData.BlackMarketData.Inited = false;
                  break;
               case TabIndex_SecretMarket:
                  this.ReqMarketGoodsInfor(CONST_BLACKMARKET.MarketID_SecretMarket);
                  this.FBlackMarketTotalData.SecretMarketData.Inited = false;
            }
         }
         else
         {
            switch(param1)
            {
               case TabIndex_BlackMarket:
                  this.FProcessorWindowScretMarket.Hide();
                  this.FProcessorWindowBlackMarket.Show(this.FUIPage,this.FBlackMarketTotalData,this.FGoodsSlots);
                  break;
               case TabIndex_SecretMarket:
                  this.FProcessorWindowBlackMarket.Hide();
                  this.FProcessorWindowScretMarket.Show(this.FUIPage,this.FBlackMarketTotalData,this.FGoodsSlots);
            }
         }
      }
      
      protected function CloseSecretMarket(param1:Object) : void
      {
         this.FUITab.SetTabHideByIndex(TabIndex_SecretMarket);
      }
      
      protected function OpenSecretMarket(param1:Object) : void
      {
         this.FUITab.SetTabShowByIndex(TabIndex_SecretMarket);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      public function Reset() : void
      {
         this.SetupLantern(false);
      }
      
      public function Show(param1:TBlackMarketTotalData) : void
      {
         this.FBlackMarketTotalData = param1;
         this.SetupLantern(true);
         Visible = true;
         if(this.FBlackMarketTotalData.SecretMarketData.SecretMarketState == CONST_BLACKMARKET.MarketState_Close)
         {
            this.CloseSecretMarket(this);
         }
         else
         {
            this.OpenSecretMarket(this);
         }
         this.FUITab.SwithTagManual(0);
      }
      
      public function GoodsInforNotify() : void
      {
         switch(this.FCurrentTabIndex)
         {
            case TabIndex_BlackMarket:
               this.FProcessorWindowScretMarket.Hide();
               this.FProcessorWindowBlackMarket.Show(this.FUIPage,this.FBlackMarketTotalData,this.FGoodsSlots);
               break;
            case TabIndex_SecretMarket:
               this.FProcessorWindowBlackMarket.Hide();
               this.FProcessorWindowScretMarket.Show(this.FUIPage,this.FBlackMarketTotalData,this.FGoodsSlots);
         }
         this.FMainUI.visible = true;
      }
      
      public function SecretMarketOpenNotify() : void
      {
         if(this.FCurrentTabIndex == TabIndex_SecretMarket)
         {
            this.ReqMarketGoodsInfor(CONST_BLACKMARKET.MarketID_SecretMarket);
         }
      }
      
      public function BuyRetNotify() : void
      {
         switch(this.FCurrentTabIndex)
         {
            case TabIndex_BlackMarket:
               this.FProcessorWindowBlackMarket.BuyRetNotify();
               break;
            case TabIndex_SecretMarket:
               this.FProcessorWindowScretMarket.BuyRetNotify();
         }
      }
   }
}

