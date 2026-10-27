package Logics.HDAstrology.vo
{
   import Logics.Inventories.TInventories;
   
   public class TSoulExchangeVo
   {
      
      private var FInventories:TInventories;
      
      private var FConditionValue:int;
      
      private var FLimitValue:int;
      
      private var FIndex:int;
      
      private var FStatus:int;
      
      public function TSoulExchangeVo()
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
      
      public function get ConditionValue() : int
      {
         return this.FConditionValue;
      }
      
      public function set ConditionValue(param1:int) : void
      {
         this.FConditionValue = param1;
      }
      
      public function get LimitValue() : int
      {
         return this.FLimitValue;
      }
      
      public function set LimitValue(param1:int) : void
      {
         this.FLimitValue = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

