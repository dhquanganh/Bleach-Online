package Logics.Tavern
{
   public class TMoras
   {
      
      protected var FMoraType:int;
      
      protected var FMoras:Vector.<TMora>;
      
      public function TMoras()
      {
         super();
         this.FMoras = new Vector.<TMora>();
      }
      
      public function get Count() : int
      {
         return this.FMoras.length;
      }
      
      public function get MoraType() : int
      {
         return this.FMoraType;
      }
      
      public function set MoraType(param1:int) : void
      {
         this.FMoraType = param1;
      }
      
      public function GetMoraByIndex(param1:uint) : TMora
      {
         return this.FMoras[param1];
      }
      
      public function GetMoraByHeroId(param1:uint) : TMora
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TMora = null;
         _loc2_ = int(this.FMoras.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FMoras[_loc3_];
            if(param1 == _loc4_.TavernHeroId)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetIndexWithHeroId(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TMora = null;
         _loc2_ = int(this.FMoras.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FMoras[_loc3_];
            if(param1 == _loc4_.TavernHeroId)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return _loc3_;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMora = null;
         _loc1_ = int(this.FMoras.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMoras[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FMoras.length = 0;
      }
      
      public function Add(param1:TMora) : void
      {
         param1.StubReferences.Reference(this);
         this.FMoras.push(param1);
      }
   }
}

