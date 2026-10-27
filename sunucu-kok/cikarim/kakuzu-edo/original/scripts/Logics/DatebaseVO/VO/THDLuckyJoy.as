package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDLuckyJoy extends THDActivityBase
   {
      
      protected var FLotteryIndex:Vector.<int>;
      
      protected var FLotteryCost:Vector.<int>;
      
      protected var FLotteryCount:Vector.<int>;
      
      protected var FSeqIDs:Vector.<int>;
      
      protected var FAwards:Vector.<int>;
      
      protected var FRateType:Vector.<Vector.<int>>;
      
      protected var FScoreExchangeIndexs:Vector.<int>;
      
      protected var FScoreExchangeCosts:Vector.<int>;
      
      protected var FScoreExchangeAwards:Vector.<int>;
      
      protected var FScoreIndex:int;
      
      protected var FFreeTimeIndex:int;
      
      protected var FFreeTimeEveryDay:int;
      
      protected var FRollResultIndex:int;
      
      public function THDLuckyJoy()
      {
         super();
         this.FLotteryIndex = new Vector.<int>();
         this.FLotteryCost = new Vector.<int>();
         this.FLotteryCount = new Vector.<int>();
         this.FSeqIDs = new Vector.<int>();
         this.FAwards = new Vector.<int>();
         this.FRateType = new Vector.<Vector.<int>>();
         this.FScoreExchangeIndexs = new Vector.<int>();
         this.FScoreExchangeCosts = new Vector.<int>();
         this.FScoreExchangeAwards = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         _loc5_ = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FLotteryIndex[_loc4_] = _loc3_[_loc4_].index;
            this.FLotteryCost[_loc4_] = _loc3_[_loc4_].cost;
            this.FLotteryCount[_loc4_] = _loc3_[_loc4_].count;
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         _loc5_ = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FSeqIDs[_loc4_] = _loc3_[_loc4_].seqId;
            this.FRateType[_loc4_] = Vector.<int>(_loc3_[_loc4_].rateType);
            this.FAwards[_loc4_] = _loc3_[_loc4_].award;
            _loc4_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         _loc5_ = int(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FScoreExchangeIndexs[_loc4_] = _loc3_[_loc4_].index;
            this.FScoreExchangeCosts[_loc4_] = _loc3_[_loc4_].costScore;
            this.FScoreExchangeAwards[_loc4_] = _loc3_[_loc4_].award;
            _loc4_++;
         }
         this.FScoreIndex = param1.readInt();
         this.FFreeTimeIndex = param1.readInt();
         this.FFreeTimeEveryDay = param1.readInt();
         this.FRollResultIndex = param1.readInt();
      }
      
      public function get LotteryIndex() : Vector.<int>
      {
         return this.FLotteryIndex;
      }
      
      public function get LotteryCost() : Vector.<int>
      {
         return this.FLotteryCost;
      }
      
      public function get LotteryCount() : Vector.<int>
      {
         return this.FLotteryCount;
      }
      
      public function get SeqIDs() : Vector.<int>
      {
         return this.FSeqIDs;
      }
      
      public function get Awards() : Vector.<int>
      {
         return this.FAwards;
      }
      
      public function get RateType() : Vector.<Vector.<int>>
      {
         return this.FRateType;
      }
      
      public function get ScoreExchangeIndexs() : Vector.<int>
      {
         return this.FScoreExchangeIndexs;
      }
      
      public function get ScoreExchangeCosts() : Vector.<int>
      {
         return this.FScoreExchangeCosts;
      }
      
      public function get ScoreExchangeAwards() : Vector.<int>
      {
         return this.FScoreExchangeAwards;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get FreeTimeIndex() : int
      {
         return this.FFreeTimeIndex;
      }
      
      public function get FreeTimeEveryDay() : int
      {
         return this.FFreeTimeEveryDay;
      }
      
      public function get RollResultIndex() : int
      {
         return this.FRollResultIndex;
      }
      
      public function set RollResultIndex(param1:int) : void
      {
         this.FRollResultIndex = param1;
      }
   }
}

