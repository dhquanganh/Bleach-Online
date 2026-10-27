package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNationalDayTwo extends THDActivityBase
   {
      
      protected var FFreeIndex:int;
      
      protected var FDiscount:int;
      
      protected var FScoreIndex:int;
      
      protected var FDiscountIndex:int;
      
      protected var FRefreshIndex:int;
      
      protected var FRefreshCost:int;
      
      protected var FItems:Vector.<Object>;
      
      protected var FMall:Vector.<Object>;
      
      protected var FBag:Object;
      
      protected var FCurPoolIndex:Vector.<int>;
      
      public function THDNationalDayTwo()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFreeIndex = param1.readInt();
         this.FDiscount = param1.readInt();
         this.FScoreIndex = param1.readInt();
         this.FDiscountIndex = param1.readInt();
         this.FRefreshIndex = param1.readInt();
         this.FRefreshCost = param1.readInt();
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCurPoolIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get FreeIndex() : int
      {
         return this.FFreeIndex;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get DiscountIndex() : int
      {
         return this.FDiscountIndex;
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
      
      public function get RefreshCost() : int
      {
         return this.FRefreshCost;
      }
      
      public function get CurPoolIndex() : Vector.<int>
      {
         return this.FCurPoolIndex;
      }
   }
}

