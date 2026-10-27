package Logics.DailySign
{
   import Logics.DatebaseVO.VO.TSignReward;
   import Logics.Inventories.TInventorySamples;
   
   public class TDailySign
   {
      
      protected var FCurrentMonth:uint;
      
      protected var FDayList:Vector.<String>;
      
      protected var FRewardID:uint;
      
      protected var FSignTotalDays:uint;
      
      protected var FServerStartDate:uint;
      
      protected var FSignReward:TSignReward;
      
      protected var FExchangeReward:TInventorySamples;
      
      protected var FOverTime:uint;
      
      protected var FMonthRewardState:int;
      
      protected var FFirstRewardState:int;
      
      public function TDailySign()
      {
         super();
         this.FDayList = new Vector.<String>();
         this.FExchangeReward = new TInventorySamples();
      }
      
      public function get CurrentMonth() : uint
      {
         return this.FCurrentMonth;
      }
      
      public function set CurrentMonth(param1:uint) : void
      {
         this.FCurrentMonth = param1;
      }
      
      public function get DayList() : Vector.<String>
      {
         return this.FDayList;
      }
      
      public function set DayList(param1:Vector.<String>) : void
      {
         this.FDayList = param1;
      }
      
      public function get SignTotalDays() : int
      {
         return this.FSignTotalDays;
      }
      
      public function set SignTotalDays(param1:int) : void
      {
         this.FSignTotalDays = param1;
      }
      
      public function get ServerStartDate() : uint
      {
         return this.FServerStartDate;
      }
      
      public function set ServerStartDate(param1:uint) : void
      {
         this.FServerStartDate = param1;
      }
      
      public function get ExchangeReward() : TInventorySamples
      {
         return this.FExchangeReward;
      }
      
      public function get SignReward() : TSignReward
      {
         return this.FSignReward;
      }
      
      public function set SignReward(param1:TSignReward) : void
      {
         this.FSignReward = param1;
      }
      
      public function get RewardID() : uint
      {
         return this.FRewardID;
      }
      
      public function set RewardID(param1:uint) : void
      {
         this.FRewardID = param1;
      }
      
      public function get OverTime() : uint
      {
         return this.FOverTime;
      }
      
      public function set OverTime(param1:uint) : void
      {
         this.FOverTime = param1;
      }
      
      public function get MonthRewardState() : int
      {
         return this.FMonthRewardState;
      }
      
      public function set MonthRewardState(param1:int) : void
      {
         this.FMonthRewardState = param1;
      }
      
      public function get FirstRewardState() : int
      {
         return this.FFirstRewardState;
      }
      
      public function set FirstRewardState(param1:int) : void
      {
         this.FFirstRewardState = param1;
      }
   }
}

