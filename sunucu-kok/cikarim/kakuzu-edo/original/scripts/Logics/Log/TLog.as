package Logics.Log
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TLog
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FType:int;
      
      protected var FUserIDHigh:uint;
      
      protected var FUserIDLow:uint;
      
      protected var FName:String;
      
      protected var FRecoredTime:uint;
      
      protected var FData:String;
      
      public function TLog()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get UserIDHigh() : uint
      {
         return this.FUserIDHigh;
      }
      
      public function set UserIDHigh(param1:uint) : void
      {
         this.FUserIDHigh = param1;
      }
      
      public function get UserIDLow() : uint
      {
         return this.FUserIDLow;
      }
      
      public function set UserIDLow(param1:uint) : void
      {
         this.FUserIDLow = param1;
      }
      
      public function get RecoredTime() : uint
      {
         return this.FRecoredTime;
      }
      
      public function set RecoredTime(param1:uint) : void
      {
         this.FRecoredTime = param1;
      }
      
      public function get Data() : String
      {
         return this.FData;
      }
      
      public function set Data(param1:String) : void
      {
         this.FData = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function Reset() : void
      {
         this.FType = 0;
         this.FUserIDHigh = 0;
         this.FUserIDLow = 0;
         this.FRecoredTime = 0;
         this.FData = null;
         this.FName = null;
      }
   }
}

