package Processors.Game.Lobby.Activity.HDChristmas2015
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDChristmas2015 extends TProcessorHDMainWindowsBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDChristmas2015(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 950;
         FWindowHeight = 605.45;
         FMainWindowReference = TProcessorHDWindowChristmas2015;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Christmas2015;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Christmas2015;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FMainWindow as TProcessorHDWindowChristmas2015).OnLoadLog = this.FOnLoadLog;
      }
   }
}

