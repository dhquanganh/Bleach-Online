package Foundation.Pools
{
   import Debugging.*;
   import Foundation.Registries.*;
   import Foundation.Utilities.*;
   
   public class TPoolAutomatic extends TPool
   {
      
      protected var FRegistryClassAutomatic:TRegistryClassAutomatic;
      
      public function TPoolAutomatic()
      {
         super();
      }
      
      override protected function ConstructRegistryClass() : void
      {
         this.FRegistryClassAutomatic = new TRegistryClassAutomatic();
         FRegistryClass = this.FRegistryClassAutomatic;
      }
      
      protected function RegisterClass(param1:Class, param2:Function = null) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<Object> = null;
         _loc3_ = this.FRegistryClassAutomatic.Count;
         _loc4_ = this.FRegistryClassAutomatic.Register(param1);
         if(_loc4_ < _loc3_)
         {
            return _loc4_;
         }
         FRegistryReleasingRoutines.Register(_loc4_,param2);
         _loc5_ = new Vector.<Object>();
         FPools.push(_loc5_);
         return _loc4_;
      }
   }
}

