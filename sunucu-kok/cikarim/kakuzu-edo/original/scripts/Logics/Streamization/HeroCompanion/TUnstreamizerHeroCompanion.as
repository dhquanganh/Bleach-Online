package Logics.Streamization.HeroCompanion
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.DatebaseVO.VO.TCompanionChip;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TVipConfig;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Logics.HeroCompanion.THeroCompanionData;
   import Logics.HeroCompanion.THeroCompanionSeatData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHeroCompanion extends TUnstreamizer
   {
      
      protected static const Status_Entered:int = 1;
      
      protected var FSilverConfig:TConfigValue;
      
      protected var FGoldConfig:TConfigValue;
      
      public function TUnstreamizerHeroCompanion()
      {
         super();
      }
      
      public function UnstreamizationInitCard(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroCompanionData = null;
         var _loc5_:TBins = null;
         var _loc6_:TBins = null;
         var _loc7_:TConfigValue = null;
         var _loc8_:TCompanionCard = null;
         var _loc9_:TCompanionChip = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:String = null;
         _loc4_ = param1 as THeroCompanionData;
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_CompanionCard);
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = _loc5_.GetDatebaseByIndex(_loc2_) as TCompanionCard;
            _loc4_.CardDatas.AddCardData(_loc8_,_loc8_.BeginStar == 1);
            _loc4_.AddChipData(_loc8_.ChipId,0,_loc8_.Identifier);
            _loc2_++;
         }
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_SilverOne) as TConfigValue;
         _loc4_.SilverOneCosts = Vector.<int>(_loc7_.Value);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_SilverTen) as TConfigValue;
         _loc4_.SilverTenCosts = Vector.<int>(_loc7_.Value);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_GoldOne) as TConfigValue;
         _loc4_.GoldOneCosts = Vector.<int>(_loc7_.Value);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_GoldTen) as TConfigValue;
         _loc4_.GoldTenCosts = Vector.<int>(_loc7_.Value);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_EncounterOne) as TConfigValue;
         _loc4_.EncounterOneCosts = Vector.<int>(_loc7_.Value);
         _loc7_ = _loc6_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_EncounterTen) as TConfigValue;
         _loc4_.EncounterTenCosts = Vector.<int>(_loc7_.Value);
      }
      
      public function UnstreamizationInfo(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TBins = null;
         var _loc13_:TVipConfig = null;
         var _loc14_:TBins = null;
         var _loc15_:TConfigValue = null;
         var _loc16_:Vector.<int> = null;
         var _loc17_:THeroCompanionSeatData = null;
         var _loc18_:int = 0;
         _loc4_ = param2 as THeroCompanionData;
         this.FSilverConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Companion_SilverFree) as TConfigValue;
         _loc7_ = int(param1.readUnsignedInt());
         _loc4_.SilverEmployTime = _loc7_ + this.FSilverConfig.Value;
         this.FGoldConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Companion_GoldFree) as TConfigValue;
         _loc7_ = int(param1.readUnsignedInt());
         _loc4_.GoldEmployTime = _loc7_ + this.FGoldConfig.Value;
         _loc4_.EncounterId = param1.readUnsignedInt();
         _loc14_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc15_ = _loc14_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_VipUnlock) as TConfigValue;
         _loc16_ = Vector.<int>(_loc15_.Value);
         _loc4_.SeatVips.length = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc16_.length)
         {
            if(_loc16_[_loc6_] > SLogicsCore.Character.VipLevel)
            {
               _loc17_ = new THeroCompanionSeatData();
               _loc17_.NeedFever = 0;
               _loc17_.NeedVip = _loc16_[_loc6_];
               _loc17_.SeatCardId = 0;
               _loc4_.SeatVips.push(_loc17_);
            }
            _loc6_++;
         }
         _loc4_.Fever = param1.readUnsignedInt();
         _loc15_ = _loc14_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Companion_LvExp) as TConfigValue;
         _loc16_ = Vector.<int>(_loc15_.Value);
         _loc7_ = int(_loc16_.length);
         _loc4_.SeatFever.length = 0;
         _loc18_ = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc18_ += _loc16_[_loc6_];
            if(_loc16_[_loc6_] > _loc4_.Fever)
            {
               _loc17_ = new THeroCompanionSeatData();
               _loc17_.NeedFever = _loc16_[_loc6_];
               _loc17_.NeedVip = 0;
               _loc17_.SeatCardId = 0;
               _loc4_.SeatFever.push(_loc17_);
            }
            _loc6_++;
         }
         _loc4_.TotalFever = _loc18_;
         _loc5_ = int(param1.readUnsignedInt());
         _loc4_.EncounterStatus = _loc5_ == Status_Entered;
         _loc4_.SeatCount = param1.readUnsignedInt();
         param1.readUnsignedShort();
         _loc4_.SilverOneCount = param1.readUnsignedInt();
         _loc4_.SilverTenCount = param1.readUnsignedInt();
         _loc4_.GoldOneCount = param1.readUnsignedInt();
         _loc4_.GoldTenCount = param1.readUnsignedInt();
         _loc4_.EncounterOneCount = param1.readUnsignedInt();
         _loc4_.EncounterTenCount = param1.readUnsignedInt();
         _loc7_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = int(param1.readUnsignedInt());
            _loc9_ = int(param1.readUnsignedInt());
            _loc4_.CardDatas.SetCardStatus(_loc8_,_loc9_);
            _loc6_++;
         }
         _loc7_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc10_ = int(param1.readUnsignedInt());
            _loc11_ = int(param1.readUnsignedInt());
            _loc4_.AddChipData(_loc10_,_loc11_);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.SeatVips.length)
         {
            if(_loc4_.SeatVips[_loc6_].NeedVip > SLogicsCore.Character.VipLevel)
            {
               break;
            }
            _loc4_.SeatVips.splice(_loc6_,1);
            _loc6_++;
         }
         _loc12_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc7_ = _loc12_.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc13_ = _loc12_.GetDatebaseByIndex(_loc6_) as TVipConfig;
            _loc6_++;
         }
      }
      
      public function UnstreamizationEmploy(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TCompanionCard = null;
         var _loc13_:THeroCompanionChipData = null;
         var _loc14_:THeroCompanionChipData = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc4_.Fever = param1.readUnsignedInt();
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = int(param1.readUnsignedInt());
         _loc7_ = int(param1.readUnsignedInt());
         if(_loc5_ == CONST_HEROCOMPANION.SendType_EmployOne)
         {
            if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmploySilver)
            {
               _loc4_.SilverOneCount = _loc7_;
            }
            else if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmployGold)
            {
               _loc4_.GoldOneCount = _loc7_;
            }
            else if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmployEncounter)
            {
               _loc4_.EncounterOneCount = _loc7_;
            }
         }
         else if(_loc5_ == CONST_HEROCOMPANION.SendType_EmployTen)
         {
            if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmploySilver)
            {
               _loc4_.SilverTenCount = _loc7_;
            }
            else if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmployGold)
            {
               _loc4_.GoldTenCount = _loc7_;
            }
            else if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmployEncounter)
            {
               _loc4_.EncounterTenCount = _loc7_;
            }
         }
         _loc4_.CardResults.length = 0;
         _loc7_ = int(param1.readUnsignedShort());
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = int(param1.readUnsignedInt());
            _loc4_.CardDatas.SetCardStatus(_loc9_,0);
            _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,_loc9_) as TCompanionCard;
            _loc4_.CardResults.push(_loc12_);
            _loc8_++;
         }
         _loc4_.ChipResults.length = 0;
         _loc7_ = int(param1.readUnsignedShort());
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = int(param1.readUnsignedInt());
            _loc10_ = int(param1.readUnsignedInt());
            _loc5_ = int(param1.readUnsignedInt());
            _loc13_ = _loc4_.AddChipData(_loc9_,_loc10_,0,true);
            _loc13_.TypeId = _loc5_;
            _loc14_ = new THeroCompanionChipData();
            _loc14_.Format(_loc13_);
            _loc14_.Amount = _loc10_;
            _loc4_.ChipResults.push(_loc14_);
            _loc8_++;
         }
         _loc11_ = int(param1.readUnsignedInt());
         if(_loc11_ <= 0)
         {
            return;
         }
         if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmploySilver)
         {
            _loc4_.SilverEmployTime = _loc11_ + this.FSilverConfig.Value;
         }
         else if(_loc6_ == CONST_HEROCOMPANION.SendCost_EmployGold)
         {
            _loc4_.GoldEmployTime = _loc11_ + this.FSilverConfig.Value;
         }
      }
      
      public function UnstreamizationSeated(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = param2 as THeroCompanionData;
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = int(param1.readUnsignedInt());
         _loc4_.CardDatas.SetCardStatus(_loc5_,_loc6_);
      }
      
      public function UnstreamizationUnSeated(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as THeroCompanionData;
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = int(param1.readUnsignedInt());
         _loc4_.CardDatas.SetCardStatus(_loc5_,0);
         _loc8_ = int(_loc4_.SeatDatas.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            if(_loc4_.SeatDatas[_loc7_].SeatCardId == _loc5_)
            {
               _loc4_.SeatDatas.splice(_loc7_,1);
               break;
            }
            _loc7_++;
         }
      }
      
      public function UnstreamizationUpgrate(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TCompanionCard = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = int(param1.readUnsignedInt());
         _loc4_.CardDatas.SetCardStatus(_loc5_);
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,_loc5_) as TCompanionCard;
         _loc4_.AddChipData(_loc7_.ChipId,_loc6_);
         _loc4_.ServerState = CONST_HEROCOMPANION.EffectType_Upgrade;
      }
      
      public function UnstreamizationCompose(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TCompanionCard = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc5_ = int(param1.readUnsignedInt());
         _loc6_ = int(param1.readUnsignedInt());
         _loc4_.CardDatas.SetCardStatus(_loc5_,0);
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,_loc5_) as TCompanionCard;
         _loc4_.AddChipData(_loc7_.ChipId,_loc6_);
         _loc4_.ServerState = CONST_HEROCOMPANION.EffectType_Compose;
      }
      
      public function UnstreamizationReforging(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TCompanionCard = null;
         var _loc10_:THeroCompanionChipData = null;
         var _loc11_:String = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc6_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = int(param1.readUnsignedInt());
            _loc8_ = int(param1.readUnsignedInt());
            if(_loc5_ == 1)
            {
               _loc10_ = _loc4_.GetChipByChipId(_loc7_);
               _loc11_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_30),_loc10_.ChipData.Name,_loc8_ - _loc10_.Amount);
               SToolReward.ShowMessage(_loc11_);
            }
            _loc4_.AddChipData(_loc7_,_loc8_);
            _loc5_++;
         }
      }
      
      public function UnstreamizationCostRefresh(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc4_.SilverOneCount = 0;
         _loc4_.SilverTenCount = 0;
         _loc4_.GoldOneCount = 0;
         _loc4_.GoldTenCount = 0;
         _loc4_.EncounterOneCount = 0;
         _loc4_.EncounterTenCount = 0;
      }
      
      public function UnstreamizationEncounterRefresh(param1:ByteArray, param2:Object, param3:Object = null) : void
      {
         var _loc4_:THeroCompanionData = null;
         _loc4_ = param2 as THeroCompanionData;
         _loc4_.EncounterId = param1.readUnsignedInt();
         _loc4_.EncounterStatus = false;
      }
   }
}

