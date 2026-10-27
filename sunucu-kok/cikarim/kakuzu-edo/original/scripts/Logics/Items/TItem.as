package Logics.Items
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TItem
   {
      
      protected var FStubReferences:TStubReferences;
      
      private var FType:int;
      
      private var FID:int;
      
      private var FCount:int;
      
      public function TItem()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get ID() : int
      {
         return this.FID;
      }
      
      public function set ID(param1:int) : void
      {
         this.FID = param1;
      }
      
      public function get Count() : int
      {
         return this.FCount;
      }
      
      public function set Count(param1:int) : void
      {
         this.FCount = param1;
      }
   }
}

