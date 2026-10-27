package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTotalCost extends THDActivityBase
   {
      
      protected var FActAwards:Vector.<TActAward>;
      
      protected var FEquipShowVec:Vector.<Object>;
      
      public function THDTotalCost()
      {
         super();
         this.FEquipShowVec = new Vector.<Object>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TActAward = null;
         var _loc6_:Array = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FActAwards = new Vector.<TActAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TActAward(_loc6_[_loc2_]);
            this.FActAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         this.FEquipShowVec = Vector.<Object>(_loc6_);
      }
      
      public function get ActAwards() : Vector.<TActAward>
      {
         return this.FActAwards;
      }
      
      public function get EquipShowVec() : Vector.<Object>
      {
         return this.FEquipShowVec;
      }
   }
}

