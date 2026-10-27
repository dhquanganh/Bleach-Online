package Processors.Game.Lobby.Activity.BRLikeUs
{
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   
   public class TProcessorBRLikeUs extends TProcessorLobbyWindows
   {
      
      public function TProcessorBRLikeUs(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
      }
      
      public function GoodAssess() : void
      {
         SExternalCore.OpenGoodAssess();
      }
      
      public function ShareFriend() : void
      {
         SExternalCore.OpenShareFriend();
      }
      
      public function PlatformSync() : void
      {
         SExternalCore.OpenPlatformSync();
      }
   }
}

