package Logics.HonorShop
{
   public class THonorShopData
   {
      
      public static const TYPE_ITEM_Inventory:uint = 0;
      
      public static const TYPE_ITEM_Hero:uint = 1;
      
      protected var FTotalCount:uint;
      
      protected var FBoughtCount:uint;
      
      protected var FHonorCount:uint;
      
      protected var FNextHonor:int;
      
      protected var FInventoryItems:Vector.<THonorShopItem>;
      
      protected var FHeroItems:Vector.<THonorShopItem>;
      
      public function THonorShopData()
      {
         super();
         this.FTotalCount = 0;
         this.FBoughtCount = 0;
         this.FHonorCount = 0;
         this.FNextHonor = 0;
         this.FInventoryItems = new Vector.<THonorShopItem>();
         this.FHeroItems = new Vector.<THonorShopItem>();
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
      
      public function get HonorCount() : uint
      {
         return this.FHonorCount;
      }
      
      public function set HonorCount(param1:uint) : void
      {
         this.FHonorCount = param1;
      }
      
      public function get InventoryItems() : Vector.<THonorShopItem>
      {
         return this.FInventoryItems;
      }
      
      public function set InventoryItems(param1:Vector.<THonorShopItem>) : void
      {
         this.FInventoryItems = param1;
      }
      
      public function get HeroItems() : Vector.<THonorShopItem>
      {
         return this.FHeroItems;
      }
      
      public function set HeroItems(param1:Vector.<THonorShopItem>) : void
      {
         this.FHeroItems = param1;
      }
      
      public function set TotalCountObj(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         _loc4_ = param1 as Vector.<Object>;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_[_loc2_] as Array;
            if(this.FHonorCount <= _loc5_[0])
            {
               this.FTotalCount = _loc5_[1];
               if(_loc2_ == _loc4_.length - 1)
               {
                  this.NextHonor = -1;
               }
               else
               {
                  _loc6_ = _loc4_[_loc2_ + 1] as Array;
                  this.NextHonor = _loc6_[0] + 1;
               }
               break;
            }
            if(_loc2_ == _loc4_.length + 1 && this.FHonorCount > _loc5_[0])
            {
               this.FTotalCount = _loc5_[1];
               this.NextHonor = -1;
            }
            _loc2_++;
         }
      }
      
      public function get NextHonor() : int
      {
         return this.FNextHonor;
      }
      
      public function set NextHonor(param1:int) : void
      {
         this.FNextHonor = param1;
      }
      
      public function ProcessorSetMallCount(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FInventoryItems.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FInventoryItems[_loc3_].Mall.Identifier)
            {
               this.FInventoryItems[_loc3_].BoughtCount = param2;
               break;
            }
            _loc3_++;
         }
         _loc4_ = int(this.FHeroItems.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FHeroItems[_loc3_].Mall.Identifier)
            {
               this.FHeroItems[_loc3_].BoughtCount = param2;
               break;
            }
            _loc3_++;
         }
      }
   }
}

