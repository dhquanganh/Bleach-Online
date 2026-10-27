package Logics.HDNewYearSheep.PetYearVO
{
   import Logics.Inventories.TInventories;
   
   public class TPetYearChipGiftBoxVO
   {
      
      protected var FInventories:TInventories;
      
      protected var FCost:int;
      
      public function TPetYearChipGiftBoxVO()
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
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function set Cost(param1:int) : void
      {
         this.FCost = param1;
      }
   }
}

