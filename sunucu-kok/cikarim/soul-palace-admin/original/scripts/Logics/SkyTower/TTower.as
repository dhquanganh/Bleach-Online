package Logics.SkyTower
{
   import Foundation.Common.TEntity;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   
   use namespace LobbySpace;
   
   public class TTower extends TEntity
   {
      
      protected var FLayers:TLayers;
      
      protected var FIsUnlock:Boolean;
      
      protected var FName:String;
      
      protected var FOpenLevel:uint;
      
      protected var FTag:uint;
      
      public function TTower(param1:uint)
      {
         super(param1);
         this.FLayers = new TLayers();
         this.FIsUnlock = false;
      }
      
      LobbySpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get IsUnlock() : Boolean
      {
         return this.FIsUnlock;
      }
      
      public function set IsUnlock(param1:Boolean) : void
      {
         this.FIsUnlock = param1;
      }
      
      public function get Layers() : TLayers
      {
         return this.FLayers;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get OpenLevel() : uint
      {
         return this.FOpenLevel;
      }
      
      public function set OpenLevel(param1:uint) : void
      {
         this.FOpenLevel = param1;
      }
      
      public function get Tag() : uint
      {
         return this.FTag;
      }
      
      public function set Tag(param1:uint) : void
      {
         this.FTag = param1;
      }
      
      public function Clear() : void
      {
         this.FLayers.Clear();
      }
   }
}

