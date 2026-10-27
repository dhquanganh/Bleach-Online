package Logics.Streamization.HDAstrology
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDAstrologyConfig;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDAstrology.TActivityAstrologyData;
   import Logics.HDAstrology.vo.TSCStarPicture;
   import Logics.HDAstrology.vo.TSingleCombineVo;
   import Logics.HDAstrology.vo.TSoulExchangeVo;
   import Logics.HDAstrology.vo.TStarCombinesVo;
   import Logics.HDAstrology.vo.TStarVo;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerAstrology extends TUnstreamizer
   {
      
      public function TUnstreamizerAstrology()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityAstrologyData = null;
         var _loc5_:THDAstrologyConfig = null;
         var _loc6_:TInventories = null;
         var _loc7_:TSCStarPicture = null;
         var _loc8_:TStarVo = null;
         var _loc9_:TStarCombinesVo = null;
         var _loc10_:TSingleCombineVo = null;
         var _loc11_:TSoulExchangeVo = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         _loc4_ = param2 as TActivityAstrologyData;
         _loc5_ = param3 as THDAstrologyConfig;
         _loc4_.ActivityConfig = _loc5_;
         _loc13_ = int(_loc5_.LoginGiftVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.LoginGiftVec[_loc12_],_loc6_);
            _loc4_.LoginGiftInventories[_loc12_] = _loc6_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.StarPositionVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc7_ = new TSCStarPicture();
            _loc7_.StarPicPosition = _loc5_.StarPositionVec[_loc12_];
            _loc7_.ExtractState = 1;
            _loc4_.ExtractDataVec[_loc12_] = _loc7_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.StarIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc8_ = new TStarVo();
            _loc8_.StarIndex = _loc5_.StarIndexVec[_loc12_];
            _loc8_.StarAmount = 0;
            _loc8_.StarType = _loc5_.StarTypeVec[_loc12_];
            _loc8_.StarCardPrice = _loc5_.StarGoldVec[_loc12_];
            _loc8_.Desc = _loc5_.StarDescVec[_loc12_];
            _loc4_.StarVec[_loc12_] = _loc8_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.CompoundIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc9_ = new TStarCombinesVo();
            _loc9_.CombineIndex = _loc5_.CompoundIndexVec[_loc12_];
            _loc9_.SoulAmount = _loc5_.CompoundStarSoulVec[_loc12_];
            _loc15_ = int(_loc5_.CompoundCardIndexVec[_loc12_].length);
            _loc14_ = 0;
            while(_loc14_ < _loc15_)
            {
               _loc10_ = new TSingleCombineVo();
               _loc10_.IsOpen = false;
               _loc10_.StarIndex = _loc5_.CompoundCardIndexVec[_loc12_][_loc14_];
               _loc10_.StarCondition = _loc5_.CompoundCardConditionVec[_loc12_][_loc14_];
               _loc10_.StarType = this.GetStarVo(_loc4_.StarVec,_loc10_.StarIndex).StarType;
               _loc10_.StarCardPrice = this.GetStarVo(_loc4_.StarVec,_loc10_.StarIndex).StarCardPrice;
               _loc10_.Desc = this.GetStarVo(_loc4_.StarVec,_loc10_.StarIndex).Desc;
               _loc9_.CombineTypeVec[_loc14_] = _loc10_;
               _loc14_++;
            }
            _loc4_.StarCombineVec[_loc12_] = _loc9_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.StarShopItemIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc11_ = new TSoulExchangeVo();
            _loc11_.Index = _loc5_.StarShopItemIndexVec[_loc12_];
            _loc11_.LimitValue = _loc5_.StarLimitVec[_loc12_];
            _loc11_.ConditionValue = _loc5_.StarConditonVec[_loc12_];
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.StarShopItemAwardVec[_loc12_],_loc6_);
            _loc11_.Inventories = _loc6_;
            _loc4_.StarShopList[_loc12_] = _loc11_;
            _loc12_++;
         }
         _loc13_ = int(_loc5_.SoulShopItemIndexVec.length);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            _loc11_ = new TSoulExchangeVo();
            _loc11_.Index = _loc5_.SoulShopItemIndexVec[_loc12_];
            _loc11_.LimitValue = _loc5_.SoulLimitVec[_loc12_];
            _loc11_.ConditionValue = _loc5_.SoulConditonVec[_loc12_];
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.SoulShopItemAwardVec[_loc12_],_loc6_);
            _loc11_.Inventories = _loc6_;
            _loc4_.SoulShopList[_loc12_] = _loc11_;
            _loc12_++;
         }
      }
      
      private function GetStarVo(param1:Vector.<TStarVo>, param2:int) : TStarVo
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TStarVo = null;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1[_loc3_];
            if(_loc5_.StarIndex == param2)
            {
               break;
            }
            _loc3_++;
         }
         return _loc5_;
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityAstrologyData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:THDAstrologyConfig = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityAstrologyData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc6_ = _loc4_.ActivityConfig;
         _loc4_.CurDay = _loc5_.ParameterVec[0];
         _loc8_ = int(_loc5_.AllBox.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc10_ = _loc5_.AllBox[_loc7_];
            this.SetData(_loc10_.BoxIndex,_loc10_.State,_loc10_.Conditions,_loc4_);
            _loc7_++;
         }
      }
      
      private function SetData(param1:int, param2:int, param3:Vector.<int>, param4:TActivityAstrologyData) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TSCStarPicture = null;
         var _loc8_:TStarVo = null;
         var _loc9_:TStarCombinesVo = null;
         var _loc10_:TSingleCombineVo = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         if(param1 == param4.ActivityConfig.LoginIndex)
         {
            param4.LoginGiftState = param2;
         }
         else if(param1 == param4.ActivityConfig.GetStatCardIndex)
         {
            _loc6_ = int(param4.ExtractDataVec.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = param4.ExtractDataVec[_loc5_];
               _loc7_.StarPicIndex = param3[_loc5_];
               _loc7_.StarType = this.GetStarVo(param4.StarVec,_loc7_.StarPicIndex).StarType;
               _loc7_.Desc = this.GetStarVo(param4.StarVec,_loc7_.StarPicIndex).Desc;
               _loc7_.ExtractState = 1;
               _loc5_++;
            }
         }
         else if(param1 == param4.ActivityConfig.ExtractSingleIndex)
         {
            _loc12_ = param4.ActivityConfig.FreeSingleVal - param2;
            _loc12_ = _loc12_ < 0 ? 0 : _loc12_;
            param4.AstrologyFree = _loc12_;
         }
         else if(param1 != param4.ActivityConfig.ExtractMoreIndex)
         {
            if(param1 == param4.ActivityConfig.RefreshIndex)
            {
               _loc12_ = param4.ActivityConfig.FreeRefreshVal - param2;
               _loc12_ = _loc12_ < 0 ? 0 : _loc12_;
               param4.RefreshFree = _loc12_;
            }
            else if(param1 == param4.ActivityConfig.StarIndex)
            {
               param4.StarVal = param2;
            }
            else if(param1 == param4.ActivityConfig.SoulIndex)
            {
               param4.SoulVal = param2;
            }
         }
         _loc6_ = int(param4.ExtractDataVec.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param4.ExtractDataVec[_loc5_];
            if(_loc7_.StarPicPosition == param1)
            {
               _loc7_.ExtractState = param2;
            }
            _loc5_++;
         }
         _loc6_ = int(param4.StarVec.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc8_ = param4.StarVec[_loc5_];
            if(param1 == _loc8_.StarIndex)
            {
               _loc8_.StarAmount = param2;
            }
            _loc5_++;
         }
         _loc6_ = int(param4.StarCombineVec.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = param4.StarCombineVec[_loc5_];
            _loc11_ = true;
            _loc13_ = 0;
            while(_loc13_ < _loc9_.CombineTypeVec.length)
            {
               _loc10_ = _loc9_.CombineTypeVec[_loc13_];
               _loc10_.StarAmount = this.GetStarVo(param4.StarVec,_loc10_.StarIndex).StarAmount;
               _loc10_.IsOpen = _loc10_.StarAmount >= _loc10_.StarCondition;
               _loc11_ &&= _loc10_.IsOpen;
               _loc13_++;
            }
            _loc9_.IsExchange = _loc11_;
            _loc5_++;
         }
         _loc6_ = int(param4.StarShopList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(param4.StarShopList[_loc5_].Index == param1)
            {
               param4.StarShopList[_loc5_].Status = param2;
            }
            _loc5_++;
         }
         _loc6_ = int(param4.SoulShopList.length);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(param4.SoulShopList[_loc5_].Index == param1)
            {
               param4.SoulShopList[_loc5_].Status = param2;
            }
            _loc5_++;
         }
      }
      
      public function FillBoxState(param1:TActAwardStatusInfo, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityAstrologyData = null;
         var _loc5_:THDAstrologyConfig = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TActAwardStatusInfo = null;
         _loc8_ = param1;
         _loc4_ = param2 as TActivityAstrologyData;
         _loc5_ = param3 as THDAstrologyConfig;
         this.SetData(_loc8_.Index,_loc8_.Status,_loc8_.Condition,_loc4_);
      }
   }
}

