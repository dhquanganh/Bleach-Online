package Logics.Streamization.NightmareTrial
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.DatebaseVO.VO.TNightmareTrialCityConfig;
   import Logics.DatebaseVO.VO.TNightmareTrialConfig;
   import Logics.DatebaseVO.VO.TNightmareTrialPointConfig;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.Inventories.TInventories;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.NightmareTrial.VO.TNightmareTrialEnemyVo;
   import Logics.NightmareTrial.VO.TNightmareTrialLevelVo;
   import Logics.NightmareTrial.VO.TNightmareTrialPointVo;
   import Logics.NightmareTrial.VO.TSelectInfoVo;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NIGHTMARETRIAL;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerNightmareTrial extends TUnstreamizer
   {
      
      private var FData:TNightmareTrialData;
      
      public function TUnstreamizerNightmareTrial(param1:TNightmareTrialData)
      {
         super();
         this.FData = param1;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      private function CurrentScanReset(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         _loc3_ = param1 - param2;
         return _loc3_ <= 0 ? 0 : _loc3_;
      }
      
      private function CurrentResetSpendGold(param1:Vector.<int>, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2 >= param1.length ? int(param1.length - 1) : param2;
         return param1[_loc3_];
      }
      
      private function SetNightmarePointState(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TNightmareTrialLevelVo = null;
         var _loc9_:TNightmareTrialPointVo = null;
         for each(_loc8_ in this.FData.NightmareTrialLevelVec)
         {
            if(_loc8_.Id == param1)
            {
               break;
            }
         }
         _loc7_ = _loc8_.CityDifficultyIdVec.indexOf(param2);
         if(_loc7_ != -1)
         {
            _loc6_ = int(_loc8_.SelectInfoVo.NightmareTrialPointVec[_loc7_].length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc9_ = _loc8_.SelectInfoVo.NightmareTrialPointVec[_loc7_][_loc5_];
               _loc9_.IsPass = _loc8_.SelectInfoVo.PassAmount > _loc5_;
               if(_loc8_.SelectInfoVo.PassAmount == _loc5_)
               {
                  _loc9_.State = TNightmareTrialPointVo.EFFECT_KNIFE;
               }
               else if(_loc8_.SelectInfoVo.PassAmount > _loc5_)
               {
                  _loc9_.State = TNightmareTrialPointVo.EFFECT_DEATH;
               }
               else
               {
                  _loc9_.State = TNightmareTrialPointVo.EFFECT_GRAY;
               }
               _loc5_++;
            }
         }
         else if(_loc8_.SelectInfoVo != null)
         {
            _loc4_ = int(_loc8_.SelectInfoVo.NightmareTrialPointVec.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = int(_loc8_.SelectInfoVo.NightmareTrialPointVec[_loc3_].length);
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  _loc9_ = _loc8_.SelectInfoVo.NightmareTrialPointVec[_loc3_][_loc5_];
                  _loc9_.IsPass = _loc8_.SelectInfoVo.PassAmount > _loc5_;
                  if(_loc8_.SelectInfoVo.PassAmount == _loc5_)
                  {
                     _loc9_.State = TNightmareTrialPointVo.EFFECT_KNIFE;
                  }
                  else if(_loc8_.SelectInfoVo.PassAmount > _loc5_)
                  {
                     _loc9_.State = TNightmareTrialPointVo.EFFECT_DEATH;
                  }
                  else
                  {
                     _loc9_.State = TNightmareTrialPointVo.EFFECT_GRAY;
                  }
                  _loc5_++;
               }
               _loc3_++;
            }
         }
      }
      
      public function InitStaticConfigData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TNightmareTrialLevelVo = null;
         var _loc6_:TBins = null;
         var _loc7_:TBins = null;
         var _loc8_:TNightmareTrialConfig = null;
         var _loc9_:TInventories = null;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NightmareTrial);
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc2_ = _loc6_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TNightmareTrialLevelVo();
            _loc8_ = _loc6_.GetDatebaseByIndex(_loc1_) as TNightmareTrialConfig;
            _loc5_.Id = _loc8_.Identifier;
            _loc5_.CityDifficultyIdVec.push(_loc8_.NormalCityId);
            _loc5_.CityDifficultyIdVec.push(_loc8_.HardCityId);
            _loc5_.CityDifficultyIdVec.push(_loc8_.NightmareCityId);
            _loc5_.CityDifficultyIdVec.push(_loc8_.DeadCityId);
            _loc4_ = int(_loc8_.AwardIdVec.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc9_ = new TInventories();
               SToolReward.GetInventoryByID(_loc8_.AwardIdVec[_loc3_],_loc9_);
               _loc5_.Inventories[_loc3_] = _loc9_;
               _loc3_++;
            }
            _loc5_.StartLevel = (_loc7_.GetDatebaseByIdentifier(_loc8_.NormalCityId) as TCity).OpenLevel;
            _loc5_.IsStart = Boolean(_loc8_.ChapterSwitch);
            _loc5_.TitleName = _loc8_.NameDesc;
            _loc5_.TxtWordDesc = TUtilityLobby.GetStringByIdentifier(_loc8_.WordTxtSysId);
            _loc5_.Name = TUtilityLobby.GetStringByIdentifier(_loc8_.TitleTxtSysId);
            _loc5_.CityDifficlutyIconVec.push((_loc7_.GetDatebaseByIdentifier(_loc8_.NormalCityId) as TCity).Icon);
            _loc5_.CityDifficlutyIconVec.push((_loc7_.GetDatebaseByIdentifier(_loc8_.HardCityId) as TCity).Icon);
            _loc5_.CityDifficlutyIconVec.push((_loc7_.GetDatebaseByIdentifier(_loc8_.NightmareCityId) as TCity).Icon);
            _loc5_.CityDifficlutyIconVec.push((_loc7_.GetDatebaseByIdentifier(_loc8_.DeadCityId) as TCity).Icon);
            this.FData.NightmareTrialLevelVec[_loc1_] = _loc5_;
            _loc1_++;
         }
      }
      
      public function NightmareInfo_Ret(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TNightmareTrialLevelVo = null;
         var _loc7_:TSelectInfoVo = null;
         var _loc8_:TNightmareTrialCityConfig = null;
         var _loc9_:TInventories = null;
         var _loc10_:Vector.<TInventories> = null;
         var _loc11_:TInventories = null;
         var _loc12_:Vector.<TInventories> = null;
         var _loc13_:TBins = null;
         var _loc14_:TBins = null;
         var _loc15_:TBins = null;
         var _loc16_:TConfigValue = null;
         var _loc17_:TCity = null;
         var _loc18_:TNightmareTrialPointConfig = null;
         var _loc19_:TNightmareTrialPointVo = null;
         var _loc20_:Vector.<TNightmareTrialPointVo> = null;
         var _loc21_:TNightmareTrialEnemyVo = null;
         var _loc22_:TEnemyArmy = null;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         _loc23_ = int(param1.readUnsignedInt());
         _loc24_ = int(param1.readUnsignedInt());
         _loc25_ = int(param1.readUnsignedInt());
         _loc26_ = int(param1.readUnsignedInt());
         _loc27_ = int(param1.readUnsignedInt());
         _loc13_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NightmareTrialCity);
         _loc14_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc16_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_NIGHTMARETRIAL.CONFIGVALUE_RefreshTimes) as TConfigValue;
         _loc15_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_NightmareTrialPoint);
         _loc7_ = new TSelectInfoVo();
         for each(_loc6_ in this.FData.NightmareTrialLevelVec)
         {
            if(_loc6_.Id == _loc23_)
            {
               _loc28_ = this.FData.NightmareTrialLevelVec.indexOf(_loc6_);
               break;
            }
         }
         _loc3_ = int(_loc6_.CityDifficultyIdVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = _loc13_.GetDatebaseByIdentifier(_loc6_.CityDifficultyIdVec[_loc2_]) as TNightmareTrialCityConfig;
            _loc5_ = int(_loc8_.AwardVec.length);
            _loc10_ = new Vector.<TInventories>();
            _loc12_ = new Vector.<TInventories>();
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc9_ = new TInventories();
               SToolReward.GetInventoryByID(_loc8_.AwardVec[_loc4_],_loc9_);
               _loc10_[_loc4_] = _loc9_;
               _loc4_++;
            }
            _loc29_ = 0;
            while(_loc29_ < _loc8_.PassAwardVec.length)
            {
               _loc11_ = new TInventories();
               SToolReward.GetInventoriesByFixedAwards(_loc8_.PassAwardVec,_loc11_);
               _loc12_[_loc29_] = _loc11_;
               _loc29_++;
            }
            _loc7_.Inventories[_loc2_] = _loc10_;
            _loc7_.PassLevelInventories[_loc2_] = _loc12_;
            _loc2_++;
         }
         _loc7_.ResetTimes = this.CurrentScanReset(_loc16_.Value.length,_loc24_);
         _loc7_.ResetGold = this.CurrentResetSpendGold(Vector.<int>(_loc16_.Value),_loc24_);
         _loc7_.CurrentCityId = _loc25_;
         _loc7_.PassAmount = _loc26_;
         _loc7_.HistoryCityId = _loc27_;
         this.FData.NightmareTrialLevelVec[_loc28_].SelectInfoVo = _loc7_;
         _loc3_ = int(_loc6_.CityDifficultyIdVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc17_ = _loc14_.GetDatebaseByIdentifier(_loc6_.CityDifficultyIdVec[_loc2_]) as TCity;
            _loc20_ = new Vector.<TNightmareTrialPointVo>();
            _loc4_ = _loc17_.Start;
            while(_loc4_ <= _loc17_.Last)
            {
               _loc18_ = _loc15_.GetDatebaseByIdentifier(_loc4_) as TNightmareTrialPointConfig;
               _loc22_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EnemyArmy,_loc18_.ArmyVec[0]) as TEnemyArmy;
               _loc19_ = new TNightmareTrialPointVo();
               _loc19_.NightmareTrialPointInfo = _loc18_;
               _loc19_.RoleTempleteID = _loc4_;
               _loc19_.Index = _loc4_ - _loc17_.Start;
               _loc19_.Enemys.FightPoses = _loc22_.EnemyPosVect;
               _loc19_.Enemys.TemplateIds = _loc22_.EnemyIdVect;
               _loc20_[_loc19_.Index] = _loc19_;
               _loc4_++;
            }
            _loc6_.SelectInfoVo.NightmareTrialPointVec[_loc2_] = _loc20_;
            _loc2_++;
         }
         this.SetNightmarePointState(_loc23_,_loc25_);
      }
      
      public function NightmareReset_Ret(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TConfigValue = null;
         var _loc7_:TNightmareTrialLevelVo = null;
         _loc2_ = int(param1.readUnsignedInt());
         _loc3_ = int(param1.readUnsignedInt());
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_NIGHTMARETRIAL.CONFIGVALUE_RefreshTimes) as TConfigValue;
         for each(_loc7_ in this.FData.NightmareTrialLevelVec)
         {
            if(_loc7_.Id == _loc2_)
            {
               _loc4_ = this.FData.NightmareTrialLevelVec.indexOf(_loc7_);
               break;
            }
         }
         this.FData.NightmareTrialLevelVec[_loc4_].SelectInfoVo.ResetTimes = this.CurrentScanReset(_loc6_.Value.length,_loc3_);
         this.FData.NightmareTrialLevelVec[_loc4_].SelectInfoVo.CurrentCityId = 0;
         this.FData.NightmareTrialLevelVec[_loc4_].SelectInfoVo.PassAmount = 0;
         this.FData.NightmareTrialLevelVec[_loc4_].SelectInfoVo.HistoryCityId = _loc5_;
         this.FData.NightmareTrialLevelVec[_loc4_].SelectInfoVo.ResetGold = this.CurrentResetSpendGold(Vector.<int>(_loc6_.Value),_loc3_);
         this.SetNightmarePointState(_loc2_,0);
      }
      
      public function NightmareSkill_Ret(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TNightmareTrialLevelVo = null;
         var _loc7_:TSkillConfig = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc3_ = int(param1.readUnsignedInt());
         _loc9_ = int(param1.readUnsignedInt());
         _loc6_ = this.FData.GetNightmareTrialLevelVo(_loc3_);
         _loc6_.SelectInfoVo.CurrentRefreshTimes = _loc9_;
         _loc4_ = _loc6_.SelectInfoVo.CurrentCityId;
         _loc6_.SelectInfoVo.SkillInfoStr = "";
         _loc5_ = int(param1.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc5_)
         {
            _loc8_ = int(param1.readUnsignedInt());
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc8_) as TSkillConfig;
            _loc6_.SelectInfoVo.SkillInfoStr += _loc7_.Desc + "\n";
            _loc2_++;
         }
      }
      
      public function NightmareAttack_Ret(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.readUnsignedInt());
      }
      
      public function NightmareSelectCity_Ret(param1:ByteArray) : void
      {
      }
      
      public function NightmarePointInfo_Ret(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TNightmareTrialLevelVo = null;
         _loc2_ = int(param1.readUnsignedInt());
         _loc3_ = int(param1.readUnsignedInt());
         _loc4_ = this.FData.GetNightmareTrialLevelVo(_loc2_);
         _loc4_.SelectInfoVo.PassAmount = _loc3_;
         this.SetNightmarePointState(_loc2_,_loc4_.SelectInfoVo.CurrentCityId);
      }
   }
}

