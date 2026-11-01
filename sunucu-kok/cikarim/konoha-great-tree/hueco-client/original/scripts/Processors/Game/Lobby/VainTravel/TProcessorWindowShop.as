package Processors.Game.Lobby.VainTravel
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelShopData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowShop extends TProcessorLobbyWindow
   {
      
      protected static const SlotNum:int = 12;
      
      protected var FMainUI:Sprite;
      
      protected var FTFChipNum:TextField;
      
      protected var FTFNextResetTime:TextField;
      
      protected var FBtnReset:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FGoodsUI:Vector.<Sprite>;
      
      protected var FExchangeFlags:Vector.<Sprite>;
      
      protected var FGoodSlots:Vector.<TUISlot>;
      
      protected var FTFCosts:Vector.<TextField>;
      
      protected var FBtnExchanges:Vector.<TUIButton>;
      
      protected var FHint:THint;
      
      protected var FMCIcon:Sprite;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FNextFlushTimeIndex:int;
      
      protected var FVainTravelCoinName:String;
      
      protected var FVainTravelData:TVainTravelData;
      
      protected var FVainTravelShopData:TVainTravelShopData;
      
      public function TProcessorWindowShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSlot();
            this.UpdateNextFlushTime();
            this.CheckCurrentGoods();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TArticle = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("VainTravelShop") as Sprite;
         addChild(this.FMainUI);
         this.FGoodsUI = new Vector.<Sprite>();
         this.FExchangeFlags = new Vector.<Sprite>();
         this.FGoodSlots = new Vector.<TUISlot>();
         this.FTFCosts = new Vector.<TextField>();
         this.FBtnExchanges = new Vector.<TUIButton>();
         _loc2_ = SlotNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMainUI["MC_Item_" + _loc1_];
            this.FGoodsUI.push(_loc3_);
            this.FExchangeFlags.push(_loc3_["MC_ExchangeFinish"]);
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["Slot"];
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.Init();
            this.FGoodSlots.push(_loc4_);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_["Btn_Exchange"];
            _loc5_.OnClick = this.BtnExchangeOnClick;
            this.FBtnExchanges.push(_loc5_);
            this.FTFCosts.push(_loc3_["Txt_Value"]);
            _loc1_++;
         }
         _loc3_ = this.FMainUI["MC_Page"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = _loc3_["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = _loc3_["MC_PageRight"];
         this.FUIPage.LabelPage = _loc3_["TF_Page"];
         this.FUIPage.PageSize = SlotNum;
         this.FUIPage.OnChangePage = this.UIPageOnChange;
         this.FUIPage.Init();
         this.FBtnReset = new TUIButton();
         this.FBtnReset.Substrate = this.FMainUI["Btn_Reset"];
         this.FBtnReset.OnClick = this.BtnResetOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTFChipNum = this.FMainUI["Txt_Value"];
         this.FTFNextResetTime = this.FMainUI["Txt_Time"];
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,CONST_CONFIGVALUE.VainTravelCoin) as TArticle;
         this.FVainTravelCoinName = _loc6_.Name;
         this.FHint = new THint();
         this.FHint.Caption = this.FVainTravelCoinName;
         this.FMCIcon = this.FMainUI["MC_Icon"];
         this.FMCIcon.addEventListener(MouseEvent.MOUSE_MOVE,this.IconOnMove);
         this.FMCIcon.addEventListener(MouseEvent.MOUSE_OUT,this.IconOnOut);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FNextFlushTimeIndex = -1;
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderShop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.FCurrentPageIndex * SlotNum;
         _loc2_ = Math.min(_loc1_ + SlotNum,this.FVainTravelData.VainTravelShopData.GoodsVec.length);
         _loc4_ = _loc1_;
         while(_loc4_ < _loc2_)
         {
            this.FGoodSlots[_loc3_].Context = this.FVainTravelShopData.Inventories.GetInventoryByIndex(_loc4_);
            this.FExchangeFlags[_loc3_].visible = this.FVainTravelShopData.BuiedTime[_loc4_] != 0;
            this.FBtnExchanges[_loc3_].Enabled = !this.FExchangeFlags[_loc3_].visible;
            this.FTFCosts[_loc3_].text = this.FVainTravelShopData.Configs[_loc4_].Price.amount.toString();
            this.FGoodsUI[_loc3_].visible = true;
            _loc4_++;
            _loc3_++;
         }
         _loc4_ = _loc3_;
         while(_loc4_ < SlotNum)
         {
            this.FGoodsUI[_loc4_].visible = false;
            this.FGoodSlots[_loc3_].Context = null;
            _loc4_++;
         }
         this.FTFChipNum.text = this.FVainTravelData.VainTravelCoinNum.toString();
      }
      
      protected function UpdateNextFlushTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         _loc3_ = int(this.FVainTravelData.VainTravelShopData.FlushTime.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FVainTravelData.VainTravelShopData.FlushTime[_loc2_] * CONST_COMMON.SecondPerHour;
            if(_loc1_ < _loc4_)
            {
               break;
            }
            _loc2_++;
         }
         _loc2_ = _loc2_ == _loc3_ ? 0 : int(_loc2_);
         if(this.FNextFlushTimeIndex != _loc2_)
         {
            this.FTFNextResetTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_20),TUtilityTiming.fomatTime(this.FVainTravelData.VainTravelShopData.FlushTime[_loc2_] * CONST_COMMON.SecondPerHour));
            this.FNextFlushTimeIndex = _loc2_;
         }
      }
      
      protected function CheckCurrentGoods() : void
      {
         if(Visible)
         {
            if(this.IfJumpTriggerTime(this.FVainTravelData.VainTravelShopData.CurrentGoodBornTime,this.FVainTravelData.VainTravelShopData.FlushTime) && this.FVainTravelData.VainTravelShopData.RequestNewFlushTime != this.FVainTravelData.VainTravelShopData.CurrentGoodBornTime)
            {
               this.ShopInforReq();
               this.FVainTravelData.VainTravelShopData.RequestNewFlushTime = this.FVainTravelData.VainTravelShopData.CurrentGoodBornTime;
            }
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
      
      protected function ShopInforReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_InitDataReq);
         _loc1_.Data.writeInt(CONST_BLACKMARKET.MarketID_VainTravelMarket);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function RequestReset(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_RefreshReq);
         _loc2_.Data.writeInt(CONST_BLACKMARKET.MarketID_VainTravelMarket);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function IconOnMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function IconOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FVainTravelShopData.CurrentFlashTime >= this.FVainTravelShopData.FlushCosts.length)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_18));
            return;
         }
         if(this.FVainTravelShopData.FlushCosts[this.FVainTravelShopData.CurrentFlashTime].amount > this.FVainTravelData.VainTravelCoinNum)
         {
            SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_21),this.FVainTravelCoinName));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_19),this.FVainTravelShopData.FlushCosts[this.FVainTravelShopData.CurrentFlashTime].amount,this.FVainTravelCoinName);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.RequestReset;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Reset();
         ProcessorWindowClose();
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = this.FBtnExchanges.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentPageIndex * SlotNum;
         if(this.FVainTravelShopData.Configs[_loc3_].Price.amount > this.FVainTravelData.VainTravelCoinNum)
         {
            SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_21),this.FVainTravelCoinName));
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_BuyGoodReq);
         _loc4_.Data.writeInt(CONST_BLACKMARKET.MarketID_VainTravelMarket);
         _loc4_.Data.writeUnsignedInt(this.FVainTravelShopData.GoodsVec[_loc3_]);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function UIPageOnChange(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderShop();
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = SlotNum;
         _loc1_ = 0;
         while(_loc1_ < SlotNum)
         {
            this.FGoodSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function Show(param1:TVainTravelData) : void
      {
         this.FVainTravelData = param1;
         this.FVainTravelShopData = this.FVainTravelData.VainTravelShopData;
         Visible = true;
         this.SetupPage(this.FVainTravelShopData.GoodsVec.length,0,this.FUIPage);
         this.RenderShop();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = SlotNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGoodSlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.FNextFlushTimeIndex = -1;
      }
   }
}

