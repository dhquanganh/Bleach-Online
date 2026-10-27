package Logics.Streamization.HDChildrenDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDChildrenDayCollect;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayCollect;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   
   public class TUnstreamizerChildrenDayCollect extends TUnstreamizer
   {
      
      public function TUnstreamizerChildrenDayCollect()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TChildrenDayCollect) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TChildrenDayCollect) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDChildrenDayCollect = null;
         var _loc7_:uint = 0;
         _loc6_ = param3.Config;
         _loc5_ = _loc6_.Items.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == _loc6_.Items[_loc4_].index)
            {
               param3.BagStatus[_loc4_] = TUtilityTool.ActState(param2);
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TChildrenDayCollect = null;
         var _loc9_:THDChildrenDayCollect = null;
         _loc8_ = param2 as TChildrenDayCollect;
         _loc9_ = param3 as THDChildrenDayCollect;
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
         var _loc4_:TChildrenDayCollect = null;
         var _loc5_:THDChildrenDayCollect = null;
         _loc4_ = param2 as TChildrenDayCollect;
         _loc5_ = param3 as THDChildrenDayCollect;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

