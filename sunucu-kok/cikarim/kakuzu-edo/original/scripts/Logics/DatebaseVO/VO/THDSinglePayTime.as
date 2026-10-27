package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TSinglePayTimeAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSinglePayTime extends THDActivityBase
   {
      
      protected var FActAwards:Vector.<TSinglePayTimeAward>;
      
      protected var FPayDay:uint;
      
      public function THDSinglePayTime()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TSinglePayTimeAward = null;
         var _loc6_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FActAwards = new Vector.<TSinglePayTimeAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TSinglePayTimeAward(_loc6_[_loc2_]);
            this.FActAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FPayDay = param1.readUnsignedInt();
      }
      
      public function get ActAwards() : Vector.<TSinglePayTimeAward>
      {
         return this.FActAwards;
      }
      
      public function get PayDay() : uint
      {
         return this.FPayDay;
      }
   }
}

