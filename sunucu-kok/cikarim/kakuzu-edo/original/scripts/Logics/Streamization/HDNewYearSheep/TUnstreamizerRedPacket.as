package Logics.Streamization.HDNewYearSheep
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDSheepRedPacketConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornGiftVo;
   import Logics.HDNewYearSheep.SendRedPacketVO.TFavornMarketExchangeVo;
   import Logics.HDNewYearSheep.SendRedPacketVO.TPersonAwardVo;
   import Logics.HDNewYearSheep.TActivitySheepRedPacketData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SheepRedPacket;
   
   public class TUnstreamizerRedPacket extends TUnstreamizer
   {
      
      public function TUnstreamizerRedPacket()
      {
         super();
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:TActivitySheepRedPacketData = null;
         var _loc10_:THDSheepRedPacketConfig = null;
         var _loc11_:TInventories = null;
         var _loc12_:TPersonAwardVo = null;
         var _loc13_:TFavornMarketExchangeVo = null;
         var _loc14_:TFavornGiftVo = null;
         var _loc15_:THDBoxStateData = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as TActivitySheepRedPacketData;
         _loc10_ = param3 as THDSheepRedPacketConfig;
         if(_loc8_.ParameterVec.length > 0)
         {
            _loc9_.AllServiceFavornValue = _loc8_.ParameterVec[0];
         }
         if(_loc8_.AllBox.length == 0)
         {
            return;
         }
         _loc9_.ActivityConfig = _loc10_;
         _loc5_ = int(_loc10_.ShowAwardVec.length);
         _loc9_.ShowInventories.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc10_.ShowAwardVec[_loc4_],_loc11_);
            _loc9_.ShowInventories[_loc4_] = _loc11_;
            _loc4_++;
         }
         _loc5_ = int(_loc10_.AllServerIndexVec.length);
         _loc9_.FavornGiftVec.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc14_ = new TFavornGiftVo();
            _loc11_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc10_.AllServerAwardVec[_loc4_],_loc11_);
            _loc14_.Inventories = _loc11_;
            _loc14_.NeedFavornValue = _loc10_.AllServerConditionVec[_loc4_];
            _loc14_.Index = _loc10_.AllServerIndexVec[_loc4_];
            _loc9_.FavornGiftVec[_loc4_] = _loc14_;
            _loc4_++;
         }
         _loc5_ = int(_loc10_.MarketIndexVec.length);
         _loc9_.FavornMarketVec.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc13_ = new TFavornMarketExchangeVo();
            _loc11_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc10_.MarketAwardVec[_loc4_],_loc11_);
            _loc13_.Inventories = _loc11_;
            _loc13_.Index = _loc10_.MarketIndexVec[_loc4_];
            _loc13_.NeedFavornValue = _loc10_.MarketCostVec[_loc4_];
            _loc13_.LimitValue = _loc10_.MarketLimitVec[_loc4_];
            _loc9_.FavornMarketVec[_loc4_] = _loc13_;
            _loc4_++;
         }
         _loc9_.GetAwardPos = CONST_SheepRedPacket.No_Receive_Award;
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc15_ = _loc8_.AllBox[_loc4_];
            if(_loc15_.BoxIndex == _loc10_.MyselfFavoutIndex)
            {
               _loc9_.MyFavornValue = _loc15_.State;
            }
            else if(_loc15_.BoxIndex == _loc10_.ResetFreeIndex)
            {
               _loc9_.FreeResetValue = _loc10_.ResetFreeValue - _loc15_.State;
            }
            else if(_loc15_.BoxIndex == _loc10_.SendFreeIndex)
            {
               _loc9_.FreeSendRedPacketValue = _loc10_.SendFreeValue - _loc15_.State;
            }
            else if(_loc15_.BoxIndex == _loc10_.RandomPropsIndex)
            {
               this.SetRandomProp(_loc15_.Conditions,_loc9_,_loc10_);
            }
            else if(_loc15_.BoxIndex == _loc10_.SendRedPacketIndex)
            {
               _loc7_ = int(_loc15_.Conditions.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc12_ = _loc9_.PersonAwardVec[_loc6_];
                  _loc12_.GetAwardState = _loc15_.Conditions[_loc6_];
                  _loc6_++;
               }
            }
            else if(_loc15_.BoxIndex >= _loc10_.AllServerIndexVec[0] && _loc15_.BoxIndex <= _loc10_.AllServerIndexVec[_loc10_.AllServerIndexVec.length - 1])
            {
               _loc7_ = int(_loc9_.FavornGiftVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc14_ = _loc9_.FavornGiftVec[_loc6_];
                  if(_loc14_.Index == _loc15_.BoxIndex)
                  {
                     _loc14_.GetAwardState = _loc15_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            else if(_loc15_.BoxIndex >= _loc10_.MarketIndexVec[0] && _loc15_.BoxIndex <= _loc10_.MarketIndexVec[_loc10_.MarketIndexVec.length - 1])
            {
               _loc7_ = int(_loc9_.FavornMarketVec.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc13_ = _loc9_.FavornMarketVec[_loc6_];
                  if(_loc13_.Index == _loc15_.BoxIndex)
                  {
                     _loc13_.BuyCount = _loc15_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            _loc4_++;
         }
      }
      
      private function SetRandomProp(param1:Vector.<int>, param2:TActivitySheepRedPacketData, param3:THDSheepRedPacketConfig) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPersonAwardVo = null;
         var _loc7_:TInventories = null;
         _loc5_ = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TPersonAwardVo();
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(param3.AllPropsVec[param1[_loc4_]],_loc7_);
            _loc6_.Inventories = _loc7_;
            _loc6_.GetAwardState = 0;
            param2.PersonAwardVec[_loc4_] = _loc6_;
            _loc4_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivitySheepRedPacketData = null;
         var _loc7_:THDSheepRedPacketConfig = null;
         var _loc8_:TActAwardStatusInfo = null;
         var _loc9_:TPersonAwardVo = null;
         var _loc10_:TFavornMarketExchangeVo = null;
         var _loc11_:TFavornGiftVo = null;
         _loc8_ = param1 as TActAwardStatusInfo;
         _loc6_ = param2 as TActivitySheepRedPacketData;
         _loc7_ = param3 as THDSheepRedPacketConfig;
         if(_loc8_.Index == _loc7_.SendRedPacketIndex)
         {
            _loc9_ = _loc6_.PersonAwardVec[_loc8_.Status];
            _loc6_.GetAwardPos = _loc8_.Status;
            _loc9_.GetAwardState = CONST_SheepRedPacket.Activity_AlreadyReceive;
         }
         else if(_loc8_.Index == _loc7_.AllServiceIndex)
         {
            _loc6_.AllServiceFavornValue = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc7_.MyselfFavoutIndex)
         {
            _loc6_.MyFavornValue = _loc8_.Status;
         }
         else if(_loc8_.Index == _loc7_.RandomPropsIndex)
         {
            this.SetRandomProp(_loc8_.Condition,_loc6_,_loc7_);
         }
         else if(_loc8_.Index == _loc7_.ResetFreeIndex)
         {
            _loc6_.FreeResetValue = _loc7_.ResetFreeValue - _loc8_.Status;
         }
         else if(_loc8_.Index == _loc7_.SendFreeIndex)
         {
            _loc6_.FreeSendRedPacketValue = _loc7_.SendFreeValue - _loc8_.Status;
         }
         else if(_loc8_.Index >= _loc7_.AllServerIndexVec[0] && _loc8_.Index <= _loc7_.AllServerIndexVec[_loc7_.AllServerIndexVec.length - 1])
         {
            _loc4_ = int(_loc6_.FavornGiftVec.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc11_ = _loc6_.FavornGiftVec[_loc5_];
               if(_loc11_.Index == _loc8_.Index)
               {
                  _loc11_.GetAwardState = _loc8_.Status;
                  break;
               }
               _loc5_++;
            }
         }
         else if(_loc8_.Index >= _loc7_.MarketIndexVec[0] && _loc8_.Index <= _loc7_.MarketIndexVec[_loc7_.MarketIndexVec.length - 1])
         {
            _loc4_ = int(_loc6_.FavornMarketVec.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc10_ = _loc6_.FavornMarketVec[_loc5_];
               if(_loc10_.Index == _loc8_.Index)
               {
                  _loc10_.BuyCount = _loc8_.Status;
                  break;
               }
               _loc5_++;
            }
         }
      }
   }
}

