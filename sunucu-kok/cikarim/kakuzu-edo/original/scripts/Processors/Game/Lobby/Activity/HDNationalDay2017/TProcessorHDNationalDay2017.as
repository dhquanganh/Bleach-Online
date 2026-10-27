package Processors.Game.Lobby.Activity.HDNationalDay2017
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDNationalDay2017 extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDNationalDay2017(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowNationalDay2017;
         FResourceID = CONST_ACTIVITY.RESOURCESID_NationalDay2017;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_NationalDay2017;
      }
   }
}

