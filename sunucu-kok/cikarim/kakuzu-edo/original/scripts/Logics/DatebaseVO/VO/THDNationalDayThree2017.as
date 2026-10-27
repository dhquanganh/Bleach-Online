package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNationalDayThree2017 extends THDActivityBase
   {
      
      protected var FRefreshIndex:uint;
      
      protected var FScoreIndex:uint;
      
      protected var FLotteryIndex:uint;
      
      protected var FLotteryRatio:uint;
      
      protected var FScoreRatio:uint;
      
      protected var FRefreshCost:uint;
      
      protected var FItemsIndex:Vector.<int>;
      
      protected var FPool:Vector.<Object>;
      
      protected var FLotteryAward:Vector.<Object>;
      
      protected var FMall:Vector.<Object>;
      
      protected var FItemsStatus:Vector.<int>;
      
      public function THDNationalDayThree2017()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRefreshIndex = param1.readInt();
         this.FScoreIndex = param1.readInt();
         this.FLotteryIndex = param1.readInt();
         this.FLotteryRatio = param1.readInt();
         this.FScoreRatio = param1.readInt();
         this.FRefreshCost = param1.readInt();
         this.FItemsIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPool = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLotteryAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FItemsStatus = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get RefreshIndex() : uint
      {
         return this.FRefreshIndex;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get LotteryIndex() : uint
      {
         return this.FLotteryIndex;
      }
      
      public function get RefreshCost() : uint
      {
         return this.FRefreshCost;
      }
      
      public function get ItemsIndex() : Vector.<int>
      {
         return this.FItemsIndex;
      }
      
      public function get Pool() : Vector.<Object>
      {
         return this.FPool;
      }
      
      public function get LotteryAward() : Vector.<Object>
      {
         return this.FLotteryAward;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get ItemsStatus() : Vector.<int>
      {
         return this.FItemsStatus;
      }
      
      public function get LotteryRatio() : uint
      {
         return this.FLotteryRatio;
      }
      
      public function get ScoreRatio() : uint
      {
         return this.FScoreRatio;
      }
   }
}

