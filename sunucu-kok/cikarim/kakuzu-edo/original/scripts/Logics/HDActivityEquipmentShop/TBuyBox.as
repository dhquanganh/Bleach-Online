package Logics.HDActivityEquipmentShop
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.HDActivityMode.TActivityEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TBuyBox extends TActivityEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FGetType:int;
      
      protected var FNeed:int;
      
      protected var FChip:TChip;
      
      protected var FRateData:Vector.<TRateData>;
      
      protected var FAwards:Vector.<uint>;
      
      public function TBuyBox(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FAwards = new Vector.<uint>();
         this.FRateData = new Vector.<TRateData>();
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
      
      public function get Chip() : TChip
      {
         return this.FChip;
      }
      
      public function set Chip(param1:TChip) : void
      {
         this.FChip = param1;
      }
      
      public function get RateData() : Vector.<TRateData>
      {
         return this.FRateData;
      }
      
      public function set RateData(param1:Vector.<TRateData>) : void
      {
         this.FRateData = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
   }
}

