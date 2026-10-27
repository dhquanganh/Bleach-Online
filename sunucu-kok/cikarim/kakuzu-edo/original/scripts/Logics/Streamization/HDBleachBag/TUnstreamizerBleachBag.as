package Logics.Streamization.HDBleachBag
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDBleachBagConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDBleachBag.TBleachTaskVo;
   import Logics.HDBleachBag.TCostGiftVo;
   import Logics.HDBleachBag.THDBleachBagData;
   import Logics.HDBleachBag.TRechargeGiftVo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerBleachBag extends TUnstreamizer
   {
      
      public function TUnstreamizerBleachBag()
      {
         super();
      }
      
      private function RefreshData(param1:int, param2:int, param3:THDBleachBagData) : void
      {
         var _loc4_:TRechargeGiftVo = null;
         var _loc5_:TCostGiftVo = null;
         var _loc6_:TBleachTaskVo = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 == param3.ActivityConfig.PerDayFreeIndex)
         {
            param3.CurFreeAwardState = param2;
         }
         _loc8_ = int(param3.RechargeGifts.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            for each(_loc4_ in param3.RechargeGifts[_loc7_])
            {
               _loc9_ = param3.RechargeGifts[_loc7_].indexOf(_loc4_);
               if(_loc4_.Index == param1 && _loc9_ == param3.ActivityDay)
               {
                  _loc4_.GiftState = param2;
                  break;
               }
            }
            _loc7_++;
         }
         _loc8_ = int(param3.CostGifts.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            for each(_loc5_ in param3.CostGifts[_loc7_])
            {
               _loc9_ = param3.CostGifts[_loc7_].indexOf(_loc5_);
               if(_loc5_.Index == param1 && _loc9_ == param3.ActivityDay)
               {
                  _loc5_.State = param2;
               }
            }
            _loc7_++;
         }
         _loc8_ = int(param3.TaskAwards.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            for each(_loc6_ in param3.TaskAwards[_loc7_])
            {
               _loc9_ = param3.TaskAwards[_loc7_].indexOf(_loc6_);
               if(_loc6_.Index == param1 && _loc9_ == param3.ActivityDay)
               {
                  _loc6_.GetAwardState = param2;
               }
            }
            _loc7_++;
         }
         if(param1 == param3.ActivityConfig.FinalAwardIndex)
         {
            param3.FinalAwardState = param2;
         }
      }
      
      private function InitActivityData(param1:THDBleachBagData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         var _loc7_:TRechargeGiftVo = null;
         var _loc8_:Vector.<TRechargeGiftVo> = null;
         var _loc9_:TCostGiftVo = null;
         var _loc10_:Vector.<TCostGiftVo> = null;
         var _loc11_:TBleachTaskVo = null;
         var _loc12_:Vector.<TBleachTaskVo> = null;
         if(param1.Inited)
         {
            return;
         }
         _loc3_ = int(param1.ActivityConfig.EveryDayFreeAwardVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(param1.ActivityConfig.EveryDayFreeAwardVec[_loc2_],_loc6_);
            param1.FreeAwards[_loc2_] = _loc6_;
            _loc2_++;
         }
         _loc3_ = int(param1.ActivityConfig.EvenyDayRechargeIndexVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new Vector.<TRechargeGiftVo>();
            _loc5_ = int(param1.ActivityConfig.EveryDayConditionVec[_loc2_].length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_ = new TRechargeGiftVo();
               _loc6_ = new TInventories();
               _loc7_.Index = param1.ActivityConfig.EvenyDayRechargeIndexVec[_loc2_];
               _loc7_.Condition = param1.ActivityConfig.EveryDayConditionVec[_loc2_][_loc4_];
               SToolReward.GetAwardsByAwardID(param1.ActivityConfig.EveryDayRechargeAwardVec[_loc2_][_loc4_],_loc6_);
               _loc7_.Inventories = _loc6_;
               _loc8_[_loc4_] = _loc7_;
               _loc4_++;
            }
            param1.RechargeGifts[_loc2_] = _loc8_;
            _loc2_++;
         }
         _loc3_ = int(param1.ActivityConfig.BuyIndexVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new Vector.<TCostGiftVo>();
            _loc5_ = int(param1.ActivityConfig.BuyAwardVec[_loc2_].length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_ = new TCostGiftVo();
               _loc6_ = new TInventories();
               _loc9_.Condition = param1.ActivityConfig.BuyCostVec[_loc2_][_loc4_];
               _loc9_.Index = param1.ActivityConfig.BuyIndexVec[_loc2_];
               SToolReward.GetAwardsByAwardID(param1.ActivityConfig.BuyAwardVec[_loc2_][_loc4_],_loc6_);
               _loc9_.Inventories = _loc6_;
               _loc10_[_loc4_] = _loc9_;
               _loc4_++;
            }
            param1.CostGifts[_loc2_] = _loc10_;
            _loc2_++;
         }
         _loc3_ = int(param1.ActivityConfig.TaskIndexVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc12_ = new Vector.<TBleachTaskVo>();
            _loc5_ = int(param1.ActivityConfig.TaskAward[_loc2_].length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc11_ = new TBleachTaskVo();
               _loc6_ = new TInventories();
               _loc11_.Index = param1.ActivityConfig.TaskIndexVec[_loc2_];
               SToolReward.GetAwardsByAwardID(param1.ActivityConfig.TaskAward[_loc2_][_loc4_],_loc6_);
               _loc11_.Inventories = _loc6_;
               if(param1.ActivityConfig.TaskTypeVec[_loc2_] == 1)
               {
                  _loc11_.Desc = TUtilityString.Format(param1.ActivityConfig.Desc0,param1.ActivityConfig.TaskConditionVec[_loc2_]);
               }
               else
               {
                  _loc11_.Desc = TUtilityString.Format(param1.ActivityConfig.Desc1,param1.ActivityConfig.TaskConditionVec[_loc2_]);
               }
               _loc12_[_loc4_] = _loc11_;
               _loc4_++;
            }
            param1.TaskAwards[_loc2_] = _loc12_;
            _loc2_++;
         }
         param1.Inited = true;
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:THDBleachBagData = null;
         var _loc6_:THDBleachBagConfig = null;
         var _loc7_:THDBoxStateData = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as THDBleachBagData;
         _loc6_ = param3 as THDBleachBagConfig;
         _loc5_.ActivityConfig = _loc6_;
         this.InitActivityData(_loc5_);
         _loc5_.ActivityDay = _loc4_.ParameterVec[0];
         _loc9_ = int(_loc4_.AllBox.length);
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc7_ = _loc4_.AllBox[_loc8_];
            this.RefreshData(_loc7_.BoxIndex,_loc7_.State,_loc5_);
            _loc8_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THDBleachBagData = null;
         _loc4_ = param2 as THDBleachBagData;
         this.RefreshData(param1.Index,param1.Status,_loc4_);
      }
   }
}

