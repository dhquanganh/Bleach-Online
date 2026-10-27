package Logics.Characters
{
   public class TRoleDigest extends TDigest
   {
      
      protected var FMilitaryRank:uint;
      
      protected var FGender:int;
      
      protected var FUserProId:int;
      
      protected var FQuality:uint;
      
      protected var FPetStatus:uint;
      
      protected var FPetID:uint;
      
      protected var FRoleX:int;
      
      protected var FRoleY:int;
      
      protected var FTag:uint;
      
      public function TRoleDigest(param1:uint, param2:uint)
      {
         super(param1,param2);
      }
      
      public function get MilitaryRank() : uint
      {
         return this.FMilitaryRank;
      }
      
      public function set MilitaryRank(param1:uint) : void
      {
         this.FMilitaryRank = param1;
      }
      
      public function get Gender() : int
      {
         return this.FGender;
      }
      
      public function set Gender(param1:int) : void
      {
         this.FGender = param1;
      }
      
      public function get UserProId() : int
      {
         return this.FUserProId;
      }
      
      public function set UserProId(param1:int) : void
      {
         this.FUserProId = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
      
      public function get PetStatus() : uint
      {
         return this.FPetStatus;
      }
      
      public function set PetStatus(param1:uint) : void
      {
         this.FPetStatus = param1;
      }
      
      public function get PetID() : uint
      {
         return this.FPetID;
      }
      
      public function set PetID(param1:uint) : void
      {
         this.FPetID = param1;
      }
      
      public function get RoleX() : int
      {
         return this.FRoleX;
      }
      
      public function set RoleX(param1:int) : void
      {
         this.FRoleX = param1;
      }
      
      public function get RoleY() : int
      {
         return this.FRoleY;
      }
      
      public function set RoleY(param1:int) : void
      {
         this.FRoleY = param1;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTag = 0;
         this.FMilitaryRank = 0;
         this.FGender = 0;
         this.FUserProId = 0;
         this.FQuality = 0;
         this.FPetStatus = 0;
         this.FPetID = 0;
         this.FRoleX = 0;
         this.FRoleY = 0;
      }
   }
}

