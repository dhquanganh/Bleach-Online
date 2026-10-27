package Logics.Pet
{
   import Resources.Constants.*;
   
   public class TPets
   {
      
      protected var FPets:Vector.<TPetBase>;
      
      public function TPets()
      {
         super();
         this.FPets = new Vector.<TPetBase>();
      }
      
      protected function SortByIdentifier() : void
      {
         this.FPets.sort(this.SortIdentifier);
      }
      
      protected function SortIdentifier(param1:TPetBase, param2:TPetBase) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
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
         _loc5_ = param1.TemplateID;
         _loc6_ = param2.TemplateID;
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function SortByCompositeState() : void
      {
         this.FPets.sort(this.SortComposite);
      }
      
      protected function SortComposite(param1:TPetBase, param2:TPetBase) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TVicePet = null;
         var _loc6_:TVicePet = null;
         _loc5_ = param1 as TVicePet;
         _loc6_ = param2 as TVicePet;
         _loc3_ = param1.TemplateID;
         _loc4_ = param2.TemplateID;
         if(_loc3_ < _loc4_ && _loc5_.CompositeState)
         {
            return -1;
         }
         if(_loc3_ > _loc4_ && _loc6_.CompositeState)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FPets.length;
      }
      
      public function GetPetByIndex(param1:int) : TPetBase
      {
         return this.FPets[param1];
      }
      
      public function GetIndexByPetID(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPetBase = null;
         _loc2_ = int(this.FPets.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FPets[_loc3_];
            if(_loc4_.TemplateID == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function GetPetByIdentifier(param1:uint, param2:uint) : TPetBase
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TPetBase = null;
         _loc3_ = int(this.FPets.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FPets[_loc4_];
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
         var _loc3_:TPetBase = null;
         _loc1_ = int(this.FPets.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FPets[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FPets.length = 0;
      }
      
      public function Add(param1:TPetBase) : void
      {
         param1.StubReferences.Reference(this);
         this.FPets.push(param1);
      }
      
      public function DeletePetByIdentifier(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPetBase = null;
         _loc3_ = 0;
         while(_loc3_ < this.FPets.length)
         {
            _loc4_ = this.FPets[_loc3_];
            if(param1 == _loc4_.Identifier0 && param2 == _loc4_.Identifier1)
            {
               _loc4_.StubReferences.Dereference(this);
               this.FPets.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
      
      public function Delete(param1:TPetBase) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FPets.length)
         {
            if(param1.Identifier0 == this.FPets[_loc2_].Identifier0 && param1.Identifier1 == this.FPets[_loc2_].Identifier1)
            {
               param1.StubReferences.Dereference(this);
               this.FPets.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function Sort() : void
      {
         this.SortByIdentifier();
      }
      
      public function SortCompositeState() : void
      {
         this.SortByCompositeState();
      }
   }
}

