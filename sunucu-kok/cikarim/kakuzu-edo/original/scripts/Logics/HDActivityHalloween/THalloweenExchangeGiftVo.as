package Logics.HDActivityHalloween
{
   import Logics.Inventories.TInventories;
   
   public class THalloweenExchangeGiftVo
   {
      
      protected var FExchangeValue:int;
      
      protected var FCurGiftIndex:int;
      
      protected var FAwardId:int;
      
      protected var FInventories:TInventories;
      
      protected var FIsScanGetAward:Boolean;
      
      public function THalloweenExchangeGiftVo()
      {
         super();
      }
      
      public function get ExchangeValue() : int
      {
         return this.FExchangeValue;
      }
      
      public function set ExchangeValue(param1:int) : void
      {
         this.FExchangeValue = param1;
      }
      
      public function get CurGiftIndex() : int
      {
         return this.FCurGiftIndex;
      }
      
      public function set CurGiftIndex(param1:int) : void
      {
         this.FCurGiftIndex = param1;
      }
      
      public function get AwardId() : int
      {
         return this.FAwardId;
      }
      
      public function set AwardId(param1:int) : void
      {
         this.FAwardId = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get IsScanGetAward() : Boolean
      {
         return this.FIsScanGetAward;
      }
      
      public function set IsScanGetAward(param1:Boolean) : void
      {
         this.FIsScanGetAward = param1;
      }
   }
}

