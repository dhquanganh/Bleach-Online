package Logics.VipShop
{
   public class TVipShopData
   {
      
      public static const TYPE_ITEM_Inventory:uint = 0;
      
      protected var FTotalCount:uint;
      
      protected var FBoughtCount:uint;
      
      protected var FInventoryItems:Vector.<TVipShopItem>;
      
      public function TVipShopData()
      {
         super();
         this.FTotalCount = 0;
         this.FBoughtCount = 0;
         this.FInventoryItems = new Vector.<TVipShopItem>(11);
      }
      
      public function get TotalCount() : uint
      {
         return this.FTotalCount;
      }
      
      public function get BoughtCount() : uint
      {
         return this.FBoughtCount;
      }
      
      public function set BoughtCount(param1:uint) : void
      {
         this.FBoughtCount = param1;
      }
      
      public function get CanBuyCount() : uint
      {
         return this.FTotalCount - this.FBoughtCount > 0 ? uint(this.FTotalCount - this.FBoughtCount) : 0;
      }
      
      public function get InventoryItems() : Vector.<TVipShopItem>
      {
         return this.FInventoryItems;
      }
      
      public function set InventoryItems(param1:Vector.<TVipShopItem>) : void
      {
         this.FInventoryItems = param1;
      }
      
      public function ProcessorSetMallCount(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FInventoryItems.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FInventoryItems[_loc3_].InventorySample.Indentifier)
            {
               this.FInventoryItems[_loc3_].BoughtCount = param2;
               break;
            }
            _loc3_++;
         }
      }
   }
}

