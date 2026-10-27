package Logics.Unlocks
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnlock extends TEntity
   {
      
      public static const UNLOCKSTATE_Unlock:uint = 0;
      
      public static const UNLOCKSTATE_Unlocking:uint = 1;
      
      public static const UNLOCKSTATE_Unlocked:uint = 2;
      
      public static const UNLOCKSTATE_ForcedOff:uint = 3;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FName:String;
      
      protected var FPosition:uint;
      
      protected var FIndex:uint;
      
      protected var FCombineType:uint;
      
      protected var FConditiontType:uint;
      
      protected var FConditiontValue:uint;
      
      protected var FUnlockState:uint;
      
      protected var FDesc:String;
      
      public function TUnlock(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
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
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get CombineType() : uint
      {
         return this.FCombineType;
      }
      
      public function set CombineType(param1:uint) : void
      {
         this.FCombineType = param1;
      }
      
      public function get Position() : uint
      {
         return this.FPosition;
      }
      
      public function set Position(param1:uint) : void
      {
         this.FPosition = param1;
      }
      
      public function get ConditiontType() : uint
      {
         return this.FConditiontType;
      }
      
      public function set ConditiontType(param1:uint) : void
      {
         this.FConditiontType = param1;
      }
      
      public function get ConditiontValue() : uint
      {
         return this.FConditiontValue;
      }
      
      public function set ConditiontValue(param1:uint) : void
      {
         this.FConditiontValue = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
      
      LogicsSpace function get UnlockState() : uint
      {
         return this.FUnlockState;
      }
      
      LogicsSpace function set UnlockState(param1:uint) : void
      {
         this.FUnlockState = param1;
      }
      
      public function get State() : uint
      {
         return this.FUnlockState;
      }
      
      public function Reset() : void
      {
         FIdentifier = 0;
         this.FName = "";
         this.FIndex = 0;
         this.FCombineType = 0;
         this.FPosition = 0;
         this.FConditiontType = 0;
         this.FConditiontValue = 0;
         this.FDesc = "";
      }
   }
}

