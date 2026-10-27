package Logics.Inventories
{
   public class TSuitEffects
   {
      
      protected var FSuitEffects:Vector.<TSuitEffect>;
      
      public function TSuitEffects()
      {
         super();
         this.FSuitEffects = new Vector.<TSuitEffect>();
      }
      
      public function get Count() : int
      {
         return this.FSuitEffects.length;
      }
      
      public function GetSuitEffectByIndex(param1:int) : TSuitEffect
      {
         return this.FSuitEffects[param1];
      }
      
      public function Add(param1:TSuitEffect) : void
      {
         param1.StubReferences.Reference(this);
         this.FSuitEffects.push(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSuitEffect = null;
         _loc1_ = int(this.FSuitEffects.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FSuitEffects[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FSuitEffects.length = 0;
      }
   }
}

