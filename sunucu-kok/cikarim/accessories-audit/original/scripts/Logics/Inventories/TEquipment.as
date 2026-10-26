package Logics.Inventories
{
   import Resources.Constants.*;
   
   public class TEquipment extends TInventory
   {
      
      protected var CAPACITY_SuitEffects:uint = 3;
      
      protected var FRequirementCareer:Vector.<uint>;
      
      protected var FUpgradingLevel:uint;
      
      protected var FBasisPropertyCategory:Vector.<int>;
      
      protected var FBasisProperty:Vector.<int>;
      
      protected var FUpgradingBasisProperty:Vector.<int>;
      
      protected var FUpgradingFlushSpiritBasisProperty:uint;
      
      protected var FMaxAdditionalCount:uint;
      
      protected var FAppendAttributes:TEquipmentAppendAttributes;
      
      protected var FWeaponSkillID:uint;
      
      protected var FWeaponSkillName:String;
      
      protected var FWeaponSkillDesc:String;
      
      protected var FHoleQuantity:uint;
      
      protected var FHoleAdditionalQuantity:uint;
      
      protected var FHoleAdditionalMax:uint;
      
      protected var FGiftedStoneItems:TGiftedStoneItems;
      
      protected var FSuitID:int;
      
      protected var FSuitData:TSuitData;
      
      protected var FSuitDataSelf:TSuitData;
      
      protected var FSuitCount:int;
      
      protected var FIsAdvancedEquip:Boolean;
      
      protected var FIsEdgeColor:uint;
      
      protected var FGrowthRate:uint;
      
      protected var FFlushSpiritCoefficient:Number;
      
      protected var FFlushSpiritLevel:uint;
      
      public function TEquipment(param1:uint)
      {
         super(param1);
         this.FRequirementCareer = new Vector.<uint>();
         this.FAppendAttributes = new TEquipmentAppendAttributes();
         this.FGiftedStoneItems = new TGiftedStoneItems();
         this.FBasisPropertyCategory = new Vector.<int>();
         this.FBasisProperty = new Vector.<int>();
         this.FUpgradingBasisProperty = new Vector.<int>();
         this.FWeaponSkillName = "";
         this.FWeaponSkillDesc = "";
         this.FSuitData = new TSuitData();
         this.FSuitDataSelf = new TSuitData();
         this.FIsAdvancedEquip = false;
      }
      
      public function get RequirementCareer() : Vector.<uint>
      {
         return this.FRequirementCareer;
      }
      
      public function set RequirementCareer(param1:Vector.<uint>) : void
      {
         this.FRequirementCareer = param1;
      }
      
      public function get UpgradingLevel() : uint
      {
         return this.FUpgradingLevel;
      }
      
      public function set UpgradingLevel(param1:uint) : void
      {
         this.FUpgradingLevel = param1;
      }
      
      public function get BasisPropertyCategory() : Vector.<int>
      {
         return this.FBasisPropertyCategory;
      }
      
      public function get BasisProperty() : Vector.<int>
      {
         return this.FBasisProperty;
      }
      
      public function get UpgradingBasisProperty() : Vector.<int>
      {
         return this.FUpgradingBasisProperty;
      }
      
      public function get UpgradingFlushSpiritBasisProperty() : uint
      {
         return this.FUpgradingFlushSpiritBasisProperty;
      }
      
      public function set UpgradingFlushSpiritBasisProperty(param1:uint) : void
      {
         this.FUpgradingFlushSpiritBasisProperty = param1;
      }
      
      public function get MaxAdditionalCount() : uint
      {
         return this.FMaxAdditionalCount;
      }
      
      public function set MaxAdditionalCount(param1:uint) : void
      {
         this.FMaxAdditionalCount = param1;
      }
      
      public function get AppendAttributes() : TEquipmentAppendAttributes
      {
         return this.FAppendAttributes;
      }
      
      public function get WeaponSkillID() : uint
      {
         return this.FWeaponSkillID;
      }
      
      public function set WeaponSkillID(param1:uint) : void
      {
         this.FWeaponSkillID = param1;
      }
      
      public function get WeaponSkillName() : String
      {
         return this.FWeaponSkillName;
      }
      
      public function set WeaponSkillName(param1:String) : void
      {
         this.FWeaponSkillName = param1;
      }
      
      public function get WeaponSkillDesc() : String
      {
         return this.FWeaponSkillDesc;
      }
      
      public function set WeaponSkillDesc(param1:String) : void
      {
         this.FWeaponSkillDesc = param1;
      }
      
      public function get HoleQuantity() : uint
      {
         return this.FHoleQuantity;
      }
      
      public function set HoleQuantity(param1:uint) : void
      {
         this.FHoleQuantity = param1;
      }
      
      public function get HoleAdditionalQuantity() : uint
      {
         return this.FHoleAdditionalQuantity;
      }
      
      public function set HoleAdditionalQuantity(param1:uint) : void
      {
         this.FHoleAdditionalQuantity = param1;
      }
      
      public function get GiftedStoneItems() : TGiftedStoneItems
      {
         return this.FGiftedStoneItems;
      }
      
      public function get SuitID() : int
      {
         return this.FSuitID;
      }
      
      public function set SuitID(param1:int) : void
      {
         this.FSuitID = param1;
      }
      
      public function get SuitData() : TSuitData
      {
         return this.FSuitData;
      }
      
      public function get SuitDataSelf() : TSuitData
      {
         return this.FSuitDataSelf;
      }
      
      public function get SuitCount() : int
      {
         return this.FSuitCount;
      }
      
      public function set SuitCount(param1:int) : void
      {
         this.FSuitCount = param1;
      }
      
      public function get IsAdvancedEquip() : Boolean
      {
         return this.FIsAdvancedEquip;
      }
      
      public function set IsAdvancedEquip(param1:Boolean) : void
      {
         this.FIsAdvancedEquip = param1;
      }
      
      public function get IsEdgeColor() : uint
      {
         return this.FIsEdgeColor;
      }
      
      public function set IsEdgeColor(param1:uint) : void
      {
         this.FIsEdgeColor = param1;
      }
      
      public function get GrowthRate() : uint
      {
         return this.FGrowthRate;
      }
      
      public function set GrowthRate(param1:uint) : void
      {
         this.FGrowthRate = param1;
      }
      
      public function get FlushSpiritLevel() : uint
      {
         return this.FFlushSpiritLevel;
      }
      
      public function set FlushSpiritLevel(param1:uint) : void
      {
         this.FFlushSpiritLevel = param1;
      }
      
      public function get FlushSpiritCoefficient() : Number
      {
         return this.FFlushSpiritCoefficient;
      }
      
      public function set FlushSpiritCoefficient(param1:Number) : void
      {
         this.FFlushSpiritCoefficient = param1;
      }
      
      public function get HoleAdditionalMax() : uint
      {
         return this.FHoleAdditionalMax;
      }
      
      public function set HoleAdditionalMax(param1:uint) : void
      {
         this.FHoleAdditionalMax = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FRequirementCareer.length = 0;
         this.FUpgradingLevel = 0;
         this.FBasisPropertyCategory.length = 0;
         this.FBasisProperty.length = 0;
         this.FUpgradingBasisProperty.length = 0;
         this.FMaxAdditionalCount = 0;
         this.FAppendAttributes.Clear();
         this.FWeaponSkillID = 0;
         this.FWeaponSkillName = "";
         this.FWeaponSkillDesc = "";
         this.FHoleQuantity = 0;
         this.FHoleAdditionalQuantity = 0;
         this.FGiftedStoneItems.Clear();
         this.FSuitID = 0;
         this.FSuitCount = 0;
         this.FSuitData.Reset();
         this.FSuitDataSelf.Reset();
         this.FIsAdvancedEquip = false;
         this.FIsEdgeColor = 0;
         this.FGrowthRate = 0;
         this.FUpgradingFlushSpiritBasisProperty = 0;
         this.FFlushSpiritCoefficient = 0;
         this.FFlushSpiritLevel = 0;
         this.FHoleAdditionalMax = 0;
      }
   }
}

