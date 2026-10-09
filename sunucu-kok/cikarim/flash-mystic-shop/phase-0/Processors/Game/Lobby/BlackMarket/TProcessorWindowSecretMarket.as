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
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Resources.Textures.TAnimationSequence;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TProcessorWindowSecretMarket extends TProcessorLobbyWindow
   {
      
      protected static const ItemNum:int = 10;
      protected static const CurrencyID:uint = 14900001;
      protected var FCurrencyRequested:Boolean = false;
      protected var FMysticCaptions:Array = [];
      
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
      
      protected var FDurationTime:int;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FBlackMarketTotalData:TBlackMarketTotalData;
      
      protected var FOnMarketClose:Function;
      
      public function TProcessorWindowSecretMarket(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.RenderTimeCounter();
            this.UpdateSlot();
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
         this.FGoodsSlots = new Vector.<TUISlot>();
         this.FGoodsPrePrice = new Vector.<TextField>();
         this.FGoodsNowPrice = new Vector.<TextField>();
         this.FGoodsPrePriceICoin = new Vector.<MovieClip>();
         this.FGoodsNowPriceICoin = new Vector.<MovieClip>();
         this.FGoodsBuyFlag = new Vector.<Sprite>();
         this.FTimeLable = param2["Lable"];
         this.FTimeCounter = param2["TimeCounter"];
         this.FBtnFlush = new TUIButton();
         this.FBtnFlush.Substrate = param2["Btn_Upgrade"];
         this.FBtnFlush.OnClick = null;
         _loc3_ = 0;
         while(_loc3_ < ItemNum)
         {
            _loc6_ = param1["Item" + _loc3_];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc6_["BackBoard"];
            _loc4_.OnClick = null;
            this.FGoodsButtons.push(_loc4_);
            this.FGoodsUI.push(_loc6_);
            this.FGoodsNames.push(_loc6_["Name"]);
            this.FGoodsPrePrice.push(_loc6_["PrePrice"]);
            this.FGoodsNowPrice.push(_loc6_["NowPrice"]);
            this.FGoodsBuyFlag.push(_loc6_["BuyFlag"]);
            this.FGoodsNames[_loc3_].mouseEnabled = false;
            this.FGoodsPrePrice[_loc3_].mouseEnabled = false;
            this.FGoodsNowPrice[_loc3_].mouseEnabled = false;
            this.FGoodsPrePriceICoin.push(_loc6_["PreIcon"]);
            this.FGoodsNowPriceICoin.push(_loc6_["NowIcon"]);
            _loc3_++;
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
         _loc2_ = int(this.FBlackMarketTotalData.SecretMarketData.GoodsVec.length);
         _loc6_ = this.FCurrentPageIndex * ItemNum;
         _loc7_ = _loc6_ + ItemNum;
         _loc7_ = _loc7_ > _loc2_ ? _loc2_ : _loc7_;
         _loc8_ = 0;
         _loc1_ = _loc6_;
         while(_loc1_ < _loc7_)
         {
            _loc3_ = this.FBlackMarketTotalData.SecretMarketData.Configs[_loc1_];
            this.FGoodsUI[_loc8_].visible = true;
            _loc5_ = this.FBlackMarketTotalData.SecretMarketData.Inventories.GetInventoryByIndex(_loc1_);
            this.FGoodsNames[_loc8_].text = _loc3_.ItemID == 14130055 ? "M\u1ea3nh BW Ulquiorra" : _loc5_.Name;
            this.FGoodsNames[_loc8_].embedFonts = false;
            this.FGoodsNames[_loc8_].setTextFormat(new TextFormat("Arial",10,0xffd866,true));
            this.FGoodsSlots[_loc8_].Context = _loc5_;
            this.FGoodsPrePrice[_loc8_].text = _loc3_.OldPrice.amount.toString();
            this.FGoodsNowPrice[_loc8_].text = _loc3_.Price.amount.toString();
            this.FGoodsBuyFlag[_loc8_].visible = false;
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
         this.FTimeLable.text = "Nguy\u00ean th\u1ea1ch:";
         this.RenderCurrencyIcons();
      }
      
      protected function RenderTimeCounter() : void
      {
         this.FTimeCounter.text = TUtilityLobby.GetArticleQuantity(CurrencyID,1).toString();
         this.RenderCurrencyIcons();
      }

      protected function RenderCurrencyIcons() : void
      {
         var texture:TTexture = SResourcesCore.TexturesInventory.GetTextureByIdentifier(CurrencyID);
         if(texture == null)
         {
            if(!this.FCurrencyRequested)
            {
               this.FCurrencyRequested = true;
               SResourcesCore.TexturesInventory.LoadSecondary(CurrencyID);
            }
            return;
         }
         var sequence:TAnimationSequence = texture.GetAnimationSequenceByIdentifier(0);
         if(sequence == null || sequence.Count == 0) return;
         for(var i:int = 0; i < ItemNum; i++)
         {
            this.SetCurrencyIcon(this.FGoodsPrePriceICoin[i],sequence);
            this.SetCurrencyIcon(this.FGoodsNowPriceICoin[i],sequence);
         }
      }

      protected function SetCurrencyIcon(coin:MovieClip, sequence:TAnimationSequence) : void
      {
         var name:String = "MysticGem_" + coin.name;
         var bitmap:Bitmap = coin.parent.getChildByName(name) as Bitmap;
         if(bitmap == null)
         {
            bitmap = new Bitmap(sequence.GetAnimationFrameByIndex(0).Surface,"auto",true);
            bitmap.name = name;
            bitmap.width = 18;
            bitmap.height = 18;
            var bounds:Object = coin.getBounds(coin);
            bitmap.x = coin.x + bounds.x + (bounds.width - 18) / 2;
            bitmap.y = coin.y + bounds.y + (bounds.height - 18) / 2;
            coin.parent.addChild(bitmap);
         }
         bitmap.visible = true;
         coin.visible = false;
      }

      protected function RestoreCurrencyIcons() : void
      {
         for(var i:int = 0; i < ItemNum; i++)
         {
            var coins:Array = [this.FGoodsPrePriceICoin[i],this.FGoodsNowPriceICoin[i]];
            for each(var coin:MovieClip in coins)
            {
               coin.visible = true;
               var bitmap:Object = coin.parent.getChildByName("MysticGem_" + coin.name);
               if(bitmap != null) bitmap.visible = false;
            }
         }
      }

      protected function SetMysticCaption(root:DisplayObjectContainer) : void
      {
         for(var i:int = 0; i < root.numChildren; i++)
         {
            var child:Object = root.getChildAt(i);
            if(child is TextField && String(child.text).toLowerCase().indexOf("coupon") >= 0)
            {
               this.FMysticCaptions.push({field:child,text:child.text});
               child.text = "Ch\u1ec9 d\u00f9ng Nguy\u00ean th\u1ea1ch - \u0111\u1ed5i kh\u00f4ng gi\u1edbi h\u1ea1n";
            }
            if(child is DisplayObjectContainer) this.SetMysticCaption(child as DisplayObjectContainer);
         }
      }

      protected function BuyGoodsReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_BuyGoodReq);
         _loc2_.Data.writeInt(CONST_BLACKMARKET.MarketID_SecretMarket);
         _loc2_.Data.writeInt(SUtilityOverLayer.UIWindowConfirmation.Tag);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function FlushGoodsReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_RefreshReq);
         _loc2_.Data.writeInt(CONST_BLACKMARKET.MarketID_SecretMarket);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
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
         if(this.FGoodsSlots == null) return;
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
      
      protected function ItemOnClick(param1:Object, param2:MouseEvent) : void
      {
         var index:int = this.FGoodsButtons.indexOf(param1 as TUIButton) + this.FCurrentPageIndex * ItemNum;
         if(index < 0 || index >= this.FBlackMarketTotalData.SecretMarketData.Configs.length) return;
         var offer:TBlackMarket = this.FBlackMarketTotalData.SecretMarketData.Configs[index];
         if(TUtilityLobby.GetArticleQuantity(CurrencyID,1) < offer.Price.amount)
         {
            SToolReward.ShowMessage("Kh\u00f4ng \u0111\u1ee7 Nguy\u00ean th\u1ea1ch.");
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Tag = offer.Identifier;
         SUtilityOverLayer.UIWindowConfirmation.Text = "D\u00f9ng " + offer.Price.amount + " Nguy\u00ean th\u1ea1ch \u0111\u1ec3 \u0111\u1ed5i " + offer.Number + " " + this.FBlackMarketTotalData.SecretMarketData.Inventories.GetInventoryByIndex(index).Name + "?";
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
      }

      protected function BtnFlushOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FlushGoodsReq(this);
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
      
      public function set OnMarketClose(param1:Function) : void
      {
         this.FOnMarketClose = param1;
      }
      
      public function Update() : void
      {
         this.RenderGoodsItem();
      }
      
      public function Show(param1:TUIPage, param2:TBlackMarketTotalData, param3:Vector.<TUISlot>) : void
      {
         this.FUIPage = param1;
         this.FUIPage.OnChangePage = this.OnChangePage;
         this.FBlackMarketTotalData = param2;
         this.FGoodsSlots = param3;
         this.SetupPage(this.FBlackMarketTotalData.SecretMarketData.GoodsVec.length,0,this.FUIPage);
         this.FCurrentPageIndex = 0;
         this.RenderGoodsItem();
         this.SetEventBind(true);
         this.SetMysticCaption(this.FGoodsUI[0].parent.parent);
         this.RenderTimeCounter();
         Visible = true;
      }
      
      public function Hide() : void
      {
         this.SetEventBind(false);
         this.RestoreCurrencyIcons();
         for each(var caption:Object in this.FMysticCaptions) caption.field.text = caption.text;
         this.FMysticCaptions.length = 0;
         Visible = false;
         this.ResetSlot();
         this.FCurrentPageIndex = 0;
      }
      
      public function BuyRetNotify() : void
      {
         this.RenderGoodsItem();
      }
   }
}

