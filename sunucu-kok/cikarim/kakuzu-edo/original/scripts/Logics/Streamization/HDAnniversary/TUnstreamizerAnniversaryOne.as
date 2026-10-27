package Logics.Streamization.HDAnniversary
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDAnniversaryOne;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAnniversary.TAnniversaryOne;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerAnniversaryOne extends TUnstreamizer
   {
      
      public function TUnstreamizerAnniversaryOne()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TAnniversaryOne) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.LoginAwardList[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.StepAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.ExtraAwardList[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.BigAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TAnniversaryOne) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDAnniversaryOne = null;
         var _loc7_:uint = 0;
         _loc6_ = param3.Config;
         if(param1 == _loc6_.OnRushIndex)
         {
            param3.RushStatus = TUtilityTool.ActState(param2);
         }
         _loc5_ = _loc6_.LoginAwardList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == _loc6_.LoginAwardList[_loc4_].index)
            {
               param3.StepAwardStatus[_loc4_] = TUtilityTool.ActState(param2);
            }
            _loc4_++;
         }
         _loc5_ = _loc6_.ExtraAwardList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param1 == _loc6_.ExtraAwardList[_loc4_].index)
            {
               param3.BigAwardStatus[_loc4_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TAnniversaryOne = null;
         var _loc9_:THDAnniversaryOne = null;
         _loc8_ = param2 as TAnniversaryOne;
         _loc9_ = param3 as THDAnniversaryOne;
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
         var _loc4_:TAnniversaryOne = null;
         var _loc5_:THDAnniversaryOne = null;
         _loc4_ = param2 as TAnniversaryOne;
         _loc5_ = param3 as THDAnniversaryOne;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

