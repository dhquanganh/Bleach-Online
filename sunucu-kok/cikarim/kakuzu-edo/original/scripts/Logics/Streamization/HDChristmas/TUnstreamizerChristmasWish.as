package Logics.Streamization.HDChristmas
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDChristmasWish;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDChristmas.TActivityChristmasWishData;
   import Logics.HDChristmas.VO.TBellExchangeVo;
   import Logics.HDChristmas.VO.TBellVo;
   import Logics.HDChristmas.VO.TRankAwardVo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_CHRISTMAS;
   
   public class TUnstreamizerChristmasWish extends TUnstreamizer
   {
      
      public static const Task_Finish:int = 1;
      
      public static const Task_UnFinish:int = 0;
      
      public function TUnstreamizerChristmasWish()
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
         var _loc5_:TActivityChristmasWishData = null;
         var _loc6_:THDChristmasWish = null;
         var _loc7_:TInventories = null;
         var _loc8_:TBellVo = null;
         var _loc9_:TBellExchangeVo = null;
         var _loc10_:TRankAwardVo = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:TFixedAward = null;
         var _loc14_:Vector.<TFixedAward> = null;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityChristmasWishData;
         _loc6_ = param3 as THDChristmasWish;
         if(_loc4_.AllBox.length == 0)
         {
            return;
         }
         _loc5_.ActivityConfig = _loc6_;
         _loc5_.ExtractInventories.length = 0;
         _loc12_ = int(_loc6_.TurntableAwardVec.length);
         _loc11_ = 0;
         while(_loc11_ < _loc12_)
         {
            _loc7_ = new TInventories();
            if(_loc6_.TurntableAwardVec[_loc11_] == 0)
            {
               _loc13_ = new TFixedAward(_loc6_.CardTypeCodeObj);
               _loc14_ = new Vector.<TFixedAward>();
               _loc14_[0] = _loc13_;
               SToolReward.GetInventoriesByFixedAwards(_loc14_,_loc7_);
            }
            else
            {
               SToolReward.GetAwardsByAwardID(_loc6_.TurntableAwardVec[_loc11_],_loc7_);
            }
            _loc5_.ExtractInventories[_loc11_] = _loc7_;
            _loc11_++;
         }
         _loc12_ = int(_loc6_.AllServerAwardVec.length);
         _loc5_.BellAwardList.length = 0;
         _loc11_ = 0;
         while(_loc11_ < _loc12_)
         {
            _loc8_ = new TBellVo();
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.AllServerAwardVec[_loc11_],_loc7_);
            _loc8_.Inventories = _loc7_;
            _loc8_.GetAwardState = CONST_CHRISTMAS.UnFinish;
            _loc8_.NeedBellValue = _loc6_.AllServerConditionVec[_loc11_];
            _loc5_.BellAwardList[_loc11_] = _loc8_;
            _loc11_++;
         }
         _loc12_ = int(_loc6_.MarketAwardVec.length);
         _loc11_ = 0;
         while(_loc11_ < _loc12_)
         {
            _loc9_ = new TBellExchangeVo();
            _loc9_.Index = _loc6_.MarketIndexVec[_loc11_];
            _loc9_.LimitValue = _loc6_.MarketLimitVec[_loc11_];
            _loc9_.NeedBellValue = _loc6_.MarketCostVec[_loc11_];
            _loc7_ = new TInventories();
            if(_loc6_.MarketAwardVec[_loc11_] != 0)
            {
               SToolReward.GetAwardsByAwardID(_loc6_.MarketAwardVec[_loc11_],_loc7_);
            }
            else
            {
               _loc13_ = new TFixedAward(_loc6_.CardTypeCodeObj);
               _loc14_ = new Vector.<TFixedAward>();
               _loc14_[0] = _loc13_;
               SToolReward.GetInventoriesByFixedAwards(_loc14_,_loc7_);
            }
            _loc9_.Inventories = _loc7_;
            _loc5_.ExchangeList[_loc11_] = _loc9_;
            _loc11_++;
         }
         _loc12_ = int(_loc6_.RankAwardsVec.length);
         _loc11_ = 0;
         while(_loc11_ < _loc12_)
         {
            _loc10_ = new TRankAwardVo();
            _loc10_.RankInfo = _loc6_.RankPromptVec[_loc11_];
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.RankAwardsVec[_loc11_],_loc7_);
            _loc10_.Inventories = _loc7_;
            _loc5_.RankAwardList[_loc11_] = _loc10_;
            _loc11_++;
         }
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:TActivityChristmasWishData = null;
         var _loc9_:THDChristmasWish = null;
         var _loc10_:THDBoxStateData = null;
         var _loc11_:TBellVo = null;
         var _loc12_:Vector.<THDBoxStateData> = null;
         var _loc13_:TInventories = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc8_ = param2 as TActivityChristmasWishData;
         _loc9_ = param3 as THDChristmasWish;
         if(_loc7_.AddtionalVecs.length > 0)
         {
            _loc8_.SetBellRankData(_loc7_.AddtionalVecs);
         }
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc7_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc7_.AllBox[_loc4_];
            if(_loc10_.BoxIndex == _loc9_.ExchangeBellIdex)
            {
               _loc8_.ExchangeBellValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc9_.TotalBellIndex)
            {
               _loc8_.TotalBellValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc9_.FreeValueIndex)
            {
               _loc8_.FreeWishValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex == _loc9_.AllServerBellIndex)
            {
               _loc8_.AllServerBellValue = _loc10_.State;
            }
            else if(_loc10_.BoxIndex >= _loc9_.AllServerIndexVec[0] && _loc10_.BoxIndex <= _loc9_.AllServerIndexVec[_loc9_.AllServerIndexVec.length - 1])
            {
               _loc6_ = _loc9_.AllServerIndexVec.indexOf(_loc10_.BoxIndex);
               _loc8_.BellAwardList[_loc6_].GetAwardState = _loc10_.State;
            }
            else if(_loc10_.BoxIndex >= _loc8_.ExchangeList[0].Index && _loc10_.BoxIndex <= _loc8_.ExchangeList[_loc8_.ExchangeList.length - 1].Index)
            {
               _loc6_ = _loc9_.MarketIndexVec.indexOf(_loc10_.BoxIndex);
               _loc8_.ExchangeList[_loc6_].BuyCount = _loc10_.State;
            }
            _loc4_++;
         }
         _loc5_ = int(_loc9_.AllServerIndexVec.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc8_.BellAwardList[_loc4_];
            if(_loc11_.GetAwardState == CONST_CHRISTMAS.UnFinish)
            {
               _loc11_.GetAwardState = _loc8_.AllServerBellValue >= _loc11_.NeedBellValue ? CONST_CHRISTMAS.ScanGetState : CONST_CHRISTMAS.UnFinish;
            }
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:TActivityChristmasWishData = null;
         var _loc6_:THDChristmasWish = null;
         var _loc7_:int = 0;
         var _loc8_:TInventories = null;
         var _loc9_:TBellVo = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc4_ = param1;
         _loc5_ = param2 as TActivityChristmasWishData;
         _loc6_ = param3 as THDChristmasWish;
         if(_loc4_.Index == _loc6_.ExchangeBellIdex)
         {
            _loc5_.ExchangeBellValue = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.TotalBellIndex)
         {
            _loc5_.TotalBellValue = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.FreeValueIndex)
         {
            _loc5_.FreeWishValue = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.AllServerBellIndex)
         {
            _loc5_.AllServerBellValue = _loc4_.Status;
         }
         else if(_loc4_.Index >= _loc6_.AllServerIndexVec[0] && _loc4_.Index <= _loc6_.AllServerIndexVec[_loc6_.AllServerIndexVec.length - 1])
         {
            _loc7_ = _loc6_.AllServerIndexVec.indexOf(_loc4_.Index);
            _loc5_.BellAwardList[_loc7_].GetAwardState = _loc4_.Status;
         }
         else if(_loc4_.Index >= _loc5_.ExchangeList[0].Index && _loc4_.Index <= _loc5_.ExchangeList[_loc5_.ExchangeList.length - 1].Index)
         {
            _loc7_ = _loc6_.MarketIndexVec.indexOf(_loc4_.Index);
            _loc5_.ExchangeList[_loc7_].BuyCount = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.OneKeyIndex)
         {
            _loc5_.TurntablePos = _loc4_.Status;
         }
         _loc11_ = int(_loc6_.AllServerIndexVec.length);
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc9_ = _loc5_.BellAwardList[_loc10_];
            if(_loc9_.GetAwardState == CONST_CHRISTMAS.UnFinish)
            {
               _loc9_.GetAwardState = _loc5_.AllServerBellValue >= _loc9_.NeedBellValue ? CONST_CHRISTMAS.ScanGetState : CONST_CHRISTMAS.UnFinish;
            }
            _loc10_++;
         }
      }
   }
}

