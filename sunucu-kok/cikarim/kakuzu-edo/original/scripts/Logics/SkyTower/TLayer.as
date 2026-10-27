package Logics.SkyTower
{
   import Foundation.Common.TEntity;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   
   use namespace LobbySpace;
   
   public class TLayer extends TEntity
   {
      
      protected var FLayerName:String;
      
      protected var FAkeyPrice:uint;
      
      protected var FPveRoleTempleteID:uint;
      
      protected var FPveNickname:String;
      
      protected var FPveLevel:uint;
      
      protected var FIsClear:Boolean;
      
      protected var FIsPvpMode:Boolean;
      
      protected var FPvpID:uint;
      
      protected var FPvpRoleHighID:uint;
      
      protected var FPvpRoleLowID:uint;
      
      protected var FPvpRoleTempleteID:uint;
      
      protected var FPvpNickname:String;
      
      protected var FPvpLevel:uint;
      
      protected var FPvpTimer:uint;
      
      protected var FAwardName:String;
      
      protected var FAwardCount:uint;
      
      public function TLayer(param1:uint)
      {
         super(param1);
         this.FIsClear = false;
         this.FLayerName = "";
         this.FPveNickname = "";
         this.FPvpNickname = "";
         this.FAwardName = "";
      }
      
      LobbySpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get LayerName() : String
      {
         return this.FLayerName;
      }
      
      public function set LayerName(param1:String) : void
      {
         this.FLayerName = param1;
      }
      
      public function get AkeyPrice() : uint
      {
         return this.FAkeyPrice;
      }
      
      public function set AkeyPrice(param1:uint) : void
      {
         this.FAkeyPrice = param1;
      }
      
      public function get PveRoleTempleteID() : uint
      {
         return this.FPveRoleTempleteID;
      }
      
      public function set PveRoleTempleteID(param1:uint) : void
      {
         this.FPveRoleTempleteID = param1;
      }
      
      public function get PveNickname() : String
      {
         return this.FPveNickname;
      }
      
      public function set PveNickname(param1:String) : void
      {
         this.FPveNickname = param1;
      }
      
      public function get PveLevel() : uint
      {
         return this.FPveLevel;
      }
      
      public function set PveLevel(param1:uint) : void
      {
         this.FPveLevel = param1;
      }
      
      public function get IsClear() : Boolean
      {
         return this.FIsClear;
      }
      
      public function set IsClear(param1:Boolean) : void
      {
         this.FIsClear = param1;
      }
      
      public function get IsPvpMode() : Boolean
      {
         return this.FIsPvpMode;
      }
      
      public function set IsPvpMode(param1:Boolean) : void
      {
         this.FIsPvpMode = param1;
      }
      
      public function get PvpID() : uint
      {
         return this.FPvpID;
      }
      
      public function set PvpID(param1:uint) : void
      {
         this.FPvpID = param1;
      }
      
      public function get PvpRoleHighID() : uint
      {
         return this.FPvpRoleHighID;
      }
      
      public function set PvpRoleHighID(param1:uint) : void
      {
         this.FPvpRoleHighID = param1;
      }
      
      public function get PvpRoleLowID() : uint
      {
         return this.FPvpRoleLowID;
      }
      
      public function set PvpRoleLowID(param1:uint) : void
      {
         this.FPvpRoleLowID = param1;
      }
      
      public function get PvpRoleTempleteID() : uint
      {
         return this.FPvpRoleTempleteID;
      }
      
      public function set PvpRoleTempleteID(param1:uint) : void
      {
         this.FPvpRoleTempleteID = param1;
      }
      
      public function get PvpNickname() : String
      {
         return this.FPvpNickname;
      }
      
      public function set PvpNickname(param1:String) : void
      {
         this.FPvpNickname = param1;
      }
      
      public function get PvpLevel() : uint
      {
         return this.FPvpLevel;
      }
      
      public function set PvpLevel(param1:uint) : void
      {
         this.FPvpLevel = param1;
      }
      
      public function get PvpTimer() : uint
      {
         return this.FPvpTimer;
      }
      
      public function set PvpTimer(param1:uint) : void
      {
         this.FPvpTimer = param1;
      }
      
      public function get AwardName() : String
      {
         return this.FAwardName;
      }
      
      public function set AwardName(param1:String) : void
      {
         this.FAwardName = param1;
      }
      
      public function get AwardCount() : uint
      {
         return this.FAwardCount;
      }
      
      public function set AwardCount(param1:uint) : void
      {
         this.FAwardCount = param1;
      }
   }
}

