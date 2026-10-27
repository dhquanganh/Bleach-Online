package Processors.Game.Lobby.Activity.HDDuanwujie
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDDuanwujie extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDDuanwujie(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 985;
         FWindowHeight = 631;
         FMainWindowReference = TProcessorHDWindowDuanwujie2016;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Duanwujie2016;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Duanwujie2016;
      }
   }
}

