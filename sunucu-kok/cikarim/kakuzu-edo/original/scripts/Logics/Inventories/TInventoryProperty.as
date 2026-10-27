package Logics.Inventories
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TInventoryProperty
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIdentifier:uint;
      
      protected var FName:String;
      
      protected var FValue:Number;
      
      protected var FOper:int;
      
      public function TInventoryProperty()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Identifier() : uint
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:uint) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get Value() : Number
      {
         return this.FValue;
      }
      
      public function set Value(param1:Number) : void
      {
         this.FValue = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Oper() : int
      {
         return this.FOper;
      }
      
      public function set Oper(param1:int) : void
      {
         this.FOper = param1;
      }
   }
}

