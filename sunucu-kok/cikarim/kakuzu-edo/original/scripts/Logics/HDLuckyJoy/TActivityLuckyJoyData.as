package Logics.HDLuckyJoy
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityLuckyJoyData extends TActivityOSBase
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
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FExchangeInventories:Vector.<TInventories>;
      
      protected var FCurrentScore:int;
      
      protected var FUsedFreeTime:int;
      
      protected var FHistoryRollAward:Vector.<int>;
      
      protected var FRollResultSeqID:int;
      
      public function TActivityLuckyJoyData()
      {
         super();
         this.FHistoryRollAward = new Vector.<int>();
         this.FAwardInventories = new Vector.<TInventories>();
         this.FExchangeInventories = new Vector.<TInventories>();
      }
      
      public function get LotteryIndex() : Vector.<int>
      {
         return this.FLotteryIndex;
      }
      
      public function set LotteryIndex(param1:Vector.<int>) : void
      {
         this.FLotteryIndex = param1;
      }
      
      public function get LotteryCost() : Vector.<int>
      {
         return this.FLotteryCost;
      }
      
      public function set LotteryCost(param1:Vector.<int>) : void
      {
         this.FLotteryCost = param1;
      }
      
      public function get LotteryCount() : Vector.<int>
      {
         return this.FLotteryCount;
      }
      
      public function set LotteryCount(param1:Vector.<int>) : void
      {
         this.FLotteryCount = param1;
      }
      
      public function get SeqIDs() : Vector.<int>
      {
         return this.FSeqIDs;
      }
      
      public function set SeqIDs(param1:Vector.<int>) : void
      {
         this.FSeqIDs = param1;
      }
      
      public function get Awards() : Vector.<int>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<int>) : void
      {
         this.FAwards = param1;
      }
      
      public function get ScoreExchangeIndexs() : Vector.<int>
      {
         return this.FScoreExchangeIndexs;
      }
      
      public function set ScoreExchangeIndexs(param1:Vector.<int>) : void
      {
         this.FScoreExchangeIndexs = param1;
      }
      
      public function get ScoreExchangeCosts() : Vector.<int>
      {
         return this.FScoreExchangeCosts;
      }
      
      public function set ScoreExchangeCosts(param1:Vector.<int>) : void
      {
         this.FScoreExchangeCosts = param1;
      }
      
      public function get ScoreExchangeAwards() : Vector.<int>
      {
         return this.FScoreExchangeAwards;
      }
      
      public function set ScoreExchangeAwards(param1:Vector.<int>) : void
      {
         this.FScoreExchangeAwards = param1;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function set ScoreIndex(param1:int) : void
      {
         this.FScoreIndex = param1;
      }
      
      public function get FreeTimeIndex() : int
      {
         return this.FFreeTimeIndex;
      }
      
      public function set FreeTimeIndex(param1:int) : void
      {
         this.FFreeTimeIndex = param1;
      }
      
      public function get FreeTimeEveryDay() : int
      {
         return this.FFreeTimeEveryDay;
      }
      
      public function set FreeTimeEveryDay(param1:int) : void
      {
         this.FFreeTimeEveryDay = param1;
      }
      
      public function get HistoryRollAward() : Vector.<int>
      {
         return this.FHistoryRollAward;
      }
      
      public function set HistoryRollAward(param1:Vector.<int>) : void
      {
         this.FHistoryRollAward = param1;
      }
      
      public function get AwardInventories() : Vector.<TInventories>
      {
         return this.FAwardInventories;
      }
      
      public function set AwardInventories(param1:Vector.<TInventories>) : void
      {
         this.FAwardInventories = param1;
      }
      
      public function get ExchangeInventories() : Vector.<TInventories>
      {
         return this.FExchangeInventories;
      }
      
      public function set ExchangeInventories(param1:Vector.<TInventories>) : void
      {
         this.FExchangeInventories = param1;
      }
      
      public function get RollResultIndex() : int
      {
         return this.FRollResultIndex;
      }
      
      public function set RollResultIndex(param1:int) : void
      {
         this.FRollResultIndex = param1;
      }
      
      public function get RollResultSeqID() : int
      {
         return this.FRollResultSeqID;
      }
      
      public function set RollResultSeqID(param1:int) : void
      {
         this.FRollResultSeqID = param1;
      }
      
      public function get LastFreeTime() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.FFreeTimeEveryDay - this.FUsedFreeTime;
         if(_loc1_ > 0)
         {
            return _loc1_;
         }
         return 0;
      }
      
      public function get UsedFreeTime() : int
      {
         return this.FUsedFreeTime;
      }
      
      public function set UsedFreeTime(param1:int) : void
      {
         this.FUsedFreeTime = param1;
      }
      
      public function get CurrentScore() : int
      {
         return this.FCurrentScore;
      }
      
      public function set CurrentScore(param1:int) : void
      {
         this.FCurrentScore = param1;
      }
      
      public function get RateType() : Vector.<Vector.<int>>
      {
         return this.FRateType;
      }
      
      public function set RateType(param1:Vector.<Vector.<int>>) : void
      {
         this.FRateType = param1;
      }
   }
}

