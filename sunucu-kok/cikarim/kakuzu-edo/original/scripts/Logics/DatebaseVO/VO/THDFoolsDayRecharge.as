package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDFoolsDayRecharge extends THDActivityBase
   {
      
      protected var FRechargeIndex:uint;
      
      protected var FDayAward:Object;
      
      protected var FTotalAward:Object;
      
      protected var FProgressAward:Object;
      
      public function THDFoolsDayRecharge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRechargeIndex = param1.readInt();
         this.FDayAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FTotalAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FProgressAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get RechargeIndex() : uint
      {
         return this.FRechargeIndex;
      }
      
      public function get DayAward() : Object
      {
         return this.FDayAward;
      }
      
      public function get TotalAward() : Object
      {
         return this.FTotalAward;
      }
      
      public function get ProgressAward() : Object
      {
         return this.FProgressAward;
      }
   }
}

