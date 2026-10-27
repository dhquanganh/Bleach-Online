package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDFoolsDayShop extends THDActivityBase
   {
      
      protected var FPlayOnceIndex:uint;
      
      protected var FPlayFiveIndex:uint;
      
      protected var FScoreIndex:uint;
      
      protected var FReItemIndex:uint;
      
      protected var FRePriceIndex:uint;
      
      protected var FCurPriceIndex:uint;
      
      protected var FReStart:uint;
      
      protected var FLuckIndex:uint;
      
      protected var FPlayCost:uint;
      
      protected var FReItemCost:uint;
      
      protected var FRePriceCost:uint;
      
      protected var FCurItems:Vector.<uint>;
      
      protected var FCurItemsIndex:Vector.<uint>;
      
      protected var FScoreShop:Vector.<Object>;
      
      public function THDFoolsDayShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FPlayOnceIndex = param1.readInt();
         this.FPlayFiveIndex = param1.readInt();
         this.FScoreIndex = param1.readInt();
         this.FReItemIndex = param1.readInt();
         this.FRePriceIndex = param1.readInt();
         this.FCurPriceIndex = param1.readInt();
         this.FReStart = param1.readInt();
         this.FLuckIndex = param1.readInt();
         this.FPlayCost = param1.readInt();
         this.FReItemCost = param1.readInt();
         this.FRePriceCost = param1.readInt();
         this.FCurItems = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCurItemsIndex = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get PlayOnceIndex() : uint
      {
         return this.FPlayOnceIndex;
      }
      
      public function get PlayFiveIndex() : uint
      {
         return this.FPlayFiveIndex;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get ReItemIndex() : uint
      {
         return this.FReItemIndex;
      }
      
      public function get RePriceIndex() : uint
      {
         return this.FRePriceIndex;
      }
      
      public function get CurPriceIndex() : uint
      {
         return this.FCurPriceIndex;
      }
      
      public function get ReStart() : uint
      {
         return this.FReStart;
      }
      
      public function get LuckIndex() : uint
      {
         return this.FLuckIndex;
      }
      
      public function get PlayCost() : uint
      {
         return this.FPlayCost;
      }
      
      public function get CurItems() : Vector.<uint>
      {
         return this.FCurItems;
      }
      
      public function get CurItemsIndex() : Vector.<uint>
      {
         return this.FCurItemsIndex;
      }
      
      public function get ScoreShop() : Vector.<Object>
      {
         return this.FScoreShop;
      }
      
      public function get ReItemCost() : uint
      {
         return this.FReItemCost;
      }
      
      public function get RePriceCost() : uint
      {
         return this.FRePriceCost;
      }
   }
}

