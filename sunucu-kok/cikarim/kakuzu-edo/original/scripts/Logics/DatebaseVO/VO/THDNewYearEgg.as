package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.THDEgg;
   import Logics.HDActivityChineseYear.TActivityLion;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYearEgg extends THDActivityBase
   {
      
      protected var FEggList:Vector.<THDEgg>;
      
      protected var FLionList:Vector.<TActivityLion>;
      
      public function THDNewYearEgg()
      {
         super();
         this.FEggList = new Vector.<THDEgg>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:TActivityLion = null;
         var _loc10_:Vector.<uint> = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_) as Array;
         _loc3_ = int(_loc8_.length);
         this.FLionList = new Vector.<TActivityLion>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new TActivityLion(_loc2_);
            _loc9_.GetType = _loc8_[_loc2_].getType;
            _loc9_.Condition = _loc8_[_loc2_].condition;
            _loc9_.Limit = _loc8_[_loc2_].limit;
            _loc9_.Cost = _loc8_[_loc2_].cost;
            _loc6_ = _loc8_[_loc2_].award;
            _loc5_ = int(_loc6_.length);
            _loc10_ = new Vector.<uint>();
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc10_.push(_loc6_[_loc4_]);
               _loc4_++;
            }
            _loc9_.Awards = _loc10_;
            _loc9_.DefaultCost = _loc8_[_loc2_].defaultCost;
            _loc9_.RateStr = _loc8_[_loc2_].rate;
            this.FLionList[_loc2_] = _loc9_;
            _loc2_++;
         }
      }
      
      public function get EggList() : Vector.<THDEgg>
      {
         return this.FEggList;
      }
      
      public function set EggList(param1:Vector.<THDEgg>) : void
      {
         this.FEggList = param1;
      }
      
      public function get LionList() : Vector.<TActivityLion>
      {
         return this.FLionList;
      }
   }
}

