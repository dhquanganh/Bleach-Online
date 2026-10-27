package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THSwiftChangeConfig extends THDActivityBase
   {
      
      protected var FHeroList:Vector.<int>;
      
      protected var FBuyProIndexList:Vector.<int>;
      
      protected var FBuyProCostList:Vector.<int>;
      
      protected var FBuyProAwardList:Vector.<int>;
      
      protected var FBuyProLimitList:Vector.<int>;
      
      protected var FbuyProHeroIdList:Vector.<int>;
      
      public function THSwiftChangeConfig()
      {
         super();
         this.FBuyProIndexList = new Vector.<int>();
         this.FBuyProCostList = new Vector.<int>();
         this.FBuyProAwardList = new Vector.<int>();
         this.FBuyProLimitList = new Vector.<int>();
         this.FbuyProHeroIdList = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FHeroList = Vector.<int>(_loc4_);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBuyProIndexList[_loc2_] = _loc4_[_loc2_].index;
            this.FBuyProCostList[_loc2_] = _loc4_[_loc2_].cost;
            this.FBuyProAwardList[_loc2_] = _loc4_[_loc2_].award;
            this.FBuyProLimitList[_loc2_] = _loc4_[_loc2_].limit;
            this.FbuyProHeroIdList[_loc2_] = _loc4_[_loc2_].heroId;
            _loc2_++;
         }
      }
      
      public function get HeroList() : Vector.<int>
      {
         return this.FHeroList;
      }
      
      public function get BuyProIndexList() : Vector.<int>
      {
         return this.FBuyProIndexList;
      }
      
      public function get BuyProCostList() : Vector.<int>
      {
         return this.FBuyProCostList;
      }
      
      public function get BuyProAwardList() : Vector.<int>
      {
         return this.FBuyProAwardList;
      }
      
      public function get BuyProLimitList() : Vector.<int>
      {
         return this.FBuyProLimitList;
      }
      
      public function get buyProHeroIdList() : Vector.<int>
      {
         return this.FbuyProHeroIdList;
      }
   }
}

