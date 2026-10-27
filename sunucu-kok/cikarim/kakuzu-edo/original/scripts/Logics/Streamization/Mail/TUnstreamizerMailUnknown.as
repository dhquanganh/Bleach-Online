package Logics.Streamization.Mail
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Mail.TPoolMail;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerMailUnknown extends TUnstreamizer
   {
      
      protected static var FPoolMail:TPoolMail;
      
      public function TUnstreamizerMailUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolMail) : void
      {
         FPoolMail = param1;
      }
   }
}

