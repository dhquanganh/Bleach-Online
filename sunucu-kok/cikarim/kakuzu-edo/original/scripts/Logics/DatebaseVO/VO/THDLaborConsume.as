package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDLaborConsume extends THDActivityBase
   {
      
      protected var FBanner:Vector.<Object>;
      
      protected var FCondition:Vector.<Object>;
      
      protected var FScore:int;
      
      protected var FRefresh:int;
      
      protected var FFreeTimes:int;
      
      protected var FRefreshCost:int;
      
      protected var FBannerIndex:Vector.<int>;
      
      protected var FMall:Vector.<Object>;
      
      protected var FBag:Object;
      
      protected var FLanguage:Object;
      
      public function THDLaborConsume()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FBanner = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCondition = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScore = param1.readInt();
         this.FRefresh = param1.readInt();
         this.FFreeTimes = param1.readInt();
         this.FRefreshCost = param1.readInt();
         this.FBannerIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBag = Json.decode(TUtilityString.FetchUTF(param1));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get Banner() : Vector.<Object>
      {
         return this.FBanner;
      }
      
      public function get Condition() : Vector.<Object>
      {
         return this.FCondition;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function get Refresh() : int
      {
         return this.FRefresh;
      }
      
      public function get FreeTimes() : int
      {
         return this.FFreeTimes;
      }
      
      public function get BannerIndex() : Vector.<int>
      {
         return this.FBannerIndex;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get Bag() : Object
      {
         return this.FBag;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
      
      public function get RefreshCost() : int
      {
         return this.FRefreshCost;
      }
   }
}

