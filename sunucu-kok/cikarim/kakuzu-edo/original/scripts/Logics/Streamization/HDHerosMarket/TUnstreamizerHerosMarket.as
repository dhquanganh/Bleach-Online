package Logics.Streamization.HDHerosMarket
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDHerosMarket;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDHerosMarket.TActivityHerosMarkets;
   
   public class TUnstreamizerHerosMarket extends TUnstreamizer
   {
      
      public function TUnstreamizerHerosMarket()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateHerosMarket(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TActivityHerosMarkets = null;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:THDHerosMarket = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         var _loc12_:Vector.<THDBoxStateData> = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc7_ = param2 as TActivityHerosMarkets;
         _loc9_ = param3 as THDHerosMarket;
         _loc7_.HerosHotStatus = new Vector.<int>(_loc9_.HerosHotId.length);
         _loc7_.KnifesHotStatus = new Vector.<int>(_loc9_.KnifeHotId.length);
         _loc7_.HerosAchieveStatus = new Vector.<int>(_loc9_.HerosAchieveAward.length);
         _loc7_.KnifesAchieveStatus = new Vector.<int>(_loc9_.KnifeAchieveAward.length);
         _loc10_ = _loc8_.ShowOnlyStates;
         _loc6_ = int(_loc9_.HerosHotId.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_.HerosHotStatus[_loc4_] = _loc10_[_loc4_].State;
            _loc4_++;
         }
         _loc6_ = int(_loc9_.KnifeHotId.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_.KnifesHotStatus[_loc5_] = _loc10_[_loc4_].State;
            _loc5_++;
         }
         _loc12_ = _loc8_.AwardStates;
         _loc6_ = int(_loc9_.HerosAchieveAward.length);
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc7_.HerosAchieveStatus[_loc4_] = _loc12_[_loc4_].State;
            _loc4_++;
         }
         _loc6_ = int(_loc9_.KnifeAchieveAward.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_.KnifesAchieveStatus[_loc5_] = _loc12_[_loc4_].State;
            _loc5_++;
         }
         _loc4_ += _loc6_;
         _loc7_.HeroExpStatus = _loc12_[_loc4_].State;
         _loc4_++;
         _loc7_.KnifeExpStatus = _loc12_[_loc4_].State;
      }
      
      public function UnstreamizeUpdateHerosMarket(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateHerosMarket(param1,param2,param3);
      }
   }
}

