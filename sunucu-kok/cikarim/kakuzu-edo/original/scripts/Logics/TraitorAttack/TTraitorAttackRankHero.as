package Logics.TraitorAttack
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TTraitorAttackRankHero
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FHeroName:String;
      
      protected var FHeroHarm:UInt64;
      
      public function TTraitorAttackRankHero()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
         this.FHeroHarm = new UInt64();
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get HeroName() : String
      {
         return this.FHeroName;
      }
      
      public function set HeroName(param1:String) : void
      {
         this.FHeroName = param1;
      }
      
      public function get HeroHarm() : UInt64
      {
         return this.FHeroHarm;
      }
      
      public function set HeroHarm(param1:UInt64) : void
      {
         this.FHeroHarm = param1;
      }
   }
}

