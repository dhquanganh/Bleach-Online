package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDGroupLv extends THDActivityBase
   {
      
      protected var FCondition:Vector.<TConditionStyleA>;
      
      protected var FAwards:Vector.<uint>;
      
      public function THDGroupLv()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TConditionStyleA = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_) as Array;
         _loc5_ = int(_loc3_.length);
         this.FCondition = new Vector.<TConditionStyleA>(_loc5_);
         this.FAwards = new Vector.<uint>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TConditionStyleA(_loc3_[_loc4_]);
            this.FCondition[_loc4_] = _loc6_;
            this.FAwards[_loc4_] = _loc6_.Value[0];
            _loc4_++;
         }
      }
      
      public function get Condition() : Vector.<TConditionStyleA>
      {
         return this.FCondition;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
   }
}

