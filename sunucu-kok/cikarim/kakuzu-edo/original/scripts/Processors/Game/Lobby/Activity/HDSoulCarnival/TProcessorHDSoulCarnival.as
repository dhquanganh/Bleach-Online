package Processors.Game.Lobby.Activity.HDSoulCarnival
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDSoulCarnival extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDSoulCarnival(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 985;
         FWindowHeight = 631;
         FMainWindowReference = TProcessorHDMainWindowSoulCarnival;
         FResourceID = CONST_ACTIVITY.RESOURCESID_SoulCarnival;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_SoulCarnival;
      }
   }
}

