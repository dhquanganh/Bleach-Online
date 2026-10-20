package Logics.Inventories
{
   public class TAppliance extends TInventory
   {
      
      protected var FUsable:Boolean;
      
      protected var FStackable:Boolean;
      
      protected var FStackableQuantityMax:uint;
      
      protected var FDynamicValue:uint;
      
      public function TAppliance(param1:uint)
      {
         super(param1);
      }
      
      public function get Usable() : Boolean
      {
         return this.FUsable;
      }
      
      public function set Usable(param1:Boolean) : void
      {
         this.FUsable = param1;
      }
      
      public function get Stackable() : Boolean
      {
         return this.FStackable;
      }
      
      public function set Stackable(param1:Boolean) : void
      {
         this.FStackable = param1;
      }
      
      public function get StackableQuantityMax() : uint
      {
         return this.FStackableQuantityMax;
      }
      
      public function set StackableQuantityMax(param1:uint) : void
      {
         this.FStackableQuantityMax = param1;
      }
      
      public function get DynamicValue() : uint
      {
         return this.FDynamicValue;
      }
      
      public function set DynamicValue(param1:uint) : void
      {
         this.FDynamicValue = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FUsable = false;
         this.FStackable = false;
         this.FStackableQuantityMax = 0;
      }
   }
}

