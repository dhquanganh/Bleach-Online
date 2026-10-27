package Processors.Game.Lobby.HeroCompanion.CardSeat
{
   import Components.Pages.TUIPage;
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TCompanionSeatBasePage
   {
      
      protected var FMainUI:Sprite;
      
      protected var FPage:TUIPage;
      
      protected var FData:THeroCompanionData;
      
      protected var FPageSize:int;
      
      protected var FPageIndex:int;
      
      protected var FCardVec:Vector.<TCompanionCardItem>;
      
      protected var FCardIndex:int;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnDown:Function;
      
      protected var FTipOnOver:Function;
      
      public function TCompanionSeatBasePage(param1:TUIComponent, param2:Sprite)
      {
         super();
         this.FMainUI = param2;
         this.FCardVec = new Vector.<TCompanionCardItem>();
         this.FPage = new TUIPage(param1);
         this.FPage.ButtonPrevious.Substrate = this.FMainUI["MC_PageLeft"];
         this.FPage.ButtonNext.Substrate = this.FMainUI["MC_PageRight"];
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.PageSize = this.FPageSize;
         this.FPage.Init();
      }
      
      protected function InitCardEvent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FCardVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FCardVec[_loc1_].ItemOnDown = this.ListOnDown;
            this.FCardVec[_loc1_].ItemOnOver = this.ListOnOver;
            this.FCardVec[_loc1_].ItemOnMove = this.ListOnMove;
            this.FCardVec[_loc1_].ItemOnOut = this.ListOnOut;
            _loc1_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.RenderCard();
      }
      
      protected function ListOnDown(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TCompanionCardItem;
         _loc4_ = this.FCardVec.indexOf(_loc3_);
         if(this.FOnDown != null && _loc4_ != -1)
         {
            this.FCardIndex = _loc4_;
            this.FOnDown(this.FCardIndex);
         }
      }
      
      protected function ListOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TCompanionCardItem;
         _loc4_ = this.FCardVec.indexOf(_loc3_);
         if(this.FOnOver != null && _loc4_ != -1)
         {
            this.FCardIndex = _loc4_;
            this.FOnOver(this.FCardIndex);
         }
      }
      
      protected function ListOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FCardIndex = -1;
         if(this.FOnOut != null)
         {
            this.FOnOut();
         }
      }
      
      protected function ListOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionCardItem = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TCompanionCardItem;
         _loc4_ = this.FCardVec.indexOf(_loc3_);
         if(this.FTipOnOver != null && _loc4_ != -1)
         {
            this.FCardIndex = _loc4_;
            this.FTipOnOver(this.FCardVec[this.FCardIndex].Data);
         }
      }
      
      protected function RenderCard() : void
      {
      }
      
      public function get CardIndex() : int
      {
         return this.FCardIndex;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnDown() : Function
      {
         return this.FOnDown;
      }
      
      public function set OnDown(param1:Function) : void
      {
         this.FOnDown = param1;
      }
      
      public function get TipOnOver() : Function
      {
         return this.FTipOnOver;
      }
      
      public function set TipOnOver(param1:Function) : void
      {
         this.FTipOnOver = param1;
      }
      
      public function SetCardData(param1:THeroCompanionData) : void
      {
         this.FData = param1;
      }
      
      public function Render() : void
      {
         this.RenderCard();
      }
   }
}

