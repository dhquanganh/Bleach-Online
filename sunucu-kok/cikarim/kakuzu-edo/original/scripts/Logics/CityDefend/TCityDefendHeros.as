package Logics.CityDefend
{
   public class TCityDefendHeros
   {
      
      protected var FCityDefendHeros:Vector.<TCityDefendHero>;
      
      public function TCityDefendHeros()
      {
         super();
         this.FCityDefendHeros = new Vector.<TCityDefendHero>();
      }
      
      public function get Count() : int
      {
         return this.FCityDefendHeros.length;
      }
      
      public function GetHeroByIndex(param1:int) : TCityDefendHero
      {
         return this.FCityDefendHeros[param1];
      }
      
      public function GetHeroById(param1:uint, param2:uint) : TCityDefendHero
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TCityDefendHero = null;
         _loc3_ = int(this.FCityDefendHeros.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FCityDefendHeros[_loc4_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCityDefendHero = null;
         _loc1_ = int(this.FCityDefendHeros.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FCityDefendHeros[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FCityDefendHeros.length = 0;
      }
      
      public function Add(param1:TCityDefendHero) : void
      {
         param1.StubReferences.Reference(this);
         this.FCityDefendHeros.push(param1);
      }
      
      public function Dec(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TCityDefendHero = null;
         _loc3_ = int(this.FCityDefendHeros.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FCityDefendHeros[_loc4_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               _loc5_.StubReferences.Dereference(this);
               this.FCityDefendHeros.splice(_loc4_,1);
               return;
            }
            _loc4_++;
         }
      }
   }
}

