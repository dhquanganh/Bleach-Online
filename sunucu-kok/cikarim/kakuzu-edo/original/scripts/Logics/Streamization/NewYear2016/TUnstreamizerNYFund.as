package Logics.Streamization.NewYear2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewYear2016Fund;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Fund;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNYFund extends TUnstreamizer
   {
      
      public function TUnstreamizerNYFund()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewYear2016Fund) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:TInventories = null;
         _loc2_ = param1.Config.RedBag.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = new TInventories();
            SToolReward.GetRandomAwardsByAwardID(param1.Config.RedBag[_loc3_].reward,_loc5_);
            param1.BagsIns[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewYear2016Fund) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDNewYear2016Fund = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.ReChargeIndex)
         {
            param3.Recharge = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.SpringFund.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.SpringFund[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.FundStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.RedBag.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.RedBag[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.BagsStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TNewYear2016Fund = null;
         var _loc9_:THDNewYear2016Fund = null;
         _loc8_ = param2 as TNewYear2016Fund;
         _loc9_ = param3 as THDNewYear2016Fund;
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
         var _loc4_:TNewYear2016Fund = null;
         _loc4_ = param2 as TNewYear2016Fund;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

