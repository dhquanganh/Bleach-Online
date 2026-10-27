package Logics.Streamization.HyperStrings.Elements
{
   import Foundation.Utilities.TUtilityString;
   import Logics.HyperStrings.Elements.THyperStringElementLinkURL;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHyperStringElementLinkURL extends TUnstreamizerHyperStringElement
   {
      
      public function TUnstreamizerHyperStringElementLinkURL()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementLinkURL = null;
         _loc4_ = param2 as THyperStringElementLinkURL;
         _loc4_.Text = TUtilityString.FetchUTF(param1);
         _loc4_.HyperlinkAddress = TUtilityString.FetchUTF(param1);
      }
   }
}

