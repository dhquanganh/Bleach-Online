package Logics.Arena
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolArena extends TPoolAutomatic
   {
      
      protected var FIndexArenaHero:int;
      
      protected var FIndexArenaReport:int;
      
      public function TPoolArena()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexArenaHero = RegisterClass(TArenaHero);
         this.FIndexArenaReport = RegisterClass(TArenaReport);
      }
      
      public function AcquireArenaHero(param1:uint = 0, param2:uint = 0) : TArenaHero
      {
         var _loc3_:TArenaHero = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexArenaHero) as TArenaHero;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TArenaHero(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireArenaReport() : TArenaReport
      {
         var _loc1_:TArenaReport = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexArenaReport) as TArenaReport;
         if(_loc1_ == null)
         {
            _loc1_ = new TArenaReport();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

