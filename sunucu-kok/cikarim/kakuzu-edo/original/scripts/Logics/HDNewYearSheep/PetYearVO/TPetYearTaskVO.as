package Logics.HDNewYearSheep.PetYearVO
{
   import Logics.Inventories.TInventories;
   
   public class TPetYearTaskVO
   {
      
      protected var FInventories:TInventories;
      
      protected var FProgress:int;
      
      public function TPetYearTaskVO()
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
      
      public function get Progress() : int
      {
         return this.FProgress;
      }
      
      public function set Progress(param1:int) : void
      {
         this.FProgress = param1;
      }
   }
}

