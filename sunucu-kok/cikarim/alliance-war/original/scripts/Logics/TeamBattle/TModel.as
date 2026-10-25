package Logics.TeamBattle
{
   import Foundation.Common.TEntity;
   import Processors.Game.Lobby.Spaces.LobbySpace;
   
   use namespace LobbySpace;
   
   public class TModel extends TEntity
   {
      
      protected var FIsUnlock:Boolean;
      
      public function TModel(param1:uint)
      {
         super(param1);
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
   }
}

