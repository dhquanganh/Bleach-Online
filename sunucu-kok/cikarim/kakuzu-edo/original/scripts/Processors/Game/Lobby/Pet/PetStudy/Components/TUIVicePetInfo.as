package Processors.Game.Lobby.Pet.PetStudy.Components
{
   import Foundation.Utilities.*;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Pet.PetHouse.Components.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIVicePetInfo extends TUIPetInfo
   {
      
      protected var FTF_Level:TextField;
      
      public function TUIVicePetInfo()
      {
         super();
      }
      
      override protected function Initialization() : void
      {
         this.FTF_Level = FResource[CONST_PET.RESOURCE_Link_TF_Level];
         super.Initialization();
      }
      
      public function SetLevel(param1:int) : void
      {
         this.FTF_Level.text = TUtilityString.Format(STRING_COMMON.FORMAT_05,param1);
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTF_Level.text = "";
      }
   }
}

