package Processors.Game.Lobby.Activity.HDActivitySwiftChange
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDSwiftChange.TActivitySwiftChangData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowDebrisMarket extends TProcessorLobbyWindow
   {
      
      protected const SLOTNUM:int = 6;
      
      protected var FScene:Sprite;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FSps:Vector.<Sprite>;
      
      protected var FBtnClose:TUIButton;
      
      protected var FUIPage:TUIPage;
      
      protected var FBuyAmounts:Vector.<TextField>;
      
      protected var FBuyCostGolds:Vector.<TextField>;
      
      protected var FDebrisNames:Vector.<TextField>;
      
      protected var FBuyBtns:Vector.<MovieClip>;
      
      protected var FBuyTButtons:Vector.<TUIButton>;
      
      protected var FStarLevels:Vector.<Sprite>;
      
      protected var FDebrisNum:Vector.<TextField>;
      
      protected var FCurrentPageIndex:int = 0;
      
      protected var FActivitySwiftChangeData:TActivitySwiftChangData;
      
      protected var FOnBtnBuyDebris:Function;
      
      public function TProcessorHDWindowDebrisMarket(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.UpdateSlots();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:Sprite = null;
         var _loc4_:TUIButton = null;
         var _loc5_:Sprite = null;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("DebrisMarket") as Sprite;
         addChild(this.FScene);
         this.FSlots = new Vector.<TUISlot>();
         this.FBuyAmounts = new Vector.<TextField>();
         this.FBuyCostGolds = new Vector.<TextField>();
         this.FBuyBtns = new Vector.<MovieClip>();
         this.FBuyTButtons = new Vector.<TUIButton>();
         this.FSps = new Vector.<Sprite>();
         this.FDebrisNames = new Vector.<TextField>();
         this.FStarLevels = new Vector.<Sprite>();
         this.FDebrisNum = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < this.SLOTNUM)
         {
            _loc3_ = this.FScene["Item" + _loc1_];
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = _loc3_["Slot"];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.Init();
            this.FSlots.push(_loc2_);
            this.FBuyAmounts.push(_loc3_["TF_BuyAmount"]);
            this.FBuyCostGolds.push(_loc3_["TF_Gold"]);
            this.FDebrisNames.push(_loc3_["TF_Name"]);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_["Btn_Buy"];
            _loc4_.OnClick = this.BtnBuyOperateOnClick;
            this.FBuyTButtons.push(_loc4_);
            this.FBuyBtns.push(_loc3_["Btn_Buy"]);
            this.FSps.push(_loc3_);
            _loc5_ = _loc3_["HeroChangLevel"];
            _loc5_.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            _loc5_.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
            this.FStarLevels.push(_loc5_);
            (_loc3_["TF_Amount"] as TextField).selectable = false;
            (_loc3_["TF_Amount"] as TextField).mouseEnabled = false;
            this.FDebrisNum.push(_loc3_["TF_Amount"]);
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FScene["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FScene["MC_Page"]["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FScene["MC_Page"]["MC_PageRight"];
         this.FUIPage.LabelPage = this.FScene["MC_Page"]["TF_Page"];
         this.FUIPage.PageSize = this.SLOTNUM;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FUIPage.Init();
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.SetupPage(this.FActivitySwiftChangeData.DataList.length,this.FCurrentPageIndex);
         this.RenderDebrisList();
      }
      
      protected function RenderDebrisList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         _loc3_ = 0;
         _loc1_ = this.FCurrentPageIndex * this.SLOTNUM;
         _loc2_ = (this.FCurrentPageIndex + 1) * this.SLOTNUM;
         _loc4_ = _loc1_;
         while(_loc4_ < _loc2_)
         {
            if(_loc4_ < this.FActivitySwiftChangeData.ExchangeInventories.length)
            {
               _loc6_ = this.FActivitySwiftChangeData.ExchangeInventories[_loc4_];
               this.FSlots[_loc3_].Context = null;
               this.FSlots[_loc3_].Context = _loc6_.GetInventoryByIndex(0);
               this.FBuyCostGolds[_loc3_].text = this.FActivitySwiftChangeData.DataList[_loc4_].Cost.toString();
               this.FDebrisNames[_loc3_].text = this.FActivitySwiftChangeData.DataList[_loc4_].DebrisHeroName;
               this.FBuyAmounts[_loc3_].text = this.FActivitySwiftChangeData.DataList[_loc4_].UseLimit + "/" + this.FActivitySwiftChangeData.DataList[_loc4_].Limit.toString();
               this.FSps[_loc3_].visible = true;
               this.FBuyTButtons[_loc3_].Enabled = this.FActivitySwiftChangeData.DataList[_loc4_].UseLimit >= this.FActivitySwiftChangeData.DataList[_loc4_].Limit ? false : true;
               this.FDebrisNum[_loc3_].text = _loc6_.GetInventoryByIndex(0).Quantity.toString();
            }
            else
            {
               this.FSps[_loc3_].visible = false;
               this.FBuyTButtons[_loc3_].Enabled = true;
            }
            _loc3_++;
            _loc4_++;
         }
      }
      
      protected function BtnBuyOperateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FCurrentPageIndex * this.SLOTNUM + this.FBuyTButtons.indexOf(param1 as TUIButton);
         if(this.FOnBtnBuyDebris != null)
         {
            this.FOnBtnBuyDebris(this,_loc3_);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FCurrentPageIndex * this.SLOTNUM + this.FStarLevels.indexOf(param1.currentTarget);
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FActivitySwiftChangeData.DataList[_loc2_].HeroId));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FCurrentPageIndex * this.SLOTNUM + this.FStarLevels.indexOf(param1.currentTarget);
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FActivitySwiftChangeData.DataList[_loc2_].HeroId));
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
         this.FCurrentPageIndex = param2;
      }
      
      public function set ActivitySwiftChangeData(param1:TActivitySwiftChangData) : void
      {
         this.FActivitySwiftChangeData = param1;
      }
      
      public function set OnBtnBuyDebris(param1:Function) : void
      {
         this.FOnBtnBuyDebris = param1;
      }
      
      public function Show() : void
      {
         this.DebrisList();
         Visible = true;
      }
      
      public function DebrisList() : void
      {
         if(!this.Visible)
         {
            this.FCurrentPageIndex = 0;
         }
         this.SetupPage(this.FActivitySwiftChangeData.DataList.length,this.FCurrentPageIndex);
         this.RenderDebrisList();
      }
   }
}

