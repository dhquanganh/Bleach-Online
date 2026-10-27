package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSoulDraw extends THDActivityBase
   {
      
      protected var FFreeAward:Vector.<Object>;
      
      protected var FGoldAward:Vector.<Object>;
      
      protected var FItemIndex:Vector.<int>;
      
      protected var FRefreshGold:uint;
      
      protected var FRefreshIndex:uint;
      
      protected var FBuyIndex:uint;
      
      public function THDSoulDraw()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFreeAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGoldAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FItemIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRefreshGold = param1.readInt();
         this.FRefreshIndex = param1.readInt();
         this.FBuyIndex = param1.readInt();
      }
      
      public function get FreeAward() : Vector.<Object>
      {
         return this.FFreeAward;
      }
      
      public function get GoldAward() : Vector.<Object>
      {
         return this.FGoldAward;
      }
      
      public function get ItemIndex() : Vector.<int>
      {
         return this.FItemIndex;
      }
      
      public function get RefreshGold() : uint
      {
         return this.FRefreshGold;
      }
      
      public function get RefreshIndex() : uint
      {
         return this.FRefreshIndex;
      }
      
      public function get BuyIndex() : uint
      {
         return this.FBuyIndex;
      }
   }
}

