package Logics.TreasureMap
{
   public class TTreasureMapHeros
   {
      
      protected var FMapHeros:Vector.<TTreasureMapHero>;
      
      public function TTreasureMapHeros()
      {
         super();
         this.FMapHeros = new Vector.<TTreasureMapHero>();
      }
      
      public function get Count() : int
      {
         return this.FMapHeros.length;
      }
      
      public function GetMapHeroByIndex(param1:int) : TTreasureMapHero
      {
         return this.FMapHeros[param1];
      }
      
      public function GetMapHeroById(param1:uint, param2:uint) : TTreasureMapHero
      {
         var _loc3_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < this.Count)
         {
            if(this.FMapHeros[_loc3_].Identifier0 == param1 && this.FMapHeros[_loc3_].Identifier1 == param2)
            {
               return this.FMapHeros[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetMapHeroByUserIndex(param1:int) : TTreasureMapHero
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            if(this.FMapHeros[_loc2_].UserIndex == param1)
            {
               return this.FMapHeros[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTreasureMapHero = null;
         _loc1_ = int(this.FMapHeros.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMapHeros[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FMapHeros.length = 0;
      }
      
      public function Add(param1:TTreasureMapHero) : void
      {
         param1.StubReferences.Reference(this);
         this.FMapHeros.push(param1);
      }
   }
}

