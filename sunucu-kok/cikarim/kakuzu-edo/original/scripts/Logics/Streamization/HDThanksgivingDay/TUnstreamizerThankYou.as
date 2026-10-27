package Logics.Streamization.HDThanksgivingDay
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Timing.STimingCore;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDThankYou;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThankYouData;
   import Processors.Game.Utilities.Common.TUtilityTool;
   
   public class TUnstreamizerThankYou extends TUnstreamizer
   {
      
      public function TUnstreamizerThankYou()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:Object, param3:TThankYouData) : void
      {
         if(param1 == param3.Config.Witness.index)
         {
            param3.WitnessKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.Growth.index)
         {
            param3.GrowthKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.Vip.index)
         {
            param3.VipKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.SuperVip.index)
         {
            param3.SuperVipKeys = TUtilityTool.ActState(param2);
         }
         else if(param1 == param3.Config.OnlineIndex)
         {
            param3.OnlineDay = (STimingCore.ServerTick - TUtilityTool.ActState(param2)) / 60 / 60 / 24;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TThankYouData = null;
         var _loc8_:THDThankYou = null;
         _loc7_ = param2 as TThankYouData;
         _loc8_ = param3 as THDThankYou;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TThankYouData = null;
         _loc4_ = param2 as TThankYouData;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

