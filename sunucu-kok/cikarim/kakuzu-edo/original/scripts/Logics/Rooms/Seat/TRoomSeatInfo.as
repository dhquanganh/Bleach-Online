package Logics.Rooms.Seat
{
   import Foundation.Common.*;
   import Foundation.Common.Stubs.*;
   import Logics.Rooms.Seat.Player.TPlayerRoomDigest;
   import Processors.Game.Lobby.Spaces.*;
   
   use namespace LobbySpace;
   
   public class TRoomSeatInfo extends TEntity
   {
      
      protected static const CAPACITY_PLAYERS:uint = 3;
      
      protected static const CAPACITY_MONSTERS:uint = 6;
      
      protected var FPassword:String;
      
      protected var FModelID:uint;
      
      protected var FRoomOwnerIndex:uint;
      
      protected var FOneselfIndex:uint;
      
      protected var FPlayerRoomDigests:Vector.<TPlayerRoomDigest>;
      
      protected var FMonsterDigests:Vector.<TPlayerRoomDigest>;
      
      public function TRoomSeatInfo(param1:uint)
      {
         super(param1);
         this.ConstructorPlayerRoomDigests();
         this.ConstructorMonsterDigests();
      }
      
      LobbySpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      protected function ConstructorPlayerRoomDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TPlayerRoomDigest = null;
         this.FPlayerRoomDigests = new Vector.<TPlayerRoomDigest>(CAPACITY_PLAYERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc2_ = new TPlayerRoomDigest(0,0);
            this.FPlayerRoomDigests[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function ConstructorMonsterDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TPlayerRoomDigest = null;
         this.FMonsterDigests = new Vector.<TPlayerRoomDigest>(CAPACITY_MONSTERS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            _loc2_ = new TPlayerRoomDigest(0,0);
            this.FMonsterDigests[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      public function get PlayerCount() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPlayerRoomDigest = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc3_ = this.FPlayerRoomDigests[_loc1_];
            if(_loc3_.Identifier0 != 0 || _loc3_.Identifier1 != 0)
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get ReadyCount() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPlayerRoomDigest = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            _loc3_ = this.FPlayerRoomDigests[_loc1_];
            if((_loc3_.Identifier0 != 0 || _loc3_.Identifier1 != 0) && _loc3_.Ready)
            {
               _loc2_++;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Password() : String
      {
         return this.FPassword;
      }
      
      public function set Password(param1:String) : void
      {
         this.FPassword = param1;
      }
      
      public function get ModelID() : uint
      {
         return this.FModelID;
      }
      
      public function set ModelID(param1:uint) : void
      {
         this.FModelID = param1;
      }
      
      public function get RoomOwnerIndex() : uint
      {
         return this.FRoomOwnerIndex;
      }
      
      public function set RoomOwnerIndex(param1:uint) : void
      {
         this.FRoomOwnerIndex = param1;
      }
      
      public function get OneselfIndex() : uint
      {
         return this.FOneselfIndex;
      }
      
      public function set OneselfIndex(param1:uint) : void
      {
         this.FOneselfIndex = param1;
      }
      
      public function get PlayerRoomDigests() : Vector.<TPlayerRoomDigest>
      {
         return this.FPlayerRoomDigests;
      }
      
      public function get MonsterDigests() : Vector.<TPlayerRoomDigest>
      {
         return this.FMonsterDigests;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         FIdentifier = 0;
         this.FPassword = "";
         this.FModelID = 0;
         this.FRoomOwnerIndex = 0;
         this.FOneselfIndex = 0;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PLAYERS)
         {
            this.FPlayerRoomDigests[_loc1_].Reset();
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MONSTERS)
         {
            this.FMonsterDigests[_loc1_].Reset();
            _loc1_++;
         }
      }
   }
}

