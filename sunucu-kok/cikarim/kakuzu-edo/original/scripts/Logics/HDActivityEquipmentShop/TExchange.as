package Logics.HDActivityEquipmentShop
{
   import Foundation.Common.Stubs.TStubReferences;
   import Logics.HDActivityMode.TActivityEntity;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   use namespace LogicsSpace;
   
   public class TExchange extends TActivityEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FGetType:int;
      
      protected var FKeysChip:Vector.<TChip>;
      
      protected var FKeysAmount:Vector.<uint>;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FLimit:int;
      
      protected var FType:uint;
      
      protected var FExchangeStatus:int;
      
      protected var FExchangeCount:int;
      
      public function TExchange(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FKeysChip = new Vector.<TChip>();
         this.FKeysAmount = new Vector.<uint>();
         this.FAwards = new Vector.<uint>();
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
      
      public function get KeysChip() : Vector.<TChip>
      {
         return this.FKeysChip;
      }
      
      public function set KeysChip(param1:Vector.<TChip>) : void
      {
         this.FKeysChip = param1;
      }
      
      public function get KeysAmount() : Vector.<uint>
      {
         return this.FKeysAmount;
      }
      
      public function set KeysAmount(param1:Vector.<uint>) : void
      {
         this.FKeysAmount = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Limit() : int
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:int) : void
      {
         this.FLimit = param1;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get ExchangeStatus() : int
      {
         return this.FExchangeStatus;
      }
      
      public function set ExchangeStatus(param1:int) : void
      {
         this.FExchangeStatus = param1;
      }
      
      public function get ExchangeCount() : int
      {
         return this.FExchangeCount;
      }
      
      public function set ExchangeCount(param1:int) : void
      {
         this.FExchangeCount = param1;
      }
      
      public function SetStatus(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FLimit - param1;
         this.FExchangeCount = param1;
         if(this.FLimit == 0)
         {
            this.FExchangeStatus = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else if(_loc2_ >= CONST_ACTIVITY_MODE.Activity_CanReceive)
         {
            this.FExchangeStatus = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else
         {
            this.FExchangeStatus = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         }
      }
   }
}

