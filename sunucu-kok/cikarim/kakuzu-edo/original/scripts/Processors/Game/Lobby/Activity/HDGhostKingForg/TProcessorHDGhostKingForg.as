package Processors.Game.Lobby.Activity.HDGhostKingForg
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDGhostKingForg extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDGhostKingForg(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 924;
         FWindowHeight = 612;
         FMainWindowReference = TProcessorHDWindowGhostKingForg;
         FResourceID = CONST_ACTIVITY.RESOURCESID_GhostKingForg;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_GhostKingForg;
      }
   }
}

