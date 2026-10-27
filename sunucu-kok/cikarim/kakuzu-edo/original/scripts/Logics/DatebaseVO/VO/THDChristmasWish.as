package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChristmasWish extends THDActivityBase
   {
      
      private var FRankAwardsVec:Vector.<int>;
      
      private var FRankPromptVec:Vector.<String>;
      
      private var FOneKeyIndex:int;
      
      private var FOneGoldCost:int;
      
      private var FTurntableAwardVec:Vector.<int>;
      
      private var FTenKeyIndex:int;
      
      private var FAllServerIndexVec:Vector.<int>;
      
      private var FAllServerConditionVec:Vector.<int>;
      
      private var FAllServerAwardVec:Vector.<int>;
      
      private var FRechargeCondition:int;
      
      private var FMarketIndexVec:Vector.<int>;
      
      private var FMarketCostVec:Vector.<int>;
      
      private var FMarketAwardVec:Vector.<int>;
      
      private var FMarketCardVec:Vector.<int>;
      
      private var FMarketLimitVec:Vector.<int>;
      
      private var FAllServerBellIndex:int;
      
      private var FFreeValueIndex:int;
      
      private var FExchangeBellIdex:int;
      
      private var FTotalBellIndex:int;
      
      private var FOneKeyPrompt:String;
      
      private var FOneWishPrompt:String;
      
      private var FBellPrompt:String;
      
      private var FRankNum:int;
      
      private var FCardTypeCodeObj:Object;
      
      public function THDChristmasWish()
      {
         super();
         this.FRankAwardsVec = new Vector.<int>();
         this.FRankPromptVec = new Vector.<String>();
         this.FTurntableAwardVec = new Vector.<int>();
         this.FAllServerIndexVec = new Vector.<int>();
         this.FAllServerConditionVec = new Vector.<int>();
         this.FAllServerAwardVec = new Vector.<int>();
         this.FMarketIndexVec = new Vector.<int>();
         this.FMarketCostVec = new Vector.<int>();
         this.FMarketAwardVec = new Vector.<int>();
         this.FMarketCardVec = new Vector.<int>();
         this.FMarketLimitVec = new Vector.<int>();
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
            this.FRankAwardsVec[_loc2_] = _loc4_[_loc2_].value;
            this.FRankPromptVec[_loc2_] = _loc4_[_loc2_].prompt;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FOneKeyIndex = _loc6_.index;
         this.FOneGoldCost = _loc6_.goldCost;
         _loc4_ = _loc6_.award;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTurntableAwardVec[_loc2_] = _loc4_[_loc2_].awardId;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FTenKeyIndex = _loc6_.index;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAllServerIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FAllServerConditionVec[_loc2_] = _loc4_[_loc2_].condition;
            this.FAllServerAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRechargeCondition = _loc6_.condition;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMarketIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FMarketCostVec[_loc2_] = _loc4_[_loc2_].costBell;
            this.FMarketAwardVec[_loc2_] = _loc4_[_loc2_].award;
            this.FMarketCardVec[_loc2_] = _loc4_[_loc2_].greetingCard;
            this.FMarketLimitVec[_loc2_] = _loc4_[_loc2_].limit;
            _loc2_++;
         }
         this.FAllServerBellIndex = param1.readUnsignedInt();
         this.FFreeValueIndex = param1.readUnsignedInt();
         this.FExchangeBellIdex = param1.readUnsignedInt();
         this.FTotalBellIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FOneKeyPrompt = _loc6_.oneKeyWishPrompt;
         this.FOneWishPrompt = _loc6_.wishPrompt;
         this.FBellPrompt = _loc6_.bellPrompt;
         this.FRankNum = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FCardTypeCodeObj = _loc6_;
      }
      
      public function get RankAwardsVec() : Vector.<int>
      {
         return this.FRankAwardsVec;
      }
      
      public function get RankPromptVec() : Vector.<String>
      {
         return this.FRankPromptVec;
      }
      
      public function get OneKeyIndex() : int
      {
         return this.FOneKeyIndex;
      }
      
      public function get OneGoldCost() : int
      {
         return this.FOneGoldCost;
      }
      
      public function get TenKeyIndex() : int
      {
         return this.FTenKeyIndex;
      }
      
      public function get TurntableAwardVec() : Vector.<int>
      {
         return this.FTurntableAwardVec;
      }
      
      public function get AllServerIndexVec() : Vector.<int>
      {
         return this.FAllServerIndexVec;
      }
      
      public function get AllServerConditionVec() : Vector.<int>
      {
         return this.FAllServerConditionVec;
      }
      
      public function get AllServerAwardVec() : Vector.<int>
      {
         return this.FAllServerAwardVec;
      }
      
      public function get RechargeCondition() : int
      {
         return this.FRechargeCondition;
      }
      
      public function get MarketIndexVec() : Vector.<int>
      {
         return this.FMarketIndexVec;
      }
      
      public function get MarketCostVec() : Vector.<int>
      {
         return this.FMarketCostVec;
      }
      
      public function get MarketAwardVec() : Vector.<int>
      {
         return this.FMarketAwardVec;
      }
      
      public function get MarketCardVec() : Vector.<int>
      {
         return this.FMarketCardVec;
      }
      
      public function get MarketLimitVec() : Vector.<int>
      {
         return this.FMarketLimitVec;
      }
      
      public function get AllServerBellIndex() : int
      {
         return this.FAllServerBellIndex;
      }
      
      public function get FreeValueIndex() : int
      {
         return this.FFreeValueIndex;
      }
      
      public function get ExchangeBellIdex() : int
      {
         return this.FExchangeBellIdex;
      }
      
      public function get TotalBellIndex() : int
      {
         return this.FTotalBellIndex;
      }
      
      public function get OneKeyPrompt() : String
      {
         return this.FOneKeyPrompt;
      }
      
      public function get OneWishPrompt() : String
      {
         return this.FOneWishPrompt;
      }
      
      public function get BellPrompt() : String
      {
         return this.FBellPrompt;
      }
      
      public function get CardTypeCodeObj() : Object
      {
         return this.FCardTypeCodeObj;
      }
      
      public function get RankNum() : int
      {
         return this.FRankNum;
      }
   }
}

