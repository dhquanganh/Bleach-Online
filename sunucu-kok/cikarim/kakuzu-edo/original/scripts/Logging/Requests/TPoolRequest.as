package Logging.Requests
{
   import Foundation.Pools.TPoolAutomatic;
   import Logging.Spaces.LoggingSpace;
   
   use namespace LoggingSpace;
   
   public class TPoolRequest extends TPoolAutomatic
   {
      
      protected var FIndexRequest:int;
      
      public function TPoolRequest()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexRequest = RegisterClass(TRequest);
      }
      
      public function Acquire(param1:uint = 0) : TRequest
      {
         var _loc2_:TRequest = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexRequest) as TRequest;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TRequest(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

