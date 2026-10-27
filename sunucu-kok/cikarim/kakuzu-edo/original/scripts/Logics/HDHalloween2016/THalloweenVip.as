package Logics.HDHalloween2016
{
   import Logics.DatebaseVO.VO.THDHalloweenVip;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class THalloweenVip extends TActivityOSBase
   {
      
      protected var FRecharge:uint;
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FPeriod:uint;
      
      protected var FGifts:Vector.<TInventories>;
      
      protected var FConfig:THDHalloweenVip;
      
      public function THalloweenVip()
      {
         super();
         this.FBagStatus = new Vector.<int>(9);
         this.FGifts = new Vector.<TInventories>();
      }
      
      public function get Recharge() : uint
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:uint) : void
      {
         this.FRecharge = param1;
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get Period() : uint
      {
         return this.FPeriod;
      }
      
      public function set Period(param1:uint) : void
      {
         this.FPeriod = param1;
      }
      
      public function get Config() : THDHalloweenVip
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDHalloweenVip) : void
      {
         this.FConfig = param1;
      }
      
      public function get Gifts() : Vector.<TInventories>
      {
         return this.FGifts;
      }
      
      public function set Gifts(param1:Vector.<TInventories>) : void
      {
         this.FGifts = param1;
      }
   }
}

