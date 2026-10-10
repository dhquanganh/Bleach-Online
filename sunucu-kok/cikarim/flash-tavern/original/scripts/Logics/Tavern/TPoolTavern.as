package Logics.Tavern
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolTavern extends TPoolAutomatic
   {
      
      protected var FIndexTavernMora:int;
      
      public function TPoolTavern()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexTavernMora = RegisterClass(TMora);
      }
      
      public function AcquireMora() : TMora
      {
         var _loc1_:TMora = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexTavernMora) as TMora;
         if(_loc1_ == null)
         {
            _loc1_ = new TMora();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

