package Logics.Inventories
{
   public class TInventoryReference
   {
      
      protected var FInventory:TInventory;
      
      public function TInventoryReference()
      {
         super();
      }
      
      public function get Inventory() : TInventory
      {
         return this.FInventory;
      }
      
      public function set Inventory(param1:TInventory) : void
      {
         if(this.FInventory != null)
         {
            this.FInventory.StubReferences.Dereference(this);
         }
         if(param1 != null)
         {
            param1.StubReferences.Reference(this);
         }
         this.FInventory = param1;
      }
   }
}

