package Processors.Game.Lobby.Activity.HDNewYear2016
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDNewYear2016 extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDNewYear2016(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowNewYear2016;
         FResourceID = CONST_ACTIVITY.RESOURCESID_NewYear2016;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_NewYear2016;
      }
   }
}

