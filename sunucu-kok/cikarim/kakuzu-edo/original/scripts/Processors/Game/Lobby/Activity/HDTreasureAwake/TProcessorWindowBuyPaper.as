package Processors.Game.Lobby.Activity.HDTreasureAwake
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDActivityTreasureAwake.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowBuyPaper extends TProcessorLobbyWindow
   {
      
      protected static const TYPENUM:int = 3;
      
      protected var FMainUI:Sprite;
      
      protected var FNames:Vector.<TextField>;
      
      protected var FOriginalPrices:Vector.<TextField>;
      
      protected var FDiscountPrices:Vector.<TextField>;
      
      protected var FDiscounts:Vector.<TextField>;
      
      protected var FCurrentBuyTimes:Vector.<TextField>;
      
      protected var FBtns:Vector.<TUIButton>;
      
      protected var FSellOutFlag:Vector.<Sprite>;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnBuyIndex:uint;
      
      protected var FAtoms:TActivityAtoms;
      
      protected var FTreasureAwakeData:TActivityTreasureAwakeData;
      
      protected var FOnBtnBuy:Function;
      
      public function TProcessorWindowBuyPaper(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("TreasureBuyPaper") as Sprite;
         addChild(this.FMainUI);
         this.FNames = new Vector.<TextField>();
         this.FOriginalPrices = new Vector.<TextField>();
         this.FDiscountPrices = new Vector.<TextField>();
         this.FDiscounts = new Vector.<TextField>();
         this.FCurrentBuyTimes = new Vector.<TextField>();
         this.FBtns = new Vector.<TUIButton>();
         this.FSellOutFlag = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < TYPENUM)
         {
            _loc2_ = this.FMainUI["type" + _loc1_];
            this.FNames.push(_loc2_["Name"]);
            this.FOriginalPrices.push(_loc2_["OriginalPrices"]);
            this.FDiscountPrices.push(_loc2_["DiscountPrices"]);
            this.FDiscounts.push(_loc2_["Discounts"]);
            this.FCurrentBuyTimes.push(_loc2_["CurrentBuyTimes"]);
            this.FSellOutFlag.push(_loc2_["SellOutFlag"]);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Btn"];
            _loc3_.OnClick = this.BtnBuyOnClick;
            this.FBtns.push(_loc3_);
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
      }
      
      public function UILocation() : void
      {
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < TYPENUM)
         {
            this.FNames[_loc1_].text = this.FTreasureAwakeData.HDTreasueShopeApply.Names[_loc1_];
            this.FDiscountPrices[_loc1_].text = this.FTreasureAwakeData.HDTreasueShopeApply.Golds[_loc1_].toString();
            this.FOriginalPrices[_loc1_].text = this.FTreasureAwakeData.HDTreasueShopeApply.Prices[_loc1_].toString();
            this.FDiscounts[_loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_29),this.FTreasureAwakeData.HDTreasueShopeApply.Discouts[_loc1_]);
            this.FCurrentBuyTimes[_loc1_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_30),this.FTreasureAwakeData.BuyTimes[_loc1_],this.FTreasureAwakeData.HDTreasueShopeApply.Limits[_loc1_]);
            this.FSellOutFlag[_loc1_].visible = this.FTreasureAwakeData.BuyTimes[_loc1_] >= this.FTreasureAwakeData.HDTreasueShopeApply.Limits[_loc1_];
            this.FBtns[_loc1_].Visible = this.FTreasureAwakeData.BuyTimes[_loc1_] < this.FTreasureAwakeData.HDTreasueShopeApply.Limits[_loc1_];
            _loc1_++;
         }
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnBuyIndex = this.FBtns.indexOf(param1 as TUIButton);
         TUtilityLobby.GoldBuy(this.FTreasureAwakeData.HDTreasueShopeApply.Golds[this.FBtnBuyIndex],this.BtnBuyOnClickOK);
      }
      
      protected function BtnBuyOnClickOK(param1:Object) : void
      {
         if(this.FOnBtnBuy != null)
         {
            this.FOnBtnBuy(this,this.FTreasureAwakeData.HDTreasueShopeApply.Indexs[this.FBtnBuyIndex]);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set OnBtnBuy(param1:Function) : void
      {
         this.FOnBtnBuy = param1;
      }
      
      public function Show(param1:TActivityOSBase = null) : void
      {
         this.FTreasureAwakeData = param1 as TActivityTreasureAwakeData;
         this.RenderUI();
         Visible = true;
      }
   }
}

