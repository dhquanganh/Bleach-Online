package Logics.Log
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolLog extends TPoolAutomatic
   {
      
      protected var FIndexLog:int;
      
      public function TPoolLog()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexLog = RegisterClass(TLog,this.ReleasingPerform_InteractionLog);
      }
      
      protected function ReleasingPerform_InteractionLog(param1:Object) : void
      {
         var _loc2_:TLog = null;
         _loc2_ = param1 as TLog;
         _loc2_.Reset();
      }
      
      public function Acquire() : TLog
      {
         var _loc1_:TLog = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexLog) as TLog;
         if(_loc1_ == null)
         {
            _loc1_ = new TLog();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

