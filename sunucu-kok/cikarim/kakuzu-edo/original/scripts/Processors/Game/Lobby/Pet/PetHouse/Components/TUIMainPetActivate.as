package Processors.Game.Lobby.Pet.PetHouse.Components
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Pet.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TUIMainPetActivate extends TUIComponent
   {
      
      public static const CAPACITY_BaseAttribute:uint = CONST_PET.CAPACITY_BaseAttribute;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FMC_BaseAttributes:Vector.<MovieClip>;
      
      protected var FIsInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FContext:TMainPet;
      
      public function TUIMainPetActivate(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         this.FTF_Level = this.FResource[CONST_PET.RESOURCE_Link_TF_Level];
         this.FTF_Name = this.FResource[CONST_PET.RESOURCE_Link_TF_PetName];
         this.FMC_BaseAttributes = new Vector.<MovieClip>(CAPACITY_BaseAttribute);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BaseAttribute)
         {
            this.FMC_BaseAttributes[_loc1_] = this.FResource[CONST_PET.RESOURCE_Link_MC_BaseAttribute + _loc1_];
            _loc1_++;
         }
         this.Reset();
         this.FIsInitialization = true;
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         this.FTF_Level.text = TUtilityString.Format(STRING_COMMON.FORMAT_05,this.FContext.Level);
         this.FTF_Name.text = this.FContext.Name;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BaseAttribute)
         {
            this.FMC_BaseAttributes[_loc1_].gotoAndStop(this.FContext.GetBaseAttributeByIndex(_loc1_) + 1);
            _loc1_++;
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      public function set Context(param1:TMainPet) : void
      {
         this.Reset();
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUI();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function Reset() : void
      {
         this.FTF_Level.text = "";
         this.FTF_Name.text = "";
      }
   }
}

