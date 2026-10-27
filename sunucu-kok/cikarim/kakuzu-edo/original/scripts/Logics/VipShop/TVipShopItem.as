package Logics.VipShop
{
   import Logics.Inventories.TInventorySample;
   
   public class TVipShopItem
   {
      
      protected var FBoughtCount:uint;
      
      protected var FInventorySample:TInventorySample;
      
      public function TVipShopItem()
      {
         super();
         this.FInventorySample = new TInventorySample();
         this.FBoughtCount = 0;
      }
      
      public function get BoughtCount() : uint
      {
         return this.FBoughtCount;
      }
      
      public function set BoughtCount(param1:uint) : void
      {
         this.FBoughtCount = param1;
      }
      
      public function get InventorySample() : TInventorySample
      {
         return this.FInventorySample;
      }
      
      public function set InventorySample(param1:TInventorySample) : void
      {
         this.FInventorySample = param1;
      }
   }
}

