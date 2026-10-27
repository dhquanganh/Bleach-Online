package Processors.Game.Lobby.Activity.HDRushInSeireitei
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDRushInSeireitei extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDRushInSeireitei(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 856;
         FWindowHeight = 565;
         FMainWindowReference = TProcessorHDWindowRushInSeireitei;
         FResourceID = CONST_ACTIVITY.RESOURCESID_RushInSeireitei;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_RushInSeireitei;
      }
   }
}

