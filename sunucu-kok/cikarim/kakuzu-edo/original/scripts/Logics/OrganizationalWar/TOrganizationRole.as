package Logics.OrganizationalWar
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   
   public class TOrganizationRole extends TEntity64
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FName:String;
      
      protected var FRoleLevel:uint;
      
      protected var FBloodRate:int;
      
      protected var FConsecutiveVictories:uint;
      
      protected var FCampID:uint;
      
      protected var FBirthPlaceID:uint;
      
      protected var FTempleteID:uint;
      
      protected var FBattleStartTime:Number;
      
      protected var FBattleLocalTime:Number;
      
      protected var FTotalScore:int;
      
      protected var FOrganizationalID:int;
      
      public function TOrganizationRole(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get RoleLevel() : uint
      {
         return this.FRoleLevel;
      }
      
      public function set RoleLevel(param1:uint) : void
      {
         this.FRoleLevel = param1;
      }
      
      public function get ConsecutiveVictories() : uint
      {
         return this.FConsecutiveVictories;
      }
      
      public function set ConsecutiveVictories(param1:uint) : void
      {
         this.FConsecutiveVictories = param1;
      }
      
      public function get CampID() : uint
      {
         return this.FCampID;
      }
      
      public function set CampID(param1:uint) : void
      {
         this.FCampID = param1;
      }
      
      public function get BirthPlaceID() : uint
      {
         return this.FBirthPlaceID;
      }
      
      public function set BirthPlaceID(param1:uint) : void
      {
         this.FBirthPlaceID = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get TempleteID() : uint
      {
         return this.FTempleteID;
      }
      
      public function set TempleteID(param1:uint) : void
      {
         this.FTempleteID = param1;
      }
      
      public function get BloodRate() : int
      {
         return this.FBloodRate;
      }
      
      public function set BloodRate(param1:int) : void
      {
         this.FBloodRate = param1;
      }
      
      public function get BattleStartTime() : Number
      {
         return this.FBattleStartTime;
      }
      
      public function set BattleStartTime(param1:Number) : void
      {
         this.FBattleStartTime = param1;
      }
      
      public function get BattleLocalTime() : Number
      {
         return this.FBattleLocalTime;
      }
      
      public function set BattleLocalTime(param1:Number) : void
      {
         this.FBattleLocalTime = param1;
      }
      
      public function get TotalScore() : int
      {
         return this.FTotalScore;
      }
      
      public function set TotalScore(param1:int) : void
      {
         this.FTotalScore = param1;
      }
      
      public function get OrganizationalID() : int
      {
         return this.FOrganizationalID;
      }
      
      public function set OrganizationalID(param1:int) : void
      {
         this.FOrganizationalID = param1;
      }
      
      public function Reset() : void
      {
         this.FName = "";
         this.FRoleLevel = 0;
         this.FBloodRate = 0;
         this.FConsecutiveVictories = 0;
         this.FCampID = 0;
         this.FBirthPlaceID = 0;
      }
   }
}

