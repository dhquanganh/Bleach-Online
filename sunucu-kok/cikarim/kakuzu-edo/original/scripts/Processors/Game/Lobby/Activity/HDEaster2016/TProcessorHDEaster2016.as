package Processors.Game.Lobby.Activity.HDEaster2016
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDEaster2016 extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDEaster2016(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 826;
         FWindowHeight = 584;
         FMainWindowReference = TProcessorHDWindowEaster2016;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Easter2016;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Easter2016;
      }
   }
}

