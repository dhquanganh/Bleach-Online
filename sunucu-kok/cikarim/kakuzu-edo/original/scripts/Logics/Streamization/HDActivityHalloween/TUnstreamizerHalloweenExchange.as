package Logics.Streamization.HDActivityHalloween
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDHalloweenExchange;
   import Logics.HDActivityHalloween.TActivityHalloweenExchangeData;
   import Logics.HDActivityHalloween.THalloweenExchangeGiftVo;
   import Logics.HDActivityHalloween.THalloweenExtractGiftVo;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_ACTIVITYHALLOWEEN;
   
   public class TUnstreamizerHalloweenExchange extends TUnstreamizer
   {
      
      protected const FExtract_Count:int = 20;
      
      public function TUnstreamizerHalloweenExchange()
      {
         super();
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityHalloweenExchangeData = null;
         var _loc6_:THDHalloweenExchange = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THalloweenExtractGiftVo = null;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityHalloweenExchangeData;
         _loc6_ = param3 as THDHalloweenExchange;
         if(_loc4_.AllBox.length == 0)
         {
            return;
         }
         _loc5_.DaysIndex = _loc6_.DaysIndex;
         _loc5_.FreeTimesIndex = _loc6_.FreeTimesIndex;
         _loc5_.ExchangeIndex = _loc6_.ExchangeIndex;
         _loc5_.OpenAllIndex = _loc6_.OpenAllIndex;
         _loc5_.ResetIndex = _loc6_.ResetIndex;
         _loc5_.HeroId = _loc6_.HeroId;
         _loc5_.HeroType = _loc6_.HeroType;
         _loc5_.FightReportAddr = _loc6_.FightReportAddr;
         _loc5_.Discount = _loc6_.Discount;
         _loc5_.ResetGold = _loc6_.ResetGold;
         _loc5_.SingleSpendGold = _loc6_.ExtractCost;
         _loc5_.TipsExtractStr = _loc6_.TipsGridStr;
         _loc5_.TipsButtonStr = _loc6_.TipsBtnStr;
         _loc8_ = this.FExtract_Count;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc9_ = new THalloweenExtractGiftVo();
            _loc5_.ExtractList.push(_loc9_);
            _loc7_++;
         }
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:TActivityHalloweenExchangeData = null;
         var _loc9_:THDHalloweenExchange = null;
         var _loc10_:THalloweenExchangeGiftVo = null;
         var _loc11_:THDBoxStateData = null;
         var _loc12_:Vector.<THDBoxStateData> = null;
         var _loc13_:TInventories = null;
         var _loc14_:int = 0;
         _loc7_ = param1 as TActivityInitRetData;
         _loc8_ = param2 as TActivityHalloweenExchangeData;
         _loc9_ = param3 as THDHalloweenExchange;
         if(_loc7_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc7_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc7_.AllBox[_loc4_];
            if(_loc11_.BoxIndex != _loc9_.DaysIndex)
            {
               if(_loc11_.BoxIndex == _loc9_.FreeTimesIndex)
               {
                  _loc8_.ResidueDegree = _loc9_.FreeTimes - _loc11_.State;
               }
               else if(_loc11_.BoxIndex == _loc9_.ExchangeIndex)
               {
                  _loc8_.TotalExchangeValue = _loc11_.State;
               }
               else if(_loc11_.BoxIndex == _loc9_.RandomIndex)
               {
                  _loc8_.ExtractArrPos = _loc11_.State - 1;
               }
               else if(_loc11_.BoxIndex <= _loc9_.ExchangeIndexList[_loc9_.ExchangeIndexList.length - 1] && _loc11_.BoxIndex >= _loc9_.ExchangeIndexList[0])
               {
                  if(_loc11_.BoxIndex == _loc9_.ExchangeIndexList[_loc9_.ExchangeIndexList.length - 1])
                  {
                     _loc8_.IsHaveHero = _loc11_.State == 0 ? false : true;
                  }
               }
               else
               {
                  if(_loc11_.State == CONST_ACTIVITYHALLOWEEN.HALLOWEEN_ExtractUnfinish)
                  {
                     _loc6_ = true;
                  }
                  else if(_loc11_.State > CONST_ACTIVITYHALLOWEEN.HALLOWEEN_ExtractFinish)
                  {
                     _loc6_ = false;
                  }
                  _loc8_.ExtractList[_loc11_.BoxIndex - 1].IsScanExtract = _loc6_;
                  if(_loc11_.State == 0)
                  {
                     _loc8_.ExtractList[_loc11_.BoxIndex - 1].AwardId = 0;
                     _loc8_.ExtractList[_loc11_.BoxIndex - 1].Inventories = null;
                  }
                  else
                  {
                     _loc8_.ExtractList[_loc11_.BoxIndex - 1].AwardId = _loc9_.ExtractAwardList[_loc8_.ExtractArrPos][_loc11_.State - 1];
                     if(_loc8_.ExtractList[_loc11_.BoxIndex - 1].AwardId == 0)
                     {
                        _loc8_.ExtractList[_loc11_.BoxIndex - 1].Inventories = null;
                     }
                     else
                     {
                        _loc13_ = new TInventories();
                        SToolReward.GetAwardsByAwardID(_loc8_.ExtractList[_loc11_.BoxIndex - 1].AwardId,_loc13_);
                        _loc8_.ExtractList[_loc11_.BoxIndex - 1].Inventories = _loc13_;
                     }
                  }
               }
            }
            _loc4_++;
         }
         _loc8_.ShowInventories.length = 0;
         _loc5_ = int(_loc9_.ShowList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc13_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc9_.ShowList[_loc8_.ExtractArrPos][_loc4_],_loc13_);
            _loc8_.ShowInventories.push(_loc13_);
            _loc4_++;
         }
         _loc8_.DataList.length = 0;
         _loc5_ = int(_loc9_.ExchangeAwardList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = new THalloweenExchangeGiftVo();
            _loc10_.AwardId = _loc9_.ExchangeAwardList[_loc4_];
            _loc10_.CurGiftIndex = _loc9_.ExchangeIndexList[_loc4_];
            _loc10_.ExchangeValue = _loc9_.ExchangeValueList[_loc4_];
            _loc10_.IsScanGetAward = this.SetGetAwardState(_loc10_.ExchangeValue,_loc8_.TotalExchangeValue);
            _loc13_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc9_.ExchangeAwardList[_loc4_],_loc13_);
            _loc10_.Inventories = _loc13_;
            _loc8_.DataList.push(_loc10_);
            _loc4_++;
         }
      }
      
      private function SetGetAwardState(param1:int, param2:int) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 <= param2)
         {
            _loc3_ = true;
         }
         else
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function UnstreamizeInitHalloween(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:THalloweenExchangeGiftVo = null;
         var _loc5_:TActAwardStatusInfo = null;
         var _loc6_:TActivityHalloweenExchangeData = null;
         var _loc7_:THDHalloweenExchange = null;
         var _loc8_:TInventories = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         _loc5_ = param1;
         _loc6_ = param2 as TActivityHalloweenExchangeData;
         _loc7_ = param3 as THDHalloweenExchange;
         if(_loc5_.Index != _loc7_.DaysIndex)
         {
            if(_loc5_.Index == _loc7_.ExchangeIndex)
            {
               _loc6_.TotalExchangeValue = _loc5_.Status;
            }
            else if(_loc5_.Index == _loc7_.FreeTimesIndex)
            {
               _loc6_.ResidueDegree = _loc7_.FreeTimes - _loc5_.Status;
            }
            else if(_loc5_.Index == _loc7_.OpenAllIndex)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc6_.ExtractList.length)
               {
                  _loc6_.ExtractList[_loc9_].IsScanExtract = false;
                  _loc9_++;
               }
            }
            else if(_loc5_.Index == _loc7_.ResetIndex)
            {
               _loc9_ = 0;
               while(_loc9_ < _loc6_.ExtractList.length)
               {
                  _loc6_.ExtractList[_loc9_].IsScanExtract = true;
                  _loc6_.ExtractList[_loc9_].AwardId = 0;
                  _loc6_.ExtractList[_loc9_].Inventories = null;
                  _loc9_++;
               }
            }
            else if(_loc5_.Index == _loc7_.RandomIndex)
            {
               _loc6_.ExtractArrPos = _loc5_.Status - 1;
               _loc10_ = int(_loc6_.ShowInventories.length);
               _loc9_ = 0;
               while(_loc9_ < _loc10_)
               {
                  _loc8_ = new TInventories();
                  SToolReward.GetAwardsByAwardID(_loc7_.ShowList[_loc6_.ExtractArrPos][_loc9_],_loc8_);
                  _loc6_.ShowInventories[_loc9_] = _loc8_;
                  _loc9_++;
               }
            }
            else if(_loc5_.Index <= _loc7_.ExchangeIndexList[_loc7_.ExchangeIndexList.length - 1] && _loc5_.Index >= _loc7_.ExchangeIndexList[0])
            {
               if(_loc5_.Index == _loc7_.ExchangeIndexList[_loc7_.ExchangeIndexList.length - 1])
               {
                  _loc6_.IsHaveHero = _loc5_.Status == 0 ? false : true;
               }
            }
            else
            {
               if(_loc5_.Status == CONST_ACTIVITYHALLOWEEN.HALLOWEEN_ExtractUnfinish)
               {
                  _loc11_ = true;
               }
               else if(_loc5_.Status >= CONST_ACTIVITYHALLOWEEN.HALLOWEEN_ExtractFinish)
               {
                  _loc11_ = false;
               }
               _loc6_.ExtractList[_loc5_.Index - 1].IsScanExtract = _loc11_;
               if(_loc5_.Status == 0)
               {
                  _loc6_.ExtractList[_loc5_.Index - 1].AwardId = 0;
                  _loc6_.ExtractList[_loc5_.Index - 1].Inventories = null;
               }
               else
               {
                  _loc6_.ExtractList[_loc5_.Index - 1].AwardId = _loc7_.ExtractAwardList[_loc6_.ExtractArrPos][_loc5_.Status - 1];
                  if(_loc6_.ExtractList[_loc5_.Index - 1].AwardId == 0)
                  {
                     _loc6_.ExtractList[_loc5_.Index - 1].Inventories = null;
                  }
                  else
                  {
                     _loc8_ = new TInventories();
                     SToolReward.GetAwardsByAwardID(_loc6_.ExtractList[_loc5_.Index - 1].AwardId,_loc8_);
                     _loc6_.ExtractList[_loc5_.Index - 1].Inventories = _loc8_;
                  }
               }
            }
         }
         _loc10_ = int(_loc6_.DataList.length);
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc4_ = _loc6_.DataList[_loc9_];
            _loc4_.IsScanGetAward = this.SetGetAwardState(_loc4_.ExchangeValue,_loc6_.TotalExchangeValue);
            _loc9_++;
         }
      }
   }
}

