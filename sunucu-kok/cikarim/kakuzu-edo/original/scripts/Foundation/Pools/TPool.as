package Foundation.Pools
{
   import Debugging.*;
   import Foundation.Common.Stubs.*;
   import Foundation.Registries.*;
   import Foundation.Utilities.*;
   
   public class TPool
   {
      
      protected var FRegistryClass:TRegistryClass;
      
      protected var FRegistryReleasingRoutines:TRegistryRoutine;
      
      protected var FPools:Vector.<Vector.<Object>>;
      
      protected var FStubsReferences:Vector.<TStubReferences>;
      
      public function TPool()
      {
         super();
         this.ConstructRegistryClass();
         this.FRegistryReleasingRoutines = new TRegistryRoutine();
         this.FPools = new Vector.<Vector.<Object>>();
         this.FStubsReferences = new Vector.<TStubReferences>();
         this.RegisterClasses();
      }
      
      protected function ConstructRegistryClass() : void
      {
      }
      
      protected function RegisterClasses() : void
      {
      }
      
      protected function InstanceAcquireByClass(param1:Class) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<Object> = null;
         _loc2_ = this.FRegistryClass.GetIndexByClass(param1);
         if(_loc2_ < 0)
         {
            return null;
         }
         _loc3_ = this.FPools[_loc2_];
         if(_loc3_.length != 0)
         {
            return _loc3_.pop();
         }
         return null;
      }
      
      protected function InstanceAcquireByIndex(param1:int) : Object
      {
         var _loc2_:Vector.<Object> = null;
         _loc2_ = this.FPools[param1];
         if(_loc2_.length != 0)
         {
            return _loc2_.pop();
         }
         return null;
      }
      
      protected function InstanceRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         var _loc4_:Vector.<Object> = null;
         _loc2_ = this.FRegistryClass.GetIndexByInstance(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         _loc3_ = this.FRegistryReleasingRoutines.GetRoutineByIndex(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_(param1);
         }
         _loc4_ = this.FPools[_loc2_];
         _loc4_.push(param1);
      }
      
      protected function InstancesReleaseByStubReferences() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:TStubReferences = null;
         _loc1_ = 0;
         _loc2_ = int(this.FStubsReferences.length);
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this.FStubsReferences[_loc3_];
            if(_loc4_.Count <= 0)
            {
               _loc1_++;
               this.FStubsReferences[_loc3_] = this.FStubsReferences[_loc2_ - _loc1_];
               this.InstanceRelease(_loc4_.Owner);
            }
            _loc3_--;
         }
         if(_loc1_ != 0)
         {
            this.FStubsReferences.length = _loc2_ - _loc1_;
         }
      }
      
      public function Update() : void
      {
         this.InstancesReleaseByStubReferences();
      }
   }
}

