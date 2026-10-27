package Processors.Game.Lobby.Activity.HDThanksGivingDay2016
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDThanksGivingDay2016 extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDThanksGivingDay2016(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 985;
         FWindowHeight = 631;
         FMainWindowReference = TProcessorHDWindowThanksGivingDay2016;
         FResourceID = CONST_ACTIVITY.RESOURCESID_ThanksGivingDay2016;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_ThanksGivingDay2016;
      }
   }
}

