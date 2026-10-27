package Logics.Pet
{
   import Logics.DatebaseVO.VO.TVicePetRankUp;
   
   public class TVicePetRankUpInfo
   {
      
      protected var FVicePetRankUp:TVicePetRankUp;
      
      protected var FPreInfo:TVicePetRankUpInfo;
      
      protected var FNextInfo:TVicePetRankUpInfo;
      
      protected var FPetId:int;
      
      public function TVicePetRankUpInfo()
      {
         super();
      }
      
      public function get PreInfo() : TVicePetRankUpInfo
      {
         return this.FPreInfo;
      }
      
      public function set PreInfo(param1:TVicePetRankUpInfo) : void
      {
         this.FPreInfo = param1;
      }
      
      public function get NextInfo() : TVicePetRankUpInfo
      {
         return this.FNextInfo;
      }
      
      public function set NextInfo(param1:TVicePetRankUpInfo) : void
      {
         this.FNextInfo = param1;
      }
      
      public function get VicePetRankUp() : TVicePetRankUp
      {
         return this.FVicePetRankUp;
      }
      
      public function set VicePetRankUp(param1:TVicePetRankUp) : void
      {
         this.FVicePetRankUp = param1;
      }
      
      public function get PetId() : int
      {
         return this.FPetId;
      }
      
      public function set PetId(param1:int) : void
      {
         this.FPetId = param1;
      }
   }
}

