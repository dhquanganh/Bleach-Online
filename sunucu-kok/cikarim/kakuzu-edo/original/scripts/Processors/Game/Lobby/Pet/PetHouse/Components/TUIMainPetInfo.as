package Processors.Game.Lobby.Pet.PetHouse.Components
{
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TUIMainPetInfo extends TUIPetInfo
   {
      
      protected var FMC_Skill:Sprite;
      
      protected var FMC_Unopened:Sprite;
      
      public function TUIMainPetInfo()
      {
         super();
      }
      
      override protected function Initialization() : void
      {
         this.FMC_Skill = FResource[CONST_PET.RESOURCE_Link_MC_Skill];
         this.FMC_Unopened = FResource[CONST_PET.RESOURCE_Link_MC_Unopened];
         super.Initialization();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FMC_Skill.visible = false;
         this.FMC_Unopened.visible = true;
      }
   }
}

