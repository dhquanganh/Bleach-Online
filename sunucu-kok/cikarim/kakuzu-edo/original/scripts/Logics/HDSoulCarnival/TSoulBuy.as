package Logics.HDSoulCarnival
{
   import Logics.DatebaseVO.VO.THDSoulBuy;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TSoulBuy extends TActivityOSBase
   {
      
      protected var FShop:TInventories;
      
      protected var FShopStatus:Vector.<int>;
      
      protected var FBigAwardStatus:int;
      
      protected var FScore:uint;
      
      protected var FBags:Vector.<TInventories>;
      
      protected var FConfig:THDSoulBuy;
      
      public function TSoulBuy()
      {
         super();
         this.FBags = new Vector.<TInventories>();
      }
      
      public function get Shop() : TInventories
      {
         return this.FShop;
      }
      
      public function set Shop(param1:TInventories) : void
      {
         this.FShop = param1;
      }
      
      public function get ShopStatus() : Vector.<int>
      {
         return this.FShopStatus;
      }
      
      public function set ShopStatus(param1:Vector.<int>) : void
      {
         this.FShopStatus = param1;
      }
      
      public function get BigAwardStatus() : int
      {
         return this.FBigAwardStatus;
      }
      
      public function set BigAwardStatus(param1:int) : void
      {
         this.FBigAwardStatus = param1;
      }
      
      public function get Config() : THDSoulBuy
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDSoulBuy) : void
      {
         this.FConfig = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Bags() : Vector.<TInventories>
      {
         return this.FBags;
      }
      
      public function set Bags(param1:Vector.<TInventories>) : void
      {
         this.FBags = param1;
      }
   }
}

