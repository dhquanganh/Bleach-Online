package Logics.HDNationalDay
{
   import Logics.DatebaseVO.VO.THDNationalDayOne;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNationalDayOne extends TActivityOSBase
   {
      
      protected var FRecharge:int;
      
      protected var FProgressGifts:Vector.<TInventories>;
      
      protected var FProgressGiftStatus:Vector.<int>;
      
      protected var FDayGifts:Vector.<TInventories>;
      
      protected var FDayGiftStatus:Vector.<int>;
      
      protected var FConfig:THDNationalDayOne;
      
      public function TNationalDayOne()
      {
         super();
         this.FProgressGifts = new Vector.<TInventories>(2);
         this.FProgressGiftStatus = new Vector.<int>(2);
         this.FDayGifts = new Vector.<TInventories>(5);
         this.FDayGiftStatus = new Vector.<int>(5);
      }
      
      public function get Recharge() : int
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:int) : void
      {
         this.FRecharge = param1;
      }
      
      public function get ProgressGifts() : Vector.<TInventories>
      {
         return this.FProgressGifts;
      }
      
      public function set ProgressGifts(param1:Vector.<TInventories>) : void
      {
         this.FProgressGifts = param1;
      }
      
      public function get ProgressGiftStatus() : Vector.<int>
      {
         return this.FProgressGiftStatus;
      }
      
      public function set ProgressGiftStatus(param1:Vector.<int>) : void
      {
         this.FProgressGiftStatus = param1;
      }
      
      public function get DayGifts() : Vector.<TInventories>
      {
         return this.FDayGifts;
      }
      
      public function set DayGifts(param1:Vector.<TInventories>) : void
      {
         this.FDayGifts = param1;
      }
      
      public function get DayGiftStatus() : Vector.<int>
      {
         return this.FDayGiftStatus;
      }
      
      public function set DayGiftStatus(param1:Vector.<int>) : void
      {
         this.FDayGiftStatus = param1;
      }
      
      public function get Config() : THDNationalDayOne
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNationalDayOne) : void
      {
         this.FConfig = param1;
      }
   }
}

