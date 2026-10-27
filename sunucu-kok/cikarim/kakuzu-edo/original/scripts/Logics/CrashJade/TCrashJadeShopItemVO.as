package Logics.CrashJade
{
   import Logics.DatebaseVO.VO.TMall;
   import Logics.Inventories.TInventory;
   
   public class TCrashJadeShopItemVO
   {
      
      protected var FInventory:TInventory;
      
      protected var FMall:TMall;
      
      protected var FBuyCont:uint;
      
      public function TCrashJadeShopItemVO()
      {
         super();
         this.FBuyCont = 0;
      }
      
      public function get Inventory() : TInventory
      {
         return this.FInventory;
      }
      
      public function set Inventory(param1:TInventory) : void
      {
         this.FInventory = param1;
      }
      
      public function get Mall() : TMall
      {
         return this.FMall;
      }
      
      public function set Mall(param1:TMall) : void
      {
         this.FMall = param1;
      }
      
      public function get BuyCont() : uint
      {
         return this.FBuyCont;
      }
      
      public function set BuyCont(param1:uint) : void
      {
         this.FBuyCont = param1;
      }
   }
}

