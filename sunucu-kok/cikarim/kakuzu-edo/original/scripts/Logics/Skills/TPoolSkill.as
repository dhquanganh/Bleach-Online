package Logics.Skills
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolSkill extends TPoolAutomatic
   {
      
      protected var FIndexSkill:int;
      
      public function TPoolSkill()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexSkill = RegisterClass(TSkill);
      }
      
      public function Acquire(param1:uint = 0) : TSkill
      {
         var _loc2_:TSkill = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexSkill) as TSkill;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TSkill(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

