package Logics.Streamization.HDThanksGivingDay2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDTGD_3;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksGivingDay2016.TTGD_3;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerTGD_3 extends TUnstreamizer
   {
      
      public function TUnstreamizerTGD_3()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TTGD_3) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc5_ = new TInventories();
         _loc4_ = uint(param1.Config.AwardInfo[0].awardId);
         SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
         param1.Bag_0 = _loc5_;
         _loc5_ = new TInventories();
         _loc4_ = uint(param1.Config.AwardInfo[1].awardId);
         SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
         param1.Bag_1 = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TTGD_3) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDTGD_3 = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.DayPayIndex)
         {
            param3.MyRecharge = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.TotalIndex)
         {
            param3.Recharge = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.AwardInfo[0].index)
         {
            param3.StatusBag_0 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.AwardInfo[1].index)
         {
            param3.StatusBag_1 = TUtilityTool.ActState(param2);
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TTGD_3 = null;
         var _loc8_:THDTGD_3 = null;
         _loc7_ = param2 as TTGD_3;
         _loc8_ = param3 as THDTGD_3;
         if(_loc7_.Config == null)
         {
            _loc7_.Config = _loc8_;
            this.ConfigHandle(_loc7_);
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
         var _loc4_:TTGD_3 = null;
         var _loc5_:THDTGD_3 = null;
         _loc4_ = param2 as TTGD_3;
         _loc5_ = param3 as THDTGD_3;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

