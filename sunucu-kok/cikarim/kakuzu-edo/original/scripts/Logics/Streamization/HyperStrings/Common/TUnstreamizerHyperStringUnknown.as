package Logics.Streamization.HyperStrings.Common
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.HyperStrings.TPoolHyperString;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerHyperStringUnknown extends TUnstreamizer
   {
      
      protected static var FPoolHyperString:TPoolHyperString;
      
      public function TUnstreamizerHyperStringUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolHyperString) : void
      {
         FPoolHyperString = param1;
      }
   }
}

