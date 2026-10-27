package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSheepGoodSell extends THDActivityBase
   {
      
      protected var FActAwardIndex:Vector.<int>;
      
      protected var FActAwardGold:Vector.<Vector.<int>>;
      
      protected var FActAwardAward:Vector.<Vector.<int>>;
      
      protected var FActAwardFreeAwardType:Vector.<int>;
      
      protected var FActAwardFreeAwardID:Vector.<int>;
      
      protected var FActAwardFreeAwardShowID:Vector.<int>;
      
      protected var FActAwardFreeAwarFightReportAddr:Vector.<String>;
      
      protected var FLoadingAwardIndex:int;
      
      protected var FLoadingAwardAward:Vector.<int>;
      
      protected var FFinalAwardIndex:int;
      
      protected var FFinalAwardAwardType:int;
      
      protected var FFinalAwardAwardID:int;
      
      protected var FFinalAwardShowID:int;
      
      protected var FFinalAwardCostNeed:int;
      
      protected var FFinalAwardFightReportAddr:String;
      
      protected var FActivityNumIndex:int;
      
      public function THDSheepGoodSell()
      {
         super();
         this.FActAwardIndex = new Vector.<int>();
         this.FActAwardGold = new Vector.<Vector.<int>>();
         this.FActAwardAward = new Vector.<Vector.<int>>();
         this.FActAwardFreeAwardType = new Vector.<int>();
         this.FActAwardFreeAwardID = new Vector.<int>();
         this.FActAwardFreeAwardShowID = new Vector.<int>();
         this.FActAwardFreeAwarFightReportAddr = new Vector.<String>();
         this.FLoadingAwardAward = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            this.FActAwardIndex.push(_loc4_[_loc2_].index);
            this.FActAwardGold.push(Vector.<int>(_loc4_[_loc2_].gold));
            this.FActAwardAward.push(Vector.<int>(_loc4_[_loc2_].award));
            this.FActAwardFreeAwardType.push(_loc4_[_loc2_].freeAwardType);
            this.FActAwardFreeAwardID.push(_loc4_[_loc2_].freeAwardID);
            this.FActAwardFreeAwardShowID.push(_loc4_[_loc2_].showId);
            this.FActAwardFreeAwarFightReportAddr.push(_loc4_[_loc2_].fightReport);
            _loc2_++;
         }
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc3_);
         this.FLoadingAwardIndex = _loc5_.index;
         this.FLoadingAwardAward = Vector.<int>(_loc5_.award);
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc3_);
         this.FFinalAwardIndex = _loc5_.index;
         this.FFinalAwardAwardType = _loc5_.awardType;
         this.FFinalAwardAwardID = _loc5_.awardID;
         this.FFinalAwardCostNeed = _loc5_.costNeed;
         this.FFinalAwardShowID = _loc5_.showId;
         this.FFinalAwardFightReportAddr = _loc5_.fightReport;
         this.FActivityNumIndex = param1.readInt();
      }
      
      public function get ActAwardIndex() : Vector.<int>
      {
         return this.FActAwardIndex;
      }
      
      public function get ActAwardGold() : Vector.<Vector.<int>>
      {
         return this.FActAwardGold;
      }
      
      public function get ActAwardAward() : Vector.<Vector.<int>>
      {
         return this.FActAwardAward;
      }
      
      public function get ActAwardFreeAwardType() : Vector.<int>
      {
         return this.FActAwardFreeAwardType;
      }
      
      public function get ActAwardFreeAwardID() : Vector.<int>
      {
         return this.FActAwardFreeAwardID;
      }
      
      public function get LoadingAwardIndex() : int
      {
         return this.FLoadingAwardIndex;
      }
      
      public function get LoadingAwardAward() : Vector.<int>
      {
         return this.FLoadingAwardAward;
      }
      
      public function get FinalAwardIndex() : int
      {
         return this.FFinalAwardIndex;
      }
      
      public function get ActivityNumIndex() : int
      {
         return this.FActivityNumIndex;
      }
      
      public function get FinalAwardAwardType() : int
      {
         return this.FFinalAwardAwardType;
      }
      
      public function get FinalAwardAwardID() : int
      {
         return this.FFinalAwardAwardID;
      }
      
      public function get FinalAwardCostNeed() : int
      {
         return this.FFinalAwardCostNeed;
      }
      
      public function get ActAwardFreeAwardShowID() : Vector.<int>
      {
         return this.FActAwardFreeAwardShowID;
      }
      
      public function get FinalAwardShowID() : int
      {
         return this.FFinalAwardShowID;
      }
      
      public function get ActAwardFreeAwarFightReportAddr() : Vector.<String>
      {
         return this.FActAwardFreeAwarFightReportAddr;
      }
      
      public function get FinalAwardFightReportAddr() : String
      {
         return this.FFinalAwardFightReportAddr;
      }
   }
}

