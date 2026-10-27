package Processors.Game.Lobby.Activity.HDFoolsDay
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDFoolsDay extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDFoolsDay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowFoosDay;
         FResourceID = CONST_ACTIVITY.RESOURCESID_FoolsDay;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_FoolsDay;
      }
   }
}

