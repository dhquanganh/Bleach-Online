package Logics.Streamization.HDChildrenDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChildrenDayHero;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayHero;
   import Logics.Inventories.TInventories;
   
   public class TUnstreamizerChildrenDayHero extends TUnstreamizer
   {
      
      public function TUnstreamizerChildrenDayHero()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TChildrenDayHero) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TChildrenDayHero) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDChildrenDayHero = null;
         var _loc8_:uint = 0;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TChildrenDayHero = null;
         var _loc9_:THDChildrenDayHero = null;
         _loc8_ = param2 as TChildrenDayHero;
         _loc9_ = param3 as THDChildrenDayHero;
         if(_loc8_.Config == null)
         {
            _loc8_.Config = _loc9_;
            this.ConfigHandle(_loc8_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TChildrenDayHero = null;
         var _loc5_:THDChildrenDayHero = null;
         _loc4_ = param2 as TChildrenDayHero;
         _loc5_ = param3 as THDChildrenDayHero;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

