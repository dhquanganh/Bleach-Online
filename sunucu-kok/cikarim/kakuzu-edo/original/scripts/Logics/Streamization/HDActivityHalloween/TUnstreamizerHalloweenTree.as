package Logics.Streamization.HDActivityHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDHalloweenTree;
   import Logics.HDActivityHalloween.TActivityHalloweenTreeData;
   import Logics.HDActivityHalloween.THalloweenTreeGiftVo;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITYHALLOWEEN;
   
   public class TUnstreamizerHalloweenTree extends TUnstreamizer
   {
      
      public function TUnstreamizerHalloweenTree()
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
         var _loc5_:TActivityHalloweenTreeData = null;
         var _loc6_:THDHalloweenTree = null;
         var _loc7_:THalloweenTreeGiftVo = null;
         var _loc8_:TInventories = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityHalloweenTreeData;
         _loc6_ = param3 as THDHalloweenTree;
         _loc5_.RechargeGold = _loc6_.RechargeGold;
         _loc5_.LevelExpList = _loc6_.TreeExpList;
         _loc5_.GiftExpList = _loc6_.ExpStageList;
         if(_loc4_.AllBox.length == 0)
         {
            return;
         }
         _loc5_.ShowInventories.length = 0;
         _loc10_ = int(_loc6_.ShowList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.ShowList[_loc9_],_loc8_);
            _loc5_.ShowInventories.push(_loc8_);
            _loc9_++;
         }
         _loc5_.WaterAwardInventories.length = 0;
         _loc10_ = int(_loc6_.ShowAwardList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.ShowAwardList[_loc9_],_loc8_);
            _loc5_.WaterAwardInventories.push(_loc8_);
            _loc9_++;
         }
         _loc5_.TreePosList = _loc6_.ShowAwardPos;
         _loc5_.GiveTimes = _loc6_.FreeTimes;
         _loc5_.WateIndex = _loc6_.WaterIndex;
         _loc5_.GetAwardIndex = _loc6_.GetAwardIndex;
         _loc5_.GetPromptStr = _loc6_.PromptStr;
         _loc5_.waterSpendCost = _loc6_.WaterCost;
         _loc5_.GetFreePromptStr = _loc6_.FreePromptStr;
         _loc5_.WatrePromptStr = _loc6_.WaterPrompt;
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityInitRetData = null;
         var _loc7_:TActivityHalloweenTreeData = null;
         var _loc8_:THDHalloweenTree = null;
         var _loc9_:THalloweenTreeGiftVo = null;
         var _loc10_:THDBoxStateData = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         var _loc12_:TInventories = null;
         _loc6_ = param1 as TActivityInitRetData;
         _loc7_ = param2 as TActivityHalloweenTreeData;
         _loc8_ = param3 as THDHalloweenTree;
         if(_loc6_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc6_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc6_.AllBox[_loc4_];
            if(_loc10_.BoxIndex == _loc8_.WaterIndex)
            {
               _loc7_.ResidueWaterTimes = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.TreeLevelIndex)
            {
               if(_loc10_.State >= _loc7_.LevelExpList.length)
               {
                  _loc7_.TreesLevel = _loc7_.LevelExpList.length - 1;
               }
               else
               {
                  _loc7_.TreesLevel = _loc10_.State;
               }
               _loc7_.CurrentTotalExp = _loc8_.TreeExpList[_loc7_.TreesLevel];
            }
            else if(_loc10_.BoxIndex == _loc8_.ExpIndex)
            {
               _loc7_.CurrentExp = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.GetAwardIndex)
            {
               _loc7_.GetAwardNum = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.FreeTimesIndex)
            {
               _loc7_.WaterTimes = _loc8_.FreeTimes - _loc10_.State;
            }
            _loc4_++;
         }
         _loc7_.DataList.length = 0;
         _loc5_ = int(_loc8_.AwardList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = new THalloweenTreeGiftVo();
            _loc9_.AwardId = _loc8_.AwardList[_loc7_.TreesLevel][_loc4_];
            _loc9_.GetAwardExp = _loc8_.TreeExpList[_loc7_.TreesLevel] * _loc8_.ExpStageList[_loc4_] / 100;
            _loc9_.CurrentGiftState = this.SetAwardState(_loc4_,_loc7_.GetAwardNum,_loc9_.GetAwardExp,_loc7_.CurrentExp);
            _loc12_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc8_.AwardList[_loc7_.TreesLevel][_loc4_],_loc12_);
            _loc9_.Inventories = _loc12_;
            _loc7_.DataList.push(_loc9_);
            _loc4_++;
         }
      }
      
      protected function SetAwardState(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:int = 0;
         if(param1 < param2)
         {
            _loc5_ = CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskAlreadyFinish;
         }
         else if(param3 <= param4)
         {
            _loc5_ = CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskFinish;
         }
         else
         {
            _loc5_ = CONST_ACTIVITYHALLOWEEN.HALLOWEENTREE_TaskUnFinish;
         }
         return _loc5_;
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THalloweenTreeGiftVo = null;
         var _loc5_:TActAwardStatusInfo = null;
         var _loc6_:TActivityHalloweenTreeData = null;
         var _loc7_:THDHalloweenTree = null;
         var _loc8_:TInventories = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc5_ = param1;
         _loc6_ = param2 as TActivityHalloweenTreeData;
         _loc7_ = param3 as THDHalloweenTree;
         if(_loc5_.Index == _loc7_.WaterIndex)
         {
            _loc6_.ResidueWaterTimes = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.TreeLevelIndex)
         {
            if(_loc5_.Status >= _loc6_.LevelExpList.length)
            {
               _loc6_.TreesLevel = _loc6_.LevelExpList.length - 1;
            }
            else
            {
               _loc6_.TreesLevel = _loc5_.Status;
            }
         }
         else if(_loc5_.Index == _loc7_.ExpIndex)
         {
            _loc6_.CurrentExp = _loc5_.Status;
            if(_loc5_.Condition != null)
            {
               if(_loc5_.Condition.length > 0)
               {
                  _loc6_.CurrentGetAWardId = _loc5_.Condition[0];
                  _loc10_ = int(_loc7_.ShowAwardList.length);
                  _loc9_ = 0;
                  while(_loc9_ < _loc10_)
                  {
                     if(_loc6_.CurrentGetAWardId == _loc7_.ShowAwardList[_loc9_])
                     {
                        _loc6_.CurrrntGetAwardIndex = _loc9_;
                        break;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         else if(_loc5_.Index == _loc7_.GetAwardIndex)
         {
            _loc6_.GetAwardNum = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.FreeTimesIndex)
         {
            _loc6_.WaterTimes = _loc7_.FreeTimes - _loc5_.Status;
         }
         _loc10_ = int(_loc7_.AwardList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc4_ = _loc6_.DataList[_loc9_];
            _loc4_.AwardId = _loc7_.AwardList[_loc6_.TreesLevel][_loc9_];
            _loc4_.GetAwardExp = _loc7_.TreeExpList[_loc6_.TreesLevel] * _loc7_.ExpStageList[_loc9_] / 100;
            _loc4_.CurrentGiftState = this.SetAwardState(_loc9_,_loc6_.GetAwardNum,_loc4_.GetAwardExp,_loc6_.CurrentExp);
            _loc8_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc7_.AwardList[_loc6_.TreesLevel][_loc9_],_loc8_);
            _loc4_.Inventories = _loc8_;
            _loc9_++;
         }
      }
   }
}

