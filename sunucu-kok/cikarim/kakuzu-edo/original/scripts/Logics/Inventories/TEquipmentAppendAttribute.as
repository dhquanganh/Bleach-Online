package Logics.Inventories
{
   import Foundation.Common.Stubs.TStubReferences;
   
   public class TEquipmentAppendAttribute
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIdentifier:uint;
      
      protected var FCategory:uint;
      
      protected var FValue:uint;
      
      protected var FName:String;
      
      protected var FSort:uint;
      
      protected var FMaxValue:uint;
      
      protected var FMinValue:uint;
      
      protected var FDivisor:uint;
      
      protected var FPercentage:uint;
      
      public function TEquipmentAppendAttribute()
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
      
      public function get Category() : uint
      {
         return this.FCategory;
      }
      
      public function set Category(param1:uint) : void
      {
         this.FCategory = param1;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
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
      
      public function get Sort() : uint
      {
         return this.FSort;
      }
      
      public function set Sort(param1:uint) : void
      {
         this.FSort = param1;
      }
      
      public function get Divisor() : uint
      {
         return this.FDivisor;
      }
      
      public function set Divisor(param1:uint) : void
      {
         this.FDivisor = param1;
      }
      
      public function get Percentage() : uint
      {
         return this.FPercentage;
      }
      
      public function set Percentage(param1:uint) : void
      {
         this.FPercentage = param1;
      }
      
      public function get MaxValue() : uint
      {
         return this.FMaxValue;
      }
      
      public function set MaxValue(param1:uint) : void
      {
         this.FMaxValue = param1;
      }
      
      public function get MinValue() : uint
      {
         return this.FMinValue;
      }
      
      public function set MinValue(param1:uint) : void
      {
         this.FMinValue = param1;
      }
   }
}

