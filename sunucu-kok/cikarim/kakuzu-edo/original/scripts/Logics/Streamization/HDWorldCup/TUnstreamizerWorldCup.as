package Logics.Streamization.HDWorldCup
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDWorldCup;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDWorldCup.TActivityWorldCup;
   
   public class TUnstreamizerWorldCup extends TUnstreamizer
   {
      
      public function TUnstreamizerWorldCup()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateWorldCup(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityWorldCup = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDWorldCup = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityWorldCup;
         _loc8_ = param3 as THDWorldCup;
         _loc6_.Score = _loc7_.ParameterVec[0];
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.FinalStatus = _loc9_[_loc4_].State;
            _loc4_++;
         }
         _loc11_ = _loc7_.BuyStates;
         _loc5_ = int(_loc11_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.Flags[_loc4_] = _loc11_[_loc4_].State;
            _loc6_.HadMoney[_loc4_] = _loc11_[_loc4_].Conditions[0];
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateWorldCup(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateWorldCup(param1,param2,param3);
      }
   }
}

