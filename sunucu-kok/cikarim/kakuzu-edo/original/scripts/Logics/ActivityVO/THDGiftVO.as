package Logics.ActivityVO
{
   import Logics.Inventories.TInventories;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class THDGiftVO
   {
      
      protected var FInventories:TInventories;
      
      protected var FState:int;
      
      protected var FCondition:Vector.<int>;
      
      protected var FCS_Index:int;
      
      protected var FCS_Bit:int;
      
      public function THDGiftVO()
      {
         super();
         this.FState = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         this.FCondition = new Vector.<int>();
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get Condition() : Vector.<int>
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:Vector.<int>) : void
      {
         this.FCondition = param1;
      }
      
      public function get CS_Index() : int
      {
         return this.FCS_Index;
      }
      
      public function set CS_Index(param1:int) : void
      {
         this.FCS_Index = param1;
      }
      
      public function get CS_Bit() : int
      {
         return this.FCS_Bit;
      }
      
      public function set CS_Bit(param1:int) : void
      {
         this.FCS_Bit = param1;
      }
   }
}

