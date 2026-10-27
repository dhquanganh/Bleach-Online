package Logics.Streamization.Items
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Items.TPoolItem;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerItemUnknown extends TUnstreamizer
   {
      
      protected static var FPoolItem:TPoolItem;
      
      public function TUnstreamizerItemUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolItem) : void
      {
         FPoolItem = param1;
      }
   }
}

