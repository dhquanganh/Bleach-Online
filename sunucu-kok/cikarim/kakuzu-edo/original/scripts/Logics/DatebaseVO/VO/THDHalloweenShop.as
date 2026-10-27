package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenShop extends THDActivityBase
   {
      
      protected var FRefreshIndex:int;
      
      protected var FTotalScoreIndex:int;
      
      protected var FBuyIndex:int;
      
      protected var FBuyCostGold:int;
      
      protected var FRefreshCostGold:int;
      
      protected var FAllBuyIndex:int;
      
      protected var FItems:Vector.<Object>;
      
      protected var FMall:Vector.<Object>;
      
      protected var FBag:Object;
      
      protected var FCurItemsIndex:Vector.<int>;
      
      protected var FMaskName:String;
      
      public function THDHalloweenShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRefreshIndex = param1.readUnsignedInt();
         this.FTotalScoreIndex = param1.readUnsignedInt();
         this.FBuyIndex = param1.readUnsignedInt();
         this.FBuyCostGold = param1.readUnsignedInt();
         this.FRefreshCostGold = param1.readUnsignedInt();
         this.FAllBuyIndex = param1.readUnsignedInt();
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCurItemsIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMaskName = TUtilityString.FetchUTF(param1);
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
      }
      
      public function get TotalScoreIndex() : int
      {
         return this.FTotalScoreIndex;
      }
      
      public function get BuyIndex() : int
      {
         return this.FBuyIndex;
      }
      
      public function get BuyCostGold() : int
      {
         return this.FBuyCostGold;
      }
      
      public function get RefreshCostGold() : int
      {
         return this.FRefreshCostGold;
      }
      
      public function get AllBuyIndex() : int
      {
         return this.FAllBuyIndex;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
      
      public function get CurItemsIndex() : Vector.<int>
      {
         return this.FCurItemsIndex;
      }
      
      public function get MaskName() : String
      {
         return this.FMaskName;
      }
   }
}

