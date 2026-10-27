package Rendering.HyperStrings
{
   import Foundation.Pools.TPoolAutomatic;
   import Foundation.UI.TUIComponent;
   
   public class TPoolSketcherHyperString extends TPoolAutomatic
   {
      
      protected var FIndexSketcherHyperString:int;
      
      public function TPoolSketcherHyperString()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexSketcherHyperString = RegisterClass(TSketcherHyperString,this.ReleasingPerform_SketcherHyperString);
      }
      
      public function ReleasingPerform_SketcherHyperString(param1:Object) : void
      {
         var _loc2_:TSketcherHyperString = null;
         _loc2_ = param1 as TSketcherHyperString;
         _loc2_.Reset();
      }
      
      public function Acquire(param1:TUIComponent) : TSketcherHyperString
      {
         var _loc2_:TSketcherHyperString = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexSketcherHyperString) as TSketcherHyperString;
         if(_loc2_ == null)
         {
            _loc2_ = new TSketcherHyperString(param1);
         }
         else
         {
            param1.addChild(_loc2_);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

