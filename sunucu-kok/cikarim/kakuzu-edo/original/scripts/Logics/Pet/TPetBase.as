package Logics.Pet
{
   import Foundation.Common.*;
   import Foundation.Common.Stubs.*;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.*;
   
   use namespace LogicsSpace;
   
   public class TPetBase extends TEntity64
   {
      
      public static const CAPACITY_BASEATTRIBUTE:int = CONST_PET.CAPACITY_BASEATTRIBUTE;
      
      public static const CAPACITY_PVPATTRIBUTE:int = CONST_PET.CAPACITY_PVPATTRIBUTE;
      
      public static const BASEATTRIBUTEINDEX_StarLevel:uint = CONST_PET.BASEATTRIBUTEINDEX_StarLevel;
      
      public static const BASEATTRIBUTEINDEX_Alive:uint = CONST_PET.BASEATTRIBUTEINDEX_Alive;
      
      public static const BASEATTRIBUTEINDEX_Attack:uint = CONST_PET.BASEATTRIBUTEINDEX_Attack;
      
      public static const BASEATTRIBUTEINDEX_Speed:uint = CONST_PET.BASEATTRIBUTEINDEX_Speed;
      
      public static const PVPATTRIBUTEINDEX_PhysicalAttack:uint = CONST_PET.PVPATTRIBUTEINDEX_PhysicalAttack;
      
      public static const PVPATTRIBUTEINDEX_PhysicalDefends:uint = CONST_PET.PVPATTRIBUTEINDEX_PhysicalDefends;
      
      public static const PVPATTRIBUTEINDEX_MagicAttack:uint = CONST_PET.PVPATTRIBUTEINDEX_MagicAttack;
      
      public static const PVPATTRIBUTEINDEX_MagicDefends:uint = CONST_PET.PVPATTRIBUTEINDEX_MagicDefends;
      
      public static const PVPATTRIBUTEINDEX_Speed:uint = CONST_PET.PVPATTRIBUTEINDEX_Speed;
      
      public static const PVPATTRIBUTEINDEX_Health:uint = CONST_PET.PVPATTRIBUTEINDEX_Health;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FTemplateID:uint;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      protected var FExperience:uint;
      
      protected var FNextExperience:uint;
      
      protected var FTotalExperience:uint;
      
      protected var FStage:uint;
      
      protected var FQuality:uint;
      
      protected var FBaseAttributes:Vector.<uint>;
      
      protected var FPvPAttributes:Vector.<uint>;
      
      protected var FNextBaseAttributes:Vector.<uint>;
      
      protected var FNextPvPAttributes:Vector.<uint>;
      
      protected var FHeadIconID:uint;
      
      protected var FLargeIconID:uint;
      
      protected var FModelID:uint;
      
      protected var FAllowAdvance:Boolean;
      
      protected var FPetState:int;
      
      public function TPetBase(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
         this.FName = "";
         this.FBaseAttributes = new Vector.<uint>(CAPACITY_BASEATTRIBUTE);
         this.FPvPAttributes = new Vector.<uint>(CAPACITY_PVPATTRIBUTE);
         this.FNextBaseAttributes = new Vector.<uint>(CAPACITY_BASEATTRIBUTE);
         this.FNextPvPAttributes = new Vector.<uint>(CAPACITY_PVPATTRIBUTE);
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint = 0) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get TemplateID() : uint
      {
         return this.FTemplateID;
      }
      
      public function set TemplateID(param1:uint) : void
      {
         this.FTemplateID = param1;
      }
      
      public function GetTemplateIDByLevel(param1:uint) : uint
      {
         return 0;
      }
      
      public function get BaseAttributesCount() : int
      {
         return CAPACITY_BASEATTRIBUTE;
      }
      
      public function get PvPAttributesCount() : int
      {
         return CAPACITY_PVPATTRIBUTE;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Experience() : uint
      {
         return this.FExperience;
      }
      
      public function set Experience(param1:uint) : void
      {
         this.FExperience = param1;
      }
      
      public function get NextExperience() : uint
      {
         return this.FNextExperience;
      }
      
      public function set NextExperience(param1:uint) : void
      {
         this.FNextExperience = param1;
      }
      
      public function get TotalExperience() : uint
      {
         return this.FTotalExperience;
      }
      
      public function set TotalExperience(param1:uint) : void
      {
         this.FTotalExperience = param1;
      }
      
      public function get Stage() : uint
      {
         return this.FStage;
      }
      
      public function set Stage(param1:uint) : void
      {
         this.FStage = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function GetBaseAttributeByIndex(param1:int) : uint
      {
         return this.FBaseAttributes[param1];
      }
      
      public function SetBaseAttributeByIndex(param1:int, param2:uint) : void
      {
         this.FBaseAttributes[param1] = param2;
      }
      
      public function get BaseAttributeStarLevel() : uint
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_StarLevel];
      }
      
      public function set BaseAttributeStarLevel(param1:uint) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_StarLevel] = param1;
      }
      
      public function get BaseAttributeAlive() : uint
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Alive];
      }
      
      public function set BaseAttributeAlive(param1:uint) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Alive] = param1;
      }
      
      public function get BaseAttributeAttack() : uint
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Attack];
      }
      
      public function set BaseAttributeAttack(param1:uint) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Attack] = param1;
      }
      
      public function get BaseAttributeSpeed() : uint
      {
         return this.FBaseAttributes[BASEATTRIBUTEINDEX_Speed];
      }
      
      public function set BaseAttributeSpeed(param1:uint) : void
      {
         this.FBaseAttributes[BASEATTRIBUTEINDEX_Speed] = param1;
      }
      
      public function GetPvPAttributeByIndex(param1:int) : uint
      {
         return this.FPvPAttributes[param1];
      }
      
      public function SetPvPAttributeByIndex(param1:int, param2:uint) : void
      {
         this.FPvPAttributes[param1] = param2;
      }
      
      public function get PvpAttributePhysicalAttack() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_PhysicalAttack];
      }
      
      public function set PvpAttributePhysicalAttack(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_PhysicalAttack] = param1;
      }
      
      public function get PvpAttributePhysicalDefends() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_PhysicalDefends];
      }
      
      public function set PvpAttributePhysicalDefends(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_PhysicalDefends] = param1;
      }
      
      public function get PvpAttributeMagicAttack() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_MagicAttack];
      }
      
      public function set PvpAttributeMagicAttack(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_MagicAttack] = param1;
      }
      
      public function get PvpAttributeMagicDefends() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_MagicDefends];
      }
      
      public function set PvpAttributeMagicDefends(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_MagicDefends] = param1;
      }
      
      public function get PvpAttributeSpeed() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_Speed];
      }
      
      public function set PvpAttributeSpeed(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_Speed] = param1;
      }
      
      public function get PvpAttributeHealth() : uint
      {
         return this.FPvPAttributes[PVPATTRIBUTEINDEX_Health];
      }
      
      public function set PvpAttributeHealth(param1:uint) : void
      {
         this.FPvPAttributes[PVPATTRIBUTEINDEX_Health] = param1;
      }
      
      public function GetNextBaseAttributeByIndex(param1:int) : uint
      {
         return this.FNextBaseAttributes[param1];
      }
      
      public function SetNextBaseAttributeByIndex(param1:int, param2:uint) : void
      {
         this.FNextBaseAttributes[param1] = param2;
      }
      
      public function GetNextPvPAttributeByIndex(param1:int) : uint
      {
         return this.FNextPvPAttributes[param1];
      }
      
      public function SetNextPvPAttributeByIndex(param1:int, param2:uint) : void
      {
         this.FNextPvPAttributes[param1] = param2;
      }
      
      public function get HeadIconID() : uint
      {
         return this.FHeadIconID;
      }
      
      public function set HeadIconID(param1:uint) : void
      {
         this.FHeadIconID = param1;
      }
      
      public function get LargeIconID() : uint
      {
         return this.FLargeIconID;
      }
      
      public function set LargeIconID(param1:uint) : void
      {
         this.FLargeIconID = param1;
      }
      
      public function get ModelID() : uint
      {
         return this.FModelID;
      }
      
      public function set ModelID(param1:uint) : void
      {
         this.FModelID = param1;
      }
      
      public function get AllowAdvance() : Boolean
      {
         return this.FAllowAdvance;
      }
      
      public function set AllowAdvance(param1:Boolean) : void
      {
         this.FAllowAdvance = param1;
      }
      
      public function get PetState() : int
      {
         return this.FPetState;
      }
      
      public function set PetState(param1:int) : void
      {
         this.FPetState = param1;
      }
      
      public function GetRank() : int
      {
         return -1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         this.FTemplateID = 0;
         this.FName = "";
         this.FLevel = 0;
         this.FExperience = 0;
         this.FNextExperience = 0;
         this.FTotalExperience = 0;
         this.FStage = 0;
         this.FQuality = 0;
         this.FAllowAdvance = true;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BASEATTRIBUTE)
         {
            this.FBaseAttributes[_loc1_] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PVPATTRIBUTE)
         {
            this.FPvPAttributes[_loc1_] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BASEATTRIBUTE)
         {
            this.FNextBaseAttributes[_loc1_] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PVPATTRIBUTE)
         {
            this.FNextPvPAttributes[_loc1_] = 0;
            _loc1_++;
         }
         this.FHeadIconID = 0;
         this.FLargeIconID = 0;
         this.FModelID = 0;
      }
   }
}

