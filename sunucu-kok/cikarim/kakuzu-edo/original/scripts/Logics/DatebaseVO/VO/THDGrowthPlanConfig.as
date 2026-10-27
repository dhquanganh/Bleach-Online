package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGrowthPlanConfig extends THDActivityBase
   {
      
      private var FAwardIndexVec:Vector.<int>;
      
      private var FAwardLevelVec:Vector.<int>;
      
      private var FAwardGoldVec:Vector.<int>;
      
      private var FTotalRechargeIndex:int;
      
      private var FSpendGoldValue:int;
      
      private var FBuyIndex:int;
      
      private var FCondition:int;
      
      public function THDGrowthPlanConfig()
      {
         super();
         this.FAwardIndexVec = new Vector.<int>();
         this.FAwardLevelVec = new Vector.<int>();
         this.FAwardGoldVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FAwardLevelVec[_loc2_] = _loc4_[_loc2_].level;
            this.FAwardGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            _loc2_++;
         }
         this.FTotalRechargeIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FBuyIndex = _loc6_.index;
         this.FCondition = _loc6_.condition;
         this.FSpendGoldValue = _loc6_.cost;
      }
      
      public function get AwardIndexVec() : Vector.<int>
      {
         return this.FAwardIndexVec;
      }
      
      public function get AwardLevelVec() : Vector.<int>
      {
         return this.FAwardLevelVec;
      }
      
      public function get AwardGoldVec() : Vector.<int>
      {
         return this.FAwardGoldVec;
      }
      
      public function get TotalRechargeIndex() : int
      {
         return this.FTotalRechargeIndex;
      }
      
      public function get SpendGoldValue() : int
      {
         return this.FSpendGoldValue;
      }
      
      public function get BuyIndex() : int
      {
         return this.FBuyIndex;
      }
      
      public function get Condition() : int
      {
         return this.FCondition;
      }
   }
}

