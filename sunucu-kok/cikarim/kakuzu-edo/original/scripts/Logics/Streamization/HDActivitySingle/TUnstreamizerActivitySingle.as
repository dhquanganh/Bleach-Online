package Logics.Streamization.HDActivitySingle
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActVipBoxAward;
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   import Logics.DatebaseVO.VO.Json.TXmasAward;
   import Logics.DatebaseVO.VO.THDActivityEspada;
   import Logics.DatebaseVO.VO.THDActivityLimitBuy;
   import Logics.DatebaseVO.VO.THDChristmas;
   import Logics.DatebaseVO.VO.THDExchangeChip;
   import Logics.DatebaseVO.VO.THDGambling;
   import Logics.DatebaseVO.VO.THDIceHeros;
   import Logics.DatebaseVO.VO.THDRandCard;
   import Logics.DatebaseVO.VO.THDServerPay;
   import Logics.DatebaseVO.VO.THDTeamBuy;
   import Logics.DatebaseVO.VO.THDVipBox;
   import Logics.HDActivityEquipmentShop.TActivitySingleEquipementShop;
   import Logics.HDActivityGambling.TActivityGambling;
   import Logics.HDActivityLimitBuy.TActivityLimitBuy;
   import Logics.HDActivityLimitBuy.TActivityLimitBuyItem;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivitySingle.TActivitySingleEspada;
   import Logics.HDActivitySingle.TActivitySingleSuperTreasure;
   import Logics.HDActivitySingle.TActivitySingleValentinesDay;
   import Logics.HDActivitySingle.TNewYearEggData;
   import Logics.HDActivitySingle.TStatusInfo;
   import Logics.HDIceHeros.TActivityIHAward;
   import Logics.HDIceHeros.TActivityIHChipBox;
   import Logics.HDIceHeros.TActivityIceHeros;
   import Logics.HDRandCard.TActivityRCStageData;
   import Logics.HDRandCard.TActivityRandCard;
   import Logics.HDServerPay.TActivityServerPay;
   import Logics.HDTeamBuy.TActivityTBBox;
   import Logics.HDTeamBuy.TActivityTeamBuy;
   import Logics.HDXmas.THDXmasData;
   import Logics.HDXmas.TXmasAwardData;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivitySingle extends TUnstreamizer
   {
      
      public function TUnstreamizerActivitySingle()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateSuperTreasure(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivitySingleSuperTreasure = null;
         var _loc6_:TActivityInitRetData = null;
         var _loc7_:TStatusInfo = null;
         _loc5_ = param1 as TActivitySingleSuperTreasure;
         _loc6_ = param2 as TActivityInitRetData;
         _loc5_.Page3BuyedCount = _loc6_.ParameterVec;
         _loc4_ = int(_loc6_.BuyStates.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = new TStatusInfo();
            _loc7_.Index = _loc6_.BuyStates[_loc3_].BoxIndex;
            _loc7_.Count = _loc6_.BuyStates[_loc3_].State;
            _loc5_.StatusInfos.Add(_loc7_);
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateXmas(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THDXmasData = null;
         var _loc5_:THDChristmas = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TXmasAwardData = null;
         _loc4_ = param2 as THDXmasData;
         _loc5_ = param3 as THDChristmas;
         _loc6_ = param1.readUnsignedInt();
         _loc4_.DailFreeTimes = _loc5_.FreeTimes - _loc6_;
         _loc4_.IndexCanGet = param1.readUnsignedInt();
         _loc8_ = param1.readUnsignedInt();
         _loc6_ = uint(param1.readShort());
         _loc4_.CollectNumList.length = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_.CollectNumList.push(param1.readUnsignedInt());
            _loc7_++;
         }
         _loc4_.ClearAward();
         _loc6_ = _loc5_.AwardList.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc9_ = new TXmasAwardData();
            if(_loc7_ < _loc8_)
            {
               _loc9_.State = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            }
            else if(_loc7_ == _loc8_)
            {
               _loc9_.State = this.CheckNum(_loc7_,_loc5_,_loc4_);
            }
            else
            {
               _loc9_.State = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc9_.InventoryId = _loc5_.AwardList[_loc7_].AwardId[0];
            _loc4_.AddAward(_loc9_);
            _loc7_++;
         }
      }
      
      private function CheckNum(param1:uint, param2:THDChristmas, param3:THDXmasData) : int
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TXmasAward = null;
         var _loc7_:uint = 0;
         _loc5_ = param2.AwardList[param1].ConditionList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3.CollectNumList[_loc4_] >= param2.AwardList[param1].ConditionList[_loc4_])
            {
               _loc7_++;
            }
            _loc4_++;
         }
         if(_loc7_ == param2.AwardList[param1].ConditionList.length)
         {
            return CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         return CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      }
      
      protected function UnstreamizationPerform_UpdateNewYearEgg(param1:Object, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TNewYearEggData = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:TActivityInitRetData = null;
         _loc5_ = param1 as TNewYearEggData;
         _loc7_ = param2 as TActivityInitRetData;
         _loc7_.AllBoxSortByIndex();
         _loc4_ = _loc7_.AllBox.length;
         _loc6_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_[_loc3_] = _loc7_.AllBox[_loc3_].State;
            _loc3_++;
         }
         _loc5_.BoxStatus = _loc6_;
      }
      
      protected function UnstreamizationPerform_UpdateEspada(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivitySingleEspada = null;
         var _loc7_:THDActivityEspada = null;
         var _loc8_:Vector.<int> = null;
         var _loc9_:Vector.<int> = null;
         var _loc10_:int = 0;
         var _loc11_:TActivityInitRetData = null;
         _loc6_ = param2 as TActivitySingleEspada;
         _loc7_ = param3 as THDActivityEspada;
         _loc11_ = param1 as TActivityInitRetData;
         _loc10_ = -1;
         _loc6_.TotalPay = _loc11_.ParameterVec[0];
         _loc5_ = int(_loc11_.AwardStates.length);
         _loc8_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc8_[_loc4_] = _loc11_.AwardStates[_loc4_].State;
            _loc4_++;
         }
         _loc6_.AwardStatus = _loc8_;
         _loc5_ = int(_loc11_.BuyStates.length);
         _loc9_ = new Vector.<int>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_[_loc4_] = _loc11_.BuyStates[_loc4_].State;
            _loc4_++;
         }
         _loc6_.BuyStatus = _loc9_;
         _loc5_ = int(_loc7_.Awards.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc6_.TotalPay < _loc7_.AwardsConditions[_loc4_].Key)
            {
               break;
            }
            _loc10_ = _loc4_;
            _loc4_++;
         }
         _loc6_.CurIndex = _loc10_;
      }
      
      protected function UnstreamizationPerform_UpdateEquipmentShop(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivitySingleEquipementShop = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDExchangeChip = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivitySingleEquipementShop;
         _loc8_ = param3 as THDExchangeChip;
         _loc6_.ChipVect = _loc8_.ChipVect;
         _loc6_.BuyBoxVect = _loc8_.BuyBoxVect;
         _loc6_.FreeDrawVect = _loc8_.FreeDrawVect;
         _loc6_.ExchangeVect = _loc8_.ExchangeVect;
         _loc9_ = _loc7_.BuyStates;
         this.SetSingleEquipmentStatus(_loc9_,_loc6_);
         _loc9_ = _loc7_.AwardStates;
         this.SetSingleEquipmentStatus(_loc9_,_loc6_);
         _loc9_ = _loc7_.ShowOnlyStates;
         this.SetSingleEquipmentStatus(_loc9_,_loc6_);
      }
      
      protected function SetSingleEquipmentStatus(param1:Vector.<THDBoxStateData>, param2:TActivitySingleEquipementShop) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2.SetStatus(param1[_loc3_].BoxIndex,param1[_loc3_].State);
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateValentinesDay(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivitySingleValentinesDay = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDVipBox = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<TActVipBoxAward> = null;
         var _loc11_:Vector.<TActVipBoxAward> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivitySingleValentinesDay;
         _loc8_ = param3 as THDVipBox;
         _loc5_ = int(_loc8_.ActAwards.length);
         _loc10_ = new Vector.<TActVipBoxAward>();
         _loc11_ = new Vector.<TActVipBoxAward>();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc8_.ActAwards[_loc4_].GetType == 1)
            {
               _loc10_.push(_loc8_.ActAwards[_loc4_]);
            }
            else if(_loc8_.ActAwards[_loc4_].GetType == 2)
            {
               _loc11_.push(_loc8_.ActAwards[_loc4_]);
            }
            _loc4_++;
         }
         _loc6_.FreeVipBox = _loc10_;
         _loc6_.BuyVipBox = _loc11_;
         _loc9_ = _loc7_.BuyStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetStatusByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetStatusByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateGambling(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityGambling = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDGambling = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<int> = null;
         var _loc11_:THDOSRank = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityGambling;
         _loc8_ = param3 as THDGambling;
         _loc6_.DataAwards = _loc8_.DataAwards;
         _loc6_.DataButtons = _loc8_.DataButtons;
         _loc6_.DataFailOverCount = _loc8_.DataFailOverCount;
         _loc6_.DataStartCount = _loc8_.DataStartCount;
         _loc6_.DataWinCount = _loc8_.DataWins;
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetDataByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc9_ = _loc7_.ShowOnlyStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetDataByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc6_.SetDataByParameterVec(_loc7_.ParameterVec);
         _loc5_ = int(_loc7_.AddtionalVecs[0].length);
         _loc6_.DataRankList.length = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc7_.AddtionalVecs[0][_loc4_] as THDOSRank;
            _loc6_.DataRankList.push(_loc11_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateLimitBuy(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityLimitBuy = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDActivityLimitBuy = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<int> = null;
         var _loc11_:TActivityLimitBuyItem = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityLimitBuy;
         _loc8_ = param3 as THDActivityLimitBuy;
         _loc5_ = int(_loc8_.BuyLimitItems.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.AddLimitBuyItem(_loc8_.BuyLimitItems[_loc4_]);
            _loc4_++;
         }
         _loc6_.FlushTime = _loc8_.FlushTime;
         _loc6_.Prompts = _loc8_.Prompts;
         _loc9_ = _loc7_.BuyStates;
         _loc10_ = _loc7_.ParameterVec;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc6_.GetItemByUniqueIndex(_loc9_[_loc4_].BoxIndex);
            if(_loc11_ != null)
            {
               _loc11_.BuyCount = _loc9_[_loc4_].State;
               _loc11_.ServerCount = _loc9_[_loc4_].Conditions[0];
               _loc11_.Value = _loc10_[0];
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateIceHeros(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityIceHeros = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDIceHeros = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<int> = null;
         var _loc12_:TActivityIHAward = null;
         var _loc13_:TActivityIHChipBox = null;
         var _loc14_:TActivityServerRank = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityIceHeros;
         _loc8_ = param3 as THDIceHeros;
         var bp:Vector.<int> = _loc7_.ParameterVec;
         if(bp.length > 6 && bp[2] == 62000450)
         {
            var runtime:Object = {
               "revision":bp[3],
               "hero":bp[4],
               "price":bp[5],
               "rewards":[]
            };
            var pos:int = 6;
            _loc8_.Awards[0].HeroID = uint(bp[4]);
            _loc8_.Awards[0].HeroType = 1;
            _loc8_.Awards[0].Condition = uint(bp[5]);
            var bi:int = 0;
            while(bi < 5)
            {
               var condition:int = bp[pos++];
               var count:int = bp[pos++];
               var items:Array = [];
               var bj:int = 0;
               while(bj < count)
               {
                  items.push({
                     "type":bp[pos++],
                     "code":bp[pos++],
                     "amount":bp[pos++]
                  });
                  bj++;
               }
               _loc8_.Awards[bi + 2].Condition = uint(condition);
               runtime.rewards.push(items);
               bi++;
            }
            _loc6_.Runtime = runtime;
         }
         _loc6_.ClearAwards();
         _loc5_ = int(_loc8_.Awards.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.AddAwardItem(_loc8_.Awards[_loc4_]);
            _loc4_++;
         }
         _loc6_.ChipBoxs = _loc8_.ChipBoxes;
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc12_ = _loc6_.GetAwardByUniqueIndex(_loc9_[_loc4_].BoxIndex);
            if(_loc12_ != null)
            {
               _loc12_.Status = _loc9_[_loc4_].State;
            }
            _loc4_++;
         }
         _loc10_ = _loc7_.BuyStates;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc13_ = _loc6_.GetChipBoxByUniqueIndex(_loc10_[_loc4_].BoxIndex);
            _loc13_.Status = _loc10_[_loc4_].State;
            _loc4_++;
         }
         _loc11_ = _loc7_.ParameterVec;
         if(_loc11_.length > 0)
         {
            _loc6_.CurOwned = _loc11_[0];
            _loc6_.CurStage = _loc11_[1];
         }
         _loc6_.MyRank = -1;
         _loc6_.ClearRank();
         _loc5_ = int(_loc7_.AddtionalVecs[0].length);
         if(_loc7_.AddtionalVecs[0].length <= 0)
         {
            return;
         }
         _loc6_.MyRank = -1;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc14_ = _loc7_.AddtionalVecs[0][_loc4_] as TActivityServerRank;
            if(_loc14_.LowID == SLogicsCore.Character.Identifier1 && _loc14_.HighID == SLogicsCore.Character.Identifier0)
            {
               _loc6_.MyRank = _loc14_.Rank;
            }
            _loc6_.AddRankItem(_loc14_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateTeamBuy(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityTeamBuy = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDTeamBuy = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:TActivityTBBox = null;
         var _loc11_:Vector.<int> = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityTeamBuy;
         _loc8_ = param3 as THDTeamBuy;
         if(_loc6_.TBSignBox == null)
         {
            _loc10_ = new TActivityTBBox(CONST_ACTIVITY_MODE.UINDEX_TeamBuy_SignUp);
            _loc6_.TBSignBox = _loc10_;
         }
         if(_loc6_.TBBuyBox == null)
         {
            _loc10_ = new TActivityTBBox(CONST_ACTIVITY_MODE.UINDEX_TeamBuy_GetBuy);
            _loc6_.TBBuyBox = _loc10_;
         }
         _loc6_.TBAwards = _loc8_.TBAwards;
         _loc6_.TBOffRates = _loc8_.TBOffRates;
         _loc6_.TBOffRatesWithSort = _loc8_.TBOffRates;
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc9_[_loc4_].BoxIndex == CONST_ACTIVITY_MODE.UINDEX_TeamBuy_SignUp)
            {
               _loc6_.TBSignBox.BoxStatus = _loc9_[_loc4_].State;
            }
            if(_loc9_[_loc4_].BoxIndex == CONST_ACTIVITY_MODE.UINDEX_TeamBuy_GetBuy)
            {
               _loc6_.TBBuyBox.BoxStatus = _loc9_[_loc4_].State;
            }
            _loc4_++;
         }
         _loc11_ = _loc7_.ParameterVec;
         _loc6_.TBCurDay = _loc11_[0];
         _loc6_.TBSignedPeople = _loc11_[1];
         _loc6_.TBBoughtPeople = _loc11_[2];
      }
      
      protected function UnstreamizationPerform_UpdateServerPay(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityServerPay = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDServerPay = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<TActivityServerRank> = null;
         var _loc11_:TActivityServerRank = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityServerPay;
         _loc8_ = param3 as THDServerPay;
         _loc6_.HerosData = _loc8_.HerosData;
         _loc6_.RankAwards = _loc8_.RankAwards;
         _loc6_.ExchangeShops = _loc8_.ExchangeShops;
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.UpdateStatus(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc10_ = new Vector.<TActivityServerRank>();
         _loc5_ = int(_loc7_.AddtionalVecs[0].length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc7_.AddtionalVecs[0][_loc4_] as TActivityServerRank;
            _loc10_.push(_loc11_);
            _loc4_++;
         }
         _loc6_.Ranks = _loc10_;
         if(_loc7_.ParameterVec.length > 0)
         {
            _loc6_.CurScore = _loc7_.ParameterVec[0];
         }
      }
      
      protected function UnstreamizationPerform_UpdateRandCard(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityRandCard = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDRandCard = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<int> = null;
         var _loc11_:TActivityRCStageData = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityRandCard;
         _loc8_ = param3 as THDRandCard;
         _loc6_.GoldAwards = _loc8_.GoldAwards;
         _loc6_.SuperAwards = _loc8_.SuperAwards;
         _loc6_.Score = _loc8_.Score;
         _loc6_.FreeTime = _loc8_.FreeTime;
         _loc6_.GoldStartBtn = _loc8_.GoldStartBtn;
         _loc6_.GoldRefreshBtn = _loc8_.GoldRefreshbtn;
         _loc6_.GoldSelectBtn = _loc8_.GoldSelectBtn;
         _loc6_.GoldRestartBtn = _loc8_.GoldRestartBtn;
         _loc6_.SuperStartBtn = _loc8_.SuperStartBtn;
         _loc6_.SuperSelectBtn = _loc8_.SuperSelectBtn;
         _loc6_.SuperRestartBtn = _loc8_.SuperRestartBtn;
         _loc10_ = _loc7_.ParameterVec;
         _loc5_ = int(_loc10_.length);
         if(_loc5_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercTotal)
         {
            _loc11_ = _loc6_.GoldStage;
            _loc11_.Stage = _loc10_[1];
            _loc6_.SetGoldAward(_loc10_[2]);
            _loc11_ = _loc6_.SuperStage;
            _loc11_.Stage = _loc10_[4];
         }
         else if(_loc5_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercGold)
         {
            _loc11_ = _loc6_.GoldStage;
            _loc11_.Stage = _loc10_[1];
            _loc6_.SetGoldAward(_loc10_[2]);
         }
         else if(_loc5_ == CONST_ACTIVITY_MODE.COUNT_RC_ParametercSuper)
         {
            _loc11_ = _loc6_.SuperStage;
            _loc11_.Stage = _loc10_[1];
         }
         _loc9_ = _loc7_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetData(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc9_ = _loc7_.ShowOnlyStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetData(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateSuperTreasure(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateSuperTreasure(param1,param2);
      }
      
      public function UnstreamizeUpdateXmas(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateXmas(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateNewYearEgg(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateNewYearEgg(param1,param2);
      }
      
      public function UnstreamizeUpdateEspada(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateEspada(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateEquipmentShop(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateEquipmentShop(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateValentinesDay(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateValentinesDay(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateGambling(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateGambling(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateLimitBuy(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateLimitBuy(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateIceHeros(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateIceHeros(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateTeamBuy(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateTeamBuy(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateServerPay(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateServerPay(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateRandCard(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateRandCard(param1,param2,param3);
      }
   }
}

