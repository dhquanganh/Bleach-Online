package Processors.Game.Lobby.Activity.HDPyramid
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProsessorHDPyramid extends TProcessorHDMainWindowsBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProsessorHDPyramid(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 674;
         FWindowHeight = 490;
         FMainWindowReference = TProsessorHDWindowPyramid;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Pyramid;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Pyramid;
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FMainWindow as TProsessorHDWindowPyramid).OnLoadLog = this.FOnLoadLog;
      }
   }
}

