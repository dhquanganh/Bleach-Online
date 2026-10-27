package Processors.Game.Lobby.Activity.HDUniteTask
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDUniteTask extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDUniteTask(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 856;
         FWindowHeight = 565;
         FMainWindowReference = TProcessorHDWindowUniteTask;
         FResourceID = CONST_ACTIVITY.RESOURCESID_UniteTask;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_UniteTask;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         (FMainWindow as TProcessorHDWindowUniteTask).OnCreateKnifeOfKillSoulData = param1;
      }
   }
}

