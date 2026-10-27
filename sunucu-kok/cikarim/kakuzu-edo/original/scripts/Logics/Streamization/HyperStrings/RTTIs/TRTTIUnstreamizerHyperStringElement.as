package Logics.Streamization.HyperStrings.RTTIs
{
   import Foundation.Registries.TRegistryClassManual;
   import Logics.Streamization.HyperStrings.Elements.TUnstreamizerHyperStringElementIcon;
   import Logics.Streamization.HyperStrings.Elements.TUnstreamizerHyperStringElementLinkItem;
   import Logics.Streamization.HyperStrings.Elements.TUnstreamizerHyperStringElementLinkURL;
   import Logics.Streamization.HyperStrings.Elements.TUnstreamizerHyperStringElementText;
   import Resources.RTTIs.RTTI_HYPERSTRING;
   
   public class TRTTIUnstreamizerHyperStringElement extends TRegistryClassManual
   {
      
      public function TRTTIUnstreamizerHyperStringElement()
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
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Text,TUnstreamizerHyperStringElementText);
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkURL,TUnstreamizerHyperStringElementLinkURL);
      }
      
      protected function RegisterClasses_Graphical() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_Icon,TUnstreamizerHyperStringElementIcon);
      }
      
      protected function RegisterClasses_LinkItem() : void
      {
         RegisterClass(RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem,TUnstreamizerHyperStringElementLinkItem);
      }
      
      override public function Register(param1:uint, param2:Class) : Boolean
      {
         return false;
      }
   }
}

