package Logics.HDKnifeChess
{
   import Logics.DatebaseVO.VO.THDKnifeChessBuy;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TKnifeChessBuy extends TActivityOSBase
   {
      
      protected var FConfig:THDKnifeChessBuy;
      
      protected var FCurStep:int;
      
      protected var FFreeSteps:int;
      
      protected var FCurZone:int;
      
      protected var FBags:Vector.<TInventories>;
      
      protected var FShop:TInventories;
      
      protected var FShopStatus:Vector.<int>;
      
      protected var FScore:uint;
      
      public function TKnifeChessBuy()
      {
         super();
         this.FBags = new Vector.<TInventories>();
         this.FShop = new TInventories();
      }
      
      public function get Config() : THDKnifeChessBuy
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDKnifeChessBuy) : void
      {
         this.FConfig = param1;
      }
      
      public function get CurStep() : int
      {
         return this.FCurStep;
      }
      
      public function set CurStep(param1:int) : void
      {
         this.FCurStep = param1;
      }
      
      public function get FreeSteps() : int
      {
         return this.FFreeSteps;
      }
      
      public function set FreeSteps(param1:int) : void
      {
         this.FFreeSteps = param1;
      }
      
      public function get CurZone() : int
      {
         return this.FCurZone;
      }
      
      public function set CurZone(param1:int) : void
      {
         this.FCurZone = param1;
      }
      
      public function get Bags() : Vector.<TInventories>
      {
         return this.FBags;
      }
      
      public function set Bags(param1:Vector.<TInventories>) : void
      {
         this.FBags = param1;
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
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
   }
}

