package Logics.Streamization.HDNewYearSheep
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TFirecrackersConfig;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.FirecrackersVO.TFireGiftBoxVO;
   import Logics.HDNewYearSheep.TFirecrackersData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TUnstreamizerFirecrackers extends TUnstreamizer
   {
      
      public function TUnstreamizerFirecrackers()
      {
         super();
      }
      
      protected function ProcessorConfig(param1:TFirecrackersData, param2:TFirecrackersConfig) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:TFireGiftBoxVO = null;
         var _loc6_:TInventories = null;
         param1.Config = param2;
         _loc4_ = param2.FinalAward[param1.Day];
         param1.OneFireCost = param2.LightingAndReset[0].costGold;
         param1.ResetCost = param2.LightingAndReset[1].costGold;
         param1.NeedFire = _loc4_.condition;
         param1.AwardType = _loc4_.showType;
         param1.AwardID = _loc4_.showID;
         param1.ShowAwardID = _loc4_.showID;
         if(param1.AwardType == TShowAwardUI.ArticalType_Hero)
         {
            param1.FightReportAddr = _loc4_.fightReportAddr;
         }
         _loc3_ = 0;
         while(_loc3_ < TFirecrackersData.BoxCount)
         {
            _loc5_ = param1.BoxList[_loc3_];
            _loc5_.Inventories = new TInventories();
            SToolReward.GetAwardsByAwardID(param2.PackageAward[_loc3_],_loc5_.Inventories);
            _loc3_++;
         }
      }
      
      protected function Core(param1:int, param2:int, param3:Vector.<int>, param4:TFirecrackersData, param5:TFirecrackersConfig) : void
      {
         switch(param1)
         {
            case param5.FreeTimeIndex[0].lightingFreeIndex:
               param4.RemainFreeFire = param5.FreeTime[0].lightingFreeTime - param2;
               break;
            case param5.FreeTimeIndex[1].resetFreeIndex:
               param4.RemainFreeReset = param5.FreeTime[1].resetFreeTime - param2;
               break;
            case param5.InsideAwardState:
               this.UpdateFireState(param2,param4,param5);
               break;
            case param5.OutsideAwardState:
               this.UpdateBoxState(param2,param4,param5);
               break;
            case param5.FirecrackersNumIndex:
               param4.FireTotal = param2;
               break;
            case param5.FinalAwardState:
               param4.AwardState = param2;
         }
      }
      
      protected function UpdateFireState(param1:int, param2:TFirecrackersData, param3:TFirecrackersConfig) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:TFireGiftBoxVO = null;
         _loc4_ = 0;
         while(_loc4_ < TFirecrackersData.FireCount)
         {
            param2.FireState[_loc4_] = int((param1 & 1 << _loc4_) != 0);
            _loc4_++;
         }
         _loc8_ = int(param3.FirecrackersRelate.length);
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc7_ = param3.FirecrackersRelate[_loc4_];
            _loc5_ = int(_loc7_.condition);
            _loc6_ = _loc7_.relate;
            _loc10_ = (param1 & _loc5_) == _loc5_;
            _loc9_ = int(_loc6_.length);
            _loc11_ = 0;
            while(_loc11_ < _loc9_)
            {
               _loc12_ = param2.BoxList[_loc6_[_loc11_]];
               if(_loc10_)
               {
                  if(_loc12_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
                  {
                     _loc12_.State = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  }
               }
               else
               {
                  _loc12_.State = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
               }
               _loc11_++;
            }
            _loc4_++;
         }
      }
      
      protected function UpdateBoxState(param1:int, param2:TFirecrackersData, param3:TFirecrackersConfig) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TFireGiftBoxVO = null;
         _loc4_ = 0;
         while(_loc4_ < TFirecrackersData.BoxCount)
         {
            _loc5_ = int((param1 & 1 << _loc4_) != 0);
            _loc6_ = param2.BoxList[_loc4_];
            if(_loc5_ == 1)
            {
               _loc6_.State = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TFirecrackersData = null;
         var _loc8_:TFirecrackersConfig = null;
         _loc7_ = param2 as TFirecrackersData;
         _loc8_ = param3 as TFirecrackersConfig;
         _loc7_.Init = true;
         _loc7_.Day = param1.ParameterVec[0];
         this.ProcessorConfig(_loc7_,_loc8_);
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc6_.Conditions,_loc7_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TFirecrackersData = null;
         var _loc5_:TFirecrackersConfig = null;
         _loc4_ = param2 as TFirecrackersData;
         _loc5_ = param3 as TFirecrackersConfig;
         _loc4_.Init = false;
         this.Core(param1.Index,param1.Status,param1.Condition,_loc4_,_loc5_);
      }
   }
}

