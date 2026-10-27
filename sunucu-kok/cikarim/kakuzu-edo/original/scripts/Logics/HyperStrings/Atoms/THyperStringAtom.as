package Logics.HyperStrings.Atoms
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TBounds;
   import Foundation.UI.TUIComponent;
   import Logics.HyperStrings.Elements.THyperStringElement;
   
   public class THyperStringAtom extends TUIComponent
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FLineIndex:int;
      
      protected var FElement:THyperStringElement;
      
      protected var FBounds:TBounds;
      
      public function THyperStringAtom(param1:TUIComponent)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FBounds = new TBounds();
         this.mouseEnabled = false;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get LineIndex() : int
      {
         return this.FLineIndex;
      }
      
      public function set LineIndex(param1:int) : void
      {
         this.FLineIndex = param1;
      }
      
      public function get Element() : THyperStringElement
      {
         return this.FElement;
      }
      
      public function set Element(param1:THyperStringElement) : void
      {
         if(param1 != this.FElement)
         {
            if(this.FElement != null)
            {
               this.FElement.StubReferences.Dereference(this);
            }
            if(param1 != null)
            {
               param1.StubReferences.Reference(this);
            }
            this.FElement = param1;
         }
      }
      
      public function get Bounds() : TBounds
      {
         return this.FBounds;
      }
      
      public function Reset() : void
      {
         this.FLineIndex = -1;
         if(this.FElement != null)
         {
            this.FElement.StubReferences.Dereference(this);
            this.FElement = null;
         }
         this.FBounds.Reset();
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      public function Render() : void
      {
      }
   }
}

