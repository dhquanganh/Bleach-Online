package Processors.Game.Lobby.Activity.HDDailyHero
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDDailyHero extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDDailyHero(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 742;
         FWindowHeight = 510;
         FMainWindowReference = TProcessorHDWindowDailyHero;
         FResourceID = CONST_ACTIVITY.RESOURCESID_DailyHero;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_DailyHero;
      }
   }
}

