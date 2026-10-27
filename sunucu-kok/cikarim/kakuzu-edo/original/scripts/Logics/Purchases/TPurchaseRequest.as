package Logics.Purchases
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TPurchaseRequest
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIDTemplate:uint;
      
      protected var FQuantity:uint;
      
      public function TPurchaseRequest()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get IDTemplate() : uint
      {
         return this.FIDTemplate;
      }
      
      public function set IDTemplate(param1:uint) : void
      {
         this.FIDTemplate = param1;
      }
      
      public function get Quantity() : uint
      {
         return this.FQuantity;
      }
      
      public function set Quantity(param1:uint) : void
      {
         this.FQuantity = param1;
      }
      
      public function Reset() : void
      {
         this.FIDTemplate = 0;
         this.FQuantity = 0;
      }
   }
}

