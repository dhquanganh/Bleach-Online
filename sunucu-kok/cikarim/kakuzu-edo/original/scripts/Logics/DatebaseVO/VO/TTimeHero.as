package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TTimeHero extends TDatebaseVO
   {
      
      protected var FOneDayCost:int;
      
      protected var FThreeDayCost:int;
      
      protected var FSevenDayCost:int;
      
      protected var FForeverCost:int;
      
      protected var FTimeList:Vector.<int>;
      
      protected var FNeedCandy:int;
      
      public function TTimeHero()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         this.FOneDayCost = param1.readUnsignedInt();
         this.FThreeDayCost = param1.readUnsignedInt();
         this.FSevenDayCost = param1.readUnsignedInt();
         this.FForeverCost = param1.readUnsignedInt();
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc2_ = Json.decode(_loc3_);
         this.FTimeList = Vector.<int>(_loc2_);
         this.FNeedCandy = param1.readUnsignedInt();
      }
      
      public function get OneDayCost() : int
      {
         return this.FOneDayCost;
      }
      
      public function get ThreeDayCost() : int
      {
         return this.FThreeDayCost;
      }
      
      public function get SevenDayCost() : int
      {
         return this.FSevenDayCost;
      }
      
      public function get ForeverCost() : int
      {
         return this.FForeverCost;
      }
      
      public function get TimeList() : Vector.<int>
      {
         return this.FTimeList;
      }
      
      public function get NeedCandy() : int
      {
         return this.FNeedCandy;
      }
   }
}

