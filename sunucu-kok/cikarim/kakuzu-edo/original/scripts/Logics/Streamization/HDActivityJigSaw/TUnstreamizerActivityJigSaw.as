package Logics.Streamization.HDActivityJigSaw
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDJigSaw;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDJigSaw.TActivityJSScore;
   import Logics.HDJigSaw.TActivityJigSaw;
   
   public class TUnstreamizerActivityJigSaw extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityJigSaw()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateJigSaw(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityJigSaw = null;
         var _loc7_:TActivityJSScore = null;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:THDJigSaw = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityJigSaw;
         _loc9_ = param3 as THDJigSaw;
         _loc6_.Awards = _loc9_.AwardsList;
         _loc6_.Buys = _loc9_.BuysList;
         _loc6_.Score = _loc9_.Score;
         _loc10_ = _loc8_.AwardStates;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetDataByUIndex(_loc10_[_loc4_].BoxIndex,_loc10_[_loc4_].State);
            _loc4_++;
         }
         _loc11_ = _loc8_.ShowOnlyStates;
         _loc5_ = int(_loc11_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetDataByUIndex(_loc11_[_loc4_].BoxIndex,_loc11_[_loc4_].State);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateJigSaw(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateJigSaw(param1,param2,param3);
      }
   }
}

