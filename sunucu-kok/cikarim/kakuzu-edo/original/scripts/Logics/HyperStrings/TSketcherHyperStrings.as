package Logics.HyperStrings
{
   import Rendering.HyperStrings.*;
   
   public class TSketcherHyperStrings
   {
      
      protected var FSketchers:Vector.<TSketcherHyperString>;
      
      public function TSketcherHyperStrings()
      {
         super();
         this.FSketchers = new Vector.<TSketcherHyperString>();
      }
      
      public function get Count() : int
      {
         return this.FSketchers.length;
      }
      
      public function GetSketcherByIndex(param1:int) : TSketcherHyperString
      {
         return this.FSketchers[param1];
      }
      
      public function DeleteSketcherByIndex(param1:int) : TSketcherHyperString
      {
         var _loc2_:TSketcherHyperString = null;
         _loc2_ = this.FSketchers[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FSketchers.splice(param1,1);
         return _loc2_;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSketcherHyperString = null;
         _loc1_ = int(this.FSketchers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FSketchers[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FSketchers.length = 0;
      }
      
      public function Add(param1:TSketcherHyperString) : void
      {
         param1.StubReferences.Reference(this);
         this.FSketchers.push(param1);
      }
   }
}

