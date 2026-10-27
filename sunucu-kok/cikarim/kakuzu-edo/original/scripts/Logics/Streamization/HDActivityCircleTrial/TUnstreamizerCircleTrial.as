package Logics.Streamization.HDActivityCircleTrial
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TFighterDetail;
   import Logics.DatebaseVO.VO.THDCircleHero;
   import Logics.DatebaseVO.VO.THDCircleTrial;
   import Logics.HDActivityCircleTrial.TActivityCircleTrialData;
   import Logics.HDActivityCircleTrial.TBlockInfo;
   import Logics.HDActivityCircleTrial.TCircleTrialAwardVo;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TUnstreamizerCircleTrial extends TUnstreamizer
   {
      
      protected var FBins:TBins;
      
      protected var FActivityHDBins:TBins;
      
      public function TUnstreamizerCircleTrial()
      {
         super();
      }
      
      public function UnstreamizeInitHalloween(param1:Object, param2:Object, param3:Object) : void
      {
         this.CoreConfigValue(param1,param2,param3);
         this.UnstreamizationPerform_InitData(param1,param2,param3);
      }
      
      private function CoreConfigValue(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityCircleTrialData = null;
         var _loc6_:THDCircleTrial = null;
         var _loc7_:TInventories = null;
         var _loc8_:TBlockInfo = null;
         var _loc9_:TCircleTrialAwardVo = null;
         var _loc10_:TFighterDetail = null;
         var _loc11_:THDCircleHero = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityCircleTrialData;
         _loc6_ = param3 as THDCircleTrial;
         _loc5_.ExtractOnKeyIndex = _loc6_.OneKeyIndex;
         _loc5_.ExtractScoreIndex = _loc6_.ScoreExtrecIndex;
         _loc5_.ExtractGoldIndex = _loc6_.GoldExtractIndex;
         _loc5_.PromptFontArr = _loc6_.PromptFontArr;
         _loc5_.ExtractCostGold = _loc6_.Gold;
         _loc5_.ExtractCostScore = _loc6_.Score;
         _loc5_.BlockList.length = 0;
         _loc14_ = int(_loc6_.ConditionIndexVec.length);
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc8_ = new TBlockInfo();
            _loc8_.BlockName = _loc6_.ConditionPromptVec[_loc13_];
            _loc8_.BlockPassTimes = 0;
            _loc8_.BlockScore = _loc6_.ConditionScoreVec[_loc13_];
            _loc8_.BlockType = _loc6_.ConditionValueVec[_loc13_];
            _loc8_.Index = _loc6_.ConditionIndexVec[_loc13_];
            _loc5_.BlockList.push(_loc8_);
            _loc13_++;
         }
         _loc5_.ExtractInventories.length = 0;
         _loc5_.HDDataList.length = 0;
         _loc5_.HDHeroGiftDataList.length = 0;
         _loc14_ = int(_loc6_.TaskAwardVec.length);
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc9_ = new TCircleTrialAwardVo();
            _loc9_.Index = _loc6_.TaskIndexVec[_loc13_];
            _loc9_.TotalValue = _loc6_.TaskValueVec[_loc13_];
            _loc9_.CurrentGetValue = 0;
            _loc9_.AwardId = _loc6_.TaskAwardVec[_loc13_];
            _loc9_.EmployName = _loc6_.TaskPromptVec[_loc13_];
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.TaskAwardVec[_loc13_],_loc7_);
            _loc9_.Inventories = _loc7_;
            _loc5_.HDDataList.push(_loc9_);
            _loc13_++;
         }
         _loc14_ = int(_loc6_.GiftAwardVec.length);
         _loc13_ = 0;
         while(_loc13_ < _loc14_)
         {
            _loc9_ = new TCircleTrialAwardVo();
            _loc9_.Index = _loc6_.GiftIndexVec[_loc13_];
            _loc12_ = this.GetGiftCoupon(_loc6_.GiftHeroIdVec[_loc13_]);
            _loc9_.TotalValue = _loc12_[1];
            _loc9_.CurrentGetValue = _loc12_[0];
            _loc9_.AwardId = _loc6_.GiftAwardVec[_loc13_];
            _loc9_.HeroGiftName = _loc6_.GiftHeroNameVec[_loc13_];
            _loc9_.EmployName = _loc6_.EmployCouponNameVec[_loc13_];
            _loc10_ = this.FBins.GetDatebaseByIdentifier(_loc6_.GiftHeroIdVec[_loc13_]) as TFighterDetail;
            _loc9_.HeroId = _loc10_.Identifier;
            _loc9_.UpHeroId = _loc10_.UpHeroID;
            _loc7_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_.GiftAwardVec[_loc13_],_loc7_);
            _loc9_.Inventories = _loc7_;
            _loc5_.HDHeroGiftDataList.push(_loc9_);
            _loc13_++;
         }
         this.FActivityHDBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_CircleHero);
         _loc11_ = this.FActivityHDBins.GetDatebaseByIndex(0) as THDCircleHero;
         _loc5_.ImageDebris = _loc11_.NeedDebrisAmount;
      }
      
      private function UnstreamizationPerform_InitData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:TActivityCircleTrialData = null;
         var _loc10_:THDCircleTrial = null;
         var _loc11_:THDBoxStateData = null;
         var _loc12_:Vector.<THDBoxStateData> = null;
         var _loc13_:int = 0;
         var _loc14_:TInventories = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc9_ = param2 as TActivityCircleTrialData;
         _loc10_ = param3 as THDCircleTrial;
         if(_loc8_.AllBox.length == 0)
         {
            return;
         }
         _loc13_ = _loc8_.ParameterVec[0];
         this.GetTypeCodeInventories(_loc13_,_loc10_,_loc9_);
         _loc5_ = int(_loc8_.AllBox.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = _loc8_.AllBox[_loc4_];
            if(_loc11_.BoxIndex >= 0 && _loc11_.BoxIndex < _loc10_.ConditionIndexVec.length)
            {
               _loc7_ = int(_loc9_.BlockList.length);
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  if(_loc10_.ConditionIndexVec[_loc6_] == _loc11_.BoxIndex)
                  {
                     _loc9_.BlockList[_loc6_].BlockPassTimes = _loc11_.State;
                     break;
                  }
                  _loc6_++;
               }
            }
            else if(_loc11_.BoxIndex == _loc10_.ScoreIndex)
            {
               _loc9_.PlayerTotalScore = _loc11_.State;
            }
            else if(_loc11_.BoxIndex != _loc10_.GoldExtractIndex)
            {
               if(_loc11_.BoxIndex != _loc10_.ScoreExtrecIndex)
               {
                  if(_loc11_.BoxIndex != _loc10_.OneKeyIndex)
                  {
                     if(_loc11_.BoxIndex >= _loc10_.TaskIndexVec[0] && _loc11_.BoxIndex <= _loc10_.TaskIndexVec[_loc10_.TaskIndexVec.length - 1])
                     {
                        _loc7_ = int(_loc9_.HDDataList.length);
                        _loc6_ = 0;
                        while(_loc6_ < _loc7_)
                        {
                           if(_loc10_.TaskIndexVec[_loc6_] == _loc11_.BoxIndex)
                           {
                              _loc9_.HDDataList[_loc6_].CurrentGetValue = _loc11_.State;
                              break;
                           }
                           _loc6_++;
                        }
                     }
                     else if(_loc11_.BoxIndex >= _loc10_.GiftIndexVec[0] && _loc11_.BoxIndex <= _loc10_.GiftIndexVec[_loc10_.GiftIndexVec.length - 1])
                     {
                        _loc7_ = int(_loc9_.HDHeroGiftDataList.length);
                        _loc6_ = 0;
                        while(_loc6_ < _loc7_)
                        {
                           if(_loc10_.GiftIndexVec[_loc6_] == _loc11_.BoxIndex)
                           {
                              _loc9_.HDHeroGiftDataList[_loc6_].GetAwardState = _loc11_.State;
                              break;
                           }
                           _loc6_++;
                        }
                     }
                     else if(_loc11_.BoxIndex == _loc10_.ChipIndex)
                     {
                        _loc9_.CurrentDebrisNum = _loc11_.State;
                     }
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function GetTypeCodeInventories(param1:int, param2:THDCircleTrial, param3:TActivityCircleTrialData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TInventories = null;
         var _loc8_:Vector.<TFixedAward> = null;
         var _loc9_:TFixedAward = null;
         var _loc10_:Object = null;
         _loc4_ = 0;
         while(_loc4_ < param2.ShowAwardArr.length)
         {
            if(param1 == _loc4_)
            {
               _loc8_ = new Vector.<TFixedAward>();
               _loc5_ = 0;
               while(_loc5_ < param2.ShowAwardArr[_loc4_].length)
               {
                  _loc10_ = new Object();
                  _loc7_ = new TInventories();
                  _loc10_.type = param2.ShowAwardArr[_loc4_][_loc5_].type;
                  _loc10_.code = param2.ShowAwardArr[_loc4_][_loc5_].code;
                  _loc10_.amount = param2.ShowAwardArr[_loc4_][_loc5_].amount;
                  _loc9_ = new TFixedAward(_loc10_);
                  _loc8_[0] = _loc9_;
                  param3.FixedAwardVec[_loc5_] = _loc9_;
                  SToolReward.GetInventoriesByFixedAwards(_loc8_,_loc7_);
                  param3.ExtractInventories[_loc5_] = _loc7_;
                  _loc5_++;
               }
               break;
            }
            _loc4_++;
         }
      }
      
      private function GetGiftCoupon(param1:int) : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:TFighterDetail = null;
         var _loc4_:TArticle = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = [];
         if(this.FBins == null)
         {
            this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_FighterDetail);
         }
         _loc3_ = this.FBins.GetDatebaseByIdentifier(param1) as TFighterDetail;
         _loc2_ = CONST_COMMON.RewardIDToTemplateID(_loc3_.EnlistPaperArticalItem.Type,_loc3_.EnlistPaperArticalItem.Code);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_) as TArticle;
         _loc7_ = _loc4_.Name;
         _loc6_ = int(_loc3_.EnlistPaperArticalItem.Amount);
         _loc5_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(_loc2_));
         _loc8_.push(_loc5_,_loc6_,_loc7_);
         return _loc8_;
      }
      
      public function UnstreamizeUpdateHalloween(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActAwardStatusInfo = null;
         var _loc5_:TActivityCircleTrialData = null;
         var _loc6_:THDCircleTrial = null;
         var _loc7_:TInventories = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param1;
         _loc5_ = param2 as TActivityCircleTrialData;
         _loc6_ = param3 as THDCircleTrial;
         if(_loc4_.Index >= 0 && _loc4_.Index < _loc6_.ConditionIndexVec.length)
         {
            _loc9_ = int(_loc5_.BlockList.length);
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               if(_loc6_.ConditionIndexVec[_loc8_] == _loc4_.Index)
               {
                  _loc5_.BlockList[_loc8_].BlockPassTimes = _loc4_.Status;
                  break;
               }
               _loc8_++;
            }
         }
         else if(_loc4_.Index == _loc6_.ScoreIndex)
         {
            _loc5_.PlayerTotalScore = _loc4_.Status;
         }
         else if(_loc4_.Index == _loc6_.GoldExtractIndex)
         {
            _loc4_.Condition;
         }
         else if(_loc4_.Index == _loc6_.ScoreExtrecIndex)
         {
            _loc4_.Condition;
         }
         else if(_loc4_.Index != _loc6_.OneKeyIndex)
         {
            if(_loc4_.Index >= _loc6_.TaskIndexVec[0] && _loc4_.Index <= _loc6_.TaskIndexVec[_loc6_.TaskIndexVec.length - 1])
            {
               _loc9_ = int(_loc5_.HDDataList.length);
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  if(_loc6_.TaskIndexVec[_loc8_] == _loc4_.Index)
                  {
                     _loc5_.HDDataList[_loc8_].CurrentGetValue = _loc4_.Status;
                     break;
                  }
                  _loc8_++;
               }
            }
            else if(_loc4_.Index >= _loc6_.GiftIndexVec[0] && _loc4_.Index <= _loc6_.GiftIndexVec[_loc6_.GiftIndexVec.length - 1])
            {
               _loc9_ = int(_loc5_.HDHeroGiftDataList.length);
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  if(_loc6_.GiftIndexVec[_loc8_] == _loc4_.Index)
                  {
                     _loc5_.HDHeroGiftDataList[_loc8_].GetAwardState = _loc4_.Status;
                     break;
                  }
                  _loc8_++;
               }
            }
            else if(_loc4_.Index == _loc6_.ChipIndex)
            {
               _loc5_.CurrentDebrisNum = _loc4_.Status;
            }
         }
      }
   }
}

