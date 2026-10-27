package Logics.Streamization.HDActivityNewHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDNewHalloweenRecharge;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewHalloween.THDNewHalloweenRechargeData;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornMarketExchangeVo;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityNewHalloween.RechargeVo.TRechargeGiftVo;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NewHalloween;
   
   public class TUnstreamizerNewHalloweenRecharge extends TUnstreamizer
   {
      
      public function TUnstreamizerNewHalloweenRecharge()
      {
         super();
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THDNewHalloweenRechargeData = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDNewHalloweenRecharge = null;
         var _loc9_:THDBoxStateData = null;
         var _loc10_:TInventories = null;
         var _loc11_:TRechargeGiftVo = null;
         var _loc12_:TFavornMarketExchangeVo = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as THDNewHalloweenRechargeData;
         _loc8_ = param3 as THDNewHalloweenRecharge;
         _loc5_ = int(_loc8_.EveryDayGiftIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new TInventories();
            _loc11_ = new TRechargeGiftVo();
            _loc11_.Index = _loc8_.EveryDayGiftIndexVec[_loc4_];
            _loc11_.Condition = _loc8_.EveryDayGiftConditionVec[_loc4_];
            _loc11_.State = CONST_NewHalloween.UnFinish;
            SToolReward.GetAwardsByAwardID(_loc8_.EveryDayGiftAwardVec[_loc4_],_loc10_);
            _loc11_.Inventories = _loc10_;
            _loc6_.EveryDayAwardVec[_loc4_] = _loc11_;
            _loc4_++;
         }
         _loc5_ = int(_loc8_.TotalGoldGiftIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new TInventories();
            _loc11_ = new TRechargeGiftVo();
            _loc11_.Index = _loc8_.TotalGoldGiftIndexVec[_loc4_];
            _loc11_.Condition = _loc8_.TotalGoldGiftConditionVec[_loc4_];
            _loc11_.State = CONST_NewHalloween.UnFinish;
            SToolReward.GetAwardsByAwardID(_loc8_.TotalGoldGiftAwardVec[_loc4_],_loc10_);
            _loc11_.Inventories = _loc10_;
            _loc6_.GoldAwardVec[_loc4_] = _loc11_;
            _loc4_++;
         }
         _loc5_ = int(_loc8_.ScoreMallIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = new TFavornMarketExchangeVo();
            _loc10_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc8_.ScoreMallAwardVec[_loc4_],_loc10_);
            _loc12_.Inventories = _loc10_;
            _loc12_.Index = _loc8_.ScoreMallIndexVec[_loc4_];
            _loc12_.NeedFavornValue = _loc8_.ScoreMallCostScoreVec[_loc4_];
            _loc12_.LimitValue = _loc8_.ScoreMallLimitVec[_loc4_];
            _loc6_.ScoreMallVoVec[_loc4_] = _loc12_;
            _loc4_++;
         }
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc6_.ActivityConfig = _loc8_;
         _loc5_ = int(_loc7_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = _loc7_.AllBox[_loc4_];
            this.SetData(_loc9_.BoxIndex,_loc9_.State,_loc6_);
            _loc4_++;
         }
      }
      
      private function SetData(param1:int, param2:int, param3:THDNewHalloweenRechargeData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRechargeGiftVo = null;
         var _loc7_:TFavornMarketExchangeVo = null;
         if(param3.ActivityConfig.ScoreIndex == param1)
         {
            param3.Score = param2;
         }
         else if(param3.ActivityConfig.DayRechargeIndex == param1)
         {
            param3.CurDayGold = param2;
         }
         else if(param3.ActivityConfig.TotalRechargeIndex == param1)
         {
            param3.TotalGold = param2;
         }
         _loc5_ = int(param3.EveryDayAwardVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.EveryDayAwardVec[_loc4_];
            if(_loc6_.Index == param1)
            {
               _loc6_.State = param2;
               break;
            }
            _loc4_++;
         }
         _loc5_ = int(param3.GoldAwardVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param3.GoldAwardVec[_loc4_];
            if(_loc6_.Index == param1)
            {
               _loc6_.State = param2;
               break;
            }
            _loc4_++;
         }
         _loc5_ = int(param3.ScoreMallVoVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param3.ScoreMallVoVec[_loc4_];
            if(_loc7_.Index == param1)
            {
               _loc7_.BuyCount = param2;
               break;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THDNewHalloweenRechargeData = null;
         var _loc5_:THDNewHalloweenRecharge = null;
         var _loc6_:TActAwardStatusInfo = null;
         _loc6_ = param1 as TActAwardStatusInfo;
         _loc4_ = param2 as THDNewHalloweenRechargeData;
         _loc5_ = param3 as THDNewHalloweenRecharge;
         this.SetData(_loc6_.Index,_loc6_.Status,_loc4_);
      }
   }
}

