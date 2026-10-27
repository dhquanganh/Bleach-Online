package Logics.HDThanksGivingDay2016
{
   import Logics.DatebaseVO.VO.THDTGD_3;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TTGD_3 extends TActivityOSBase
   {
      
      protected var FBag_0:TInventories;
      
      protected var FStatusBag_0:int;
      
      protected var FBag_1:TInventories;
      
      protected var FStatusBag_1:int;
      
      protected var FRecharge:int;
      
      protected var FMyRecharge:int;
      
      protected var FConfig:THDTGD_3;
      
      public function TTGD_3()
      {
         super();
         this.FBag_0 = new TInventories();
         this.FBag_1 = new TInventories();
      }
      
      public function get Bag_0() : TInventories
      {
         return this.FBag_0;
      }
      
      public function set Bag_0(param1:TInventories) : void
      {
         this.FBag_0 = param1;
      }
      
      public function get StatusBag_0() : int
      {
         return this.FStatusBag_0;
      }
      
      public function set StatusBag_0(param1:int) : void
      {
         this.FStatusBag_0 = param1;
      }
      
      public function get Bag_1() : TInventories
      {
         return this.FBag_1;
      }
      
      public function set Bag_1(param1:TInventories) : void
      {
         this.FBag_1 = param1;
      }
      
      public function get StatusBag_1() : int
      {
         return this.FStatusBag_1;
      }
      
      public function set StatusBag_1(param1:int) : void
      {
         this.FStatusBag_1 = param1;
      }
      
      public function get Recharge() : int
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:int) : void
      {
         this.FRecharge = param1;
      }
      
      public function get Config() : THDTGD_3
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDTGD_3) : void
      {
         this.FConfig = param1;
      }
      
      public function get MyRecharge() : int
      {
         return this.FMyRecharge;
      }
      
      public function set MyRecharge(param1:int) : void
      {
         this.FMyRecharge = param1;
      }
   }
}

