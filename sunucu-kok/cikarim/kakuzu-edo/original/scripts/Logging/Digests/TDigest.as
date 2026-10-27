package Logging.Digests
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logging.Spaces.LoggingSpace;
   
   use namespace LoggingSpace;
   
   public class TDigest extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FOutputType:uint;
      
      protected var FLevel:uint;
      
      protected var FContent:*;
      
      protected var FAdditional:Array;
      
      public function TDigest(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LoggingSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get OutputType() : uint
      {
         return this.FOutputType;
      }
      
      public function set OutputType(param1:uint) : void
      {
         this.FOutputType = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Content() : *
      {
         return this.FContent;
      }
      
      public function set Content(param1:*) : void
      {
         this.FContent = param1;
      }
      
      public function get Additional() : Array
      {
         return this.FAdditional;
      }
      
      public function set Additional(param1:Array) : void
      {
         this.FAdditional = param1;
      }
      
      public function Reset() : void
      {
         FIdentifier = 0;
         this.FOutputType = 0;
         this.FLevel = 0;
      }
   }
}

