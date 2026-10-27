package Logics.Streamization.HyperStrings.Common
{
   import Foundation.Streamization.TStreamizer;
   import Logics.HyperStrings.TPoolHyperString;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TStreamizerHyperStringUnknown extends TStreamizer
   {
      
      protected static var FPoolHyperString:TPoolHyperString;
      
      public function TStreamizerHyperStringUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolHyperString) : void
      {
         FPoolHyperString = param1;
      }
   }
}

