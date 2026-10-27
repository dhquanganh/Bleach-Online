package Processors.Game.Lobby.Activity.HDChildrenDay
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDChildrenDay extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDChildrenDay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowChildrenDay;
         FResourceID = CONST_ACTIVITY.RESOURCESID_ChildrenDay;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_ChildrenDay;
      }
   }
}

