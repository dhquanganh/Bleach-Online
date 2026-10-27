package Logics.HyperStrings.RTTIs
{
   import Foundation.Registries.TRegistryClassManual;
   import Logics.HyperStrings.Elements.THyperStringElementIcon;
   import Logics.HyperStrings.Elements.THyperStringElementInventory;
   import Logics.HyperStrings.Elements.THyperStringElementLinkCharacter;
   import Logics.HyperStrings.Elements.THyperStringElementLinkEvent;
   import Logics.HyperStrings.Elements.THyperStringElementLinkHero;
   import Logics.HyperStrings.Elements.THyperStringElementLinkItem;
   import Logics.HyperStrings.Elements.THyperStringElementLinkURL;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import Resources.RTTIs.RTTI_HYPERSTRING;
   
   public class TRTTIHyperStringElement extends TRegistryClassManual
   {
      
      public function TRTTIHyperStringElement()
      {
         super();
         this.RegisterClasses();
      }
      
      protected function RegisterClasses() : void
      {
         this.RegisterClasses_Textual();
         this.RegisterClasses_Graphical();
         this.RegisterClasses_Inventory();
         this.RegisterClasses_Item();
         this.RegisterClasses_LinkCharacter();
         this.RegisterClasses_LinkHero();
         this.RegisterClasses_LinkEvent();
      }
      
      protected function RegisterClasses_Textual() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Text,THyperStringElementText);
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkURL,THyperStringElementLinkURL);
      }
      
      protected function RegisterClasses_Graphical() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Icon,THyperStringElementIcon);
      }
      
      protected function RegisterClasses_Inventory() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkInventory,THyperStringElementInventory);
      }
      
      protected function RegisterClasses_Item() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem,THyperStringElementLinkItem);
      }
      
      protected function RegisterClasses_LinkCharacter() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkCharacter,THyperStringElementLinkCharacter);
      }
      
      protected function RegisterClasses_LinkHero() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkHero,THyperStringElementLinkHero);
      }
      
      protected function RegisterClasses_LinkEvent() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkEvent,THyperStringElementLinkEvent);
      }
      
      override public function Register(param1:uint, param2:Class) : Boolean
      {
         return false;
      }
   }
}

