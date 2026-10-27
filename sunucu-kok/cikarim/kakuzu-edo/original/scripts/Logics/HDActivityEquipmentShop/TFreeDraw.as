package Logics.HDActivityEquipmentShop
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.HDActivityMode.TActivityEntity;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   use namespace LogicsSpace;
   
   public class TFreeDraw extends TActivityEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FGetType:int;
      
      protected var FLimit:int;
      
      protected var FAmount:int;
      
      protected var FChips:Vector.<TChip>;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FStatus:int;
      
      protected var FCount:int;
      
      public function TFreeDraw(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FChips = new Vector.<TChip>();
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
      
      public function get Limit() : int
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:int) : void
      {
         this.FLimit = param1;
      }
      
      public function get Amount() : int
      {
         return this.FAmount;
      }
      
      public function set Amount(param1:int) : void
      {
         this.FAmount = param1;
      }
      
      public function get Chips() : Vector.<TChip>
      {
         return this.FChips;
      }
      
      public function set Chips(param1:Vector.<TChip>) : void
      {
         this.FChips = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function get Count() : int
      {
         return this.FCount;
      }
      
      public function SetStatus(param1:int) : void
      {
         this.FCount = this.FLimit - param1;
         if(this.Count >= CONST_ACTIVITY_MODE.Activity_CanReceive)
         {
            this.FStatus = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else
         {
            this.FStatus = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         }
      }
   }
}

