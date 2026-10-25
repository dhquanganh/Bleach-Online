package Logics.Rooms
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   
   use namespace LobbySpace;
   
   public class TRoomDigest extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FOperatingType:uint;
      
      protected var FName:String;
      
      protected var FModelID:uint;
      
      protected var FPlayerCount:int;
      
      protected var FPassworded:Boolean;
      
      protected var FIsFighting:Boolean;
      
      protected var FModeType:uint;
      
      protected var FModelName:String;
      
      protected var FPlayerCapacity:int;
      
      protected var FSuitableLevel:String;
      
      protected var FResourceID:uint;
      
      public function TRoomDigest(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FName = "";
         this.FModelName = "";
         this.FSuitableLevel = "";
      }
      
      LobbySpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get OperatingType() : uint
      {
         return this.FOperatingType;
      }
      
      public function set OperatingType(param1:uint) : void
      {
         this.FOperatingType = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get ModelID() : uint
      {
         return this.FModelID;
      }
      
      public function set ModelID(param1:uint) : void
      {
         this.FModelID = param1;
      }
      
      public function get PlayerCount() : int
      {
         return this.FPlayerCount;
      }
      
      public function set PlayerCount(param1:int) : void
      {
         this.FPlayerCount = param1;
      }
      
      public function get Passworded() : Boolean
      {
         return this.FPassworded;
      }
      
      public function set Passworded(param1:Boolean) : void
      {
         this.FPassworded = param1;
      }
      
      public function get IsFighting() : Boolean
      {
         return this.FIsFighting;
      }
      
      public function set IsFighting(param1:Boolean) : void
      {
         this.FIsFighting = param1;
      }
      
      public function get ModeType() : uint
      {
         return this.FModeType;
      }
      
      public function set ModeType(param1:uint) : void
      {
         this.FModeType = param1;
      }
      
      public function get ModelName() : String
      {
         return this.FModelName;
      }
      
      public function set ModelName(param1:String) : void
      {
         this.FModelName = param1;
      }
      
      public function get PlayerCapacity() : int
      {
         return this.FPlayerCapacity;
      }
      
      public function set PlayerCapacity(param1:int) : void
      {
         this.FPlayerCapacity = param1;
      }
      
      public function get SuitableLevel() : String
      {
         return this.FSuitableLevel;
      }
      
      public function set SuitableLevel(param1:String) : void
      {
         this.FSuitableLevel = param1;
      }
      
      public function get ResourceID() : uint
      {
         return this.FResourceID;
      }
      
      public function set ResourceID(param1:uint) : void
      {
         this.FResourceID = param1;
      }
      
      public function Reset() : void
      {
         this.FOperatingType = 0;
         this.FName = "";
         this.FModelID = 0;
         this.FPlayerCount = 0;
         this.FPassworded = false;
         this.FIsFighting = false;
         this.FModeType = 0;
         this.FModelName = "";
         this.FSuitableLevel = "";
         this.FResourceID = 0;
      }
   }
}

