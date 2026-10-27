package Processors.Game.Lobby.Activity.HDEveryDayAward
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDEveryDayAward extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDEveryDayAward(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 714.45;
         FWindowHeight = 579.75;
         FMainWindowReference = TProcessorHDWindowEveryDayAward;
         FResourceID = CONST_ACTIVITY.RESOURCESID_EveryDayAward;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_EveryDayAward;
      }
   }
}

