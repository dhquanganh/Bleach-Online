package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActVipBoxAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDVipBox extends THDActivityBase
   {
      
      protected var FActAwards:Vector.<TActVipBoxAward>;
      
      public function THDVipBox()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TActVipBoxAward = null;
         var _loc6_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FActAwards = new Vector.<TActVipBoxAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TActVipBoxAward(_loc6_[_loc2_].index);
            _loc5_.Limit = _loc6_[_loc2_].limit;
            _loc5_.Cost = _loc6_[_loc2_].cost;
            _loc5_.Key = _loc6_[_loc2_].condition;
            _loc5_.Awards.push(_loc6_[_loc2_].award[0]);
            _loc5_.OriginalPrice = _loc6_[_loc2_].originalPrice;
            _loc5_.Prompt = _loc6_[_loc2_].prompt;
            _loc5_.GetType = _loc6_[_loc2_].getType;
            this.FActAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      public function get ActAwards() : Vector.<TActVipBoxAward>
      {
         return this.FActAwards;
      }
   }
}

