package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TNightmareTrialCityConfig extends TDatebaseVO
   {
      
      private var FAwardVec:Vector.<int>;
      
      private var FPassAwardVec:Vector.<TFixedAward>;
      
      public function TNightmareTrialCityConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:TFixedAward = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_);
         this.FAwardVec = Vector.<int>(_loc4_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_);
         _loc7_ = int(_loc4_.length);
         this.FPassAwardVec = new Vector.<TFixedAward>();
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = new TFixedAward(_loc4_[_loc6_]);
            this.FPassAwardVec[_loc6_] = _loc5_;
            _loc6_++;
         }
      }
      
      public function get AwardVec() : Vector.<int>
      {
         return this.FAwardVec;
      }
      
      public function get PassAwardVec() : Vector.<TFixedAward>
      {
         return this.FPassAwardVec;
      }
   }
}

