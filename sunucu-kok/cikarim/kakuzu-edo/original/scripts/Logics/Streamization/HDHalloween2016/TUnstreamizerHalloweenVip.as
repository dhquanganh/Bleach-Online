package Logics.Streamization.HDHalloween2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDHalloweenVip;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDHalloween2016.THalloweenVip;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerHalloweenVip extends TUnstreamizer
   {
      
      public function TUnstreamizerHalloweenVip()
      {
         super();
      }
      
      protected function ConfigHandle(param1:THalloweenVip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.DayFreeGifts[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Gifts[_loc2_] = _loc5_;
            if(param1.Config.DayFreeGifts[_loc2_].add > 0)
            {
               _loc6_ = new TInventories();
               SToolReward.GetInventoryByIDAmount(param1.Config.MaskId,param1.Config.DayFreeGifts[_loc2_].add,_loc6_);
               param1.Gifts[_loc2_].Add(_loc6_.GetInventoryByIndex(0));
            }
            _loc2_++;
         }
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.DayChargeGifts[_loc2_].award);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Gifts[_loc2_ + 3] = _loc5_;
            if(param1.Config.DayChargeGifts[_loc2_].add > 0)
            {
               _loc6_ = new TInventories();
               SToolReward.GetInventoryByIDAmount(param1.Config.MaskId,param1.Config.DayChargeGifts[_loc2_].add,_loc6_);
               param1.Gifts[_loc2_ + 3].Add(_loc6_.GetInventoryByIndex(0));
            }
            _loc2_++;
         }
         _loc5_ = new TInventories();
         _loc4_ = uint(param1.Config.ProgressChargeGifts[0].award);
         SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
         param1.Gifts[8] = _loc5_;
         if(param1.Config.ProgressChargeGifts[0].add > 0)
         {
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByIDAmount(param1.Config.MaskId,param1.Config.ProgressChargeGifts[0].add,_loc6_);
            param1.Gifts[8].Add(_loc6_.GetInventoryByIndex(0));
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:THalloweenVip) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDHalloweenVip = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.RechargeIndex)
         {
            param3.Recharge = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ProgressChargeIndex)
         {
            param3.Period = TUtilityTool.ActState(param2);
         }
         else if(param1 == 9)
         {
            param3.BagStatus[8] = TUtilityTool.ActState(param2);
         }
         _loc6_ = 3;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.DayFreeGifts[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.BagStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = 5;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.DayChargeGifts[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.BagStatus[_loc5_ + 3] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:THalloweenVip = null;
         var _loc8_:THDHalloweenVip = null;
         _loc7_ = param2 as THalloweenVip;
         _loc8_ = param3 as THDHalloweenVip;
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
         var _loc4_:THalloweenVip = null;
         _loc4_ = param2 as THalloweenVip;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

