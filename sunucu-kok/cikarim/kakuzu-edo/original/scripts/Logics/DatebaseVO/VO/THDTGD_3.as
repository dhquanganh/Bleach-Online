package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTGD_3 extends THDActivityBase
   {
      
      protected var FDayPayIndex:int;
      
      protected var FTotalIndex:int;
      
      protected var FAwardInfo:Vector.<Object>;
      
      protected var FPayInfo:Vector.<Object>;
      
      public function THDTGD_3()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDayPayIndex = param1.readUnsignedInt();
         this.FTotalIndex = param1.readUnsignedInt();
         this.FAwardInfo = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPayInfo = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get DayPayIndex() : int
      {
         return this.FDayPayIndex;
      }
      
      public function get TotalIndex() : int
      {
         return this.FTotalIndex;
      }
      
      public function get AwardInfo() : Vector.<Object>
      {
         return this.FAwardInfo;
      }
      
      public function get PayInfo() : Vector.<Object>
      {
         return this.FPayInfo;
      }
   }
}

