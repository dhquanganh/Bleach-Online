package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewHalloweenRecharge extends THDActivityBase
   {
      
      private var FScoreIndex:int;
      
      private var FEveryDayGiftIndexVec:Vector.<int>;
      
      private var FEveryDayGiftConditionVec:Vector.<int>;
      
      private var FEveryDayGiftAwardVec:Vector.<int>;
      
      private var FDayRechargeIndex:int;
      
      private var FTotalRechargeIndex:int;
      
      private var FTotalGoldGiftIndexVec:Vector.<int>;
      
      private var FTotalGoldGiftConditionVec:Vector.<int>;
      
      private var FTotalGoldGiftAwardVec:Vector.<int>;
      
      private var FScoreMallIndexVec:Vector.<int>;
      
      private var FScoreMallCostScoreVec:Vector.<int>;
      
      private var FScoreMallLimitVec:Vector.<int>;
      
      private var FScoreMallAwardVec:Vector.<int>;
      
      public function THDNewHalloweenRecharge()
      {
         super();
         this.FEveryDayGiftIndexVec = new Vector.<int>();
         this.FEveryDayGiftConditionVec = new Vector.<int>();
         this.FEveryDayGiftAwardVec = new Vector.<int>();
         this.FTotalGoldGiftIndexVec = new Vector.<int>();
         this.FTotalGoldGiftConditionVec = new Vector.<int>();
         this.FTotalGoldGiftAwardVec = new Vector.<int>();
         this.FScoreMallIndexVec = new Vector.<int>();
         this.FScoreMallCostScoreVec = new Vector.<int>();
         this.FScoreMallLimitVec = new Vector.<int>();
         this.FScoreMallAwardVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FScoreIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FEveryDayGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FEveryDayGiftConditionVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FEveryDayGiftAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         this.FDayRechargeIndex = param1.readUnsignedInt();
         this.FTotalRechargeIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTotalGoldGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FTotalGoldGiftConditionVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FTotalGoldGiftAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FScoreMallIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FScoreMallCostScoreVec[_loc2_] = _loc4_[_loc2_].costScore;
            this.FScoreMallLimitVec[_loc2_] = _loc4_[_loc2_].limit;
            this.FScoreMallAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get EveryDayGiftIndexVec() : Vector.<int>
      {
         return this.FEveryDayGiftIndexVec;
      }
      
      public function get EveryDayGiftConditionVec() : Vector.<int>
      {
         return this.FEveryDayGiftConditionVec;
      }
      
      public function get EveryDayGiftAwardVec() : Vector.<int>
      {
         return this.FEveryDayGiftAwardVec;
      }
      
      public function get DayRechargeIndex() : int
      {
         return this.FDayRechargeIndex;
      }
      
      public function get TotalRechargeIndex() : int
      {
         return this.FTotalRechargeIndex;
      }
      
      public function get TotalGoldGiftIndexVec() : Vector.<int>
      {
         return this.FTotalGoldGiftIndexVec;
      }
      
      public function get TotalGoldGiftConditionVec() : Vector.<int>
      {
         return this.FTotalGoldGiftConditionVec;
      }
      
      public function get TotalGoldGiftAwardVec() : Vector.<int>
      {
         return this.FTotalGoldGiftAwardVec;
      }
      
      public function get ScoreMallIndexVec() : Vector.<int>
      {
         return this.FScoreMallIndexVec;
      }
      
      public function get ScoreMallCostScoreVec() : Vector.<int>
      {
         return this.FScoreMallCostScoreVec;
      }
      
      public function get ScoreMallLimitVec() : Vector.<int>
      {
         return this.FScoreMallLimitVec;
      }
      
      public function get ScoreMallAwardVec() : Vector.<int>
      {
         return this.FScoreMallAwardVec;
      }
   }
}

