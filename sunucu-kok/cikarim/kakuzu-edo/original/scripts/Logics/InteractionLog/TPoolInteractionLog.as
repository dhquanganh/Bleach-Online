package Logics.InteractionLog
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolInteractionLog extends TPoolAutomatic
   {
      
      protected var FIndexInteractionLog:int;
      
      public function TPoolInteractionLog()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexInteractionLog = RegisterClass(TInteractionLog,this.ReleasingPerform_InteractionLog);
      }
      
      protected function ReleasingPerform_InteractionLog(param1:Object) : void
      {
         var _loc2_:TInteractionLog = null;
         _loc2_ = param1 as TInteractionLog;
         _loc2_.Reset();
      }
      
      public function Acquire(param1:uint = 0, param2:uint = 0) : TInteractionLog
      {
         var _loc3_:TInteractionLog = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexInteractionLog) as TInteractionLog;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TInteractionLog(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
   }
}

