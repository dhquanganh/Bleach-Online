package Processors.Game.Lobby.Activity.HDDayBack
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDDayBack extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDDayBack(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 822;
         FWindowHeight = 571;
         FMainWindowReference = TProcessorHDWindowDayBack;
         FResourceID = CONST_ACTIVITY.RESOURCESID_DayBack;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_DayBack;
      }
   }
}

