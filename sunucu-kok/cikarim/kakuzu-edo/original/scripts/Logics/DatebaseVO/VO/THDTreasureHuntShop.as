package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTreasureHuntShop extends THDActivityBase
   {
      
      protected var FDarkIndex:uint;
      
      protected var FLightIndex:uint;
      
      protected var FDarkItemIndex:uint;
      
      protected var FLightItemIndex:uint;
      
      protected var FItems:Vector.<Object>;
      
      protected var FShop:Vector.<Object>;
      
      protected var FBigAward:Object;
      
      protected var FCost:uint;
      
      protected var FTexts:Vector.<Object>;
      
      public function THDTreasureHuntShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDarkIndex = param1.readInt();
         this.FLightIndex = param1.readInt();
         this.FDarkItemIndex = param1.readInt();
         this.FLightItemIndex = param1.readInt();
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FCost = param1.readInt();
         this.FTexts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get DarkIndex() : uint
      {
         return this.FDarkIndex;
      }
      
      public function get LightIndex() : uint
      {
         return this.FLightIndex;
      }
      
      public function get DarkItemIndex() : uint
      {
         return this.FDarkItemIndex;
      }
      
      public function get LightItemIndex() : uint
      {
         return this.FLightItemIndex;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
      
      public function get Shop() : Vector.<Object>
      {
         return this.FShop;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function get Texts() : Vector.<Object>
      {
         return this.FTexts;
      }
   }
}

