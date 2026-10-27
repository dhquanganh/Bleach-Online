package Logics.TraitorAttack
{
   import Foundation.Pools.TPoolAutomatic;
   
   public class TPoolTraitorAttack extends TPoolAutomatic
   {
      
      protected var FIndexTraitorAttackHero:int;
      
      public function TPoolTraitorAttack()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexTraitorAttackHero = RegisterClass(TTraitorAttackRankHero);
      }
      
      public function AcquireRankHero() : TTraitorAttackRankHero
      {
         var _loc1_:TTraitorAttackRankHero = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexTraitorAttackHero) as TTraitorAttackRankHero;
         if(_loc1_ == null)
         {
            _loc1_ = new TTraitorAttackRankHero();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
   }
}

