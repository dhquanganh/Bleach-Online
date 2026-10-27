package Logics.Streamization.HDActivityNewHalloween.RechargeVo
{
   import Logics.Inventories.TInventories;
   
   public class TRechargeGiftVo
   {
      
      private var FInventories:TInventories;
      
      private var FCondition:int;
      
      private var FIndex:int;
      
      private var FState:int;
      
      public function TRechargeGiftVo()
      {
         super();
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get Condition() : int
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:int) : void
      {
         this.FCondition = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
   }
}

