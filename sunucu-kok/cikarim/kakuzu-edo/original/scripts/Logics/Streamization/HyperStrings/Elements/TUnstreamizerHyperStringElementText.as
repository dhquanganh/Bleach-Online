package Logics.Streamization.HyperStrings.Elements
{
   import Foundation.Utilities.TUtilityString;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHyperStringElementText extends TUnstreamizerHyperStringElement
   {
      
      public function TUnstreamizerHyperStringElementText()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = param2 as THyperStringElementText;
         _loc4_.Text = TUtilityString.FetchUTF(param1);
      }
   }
}

