package Logics.Characters
{
   import Resources.Constants.*;
   
   public class THeros
   {
      
      protected var FHeros:Vector.<THero>;
      
      public function THeros()
      {
         super();
         this.FHeros = new Vector.<THero>();
      }
      
      protected function SortByLevel() : void
      {
         this.FHeros.sort(this.SortLevel);
      }
      
      protected function SortBySpeed() : void
      {
         this.FHeros.sort(this.SortSpeed);
      }
      
      protected function SortLevel(param1:THero, param2:THero) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1.IsMain)
         {
            return -1;
         }
         if(param2.IsMain)
         {
            return 1;
         }
         _loc3_ = param1.Level;
         _loc4_ = param2.Level;
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         _loc5_ = param1.Identifier;
         _loc6_ = param2.Identifier;
         if(_loc5_ > _loc6_)
         {
            return -1;
         }
         if(_loc5_ < _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function SortSpeed(param1:THero, param2:THero) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc3_ = param1.BaseAttributeSpeed;
         _loc4_ = param2.BaseAttributeSpeed;
         if(_loc3_ > _loc4_)
         {
            return -1;
         }
         if(_loc3_ < _loc4_)
         {
            return 1;
         }
         _loc5_ = param1.Identifier;
         _loc6_ = param2.Identifier;
         if(_loc5_ > _loc6_)
         {
            return -1;
         }
         if(_loc5_ < _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FHeros.length;
      }
      
      public function GetHeroByIndex(param1:int) : THero
      {
         return this.FHeros[param1];
      }
      
      public function GetHeroByIdentifier(param1:uint) : THero
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         _loc2_ = int(this.FHeros.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FHeros[_loc3_];
            if(_loc4_.Identifier == param1)
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
         var _loc3_:THero = null;
         _loc1_ = int(this.FHeros.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FHeros[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FHeros.length = 0;
      }
      
      public function Add(param1:THero) : void
      {
         param1.StubReferences.Reference(this);
         this.FHeros.push(param1);
      }
      
      public function Delete(param1:THero) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FHeros.length)
         {
            if(param1.Identifier == this.FHeros[_loc2_].Identifier)
            {
               param1.StubReferences.Dereference(this);
               this.FHeros.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function Sort() : void
      {
         this.SortByLevel();
      }
      
      public function SortByHeroSpeed() : void
      {
         this.SortBySpeed();
      }
      
      public function SortHeros(param1:Function) : void
      {
         this.FHeros.sort(param1);
      }
   }
}

