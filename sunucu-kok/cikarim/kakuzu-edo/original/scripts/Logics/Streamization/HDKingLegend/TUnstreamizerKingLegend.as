package Logics.Streamization.HDKingLegend
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDKingLegend;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDKingLegend.TActivityKingLegendData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_KingLegend;
   
   public class TUnstreamizerKingLegend extends TUnstreamizer
   {
      
      public static const Task_Finish:int = 1;
      
      public static const Task_UnFinish:int = 0;
      
      private const Task_Count:int = 4;
      
      public function TUnstreamizerKingLegend()
      {
         super();
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityKingLegendData = null;
         var _loc6_:THDKingLegend = null;
         var _loc7_:TInventories = null;
         var _loc8_:TKingLegendTaskVo = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityKingLegendData;
         _loc6_ = param3 as THDKingLegend;
         _loc5_.PlayerOrderValue = SLogicsCore.Character.CreditMilitaryOrders;
         _loc5_.ActivityConfig = _loc6_;
         _loc5_.ExtractInventories.length = 0;
         _loc10_ = int(_loc6_.TurnAwardArr.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.TurnAwardArr[_loc9_],_loc7_);
            _loc5_.ExtractInventories[_loc9_] = _loc7_;
            _loc9_++;
         }
         _loc10_ = this.Task_Count;
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc8_ = new TKingLegendTaskVo();
            _loc8_.taskCurValue = 0;
            _loc8_.taskTotalValue = 1;
            _loc8_.taskState = Task_UnFinish;
            _loc8_.taskType = _loc9_ + 1;
            _loc5_.TaskList[_loc9_] = _loc8_;
            _loc9_++;
         }
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityInitRetData = null;
         var _loc7_:TActivityKingLegendData = null;
         var _loc8_:THDKingLegend = null;
         var _loc9_:TKingLegendTaskVo = null;
         var _loc10_:THDBoxStateData = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         var _loc12_:TInventories = null;
         var _loc13_:int = 0;
         _loc6_ = param1 as TActivityInitRetData;
         _loc7_ = param2 as TActivityKingLegendData;
         _loc8_ = param3 as THDKingLegend;
         if(_loc6_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc6_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc6_.AllBox[_loc4_];
            if(_loc10_.BoxIndex == _loc8_.CurDayIndex)
            {
               _loc7_.CurDay = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.CurCostIndex)
            {
               _loc7_.CurCostGold = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.RechargeAwardIndex)
            {
               this.setTaskList(1,_loc10_.State,_loc7_.TaskList);
            }
            else if(_loc10_.BoxIndex == _loc8_.CostGoldAwardIndex)
            {
               this.setTaskList(2,_loc10_.State,_loc7_.TaskList);
            }
            else if(_loc10_.BoxIndex == _loc8_.TurntableIndex)
            {
               this.setTaskList(4,_loc10_.State,_loc7_.TaskList);
            }
            else if(_loc10_.BoxIndex == _loc8_.ExchargeIndexArr[0])
            {
               _loc7_.ExchargeFirstState = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.ExchargeIndexArr[1])
            {
               _loc7_.ExchargeSecondState = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc8_.BagIndex)
            {
               _loc7_.BagBtnState = _loc10_.State;
            }
            _loc4_++;
         }
         _loc12_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc8_.RechargeAwardArr[_loc7_.CurDay],_loc12_);
         _loc7_.RechargeInventories = _loc12_;
         _loc12_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc8_.CostGoldAwardArr[_loc7_.CurDay],_loc12_);
         _loc7_.GetAwardInventories = _loc12_;
         _loc12_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc8_.BagArr[_loc7_.CurDay],_loc12_);
         _loc7_.BagAwardInventories = _loc12_;
      }
      
      private function setTaskList(param1:int, param2:int, param3:Vector.<TKingLegendTaskVo>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param3.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3[_loc4_].taskType == param1)
            {
               if(param2 == CONST_KingLegend.Task_Finish || param2 == CONST_KingLegend.Task_GetAward)
               {
                  param3[_loc4_].taskCurValue = 1;
               }
               else
               {
                  param3[_loc4_].taskCurValue = 0;
               }
               param3[_loc4_].taskState = param2;
               break;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TKingLegendTaskVo = null;
         var _loc5_:TActAwardStatusInfo = null;
         var _loc6_:TActivityKingLegendData = null;
         var _loc7_:THDKingLegend = null;
         var _loc8_:TInventories = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc5_ = param1;
         _loc6_ = param2 as TActivityKingLegendData;
         _loc7_ = param3 as THDKingLegend;
         _loc6_.PlayerOrderValue = SLogicsCore.Character.CreditMilitaryOrders;
         if(_loc5_.Index == _loc7_.CurDayIndex)
         {
            _loc6_.CurDay = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.CurCostIndex)
         {
            _loc6_.CurCostGold = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.RechargeAwardIndex)
         {
            this.setTaskList(1,_loc5_.Status,_loc6_.TaskList);
         }
         else if(_loc5_.Index == _loc7_.CostGoldAwardIndex)
         {
            this.setTaskList(2,_loc5_.Status,_loc6_.TaskList);
         }
         else if(_loc5_.Index == _loc7_.TurntableIndex)
         {
            this.setTaskList(4,_loc5_.Status,_loc6_.TaskList);
            _loc6_.GetExtractInfoVec = _loc5_.Condition;
         }
         else if(_loc5_.Index == _loc7_.ExchargeIndexArr[0])
         {
            _loc6_.ExchargeFirstState = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.ExchargeIndexArr[1])
         {
            _loc6_.ExchargeSecondState = _loc5_.Status;
         }
         else if(_loc5_.Index == _loc7_.BagIndex)
         {
            _loc6_.BagBtnState = _loc5_.Status;
         }
         _loc8_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc7_.RechargeAwardArr[_loc6_.CurDay],_loc8_);
         _loc6_.RechargeInventories = _loc8_;
         _loc8_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc7_.CostGoldAwardArr[_loc6_.CurDay],_loc8_);
         _loc6_.GetAwardInventories = _loc8_;
         _loc8_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc7_.BagArr[_loc6_.CurDay],_loc8_);
         _loc6_.BagAwardInventories = _loc8_;
      }
   }
}

