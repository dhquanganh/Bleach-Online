package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDBleachBagConfig extends THDActivityBase
   {
      
      private var FPerDayFreeIndex:int;
      
      private var FEveryDayFreeAwardVec:Vector.<int>;
      
      private var FEvenyDayRechargeIndexVec:Vector.<int>;
      
      private var FEveryDayRechargeAwardVec:Vector.<Vector.<int>>;
      
      private var FEveryDayConditionVec:Vector.<Vector.<int>>;
      
      private var FFinalAwardIndex:int;
      
      private var FFinalAwardTypeVec:Vector.<int>;
      
      private var FFinalAwardAwardVec:Vector.<int>;
      
      private var FFinalAwardShowIDVec:Vector.<int>;
      
      private var FFinalAwardFightReportAddrVec:Vector.<String>;
      
      private var FBuyIndexVec:Vector.<int>;
      
      private var FBuyCostVec:Vector.<Vector.<int>>;
      
      private var FBuyAwardVec:Vector.<Vector.<int>>;
      
      private var FTaskIndexVec:Vector.<int>;
      
      private var FTaskConditionVec:Vector.<int>;
      
      private var FTaskTypeVec:Vector.<int>;
      
      private var FTaskAward:Vector.<Vector.<int>>;
      
      private var FDesc0:String;
      
      private var FDesc1:String;
      
      private var FDesc2:String;
      
      public function THDBleachBagConfig()
      {
         super();
         this.FEvenyDayRechargeIndexVec = new Vector.<int>();
         this.FEveryDayRechargeAwardVec = new Vector.<Vector.<int>>();
         this.FEveryDayConditionVec = new Vector.<Vector.<int>>();
         this.FFinalAwardAwardVec = new Vector.<int>();
         this.FFinalAwardShowIDVec = new Vector.<int>();
         this.FFinalAwardFightReportAddrVec = new Vector.<String>();
         this.FBuyIndexVec = new Vector.<int>();
         this.FBuyCostVec = new Vector.<Vector.<int>>();
         this.FBuyAwardVec = new Vector.<Vector.<int>>();
         this.FTaskIndexVec = new Vector.<int>();
         this.FTaskConditionVec = new Vector.<int>();
         this.FTaskTypeVec = new Vector.<int>();
         this.FTaskAward = new Vector.<Vector.<int>>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         this.FPerDayFreeIndex = _loc6_.index;
         this.FEveryDayFreeAwardVec = Vector.<int>(_loc6_.award);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FEvenyDayRechargeIndexVec.push(_loc5_[_loc2_].index);
            this.FEveryDayRechargeAwardVec.push(Vector.<int>(_loc5_[_loc2_].award));
            this.FEveryDayConditionVec.push(Vector.<int>(_loc5_[_loc2_].condition));
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         this.FFinalAwardIndex = _loc6_.index;
         this.FFinalAwardTypeVec = Vector.<int>(_loc6_.showType);
         this.FFinalAwardAwardVec = Vector.<int>(_loc6_.award);
         this.FFinalAwardShowIDVec = Vector.<int>(_loc6_.showId);
         this.FFinalAwardFightReportAddrVec = Vector.<String>(_loc6_.fightReport);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBuyIndexVec.push(_loc5_[_loc2_].index);
            this.FBuyCostVec.push(Vector.<int>(_loc5_[_loc2_].cost));
            this.FBuyAwardVec.push(Vector.<int>(_loc5_[_loc2_].award));
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTaskIndexVec.push(_loc5_[_loc2_].index);
            this.FTaskConditionVec.push(_loc5_[_loc2_].condition);
            this.FTaskTypeVec.push(_loc5_[_loc2_].conditionType);
            this.FTaskAward.push(Vector.<int>(_loc5_[_loc2_].award));
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         this.FDesc0 = _loc6_.awardDesc;
         this.FDesc1 = _loc6_.costDesc;
         this.FDesc2 = _loc6_.prompt;
      }
      
      public function get PerDayFreeIndex() : int
      {
         return this.FPerDayFreeIndex;
      }
      
      public function get EveryDayFreeAwardVec() : Vector.<int>
      {
         return this.FEveryDayFreeAwardVec;
      }
      
      public function get EvenyDayRechargeIndexVec() : Vector.<int>
      {
         return this.FEvenyDayRechargeIndexVec;
      }
      
      public function get EveryDayRechargeAwardVec() : Vector.<Vector.<int>>
      {
         return this.FEveryDayRechargeAwardVec;
      }
      
      public function get EveryDayConditionVec() : Vector.<Vector.<int>>
      {
         return this.FEveryDayConditionVec;
      }
      
      public function get FinalAwardIndex() : int
      {
         return this.FFinalAwardIndex;
      }
      
      public function get FinalAwardTypeVec() : Vector.<int>
      {
         return this.FFinalAwardTypeVec;
      }
      
      public function get FinalAwardAwardVec() : Vector.<int>
      {
         return this.FFinalAwardAwardVec;
      }
      
      public function get FinalAwardShowIDVec() : Vector.<int>
      {
         return this.FFinalAwardShowIDVec;
      }
      
      public function get FinalAwardFightReportAddrVec() : Vector.<String>
      {
         return this.FFinalAwardFightReportAddrVec;
      }
      
      public function get BuyIndexVec() : Vector.<int>
      {
         return this.FBuyIndexVec;
      }
      
      public function get BuyCostVec() : Vector.<Vector.<int>>
      {
         return this.FBuyCostVec;
      }
      
      public function get BuyAwardVec() : Vector.<Vector.<int>>
      {
         return this.FBuyAwardVec;
      }
      
      public function get TaskIndexVec() : Vector.<int>
      {
         return this.FTaskIndexVec;
      }
      
      public function get TaskConditionVec() : Vector.<int>
      {
         return this.FTaskConditionVec;
      }
      
      public function get TaskTypeVec() : Vector.<int>
      {
         return this.FTaskTypeVec;
      }
      
      public function get TaskAward() : Vector.<Vector.<int>>
      {
         return this.FTaskAward;
      }
      
      public function get Desc0() : String
      {
         return this.FDesc0;
      }
      
      public function get Desc1() : String
      {
         return this.FDesc1;
      }
      
      public function get Desc2() : String
      {
         return this.FDesc2;
      }
   }
}

