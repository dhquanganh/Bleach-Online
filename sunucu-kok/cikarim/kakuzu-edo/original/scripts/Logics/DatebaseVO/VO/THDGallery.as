package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGallery extends THDActivityBase
   {
      
      protected var FLoginIndex:int;
      
      protected var FLoginAwardIdVec:Vector.<int>;
      
      protected var FAwardIndexVec:Vector.<int>;
      
      protected var FRewardIdsVec:Vector.<Vector.<int>>;
      
      protected var FBoxAwardIndexVec:Vector.<int>;
      
      protected var FBoxAwardIdVec:Vector.<int>;
      
      protected var FBoxCostScoreVec:Vector.<int>;
      
      protected var FExtractOneIndex:int;
      
      protected var FExtractOneCost:int;
      
      protected var FExtractTenIndex:int;
      
      protected var FExtractFiftyIndex:int;
      
      protected var FRefreshItemIndex:int;
      
      protected var FRefreshItemCost:int;
      
      protected var FRemoveIndex:int;
      
      protected var FRemoveCostVec:Vector.<int>;
      
      protected var FScoreIndex:int;
      
      protected var FFreeTimeIndex:int;
      
      protected var FFreeTime:int;
      
      protected var FDisCount:int;
      
      protected var FRemoveWords:Vector.<String>;
      
      public function THDGallery()
      {
         super();
         this.FLoginAwardIdVec = new Vector.<int>();
         this.FAwardIndexVec = new Vector.<int>();
         this.FRewardIdsVec = new Vector.<Vector.<int>>();
         this.FBoxAwardIndexVec = new Vector.<int>();
         this.FBoxAwardIdVec = new Vector.<int>();
         this.FBoxCostScoreVec = new Vector.<int>();
         this.FRemoveCostVec = new Vector.<int>();
         this.FRemoveWords = new Vector.<String>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         _loc4_ = _loc6_.awardId;
         this.FLoginIndex = _loc6_.index;
         this.FLoginAwardIdVec = Vector.<int>(_loc4_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAwardIndexVec.push(_loc6_.index);
         this.FRewardIdsVec.push(new Vector.<int>());
         _loc4_ = _loc6_.rewards;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRewardIdsVec[0].push(_loc4_[_loc2_].awardId);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAwardIndexVec.push(_loc6_.index);
         this.FRewardIdsVec.push(new Vector.<int>());
         _loc4_ = _loc6_.rewards;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRewardIdsVec[1].push(_loc4_[_loc2_].awardId);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAwardIndexVec.push(_loc6_.index);
         this.FRewardIdsVec.push(new Vector.<int>());
         _loc4_ = _loc6_.rewards;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRewardIdsVec[2].push(_loc4_[_loc2_].awardId);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FAwardIndexVec.push(_loc6_.index);
         this.FRewardIdsVec.push(new Vector.<int>());
         _loc4_ = _loc6_.rewards;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRewardIdsVec[3].push(_loc4_[_loc2_].awardId);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBoxAwardIndexVec.push(_loc4_[_loc2_].index);
            this.FBoxAwardIdVec.push(_loc4_[_loc2_].award);
            this.FBoxCostScoreVec.push(_loc4_[_loc2_].costScore);
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FExtractOneIndex = _loc6_.index;
         this.FExtractOneCost = _loc6_.cost;
         this.FExtractTenIndex = param1.readUnsignedInt();
         this.FExtractFiftyIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRefreshItemIndex = _loc6_.index;
         this.FRefreshItemCost = _loc6_.cost;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRemoveIndex = _loc6_.index;
         this.FRemoveCostVec = Vector.<int>(_loc6_.cost);
         this.FRemoveCostVec.unshift(0);
         this.FScoreIndex = param1.readUnsignedInt();
         this.FFreeTimeIndex = param1.readUnsignedInt();
         this.FFreeTime = param1.readUnsignedInt();
         this.FDisCount = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FRemoveWords = Vector.<String>(_loc4_);
      }
      
      public function get LoginIndex() : int
      {
         return this.FLoginIndex;
      }
      
      public function get BoxAwardIndexVec() : Vector.<int>
      {
         return this.FBoxAwardIndexVec;
      }
      
      public function get ExtractOneIndex() : int
      {
         return this.FExtractOneIndex;
      }
      
      public function get ExtractTenIndex() : int
      {
         return this.FExtractTenIndex;
      }
      
      public function get ExtractFiftyIndex() : int
      {
         return this.FExtractFiftyIndex;
      }
      
      public function get RefreshItemIndex() : int
      {
         return this.FRefreshItemIndex;
      }
      
      public function get RemoveIndex() : int
      {
         return this.FRemoveIndex;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get FreeTimeIndex() : int
      {
         return this.FFreeTimeIndex;
      }
      
      public function get AwardIndexVec() : Vector.<int>
      {
         return this.FAwardIndexVec;
      }
      
      public function get DisCount() : int
      {
         return this.FDisCount;
      }
      
      public function set DisCount(param1:int) : void
      {
         this.FDisCount = param1;
      }
      
      public function get ExtractOneCost() : int
      {
         return this.FExtractOneCost;
      }
      
      public function get RefreshItemCost() : int
      {
         return this.FRefreshItemCost;
      }
      
      public function get RemoveCostVec() : Vector.<int>
      {
         return this.FRemoveCostVec;
      }
      
      public function get RemoveWords() : Vector.<String>
      {
         return this.FRemoveWords;
      }
      
      public function get RewardIdsVec() : Vector.<Vector.<int>>
      {
         return this.FRewardIdsVec;
      }
      
      public function get BoxAwardIdVec() : Vector.<int>
      {
         return this.FBoxAwardIdVec;
      }
      
      public function get BoxCostScoreVec() : Vector.<int>
      {
         return this.FBoxCostScoreVec;
      }
      
      public function get FreeTime() : int
      {
         return this.FFreeTime;
      }
      
      public function get LoginAwardIdVec() : Vector.<int>
      {
         return this.FLoginAwardIdVec;
      }
   }
}

