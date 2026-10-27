package Logics.Streamization.HDPyramid
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDPyramid;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDPyramid.THDPyramidData;
   
   public class TunstreamizerPyramid extends TUnstreamizer
   {
      
      public function TunstreamizerPyramid()
      {
         super();
      }
      
      protected function UnstreamizationPerform_Init(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:THDPyramidData = null;
         var _loc6_:THDPyramid = null;
         var _loc7_:Vector.<THDBoxStateData> = null;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as THDPyramidData;
         _loc6_ = param3 as THDPyramid;
         _loc7_ = _loc4_.AllBox;
         _loc8_ = _loc4_.ShowOnlyStates;
         _loc10_ = _loc7_.length;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            if(_loc7_[_loc9_].BoxIndex == _loc6_.RechargeIndex)
            {
               _loc5_.RechargeNum = _loc7_[_loc9_].State;
            }
            if(_loc7_[_loc9_].BoxIndex == _loc6_.ExtractIndex)
            {
               _loc5_.ExtractNum = _loc7_[_loc9_].State;
            }
            if(_loc7_[_loc9_].BoxIndex == _loc6_.PositionIndex)
            {
               _loc5_.CurLine = _loc7_[_loc9_].State;
            }
            if(_loc7_[_loc9_].BoxIndex == 98)
            {
               _loc5_.PreLine = _loc7_[_loc9_].State;
            }
            if(_loc7_[_loc9_].BoxIndex == _loc6_.SmashOne)
            {
               _loc5_.Position = _loc7_[_loc9_].State;
            }
            _loc9_++;
         }
         _loc10_ = _loc8_.length;
         _loc5_.GiftStatus = new Vector.<int>(_loc10_);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc5_.GiftStatus[_loc9_] = _loc8_[_loc9_].State;
            _loc9_++;
         }
         _loc5_.ScoreNum = _loc4_.ParameterVec[0];
      }
      
      protected function UnstreamizationPerform_Change(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:THDPyramidData = null;
         var _loc6_:THDPyramid = null;
         var _loc7_:Vector.<THDBoxStateData> = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc4_ = param1 as TActAwardStatusInfo;
         _loc5_ = param2 as THDPyramidData;
         _loc6_ = param3 as THDPyramid;
         if(_loc4_.Index == _loc6_.SmashOne)
         {
            _loc5_.Position = _loc4_.Status;
         }
         if(_loc4_.Index == _loc6_.PositionIndex)
         {
            _loc5_.CurLine = _loc4_.Status;
         }
         if(_loc4_.Index == _loc6_.RechargeIndex)
         {
            _loc5_.RechargeNum = _loc4_.Status;
         }
         if(_loc4_.Index == _loc6_.ExtractIndex)
         {
            _loc5_.ExtractNum = _loc4_.Status;
         }
         if(_loc4_.Index == _loc6_.ScoreIndex)
         {
            _loc5_.ScoreNum = _loc4_.Status;
         }
         if(_loc4_.Index == 98)
         {
            _loc5_.PreLine = _loc4_.Status;
         }
         _loc10_ = _loc6_.Gift.length;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            if(_loc6_.Gift[_loc8_].index == _loc4_.Index)
            {
               _loc5_.GiftStatus[_loc8_] = _loc4_.Status;
            }
            _loc8_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Init(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Change(param1,param2,param3);
      }
   }
}

