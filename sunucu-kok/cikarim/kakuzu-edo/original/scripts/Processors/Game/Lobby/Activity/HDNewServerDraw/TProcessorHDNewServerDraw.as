package Processors.Game.Lobby.Activity.HDNewServerDraw
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDNewServerDraw extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDNewServerDraw(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 731;
         FWindowHeight = 535;
         FMainWindowReference = TProcessorHDWindowNewServerDraw;
         FResourceID = CONST_ACTIVITY.RESOURCESID_NewServerDraw;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_NewServerDraw;
      }
   }
}

