package Logics.Streamization.HDEveryDayAward
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDEveryDayAward;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEveryDayAward.TEveryDayAwardData;
   
   public class TUnstreamizerEveryDayAward extends TUnstreamizer
   {
      
      public function TUnstreamizerEveryDayAward()
      {
         super();
      }
      
      protected function Core(param1:int, param2:int, param3:TEveryDayAwardData) : void
      {
         var _loc4_:int = 0;
         if(param1 == param3.Config.RechargeIndex)
         {
            param3.Recharge = param2;
         }
         else if(param1 == param3.Config.RechargeGiftIndex)
         {
            param3.RechargeGift = param2;
         }
         else if(param1 == param3.Config.ParticipateIndex)
         {
            param3.Participate = param2;
         }
         else
         {
            _loc4_ = param3.Config.RechargeIndexs.indexOf(param1);
            if(_loc4_ != -1)
            {
               param3.ShareGiftState[_loc4_] = param2;
            }
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TEveryDayAwardData = null;
         var _loc8_:THDEveryDayAward = null;
         _loc7_ = param2 as TEveryDayAwardData;
         _loc8_ = param3 as THDEveryDayAward;
         _loc7_.Config = _loc8_;
         _loc7_.Day = param1.ParameterVec[0];
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TEveryDayAwardData = null;
         _loc4_ = param2 as TEveryDayAwardData;
         this.Core(param1.Index,param1.Status,_loc4_);
      }
   }
}

