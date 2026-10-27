package Logics.CityDefend
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TCityDefendHero extends TEntity64
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FStatus:uint;
      
      protected var FUserName:String;
      
      protected var FUserLevel:uint;
      
      protected var FQuality:uint;
      
      protected var FMilitaryRank:uint;
      
      protected var FPetStatus:Boolean;
      
      protected var FPetModelId:uint;
      
      protected var FRoleTemplateId:uint;
      
      protected var FUserType:uint;
      
      protected var FUserPower:uint;
      
      protected var FUserRebirthNum:uint;
      
      public function TCityDefendHero(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Status() : uint
      {
         return this.FStatus;
      }
      
      public function set Status(param1:uint) : void
      {
         this.FStatus = param1;
      }
      
      public function get UserName() : String
      {
         return this.FUserName;
      }
      
      public function set UserName(param1:String) : void
      {
         this.FUserName = param1;
      }
      
      public function get UserLevel() : uint
      {
         return this.FUserLevel;
      }
      
      public function set UserLevel(param1:uint) : void
      {
         this.FUserLevel = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get MilitaryRank() : uint
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:uint) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get PetStatus() : Boolean
      {
         return this.FPetStatus;
      }
      
      public function set PetStatus(param1:Boolean) : void
      {
         this.FPetStatus = param1;
      }
      
      public function get PetModelId() : uint
      {
         return this.FPetModelId;
      }
      
      public function set PetModelId(param1:uint) : void
      {
         this.FPetModelId = param1;
      }
      
      public function get RoleTemplateId() : uint
      {
         return this.FRoleTemplateId;
      }
      
      public function set RoleTemplateId(param1:uint) : void
      {
         this.FRoleTemplateId = param1;
      }
      
      public function get UserType() : uint
      {
         return this.FUserType;
      }
      
      public function set UserType(param1:uint) : void
      {
         this.FUserType = param1;
      }
      
      public function get UserPower() : uint
      {
         return this.FUserPower;
      }
      
      public function set UserPower(param1:uint) : void
      {
         this.FUserPower = param1;
      }
      
      public function get UserRebirthNum() : uint
      {
         return this.FUserRebirthNum;
      }
      
      public function set UserRebirthNum(param1:uint) : void
      {
         this.FUserRebirthNum = param1;
      }
   }
}

