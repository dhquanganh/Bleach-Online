package Logics.Rooms.Seat.Player
{
   import Foundation.Common.TEntity64;
   import Logics.Rooms.Seat.Player.Hero.TCollectionHero;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   import Resources.Constants.CONST_TEAMBATTLE;
   
   use namespace LobbySpace;
   
   public class TPlayerRoomDigest extends TEntity64
   {
      
      protected static const CAPACITY_HEROS:uint = CONST_TEAMBATTLE.CAPACITY_HEROS;
      
      protected var FSeatIndex:uint;
      
      protected var FOneselfSeatIndex:uint;
      
      protected var FRoomOwnerIndex:uint;
      
      protected var FRoleTempleteID:uint;
      
      protected var FRoleModelID:uint;
      
      protected var FRoleHeadID:uint;
      
      protected var FNickname:String;
      
      protected var FLevel:uint;
      
      protected var FFightingPower:uint;
      
      protected var FReady:Boolean;
      
      protected var FFriendBuffStatus:Boolean;
      
      protected var FOrganizationBuffStatus:Boolean;
      
      protected var FKnifeExpandID:uint;
      
      protected var FKnifeID:uint;
      
      protected var FKnifeCaption:String;
      
      protected var FHeros:TCollectionHero;
      
      protected var FIsMonster:Boolean;
      
      public function TPlayerRoomDigest(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FNickname = "";
         this.FHeros = new TCollectionHero(CAPACITY_HEROS);
      }
      
      LobbySpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get SeatIndex() : uint
      {
         return this.FSeatIndex;
      }
      
      public function set SeatIndex(param1:uint) : void
      {
         this.FSeatIndex = param1;
      }
      
      public function get OneselfSeatIndex() : uint
      {
         return this.FOneselfSeatIndex;
      }
      
      public function set OneselfSeatIndex(param1:uint) : void
      {
         this.FOneselfSeatIndex = param1;
      }
      
      public function get RoomOwnerIndex() : uint
      {
         return this.FRoomOwnerIndex;
      }
      
      public function set RoomOwnerIndex(param1:uint) : void
      {
         this.FRoomOwnerIndex = param1;
      }
      
      public function get RoleTempleteID() : uint
      {
         return this.FRoleTempleteID;
      }
      
      public function set RoleTempleteID(param1:uint) : void
      {
         this.FRoleTempleteID = param1;
      }
      
      public function get RoleModelID() : uint
      {
         return this.FRoleModelID;
      }
      
      public function set RoleModelID(param1:uint) : void
      {
         this.FRoleModelID = param1;
      }
      
      public function get RoleHeadID() : uint
      {
         return this.FRoleHeadID;
      }
      
      public function set RoleHeadID(param1:uint) : void
      {
         this.FRoleHeadID = param1;
      }
      
      public function get Nickname() : String
      {
         return this.FNickname;
      }
      
      public function set Nickname(param1:String) : void
      {
         this.FNickname = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get FightingPower() : uint
      {
         return this.FFightingPower;
      }
      
      public function set FightingPower(param1:uint) : void
      {
         this.FFightingPower = param1;
      }
      
      public function get Ready() : Boolean
      {
         return this.FReady;
      }
      
      public function set Ready(param1:Boolean) : void
      {
         this.FReady = param1;
      }
      
      public function get FriendBuffStatus() : Boolean
      {
         return this.FFriendBuffStatus;
      }
      
      public function set FriendBuffStatus(param1:Boolean) : void
      {
         this.FFriendBuffStatus = param1;
      }
      
      public function get OrganizationBuffStatus() : Boolean
      {
         return this.FOrganizationBuffStatus;
      }
      
      public function set OrganizationBuffStatus(param1:Boolean) : void
      {
         this.FOrganizationBuffStatus = param1;
      }
      
      public function get KnifeExpandID() : uint
      {
         return this.FKnifeExpandID;
      }
      
      public function set KnifeExpandID(param1:uint) : void
      {
         this.FKnifeExpandID = param1;
      }
      
      public function get KnifeID() : uint
      {
         return this.FKnifeID;
      }
      
      public function set KnifeID(param1:uint) : void
      {
         this.FKnifeID = param1;
      }
      
      public function get KnifeCaption() : String
      {
         return this.FKnifeCaption;
      }
      
      public function set KnifeCaption(param1:String) : void
      {
         this.FKnifeCaption = param1;
      }
      
      public function get Heros() : TCollectionHero
      {
         return this.FHeros;
      }
      
      public function get IsMonster() : Boolean
      {
         return this.FIsMonster;
      }
      
      public function set IsMonster(param1:Boolean) : void
      {
         this.FIsMonster = param1;
      }
      
      public function Reset() : void
      {
         FIdentifier0 = 0;
         FIdentifier1 = 0;
         this.FSeatIndex = 0;
         this.FRoleTempleteID = 0;
         this.FRoleModelID = 0;
         this.FRoleHeadID = 0;
         this.FNickname = "";
         this.FLevel = 0;
         this.FFightingPower = 0;
         this.FKnifeExpandID = 0;
         this.FKnifeID = 0;
         this.FKnifeCaption = "";
         this.FHeros.Clear();
         this.FReady = false;
         this.FFriendBuffStatus = false;
         this.FOrganizationBuffStatus = false;
         this.FIsMonster = false;
      }
   }
}

