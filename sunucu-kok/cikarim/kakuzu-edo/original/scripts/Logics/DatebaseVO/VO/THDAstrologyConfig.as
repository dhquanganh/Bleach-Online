package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDAstrologyConfig extends THDActivityBase
   {
      
      private var FLoginGiftVec:Vector.<int>;
      
      private var FLoginIndex:int;
      
      private var FExtractSingleIndex:int;
      
      private var FExtractCostGold:int;
      
      private var FFreeSingleVal:int;
      
      private var FExtractMoreIndex:int;
      
      private var FDiscount:int;
      
      private var FRefreshIndex:int;
      
      private var FRefreshCostGold:int;
      
      private var FFreeRefreshVal:int;
      
      private var FStarIndexVec:Vector.<int>;
      
      private var FStarTypeVec:Vector.<int>;
      
      private var FStarGoldVec:Vector.<int>;
      
      private var FStarDescVec:Vector.<String>;
      
      private var FStarPositionVec:Vector.<int>;
      
      private var FGetStatCardIndex:int;
      
      private var FCompoundIndexVec:Vector.<int>;
      
      private var FCompoundCardIndexVec:Vector.<Vector.<int>>;
      
      private var FCompoundCardConditionVec:Vector.<Vector.<int>>;
      
      private var FCompoundStarSoulVec:Vector.<int>;
      
      private var FStarIndex:int;
      
      private var FSoulIndex:int;
      
      private var FStarShopItemIndexVec:Vector.<int>;
      
      private var FStarShopItemAwardVec:Vector.<int>;
      
      private var FStarConditonVec:Vector.<int>;
      
      private var FStarLimitVec:Vector.<int>;
      
      private var FSoulShopItemIndexVec:Vector.<int>;
      
      private var FSoulShopItemAwardVec:Vector.<int>;
      
      private var FSoulConditonVec:Vector.<int>;
      
      private var FSoulLimitVec:Vector.<int>;
      
      private var FConditionDesc:String;
      
      public function THDAstrologyConfig()
      {
         super();
         this.FStarIndexVec = new Vector.<int>();
         this.FStarTypeVec = new Vector.<int>();
         this.FStarGoldVec = new Vector.<int>();
         this.FStarDescVec = new Vector.<String>();
         this.FCompoundIndexVec = new Vector.<int>();
         this.FCompoundCardIndexVec = new Vector.<Vector.<int>>();
         this.FCompoundCardConditionVec = new Vector.<Vector.<int>>();
         this.FCompoundStarSoulVec = new Vector.<int>();
         this.FStarShopItemIndexVec = new Vector.<int>();
         this.FStarShopItemAwardVec = new Vector.<int>();
         this.FStarConditonVec = new Vector.<int>();
         this.FStarLimitVec = new Vector.<int>();
         this.FSoulShopItemIndexVec = new Vector.<int>();
         this.FSoulShopItemAwardVec = new Vector.<int>();
         this.FSoulConditonVec = new Vector.<int>();
         this.FSoulLimitVec = new Vector.<int>();
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
         this.FLoginIndex = _loc6_.index;
         this.FLoginGiftVec = Vector.<int>(_loc6_.awardIds);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FExtractSingleIndex = _loc6_.index;
         this.FExtractCostGold = _loc6_.gold;
         this.FFreeSingleVal = _loc6_.count;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FExtractMoreIndex = _loc6_.index;
         this.FDiscount = _loc6_.discount;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRefreshIndex = _loc6_.index;
         this.FRefreshCostGold = _loc6_.gold;
         this.FFreeRefreshVal = _loc6_.count;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStarIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FStarTypeVec[_loc2_] = _loc4_[_loc2_].type;
            this.FStarGoldVec[_loc2_] = _loc4_[_loc2_].gold;
            this.FStarDescVec[_loc2_] = _loc4_[_loc2_].desc;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FStarPositionVec = Vector.<int>(_loc4_);
         this.FGetStatCardIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCompoundIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FCompoundCardIndexVec[_loc2_] = Vector.<int>(_loc4_[_loc2_].combinations);
            this.FCompoundCardConditionVec[_loc2_] = Vector.<int>(_loc4_[_loc2_].condition);
            this.FCompoundStarSoulVec[_loc2_] = _loc4_[_loc2_].starSoul;
            _loc2_++;
         }
         this.FStarIndex = param1.readUnsignedInt();
         this.FSoulIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStarShopItemIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FStarShopItemAwardVec[_loc2_] = _loc4_[_loc2_].awardId;
            this.FStarConditonVec[_loc2_] = _loc4_[_loc2_].star;
            this.FStarLimitVec[_loc2_] = _loc4_[_loc2_].count;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSoulShopItemIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FSoulShopItemAwardVec[_loc2_] = _loc4_[_loc2_].awardId;
            this.FSoulConditonVec[_loc2_] = _loc4_[_loc2_].soul;
            this.FSoulLimitVec[_loc2_] = _loc4_[_loc2_].count;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FConditionDesc = _loc6_.conditionPrompt;
      }
      
      public function get LoginGiftVec() : Vector.<int>
      {
         return this.FLoginGiftVec;
      }
      
      public function get LoginIndex() : int
      {
         return this.FLoginIndex;
      }
      
      public function get ExtractSingleIndex() : int
      {
         return this.FExtractSingleIndex;
      }
      
      public function get ExtractCostGold() : int
      {
         return this.FExtractCostGold;
      }
      
      public function get FreeSingleVal() : int
      {
         return this.FFreeSingleVal;
      }
      
      public function get ExtractMoreIndex() : int
      {
         return this.FExtractMoreIndex;
      }
      
      public function get Discount() : int
      {
         return this.FDiscount;
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
      }
      
      public function get RefreshCostGold() : int
      {
         return this.FRefreshCostGold;
      }
      
      public function get FreeRefreshVal() : int
      {
         return this.FFreeRefreshVal;
      }
      
      public function get StarIndexVec() : Vector.<int>
      {
         return this.FStarIndexVec;
      }
      
      public function get StarTypeVec() : Vector.<int>
      {
         return this.FStarTypeVec;
      }
      
      public function get StarGoldVec() : Vector.<int>
      {
         return this.FStarGoldVec;
      }
      
      public function get StarDescVec() : Vector.<String>
      {
         return this.FStarDescVec;
      }
      
      public function get StarPositionVec() : Vector.<int>
      {
         return this.FStarPositionVec;
      }
      
      public function get GetStatCardIndex() : int
      {
         return this.FGetStatCardIndex;
      }
      
      public function get CompoundIndexVec() : Vector.<int>
      {
         return this.FCompoundIndexVec;
      }
      
      public function get CompoundCardIndexVec() : Vector.<Vector.<int>>
      {
         return this.FCompoundCardIndexVec;
      }
      
      public function get CompoundCardConditionVec() : Vector.<Vector.<int>>
      {
         return this.FCompoundCardConditionVec;
      }
      
      public function get CompoundStarSoulVec() : Vector.<int>
      {
         return this.FCompoundStarSoulVec;
      }
      
      public function get StarIndex() : int
      {
         return this.FStarIndex;
      }
      
      public function get SoulIndex() : int
      {
         return this.FSoulIndex;
      }
      
      public function get StarShopItemIndexVec() : Vector.<int>
      {
         return this.FStarShopItemIndexVec;
      }
      
      public function get StarShopItemAwardVec() : Vector.<int>
      {
         return this.FStarShopItemAwardVec;
      }
      
      public function get StarConditonVec() : Vector.<int>
      {
         return this.FStarConditonVec;
      }
      
      public function get StarLimitVec() : Vector.<int>
      {
         return this.FStarLimitVec;
      }
      
      public function get SoulShopItemIndexVec() : Vector.<int>
      {
         return this.FSoulShopItemIndexVec;
      }
      
      public function get SoulShopItemAwardVec() : Vector.<int>
      {
         return this.FSoulShopItemAwardVec;
      }
      
      public function get SoulConditonVec() : Vector.<int>
      {
         return this.FSoulConditonVec;
      }
      
      public function get SoulLimitVec() : Vector.<int>
      {
         return this.FSoulLimitVec;
      }
      
      public function get ConditionDesc() : String
      {
         return this.FConditionDesc;
      }
   }
}

