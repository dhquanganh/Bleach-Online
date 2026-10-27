package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNationalDayTwo2017 extends THDActivityBase
   {
      
      protected var FTotalPayIndex:uint;
      
      protected var FDayPayIndex:uint;
      
      protected var FSingleAward:Vector.<Object>;
      
      protected var FTotalAward:Vector.<Object>;
      
      protected var FBigAward:Object;
      
      public function THDNationalDayTwo2017()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTotalPayIndex = param1.readInt();
         this.FDayPayIndex = param1.readInt();
         this.FSingleAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTotalAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get TotalPayIndex() : uint
      {
         return this.FTotalPayIndex;
      }
      
      public function get DayPayIndex() : uint
      {
         return this.FDayPayIndex;
      }
      
      public function get SingleAward() : Vector.<Object>
      {
         return this.FSingleAward;
      }
      
      public function get TotalAward() : Vector.<Object>
      {
         return this.FTotalAward;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
   }
}

