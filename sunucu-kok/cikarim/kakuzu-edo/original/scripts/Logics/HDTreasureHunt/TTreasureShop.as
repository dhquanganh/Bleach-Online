package Logics.HDTreasureHunt
{
   import Logics.DatebaseVO.VO.THDTreasureHuntShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TTreasureShop extends TActivityOSBase
   {
      
      protected var FDarkItemCount:uint;
      
      protected var FLightItemCount:uint;
      
      protected var FDarkShowItems:TInventories;
      
      protected var FLightShowItems:TInventories;
      
      protected var FDarkShop:TInventories;
      
      protected var FLightShop:TInventories;
      
      protected var FDarkShopStatus:Vector.<int>;
      
      protected var FLightShopStatus:Vector.<int>;
      
      protected var FBigAwardStatus:int;
      
      protected var FConfig:THDTreasureHuntShop;
      
      public function TTreasureShop()
      {
         super();
         this.FDarkShowItems = new TInventories();
         this.FDarkShopStatus = new Vector.<int>();
         this.FLightShopStatus = new Vector.<int>();
      }
      
      public function get DarkItemCount() : uint
      {
         return this.FDarkItemCount;
      }
      
      public function set DarkItemCount(param1:uint) : void
      {
         this.FDarkItemCount = param1;
      }
      
      public function get LightItemCount() : uint
      {
         return this.FLightItemCount;
      }
      
      public function set LightItemCount(param1:uint) : void
      {
         this.FLightItemCount = param1;
      }
      
      public function get DarkShowItems() : TInventories
      {
         return this.FDarkShowItems;
      }
      
      public function set DarkShowItems(param1:TInventories) : void
      {
         this.FDarkShowItems = param1;
      }
      
      public function get LightShowItems() : TInventories
      {
         return this.FLightShowItems;
      }
      
      public function set LightShowItems(param1:TInventories) : void
      {
         this.FLightShowItems = param1;
      }
      
      public function get DarkShop() : TInventories
      {
         return this.FDarkShop;
      }
      
      public function set DarkShop(param1:TInventories) : void
      {
         this.FDarkShop = param1;
      }
      
      public function get LightShop() : TInventories
      {
         return this.FLightShop;
      }
      
      public function set LightShop(param1:TInventories) : void
      {
         this.FLightShop = param1;
      }
      
      public function get DarkShopStatus() : Vector.<int>
      {
         return this.FDarkShopStatus;
      }
      
      public function set DarkShopStatus(param1:Vector.<int>) : void
      {
         this.FDarkShopStatus = param1;
      }
      
      public function get LightShopStatus() : Vector.<int>
      {
         return this.FLightShopStatus;
      }
      
      public function set LightShopStatus(param1:Vector.<int>) : void
      {
         this.FLightShopStatus = param1;
      }
      
      public function get BigAwardStatus() : int
      {
         return this.FBigAwardStatus;
      }
      
      public function set BigAwardStatus(param1:int) : void
      {
         this.FBigAwardStatus = param1;
      }
      
      public function get Config() : THDTreasureHuntShop
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDTreasureHuntShop) : void
      {
         this.FConfig = param1;
      }
   }
}

