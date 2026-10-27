package Processors.Game.Lobby.Activity.HDKnifeChess
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDKnifeChess extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDKnifeChess(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 985;
         FWindowHeight = 631;
         FMainWindowReference = TProcessorHDWindowKnifeChess;
         FResourceID = CONST_ACTIVITY.RESOURCESID_KnifeChess;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_KnifeChess;
      }
   }
}

