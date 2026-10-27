package Processors.Game.Lobby.Activity.HDBrushHappy
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDBrushHappy extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDBrushHappy(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 777;
         FWindowHeight = 505;
         FMainWindowReference = TProcessorHDWindowBrushHappy;
         FResourceID = CONST_ACTIVITY.RESOURCESID_BrushHappy;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_BrushHappy;
      }
   }
}

