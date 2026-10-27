package Logics.Streamization.HyperStrings.Elements
{
   import Foundation.Utilities.TUtilityString;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import flash.utils.ByteArray;
   
   public class TStreamizerHyperStringElementText extends TStreamizerHyperStringElement
   {
      
      public function TStreamizerHyperStringElementText()
      {
         super();
      }
      
      override protected function StreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementText = null;
         _loc4_ = param2 as THyperStringElementText;
         TUtilityString.FlushUTF(param1,_loc4_.Text);
      }
   }
}

