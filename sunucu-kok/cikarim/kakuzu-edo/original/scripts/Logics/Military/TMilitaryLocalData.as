package Logics.Military
{
   public class TMilitaryLocalData
   {
      
      protected var FAnyMilitaryName:String;
      
      protected var FAnyMilitaryNamePrefix:String;
      
      protected var FAnyMilitaryNameSubfix:String;
      
      protected var FAnyMilitaryCreditDayCost:int;
      
      protected var FUpgradeAnyLevelNeedCredit:int;
      
      protected var FAnyMilitarySalarySilvercoin:int;
      
      protected var FAnyMilitarySalarySpirit:int;
      
      protected var FAnyMilitaryMaxHeroNum:int;
      
      protected var FAnyMilitaryFightHeroNum:int;
      
      protected var FAnyMilitaryUseableCount:int;
      
      protected var FAnyMilitaryAttributesValue:Vector.<String>;
      
      public function TMilitaryLocalData(param1:int)
      {
         super();
         this.FAnyMilitaryAttributesValue = new Vector.<String>(param1);
      }
      
      public function get AnyMilitaryNamePrefix() : String
      {
         return this.FAnyMilitaryNamePrefix;
      }
      
      public function set AnyMilitaryNamePrefix(param1:String) : void
      {
         this.FAnyMilitaryNamePrefix = param1;
      }
      
      public function get AnyMilitaryNameSubfix() : String
      {
         return this.FAnyMilitaryNameSubfix;
      }
      
      public function set AnyMilitaryNameSubfix(param1:String) : void
      {
         this.FAnyMilitaryNameSubfix = param1;
      }
      
      public function get AnyMilitaryCreditDayCost() : int
      {
         return this.FAnyMilitaryCreditDayCost;
      }
      
      public function set AnyMilitaryCreditDayCost(param1:int) : void
      {
         this.FAnyMilitaryCreditDayCost = param1;
      }
      
      public function get UpgradeAnyLevelNeedCredit() : int
      {
         return this.FUpgradeAnyLevelNeedCredit;
      }
      
      public function set UpgradeAnyLevelNeedCredit(param1:int) : void
      {
         this.FUpgradeAnyLevelNeedCredit = param1;
      }
      
      public function get AnyMilitarySalarySilvercoin() : int
      {
         return this.FAnyMilitarySalarySilvercoin;
      }
      
      public function set AnyMilitarySalarySilvercoin(param1:int) : void
      {
         this.FAnyMilitarySalarySilvercoin = param1;
      }
      
      public function get AnyMilitarySalarySpirit() : int
      {
         return this.FAnyMilitarySalarySpirit;
      }
      
      public function set AnyMilitarySalarySpirit(param1:int) : void
      {
         this.FAnyMilitarySalarySpirit = param1;
      }
      
      public function get AnyMilitaryMaxHeroNum() : int
      {
         return this.FAnyMilitaryMaxHeroNum;
      }
      
      public function set AnyMilitaryMaxHeroNum(param1:int) : void
      {
         this.FAnyMilitaryMaxHeroNum = param1;
      }
      
      public function get AnyMilitaryFightHeroNum() : int
      {
         return this.FAnyMilitaryFightHeroNum;
      }
      
      public function set AnyMilitaryFightHeroNum(param1:int) : void
      {
         this.FAnyMilitaryFightHeroNum = param1;
      }
      
      public function set AnyMilitaryUseableCount(param1:int) : void
      {
         this.FAnyMilitaryUseableCount = param1;
      }
      
      public function get AnyMilitaryUseableCount() : int
      {
         return this.FAnyMilitaryUseableCount;
      }
      
      public function get AnyMilitaryAttributesValue() : Vector.<String>
      {
         return this.FAnyMilitaryAttributesValue;
      }
      
      public function set AnyMilitaryAttributesValue(param1:Vector.<String>) : void
      {
         this.FAnyMilitaryAttributesValue = param1;
      }
      
      public function get AnyMilitaryName() : String
      {
         return this.FAnyMilitaryName;
      }
      
      public function set AnyMilitaryName(param1:String) : void
      {
         this.FAnyMilitaryName = param1;
      }
   }
}

