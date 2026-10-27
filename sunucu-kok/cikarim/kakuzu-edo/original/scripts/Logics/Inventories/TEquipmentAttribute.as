package Logics.Inventories
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TEquipmentAttribute
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIDDescription:uint;
      
      public function TEquipmentAttribute()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get IDDescription() : uint
      {
         return this.FIDDescription;
      }
      
      public function set IDDescription(param1:uint) : void
      {
         this.FIDDescription = param1;
      }
   }
}

