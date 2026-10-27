package Logics.Military
{
   import Foundation.Common.Integer.UInt64;
   
   public class TMilitaryData
   {
      
      protected var FMilitaryRank:int;
      
      protected var FLevel:int;
      
      protected var FRoleName:String;
      
      protected var FJobID:int;
      
      protected var FExperience:UInt64;
      
      protected var FUpgradeNeedExperience:UInt64;
      
      protected var FOrganizationName:String;
      
      protected var FCountryName:String;
      
      protected var FBattleValue:int;
      
      protected var FSalaryState:Boolean;
      
      protected var FCurrentCredit:uint;
      
      protected var FCurrentSilverCoin:UInt64;
      
      protected var FCurrentSpirit:uint;
      
      protected var FLocalMilitaryData:Vector.<TMilitaryLocalData>;
      
      protected var FInitComplete:Boolean;
      
      public function TMilitaryData(param1:int)
      {
         super();
         this.FLocalMilitaryData = new Vector.<TMilitaryLocalData>(param1);
         this.FCurrentSilverCoin = new UInt64();
         this.FExperience = new UInt64();
         this.FUpgradeNeedExperience = new UInt64();
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get RoleName() : String
      {
         return this.FRoleName;
      }
      
      public function set RoleName(param1:String) : void
      {
         this.FRoleName = param1;
      }
      
      public function get Experience() : UInt64
      {
         return this.FExperience;
      }
      
      public function set Experience(param1:UInt64) : void
      {
         this.FExperience = param1;
      }
      
      public function get UpgradeNeedExperience() : UInt64
      {
         return this.FUpgradeNeedExperience;
      }
      
      public function set UpgradeNeedExperience(param1:UInt64) : void
      {
         this.FUpgradeNeedExperience = param1;
      }
      
      public function get OrganizationName() : String
      {
         return this.FOrganizationName;
      }
      
      public function set OrganizationName(param1:String) : void
      {
         this.FOrganizationName = param1;
      }
      
      public function get CountryName() : String
      {
         return this.FCountryName;
      }
      
      public function set CountryName(param1:String) : void
      {
         this.FCountryName = param1;
      }
      
      public function get CurrentCredit() : uint
      {
         return this.FCurrentCredit;
      }
      
      public function set CurrentCredit(param1:uint) : void
      {
         this.FCurrentCredit = param1;
      }
      
      public function SetMilitaryInforByIndex(param1:TMilitaryLocalData, param2:int) : void
      {
         this.FLocalMilitaryData[param2] = param1;
      }
      
      public function GetMilitaryInforByIndex(param1:int) : TMilitaryLocalData
      {
         return this.FLocalMilitaryData[param1];
      }
      
      public function get InforCount() : int
      {
         return this.FLocalMilitaryData.length;
      }
      
      public function get SalaryState() : Boolean
      {
         return this.FSalaryState;
      }
      
      public function set SalaryState(param1:Boolean) : void
      {
         this.FSalaryState = param1;
      }
      
      public function get MilitaryRank() : int
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:int) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get CurrentSilverCoin() : UInt64
      {
         return this.FCurrentSilverCoin;
      }
      
      public function set CurrentSilverCoin(param1:UInt64) : void
      {
         this.FCurrentSilverCoin = param1;
      }
      
      public function get CurrentSpirit() : uint
      {
         return this.FCurrentSpirit;
      }
      
      public function set CurrentSpirit(param1:uint) : void
      {
         this.FCurrentSpirit = param1;
      }
      
      public function get JobID() : int
      {
         return this.FJobID;
      }
      
      public function set JobID(param1:int) : void
      {
         this.FJobID = param1;
      }
      
      public function get BattleValue() : int
      {
         return this.FBattleValue;
      }
      
      public function set BattleValue(param1:int) : void
      {
         this.FBattleValue = param1;
      }
      
      public function get InitComplete() : Boolean
      {
         return this.FInitComplete;
      }
      
      public function set InitComplete(param1:Boolean) : void
      {
         this.FInitComplete = param1;
      }
   }
}

