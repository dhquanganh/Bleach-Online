package Processors.Game.Lobby.Activity.KnifeHeroCollect
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDKnifeHeroCollect extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDKnifeHeroCollect(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 833;
         FWindowHeight = 582;
         FMainWindowReference = TProcessorHDWindowKnifeHeroCollect;
         FResourceID = CONST_ACTIVITY.RESOURCESID_KnifeHeroCollect;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_KnifeHeroCollect;
      }
   }
}

