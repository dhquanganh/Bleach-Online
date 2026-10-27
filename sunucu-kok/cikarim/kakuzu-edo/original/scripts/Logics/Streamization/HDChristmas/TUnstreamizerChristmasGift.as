package Logics.Streamization.HDChristmas
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDChristmasGift;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDChristmas.TActivityChristmasGiftData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerChristmasGift extends TUnstreamizer
   {
      
      public function TUnstreamizerChristmasGift()
      {
         super();
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityChristmasGiftData = null;
         var _loc6_:THDChristmasGift = null;
         var _loc7_:TInventories = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityChristmasGiftData;
         _loc6_ = param3 as THDChristmasGift;
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:TActivityInitRetData = null;
         var _loc10_:TActivityChristmasGiftData = null;
         var _loc11_:THDChristmasGift = null;
         var _loc12_:THDBoxStateData = null;
         var _loc13_:Vector.<THDBoxStateData> = null;
         var _loc14_:TInventories = null;
         _loc9_ = param1 as TActivityInitRetData;
         _loc10_ = param2 as TActivityChristmasGiftData;
         _loc11_ = param3 as THDChristmasGift;
         if(_loc9_.AllBox.length <= 0)
         {
            return;
         }
         _loc10_.CurDay = _loc9_.ParameterVec[0];
         if(_loc9_.AllBox.length == 0)
         {
            return;
         }
         _loc5_ = int(_loc9_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = _loc9_.AllBox[_loc4_];
            if(_loc12_.BoxIndex == _loc11_.RechargeAwardIndex)
            {
               _loc10_.RechargeAwardStatus = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc11_.DayAwardIndex)
            {
               _loc10_.DayAwardStatus = _loc12_.State;
            }
            else if(_loc12_.BoxIndex == _loc11_.BuyTimesIndex)
            {
               _loc10_.BuyCount = _loc12_.State;
            }
            else
            {
               _loc7_ = int(_loc11_.BagBuyIndexVec.length);
               _loc8_ = false;
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc11_.BagBuyIndexVec[_loc6_] == _loc12_.BoxIndex)
                  {
                     _loc10_.BagBuyStatusVec[_loc6_] = _loc12_.State;
                     _loc8_ = true;
                     break;
                  }
                  _loc6_++;
               }
               if(!_loc8_)
               {
                  _loc7_ = int(_loc11_.BagGetIndexVec.length);
                  _loc6_ = 0;
                  while(_loc6_ < _loc7_)
                  {
                     if(_loc11_.BagGetIndexVec[_loc6_] == _loc12_.BoxIndex)
                     {
                        _loc10_.BagGetStatusVec[_loc6_] = _loc12_.State;
                        break;
                     }
                     _loc6_++;
                  }
               }
            }
            _loc4_++;
         }
         _loc14_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc11_.RechargeAwardVec[_loc10_.CurDay],_loc14_);
         _loc10_.RechargeInventories = _loc14_;
         _loc14_ = new TInventories();
         SToolReward.GetAwardsByAwardID(_loc11_.DayAwardVec[_loc10_.CurDay],_loc14_);
         _loc10_.DayInventories = _loc14_;
         _loc10_.BagBuyInventoriesVec.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc11_.BagBuyAwardsCount)
         {
            _loc14_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc11_.GetAwardsByType(_loc4_)[_loc10_.CurDay],_loc14_);
            _loc10_.BagBuyInventoriesVec.push(_loc14_);
            _loc4_++;
         }
         _loc10_.BagGetInventoriesVec.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc11_.BagGetAwardVec.length)
         {
            _loc14_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc11_.BagGetAwardVec[_loc4_],_loc14_);
            _loc10_.BagGetInventoriesVec.push(_loc14_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:TActivityChristmasGiftData = null;
         var _loc6_:THDChristmasGift = null;
         var _loc7_:TInventories = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         _loc4_ = param1;
         _loc5_ = param2 as TActivityChristmasGiftData;
         _loc6_ = param3 as THDChristmasGift;
         if(_loc4_.Index == _loc6_.RechargeAwardIndex)
         {
            _loc5_.RechargeAwardStatus = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.DayAwardIndex)
         {
            _loc5_.DayAwardStatus = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.BuyTimesIndex)
         {
            _loc5_.BuyCount = _loc4_.Status;
         }
         else
         {
            _loc9_ = int(_loc6_.BagBuyIndexVec.length);
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc10_ = false;
               if(_loc6_.BagBuyIndexVec[_loc8_] == _loc4_.Index)
               {
                  _loc5_.BagBuyStatusVec[_loc8_] = _loc4_.Status;
                  _loc10_ = true;
                  break;
               }
               _loc8_++;
            }
            if(_loc10_)
            {
               return;
            }
            _loc9_ = int(_loc6_.BagGetIndexVec.length);
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               if(_loc6_.BagGetIndexVec[_loc8_] == _loc4_.Index)
               {
                  _loc5_.BagGetStatusVec[_loc8_] = _loc4_.Status;
                  break;
               }
               _loc8_++;
            }
         }
      }
   }
}

