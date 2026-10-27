package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChristmasCarnivalConfig extends THDActivityBase
   {
      
      protected var FItemRefreshIndexs:Array;
      
      protected var FItemBuyIndexs:Array;
      
      protected var FAllItems:Array;
      
      protected var FSuperItems:Array;
      
      protected var FRefreshConsume:Array;
      
      protected var FRefreshIntervalTime:Number;
      
      protected var FRefreshItemGold:uint;
      
      protected var FRefreshIndex:uint;
      
      protected var FRefreshHeroIndex:uint;
      
      protected var FHero:Object;
      
      protected var FLanguage:Array;
      
      protected var FDiscountCostIndex:uint;
      
      public function THDChristmasCarnivalConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FItemRefreshIndexs = Json.decode(TUtilityString.FetchUTF(param1));
         this.FItemBuyIndexs = Json.decode(TUtilityString.FetchUTF(param1));
         this.FAllItems = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSuperItems = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRefreshConsume = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRefreshIntervalTime = param1.readInt();
         this.FRefreshItemGold = param1.readInt();
         this.FRefreshIndex = param1.readInt();
         this.FRefreshHeroIndex = param1.readInt();
         this.FHero = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
         this.FDiscountCostIndex = param1.readInt();
      }
      
      public function get ItemRefreshIndexs() : Array
      {
         return this.FItemRefreshIndexs;
      }
      
      public function get ItemBuyIndexs() : Array
      {
         return this.FItemBuyIndexs;
      }
      
      public function get AllItems() : Array
      {
         return this.FAllItems;
      }
      
      public function get SuperItems() : Array
      {
         return this.FSuperItems;
      }
      
      public function get RefreshConsume() : Array
      {
         return this.FRefreshConsume;
      }
      
      public function get RefreshIntervalTime() : Number
      {
         return this.FRefreshIntervalTime;
      }
      
      public function get RefreshItemGold() : uint
      {
         return this.FRefreshItemGold;
      }
      
      public function get RefreshIndex() : uint
      {
         return this.FRefreshIndex;
      }
      
      public function get RefreshHeroIndex() : uint
      {
         return this.FRefreshHeroIndex;
      }
      
      public function get Hero() : Object
      {
         return this.FHero;
      }
      
      public function get Language() : Array
      {
         return this.FLanguage;
      }
      
      public function get DiscountCostIndex() : uint
      {
         return this.FDiscountCostIndex;
      }
   }
}

