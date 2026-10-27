package Logics.HDBleachBag
{
   import Logics.Inventories.TInventories;
   
   public class TRechargeGiftVo
   {
      
      private var FIndex:int;
      
      private var FCondition:int;
      
      private var FInventories:TInventories;
      
      private var FGiftState:int;
      
      public function TRechargeGiftVo()
      {
         super();
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Condition() : int
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:int) : void
      {
         this.FCondition = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get GiftState() : int
      {
         return this.FGiftState;
      }
      
      public function set GiftState(param1:int) : void
      {
         this.FGiftState = param1;
      }
   }
}

