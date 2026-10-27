package Logics.HDNationalDay2017
{
   import Logics.DatebaseVO.VO.THDNationalDayTwo2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNationalDay2017Two extends TActivityOSBase
   {
      
      protected var FSingleBags:Vector.<TInventories>;
      
      protected var FSignleBagsStatus:Vector.<int>;
      
      protected var FChargeBags:Vector.<TInventories>;
      
      protected var FChargeBagsStatus:Vector.<int>;
      
      protected var FBigAwardStatus:int;
      
      protected var FTotalCharge:uint;
      
      protected var FTodayCharge:uint;
      
      protected var FConfig:THDNationalDayTwo2017;
      
      public function TNationalDay2017Two()
      {
         super();
         this.FSingleBags = new Vector.<TInventories>();
         this.FSignleBagsStatus = new Vector.<int>();
         this.FChargeBags = new Vector.<TInventories>();
         this.FChargeBagsStatus = new Vector.<int>();
      }
      
      public function get SingleBags() : Vector.<TInventories>
      {
         return this.FSingleBags;
      }
      
      public function set SingleBags(param1:Vector.<TInventories>) : void
      {
         this.FSingleBags = param1;
      }
      
      public function get SignleBagsStatus() : Vector.<int>
      {
         return this.FSignleBagsStatus;
      }
      
      public function set SignleBagsStatus(param1:Vector.<int>) : void
      {
         this.FSignleBagsStatus = param1;
      }
      
      public function get ChargeBags() : Vector.<TInventories>
      {
         return this.FChargeBags;
      }
      
      public function set ChargeBags(param1:Vector.<TInventories>) : void
      {
         this.FChargeBags = param1;
      }
      
      public function get ChargeBagsStatus() : Vector.<int>
      {
         return this.FChargeBagsStatus;
      }
      
      public function set ChargeBagsStatus(param1:Vector.<int>) : void
      {
         this.FChargeBagsStatus = param1;
      }
      
      public function get BigAwardStatus() : int
      {
         return this.FBigAwardStatus;
      }
      
      public function set BigAwardStatus(param1:int) : void
      {
         this.FBigAwardStatus = param1;
      }
      
      public function get Config() : THDNationalDayTwo2017
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNationalDayTwo2017) : void
      {
         this.FConfig = param1;
      }
      
      public function get TotalCharge() : uint
      {
         return this.FTotalCharge;
      }
      
      public function set TotalCharge(param1:uint) : void
      {
         this.FTotalCharge = param1;
      }
      
      public function get TodayCharge() : uint
      {
         return this.FTodayCharge;
      }
      
      public function set TodayCharge(param1:uint) : void
      {
         this.FTodayCharge = param1;
      }
   }
}

