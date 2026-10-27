package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2016Nian extends THDActivityBase
   {
      
      protected var FOnceFund:Vector.<Object>;
      
      protected var FDailyFund:Vector.<Object>;
      
      protected var FActivityFund:Object;
      
      protected var FArrowIndex:uint;
      
      protected var FArrowAwards:Vector.<Object>;
      
      protected var FDayRechargeIndex:uint;
      
      protected var FTotalRechargeIndex:uint;
      
      protected var FArrowId:uint;
      
      public function THDNewYear2016Nian()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FOnceFund = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FDailyFund = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FActivityFund = Json.decode(TUtilityString.FetchUTF(param1));
         this.FArrowIndex = param1.readUnsignedInt();
         this.FArrowAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FDayRechargeIndex = param1.readUnsignedInt();
         this.FTotalRechargeIndex = param1.readUnsignedInt();
         this.FArrowId = param1.readUnsignedInt();
      }
      
      public function get OnceFund() : Vector.<Object>
      {
         return this.FOnceFund;
      }
      
      public function get DailyFund() : Vector.<Object>
      {
         return this.FDailyFund;
      }
      
      public function get ActivityFund() : Object
      {
         return this.FActivityFund;
      }
      
      public function get ArrowIndex() : uint
      {
         return this.FArrowIndex;
      }
      
      public function get ArrowAwards() : Vector.<Object>
      {
         return this.FArrowAwards;
      }
      
      public function get DayRechargeIndex() : uint
      {
         return this.FDayRechargeIndex;
      }
      
      public function get TotalRechargeIndex() : uint
      {
         return this.FTotalRechargeIndex;
      }
      
      public function get ArrowId() : uint
      {
         return this.FArrowId;
      }
   }
}

