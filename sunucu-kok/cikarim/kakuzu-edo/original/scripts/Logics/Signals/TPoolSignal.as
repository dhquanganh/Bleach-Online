package Logics.Signals
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolSignal extends TPoolAutomatic
   {
      
      protected var FIndexSignal:int;
      
      public function TPoolSignal()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexSignal = RegisterClass(TSignal);
      }
      
      public function Acquire(param1:uint, param2:uint, param3:int = 0, param4:Object = null) : TSignal
      {
         var _loc5_:TSignal = null;
         _loc5_ = InstanceAcquireByIndex(this.FIndexSignal) as TSignal;
         if(_loc5_ == null)
         {
            _loc5_ = new TSignal();
         }
         _loc5_.Destination = param1;
         _loc5_.Identifier = param2;
         _loc5_.Value = param3;
         _loc5_.UserData = param4;
         FStubsReferences.push(_loc5_.StubReferences);
         return _loc5_;
      }
   }
}

