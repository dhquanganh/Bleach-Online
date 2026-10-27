package Logics.HyperStrings.Elements
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class THyperStringElement
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FTag:uint;
      
      public function THyperStringElement()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      public function Reset() : void
      {
         this.FTag = 0;
      }
      
      public function FlushElement(param1:THyperStringElement) : void
      {
         param1.Tag = this.FTag;
      }
   }
}

