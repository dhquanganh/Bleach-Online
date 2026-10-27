package Logics.Mail
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolMail extends TPoolAutomatic
   {
      
      protected var FIndexMail:int;
      
      public function TPoolMail()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexMail = RegisterClass(TMail,this.ReleasingPerform_Mail);
      }
      
      protected function ReleasingPerform_Mail(param1:Object) : void
      {
         var _loc2_:TMail = null;
         _loc2_ = param1 as TMail;
         _loc2_.Reset();
      }
      
      public function AcquireMail(param1:uint = 0) : TMail
      {
         var _loc2_:TMail = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexMail) as TMail;
         if(_loc2_ == null)
         {
            _loc2_ = new TMail();
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

