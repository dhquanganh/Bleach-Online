package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDAnniversaryTwo extends THDActivityBase
   {
      
      protected var FTotalPayIndex:uint;
      
      protected var FDayAward:Vector.<Object>;
      
      protected var FTotalAward:Vector.<Object>;
      
      protected var FBag:Object;
      
      public function THDAnniversaryTwo()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTotalPayIndex = param1.readUnsignedInt();
         this.FDayAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTotalAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get TotalPayIndex() : uint
      {
         return this.FTotalPayIndex;
      }
      
      public function get DayAward() : Vector.<Object>
      {
         return this.FDayAward;
      }
      
      public function get TotalAward() : Vector.<Object>
      {
         return this.FTotalAward;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
      
      public function set Bag(param1:Object) : void
      {
         this.FBag = param1;
      }
   }
}

