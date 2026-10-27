package Processors.Game.Lobby.Activity.HDThankssgivingDay
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDThanksgivingDay extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDThanksgivingDay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 977;
         FWindowHeight = 604;
         FMainWindowReference = TProcessorHDWindowThanksgivingDay;
         FResourceID = CONST_ACTIVITY.RESOURCESID_ThanksgivingDay;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_ThanksgivingDay;
      }
   }
}

