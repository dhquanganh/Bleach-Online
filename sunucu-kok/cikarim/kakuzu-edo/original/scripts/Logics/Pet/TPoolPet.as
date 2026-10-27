package Logics.Pet
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolPet extends TPoolAutomatic
   {
      
      protected var FIndexMainPet:int;
      
      protected var FIndexVicePet:int;
      
      public function TPoolPet()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexMainPet = RegisterClass(TMainPet,this.ReleasingPerform_MainPet);
         this.FIndexVicePet = RegisterClass(TVicePet,this.ReleasingPerform_VicePet);
      }
      
      protected function ReleasingPerform_MainPet(param1:Object) : void
      {
         var _loc2_:TMainPet = null;
         _loc2_ = param1 as TMainPet;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_VicePet(param1:Object) : void
      {
         var _loc2_:TVicePet = null;
         _loc2_ = param1 as TVicePet;
         _loc2_.Reset();
      }
      
      public function AcquireMainPet(param1:uint = 0) : TMainPet
      {
         var _loc2_:TMainPet = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexMainPet) as TMainPet;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TMainPet(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireVicePet(param1:uint = 0, param2:uint = 0) : TVicePet
      {
         var _loc3_:TVicePet = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexVicePet) as TVicePet;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TVicePet(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
   }
}

