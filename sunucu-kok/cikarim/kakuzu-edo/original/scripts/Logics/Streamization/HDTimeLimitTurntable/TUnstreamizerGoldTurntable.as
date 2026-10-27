package Logics.Streamization.HDTimeLimitTurntable
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDTimeLimitTurntableConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDTimeLimitTurntable.TActivityGoldTurntableData;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerGoldTurntable extends TUnstreamizer
   {
      
      public function TUnstreamizerGoldTurntable()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGoldTurntableData = null;
         var _loc5_:THDTimeLimitTurntableConfig = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = param2 as TActivityGoldTurntableData;
         _loc5_ = param3 as THDTimeLimitTurntableConfig;
         _loc4_.ActivityConfig = _loc5_;
      }
      
      public function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGoldTurntableData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:THDTimeLimitTurntableConfig = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityGoldTurntableData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc6_ = param1 as THDTimeLimitTurntableConfig;
         _loc8_ = int(_loc5_.AllBox.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc10_ = _loc5_.AllBox[_loc7_];
            if(_loc10_.BoxIndex == _loc6_.LowFinishExtractIndex)
            {
               _loc4_.LowExtractValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc6_.HighFinishExtractIndex)
            {
               _loc4_.HighExtractValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc6_.RechargeIndex)
            {
               _loc4_.RechargeGoldValue = _loc10_.State;
            }
            _loc7_++;
         }
      }
      
      public function FillBoxState(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGoldTurntableData = null;
         var _loc5_:THDTimeLimitTurntableConfig = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActAwardStatusInfo = null;
         _loc8_ = param1;
         _loc4_ = param2 as TActivityGoldTurntableData;
         _loc5_ = param3 as THDTimeLimitTurntableConfig;
         if(_loc8_.Index == _loc5_.LowFinishExtractIndex)
         {
            _loc4_.LowExtractValue = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc5_.HighFinishExtractIndex)
         {
            _loc4_.HighExtractValue = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc5_.RechargeIndex)
         {
            _loc4_.RechargeGoldValue = _loc8_.Status;
         }
      }
   }
}

