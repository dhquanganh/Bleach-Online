package Logics.HDBleachBag
{
   import Logics.Inventories.TInventories;
   
   public class TCostGiftVo
   {
      
      private var FIndex:int;
      
      private var FCondition:int;
      
      private var FLimit:int;
      
      private var FState:int;
      
      private var FInventories:TInventories;
      
      public function TCostGiftVo()
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
      
      public function get Limit() : int
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:int) : void
      {
         this.FLimit = param1;
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

