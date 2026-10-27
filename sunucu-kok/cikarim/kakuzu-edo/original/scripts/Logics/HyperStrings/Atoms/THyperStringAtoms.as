package Logics.HyperStrings.Atoms
{
   public class THyperStringAtoms
   {
      
      protected var FAtoms:Vector.<THyperStringAtom>;
      
      public function THyperStringAtoms()
      {
         super();
         this.FAtoms = new Vector.<THyperStringAtom>();
      }
      
      public function get Count() : int
      {
         return this.FAtoms.length;
      }
      
      public function GetAtomByIndex(param1:int) : THyperStringAtom
      {
         return this.FAtoms[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THyperStringAtom = null;
         _loc1_ = int(this.FAtoms.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FAtoms[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FAtoms.length = 0;
      }
      
      public function Add(param1:THyperStringAtom) : void
      {
         param1.StubReferences.Reference(this);
         this.FAtoms.push(param1);
      }
   }
}

