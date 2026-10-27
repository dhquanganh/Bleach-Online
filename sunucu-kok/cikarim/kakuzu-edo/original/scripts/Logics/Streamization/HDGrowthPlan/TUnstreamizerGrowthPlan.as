package Logics.Streamization.HDGrowthPlan
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDGrowthPlanConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDGrowthPlan.TActivityGrowthPlanData;
   import Logics.HDGrowthPlan.VO.TLevelGrowPlanVO;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_GROWTHPLAN;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerGrowthPlan extends TUnstreamizer
   {
      
      public function TUnstreamizerGrowthPlan()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGrowthPlanData = null;
         var _loc5_:THDGrowthPlanConfig = null;
         var _loc6_:TLevelGrowPlanVO = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TActivityGrowthPlanData;
         _loc5_ = param3 as THDGrowthPlanConfig;
         _loc4_.ActivityConfig = _loc5_;
         _loc8_ = int(_loc5_.AwardIndexVec.length);
         _loc4_.GrowPlanVec.length = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TLevelGrowPlanVO();
            _loc6_.GetAwardState = 0;
            _loc6_.Gold = _loc5_.AwardGoldVec[_loc7_];
            _loc6_.Level = _loc5_.AwardLevelVec[_loc7_];
            _loc6_.Index = _loc5_.AwardIndexVec[_loc7_];
            _loc4_.GrowPlanVec[_loc7_] = _loc6_;
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGrowthPlanData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:THDGrowthPlanConfig = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityGrowthPlanData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc6_ = _loc4_.ActivityConfig;
         _loc8_ = int(_loc5_.AllBox.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = _loc5_.AllBox[_loc7_];
            this.SetData(_loc9_.BoxIndex,_loc9_.State,_loc4_);
            _loc7_++;
         }
      }
      
      private function SetData(param1:int, param2:int, param3:TActivityGrowthPlanData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TLevelGrowPlanVO = null;
         _loc5_ = int(param3.GrowPlanVec.length);
         if(param1 == param3.ActivityConfig.BuyIndex)
         {
            param3.BuyGrowthPlanState = param2;
         }
         else if(param1 == param3.ActivityConfig.TotalRechargeIndex)
         {
            param3.RechargeGoldValue = param2;
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = param3.GrowPlanVec[_loc4_];
               if(param1 == _loc6_.Index)
               {
                  _loc6_.GetAwardState = param2;
                  break;
               }
               _loc4_++;
            }
         }
         this.JudgeGetAwradState(param3);
         param3.IsFinishAllTask = this.GetFinshTaskBol(param3);
      }
      
      private function GetFinshTaskBol(param1:TActivityGrowthPlanData) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         _loc4_ = true;
         _loc3_ = int(param1.GrowPlanVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.GrowPlanVec[_loc2_].GetAwardState == CONST_GROWTHPLAN.Activity_AlreadyFinish)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
            _loc4_ &&= _loc5_;
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function FillBoxState(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityGrowthPlanData = null;
         var _loc5_:THDGrowthPlanConfig = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActAwardStatusInfo = null;
         _loc8_ = param1;
         _loc4_ = param2 as TActivityGrowthPlanData;
         _loc5_ = param3 as THDGrowthPlanConfig;
         this.SetData(_loc8_.Index,_loc8_.Status,_loc4_);
      }
      
      public function JudgeGetAwradState(param1:TActivityGrowthPlanData) : void
      {
         var _loc2_:TLevelGrowPlanVO = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc4_ = param1.BuyGrowthPlanState == CONST_GROWTHPLAN.Activity_AlreadyFinish;
         _loc3_ = int(SLogicsCore.Character.Heros.GetHeroByIndex(0).Level);
         if(_loc4_)
         {
            for each(_loc2_ in param1.GrowPlanVec)
            {
               if(_loc2_.GetAwardState != CONST_GROWTHPLAN.Activity_AlreadyFinish && _loc3_ >= _loc2_.Level)
               {
                  _loc2_.GetAwardState = CONST_GROWTHPLAN.Activity_ScanOperate;
               }
            }
         }
      }
   }
}

