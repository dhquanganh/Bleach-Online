package Logics.Streamization.HDActivityRecharge
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDDailyCost;
   import Logics.DatebaseVO.VO.THDDailyPay;
   import Logics.DatebaseVO.VO.THDDailyTotalCost;
   import Logics.DatebaseVO.VO.THDDailyTotalPay;
   import Logics.DatebaseVO.VO.THDFirstPay;
   import Logics.DatebaseVO.VO.THDMoneyPenny;
   import Logics.DatebaseVO.VO.THDSinglePay;
   import Logics.DatebaseVO.VO.THDTotalCost;
   import Logics.DatebaseVO.VO.THDTotalPay;
   import Logics.DatebaseVO.VO.THDVipBox;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityRecharge.TActivityRSAwardBox;
   import Logics.HDActivityRecharge.TActivityRechargeSuitReturnGold;
   import Logics.HDActivityRecharge.TAwardData;
   import Logics.HDActivityRecharge.TDailyCostAwardData;
   import Logics.HDActivityRecharge.THDDailyCostData;
   import Logics.HDActivityRecharge.THDDailyPayData;
   import Logics.HDActivityRecharge.THDDailyTotalCostData;
   import Logics.HDActivityRecharge.THDDailyTotalPayData;
   import Logics.HDActivityRecharge.THDFirstPayData;
   import Logics.HDActivityRecharge.THDSinglePayData;
   import Logics.HDActivityRecharge.THDTotalCostData;
   import Logics.HDActivityRecharge.THDTotalPayData;
   import Logics.HDActivityRecharge.THDVipBoxData;
   import Logics.HDActivitySoulBox.TActivityMoneyPenny;
   import Logics.HDActivitySoulBox.TActivityMoneyPennyBox;
   
   public class TUnstreamizerActivityRecharge extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityRecharge()
      {
         super();
      }
      
      private function UnstreamizationPerform_UpdateDailyCost(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDDailyCostData = null;
         var _loc6_:THDDailyCost = null;
         var _loc7_:TDailyCostAwardData = null;
         _loc5_ = param1 as THDDailyCostData;
         _loc6_ = param2 as THDDailyCost;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetDailyCostDataByBase(_loc7_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetDailyCostDataByBase(param1:TDailyCostAwardData, param2:THDDailyCost, param3:int) : void
      {
         if(param2 == null)
         {
            return;
         }
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateDailyPay(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDDailyPayData = null;
         var _loc6_:THDDailyPay = null;
         var _loc7_:TAwardData = null;
         _loc5_ = param1 as THDDailyPayData;
         _loc6_ = param2 as THDDailyPay;
         if(_loc6_ == null)
         {
            return;
         }
         _loc5_.Award.Name = _loc6_.ActAwards[0].Key.toString();
         _loc5_.Award.ItemIdList = _loc6_.ActAwards[0].Awards;
      }
      
      private function UnstreamizationPerform_UpdateSinglePay(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDSinglePayData = null;
         var _loc6_:THDSinglePay = null;
         var _loc7_:TAwardData = null;
         _loc5_ = param1 as THDSinglePayData;
         _loc6_ = param2 as THDSinglePay;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetSinglePayDataByBase(_loc7_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetSinglePayDataByBase(param1:TAwardData, param2:THDSinglePay, param3:uint) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateTotalCost(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDTotalCostData = null;
         var _loc6_:THDTotalCost = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TAwardData = null;
         _loc5_ = param1 as THDTotalCostData;
         _loc6_ = param2 as THDTotalCost;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetTotalCostDataByBase(_loc8_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetTotalCostDataByBase(param1:TAwardData, param2:THDTotalCost, param3:int) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateTotalPay(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDTotalPayData = null;
         var _loc6_:THDTotalPay = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TAwardData = null;
         _loc5_ = param1 as THDTotalPayData;
         _loc6_ = param2 as THDTotalPay;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetTotalPayDataByBase(_loc8_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetTotalPayDataByBase(param1:TAwardData, param2:THDTotalPay, param3:uint) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateVipBox(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDVipBoxData = null;
         var _loc6_:THDVipBox = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TAwardData = null;
         _loc5_ = param1 as THDVipBoxData;
         _loc6_ = param2 as THDVipBox;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetVipBoxDataByBase(_loc8_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetVipBoxDataByBase(param1:TAwardData, param2:THDVipBox, param3:int) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateFirstPay(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THDFirstPayData = null;
         var _loc7_:THDFirstPay = null;
         var _loc8_:Vector.<int> = null;
         var _loc9_:TAwardData = null;
         var _loc10_:TActivityInitRetData = null;
         var _loc11_:THDBoxStateData = null;
         _loc10_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as THDFirstPayData;
         _loc7_ = param3 as THDFirstPay;
         _loc6_.TotalPay = _loc10_.ParameterVec[0];
         _loc6_.ClearAward();
         _loc5_ = int(_loc10_.AwardStates.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc10_.AwardStates[_loc4_];
            _loc9_ = new TAwardData();
            _loc9_.State = _loc11_.State;
            this.SetFirstPayDataByBase(_loc9_,_loc7_,_loc4_);
            _loc6_.AddAward(_loc9_);
            _loc4_++;
         }
      }
      
      private function SetFirstPayDataByBase(param1:TAwardData, param2:THDFirstPay, param3:int) : void
      {
         param1.Name = param2.ActAwards[param3].Key.toString();
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateDailyTotalCost(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDDailyTotalCostData = null;
         var _loc6_:THDDailyTotalCost = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TAwardData = null;
         _loc5_ = param1 as THDDailyTotalCostData;
         _loc6_ = param2 as THDDailyTotalCost;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetDailyTotalCostDataByBase(_loc8_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetDailyTotalCostDataByBase(param1:TAwardData, param2:THDDailyTotalCost, param3:int) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      private function UnstreamizationPerform_UpdateDailyTotalPay(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDDailyTotalPayData = null;
         var _loc6_:THDDailyTotalPay = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TAwardData = null;
         _loc5_ = param1 as THDDailyTotalPayData;
         _loc6_ = param2 as THDDailyTotalPay;
         _loc4_ = int(_loc5_.CountForAward());
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.GetAwardByIndex(_loc3_);
            this.SetDailyTotalPayDataByBase(_loc8_,_loc6_,_loc3_);
            _loc3_++;
         }
      }
      
      private function SetDailyTotalPayDataByBase(param1:TAwardData, param2:THDDailyTotalPay, param3:uint) : void
      {
         param1.Name = param2.ActAwards[param3].Prompt;
         param1.ItemIdList = param2.ActAwards[param3].Awards;
      }
      
      protected function UnstreamizationPerform_UpdateMoneyPenny(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityMoneyPenny = null;
         var _loc7_:THDMoneyPenny = null;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:TActivityMoneyPennyBox = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityMoneyPenny;
         _loc7_ = param3 as THDMoneyPenny;
         _loc6_.MPBoxStatus = _loc7_.BoxStatus;
         _loc6_.MPConditions = _loc7_.BoxConditions;
         _loc6_.AddPercent = _loc7_.Additional;
         _loc5_ = int(_loc8_.AwardStates.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc8_.AwardStates;
            _loc10_ = _loc6_.GetMPByUniqueIndex(_loc9_[_loc4_].BoxIndex);
            _loc10_.Status = _loc9_[_loc4_].State;
            _loc4_++;
         }
         _loc5_ = int(_loc8_.ShowOnlyStates.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc8_.ShowOnlyStates;
            _loc10_ = _loc6_.GetMPByUniqueIndex(_loc9_[_loc4_].BoxIndex);
            _loc10_.Status = _loc9_[_loc4_].State;
            _loc10_.Excharged = _loc9_[_loc4_].Conditions[0];
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateRechargeSuitReturnGold(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityRechargeSuitReturnGold = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:TActivityRSAwardBox = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityRechargeSuitReturnGold;
         _loc8_ = _loc7_.AwardStates;
         _loc9_ = new TActivityRSAwardBox(_loc8_[0].BoxIndex);
         _loc9_.BoxStatus = _loc8_[0].State;
         _loc6_.SetData(_loc9_);
      }
      
      public function UnstreamizeUpdateDailyCost(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateDailyCost(param1,param2);
      }
      
      public function UnstreamizeUpdateDailyPay(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateDailyPay(param1,param2);
      }
      
      public function UnstreamizeUpdateSinglePay(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateSinglePay(param1,param2);
      }
      
      public function UnstreamizeUpdateTotalCost(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateTotalCost(param1,param2);
      }
      
      public function UnstreamizeUpdateTotalPay(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateTotalPay(param1,param2);
      }
      
      public function UnstreamizeUpdateVipBox(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateVipBox(param1,param2);
      }
      
      public function UnstreamizeUpdateFirstPay(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateFirstPay(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateDailyTotalCost(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateDailyTotalCost(param1,param2);
      }
      
      public function UnstreamizeUpdateDailyTotalPay(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateDailyTotalPay(param1,param2);
      }
      
      public function UnstreamizeUpdateMoneyPenny(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateMoneyPenny(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateRechargeSuitReturnGold(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateRechargeSuitReturnGold(param1,param2,param3);
      }
   }
}

