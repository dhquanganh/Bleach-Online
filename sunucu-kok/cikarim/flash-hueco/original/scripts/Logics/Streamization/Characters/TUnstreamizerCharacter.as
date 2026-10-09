package Logics.Streamization.Characters
{
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.Buffs.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.KnifeSoul.TKnifeSoulData;
   import Logics.SLogicsCore;
   import Logics.Spaces.*;
   import Logics.Streamization.Buffs.*;
   import Logics.Streamization.CrashJade.TUnstreamizerCrashJadeData;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.Quest.*;
   import Logics.Streamization.Skills.*;
   import Logics.Vip.TVip;
   import Resources.Constants.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerCharacter extends TUnstreamizerCharacterUnknown
   {
      
      protected static const STARTINDEX_BaseAttribute:uint = 10;
      
      protected static const ENDINDEX_BaseAttribute:uint = 20;
      
      public static const INDEXEQUIPMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXEQUIPMENTMOUNTED;
      
      public static const INDEXORNAMENTMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXORNAMENTMOUNTED;
      
      public static const INDEXTREASUREMOUNTED:Vector.<uint> = CONST_INVENTORY.INDEXTREASUREMOUNTED;
      
      protected static const CAPACITY_WakeEquipsMounted:int = CONST_CHARACTER.CAPACITY_WakeEquipsMounted;
      
      protected var FUnstreamizerQuests:TUnstreamizerQuests;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FUnstreamizerInventories:TUnstreamizerInventories;
      
      protected var FUnstreamizerCrashJadeData:TUnstreamizerCrashJadeData;
      
      protected var FInventoryReference:TInventoryReference;
      
      protected var FUnstreamizerWakeEquip:TUnstreamizerWakeEquip;
      
      public function TUnstreamizerCharacter()
      {
         var _loc1_:int = 0;
         super();
         FUnstreamizerSkills = new TUnstreamizerSkills();
         FUnstreamizerSkill = new TUnstreamizerSkill();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FUnstreamizerInventories = new TUnstreamizerInventories();
         this.FUnstreamizerCrashJadeData = new TUnstreamizerCrashJadeData();
         this.FInventoryReference = new TInventoryReference();
         this.FUnstreamizerWakeEquip = new TUnstreamizerWakeEquip();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_BasicProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TCharacter = null;
         var _loc7_:TVip = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         _loc6_ = param2 as TCharacter;
         _loc7_ = _loc6_.VipData;
         _loc6_.AgentOperatorId = param1.readUnsignedInt();
         _loc6_.ServerId = param1.readUnsignedInt();
         _loc6_.AgentUserId = TUtilityString.FetchUTF(param1);
         _loc4_ = param1.readUnsignedInt();
         _loc5_ = param1.readUnsignedInt();
         _loc6_.Coerce(_loc4_,_loc5_);
         _loc6_.NickName = TUtilityString.FetchUTF(param1);
         _loc6_.Country = param1.readUnsignedInt();
         _loc6_.MilitaryRank = param1.readUnsignedInt();
         _loc6_.Prestige = param1.readUnsignedInt();
         _loc6_.CreditSilverCoin.High = param1.readUnsignedInt();
         _loc6_.CreditSilverCoin.Low = param1.readUnsignedInt();
         _loc6_.CreditGold = param1.readUnsignedInt();
         _loc6_.CreditGiftCertificate = param1.readUnsignedInt();
         _loc6_.CreditMilitaryOrders = param1.readUnsignedInt();
         _loc8_ = int(param1.readUnsignedInt());
         _loc9_ = int(param1.readUnsignedInt());
         _loc7_.CoercePropertieVipLevel(_loc8_);
         _loc7_.CoercePropertieVipExp(_loc9_);
         _loc6_.BackpackCapacity = param1.readUnsignedShort();
         _loc6_.BackpackExpandCount = param1.readUnsignedByte();
         _loc6_.TownID = param1.readUnsignedInt();
         _loc6_.StarMapIndex = param1.readUnsignedInt();
         _loc6_.GeneralsSoul = param1.readUnsignedInt();
         _loc6_.HeroSoulBlueSoul = param1.readUnsignedInt();
         _loc6_.HeroSoulPurpleSoul = param1.readUnsignedInt();
         _loc6_.HeroSoulGoldSoul = param1.readUnsignedInt();
         _loc6_.HeroSoulOrangeSoul = param1.readUnsignedInt();
      }
      
      protected function UnstreamizationPerform_BackpackCapacityByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCharacter = null;
         var _loc5_:TConfigValue = null;
         _loc4_ = param2 as TCharacter;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BACKPACK_InitCapacity) as TConfigValue;
         _loc4_.BackpackCapacity = _loc5_.Value as uint;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BACKPACK_InitTemporaryCapacity) as TConfigValue;
         _loc4_.BackpackTemporaryCapacity = _loc5_.Value as uint;
      }
      
      protected function UnstreamizationPerform_Quests(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCharacter = null;
         _loc4_ = param2 as TCharacter;
      }
      
      protected function UnstreamizationPerform_Heros(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THeros = null;
         var _loc7_:THero = null;
         _loc6_ = param2 as THeros;
         _loc6_.Clear();
         _loc4_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = FPoolCharacter.AcquireHero();
            this.UnstreamizationPerform_HeroProperties(param1,_loc7_,param3);
            this.UnstreamizationPerform_HeroByDatabase(param1,_loc7_,param3);
            _loc6_.Add(_loc7_);
            _loc5_++;
         }
      }
      
      protected function UnstreamizationPerform_KnifeSoul(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TKnifeSoulData = null;
         _loc4_ = param2 as TKnifeSoulData;
         _loc4_.ID = param1.readUnsignedInt();
         _loc4_.ChangedID = param1.readUnsignedInt();
         this.UnstreamizationPerform_KnifeSoulByDatabase(_loc4_);
      }
      
      protected function UnstreamizationPerform_HeroProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THero = null;
         _loc7_ = param2 as THero;
         _loc6_ = param1.readUnsignedInt();
         _loc7_.Coerce(_loc6_);
         _loc7_.RebirthLevel = param1.readUnsignedInt();
         _loc7_.Experience.High = param1.readUnsignedInt();
         _loc7_.Experience.Low = param1.readUnsignedInt();
         _loc7_.Profession = param1.readUnsignedByte();
         _loc7_.FightPosition = param1.readUnsignedByte();
         _loc7_.ChangeSchedule = param1.readUnsignedInt();
         _loc4_ = param1.readShort();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_.AdvanceChanges[param1.readByte() - 1] = new <int>[param1.readUnsignedInt(),param1.readUnsignedInt()];
            _loc5_++;
         }
         _loc7_.HeroOverTime = param1.readUnsignedInt();
         _loc7_.HeroCostGold = param1.readUnsignedInt();
         _loc7_.MainPetID = param1.readUnsignedInt();
         _loc7_.VicePetHighID = param1.readUnsignedInt();
         _loc7_.VicePetLowID = param1.readUnsignedInt();
         _loc7_.WakeupLevel = param1.readUnsignedInt();
         _loc7_.WakeupStatus = param1.readUnsignedInt();
         _loc7_.RelatedPartnerPos = param1.readUnsignedInt();
         if(_loc7_.FightPosition == 0)
         {
            _loc7_.Mounted = false;
         }
         else
         {
            _loc7_.Mounted = true;
         }
         _loc7_.RebirthNum = param1.readByte();
         _loc7_.PropPower = param1.readByte();
         _loc7_.AttackEffect = param1.readByte();
         _loc7_.HistoryMaxLevel = param1.readUnsignedInt();
         _loc7_.AddQuality = param1.readByte();
         param1.readUnsignedShort();
         FUnstreamizerSkill.Unstreamize(param1,_loc7_.Skill,param3);
         this.UnstreamizationPerform_BaseAttributes(param1,_loc7_,param3);
         this.UnstreamizationPerform_PvPAttributes(param1,_loc7_,param3);
         this.UnstreamizationPerform_GrowRateAttributes(param1,_loc7_,param3);
         this.UnstreamizationPerform_EquipmentsMounted(param1,_loc7_,param3);
         this.UnstreamizationPerform_CrashJadeMounted(param1,_loc7_,param3);
      }
      
      protected function InitInventoryWakes() : void
      {
         var _loc1_:TInventoryWake = null;
         var _loc2_:TBins = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_WakeUpEquip);
         _loc4_ = _loc2_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc2_.GetDatebaseByIndex(_loc3_).Identifier;
            _loc1_ = new TInventoryWake(_loc5_);
            _loc1_.IDTemplate = _loc5_;
            this.FUnstreamizerWakeEquip.UnstreamizationWakeEquip(_loc1_);
            this.FUnstreamizerWakeEquip.UnstreamizeGenerateInventory(null,_loc1_,null);
            SLogicsCore.Character.InventoryWakes.Add(_loc1_);
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_HeroByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         var _loc5_:TBaseHero = null;
         var _loc6_:THeroTalent = null;
         var _loc7_:TRoleModel = null;
         var _loc8_:TSkillConfig = null;
         var _loc9_:int = 0;
         var _loc10_:TWakeUp = null;
         var _loc11_:Vector.<int> = null;
         var _loc12_:TInventoryWake = null;
         _loc4_ = param2 as THero;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc4_.Identifier) as TBaseHero;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroTalent,_loc5_.Talent) as THeroTalent;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc4_.Identifier) as TRoleModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc5_.NormalAttack) as TSkillConfig;
         _loc4_.Name = _loc5_.Name;
         _loc4_.IsMain = _loc5_.IsMain;
         _loc4_.Quality = _loc5_.Quality + 0;
         _loc4_.CrashJadeOpenLevel = _loc5_.CrashJadeOpenLevel;
         _loc4_.TalentName = _loc6_.TalentName;
         _loc4_.TalentDesc = _loc6_.TalentDesc;
         _loc4_.NormalAttackName = _loc8_.Name;
         _loc4_.ModelID = _loc7_.Model;
         _loc4_.SmallID = _loc7_.RoleHead;
         _loc4_.LargeID = _loc7_.RoleStyle;
         _loc4_.Assess = _loc5_.Assess;
         if(SLogicsCore.Character.InventoryWakes.Count == 0)
         {
            this.InitInventoryWakes();
         }
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,_loc4_.Identifier) as TWakeUp;
         if(_loc10_ == null)
         {
            return;
         }
         _loc11_ = _loc10_.GetIndexsByWakeLevel(_loc4_.WakeupLevel);
         if(_loc11_ == null)
         {
            return;
         }
         _loc9_ = 0;
         while(_loc9_ < CAPACITY_WakeEquipsMounted)
         {
            if(_loc9_ < _loc11_.length)
            {
               _loc12_ = SLogicsCore.Character.InventoryWakes.GetInventoryByTempletID(_loc11_[_loc9_]) as TInventoryWake;
               _loc4_.WakeEquipsNeed.SetInventoryByIndex(_loc9_,_loc12_);
            }
            _loc9_++;
         }
      }
      
      protected function UnstreamizeGenerateHeroBaseAttributesByHero(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         var _loc5_:TBaseHero = null;
         _loc4_ = param2 as THero;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc4_.Identifier) as TBaseHero;
         _loc4_.BaseAttributePower = _loc5_.Power;
         _loc4_.BaseAttributeIntelligence = _loc5_.Intelligence;
         _loc4_.BaseAttributeAgile = _loc5_.Agile;
         _loc4_.BaseAttributeLife = _loc5_.Life;
         _loc4_.FirstAttributePowerRate = _loc5_.PowerGrow;
         _loc4_.FirstAttributeIntelligenceRate = _loc5_.IntelligenceGrow;
         _loc4_.FirstAttributeAgileRate = _loc5_.AgileGrow;
         _loc4_.FirstAttributeHealthRate = _loc5_.LifeGrow;
      }
      
      protected function UnstreamizationPerform_KnifeSoulByDatabase(param1:Object) : void
      {
         var _loc2_:TKnifeSoulData = null;
         var _loc3_:TKnifeSoul = null;
         var _loc4_:TKnifeExpand = null;
         var _loc5_:TKnife = null;
         var _loc6_:TBins = null;
         _loc2_ = param1 as TKnifeSoulData;
         if(_loc2_.ChangedID == 0)
         {
            _loc2_.CurrentModuleID = 0;
            _loc2_.CurrentName = "";
         }
         else
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,_loc2_.ChangedID) as TKnifeExpand;
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Knife,_loc4_.RelationID) as TKnife;
            _loc2_.CurrentModuleID = _loc4_.RelationID;
            _loc2_.CurrentName = _loc5_.Name;
         }
      }
      
      protected function UnstreamizationPerform_BaseAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc6_ = param2 as THero;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            switch(CONST_COMMON.BASSATTRIBUTENUMTYPE[_loc4_])
            {
               case CONST_COMMON.BASSATTRIBUTENUMTYPE_FLOAT:
                  _loc7_ = param1.readFloat();
                  _loc8_ = parseFloat(Number(_loc7_ * 100).toFixed(1));
                  _loc6_.SetBaseAttributeByIndex(_loc4_,_loc8_);
                  break;
               case CONST_COMMON.BASSATTRIBUTENUMTYPE_INTEGER:
                  _loc7_ = param1.readUnsignedInt();
                  _loc6_.SetBaseAttributeByIndex(_loc4_,_loc7_);
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_PvPAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THero = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc6_ = param2 as THero;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            switch(CONST_COMMON.BASSATTRIBUTENUMTYPE[_loc4_])
            {
               case CONST_COMMON.BASSATTRIBUTENUMTYPE_FLOAT:
                  _loc7_ = param1.readFloat();
                  _loc8_ = parseFloat(Number(_loc7_ * 100).toFixed(1));
                  _loc6_.SetPvPAttributeByIndex(_loc4_,_loc8_);
                  break;
               case CONST_COMMON.BASSATTRIBUTENUMTYPE_INTEGER:
                  _loc7_ = param1.readUnsignedInt();
                  _loc6_.SetPvPAttributeByIndex(_loc4_,_loc7_);
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_GrowRateAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:THero = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc5_ = param2 as THero;
         _loc9_ = CONST_COMMON.CAPACITY_FirstAttributesRate;
         _loc10_ = CONST_COMMON.CAPACITY_FirstAttributes;
         _loc8_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc10_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc5_.SetFirstAttributeByIndex(_loc4_,_loc6_);
            _loc4_++;
         }
         _loc8_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc9_)
         {
            _loc6_ = param1.readFloat();
            _loc7_ = parseFloat(Number(_loc6_).toFixed(1));
            _loc5_.SetFirstAttributeRateByIndex(_loc4_,_loc7_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_EquipmentsMounted(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         var _loc5_:TCollectionInventory = null;
         var _loc6_:TCollectionInventory = null;
         var _loc7_:TCollectionInventory = null;
         var _loc8_:TCollectionInventory = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:TInventory = null;
         var _loc12_:int = 0;
         _loc4_ = param2 as THero;
         _loc5_ = _loc4_.EquipmentsMounted;
         _loc7_ = _loc4_.TalismansMounted;
         _loc6_ = _loc4_.OrnamentsMounted;
         _loc6_.Clear();
         _loc5_.Clear();
         _loc7_.Clear();
         _loc9_ = int(param1.readUnsignedShort());
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            this.FUnstreamizerInventoryReference.Unstreamize(param1,this.FInventoryReference,param3);
            _loc11_ = this.FInventoryReference.Inventory;
            switch(_loc11_.Category)
            {
               case CATEGORY_Equipment:
                  _loc12_ = INDEXEQUIPMENTMOUNTED.indexOf(_loc11_.CategorySecond);
                  _loc8_ = _loc5_;
                  break;
               case CATEGORY_Treasure:
                  _loc12_ = INDEXTREASUREMOUNTED.indexOf(_loc11_.CategorySecond);
                  _loc11_.Coerce(_loc11_.CategorySecond);
                  _loc8_ = _loc7_;
                  break;
               case CATEGORY_Ornament:
                  _loc12_ = INDEXORNAMENTMOUNTED.indexOf(_loc11_.CategorySecond);
                  _loc8_ = _loc6_;
            }
            _loc8_.SetInventoryByIndex(_loc12_,_loc11_);
            this.FInventoryReference.Inventory = null;
            _loc10_++;
         }
      }
      
      protected function UnstreamizationPerform_CrashJadeMounted(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         _loc4_ = param2 as THero;
         _loc4_.CrashJadeMounted.Clear();
         this.FUnstreamizerCrashJadeData.UnstreamizationPerform_HeroJade(param1,_loc4_,null);
      }
      
      protected function UnstreamizationPerform_Inventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = param2 as TInventories;
         this.FUnstreamizerInventories.Unstreamize(param1,_loc4_,param3);
      }
      
      protected function UnstreamizationPerform_Classification_Inventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:TCharacter = null;
         var _loc9_:TInventory = null;
         var _loc10_:TInventories = null;
         var _loc11_:TInventories = null;
         var _loc12_:TInventories = null;
         var _loc13_:TInventories = null;
         var _loc14_:TInventories = null;
         var _loc15_:TInventories = null;
         var _loc16_:TInventories = null;
         var _loc17_:TInventories = null;
         _loc8_ = param2 as TCharacter;
         _loc10_ = _loc8_.Inventories;
         _loc11_ = _loc8_.Equipments;
         _loc13_ = _loc8_.Ornaments;
         _loc12_ = _loc8_.Appliances;
         _loc14_ = _loc8_.Gems;
         _loc15_ = _loc8_.Treasures;
         _loc16_ = _loc8_.Materials;
         _loc17_ = _loc8_.WakeEquip;
         _loc4_ = _loc10_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc9_ = _loc10_.GetInventoryByIndex(_loc5_);
            _loc6_ = _loc9_.Category;
            _loc7_ = this.InventoryClassByCategory(_loc6_);
            switch(_loc7_)
            {
               case CLASS_Appliance:
                  _loc12_.Add(_loc9_);
                  break;
               case CLASS_Equipment:
                  _loc11_.Add(_loc9_);
                  break;
               case CLASS_Gem:
                  _loc14_.Add(_loc9_);
                  break;
               case CLASS_Treasure:
                  _loc15_.Add(_loc9_);
                  break;
               case CLASS_Material:
                  _loc16_.Add(_loc9_);
                  break;
               case CLASS_Ornament:
                  _loc13_.Add(_loc9_);
                  break;
               case CLASS_WakeEquip:
                  _loc17_.Add(_loc9_);
            }
            _loc5_++;
         }
         _loc14_.Sort();
         _loc15_.Sort();
         _loc16_.Sort();
         _loc11_.Sort();
         _loc12_.Sort();
         _loc13_.Sort();
         _loc17_.Sort();
         _loc10_.Clear();
      }
      
      protected function InventoryClassByCategory(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case CATEGORY_Normal:
               _loc2_ = CLASS_Appliance;
               break;
            case CATEGORY_Equipment:
               _loc2_ = CLASS_Equipment;
               break;
            case CATEGORY_Ornament:
               _loc2_ = CLASS_Ornament;
               break;
            case CATEGORY_Gem:
               _loc2_ = CLASS_Gem;
               break;
            case CATEGORY_Treasure:
               _loc2_ = CLASS_Treasure;
               break;
            case CATEGORY_Material:
               _loc2_ = CLASS_Material;
               break;
            case CATEGORY_WakeEquip:
               _loc2_ = CLASS_WakeEquip;
         }
         return _loc2_;
      }
      
      protected function UnstreamizationPerform_TemporaryInventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = param2 as TInventories;
         this.FUnstreamizerInventories.Unstreamize(param1,_loc4_,param3);
         _loc4_.SortTime();
      }
      
      protected function UnstreamizationPerform_GenerateHerosByIdentifiers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TBins = null;
         var _loc9_:TBaseHero = null;
         var _loc10_:THeros = null;
         var _loc11_:THero = null;
         _loc10_ = param2 as THeros;
         _loc7_ = param3 as Vector.<uint>;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         _loc5_ = int(_loc7_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc7_[_loc4_];
            _loc9_ = _loc8_.GetDatebaseByIdentifier(_loc6_) as TBaseHero;
            _loc11_ = FPoolCharacter.AcquireHero(_loc6_);
            this.UnstreamizationPerform_GenerateHeroProperties(param1,_loc11_,_loc8_);
            this.UnstreamizationPerform_HeroByDatabase(param1,_loc11_,param3);
            this.UnstreamizeGenerateHeroBaseAttributesByHero(param1,_loc11_,_loc9_);
            _loc10_.Add(_loc11_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_GenerateHeroProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         var _loc5_:TBins = null;
         var _loc6_:TBaseHero = null;
         _loc4_ = param2 as THero;
         _loc5_ = param3 as TBins;
         _loc6_ = _loc5_.GetDatebaseByIdentifier(_loc4_.Identifier) as TBaseHero;
         _loc4_.RebirthLevel = _loc6_.Level;
         _loc4_.Experience.High = 0;
         _loc4_.Experience.Low = 0;
         _loc4_.Profession = _loc6_.Profession;
         _loc4_.FightPosition = 0;
         _loc4_.Mounted = false;
         FUnstreamizerSkills.UnstreamizeGenerateSkills(param1,_loc4_,param3);
      }
      
      public function UnstreamizeBasicProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_BasicProperties(param1,param2,param3);
         this.UnstreamizationPerform_BackpackCapacityByDatabase(param1,param2,param3);
      }
      
      public function UnstreamizeHeros(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Heros(param1,param2,param3);
      }
      
      public function UnstreamizeQuests(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Quests(param1,param2,param3);
      }
      
      public function UnstreamizeBuffsGlobal(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      public function UnstreamizeKnifeSoul(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_KnifeSoul(param1,param2,param3);
      }
      
      public function UnstreamizeFreshGuide(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:String = null;
         _loc4_ = TUtilityString.FetchUTF(param1);
         SLogicsCore.Character.FreshGuideProgress = _loc4_;
      }
      
      public function UnstreamizeEquipmentsMounted(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_EquipmentsMounted(param1,param2,param3);
      }
      
      public function UnstreamizeInventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Inventories(param1,param2,param3);
      }
      
      public function UnstreamizeClassificationInventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Classification_Inventories(param1,param2,param3);
      }
      
      public function UnstreamizeTemporaryInventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_TemporaryInventories(param1,param2,param3);
      }
      
      public function UnstreamizeBaseAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_BaseAttributes(param1,param2,param3);
      }
      
      public function UnstreamizePvPAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_PvPAttributes(param1,param2,param3);
      }
      
      public function UnstreamizeGrowUpAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GrowRateAttributes(param1,param2,param3);
      }
      
      public function UnstreamizeGenerateHerosByIdentifiers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateHerosByIdentifiers(param1,param2,param3);
      }
   }
}

