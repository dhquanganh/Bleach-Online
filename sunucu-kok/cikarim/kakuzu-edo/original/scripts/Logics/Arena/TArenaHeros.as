package Logics.Arena
{
   public class TArenaHeros
   {
      
      protected var FArenaHeros:Vector.<TArenaHero>;
      
      public function TArenaHeros()
      {
         super();
         this.FArenaHeros = new Vector.<TArenaHero>();
      }
      
      public function get Count() : int
      {
         return this.FArenaHeros.length;
      }
      
      public function GetHeroByIndex(param1:int) : TArenaHero
      {
         return this.FArenaHeros[param1];
      }
      
      public function GetHeroByRanking(param1:uint) : TArenaHero
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TArenaHero = null;
         _loc2_ = int(this.FArenaHeros.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FArenaHeros[_loc3_];
            if(_loc4_.Ranking == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TArenaHero = null;
         _loc1_ = int(this.FArenaHeros.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FArenaHeros[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FArenaHeros.length = 0;
      }
      
      public function Add(param1:TArenaHero) : void
      {
         param1.StubReferences.Reference(this);
         this.FArenaHeros.push(param1);
      }
   }
}

