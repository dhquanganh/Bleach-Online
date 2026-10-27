package Processors.Game.Lobby.HeroCompanion.CardSeat
{
   import Foundation.UI.TUIComponent;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.*;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.Sprite;
   
   public class TCompanionSeatPageCard extends TCompanionSeatBasePage
   {
      
      protected var FCardDatas:Vector.<THeroCompanionCardData>;
      
      public function TCompanionSeatPageCard(param1:TUIComponent, param2:Sprite)
      {
         var _loc3_:int = 0;
         var _loc4_:TCompanionCardItem = null;
         FPageSize = CONST_HEROCOMPANION.Seat_Card_Num;
         super(param1,param2);
         FPage.LabelPage = FMainUI["TF_Page"];
         _loc3_ = 0;
         while(_loc3_ < FPageSize)
         {
            _loc4_ = new TCompanionCardItem(FMainUI["MC_Card_" + _loc3_]);
            FCardVec.push(_loc4_);
            _loc3_++;
         }
         InitCardEvent();
      }
      
      override protected function RenderCard() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THeroCompanionCardData = null;
         var _loc7_:Vector.<THeroCompanionCardData> = null;
         super.RenderCard();
         _loc7_ = new Vector.<THeroCompanionCardData>();
         _loc1_ = FData.CardDatas.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc6_ = FData.CardDatas.GetCardByIndex(_loc2_);
            if(_loc6_.Seat <= 0)
            {
               if(_loc6_.Level > 0)
               {
                  _loc7_.push(_loc6_);
               }
            }
            _loc2_++;
         }
         _loc1_ = int(_loc7_.length);
         FPage.SetupPage(_loc1_,FPageIndex);
         _loc3_ = FPageIndex * FPageSize;
         _loc4_ = Math.min(_loc3_ + FPageSize,_loc1_);
         _loc2_ = _loc3_;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = _loc7_[_loc2_];
            FCardVec[_loc5_].SetData(_loc6_.GetCurCard());
            _loc2_++;
            _loc5_++;
         }
         _loc2_ = _loc5_;
         while(_loc2_ < FPageSize)
         {
            FCardVec[_loc2_].ClearData();
            _loc2_++;
         }
      }
      
      public function get CardVec() : Vector.<TCompanionCardItem>
      {
         return FCardVec;
      }
      
      override public function SetCardData(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.SetCardData(param1);
         Render();
      }
   }
}

