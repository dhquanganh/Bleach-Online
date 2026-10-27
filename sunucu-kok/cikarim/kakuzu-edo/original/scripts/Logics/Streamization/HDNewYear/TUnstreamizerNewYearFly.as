package Logics.Streamization.HDNewYear
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDNewYearFly;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewYear.TActivityNewYearFlyData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerNewYearFly extends TUnstreamizer
   {
      
      public function TUnstreamizerNewYearFly()
      {
         super();
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityInitRetData = null;
         var _loc7_:TActivityNewYearFlyData = null;
         var _loc8_:THDNewYearFly = null;
         _loc6_ = param1 as TActivityInitRetData;
         _loc7_ = param2 as TActivityNewYearFlyData;
         _loc8_ = param3 as THDNewYearFly;
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:TInventories = null;
         var _loc10_:TActivityInitRetData = null;
         var _loc11_:TActivityNewYearFlyData = null;
         var _loc12_:THDNewYearFly = null;
         var _loc13_:THDBoxStateData = null;
         _loc10_ = param1 as TActivityInitRetData;
         _loc11_ = param2 as TActivityNewYearFlyData;
         _loc12_ = param3 as THDNewYearFly;
         if(_loc10_.AllBox.length == 0)
         {
            return;
         }
         _loc11_.CurDay = _loc10_.ParameterVec[0];
         _loc11_.SetFriend(_loc10_.ParameterVec[1],_loc10_.ParameterVec[2]);
         _loc5_ = int(_loc10_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_ = false;
            _loc13_ = _loc10_.AllBox[_loc4_];
            if(_loc13_.BoxIndex == _loc12_.FriendIndex)
            {
               _loc11_.SetFriend(_loc13_.Conditions[0],_loc13_.Conditions[1]);
            }
            else if(_loc13_.BoxIndex == _loc12_.GoodCountIndex)
            {
               _loc11_.GoodCount = _loc13_.State;
            }
            else if(_loc13_.BoxIndex == _loc12_.CharmCountIndex)
            {
               _loc11_.CharmCount = _loc13_.State;
            }
            else
            {
               _loc7_ = int(_loc12_.GoodCardIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc13_.BoxIndex == _loc12_.GoodCardIndexVec[_loc6_])
                  {
                     _loc11_.GoodStatusVec[_loc6_] = _loc13_.State;
                     _loc8_ = true;
                     break;
                  }
                  _loc6_++;
               }
               if(!_loc8_)
               {
                  _loc7_ = int(_loc12_.CharmCardIndexVec.length);
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     if(_loc13_.BoxIndex == _loc12_.CharmCardIndexVec[_loc6_])
                     {
                        _loc11_.CharmStatusVec[_loc6_] = _loc13_.State;
                        _loc8_ = true;
                        break;
                     }
                     _loc6_++;
                  }
               }
            }
            _loc4_++;
         }
         _loc11_.ActInventories.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc12_.ActCount)
         {
            _loc9_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc12_.GetActAwardsByPos(_loc4_)[_loc11_.CurDay],_loc9_);
            _loc11_.ActInventories.push(_loc9_);
            _loc4_++;
         }
         _loc11_.NextActInventories.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc12_.ActCount)
         {
            if(_loc11_.CurDay + 1 >= _loc12_.ActAwardCount)
            {
               break;
            }
            _loc9_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc12_.GetActAwardsByPos(_loc4_)[_loc11_.CurDay + 1],_loc9_);
            _loc11_.NextActInventories.push(_loc9_);
            _loc4_++;
         }
         if(_loc12_.CharmInventories.length <= 0)
         {
            _loc5_ = int(_loc12_.CharmCardAwardVec.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc12_.CharmCardAwardVec[_loc4_],_loc9_);
               _loc12_.CharmInventories.push(_loc9_);
               _loc4_++;
            }
         }
         if(_loc12_.GoodInventories.length > 0)
         {
            return;
         }
         _loc5_ = int(_loc12_.GoodCardAwardVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc12_.GoodCardAwardVec[_loc4_],_loc9_);
            _loc12_.GoodInventories.push(_loc9_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:TActivityNewYearFlyData = null;
         var _loc8_:THDNewYearFly = null;
         var _loc9_:TActAwardStatusInfo = null;
         _loc9_ = param1;
         _loc7_ = param2 as TActivityNewYearFlyData;
         _loc8_ = param3 as THDNewYearFly;
         if(_loc9_.Index == _loc8_.FriendIndex)
         {
            _loc7_.SetFriend(_loc9_.Condition[0],_loc9_.Condition[1]);
         }
         else if(_loc9_.Index == _loc8_.GoodCountIndex)
         {
            _loc7_.GoodCount = _loc9_.Status;
         }
         else if(_loc9_.Index == _loc8_.CharmCountIndex)
         {
            _loc7_.CharmCount = _loc9_.Status;
         }
         else
         {
            _loc4_ = int(_loc8_.GoodCardIndexVec.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_loc9_.Index == _loc8_.GoodCardIndexVec[_loc5_])
               {
                  _loc7_.GoodStatusVec[_loc5_] = _loc9_.Status;
                  return;
               }
               _loc5_++;
            }
            _loc4_ = int(_loc8_.CharmCardIndexVec.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(_loc9_.Index == _loc8_.CharmCardIndexVec[_loc5_])
               {
                  _loc7_.CharmStatusVec[_loc5_] = _loc9_.Status;
                  return;
               }
               _loc5_++;
            }
         }
      }
   }
}

