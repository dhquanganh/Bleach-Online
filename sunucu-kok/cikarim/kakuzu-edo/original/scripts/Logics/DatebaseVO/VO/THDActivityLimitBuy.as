package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityLimitBuy.TActivityLimitBuyItem;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDActivityLimitBuy extends THDActivityBase
   {
      
      protected var FBuyLimitItems:Vector.<TActivityLimitBuyItem>;
      
      protected var FFlushTime:Vector.<uint>;
      
      protected var FPrompts:Vector.<String>;
      
      public function THDActivityLimitBuy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:TActivityLimitBuyItem = null;
         var _loc7_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FBuyLimitItems = new Vector.<TActivityLimitBuyItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TActivityLimitBuyItem(_loc5_[_loc2_].boxIndex);
            _loc6_.LimitBuyCount = _loc5_[_loc2_].limit;
            _loc6_.Cost = _loc5_[_loc2_].cost;
            _loc6_.ServerLimitCount = _loc5_[_loc2_].serverLimit;
            _loc6_.BuyCondition = _loc5_[_loc2_].condition[0].value;
            _loc7_ = _loc5_[_loc2_].award as Array;
            _loc6_.Awards.push(_loc7_[0]);
            this.FBuyLimitItems[_loc2_] = _loc6_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FFlushTime = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FFlushTime[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FPrompts = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FPrompts[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
      }
      
      public function get BuyLimitItems() : Vector.<TActivityLimitBuyItem>
      {
         return this.FBuyLimitItems;
      }
      
      public function get FlushTime() : Vector.<uint>
      {
         return this.FFlushTime;
      }
      
      public function get Prompts() : Vector.<String>
      {
         return this.FPrompts;
      }
   }
}

