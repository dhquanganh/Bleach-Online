package Logics.Signals
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TSignal
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FDestination:uint;
      
      protected var FIdentifier:uint;
      
      protected var FValue:int;
      
      protected var FUserData:Object;
      
      public function TSignal()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Destination() : uint
      {
         return this.FDestination;
      }
      
      public function set Destination(param1:uint) : void
      {
         this.FDestination = param1;
      }
      
      public function get Identifier() : uint
      {
         return this.FIdentifier;
      }
      
      public function set Identifier(param1:uint) : void
      {
         this.FIdentifier = param1;
      }
      
      public function get Value() : int
      {
         return this.FValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.FValue = param1;
      }
      
      public function get UserData() : Object
      {
         return this.FUserData;
      }
      
      public function set UserData(param1:Object) : void
      {
         this.FUserData = param1;
      }
   }
}

