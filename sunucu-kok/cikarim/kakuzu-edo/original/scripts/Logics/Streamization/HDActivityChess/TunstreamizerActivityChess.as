package Logics.Streamization.HDActivityChess
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDChess;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDChess.TActivityChess;
   
   public class TunstreamizerActivityChess extends TUnstreamizer
   {
      
      public function TunstreamizerActivityChess()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateChess(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityChess = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDChess = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityChess;
         _loc8_ = param3 as THDChess;
         _loc6_.Boxes = _loc8_.Boxes;
         _loc6_.FinalAward = _loc8_.FinalAward;
         _loc6_.AchieveAward = _loc8_.AchieveAward;
         _loc6_.MaxDiceNum = _loc8_.MaxDiceNum;
         _loc6_.NormalCost = _loc8_.NormalCost;
         _loc6_.ControlCost = _loc8_.ControlCost;
         _loc6_.CoolDown = _loc8_.CoolDown;
         _loc6_.LocationIndex = _loc8_.LocationIndex;
         _loc6_.FinalBoxIndex = _loc8_.FinalBoxIndex;
         _loc6_.CoolDown = _loc7_.ParameterVec[0];
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetStatusByUIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc10_ = _loc7_.AllBox;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc10_[_loc4_].BoxIndex == 100)
            {
               _loc6_.LocationPos = _loc10_[_loc4_].State;
            }
            if(_loc10_[_loc4_].BoxIndex == 101)
            {
               _loc6_.SetFinalBoxIndex(_loc10_[_loc4_].State);
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateChess(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateChess(param1,param2,param3);
      }
   }
}

