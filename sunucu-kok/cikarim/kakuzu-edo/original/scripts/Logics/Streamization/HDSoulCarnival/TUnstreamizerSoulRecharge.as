package Logics.Streamization.HDSoulCarnival
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDSoulRecharge;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDSoulCarnival.TSoulRecharge;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerSoulRecharge extends TUnstreamizer
   {
      
      public function TUnstreamizerSoulRecharge()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TSoulRecharge) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Recharge[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.InvsVect[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TSoulRecharge) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDSoulRecharge = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         _loc6_ = _loc7_.Recharge.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.Recharge[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.Count[param1 - 1] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:TSoulRecharge = null;
         var _loc9_:THDSoulRecharge = null;
         _loc8_ = param2 as TSoulRecharge;
         _loc9_ = param3 as THDSoulRecharge;
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
         var _loc4_:TSoulRecharge = null;
         var _loc5_:THDSoulRecharge = null;
         _loc4_ = param2 as TSoulRecharge;
         _loc5_ = param3 as THDSoulRecharge;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

