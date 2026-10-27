package Logics.HDThanksGivingDay2016
{
   import Logics.DatebaseVO.VO.THDTGD_1;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TTGD_1 extends TActivityOSBase
   {
      
      protected var FGiftStatus:Vector.<int>;
      
      protected var FGifts:Vector.<TInventories>;
      
      protected var FJackStatus:int;
      
      protected var FConfig:THDTGD_1;
      
      public function TTGD_1()
      {
         super();
         this.FGiftStatus = new Vector.<int>();
         this.FGifts = new Vector.<TInventories>();
      }
      
      public function get GiftStatus() : Vector.<int>
      {
         return this.FGiftStatus;
      }
      
      public function set GiftStatus(param1:Vector.<int>) : void
      {
         this.FGiftStatus = param1;
      }
      
      public function get Gifts() : Vector.<TInventories>
      {
         return this.FGifts;
      }
      
      public function set Gifts(param1:Vector.<TInventories>) : void
      {
         this.FGifts = param1;
      }
      
      public function get Config() : THDTGD_1
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDTGD_1) : void
      {
         this.FConfig = param1;
      }
      
      public function get JackStatus() : int
      {
         return this.FJackStatus;
      }
      
      public function set JackStatus(param1:int) : void
      {
         this.FJackStatus = param1;
      }
   }
}

