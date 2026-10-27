package Processors.Game.Lobby.Activity.HDLuckyJoy
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.HDLuckyJoy.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowScoreExchange extends TProcessorLobbyWindow
   {
      
      protected static const TABNUM:int = 4;
      
      protected static const SLOTNUM:int = 6;
      
      protected var FScene:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FAwardCosts:Vector.<TextField>;
      
      protected var FAwardExchangeBtns:Vector.<TUIButton>;
      
      protected var FCurrentTabIndex:int;
      
      protected var FBtnClose:TUIButton;
      
      protected var FTFScore:TextField;
      
      protected var FActivityLuckyJoyData:TActivityLuckyJoyData;
      
      protected var FOnBtnExchangeClick:Function;
      
      public function TProcessorHDWindowScoreExchange(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
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
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("LuckyJoyExchange") as Sprite;
         addChild(this.FScene);
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < TABNUM)
         {
            this.FUITab.SetTabByIndex(this.FScene["Tab" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FSlots = new Vector.<TUISlot>();
         this.FAwardCosts = new Vector.<TextField>();
         this.FAwardExchangeBtns = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < SLOTNUM)
         {
            _loc3_ = this.FScene["Award" + _loc1_];
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = _loc3_["Slot"];
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.Init();
            this.FSlots.push(_loc2_);
            this.FAwardCosts.push(_loc3_["ScoreCost"]);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_["Btn_Exchange"];
            _loc4_.OnClick = this.BtnExchangeOnClick;
            this.FAwardExchangeBtns.push(_loc4_);
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FScene["btnClose"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTFScore = this.FScene["CurrentScore"];
      }
      
      protected function RenderArticles() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         _loc3_ = 0;
         _loc1_ = this.FCurrentTabIndex * SLOTNUM;
         _loc2_ = _loc1_ + SLOTNUM;
         _loc4_ = _loc1_;
         while(_loc4_ < _loc2_)
         {
            _loc6_ = this.FActivityLuckyJoyData.ExchangeInventories[_loc4_];
            this.FSlots[_loc3_].Context = null;
            this.FSlots[_loc3_].Context = _loc6_.GetInventoryByIndex(0);
            this.FAwardCosts[_loc3_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_78),this.FActivityLuckyJoyData.ScoreExchangeCosts[_loc4_]);
            this.FAwardExchangeBtns[_loc3_].Enabled = this.FActivityLuckyJoyData.CurrentScore >= this.FActivityLuckyJoyData.ScoreExchangeCosts[_loc4_];
            _loc3_++;
            _loc4_++;
         }
         this.FTFScore.text = this.FActivityLuckyJoyData.CurrentScore.toString();
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
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.RenderArticles();
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FAwardExchangeBtns.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentTabIndex * SLOTNUM;
         if(this.FOnBtnExchangeClick != null)
         {
            this.FOnBtnExchangeClick(this,this.FActivityLuckyJoyData.ScoreExchangeIndexs[_loc3_]);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set ActivityLuckyJoyData(param1:TActivityLuckyJoyData) : void
      {
         this.FActivityLuckyJoyData = param1;
      }
      
      public function set OnBtnExchangeClick(param1:Function) : void
      {
         this.FOnBtnExchangeClick = param1;
      }
      
      public function Show() : void
      {
         this.FUITab.SwithTagManual(0);
         Visible = true;
      }
      
      public function Update() : void
      {
         this.RenderArticles();
      }
   }
}

