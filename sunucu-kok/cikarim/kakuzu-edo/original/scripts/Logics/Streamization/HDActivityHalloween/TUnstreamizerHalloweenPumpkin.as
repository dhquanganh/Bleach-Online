package Logics.Streamization.HDActivityHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDHalloweenPumpkin;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.SLogicsCore;
   
   public class TUnstreamizerHalloweenPumpkin extends TUnstreamizer
   {
      
      public function TUnstreamizerHalloweenPumpkin()
      {
         super();
      }
      
      protected function IsProgress(param1:TActivityHalloweenPumpkinData, param2:THDHalloweenPumpkin, param3:uint) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<uint> = null;
         _loc7_ = param2.TaskIndexCTS[param1.Day];
         _loc5_ = _loc7_.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc7_[_loc4_];
            if(param3 == _loc6_)
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      protected function Core(param1:TActivityHalloweenPumpkinData, param2:THDHalloweenPumpkin, param3:uint, param4:int) : void
      {
         var _loc5_:Vector.<uint> = null;
         if(!this.IsProgress(param1,param2,param3))
         {
            switch(param3)
            {
               case param2.PumpkinLightIndex:
                  param1.MyLightCount = param4;
                  break;
               case param2.MatchIndex:
                  param1.MatchCount = param4;
                  break;
               case param2.ServerAwardIndex:
                  param1.AllServerRewardGet = Boolean(param4);
                  break;
               case param2.AllPumpkinLightIndex:
                  param1.AllLightCount = param4;
            }
         }
         else
         {
            _loc5_ = param2.TaskIndexCTS[param1.Day];
            param1.Progress[_loc5_.indexOf(param3)] = param4;
         }
      }
      
      public function UnstreamizeInitHalloween(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:Vector.<THDBoxStateData> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDBoxStateData = null;
         var _loc8_:Vector.<Object> = null;
         var _loc9_:TActivityServerRank = null;
         var _loc10_:TActivityHalloweenPumpkinData = null;
         var _loc11_:THDHalloweenPumpkin = null;
         _loc10_ = param2 as TActivityHalloweenPumpkinData;
         _loc11_ = param3 as THDHalloweenPumpkin;
         _loc10_.IsUpdatePackage = false;
         if(_loc11_ != null)
         {
            _loc10_.Config = _loc11_;
         }
         _loc4_ = param1.AllBox;
         _loc5_ = _loc4_.length;
         if(_loc5_ > 0)
         {
            _loc10_.Day = param1.ParameterVec[0];
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc4_[_loc6_];
               this.Core(_loc10_,_loc11_,_loc7_.BoxIndex,_loc7_.State);
               _loc6_++;
            }
         }
         _loc10_.ClearRank();
         _loc8_ = param1.AddtionalVecs[0];
         _loc5_ = _loc8_.length;
         if(_loc5_ <= 0)
         {
            return;
         }
         _loc10_.MyRank = -1;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = _loc8_[_loc6_] as TActivityServerRank;
            if(_loc9_.LowID == SLogicsCore.Character.Identifier1 && _loc9_.HighID == SLogicsCore.Character.Identifier0)
            {
               _loc10_.MyRank = _loc9_.Rank;
            }
            _loc10_.AddRankItem(_loc9_);
            _loc6_++;
         }
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TActivityHalloweenPumpkinData = null;
         var _loc5_:THDHalloweenPumpkin = null;
         _loc4_ = param2 as TActivityHalloweenPumpkinData;
         _loc5_ = param3 as THDHalloweenPumpkin;
         _loc4_.IsUpdatePackage = true;
         this.Core(_loc4_,_loc5_,param1.Index,param1.Status);
         if(param1.Index == _loc5_.PumpkinLightIndex)
         {
            _loc4_.PumpkinReward = param1.Condition[0];
         }
      }
   }
}

