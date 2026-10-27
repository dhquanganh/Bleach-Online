package Logics.HeroCompanion
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class THeroCompanionCardDatas
   {
      
      protected var FCardDatas:Vector.<THeroCompanionCardData>;
      
      public function THeroCompanionCardDatas()
      {
         super();
         this.FCardDatas = new Vector.<THeroCompanionCardData>();
      }
      
      protected function GetLastCardId(param1:int) : int
      {
         var _loc2_:TCompanionCard = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,param1) as TCompanionCard;
         if(_loc2_.NextId == 0)
         {
            return param1;
         }
         return this.GetLastCardId(_loc2_.NextId);
      }
      
      public function get Count() : int
      {
         return this.FCardDatas.length;
      }
      
      public function GetCardByIndex(param1:int) : THeroCompanionCardData
      {
         if(param1 >= this.FCardDatas.length)
         {
            return null;
         }
         return this.FCardDatas[param1];
      }
      
      public function GetCardByLastId(param1:int) : THeroCompanionCardData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FCardDatas.length)
         {
            if(this.FCardDatas[_loc2_].LastCard == param1)
            {
               return this.FCardDatas[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetCardBySeat(param1:int) : THeroCompanionCardData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FCardDatas.length)
         {
            if(this.FCardDatas[_loc2_].Seat == param1)
            {
               return this.FCardDatas[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function AddCard(param1:THeroCompanionCardData) : void
      {
         this.FCardDatas.push(param1);
      }
      
      public function AddCardData(param1:TCompanionCard, param2:Boolean = false) : void
      {
         var _loc3_:THeroCompanionCardData = null;
         if(param2 == true)
         {
            _loc3_ = new THeroCompanionCardData();
            this.FCardDatas.push(_loc3_);
         }
         else
         {
            _loc3_ = this.FCardDatas[this.FCardDatas.length - 1];
            if(param1.NextId == 0)
            {
               _loc3_.LastCard = param1.Identifier;
            }
         }
         _loc3_.Cards.push(param1);
      }
      
      public function SetCardStatus(param1:int, param2:int = -1) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TCompanionCard = null;
         _loc5_ = this.GetLastCardId(param1);
         _loc4_ = int(this.FCardDatas.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FCardDatas[_loc3_].LastCard == _loc5_)
            {
               _loc6_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(param2 != -1)
         {
            this.FCardDatas[_loc6_].Seat = param2;
         }
         _loc4_ = int(this.FCardDatas[_loc6_].Cards.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FCardDatas[_loc6_].Cards[_loc3_];
            if(_loc7_.Identifier == param1)
            {
               this.FCardDatas[_loc6_].Level = _loc7_.Level;
               break;
            }
            _loc3_++;
         }
      }
      
      public function GetCards() : Vector.<THeroCompanionCardData>
      {
         return this.FCardDatas;
      }
      
      public function Clear() : void
      {
         this.FCardDatas.length = 0;
      }
   }
}

