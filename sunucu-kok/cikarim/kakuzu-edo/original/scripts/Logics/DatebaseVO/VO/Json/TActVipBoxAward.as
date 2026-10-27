package Logics.DatebaseVO.VO.Json
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActVipBoxAward extends TActivityEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FKey:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FPrompt:String;
      
      protected var FLimit:uint;
      
      protected var FCost:uint;
      
      protected var FOriginalPrice:uint;
      
      protected var FGetType:uint;
      
      protected var FStatus:int;
      
      public function TActVipBoxAward(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FPrompt = "";
         this.FAwards = new Vector.<uint>();
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:uint) : void
      {
         this.FLimit = param1;
      }
      
      public function get Key() : uint
      {
         return this.FKey;
      }
      
      public function set Key(param1:uint) : void
      {
         this.FKey = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get OriginalPrice() : uint
      {
         return this.FOriginalPrice;
      }
      
      public function set OriginalPrice(param1:uint) : void
      {
         this.FOriginalPrice = param1;
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

