package Logics.HDActivityEquipmentShop
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.HDActivityMode.TActivityEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TChip extends TActivityEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FGetType:int;
      
      protected var FNeed:int;
      
      protected var FName:String;
      
      protected var FCount:uint;
      
      public function TChip(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FName = "";
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIndex = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get GetType() : int
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:int) : void
      {
         this.FGetType = param1;
      }
      
      public function get Need() : int
      {
         return this.FNeed;
      }
      
      public function set Need(param1:int) : void
      {
         this.FNeed = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Count() : uint
      {
         return this.FCount;
      }
      
      public function set Count(param1:uint) : void
      {
         this.FCount = param1;
      }
      
      public function SetStatus(param1:int) : void
      {
         this.FCount = param1;
      }
   }
}

