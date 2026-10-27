package Processors.Game.Lobby.Activity.HDCoolSummer
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDCoolSummer extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDCoolSummer(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 978;
         FWindowHeight = 589;
         FMainWindowReference = TProcessorHDWindowCoolSummer;
         FResourceID = CONST_ACTIVITY.RESOURCESID_CoolSummer;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_CoolSummer;
      }
   }
}

