package Foundation.Resources.Streamization
{
   import Foundation.Registries.TRegistryRoutine;
   import flash.utils.ByteArray;
   
   public class TResourceUnstreamizerAsynchronous extends TResourceUnstreamizer
   {
      
      public static const UNSTREAMIZATIONSTATE_Idle:int = 0;
      
      protected var FUnstreamizationRoutines:TRegistryRoutine;
      
      protected var FUnstreamizationState:int;
      
      protected var FStream:ByteArray;
      
      protected var FDestination:Object;
      
      protected var FCorrelator:Object;
      
      public function TResourceUnstreamizerAsynchronous()
      {
         super();
         this.FUnstreamizationRoutines = new TRegistryRoutine();
         this.UnstreamizationRegisterRountines();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Function = null;
         while(this.FUnstreamizationState != UNSTREAMIZATIONSTATE_Idle)
         {
            _loc4_ = this.FUnstreamizationState;
            _loc5_ = this.FUnstreamizationRoutines.GetRoutineByIndentifier(this.FUnstreamizationState);
            if(_loc5_ != null)
            {
               _loc5_();
            }
            if(_loc4_ == this.FUnstreamizationState)
            {
               return;
            }
         }
      }
      
      protected function UnstreamizationRegisterRountines() : void
      {
      }
      
      protected function UnstreamizationInitialize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.FStream = param1;
         this.FDestination = param2;
         this.FCorrelator = param3;
      }
      
      protected function UnstreamizationFinalize() : void
      {
         this.FStream = null;
         this.FDestination = null;
         this.FCorrelator = null;
      }
      
      override public function get Unstreamizing() : Boolean
      {
         return this.FUnstreamizationState != UNSTREAMIZATIONSTATE_Idle;
      }
      
      override public function Unstreamize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationInitialize(param1,param2,param3);
      }
      
      override public function Process() : void
      {
         this.UnstreamizationPerform(this.FStream,this.FDestination,this.FCorrelator);
      }
   }
}

