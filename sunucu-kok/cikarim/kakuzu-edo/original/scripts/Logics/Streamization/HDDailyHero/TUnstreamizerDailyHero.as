package Logics.Streamization.HDDailyHero
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDDailyHero;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDDailyHero.THDDailyHeroData;
   
   public class TUnstreamizerDailyHero extends TUnstreamizer
   {
      
      public function TUnstreamizerDailyHero()
      {
         super();
      }
      
      protected function UnstreamizationPerform_InitDailyHero(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:THDDailyHeroData = null;
         var _loc6_:THDDailyHero = null;
         var _loc7_:Vector.<THDBoxStateData> = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as THDDailyHeroData;
         _loc6_ = param3 as THDDailyHero;
         _loc7_ = _loc4_.AllBox;
         _loc5_.AwardStates = new Vector.<int>();
         _loc10_ = _loc7_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            if(_loc7_[_loc8_].BoxIndex == _loc6_.ScoreIndex)
            {
               _loc5_.Score = _loc7_[_loc8_].State;
            }
            _loc8_++;
         }
         _loc9_ = _loc6_.Awards.length;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            if(_loc7_[_loc8_].BoxIndex != _loc6_.ScoreIndex)
            {
               _loc5_.AwardStates.push(_loc7_[_loc8_].State);
            }
            _loc8_++;
         }
      }
      
      protected function UnstreamizationPerform_ChangeDailyHero(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:THDDailyHeroData = null;
         var _loc6_:THDDailyHero = null;
         var _loc7_:Vector.<THDBoxStateData> = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc4_ = param1 as TActAwardStatusInfo;
         _loc5_ = param2 as THDDailyHeroData;
         _loc6_ = param3 as THDDailyHero;
         if(_loc4_.Index == _loc6_.ScoreIndex)
         {
            _loc5_.Score = _loc4_.Status;
         }
         if(_loc4_.Index != _loc6_.ScoreIndex)
         {
            _loc5_.AwardStates[_loc4_.Index - 1] = _loc4_.Status;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitDailyHero(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_ChangeDailyHero(param1,param2,param3);
      }
   }
}

