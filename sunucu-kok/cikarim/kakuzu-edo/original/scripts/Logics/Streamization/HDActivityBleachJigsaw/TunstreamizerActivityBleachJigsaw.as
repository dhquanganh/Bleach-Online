package Logics.Streamization.HDActivityBleachJigsaw
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDBleachJigSaw;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDBleachJigsaw.TActivityBleachJigsaw;
   
   public class TunstreamizerActivityBleachJigsaw extends TUnstreamizer
   {
      
      public function TunstreamizerActivityBleachJigsaw()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateBleachJigsaw(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityBleachJigsaw = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDBleachJigSaw = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityBleachJigsaw;
         _loc8_ = param3 as THDBleachJigSaw;
         _loc6_.JigSawItemsVec = _loc8_.JigSawItemsVec;
         _loc6_.JigSawNeedsVec = _loc8_.JigSawNeedsVec;
         _loc6_.JigSawFinalAwardVec = _loc8_.JigSawFinalAwardVec;
         _loc6_.JigSawBtnVec = _loc8_.JigSawBtnVec;
         _loc6_.JigSawCoolDown = _loc7_.ParameterVec[0];
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetNumByUIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc6_.SetStatusByUIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc10_ = _loc7_.ShowOnlyStates;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetNumByUIndex(_loc10_[_loc4_].BoxIndex,_loc10_[_loc4_].State);
            _loc6_.SetStatusByUIndex(_loc10_[_loc4_].BoxIndex,_loc10_[_loc4_].Conditions[0]);
            _loc4_++;
         }
         _loc11_ = _loc7_.BuyStates;
         _loc5_ = int(_loc11_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.JigSawFinalStatus = _loc11_[_loc4_].State;
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateBleachJigsaw(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateBleachJigsaw(param1,param2,param3);
      }
   }
}

