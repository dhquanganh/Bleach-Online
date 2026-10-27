package Logics.Characters
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TDigest extends TEntity64
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FType:uint;
      
      protected var FName:String;
      
      protected var FLevel:uint;
      
      public function TDigest(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function Reset() : void
      {
         FIdentifier0 = 0;
         FIdentifier1 = 0;
         this.FType = 0;
         this.FName = "";
         this.FLevel = 0;
      }
   }
}

