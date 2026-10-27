package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNationalDayOne extends THDActivityBase
   {
      
      protected var FDayGifts:Vector.<Object>;
      
      protected var FProgressGifts:Vector.<Object>;
      
      protected var FRechargeIndex:int;
      
      public function THDNationalDayOne()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FDayGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FProgressGifts = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRechargeIndex = param1.readInt();
      }
      
      public function get ProgressGifts() : Vector.<Object>
      {
         return this.FProgressGifts;
      }
      
      public function get DayGifts() : Vector.<Object>
      {
         return this.FDayGifts;
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
   }
}

