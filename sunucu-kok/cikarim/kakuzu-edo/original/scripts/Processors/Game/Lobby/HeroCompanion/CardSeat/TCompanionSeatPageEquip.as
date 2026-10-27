package Processors.Game.Lobby.HeroCompanion.CardSeat
{
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionCardDatas;
   import Logics.HeroCompanion.THeroCompanionData;
   import Logics.HeroCompanion.THeroCompanionSeatData;
   import Processors.Game.Lobby.HeroCompanion.Components.*;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TCompanionSeatPageEquip extends TCompanionSeatBasePage
   {
      
      protected static const Leader_Page:int = 0;
      
      protected var FLeaderIcon:Sprite;
      
      protected var FSeatDatas:Vector.<THeroCompanionSeatData>;
      
      protected var FSeats:THeroCompanionCardDatas;
      
      protected var FOnDismount:Function;
      
      public function TCompanionSeatPageEquip(param1:TUIComponent, param2:Sprite)
      {
         var _loc3_:int = 0;
         var _loc4_:TCompanionSeatItem = null;
         FPageSize = CONST_HEROCOMPANION.Seat_Equip_Num;
         super(param1,param2);
         this.FLeaderIcon = FMainUI["MC_LeaderIcon"];
         this.FLeaderIcon.visible = false;
         _loc3_ = 0;
         while(_loc3_ < FPageSize)
         {
            _loc4_ = new TCompanionSeatItem(FMainUI["MC_SeatItem_" + _loc3_]);
            _loc4_.UIIndex = _loc3_;
            _loc4_.SeatOnOver = this.SeatOnOver;
            _loc4_.SeatOnOut = this.SeatOnOut;
            _loc4_.OnDismount = this.Dismount;
            FCardVec.push(_loc4_);
            _loc3_++;
         }
         this.FSeats = new THeroCompanionCardDatas();
         InitCardEvent();
      }
      
      override protected function RenderCard() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCompanionSeatItem = null;
         super.RenderCard();
         this.FLeaderIcon.visible = FPageIndex == Leader_Page;
         _loc1_ = int(this.FSeatDatas.length);
         FPage.SetupPage(_loc1_,FPageIndex);
         _loc3_ = FPageIndex * FPageSize;
         _loc4_ = Math.min(_loc3_ + FPageSize,_loc1_);
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = FCardVec[_loc5_] as TCompanionSeatItem;
            _loc6_.SetSeatData(this.FSeatDatas[_loc2_],this.FSeats.GetCardBySeat(_loc2_ + 1));
            _loc2_++;
            _loc5_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < FPageSize)
         {
            _loc6_ = FCardVec[_loc2_] as TCompanionSeatItem;
            _loc6_.ClearData();
            _loc2_++;
         }
      }
      
      protected function Dismount(param1:int, param2:int) : void
      {
         if(this.FOnDismount != null)
         {
            this.FOnDismount(param1,param2);
         }
      }
      
      protected function SeatOnOver(param1:int) : void
      {
         FOnOver(param1);
      }
      
      protected function SeatOnOut() : void
      {
         FOnOut();
      }
      
      override protected function ListOnOut(param1:Object, param2:MouseEvent) : void
      {
         FOnOut();
      }
      
      public function get CardVec() : Vector.<TCompanionSeatItem>
      {
         return Vector.<TCompanionSeatItem>(FCardVec);
      }
      
      public function get CurPage() : int
      {
         return FPageIndex;
      }
      
      public function get OnDismount() : Function
      {
         return this.FOnDismount;
      }
      
      public function set OnDismount(param1:Function) : void
      {
         this.FOnDismount = param1;
      }
      
      override public function SetCardData(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroCompanionCardData = null;
         super.SetCardData(param1);
         _loc3_ = FData.CardDatas.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FData.CardDatas.GetCardByIndex(_loc2_);
            if(_loc4_.Seat > 0)
            {
               this.FSeats.AddCard(_loc4_);
            }
            _loc2_++;
         }
         this.FSeatDatas = FData.SeatDatas.concat(FData.SeatVips,FData.SeatFever);
         Render();
      }
   }
}

