package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNationalDayOne2017 extends THDActivityBase
   {
      
      protected var FCostGold:uint;
      
      protected var FSignList:Vector.<Object>;
      
      protected var FLeftBags:Vector.<Object>;
      
      protected var FRightBags:Vector.<Object>;
      
      protected var FCurDayIndex:uint;
      
      public function THDNationalDayOne2017()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FCostGold = param1.readInt();
         this.FSignList = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLeftBags = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRightBags = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCurDayIndex = param1.readInt();
      }
      
      public function get CostGold() : uint
      {
         return this.FCostGold;
      }
      
      public function get SignList() : Vector.<Object>
      {
         return this.FSignList;
      }
      
      public function get LeftBags() : Vector.<Object>
      {
         return this.FLeftBags;
      }
      
      public function get RightBags() : Vector.<Object>
      {
         return this.FRightBags;
      }
      
      public function get CurDayIndex() : uint
      {
         return this.FCurDayIndex;
      }
   }
}

