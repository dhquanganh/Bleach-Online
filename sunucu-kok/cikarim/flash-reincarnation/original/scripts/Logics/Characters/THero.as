package Logics.Characters
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Common.Stubs.*;
   import Foundation.DataProtected.*;
   import Foundation.Resources.SResourcesCore;
   import Logics.CustomHero.TCurHero;
   import Logics.DatebaseVO.VO.TBaseEquip;
   import Logics.Inventories.*;
   import Logics.NijiaStar.*;
   import Logics.Skills.*;
   import Logics.Spaces.*;
   import Processors.Game.Utilities.Inventories.TUtilityInventory;
   import Resources.Constants.*;
   
   use namespace LogicsSpace;
   
   public class THero extends TEntity
   {
      
      protected static const CAPACITY_BaseAttributes:uint = CONST_COMMON.CAPACITY_BaseAttributes;
      
      protected static const BASEATTRIBUTEINDEX_Power:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Power;
      
      protected static const BASEATTRIBUTEINDEX_Intelligence:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Intelligence;
      
      protected static const BASEATTRIBUTEINDEX_Agile:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Agile;
      
      protected static const BASEATTRIBUTEINDEX_Life:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Life;
      
      protected static const BASEATTRIBUTEINDEX_Speed:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Speed;
      
      protected static const BASEATTRIBUTEINDEX_Health:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Health;
      
      protected static const BASEATTRIBUTEINDEX_PhysicalAttack:uint = CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalAttack;
      
      protected static const BASEATTRIBUTEINDEX_MagicAttack:uint = CONST_COMMON.BASEATTRIBUTEINDEX_MagicAttack;
      
      protected static const BASEATTRIBUTEINDEX_PhysicalDefends:uint = CONST_COMMON.BASEATTRIBUTEINDEX_PhysicalDefends;
      
      protected static const BASEATTRIBUTEINDEX_MagicDefends:uint = CONST_COMMON.BASEATTRIBUTEINDEX_MagicDefends;
      
      protected static const BASEATTRIBUTEINDEX_Hit:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Hit;
      
      protected static const BASEATTRIBUTEINDEX_Dodge:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Dodge;
      
      protected static const BASEATTRIBUTEINDEX_Crit:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Crit;
      
      protected static const BASEATTRIBUTEINDEX_GridFile:uint = CONST_COMMON.BASEATTRIBUTEINDEX_GridFile;
      
      protected static const BASEATTRIBUTEINDEX_Punch:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Punch;
      
      protected static const BASEATTRIBUTEINDEX_Help:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Help;
      
      protected static const BASEATTRIBUTEINDEX_Wreck:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Wreck;
      
      protected static const BASEATTRIBUTEINDEX_Uprising:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Uprising;
      
      protected static const BASEATTRIBUTEINDEX_Hurt:uint = CONST_COMMON.BASEATTRIBUTEINDEX_Hurt;
      
      protected static const BASEATTRIBUTEINDEX_FightingPower:uint = CONST_COMMON.BASEATTRIBUTEINDEX_FightingPower;
      
      protected static const BASEATTRIBUTEINDEX_AvoidhurtRate:uint = CONST_COMMON.BASEATTRIBUTEINDEX_AvoidhurtRate;
      
      protected static const CAPACITY_FirstAttributesRate:uint = CONST_COMMON.CAPACITY_FirstAttributesRate;
      
      protected static const FIRSTATTRIBUTERATEINDEX_Power:uint = CONST_COMMON.FIRSTATTRIBUTERATEINDEX_Power;
      
      protected static const FIRSTATTRIBUTERATEINDEX_Intelligence:uint = CONST_COMMON.FIRSTATTRIBUTERATEINDEX_Intelligence;
      
      protected static const FIRSTATTRIBUTERATEINDEX_Agile:uint = CONST_COMMON.FIRSTATTRIBUTERATEINDEX_Agile;
      
      protected static const FIRSTATTRIBUTERATEINDEX_Health:uint = CONST_COMMON.FIRSTATTRIBUTERATEINDEX_Health;
      
      protected static const CAPACITY_EquipmentsMounted:uint = CONST_CHARACTER.CAPACITY_EquipmentsMounted;
      
      protected static const CAPACITY_TalismansMounted:uint = CONST_CHARACTER.CAPACITY_TalismansMounted;
      
      protected static const CAPACITY_AccessoriesMounted:uint = CONST_CHARACTER.CAPACITY_AccessoriesMounted;
      
      protected static const CAPACITY_CrashJadeMounted:uint = CONST_CHARACTER.CAPACITY_CrashJadeMounted;
      
      protected static const CAPACITY_WakeEquipsMounted:uint = CONST_CHARACTER.CAPACITY_WakeEquipsMounted;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const PROFESSION_Agility:uint = CONST_CHARACTER.PROFESSION_Agility;
      
      protected static const PROFESSION_Defending:uint = CONST_CHARACTER.PROFESSION_Defending;
      
      protected static const PROFESSION_Intellect:uint = CONST_CHARACTER.PROFESSION_Intellect;
      
      protected static const PROFESSION_Strength:uint = CONST_CHARACTER.PROFESSION_Strength;
      
      protected static const PROPERTY_LEVEL:String = "HEROLEVEL";
      
      protected var FStubReferences:TStubReferences;
      
      protected var FName:String;
      
      protected var FProfession:uint;
      
      protected var FHistoryMaxLevel:uint;
      
      protected var FAssess:String;
      
      protected var FExperience:UInt64;
      
      protected var FSkill:TSkill;
      
      protected var FBaseAttributes:Vector.<Number>;
      
      protected var FPvPAttributes:Vector.<Number>;
      
      protected var FEquipmentsMounted:TCollectionInventory;
      
      protected var FTalismansMounted:TCollectionInventory;
      
      protected var FOrnamentsMounted:TCollectionInventory;
      
      protected var FCrashJadeMounted:TCollectionInventory;
      
      protected var FWakeEquipsNeed:TCollectionInventory;
      
      protected var FNijiaStars:TNijiaStars;
      
      protected var FFightPosition:int;
      
      protected var FMounted:Boolean;
      
      protected var FIsMain:Boolean;
      
      protected var FQuality:uint;
      
      protected var FIsNewEmployment:Boolean;
      
      protected var FTalentName:String;
      
      protected var FTalentDesc:String;
      
      protected var FNormalAttackName:String;
      
      protected var FFirstAttributesRate:Vector.<Number>;
      
      protected var FFirstAttributes:Vector.<uint>;
      
      protected var FModelID:uint;
      
      protected var FLargeID:uint;
      
      protected var FSmallID:uint;
      
      protected var FCrashJadeOpenLevel:Vector.<int>;
      
      protected var FChangeSchedule:int;
      
      protected var FAdvanceChanges:Vector.<Vector.<int>>;
      
      protected var FMainPetID:uint;
      
      protected var FVicePetHighID:uint;
      
      protected var FVicePetLowID:uint;
      
      protected var FWakeupLevel:int;
      
      protected var FWakeupStatus:int;
      
      protected var FWakeupEquipCount:int;
      
      protected var FHeroOverTime:uint;
      
      protected var FHeroCostGold:uint;
      
      protected var FRelatedPartnerPos:uint;
      
      protected var FCustomHero:TCurHero;
      
      protected var FRebirthLevel:uint;
      
      protected var FRebirthNum:uint;
      
      protected var FPropPower:uint;
      
      protected var FAttackEffect:uint;
      
      protected var FReduceLevel:int = -1;
      
      protected var FAddQuality:uint;
      
      public function THero(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FExperience = new UInt64();
         this.FSkill = new TSkill(0);
         this.FNijiaStars = new TNijiaStars();
         this.FBaseAttributes = new Vector.<Number>(CAPACITY_BaseAttributes);
         this.FPvPAttributes = new Vector.<Number>(CAPACITY_BaseAttributes);
         this.FEquipmentsMounted = new TCollectionInventory(CAPACITY_EquipmentsMounted);
         this.FTalismansMounted = new TCollectionInventory(CAPACITY_TalismansMounted);
         this.FOrnamentsMounted = new TCollectionInventory(CAPACITY_AccessoriesMounted);
         this.FCrashJadeMounted = new TCollectionInventory(CAPACITY_CrashJadeMounted);
         this.FWakeEquipsNeed = new TCollectionInventory(CAPACITY_WakeEquipsMounted);
         this.FFirstAttributesRate = new Vector.<Number>(CAPACITY_FirstAttributesRate);
         this.FFirstAttributes = new Vector.<uint>(CAPACITY_FirstAttributesRate);
         this.FAdvanceChanges = new Vector.<Vector.<int>>(7);
         this.FIsNewEmployment = false;
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      protected function GetSmallSpecialTreasure(param1:TEquipment) : TEquipment
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEquipment = null;
         var _loc5_:TEquipment = null;
         var _loc6_:TBaseEquip = null;
         var _loc7_:int = 0;
         _loc5_ = null;
         _loc3_ = int(CAPACITY_TalismansMounted);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FTalismansMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc4_ != null)
            {
               if(_loc4_.RequirementLevel >= 100)
               {
                  if(param1.RequirementLevel == _loc4_.RequirementLevel)
                  {
                     if(_loc5_ == null)
                     {
                        _loc5_ = _loc4_;
                     }
                     else if(_loc5_.UpgradingLevel > _loc4_.UpgradingLevel)
                     {
                        _loc5_ = _loc4_;
                     }
                  }
               }
            }
            _loc2_++;
         }
         if(_loc5_ != null)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,_loc5_.IDTemplate) as TBaseEquip;
            _loc7_ = _loc6_.SuitId + Math.floor(_loc5_.UpgradingLevel / 10);
            if(_loc5_.SuitID != _loc7_)
            {
               _loc5_.SuitID = _loc7_;
               TUtilityInventory.SuitDataCopy(_loc5_.SuitDataSelf,_loc5_.SuitData);
            }
         }
         return _loc5_;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Profession() : uint
      {
         return this.FProfession;
      }
      
      public function set Profession(param1:uint) : void
      {
         this.FProfession = param1;
      }
      
      public function get Level() : uint
      {
         return Math.max(this.FHistoryMaxLevel,this.FRebirthLevel);
      }
      
      public function get Experience() : UInt64
      {
         return this.FExperience;
      }
      
      public function set Experience(param1:UInt64) : void
      {
         this.FExperience = param1;
      }
      
      public function GetBaseAttributeByIndex(param1:int) : Number
      {
         return this.FBaseAttributes[param1];
      }
      
      public function SetBaseAttributeByIndex(param1:int, param2:Number) : void
      {
         this.FBaseAttributes[param1] = param2;
      }
      
      public function SetPvPAttributeByIndex(param1:int, param2:Number) : void
      {
         this.FPvPAttributes[param1] = param2;
      }
      
      public function GetPvPAttributeByIndex(param1:int) : Number
      {
         return this.FPvPAttributes[param1];
      }
      
      public function get BaseAttributePower() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Power] as Number;
      }
      
      public function set BaseAttributePower(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Power] = param1;
      }
      
      public function get BaseAttributeAgile() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Agile] as Number;
      }
      
      public function set BaseAttributeAgile(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Agile] = param1;
      }
      
      public function get BaseAttributeIntelligence() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Intelligence] as Number;
      }
      
      public function set BaseAttributeIntelligence(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Intelligence] = param1;
      }
      
      public function get BaseAttributeLife() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Life] as Number;
      }
      
      public function set BaseAttributeLife(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Life] = param1;
      }
      
      public function get BaseAttributeSpeed() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Speed] as Number;
      }
      
      public function set BaseAttributeSpeed(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Speed] = param1;
      }
      
      public function get BaseAttributeHealth() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Health] as Number;
      }
      
      public function set BaseAttributeHealth(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Health] = param1;
      }
      
      public function get BaseAttributePhysicalAttack() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_PhysicalAttack] as Number;
      }
      
      public function set BaseAttributePhysicalAttack(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_PhysicalAttack] = param1;
      }
      
      public function get BaseAttributeMagicAttack() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_MagicAttack] as Number;
      }
      
      public function set BaseAttributeMagicAttack(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_MagicAttack] = param1;
      }
      
      public function get BaseAttributePhysicalDefends() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_PhysicalDefends] as Number;
      }
      
      public function set BaseAttributePhysicalDefends(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_PhysicalDefends] = param1;
      }
      
      public function get BaseAttributeMagicDefends() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_MagicDefends] as Number;
      }
      
      public function set BaseAttributeMagicDefends(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_MagicDefends] = param1;
      }
      
      public function get BaseAttributeHit() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Hit] as Number;
      }
      
      public function set BaseAttributeHit(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Hit] = param1;
      }
      
      public function get BaseAttributeDodge() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Dodge] as Number;
      }
      
      public function set BaseAttributeDodge(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Dodge] = param1;
      }
      
      public function get BaseAttributeCrit() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Crit] as Number;
      }
      
      public function set BaseAttributeCrit(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Crit] = param1;
      }
      
      public function get BaseAttributeGridFile() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_GridFile] as Number;
      }
      
      public function set BaseAttributeGridFile(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_GridFile] = param1;
      }
      
      public function get BaseAttributePunch() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Punch] as Number;
      }
      
      public function set BaseAttributePunch(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Punch] = param1;
      }
      
      public function get BaseAttributeHelp() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Help] as Number;
      }
      
      public function set BaseAttributeHelp(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Help] = param1;
      }
      
      public function get BaseAttributeWreck() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Wreck] as Number;
      }
      
      public function set BaseAttributeWreck(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Wreck] = param1;
      }
      
      public function get BaseAttributeUprising() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Uprising] as Number;
      }
      
      public function set BaseAttributeUprising(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Uprising] = param1;
      }
      
      public function get BaseAttributeHurt() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Hurt] as Number;
      }
      
      public function set BaseAttributeHurt(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Hurt] = param1;
      }
      
      public function get BaseAttributeFightingPower() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_FightingPower] as Number;
      }
      
      public function set BaseAttributeFightingPower(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_FightingPower] = param1;
      }
      
      public function get BaseAttributeAvoidhurtRate() : Number
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_AvoidhurtRate] as Number;
      }
      
      public function set BaseAttributeAvoidhurtRate(param1:Number) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_AvoidhurtRate] = param1;
      }
      
      public function get PvPAttributePower() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Power] as Number;
      }
      
      public function set PvPAttributePower(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Power] = param1;
      }
      
      public function get PvPAttributeAgile() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Agile] as Number;
      }
      
      public function set PvPAttributeAgile(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Agile] = param1;
      }
      
      public function get PvPAttributeIntelligence() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Intelligence] as Number;
      }
      
      public function set PvPAttributeIntelligence(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Intelligence] = param1;
      }
      
      public function get PvPAttributeLife() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Life] as Number;
      }
      
      public function set PvPAttributeLife(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Life] = param1;
      }
      
      public function get PvPAttributeSpeed() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Speed] as Number;
      }
      
      public function set PvPAttributeSpeed(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Speed] = param1;
      }
      
      public function get PvPAttributeHealth() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Health] as Number;
      }
      
      public function set PvPAttributeHealth(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Health] = param1;
      }
      
      public function get PvPAttributePhysicalAttack() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_PhysicalAttack] as Number;
      }
      
      public function set PvPAttributePhysicalAttack(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_PhysicalAttack] = param1;
      }
      
      public function get PvPAttributeMagicAttack() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_MagicAttack] as Number;
      }
      
      public function set PvPAttributeMagicAttack(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_MagicAttack] = param1;
      }
      
      public function get PvPAttributePhysicalDefends() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_PhysicalDefends] as Number;
      }
      
      public function set PvPAttributePhysicalDefends(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_PhysicalDefends] = param1;
      }
      
      public function get PvPAttributeMagicDefends() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_MagicDefends] as Number;
      }
      
      public function set PvPAttributeMagicDefends(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_MagicDefends] = param1;
      }
      
      public function get PvPAttributeHit() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Hit] as Number;
      }
      
      public function set PvPAttributeHit(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Hit] = param1;
      }
      
      public function get PvPAttributeDodge() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Dodge] as Number;
      }
      
      public function set PvPAttributeDodge(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Dodge] = param1;
      }
      
      public function get PvPAttributeCrit() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Crit] as Number;
      }
      
      public function set PvPAttributeCrit(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Crit] = param1;
      }
      
      public function get PvPAttributeGridFile() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_GridFile] as Number;
      }
      
      public function set PvPAttributeGridFile(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_GridFile] = param1;
      }
      
      public function get PvPAttributePunch() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Punch] as Number;
      }
      
      public function set PvPAttributePunch(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Punch] = param1;
      }
      
      public function get PvPAttributeHelp() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Help] as Number;
      }
      
      public function set PvPAttributeHelp(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Help] = param1;
      }
      
      public function get PvPAttributeWreck() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Wreck] as Number;
      }
      
      public function set PvPAttributeWreck(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Wreck] = param1;
      }
      
      public function get PvPAttributeUprising() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Uprising] as Number;
      }
      
      public function set PvPAttributeUprising(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Uprising] = param1;
      }
      
      public function get PvPAttributeHurt() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_Hurt] as Number;
      }
      
      public function set PvPAttributeHurt(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_Hurt] = param1;
      }
      
      public function get PvPAttributeFightingPower() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_FightingPower] as Number;
      }
      
      public function set PvPAttributeFightingPower(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_FightingPower] = param1;
      }
      
      public function get PvPAttributeAvoidhurtRate() : Number
      {
         return this.FPvPAttributes[BASEATTRIBUTEINDEX_AvoidhurtRate] as Number;
      }
      
      public function set PvPAttributeAvoidhurtRate(param1:Number) : void
      {
         this.FPvPAttributes[BASEATTRIBUTEINDEX_AvoidhurtRate] = param1;
      }
      
      public function get EquipmentsMounted() : TCollectionInventory
      {
         return this.FEquipmentsMounted;
      }
      
      public function get WakeEquipsNeed() : TCollectionInventory
      {
         return this.FWakeEquipsNeed;
      }
      
      public function set WakeEquipsNeed(param1:TCollectionInventory) : void
      {
         this.FWakeEquipsNeed = param1;
      }
      
      public function get TalismansMounted() : TCollectionInventory
      {
         return this.FTalismansMounted;
      }
      
      public function get FightPosition() : int
      {
         return this.FFightPosition;
      }
      
      public function set FightPosition(param1:int) : void
      {
         this.FFightPosition = param1;
      }
      
      public function get Mounted() : Boolean
      {
         return this.FMounted;
      }
      
      public function set Mounted(param1:Boolean) : void
      {
         this.FMounted = param1;
      }
      
      public function get IsMain() : Boolean
      {
         return this.FIsMain;
      }
      
      public function set IsMain(param1:Boolean) : void
      {
         this.FIsMain = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get IsNewEmployment() : Boolean
      {
         return this.FIsNewEmployment;
      }
      
      public function set IsNewEmployment(param1:Boolean) : void
      {
         this.FIsNewEmployment = param1;
      }
      
      public function GetFirstAttributeRateByIndex(param1:int) : Number
      {
         return this.FFirstAttributesRate[param1];
      }
      
      public function SetFirstAttributeRateByIndex(param1:int, param2:Number) : void
      {
         this.FFirstAttributesRate[param1] = param2;
      }
      
      public function get FirstAttributePowerRate() : Number
      {
         return this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Power] as Number;
      }
      
      public function set FirstAttributePowerRate(param1:Number) : void
      {
         this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Power] = param1;
      }
      
      public function get FirstAttributeIntelligenceRate() : Number
      {
         return this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Intelligence] as Number;
      }
      
      public function set FirstAttributeIntelligenceRate(param1:Number) : void
      {
         this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Intelligence] = param1;
      }
      
      public function get FirstAttributeAgileRate() : Number
      {
         return this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Agile] as Number;
      }
      
      public function set FirstAttributeAgileRate(param1:Number) : void
      {
         this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Agile] = param1;
      }
      
      public function get FirstAttributeHealthRate() : Number
      {
         return this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Health] as Number;
      }
      
      public function set FirstAttributeHealthRate(param1:Number) : void
      {
         this.FFirstAttributesRate[FIRSTATTRIBUTERATEINDEX_Health] = param1;
      }
      
      public function GetFirstAttributeByIndex(param1:int) : Number
      {
         return this.FFirstAttributes[param1];
      }
      
      public function SetFirstAttributeByIndex(param1:int, param2:Number) : void
      {
         this.FFirstAttributes[param1] = param2;
      }
      
      public function get FirstAttributePower() : Number
      {
         return this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Power] as Number;
      }
      
      public function set FirstAttributePower(param1:Number) : void
      {
         this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Power] = param1;
      }
      
      public function get FirstAttributeIntelligence() : Number
      {
         return this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Intelligence] as Number;
      }
      
      public function set FirstAttributeIntelligence(param1:Number) : void
      {
         this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Intelligence] = param1;
      }
      
      public function get FirstAttributeAgile() : Number
      {
         return this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Agile] as Number;
      }
      
      public function set FirstAttributeAgile(param1:Number) : void
      {
         this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Agile] = param1;
      }
      
      public function get FirstAttributeHealth() : Number
      {
         return this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Health] as Number;
      }
      
      public function set FirstAttributeHealth(param1:Number) : void
      {
         this.FFirstAttributes[FIRSTATTRIBUTERATEINDEX_Health] = param1;
      }
      
      public function get TalentName() : String
      {
         return this.FTalentName;
      }
      
      public function set TalentName(param1:String) : void
      {
         this.FTalentName = param1;
      }
      
      public function get TalentDesc() : String
      {
         return this.FTalentDesc;
      }
      
      public function set TalentDesc(param1:String) : void
      {
         this.FTalentDesc = param1;
      }
      
      public function get ModelID() : uint
      {
         return this.FModelID;
      }
      
      public function set ModelID(param1:uint) : void
      {
         this.FModelID = param1;
      }
      
      public function get LargeID() : uint
      {
         return this.FLargeID;
      }
      
      public function set LargeID(param1:uint) : void
      {
         this.FLargeID = param1;
      }
      
      public function get SmallID() : uint
      {
         return this.FSmallID;
      }
      
      public function set SmallID(param1:uint) : void
      {
         this.FSmallID = param1;
      }
      
      public function get NormalAttackName() : String
      {
         return this.FNormalAttackName;
      }
      
      public function set NormalAttackName(param1:String) : void
      {
         this.FNormalAttackName = param1;
      }
      
      public function get StandPositionWithProfession() : uint
      {
         var _loc1_:uint = 0;
         switch(this.FProfession)
         {
            case PROFESSION_Agility:
            case PROFESSION_Strength:
               _loc1_ = uint(INDEX_Station_Middle);
               break;
            case PROFESSION_Defending:
               _loc1_ = uint(INDEX_Station_Front);
               break;
            case PROFESSION_Intellect:
               _loc1_ = uint(INDEX_Station_After);
               if(this.FIsMain)
               {
                  _loc1_ = uint(INDEX_Station_Middle);
               }
         }
         return _loc1_;
      }
      
      public function get Assess() : String
      {
         return this.FAssess;
      }
      
      public function set Assess(param1:String) : void
      {
         this.FAssess = param1;
      }
      
      public function get Skill() : TSkill
      {
         return this.FSkill;
      }
      
      public function set Skill(param1:TSkill) : void
      {
         this.FSkill = param1;
      }
      
      public function get NijiaStars() : TNijiaStars
      {
         return this.FNijiaStars;
      }
      
      public function set NijiaStars(param1:TNijiaStars) : void
      {
         this.FNijiaStars = param1;
      }
      
      public function get OrnamentsMounted() : TCollectionInventory
      {
         return this.FOrnamentsMounted;
      }
      
      public function get CrashJadeMounted() : TCollectionInventory
      {
         return this.FCrashJadeMounted;
      }
      
      public function get CrashJadeOpenLevel() : Vector.<int>
      {
         return this.FCrashJadeOpenLevel;
      }
      
      public function set CrashJadeOpenLevel(param1:Vector.<int>) : void
      {
         this.FCrashJadeOpenLevel = param1;
      }
      
      public function get ChangeSchedule() : int
      {
         return this.FChangeSchedule;
      }
      
      public function set ChangeSchedule(param1:int) : void
      {
         this.FChangeSchedule = param1;
      }
      
      public function get MainPetID() : uint
      {
         return this.FMainPetID;
      }
      
      public function set MainPetID(param1:uint) : void
      {
         this.FMainPetID = param1;
      }
      
      public function get VicePetHighID() : uint
      {
         return this.FVicePetHighID;
      }
      
      public function set VicePetHighID(param1:uint) : void
      {
         this.FVicePetHighID = param1;
      }
      
      public function get VicePetLowID() : uint
      {
         return this.FVicePetLowID;
      }
      
      public function set VicePetLowID(param1:uint) : void
      {
         this.FVicePetLowID = param1;
      }
      
      public function set CrashJadeMounted(param1:TCollectionInventory) : void
      {
         this.FCrashJadeMounted = param1;
      }
      
      public function set HeroOverTime(param1:uint) : void
      {
         this.FHeroOverTime = param1;
      }
      
      public function get HeroOverTime() : uint
      {
         return this.FHeroOverTime;
      }
      
      public function set HeroCostGold(param1:uint) : void
      {
         this.FHeroCostGold = param1;
      }
      
      public function get HeroCostGold() : uint
      {
         return this.FHeroCostGold;
      }
      
      public function get RelatedPartnerPos() : uint
      {
         return this.FRelatedPartnerPos;
      }
      
      public function set RelatedPartnerPos(param1:uint) : void
      {
         this.FRelatedPartnerPos = param1;
      }
      
      public function get WakeupLevel() : int
      {
         return this.FWakeupLevel;
      }
      
      public function set WakeupLevel(param1:int) : void
      {
         this.FWakeupLevel = param1;
      }
      
      public function get WakeupStatus() : int
      {
         return this.FWakeupStatus;
      }
      
      public function set WakeupStatus(param1:int) : void
      {
         this.FWakeupStatus = param1;
         this.SetWakeupEquipCount();
      }
      
      public function get WakeupEquipCount() : int
      {
         return this.FWakeupEquipCount;
      }
      
      public function set WakeupEquipCount(param1:int) : void
      {
         this.FWakeupEquipCount = param1;
      }
      
      public function get CustomHero() : TCurHero
      {
         return this.FCustomHero;
      }
      
      public function get RebirthLevel() : uint
      {
         return this.FRebirthLevel;
      }
      
      public function set CustomHero(param1:TCurHero) : void
      {
         this.FCustomHero = param1;
      }
      
      public function set RebirthLevel(param1:uint) : void
      {
         this.FRebirthLevel = param1;
      }
      
      public function get PropPower() : uint
      {
         return this.FPropPower;
      }
      
      public function set PropPower(param1:uint) : void
      {
         this.FPropPower = param1;
      }
      
      public function get AttackEffect() : uint
      {
         return this.FAttackEffect;
      }
      
      public function set AttackEffect(param1:uint) : void
      {
         this.FAttackEffect = param1;
      }
      
      public function get RebirthNum() : uint
      {
         return this.FRebirthNum;
      }
      
      public function set RebirthNum(param1:uint) : void
      {
         this.FRebirthNum = param1;
      }
      
      public function set HistoryMaxLevel(param1:uint) : void
      {
         this.FHistoryMaxLevel = param1;
      }
      
      public function get HistoryMaxLevel() : uint
      {
         return this.FHistoryMaxLevel;
      }
      
      public function get AddQuality() : uint
      {
         return this.FAddQuality;
      }
      
      public function set AddQuality(param1:uint) : void
      {
         this.FAddQuality = param1;
      }
      
      public function get AdvanceChanges() : Vector.<Vector.<int>>
      {
         return this.FAdvanceChanges;
      }
      
      public function set AdvanceChanges(param1:Vector.<Vector.<int>>) : void
      {
         this.FAdvanceChanges = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FName = "";
         this.FProfession = 0;
         this.FExperience.High = 0;
         this.FExperience.Low = 0;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BaseAttributes)
         {
            this.FBaseAttributes[_loc1_] = 0;
            _loc1_++;
         }
         this.FEquipmentsMounted.Clear();
         this.FTalismansMounted.Clear();
         this.FOrnamentsMounted.Clear();
         this.FWakeEquipsNeed.Clear();
         this.FWakeupStatus = 0;
         this.FFightPosition = -1;
         this.FMounted = false;
         this.FNijiaStars.Clear();
         this.FIsMain = false;
         this.FQuality = 0;
         this.FIsNewEmployment = false;
         this.FTalentName = "";
         this.FTalentDesc = "";
         this.FNormalAttackName = "";
         this.FModelID = 0;
         this.FLargeID = 0;
         this.FSmallID = 0;
         this.FMainPetID = 0;
         this.FVicePetHighID = 0;
         this.FVicePetLowID = 0;
         this.FChangeSchedule = 0;
         this.FHeroOverTime = 0;
         this.FHeroCostGold = 0;
         this.FRebirthLevel = 0;
         this.FRebirthNum = 0;
         this.FPropPower = 0;
         this.FAttackEffect = 0;
      }
      
      public function GetSuitCountByEquipment(param1:TEquipment) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         _loc3_ = int(CAPACITY_EquipmentsMounted);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FEquipmentsMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc5_ != null)
            {
               if(param1.SuitID == _loc5_.SuitID)
               {
                  _loc4_++;
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetSuitCountByTalisman(param1:TEquipment) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         _loc6_ = this.GetSmallSpecialTreasure(param1);
         if(_loc6_ == null)
         {
            return 0;
         }
         _loc4_ = 0;
         _loc3_ = int(CAPACITY_TalismansMounted);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FTalismansMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc5_ != null)
            {
               if(_loc5_.RequirementLevel >= 100)
               {
                  if(_loc5_.RequirementLevel == _loc6_.RequirementLevel)
                  {
                     if(_loc5_.UpgradingLevel > _loc6_.UpgradingLevel)
                     {
                        _loc5_.SuitID = _loc6_.SuitID;
                        TUtilityInventory.SuitDataCopy(_loc6_.SuitData,_loc5_.SuitData);
                     }
                     if(_loc6_.SuitID == _loc5_.SuitID)
                     {
                        _loc4_++;
                     }
                  }
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function GetSuitCountByOrnament(param1:TEquipment) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         _loc3_ = int(CAPACITY_AccessoriesMounted);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FOrnamentsMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            if(_loc5_ != null)
            {
               if(param1.SuitID == _loc5_.SuitID)
               {
                  _loc4_++;
               }
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function SetWakeupEquipCount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(CAPACITY_WakeEquipsMounted);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if((this.FWakeupStatus & 1 << _loc1_) != 0)
            {
               _loc3_++;
            }
            _loc1_++;
         }
         this.FWakeupEquipCount = _loc3_;
      }
      
      public function SetSuitCount(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TEquipment = null;
         _loc4_ = int(CAPACITY_EquipmentsMounted);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FEquipmentsMounted.GetInventoryByIndex(_loc3_) as TEquipment;
            if(_loc5_ != null)
            {
               if(param1.SuitID == _loc5_.SuitID)
               {
                  _loc5_.SuitCount = param2;
               }
            }
            _loc3_++;
         }
      }
      
      public function SetTreasureSuitCount(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TEquipment = null;
         _loc6_ = this.GetSmallSpecialTreasure(param1);
         if(_loc6_ == null)
         {
            return;
         }
         _loc4_ = int(CAPACITY_TalismansMounted);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FTalismansMounted.GetInventoryByIndex(_loc3_) as TEquipment;
            if(_loc5_ != null)
            {
               if(_loc6_.SuitID == _loc5_.SuitID)
               {
                  _loc5_.SuitCount = param2;
               }
            }
            _loc3_++;
         }
      }
      
      public function SetOrnamentSuitCount(param1:TEquipment, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TEquipment = null;
         _loc4_ = int(CAPACITY_AccessoriesMounted);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FOrnamentsMounted.GetInventoryByIndex(_loc3_) as TEquipment;
            if(_loc5_ != null)
            {
               if(param1.SuitID == _loc5_.SuitID)
               {
                  _loc5_.SuitCount = param2;
               }
            }
            _loc3_++;
         }
      }
   }
}

