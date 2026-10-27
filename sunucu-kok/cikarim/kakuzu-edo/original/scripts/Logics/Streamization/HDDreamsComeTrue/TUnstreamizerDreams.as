package Logics.Streamization.HDDreamsComeTrue
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THDDreamsComeTrue;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.DatebaseVO.VO.TKnifeExpand;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Logics.HDDreamsComeTrue.vo.TAwardExchangeVo;
   import Logics.HDDreamsComeTrue.vo.TFinishConditionVo;
   import Logics.HDDreamsComeTrue.vo.TFontIMGVo;
   import Logics.HDDreamsComeTrue.vo.TScoreRankAwardVo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DREAMS;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerDreams extends TUnstreamizer
   {
      
      public function TUnstreamizerDreams()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityDreamsData = null;
         var _loc5_:THDDreamsComeTrue = null;
         var _loc6_:TAwardExchangeVo = null;
         var _loc7_:TFontIMGVo = null;
         var _loc8_:TInventories = null;
         var _loc9_:TFinishConditionVo = null;
         var _loc10_:Vector.<TFinishConditionVo> = null;
         var _loc11_:TScoreRankAwardVo = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         _loc4_ = param2 as TActivityDreamsData;
         _loc5_ = param3 as THDDreamsComeTrue;
         _loc4_.ActivityConfig = _loc5_;
         _loc13_ = int(_loc5_.LowAwardIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc7_ = new TFontIMGVo();
            _loc7_.FontIndex = _loc5_.LowAwardIndexVec[_loc12_];
            _loc7_.FontCount = 0;
            _loc7_.CurFrame = _loc5_.LowAwardPosVec[_loc12_];
            _loc7_.TipsName = _loc5_.LowAwardTipsNameVec[_loc12_];
            _loc4_.GetFontImgList.push(_loc7_);
            _loc12_++;
         }
         _loc13_ = int(_loc5_.HighAwardIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc7_ = new TFontIMGVo();
            _loc7_.FontIndex = _loc5_.HighAwardIndexVec[_loc12_];
            _loc7_.FontCount = 0;
            _loc7_.CurFrame = _loc5_.HighAwardPosVec[_loc12_];
            _loc7_.TipsName = _loc5_.HighAwardTipsNameVec[_loc12_];
            _loc4_.GetFontImgList.push(_loc7_);
            _loc12_++;
         }
         _loc13_ = int(_loc5_.AwardIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc6_ = new TAwardExchangeVo();
            _loc6_.AwardType = _loc5_.AwardTypeVec[_loc12_];
            _loc6_.Index = _loc5_.AwardIndexVec[_loc12_];
            _loc6_.Limit = _loc5_.AwardLimitVec[_loc12_];
            if(_loc6_.AwardType == CONST_DREAMS.Type_0)
            {
               _loc6_.Inventories = null;
               _loc6_.HeroId = _loc5_.AwardIdVec[_loc12_];
               _loc6_.AwardName = this.GetHeroName(_loc5_.AwardIdVec[_loc12_]);
            }
            else if(_loc6_.AwardType == CONST_DREAMS.Type_1)
            {
               _loc6_.Inventories = null;
               _loc6_.HeroId = _loc5_.AwardIdVec[_loc12_];
               _loc6_.AwardName = this.GetKnifeName(_loc5_.AwardIdVec[_loc12_]);
            }
            else
            {
               _loc6_.HeroId = CONST_DREAMS.NotHero;
               _loc8_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc5_.AwardIdVec[_loc12_],_loc8_);
               _loc6_.Inventories = _loc8_;
               _loc6_.AwardName = _loc8_.GetInventoryByIndex(0).Name + "*" + _loc8_.GetInventoryByIndex(0).Quantity;
            }
            _loc14_ = _loc5_.AwardShowFontIndexVec[_loc12_];
            _loc15_ = _loc5_.AwardCostFontValueVec[_loc12_];
            _loc10_ = new Vector.<TFinishConditionVo>();
            _loc16_ = 0;
            while(_loc16_ < _loc14_.length)
            {
               _loc9_ = new TFinishConditionVo();
               _loc9_.Condition = _loc15_[_loc16_];
               _loc9_.FontIndex = _loc14_[_loc16_];
               _loc9_.FontShowCurFrame = this.GetFontCurFrame(_loc4_,_loc14_[_loc16_]);
               _loc10_.push(_loc9_);
               _loc16_++;
            }
            _loc6_.FinishConditionVec = _loc10_;
            _loc4_.ExchangeList[_loc12_] = _loc6_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.RankAwardsVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc11_ = new TScoreRankAwardVo();
            _loc11_.RankInfo = _loc5_.RankPromptVec[_loc12_];
            _loc8_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.RankAwardsVec[_loc12_],_loc8_);
            _loc11_.Inventories = _loc8_;
            _loc4_.RankAwardList[_loc12_] = _loc11_;
            _loc12_++;
         }
      }
      
      private function GetHeroName(param1:int) : String
      {
         var _loc2_:String = null;
         var _loc3_:TBins = null;
         var _loc4_:TBaseHero = null;
         _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc4_ = _loc3_.GetDatebaseByIdentifier(param1) as TBaseHero;
         if(_loc4_ == null)
         {
            _loc2_ = "";
         }
         else
         {
            _loc2_ = _loc4_.Name;
         }
         return _loc2_;
      }
      
      private function GetKnifeName(param1:int) : String
      {
         var _loc2_:TBaseHero = null;
         var _loc3_:TKnifeExpand = null;
         var _loc4_:TKnife = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param1) as TKnifeExpand;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc3_.RelationID) as TKnife;
         return _loc4_.Name;
      }
      
      private function GetFontCurFrame(param1:TActivityDreamsData, param2:int) : int
      {
         var _loc3_:TFontIMGVo = null;
         var _loc4_:int = 0;
         for each(_loc3_ in param1.GetFontImgList)
         {
            if(_loc3_.FontIndex == param2)
            {
               _loc4_ = _loc3_.CurFrame;
               break;
            }
         }
         return _loc4_;
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityDreamsData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:THDDreamsComeTrue = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:THDBoxStateData = null;
         var _loc11_:TFontIMGVo = null;
         var _loc12_:TAwardExchangeVo = null;
         var _loc13_:int = 0;
         _loc4_ = param2 as TActivityDreamsData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc6_ = _loc4_.ActivityConfig;
         if(_loc5_.AddtionalVecs.length > 0)
         {
            _loc4_.SetScoreRankData(_loc5_.AddtionalVecs);
         }
         if(_loc5_.AllBox.length == 0)
         {
            return;
         }
         _loc8_ = int(_loc5_.AllBox.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc10_ = _loc5_.AllBox[_loc7_];
            if(_loc10_.BoxIndex >= _loc4_.GetFontImgList[0].FontIndex && _loc10_.BoxIndex <= _loc4_.GetFontImgList[_loc4_.GetFontImgList.length - 1].FontIndex)
            {
               for each(_loc11_ in _loc4_.GetFontImgList)
               {
                  if(_loc11_.FontIndex == _loc10_.BoxIndex)
                  {
                     _loc11_.FontCount = _loc10_.State;
                     break;
                  }
               }
            }
            else if(_loc10_.BoxIndex >= _loc4_.ExchangeList[0].Index && _loc10_.BoxIndex <= _loc4_.ExchangeList[_loc4_.ExchangeList.length - 1].Index)
            {
               for each(_loc12_ in _loc4_.ExchangeList)
               {
                  if(_loc12_.Index == _loc10_.BoxIndex)
                  {
                     this.SetCurAwardState(_loc12_,_loc10_.State);
                     break;
                  }
               }
            }
            else if(_loc10_.BoxIndex == _loc6_.LowFreeTimeIndex)
            {
               _loc13_ = _loc6_.LowFreeTime - _loc10_.State;
               _loc13_ = _loc13_ <= 0 ? 0 : _loc13_;
               _loc4_.LowFreeTime = _loc13_;
            }
            else if(_loc10_.BoxIndex == _loc6_.HighFreeTimeIndex)
            {
               _loc13_ = _loc6_.HighFreeTime - _loc10_.State;
               _loc13_ = _loc13_ <= 0 ? 0 : _loc13_;
               _loc4_.HighFreeTime = _loc13_;
            }
            else if(_loc10_.BoxIndex == _loc6_.ScoreIndex)
            {
               _loc4_.TotalScore = _loc10_.State;
            }
            _loc7_++;
         }
         this.SetMaxValue(_loc4_);
      }
      
      private function SetCurAwardState(param1:TAwardExchangeVo, param2:int) : void
      {
         if(param1.Limit <= param2)
         {
            param1.Status = -1;
         }
         else
         {
            param1.Status = 1;
         }
      }
      
      private function SetMaxValue(param1:TActivityDreamsData) : void
      {
         var _loc2_:TFontIMGVo = null;
         var _loc3_:TAwardExchangeVo = null;
         var _loc4_:TFinishConditionVo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TActivityDreamsData = null;
         _loc10_ = param1;
         _loc6_ = int(_loc10_.ExchangeList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = _loc10_.ExchangeList[_loc5_];
            _loc9_ = int(_loc3_.FinishConditionVec.length);
            _loc7_ = int.MAX_VALUE;
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc4_ = _loc3_.FinishConditionVec[_loc8_];
               _loc7_ = Math.min(_loc7_,this.GetFontAmount(_loc10_,_loc4_));
               _loc8_++;
            }
            _loc3_.MaxValue = _loc7_;
            _loc5_++;
         }
      }
      
      private function GetFontAmount(param1:TActivityDreamsData, param2:TFinishConditionVo) : int
      {
         var _loc3_:TFontIMGVo = null;
         var _loc4_:int = 0;
         for each(_loc3_ in param1.GetFontImgList)
         {
            if(_loc3_.FontIndex == param2.FontIndex)
            {
               _loc4_ = _loc3_.FontCount / param2.Condition;
               break;
            }
         }
         return _loc4_;
      }
      
      public function FillBoxState(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityDreamsData = null;
         var _loc5_:THDDreamsComeTrue = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActAwardStatusInfo = null;
         var _loc9_:TFontIMGVo = null;
         var _loc10_:TAwardExchangeVo = null;
         var _loc11_:TFinishConditionVo = null;
         var _loc12_:int = 0;
         _loc8_ = param1;
         _loc4_ = param2 as TActivityDreamsData;
         _loc5_ = param3 as THDDreamsComeTrue;
         if(_loc8_.Index >= _loc4_.GetFontImgList[0].FontIndex && _loc8_.Index <= _loc4_.GetFontImgList[_loc4_.GetFontImgList.length - 1].FontIndex)
         {
            for each(_loc9_ in _loc4_.GetFontImgList)
            {
               if(_loc9_.FontIndex == _loc8_.Index)
               {
                  _loc9_.FontCount = _loc8_.Status;
                  break;
               }
            }
         }
         else if(_loc8_.Index >= _loc4_.ExchangeList[0].Index && _loc8_.Index <= _loc4_.ExchangeList[_loc4_.ExchangeList.length - 1].Index)
         {
            for each(_loc10_ in _loc4_.ExchangeList)
            {
               if(_loc10_.Index == _loc8_.Index)
               {
                  this.SetCurAwardState(_loc10_,_loc8_.Status);
                  break;
               }
            }
         }
         else if(_loc8_.Index == _loc5_.LowFreeTimeIndex)
         {
            _loc12_ = _loc5_.LowFreeTime - _loc8_.Status;
            _loc12_ = _loc12_ <= 0 ? 0 : _loc12_;
            _loc4_.LowFreeTime = _loc12_;
         }
         else if(_loc8_.Index == _loc5_.HighFreeTimeIndex)
         {
            _loc12_ = _loc5_.HighFreeTime - _loc8_.Status;
            _loc12_ = _loc12_ <= 0 ? 0 : _loc12_;
            _loc4_.HighFreeTime = _loc12_;
         }
         else if(_loc8_.Index == _loc5_.ScoreIndex)
         {
            _loc4_.TotalScore = _loc8_.Status;
         }
         this.SetMaxValue(_loc4_);
      }
   }
}

