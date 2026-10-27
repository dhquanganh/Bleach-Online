package Processors.Game.Lobby.Activity.HDLaborDay2016
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDLaborDay2016 extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDLaborDay2016(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 985;
         FWindowHeight = 631;
         FMainWindowReference = TProcessorHDWindowLaborDay2016;
         FResourceID = CONST_ACTIVITY.RESOURCESID_LaborDay2016;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_LaborDay2016;
      }
   }
}

