package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTGD_2 extends THDActivityBase
   {
      
      protected var FRefreshIndex:int;
      
      protected var FBuyCostGold:int;
      
      protected var FRefreshCostGold:int;
      
      protected var FAllBuyIndex:int;
      
      protected var FCardInfo:Vector.<Object>;
      
      protected var FBlueIndex:int;
      
      protected var FPurpleIndex:int;
      
      protected var FGoldIndex:int;
      
      protected var FRedIndex:int;
      
      protected var FFreeIndex:int;
      
      protected var FItems:Vector.<Object>;
      
      protected var FMall:Vector.<Object>;
      
      protected var FCurItems:Vector.<int>;
      
      public function THDTGD_2()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRefreshIndex = param1.readUnsignedInt();
         this.FBuyCostGold = param1.readUnsignedInt();
         this.FRefreshCostGold = param1.readUnsignedInt();
         this.FAllBuyIndex = param1.readUnsignedInt();
         this.FCardInfo = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBlueIndex = param1.readUnsignedInt();
         this.FPurpleIndex = param1.readUnsignedInt();
         this.FGoldIndex = param1.readUnsignedInt();
         this.FRedIndex = param1.readUnsignedInt();
         this.FFreeIndex = param1.readUnsignedInt();
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCurItems = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
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
      
      public function get BlueIndex() : int
      {
         return this.FBlueIndex;
      }
      
      public function get PurpleIndex() : int
      {
         return this.FPurpleIndex;
      }
      
      public function get GoldIndex() : int
      {
         return this.FGoldIndex;
      }
      
      public function get RedIndex() : int
      {
         return this.FRedIndex;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get CurItems() : Vector.<int>
      {
         return this.FCurItems;
      }
      
      public function get CardInfo() : Vector.<Object>
      {
         return this.FCardInfo;
      }
      
      public function get FreeIndex() : int
      {
         return this.FFreeIndex;
      }
   }
}

