package Processors.Game.Lobby.BlackMarket
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.BlackMarket.TBlackMarketTotalData;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowBlackMarket extends TProcessorLobbyWindow
   {
      
      protected static const ItemNum:int = 10;
      
      protected var FGoodsUI:Vector.<Sprite>;
      
      protected var FGoodsButtons:Vector.<TUIButton>;
      
      protected var FGoodsNames:Vector.<TextField>;
      
      protected var FGoodsSlots:Vector.<TUISlot>;
      
      protected var FGoodsPrePrice:Vector.<TextField>;
      
      protected var FGoodsNowPrice:Vector.<TextField>;
      
      protected var FGoodsPrePriceICoin:Vector.<MovieClip>;
      
      protected var FGoodsNowPriceICoin:Vector.<MovieClip>;
      
      protected var FGoodsBuyFlag:Vector.<Sprite>;
      
      protected var FTimeLable:TextField;
      
      protected var FTimeCounter:TextField;
      
      protected var FBtnFlush:TUIButton;
      
      protected var FNextFlushTimeIndex:int;
      
      protected var FCurrentPageIndex:int;
      
      protected var FUIPage:TUIPage;
      
      protected var FBlackMarketTotalData:TBlackMarketTotalData;
      
      public function TProcessorWindowBlackMarket(param1:TUIComponent)
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
         }
      }
      
      public function UIDispatch(param1:Sprite, param2:Sprite) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:TUISlot = null;
         var _loc6_:MovieClip = null;
         this.FGoodsUI = new Vector.<Sprite>();
         this.FGoodsButtons = new Vector.<TUIButton>();
         this.FGoodsNames = new Vector.<TextField>();
         this.FGoodsPrePrice = new Vector.<TextField>();
         this.FGoodsNowPrice = new Vector.<TextField>();
         this.FGoodsPrePriceICoin = new Vector.<MovieClip>();
         this.FGoodsNowPriceICoin = new Vector.<MovieClip>();
         this.FGoodsBuyFlag = new Vector.<Sprite>();
         this.FTimeLable = param2["Lable"];
         this.FTimeCounter = param2["TimeCounter"];
         this.FBtnFlush = new TUIButton();
         this.FBtnFlush.Substrate = param2["Btn_Upgrade"];
         this.FBtnFlush.OnClick = this.BtnFlushOnClick;
         _loc3_ = 0;
         while(_loc3_ < ItemNum)
         {
            _loc6_ = param1["Item" + _loc3_];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc6_["BackBoard"];
            _loc4_.OnClick = this.ItemOnClick;
            this.FGoodsButtons.push(_loc4_);
            this.FGoodsUI.push(_loc6_);
            this.FGoodsNames.push(_loc6_["Name"]);
            this.FGoodsPrePrice.push(_loc6_["PrePrice"]);
            this.FGoodsNowPrice.push(_loc6_["NowPrice"]);
            this.FGoodsBuyFlag.push(_loc6_["BuyFlag"]);
            this.FGoodsPrePriceICoin.push(_loc6_["PreIcon"]);
            this.FGoodsNowPriceICoin.push(_loc6_["NowIcon"]);
            _loc3_++;
         }
         this.UpdateGoldCaption(param2);
         this.FNextFlushTimeIndex = -1;
      }
      
      protected function UpdateGoldCaption(root:DisplayObjectContainer) : void
      {
         for(var i:int = 0; i < root.numChildren; i++)
         {
            var child:Object = root.getChildAt(i);
            if(child is TextField && String(child.text).toLowerCase().indexOf("coupons first") >= 0)
            {
               child.text = "Epic EXP Scroll: 50 Gold for 50";
            }
            if(child is DisplayObjectContainer) this.UpdateGoldCaption(child as DisplayObjectContainer);
         }
      }

      protected function SetEventBind(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < ItemNum)
         {
            if(param1)
            {
               this.FGoodsButtons[_loc2_].OnClick = this.ItemOnClick;
               this.FBtnFlush.OnClick = this.BtnFlushOnClick;
            }
            else
            {
               this.FGoodsButtons[_loc2_].OnClick = null;
               this.FBtnFlush.OnClick = null;
            }
            _loc2_++;
         }
      }
      
      protected function RenderGoodsItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBlackMarket = null;
         var _loc4_:TArticle = null;
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc2_ = int(this.FBlackMarketTotalData.BlackMarketData.GoodsVec.length);
         _loc6_ = this.FCurrentPageIndex * ItemNum;
         _loc7_ = _loc6_ + ItemNum;
         _loc7_ = _loc7_ > _loc2_ ? _loc2_ : _loc7_;
         _loc8_ = 0;
         _loc2_ = int(this.FBlackMarketTotalData.BlackMarketData.GoodsVec.length);
         _loc1_ = _loc6_;
         while(_loc1_ < _loc7_)
         {
            _loc3_ = this.FBlackMarketTotalData.BlackMarketData.Configs[_loc1_];
            this.FGoodsUI[_loc8_].visible = true;
            _loc5_ = this.FBlackMarketTotalData.BlackMarketData.Inventories.GetInventoryByIndex(_loc1_);
            this.FGoodsNames[_loc8_].text = _loc5_.Name;
            this.FGoodsSlots[_loc8_].Context = _loc5_;
            this.FGoodsPrePrice[_loc8_].text = _loc3_.OldPrice.amount.toString();
            this.FGoodsNowPrice[_loc8_].text = _loc3_.Price.amount.toString();
            this.FGoodsBuyFlag[_loc8_].visible = this.FBlackMarketTotalData.BlackMarketData.BuiedTime[_loc1_] >= _loc3_.TotalTimes;
            switch(CONST_COMMON.RewardIDToTemplateID(_loc3_.OldPrice.type,_loc3_.OldPrice.code))
            {
               case CONST_BLACKMARKET.CoinType_Sliver:
                  this.FGoodsPrePriceICoin[_loc8_].gotoAndStop(1);
                  break;
               case CONST_BLACKMARKET.CoinType_Gold:
                  this.FGoodsPrePriceICoin[_loc8_].gotoAndStop(3);
                  break;
               case CONST_BLACKMARKET.CoinType_GiftCoin:
                  this.FGoodsPrePriceICoin[_loc8_].gotoAndStop(2);
            }
            switch(CONST_COMMON.RewardIDToTemplateID(_loc3_.Price.type,_loc3_.Price.code))
            {
               case CONST_BLACKMARKET.CoinType_Sliver:
                  this.FGoodsNowPriceICoin[_loc8_].gotoAndStop(1);
                  break;
               case CONST_BLACKMARKET.CoinType_Gold:
                  this.FGoodsNowPriceICoin[_loc8_].gotoAndStop(3);
                  break;
               case CONST_BLACKMARKET.CoinType_GiftCoin:
                  this.FGoodsNowPriceICoin[_loc8_].gotoAndStop(2);
            }
            _loc8_++;
            _loc1_++;
         }
         _loc1_ = _loc8_;
         while(_loc1_ < ItemNum)
         {
            this.FGoodsUI[_loc1_].visible = false;
            _loc1_++;
         }
         this.FTimeLable.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_06),this.FBlackMarketTotalData.BlackMarketData.FlushTime[0],this.FBlackMarketTotalData.BlackMarketData.FlushTime[1]);
      }
      
      protected function BuyGoodsReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_BuyGoodReq);
         _loc2_.Data.writeInt(CONST_BLACKMARKET.MarketID_BlackMarket);
         _loc2_.Data.writeInt(SUtilityOverLayer.UIWindowConfirmation.Tag);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function FlushGoodsReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_RefreshReq);
         _loc2_.Data.writeInt(CONST_BLACKMARKET.MarketID_BlackMarket);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ItemOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TBlackMarket = null;
         var _loc5_:String = null;
         _loc3_ = this.FGoodsButtons.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentPageIndex * ItemNum;
         _loc4_ = this.FBlackMarketTotalData.BlackMarketData.Configs[_loc3_];
         if(this.FBlackMarketTotalData.BlackMarketData.BuiedTime[_loc3_] >= _loc4_.TotalTimes)
         {
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Tag = _loc4_.Identifier;
         switch(CONST_COMMON.RewardIDToTemplateID(_loc4_.Price.type,_loc4_.Price.code))
         {
            case CONST_BLACKMARKET.CoinType_GiftCoin:
               _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_02);
               break;
            case CONST_BLACKMARKET.CoinType_Gold:
               _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_03);
               break;
            case CONST_BLACKMARKET.CoinType_Sliver:
               this.BuyGoodsReq(this);
               return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(_loc5_,_loc4_.Price.amount);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
      }
      
      protected function BtnFlushOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FBlackMarketTotalData.BlackMarketData.FlushCosts.length <= this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_04));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BlackMarket_05),this.FBlackMarketTotalData.BlackMarketData.FlushCosts[this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime].amount);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.FlushGoodsReq;
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FGoodsSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGoodsSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ResetSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FGoodsSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGoodsSlots[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function UpdateNextFlushTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FBlackMarketTotalData.BlackMarketData.ServerRefreshSeconds > 0)
         {
            this.FTimeCounter.text = TUtilityTiming.fomatTime(Math.max(0,this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime + this.FBlackMarketTotalData.BlackMarketData.ServerRefreshSeconds - STimingCore.ServerTick));
            return;
         }
         _loc1_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         _loc3_ = int(this.FBlackMarketTotalData.BlackMarketData.FlushTime.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FBlackMarketTotalData.BlackMarketData.FlushTime[_loc2_] * CONST_COMMON.SecondPerHour;
            if(_loc1_ < _loc4_)
            {
               break;
            }
            _loc2_++;
         }
         _loc2_ = _loc2_ == _loc3_ ? 0 : int(_loc2_);
         if(this.FNextFlushTimeIndex != _loc2_)
         {
            this.FTimeCounter.text = TUtilityTiming.fomatTime(this.FBlackMarketTotalData.BlackMarketData.FlushTime[_loc2_] * CONST_COMMON.SecondPerHour);
         }
      }
      
      protected function OnChangePage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderGoodsItem();
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      public function Update() : void
      {
         this.RenderGoodsItem();
      }
      
      public function Show(param1:TUIPage, param2:TBlackMarketTotalData, param3:Vector.<TUISlot>) : void
      {
         this.FBlackMarketTotalData = param2;
         this.FUIPage = param1;
         this.FUIPage.OnChangePage = this.OnChangePage;
         this.FGoodsSlots = param3;
         this.SetupPage(this.FBlackMarketTotalData.BlackMarketData.GoodsVec.length,0,this.FUIPage);
         this.FCurrentPageIndex = 0;
         this.RenderGoodsItem();
         this.SetEventBind(true);
         Visible = true;
      }
      
      public function Hide() : void
      {
         this.SetEventBind(false);
         this.FNextFlushTimeIndex = -1;
         Visible = false;
         this.ResetSlot();
      }
      
      public function BuyRetNotify() : void
      {
         this.RenderGoodsItem();
      }
   }
}

