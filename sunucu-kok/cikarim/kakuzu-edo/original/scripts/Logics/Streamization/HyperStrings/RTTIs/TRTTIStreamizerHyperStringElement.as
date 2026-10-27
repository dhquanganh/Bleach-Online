package Logics.Streamization.HyperStrings.RTTIs
{
   import Foundation.Registries.TRegistryClassManual;
   import Logics.Streamization.HyperStrings.Elements.TStreamizerHyperStringElementIcon;
   import Logics.Streamization.HyperStrings.Elements.TStreamizerHyperStringElementLinkItem;
   import Logics.Streamization.HyperStrings.Elements.TStreamizerHyperStringElementText;
   import Resources.RTTIs.RTTI_HYPERSTRING;
   
   public class TRTTIStreamizerHyperStringElement extends TRegistryClassManual
   {
      
      public function TRTTIStreamizerHyperStringElement()
      {
         super();
         this.RegisterClasses();
      }
      
      protected function RegisterClasses() : void
      {
         this.RegisterClasses_Textual();
         this.RegisterClasses_Graphical();
         this.RegisterClasses_LinkItem();
      }
      
      protected function RegisterClasses_Textual() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Text,TStreamizerHyperStringElementText);
      }
      
      protected function RegisterClasses_Graphical() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Icon,TStreamizerHyperStringElementIcon);
      }
      
      protected function RegisterClasses_LinkItem() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem,TStreamizerHyperStringElementLinkItem);
      }
      
      override public function Register(param1:uint, param2:Class) : Boolean
      {
         return false;
      }
   }
}

