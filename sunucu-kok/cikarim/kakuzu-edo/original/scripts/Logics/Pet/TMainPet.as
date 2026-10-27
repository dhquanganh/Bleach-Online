package Logics.Pet
{
   import Logics.DatebaseVO.VO.Json.TPetRankUpCondition;
   
   public class TMainPet extends TPetBase
   {
      
      protected var FPetRankUpCondition:TPetRankUpCondition;
      
      public function TMainPet(param1:uint)
      {
         super(param1,0);
      }
      
      override public function GetTemplateIDByLevel(param1:uint) : uint
      {
         return FIdentifier0 * 1000 + param1;
      }
      
      public function GetTemplateIDByID(param1:uint) : uint
      {
         return param1 * 1000 + Level;
      }
      
      public function get PetRankUpCondition() : TPetRankUpCondition
      {
         return this.FPetRankUpCondition;
      }
      
      public function set PetRankUpCondition(param1:TPetRankUpCondition) : void
      {
         this.FPetRankUpCondition = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         FIdentifier0 = 0;
         FIdentifier1 = 0;
         this.FPetRankUpCondition = null;
      }
   }
}

