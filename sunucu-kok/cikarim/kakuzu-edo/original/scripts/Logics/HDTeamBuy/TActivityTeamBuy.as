package Logics.HDTeamBuy
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityTeamBuy extends TActivityOSBase
   {
      
      protected var FTBCurDay:uint;
      
      protected var FTBAwards:Vector.<TActivityTBAward>;
      
      protected var FTBOffRates:Vector.<TActivityTBOffRate>;
      
      protected var FTBOffRatesWithSort:Vector.<TActivityTBOffRate>;
      
      protected var FTBSignBox:TActivityTBBox;
      
      protected var FTBBuyBox:TActivityTBBox;
      
      protected var FTBSignedPeople:uint;
      
      protected var FTBBoughtPeople:uint;
      
      protected var FTBStatus:uint;
      
      protected var FTBCurPirce:uint;
      
      protected var FTBFavorablePeople:int;
      
      protected var FTBCurLevel:uint;
      
      protected var FTBCurAward:TActivityTBAward;
      
      protected var FTBTimeZero:int;
      
      protected var FTBTimeStartSign:int;
      
      protected var FTBTimeEndSign:int;
      
      protected var FTBTimeStartBuy:int;
      
      protected var FTBTimeEndBuy:int;
      
      protected var FTBTimeTwentyFour:int;
      
      public function TActivityTeamBuy()
      {
         super();
      }
      
      protected function ProcessorSortTBOffRates() : void
      {
         this.FTBOffRatesWithSort = this.FTBOffRatesWithSort.sort(this.SortOnOffRate);
      }
      
      protected function SortOnOffRate(param1:TActivityTBOffRate, param2:TActivityTBOffRate) : Number
      {
         if(param1.Sort < param2.Sort)
         {
            return -1;
         }
         if(param1.Sort > param2.Sort)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : uint
      {
         if(this.FTBAwards == null)
         {
            return 0;
         }
         return this.FTBAwards.length;
      }
      
      public function set TBAwards(param1:Vector.<TActivityTBAward>) : void
      {
         this.FTBAwards = param1;
      }
      
      public function set TBOffRates(param1:Vector.<TActivityTBOffRate>) : void
      {
         this.FTBOffRates = param1;
      }
      
      public function get TBOffRatesWithSort() : Vector.<TActivityTBOffRate>
      {
         return this.FTBOffRatesWithSort;
      }
      
      public function get TBSignedPeople() : uint
      {
         return this.FTBSignedPeople;
      }
      
      public function set TBSignedPeople(param1:uint) : void
      {
         this.FTBSignedPeople = param1;
      }
      
      public function get TBBoughtPeople() : uint
      {
         return this.FTBBoughtPeople;
      }
      
      public function set TBBoughtPeople(param1:uint) : void
      {
         this.FTBBoughtPeople = param1;
      }
      
      public function get TBCurDay() : uint
      {
         return this.FTBCurDay;
      }
      
      public function set TBCurDay(param1:uint) : void
      {
         this.FTBCurDay = param1;
      }
      
      public function get TBSignBox() : TActivityTBBox
      {
         return this.FTBSignBox;
      }
      
      public function set TBSignBox(param1:TActivityTBBox) : void
      {
         this.FTBSignBox = param1;
      }
      
      public function get TBBuyBox() : TActivityTBBox
      {
         return this.FTBBuyBox;
      }
      
      public function set TBBuyBox(param1:TActivityTBBox) : void
      {
         this.FTBBuyBox = param1;
      }
      
      public function get TBStatus() : uint
      {
         return this.FTBStatus;
      }
      
      public function set TBStatus(param1:uint) : void
      {
         this.FTBStatus = param1;
      }
      
      public function get TBTimeZero() : int
      {
         return this.FTBTimeZero;
      }
      
      public function set TBTimeZero(param1:int) : void
      {
         this.FTBTimeZero = param1;
      }
      
      public function get TBTimeStartSign() : int
      {
         return this.FTBTimeStartSign;
      }
      
      public function set TBTimeStartSign(param1:int) : void
      {
         this.FTBTimeStartSign = param1;
      }
      
      public function get TBTimeEndSign() : int
      {
         return this.FTBTimeEndSign;
      }
      
      public function set TBTimeEndSign(param1:int) : void
      {
         this.FTBTimeEndSign = param1;
      }
      
      public function get TBTimeStartBuy() : int
      {
         return this.FTBTimeStartBuy;
      }
      
      public function set TBTimeStartBuy(param1:int) : void
      {
         this.FTBTimeStartBuy = param1;
      }
      
      public function get TBTimeEndBuy() : int
      {
         return this.FTBTimeEndBuy;
      }
      
      public function set TBTimeEndBuy(param1:int) : void
      {
         this.FTBTimeEndBuy = param1;
      }
      
      public function get TBTimeTwentyFour() : int
      {
         return this.FTBTimeTwentyFour;
      }
      
      public function set TBTimeTwentyFour(param1:int) : void
      {
         this.FTBTimeTwentyFour = param1;
      }
      
      public function get TBCurPirce() : int
      {
         return this.FTBCurPirce;
      }
      
      public function set TBCurPirce(param1:int) : void
      {
         this.FTBCurPirce = param1;
      }
      
      public function get TBCurAward() : TActivityTBAward
      {
         return this.FTBCurAward;
      }
      
      public function set TBCurAward(param1:TActivityTBAward) : void
      {
         this.FTBCurAward = param1;
      }
      
      public function get TBFavorablePeople() : int
      {
         return this.FTBFavorablePeople;
      }
      
      public function set TBFavorablePeople(param1:int) : void
      {
         this.FTBFavorablePeople = param1;
      }
      
      public function get TBCurLevel() : uint
      {
         return this.FTBCurLevel;
      }
      
      public function set TBCurLevel(param1:uint) : void
      {
         this.FTBCurLevel = param1;
      }
      
      public function set TBOffRatesWithSort(param1:Vector.<TActivityTBOffRate>) : void
      {
         this.FTBOffRatesWithSort = param1;
         this.ProcessorSortTBOffRates();
      }
      
      public function ProcessorGetAwardIDs() : Vector.<uint>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc2_ = int(this.FTBAwards.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FTBAwards[_loc1_].Award;
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function ProcessorGetAwardByIndex(param1:int) : TActivityTBAward
      {
         if(this.FTBAwards == null)
         {
            return null;
         }
         return this.FTBAwards[param1];
      }
      
      public function ProcessorGetOffRateByCondition(param1:uint) : TActivityTBOffRate
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FTBOffRates.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 >= this.FTBOffRates[_loc2_].Condition)
            {
               return this.FTBOffRates[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function SetBoxStatusByUIndex(param1:uint, param2:int) : void
      {
         if(this.FTBSignBox.Index == param1)
         {
            this.FTBSignBox.BoxStatus = param2;
            return;
         }
         if(this.FTBBuyBox.Index == param1)
         {
            this.FTBBuyBox.BoxStatus = param2;
            return;
         }
      }
   }
}

