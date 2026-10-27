package Logics.Streamization.HDGhostKingForg
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDGhostKingForg;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGhostKingForg.TGhostKingForgData;
   import Processors.Game.Utilities.Common.TUtilityTool;
   
   public class TUnstreamizerGhostKingForg extends TUnstreamizer
   {
      
      public function TUnstreamizerGhostKingForg()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:Object, param3:TGhostKingForgData) : void
      {
         if(this.DisposeScoreShop(param1,param2,param3))
         {
            return;
         }
         switch(param1)
         {
            case param3.Config.RechargeIndex:
               param3.TotalRecharge = TUtilityTool.ActState(param2);
               break;
            case param3.Config.Forging.index:
               param3.ForgPower = TUtilityTool.ActState(param2);
               break;
            case param3.Config.ForgingAward.index:
               param3.ForgGiftState = TUtilityTool.ActState(param2);
               break;
            case param3.Config.ScoreIndex:
               param3.TotalGhostKingPower = TUtilityTool.ActState(param2);
               break;
            case param3.Config.AdditionalAward.index:
               param3.CanSelectCount = TUtilityTool.ActState(param2);
               break;
            case param3.Config.BigAward.index:
               param3.ShowUIState = TUtilityTool.ActState(param2);
         }
      }
      
      protected function DisposeScoreShop(param1:uint, param2:Object, param3:TGhostKingForgData) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         _loc5_ = 0;
         for each(_loc4_ in param3.Config.ScoreShop)
         {
            if(param1 == _loc4_.index)
            {
               param3.ScoreItemStates[_loc5_] = TUtilityTool.ActState(param2);
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TGhostKingForgData = null;
         var _loc8_:THDGhostKingForg = null;
         _loc7_ = param2 as TGhostKingForgData;
         _loc8_ = param3 as THDGhostKingForg;
         _loc7_.Config = _loc8_;
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
         var _loc4_:TGhostKingForgData = null;
         _loc4_ = param2 as TGhostKingForgData;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

