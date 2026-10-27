package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDHalloweenTree extends THDActivityBase
   {
      
      private var FShowList:Vector.<int>;
      
      private var FShowAwardPos:Vector.<int>;
      
      private var FRechargeGold:int;
      
      private var FWaterIndex:int;
      
      private var FWateringExp:int;
      
      private var FWaterCost:int;
      
      private var FShowAwardList:Vector.<int>;
      
      private var FFreeTimes:int;
      
      private var FTreeExpList:Vector.<int>;
      
      private var FExpStageList:Vector.<int>;
      
      private var FAwardList:Array;
      
      private var FFreeTimesIndex:int;
      
      private var FTreeLevelIndex:int;
      
      private var FExpIndex:int;
      
      private var FGetAwardIndex:int;
      
      private var FPromptStr:String;
      
      private var FFreePromptStr:String;
      
      private var FWaterPrompt:String;
      
      public function THDHalloweenTree()
      {
         super();
         this.FShowList = new Vector.<int>(4);
         this.FShowAwardPos = new Vector.<int>(4);
         this.FShowAwardList = new Vector.<int>(9);
         this.FTreeExpList = new Vector.<int>(5);
         this.FExpStageList = new Vector.<int>(5);
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowList[_loc2_] = _loc4_[_loc2_].award;
            this.FShowAwardPos[_loc2_] = _loc4_[_loc2_].level;
            _loc2_++;
         }
         this.FRechargeGold = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FWaterIndex = _loc7_.index;
         this.FWaterCost = _loc7_.cost;
         this.FWateringExp = _loc7_.getExp;
         _loc6_ = _loc7_.waterAward as Array;
         _loc3_ = int(_loc6_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowAwardList[_loc2_] = _loc6_[_loc2_].award;
            _loc2_++;
         }
         this.FFreeTimes = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FTreeExpList = Vector.<int>(_loc4_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FExpStageList = Vector.<int>(_loc4_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FAwardList = _loc4_;
         this.FFreeTimesIndex = param1.readUnsignedInt();
         this.FTreeLevelIndex = param1.readUnsignedInt();
         this.FExpIndex = param1.readUnsignedInt();
         this.FGetAwardIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc5_);
         this.FPromptStr = _loc7_.treePrompt;
         this.FFreePromptStr = _loc7_.freePrompt;
         this.FWaterPrompt = _loc7_.waterPrompt;
      }
      
      public function get ShowList() : Vector.<int>
      {
         return this.FShowList;
      }
      
      public function get ShowAwardPos() : Vector.<int>
      {
         return this.FShowAwardPos;
      }
      
      public function get RechargeGold() : int
      {
         return this.FRechargeGold;
      }
      
      public function get WaterIndex() : int
      {
         return this.FWaterIndex;
      }
      
      public function get WateringExp() : int
      {
         return this.FWateringExp;
      }
      
      public function get WaterCost() : int
      {
         return this.FWaterCost;
      }
      
      public function get ShowAwardList() : Vector.<int>
      {
         return this.FShowAwardList;
      }
      
      public function get FreeTimes() : int
      {
         return this.FFreeTimes;
      }
      
      public function get TreeExpList() : Vector.<int>
      {
         return this.FTreeExpList;
      }
      
      public function get ExpStageList() : Vector.<int>
      {
         return this.FExpStageList;
      }
      
      public function get AwardList() : Array
      {
         return this.FAwardList;
      }
      
      public function get FreeTimesIndex() : int
      {
         return this.FFreeTimesIndex;
      }
      
      public function get TreeLevelIndex() : int
      {
         return this.FTreeLevelIndex;
      }
      
      public function get ExpIndex() : int
      {
         return this.FExpIndex;
      }
      
      public function get GetAwardIndex() : int
      {
         return this.FGetAwardIndex;
      }
      
      public function get PromptStr() : String
      {
         return this.FPromptStr;
      }
      
      public function get FreePromptStr() : String
      {
         return this.FFreePromptStr;
      }
      
      public function get WaterPrompt() : String
      {
         return this.FWaterPrompt;
      }
   }
}

