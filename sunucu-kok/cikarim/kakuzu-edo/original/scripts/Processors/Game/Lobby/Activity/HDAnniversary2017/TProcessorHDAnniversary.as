package Processors.Game.Lobby.Activity.HDAnniversary2017
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDAnniversary extends TProcessorHDMainWindowsBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDAnniversary(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowAnniversary;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Anniversary;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Anniversary;
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FMainWindow as TProcessorHDWindowAnniversary).OnLoadLog = this.FOnLoadLog;
      }
   }
}

