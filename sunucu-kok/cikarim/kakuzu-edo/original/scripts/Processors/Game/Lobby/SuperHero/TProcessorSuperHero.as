package Processors.Game.Lobby.SuperHero
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import flash.utils.ByteArray;
   
   public class TProcessorSuperHero extends TProcessorLobbyPlate
   {
      
      public function TProcessorSuperHero(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

