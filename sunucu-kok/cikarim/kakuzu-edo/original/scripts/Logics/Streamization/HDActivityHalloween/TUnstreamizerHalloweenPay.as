package Logics.Streamization.HDActivityHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDHalloweenPay;
   import Logics.HDActivityHalloween.TActivityHalloweenPayData;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerHalloweenPay extends TUnstreamizer
   {
      
      public function TUnstreamizerHalloweenPay()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateHalloweenPay(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityHalloweenPayData = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDHalloweenPay = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         var _loc12_:Vector.<THDBoxStateData> = null;
         var _loc13_:TInventories = null;
         var _loc14_:Vector.<TFixedAward> = null;
         var _loc15_:TFixedAward = null;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityHalloweenPayData;
         _loc8_ = param3 as THDHalloweenPay;
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc8_.TempArr.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_.FreeAwardsPos[_loc4_] = _loc8_.TempArr[_loc4_].value[0].code;
            _loc4_++;
         }
         _loc16_ = 0;
         while(_loc16_ < _loc8_.FreeAwards.length)
         {
            _loc14_ = new Vector.<TFixedAward>(6);
            _loc4_ = 0;
            while(_loc4_ < 6)
            {
               _loc17_ = new Object();
               _loc13_ = new TInventories();
               _loc17_.type = _loc8_.TempArr[_loc16_ * 6 + _loc4_].value[0].type;
               _loc17_.code = _loc8_.TempArr[_loc16_ * 6 + _loc4_].value[0].code;
               _loc17_.amount = _loc8_.TempArr[_loc16_ * 6 + _loc4_].value[0].amount;
               _loc15_ = new TFixedAward(_loc17_);
               _loc14_[_loc4_] = _loc15_;
               _loc4_++;
            }
            SToolReward.GetInventoriesByFixedAwards(_loc14_,_loc13_);
            _loc8_.FreeAwards[_loc16_] = _loc13_;
            _loc16_++;
         }
         _loc9_ = _loc7_.AwardStates;
         _loc6_.PayBagStatus = _loc9_[0].State;
         _loc6_.RandBagStatus = _loc9_[1].State;
         _loc6_.RevBagNum = _loc7_.ParameterVec[0];
         _loc6_.AllServerBagNum = _loc7_.ParameterVec[1];
         _loc6_.CurDay = _loc7_.ParameterVec[2];
         _loc11_ = _loc7_.BuyStates;
         _loc6_.DayBagStatus = _loc11_[0].State;
         _loc12_ = _loc7_.MailStates;
         _loc5_ = int(_loc12_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.AllServerBagStatus[_loc4_] = _loc12_[_loc4_].State;
            _loc4_++;
         }
         _loc10_ = _loc7_.ShowOnlyStates;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.RevBagStatus[_loc4_] = _loc10_[_loc4_].State;
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitHalloween(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateHalloweenPay(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TActivityHalloweenPayData = null;
         var _loc5_:THDHalloweenPay = null;
         _loc4_ = param2 as TActivityHalloweenPayData;
         _loc5_ = param3 as THDHalloweenPay;
         if(param1.Index == _loc5_.PayIndex)
         {
            _loc4_.PayBagStatus = param1.Status;
         }
         if(param1.Index == _loc5_.GetPayIndex)
         {
            _loc4_.RandBagStatus = param1.Status;
         }
         if(param1.Index == _loc5_.LimitBuyBtnIndex)
         {
            _loc4_.DayBagStatus = param1.Status;
         }
         if(param1.Index == _loc5_.LimitBuyIndex)
         {
            _loc4_.RevBagNum = param1.Status;
         }
         if(param1.Index == _loc5_.ServerLimitIndex)
         {
            _loc4_.AllServerBagNum = param1.Status;
         }
         if(param1.Index >= _loc5_.AllServerBuyIndex[0] && param1.Index <= _loc5_.AllServerBuyIndex[_loc5_.AllServerBuyIndex.length - 1])
         {
            _loc4_.AllServerBagStatus[param1.Index - _loc5_.AllServerBuyIndex[0]] = param1.Status;
         }
         if(param1.Index >= _loc5_.PackageIndex[0] && param1.Index <= _loc5_.PackageIndex[_loc5_.PackageIndex.length - 1])
         {
            _loc4_.RevBagStatus[param1.Index - _loc5_.PackageIndex[0]] = param1.Status;
         }
      }
   }
}

