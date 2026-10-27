package Logging.Digests
{
   import Foundation.Pools.TPoolAutomatic;
   import Logging.Spaces.LoggingSpace;
   
   use namespace LoggingSpace;
   
   public class TPoolDigest extends TPoolAutomatic
   {
      
      protected var FIndexDigest:int;
      
      public function TPoolDigest()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexDigest = RegisterClass(TDigest);
      }
      
      public function Acquire(param1:uint = 0) : TDigest
      {
         var _loc2_:TDigest = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexDigest) as TDigest;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TDigest(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

