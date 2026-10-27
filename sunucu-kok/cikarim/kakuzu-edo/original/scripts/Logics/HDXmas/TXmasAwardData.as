package Logics.HDXmas
{
   public class TXmasAwardData
   {
      
      protected var FState:int;
      
      protected var FInventoryId:uint;
      
      public function TXmasAwardData()
      {
         super();
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get InventoryId() : uint
      {
         return this.FInventoryId;
      }
      
      public function set InventoryId(param1:uint) : void
      {
         this.FInventoryId = param1;
      }
   }
}

