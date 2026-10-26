package Logics.Streamization.Inventories
{
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Spaces.*;
   import Processors.Game.Utilities.Inventories.TUtilityInventory;
   import Resources.Constants.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerEquipment extends TUnstreamizerInventory
   {
      
      protected var FUnstreamizerAppendAttributes:TUnstreamizerEquipmentAppendAttributes;
      
      protected var FUnstreamizerAppliance:TUnstreamizerAppliance;
      
      public function TUnstreamizerEquipment()
      {
         super();
         this.FUnstreamizerAppendAttributes = new TUnstreamizerEquipmentAppendAttributes();
         this.FUnstreamizerAppliance = new TUnstreamizerAppliance();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform(param1,param2,param3);
         this.UnstreamizationPerform_EquipmentProperties(param1,param2,param3);
         this.UnstreamizationPerform_EquipmentByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_EquipmentProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TEquipment = null;
         var _loc7_:TEquipmentAppendAttributes = null;
         var _loc8_:TGiftedStoneItems = null;
         var _loc9_:TAppliance = null;
         _loc6_ = param2 as TEquipment;
         _loc6_.UpgradingLevel = param1.readUnsignedByte();
         _loc6_.HoleAdditionalQuantity = param1.readUnsignedByte();
         _loc7_ = _loc6_.AppendAttributes;
         this.FUnstreamizerAppendAttributes.Unstreamize(param1,_loc7_,param3);
         _loc6_.WeaponSkillID = param1.readUnsignedInt();
         _loc6_.FlushSpiritLevel = param1.readUnsignedInt();
         _loc8_ = _loc6_.GiftedStoneItems;
         _loc8_.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = FPoolInventory.AcquireAppliance();
            _loc9_.Category = param1.readUnsignedByte();
            _loc9_.IDTemplate = param1.readUnsignedInt();
            this.FUnstreamizerAppliance.UnstreamizeAdditionalDataAppliance(param1,_loc9_,param3);
            _loc8_.Add(_loc9_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_EquipmentByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TWeaponSkillConfig = null;
         var _loc8_:TSuit = null;
         var _loc9_:TBaseEquip = null;
         var _loc10_:uint = 0;
         var _loc11_:TBuildValue = null;
         var _loc12_:uint = 0;
         var _loc13_:TTreasureUpgrade = null;
         var _loc14_:TBins = null;
         var _loc15_:TBuildConsume = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:TEquipment = null;
         var _loc22_:TSuitData = null;
         var _loc23_:TSuitEffect = null;
         var _loc24_:TEquipUpgrade = null;
         var _loc25_:TOrnamentValue = null;
         var _loc26_:TConfigValue = null;
         var _loc27_:Vector.<uint> = null;
         var _loc28_:Number = NaN;
         var _loc29_:uint = 0;
         var _loc30_:TTempleValue = null;
         var _loc31_:TBins = null;
         _loc21_ = param1 as TEquipment;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,_loc21_.IDTemplate) as TBaseEquip;
         if(_loc21_.Category == CATEGORY_Equipment)
         {
            _loc24_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EquipUpgrade,_loc21_.IDTemplate) as TEquipUpgrade;
         }
         switch(_loc21_.Category)
         {
            case CATEGORY_Equipment:
               if(_loc21_.UpgradingLevel > 0)
               {
                  _loc10_ = CONST_SMITHY.GetBuildValueID(_loc21_.UpgradingLevel,_loc21_.Quality,_loc21_.CategorySecond);
                  _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildValue,_loc10_) as TBuildValue;
                  if(_loc21_.UpgradingBasisProperty.length <= 0)
                  {
                     _loc21_.UpgradingBasisProperty.push(_loc11_.Value);
                  }
                  else
                  {
                     _loc21_.UpgradingBasisProperty[0] = _loc11_.Value;
                  }
                  _loc14_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuildConsume);
                  _loc4_ = int(_loc21_.UpgradingLevel);
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc16_ = int(CONST_SMITHY.GetBuildConsumeID(_loc21_.Quality,_loc3_));
                     _loc15_ = _loc14_.GetDatebaseByIdentifier(_loc16_) as TBuildConsume;
                     _loc18_ += _loc15_.Consume;
                     _loc3_++;
                  }
                  _loc21_.SellingValue = _loc18_ * 0.8;
               }
               else
               {
                  _loc21_.SellingValue = 0;
               }
               _loc10_ = _loc21_.CategorySecond * 10000 + _loc21_.Quality * 1000 + _loc21_.UpgradingLevel + 1;
               _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildValue,_loc10_) as TBuildValue;
               if(_loc11_ != null)
               {
                  _loc21_.GrowthRate = _loc11_.AddValue;
               }
               break;
            case CATEGORY_Treasure:
               if(_loc21_.UpgradingLevel > 0)
               {
                  _loc12_ = this.GetUpgradingValue(_loc21_.IDTemplate,_loc21_.UpgradingLevel);
                  _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TreasureUpgrade,_loc12_) as TTreasureUpgrade;
                  _loc4_ = int(_loc13_.AddValue.length);
                  _loc21_.UpgradingBasisProperty.length = 0;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc21_.UpgradingBasisProperty.push(_loc13_.AddValue[_loc3_]);
                     _loc3_++;
                  }
               }
               _loc17_ = int(_loc21_.SellValue);
               _loc19_ = int(_loc21_.UpgradingLevel);
               _loc20_ = int(_loc21_.Quality);
               _loc21_.SellingValue = _loc17_ * _loc19_ * _loc20_ * 0.1;
               break;
            case CATEGORY_Ornament:
               if(_loc21_.UpgradingLevel > 0)
               {
                  _loc31_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrnamentValue);
                  _loc4_ = _loc31_.Count;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc25_ = _loc31_.GetDatebaseByIndex(_loc3_) as TOrnamentValue;
                     if(_loc25_.ItemID == _loc21_.IDTemplate && _loc25_.Level == _loc21_.UpgradingLevel)
                     {
                        _loc21_.UpgradingBasisProperty.push(_loc25_.AddValue);
                        break;
                     }
                     _loc3_++;
                  }
               }
         }
         _loc4_ = int(_loc9_.DressProfessions.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc21_.RequirementCareer[_loc3_] = _loc9_.DressProfessions[_loc3_];
            _loc3_++;
         }
         _loc21_.HoleAdditionalMax = _loc9_.DrillHoleNum;
         _loc21_.BasisPropertyCategory.length = 0;
         _loc21_.BasisProperty.length = 0;
         _loc4_ = int(_loc9_.MainType.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc21_.BasisPropertyCategory.push(_loc9_.MainType[_loc3_]);
            _loc21_.BasisProperty.push(_loc9_.MainValue[_loc3_]);
            _loc3_++;
         }
         _loc21_.MaxAdditionalCount = _loc9_.MaxAdditionalCount;
         _loc21_.FlushSpiritCoefficient = _loc9_.FlushSpiritCoefficient;
         if(_loc21_.FlushSpiritCoefficient != 0 && _loc21_.FlushSpiritLevel != 0)
         {
            _loc26_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_FlushSpiritMapID) as TConfigValue;
            _loc27_ = _loc26_.Value as Vector.<uint>;
            _loc26_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SkyTower_AddtionAddParamterID) as TConfigValue;
            _loc28_ = _loc26_.Value as Number;
            _loc4_ = int(_loc27_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc21_.RequirementLevel < _loc27_[_loc3_])
               {
                  break;
               }
               _loc3_++;
            }
            _loc3_--;
            _loc29_ = _loc27_[_loc3_] * 1000 + _loc21_.CategorySecond * 100 + _loc21_.FlushSpiritLevel;
            _loc30_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TempleValue,_loc29_) as TTempleValue;
            _loc21_.UpgradingFlushSpiritBasisProperty = _loc30_.LevelCoefficient * _loc21_.FlushSpiritCoefficient * _loc30_.TypeCoefficient * (_loc21_.UpgradingLevel + _loc28_);
         }
         if(_loc21_.WeaponSkillID > 0)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WeaponSkillConfig,_loc21_.WeaponSkillID) as TWeaponSkillConfig;
            _loc21_.WeaponSkillName = _loc7_.Name;
            _loc21_.WeaponSkillDesc = _loc7_.Desc;
         }
         _loc21_.HoleQuantity = _loc9_.HoleCount;
         _loc22_ = _loc21_.SuitData;
         if(_loc21_.Category == CONST_INVENTORY.CATEGORY_Treasure && _loc21_.RequirementLevel >= 100)
         {
            _loc21_.SuitID = _loc9_.SuitId + Math.floor(_loc21_.UpgradingLevel / 10);
         }
         else
         {
            _loc21_.SuitID = _loc9_.SuitId;
         }
         if(_loc21_.SuitID > 0)
         {
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Suit,_loc21_.SuitID) as TSuit;
            if(_loc8_ != null)
            {
               _loc22_.Name = _loc8_.Name;
               _loc22_.MaxCount = _loc8_.MaxCount;
               _loc4_ = int(_loc8_.SuitEffects.length);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc23_ = FPoolInventory.AcquireSuitEffect();
                  _loc23_.SuitQuantity = _loc8_.SuitEffects[_loc3_].SuitQuantity;
                  _loc23_.Category = _loc8_.SuitEffects[_loc3_].Category;
                  _loc23_.Value = _loc8_.SuitEffects[_loc3_].Value;
                  _loc23_.Percentage = _loc8_.SuitEffects[_loc3_].Percentage;
                  _loc22_.SuitEffects.Add(_loc23_);
                  _loc3_++;
               }
            }
         }
         if(_loc21_.RequirementLevel >= 100)
         {
            TUtilityInventory.SuitDataCopy(_loc22_,_loc21_.SuitDataSelf);
         }
         if(_loc24_ != null)
         {
            _loc21_.IsAdvancedEquip = true;
         }
         else
         {
            _loc21_.IsAdvancedEquip = false;
         }
         _loc21_.IsEdgeColor = _loc9_.EdgeColor;
      }
      
      override protected function UnstreamizationPerform_QuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform_QuestReward(param1,param2,param3);
         this.UnstreamizationPerform_QREquipmentProperties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_QREquipmentProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TEquipment = null;
         _loc4_ = param2 as TEquipment;
      }
      
      protected function UnstreamizationPerform_GenerateEquipmentProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TEquipment = null;
         var _loc5_:TBaseEquip = null;
         _loc4_ = param2 as TEquipment;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,_loc4_.IDTemplate) as TBaseEquip;
         _loc4_.SuitID = _loc5_.SuitId;
      }
      
      protected function GetUpgradingValue(param1:uint, param2:int) : uint
      {
         return Math.floor(param1 % 1000) * 1000 + param2;
      }
      
      override public function UnstreamizeGenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizeGenerateInventory(param1,param2,param3);
         this.UnstreamizationPerform_GenerateEquipmentProperties(param1,param2,param3);
         this.UnstreamizationPerform_EquipmentByDatabase(param2,param3);
      }
   }
}

