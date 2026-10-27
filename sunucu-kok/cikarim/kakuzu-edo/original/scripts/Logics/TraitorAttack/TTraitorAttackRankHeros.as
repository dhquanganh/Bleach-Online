package Logics.TraitorAttack
{
   import Foundation.Common.Integer.UInt64;
   
   public class TTraitorAttackRankHeros
   {
      
      protected var FTotleHarm:UInt64;
      
      protected var FMySelfHarm:UInt64;
      
      protected var FTraitorAttackRankHeros:Vector.<TTraitorAttackRankHero>;
      
      public function TTraitorAttackRankHeros()
      {
         super();
         this.FTotleHarm = new UInt64();
         this.FMySelfHarm = new UInt64();
         this.FTraitorAttackRankHeros = new Vector.<TTraitorAttackRankHero>();
      }
      
      public function get Count() : int
      {
         return this.FTraitorAttackRankHeros.length;
      }
      
      public function get TotleHarm() : UInt64
      {
         return this.FTotleHarm;
      }
      
      public function set TotleHarm(param1:UInt64) : void
      {
         this.FTotleHarm = param1;
      }
      
      public function get MySelfHarm() : UInt64
      {
         return this.FMySelfHarm;
      }
      
      public function set MySelfHarm(param1:UInt64) : void
      {
         this.FMySelfHarm = param1;
      }
      
      public function GetRankHeroByIndex(param1:int) : TTraitorAttackRankHero
      {
         return this.FTraitorAttackRankHeros[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTraitorAttackRankHero = null;
         _loc1_ = int(this.FTraitorAttackRankHeros.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FTraitorAttackRankHeros[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FTraitorAttackRankHeros.length = 0;
      }
      
      public function Add(param1:TTraitorAttackRankHero) : void
      {
         param1.StubReferences.Reference(this);
         this.FTraitorAttackRankHeros.push(param1);
      }
   }
}

