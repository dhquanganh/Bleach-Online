package Logics.Streamization.HDActivityCircleTrial
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDCircleHero;
   import Logics.HDActivityCircleTrial.TActivityCircleHeroData;
   import Logics.HDActivityCircleTrial.TCircleTaskVo;
   import Logics.HDActivityCircleTrial.TExtractFreeAwardVo;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerCircleHero extends TUnstreamizer
   {
      
      public function TUnstreamizerCircleHero()
      {
         super();
      }
      
      public function UnstreamizeInitHalloween(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityCircleHeroData = null;
         var _loc6_:THDCircleHero = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TInventories = null;
         var _loc10_:TExtractFreeAwardVo = null;
         _loc6_ = param3 as THDCircleHero;
         _loc5_ = param2 as TActivityCircleHeroData;
         _loc5_.CircleHeroConfig = _loc6_;
         _loc5_.ExtractInventories.length = 0;
         _loc8_ = int(_loc6_.ShowArr.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = new TInventories();
            if(_loc6_.ShowArr[_loc7_] != 0)
            {
               SToolReward.GetAwardsByAwardID(_loc6_.ShowArr[_loc7_],_loc9_);
               _loc5_.ExtractInventories[_loc7_] = _loc9_;
            }
            else
            {
               _loc5_.ExtractInventories[_loc7_] = null;
            }
            _loc7_++;
         }
         _loc5_.ExtractAwardVec.length = 0;
         _loc8_ = int(_loc6_.ExtractGiftIndexVec.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc10_ = new TExtractFreeAwardVo();
            _loc10_.TotalTimes = _loc6_.ExtractGiftConVec[_loc7_];
            _loc10_.Index = _loc6_.ExtractGiftIndexVec[_loc7_];
            _loc9_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.ExtractAwardVec[_loc7_],_loc9_);
            _loc10_.Inventories = _loc9_;
            _loc10_.IsGetAward = false;
            _loc5_.ExtractAwardVec[_loc7_] = _loc10_;
            _loc7_++;
         }
         _loc8_ = int(_loc6_.ChipGiftIndexVec.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc10_ = new TExtractFreeAwardVo();
            _loc10_.TotalTimes = _loc6_.ChipGiftConVec[_loc7_];
            _loc10_.Index = _loc6_.ChipGiftIndexVec[_loc7_];
            _loc10_.GetDebrisState = 0;
            _loc9_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.ChipGiftAwardVec[_loc7_],_loc9_);
            _loc10_.Inventories = _loc9_;
            _loc5_.DebrisGiftVec[_loc7_] = _loc10_;
            _loc7_++;
         }
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:TActivityCircleHeroData = null;
         var _loc10_:THDCircleHero = null;
         var _loc11_:String = null;
         var _loc12_:THDBoxStateData = null;
         var _loc13_:Vector.<THDBoxStateData> = null;
         var _loc14_:int = 0;
         var _loc15_:TInventories = null;
         var _loc16_:TCircleTaskVo = null;
         var _loc17_:int = 0;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as TActivityCircleHeroData;
         _loc10_ = param3 as THDCircleHero;
         _loc14_ = _loc8_.ParameterVec[0];
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = _loc8_.AllBox[_loc4_];
            if(_loc12_.BoxIndex == _loc10_.RechargeIndex)
            {
               _loc9_.CurRechargeValue = _loc12_.State;
               _loc9_.NeedRechargeValue = _loc10_.RechargeCondition[_loc14_];
               _loc15_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc10_.RechargeAwardVec[_loc14_],_loc15_);
               _loc9_.RechargeInventories = _loc15_;
            }
            else if(_loc12_.BoxIndex == _loc10_.RechargeGiftIndex)
            {
               _loc9_.RechargeGiftState = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.CurTaskIndex)
            {
               _loc16_ = new TCircleTaskVo();
               _loc7_ = int(_loc10_.TaskInfoIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc12_.State == _loc10_.TaskInfoIndexVec[_loc6_])
                  {
                     _loc16_.TotalTimes = _loc10_.TaskInfoValueVec[_loc6_];
                     _loc16_.AwardDescribeStr = _loc10_.LimitPrompt;
                     _loc17_ = 0;
                     while(_loc17_ < _loc10_.TaskDescribeTypeVec.length)
                     {
                        if(_loc10_.TaskInfoTypeVec[_loc6_] == _loc10_.TaskDescribeTypeVec[_loc17_])
                        {
                           _loc11_ = TUtilityString.Format(_loc10_.TaskDescribeInfoVec[_loc17_],_loc10_.TaskInfoValueVec[_loc6_]);
                           _loc16_.TaskDescribeStr = _loc11_;
                           _loc16_.GotoModuleId = _loc10_.TaskDescribeModuleIdVec[_loc17_];
                           break;
                        }
                        _loc17_++;
                     }
                     break;
                  }
                  _loc6_++;
               }
               _loc9_.TaskVo = _loc16_;
            }
            else if(_loc12_.BoxIndex >= _loc10_.TaskInfoIndexVec[0] && _loc12_.BoxIndex <= _loc10_.TaskInfoIndexVec[_loc10_.TaskInfoIndexVec.length - 1])
            {
               _loc7_ = int(_loc10_.TaskInfoIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc12_.BoxIndex == _loc10_.TaskInfoIndexVec[_loc6_])
                  {
                     _loc9_.TaskVo.CurrentTimes = _loc12_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            else if(_loc12_.BoxIndex == _loc10_.ExchangeHeroIndex)
            {
               _loc9_.HeroState = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.FreeTimeIndex)
            {
               _loc9_.FreeTimes = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.PlayerChipIndex)
            {
               _loc9_.CurrentDebris = _loc12_.State;
            }
            else if(_loc12_.BoxIndex >= _loc10_.ExtractGiftIndexVec[0] && _loc12_.BoxIndex <= _loc10_.ExtractGiftIndexVec[_loc10_.ExtractGiftIndexVec.length - 1])
            {
               _loc7_ = int(_loc10_.ExtractGiftIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc12_.BoxIndex == _loc10_.ExtractGiftIndexVec[_loc6_])
                  {
                     _loc9_.ExtractAwardVec[_loc6_].GetDebrisState = _loc12_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            else if(_loc12_.BoxIndex >= _loc10_.ChipGiftIndexVec[0] && _loc12_.BoxIndex <= _loc10_.ChipGiftIndexVec[_loc10_.ChipGiftIndexVec.length - 1])
            {
               _loc7_ = int(_loc10_.ChipGiftIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc5_)
               {
                  if(_loc12_.BoxIndex == _loc10_.ChipGiftIndexVec[_loc6_])
                  {
                     _loc9_.DebrisGiftVec[_loc6_].GetDebrisState = _loc12_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            else if(_loc12_.BoxIndex == _loc10_.TotalExtractTimes)
            {
               _loc9_.ExtractTotalTimes = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc10_.RoundsIndex)
            {
               _loc9_.Rounds = _loc12_.State;
               _loc7_ = int(_loc10_.ExtractGiftIndexVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc9_.ExtractAwardVec[_loc6_].TotalTimes = _loc10_.ExtractGiftConVec[_loc6_] + _loc10_.ExtractGiftConVec[_loc10_.ExtractGiftConVec.length - 1] * _loc9_.Rounds;
                  _loc6_++;
               }
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:TActivityCircleHeroData = null;
         var _loc6_:THDCircleHero = null;
         var _loc7_:TInventories = null;
         var _loc8_:TCircleTaskVo = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         _loc4_ = param1;
         _loc5_ = param2 as TActivityCircleHeroData;
         _loc6_ = param3 as THDCircleHero;
         if(_loc4_.Index == _loc6_.RechargeIndex)
         {
            _loc5_.CurRechargeValue = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.RechargeGiftIndex)
         {
            _loc5_.RechargeGiftState = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.CurTaskIndex)
         {
            _loc8_ = _loc5_.TaskVo;
            _loc10_ = int(_loc6_.TaskInfoIndexVec.length);
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               if(_loc4_.Status == _loc6_.TaskInfoIndexVec[_loc9_])
               {
                  _loc8_.TotalTimes = _loc6_.TaskInfoValueVec[_loc9_];
                  _loc12_ = 0;
                  while(_loc12_ < _loc6_.TaskDescribeTypeVec.length)
                  {
                     if(_loc6_.TaskInfoTypeVec[_loc9_] == _loc6_.TaskDescribeTypeVec[_loc12_])
                     {
                        _loc11_ = TUtilityString.Format(_loc6_.TaskDescribeInfoVec[_loc12_],_loc6_.TaskInfoValueVec[_loc9_]);
                        _loc8_.TaskDescribeStr = _loc11_;
                        _loc8_.GotoModuleId = _loc6_.TaskDescribeModuleIdVec[_loc12_];
                        break;
                     }
                     _loc12_++;
                  }
                  break;
               }
               _loc9_++;
            }
         }
         else if(_loc4_.Index >= _loc6_.TaskInfoIndexVec[0] && _loc4_.Index <= _loc6_.TaskInfoIndexVec[_loc6_.TaskInfoIndexVec.length - 1])
         {
            _loc10_ = int(_loc6_.TaskInfoIndexVec.length);
            _loc9_ = 0;
            while(_loc9_ < _loc10_)
            {
               if(_loc4_.Index == _loc6_.TaskInfoIndexVec[_loc9_])
               {
                  _loc5_.TaskVo.CurrentTimes = _loc4_.Status;
                  break;
               }
               _loc9_++;
            }
         }
         else if(_loc4_.Index == _loc6_.ExchangeHeroIndex)
         {
            _loc5_.HeroState = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.FreeTimeIndex)
         {
            _loc5_.FreeTimes = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.PlayerChipIndex)
         {
            _loc5_.CurrentDebris = _loc4_.Status;
         }
         else if(_loc4_.Index != _loc6_.AddChipIndex)
         {
            if(_loc4_.Index >= _loc6_.ExtractGiftIndexVec[0] && _loc4_.Index <= _loc6_.ExtractGiftIndexVec[_loc6_.ExtractGiftIndexVec.length - 1])
            {
               _loc10_ = int(_loc6_.ExtractGiftIndexVec.length);
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  if(_loc4_.Index == _loc6_.ExtractGiftIndexVec[_loc9_])
                  {
                     _loc5_.ExtractAwardVec[_loc9_].GetDebrisState = _loc4_.Status;
                     break;
                  }
                  _loc9_++;
               }
            }
            else if(_loc4_.Index >= _loc6_.ChipGiftIndexVec[0] && _loc4_.Index <= _loc6_.ChipGiftIndexVec[_loc6_.ChipGiftIndexVec.length - 1])
            {
               _loc10_ = int(_loc6_.ChipGiftIndexVec.length);
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  if(_loc4_.Index == _loc6_.ChipGiftIndexVec[_loc9_])
                  {
                     _loc5_.DebrisGiftVec[_loc9_].GetDebrisState = _loc4_.Status;
                     break;
                  }
                  _loc9_++;
               }
            }
            else if(_loc4_.Index == _loc6_.TotalExtractTimes)
            {
               _loc5_.ExtractTotalTimes = _loc4_.Status;
            }
            else if(_loc4_.Index == _loc6_.RoundsIndex)
            {
               _loc5_.Rounds = _loc4_.Status;
               _loc10_ = int(_loc6_.ExtractGiftIndexVec.length);
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  _loc5_.ExtractAwardVec[_loc9_].TotalTimes = _loc6_.ExtractGiftConVec[_loc9_] + _loc6_.ExtractGiftConVec[_loc6_.ExtractGiftConVec.length - 1] * _loc5_.Rounds;
                  _loc9_++;
               }
            }
         }
      }
   }
}

