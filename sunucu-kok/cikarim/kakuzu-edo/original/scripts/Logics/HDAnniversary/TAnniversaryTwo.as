package Logics.HDAnniversary
{
   import Logics.DatebaseVO.VO.THDAnniversaryTwo;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TAnniversaryTwo extends TActivityOSBase
   {
      
      protected var FRecharge:uint;
      
      protected var FDayAward:Vector.<TInventories>;
      
      protected var FTotalAward:Vector.<TInventories>;
      
      protected var FDayAwardStatus:Vector.<int>;
      
      protected var FTotalAwardStatus:Vector.<int>;
      
      protected var FConfig:THDAnniversaryTwo;
      
      protected var FJackPointStatus:int;
      
      public function TAnniversaryTwo()
      {
         super();
         this.FDayAward = new Vector.<TInventories>();
         this.FTotalAward = new Vector.<TInventories>();
         this.FDayAwardStatus = new Vector.<int>();
         this.FTotalAwardStatus = new Vector.<int>();
      }
      
      public function get Recharge() : uint
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:uint) : void
      {
         this.FRecharge = param1;
      }
      
      public function get DayAward() : Vector.<TInventories>
      {
         return this.FDayAward;
      }
      
      public function set DayAward(param1:Vector.<TInventories>) : void
      {
         this.FDayAward = param1;
      }
      
      public function get TotalAward() : Vector.<TInventories>
      {
         return this.FTotalAward;
      }
      
      public function set TotalAward(param1:Vector.<TInventories>) : void
      {
         this.FTotalAward = param1;
      }
      
      public function get Config() : THDAnniversaryTwo
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDAnniversaryTwo) : void
      {
         this.FConfig = param1;
      }
      
      public function get DayAwardStatus() : Vector.<int>
      {
         return this.FDayAwardStatus;
      }
      
      public function set DayAwardStatus(param1:Vector.<int>) : void
      {
         this.FDayAwardStatus = param1;
      }
      
      public function get TotalAwardStatus() : Vector.<int>
      {
         return this.FTotalAwardStatus;
      }
      
      public function set TotalAwardStatus(param1:Vector.<int>) : void
      {
         this.FTotalAwardStatus = param1;
      }
      
      public function get JackPointStatus() : int
      {
         return this.FJackPointStatus;
      }
      
      public function set JackPointStatus(param1:int) : void
      {
         this.FJackPointStatus = param1;
      }
   }
}

