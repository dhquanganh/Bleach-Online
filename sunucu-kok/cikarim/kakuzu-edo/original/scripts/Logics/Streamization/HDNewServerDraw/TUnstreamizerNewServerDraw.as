package Logics.Streamization.HDNewServerDraw
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDNewServerDraw;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewServerDraw.TNewServerDrawData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNewServerDraw extends TUnstreamizer
   {
      
      public function TUnstreamizerNewServerDraw()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TNewServerDrawData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         _loc3_ = param1.Config.GiftIndexs.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = uint(param1.Config.GiftIndexs[_loc2_].awardId);
            _loc4_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_,_loc4_);
            param1.Invs[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:TNewServerDrawData) : void
      {
         if(this.RechargeHandle(param1,param2,param3))
         {
            return;
         }
         if(this.GiftIndexsHandle(param1,param2,param3))
         {
            return;
         }
         if(this.StudIndexHandle(param1,param2,param3))
         {
            return;
         }
      }
      
      protected function RechargeHandle(param1:uint, param2:Object, param3:TNewServerDrawData) : Boolean
      {
         if(param1 == param3.Config.Recharge.index)
         {
            param3.TodayReceiveState = TUtilityTool.ActState(param2);
            return true;
         }
         return false;
      }
      
      protected function GiftIndexsHandle(param1:uint, param2:Object, param3:TNewServerDrawData) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         _loc5_ = param3.Config.GiftIndexs.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.Config.GiftIndexs[_loc4_];
            if(param1 == _loc6_.index)
            {
               param3.GiftsState[_loc4_] = TUtilityTool.ActState(param2);
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function StudIndexHandle(param1:uint, param2:Object, param3:TNewServerDrawData) : Boolean
      {
         var _loc4_:uint = 0;
         if(param1 == param3.Config.StudIndex)
         {
            _loc4_ = uint(TUtilityTool.ActState(param2));
            param3.LotteryTargetIndex = param3.Config.DoubleIndex.indexOf(_loc4_);
            return true;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TNewServerDrawData = null;
         var _loc8_:THDNewServerDraw = null;
         _loc7_ = param2 as TNewServerDrawData;
         _loc8_ = param3 as THDNewServerDraw;
         _loc7_.LotteryTargetIndex = -1;
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
         var _loc4_:TNewServerDrawData = null;
         _loc4_ = param2 as TNewServerDrawData;
         _loc4_.LotteryTargetIndex = -1;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

