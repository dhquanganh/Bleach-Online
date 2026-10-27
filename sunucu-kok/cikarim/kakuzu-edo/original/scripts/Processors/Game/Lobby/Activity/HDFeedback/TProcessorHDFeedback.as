package Processors.Game.Lobby.Activity.HDFeedback
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   
   public class TProcessorHDFeedback extends TProcessorHDMainWindowsBase
   {
      
      public function TProcessorHDFeedback(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function SetupParams() : void
      {
         FWindowWidth = 821;
         FWindowHeight = 573;
         FMainWindowReference = TProcessorHDWindowFeedback;
         FResourceID = CONST_ACTIVITY.RESOURCESID_Feedback;
         FMainType = CONST_SHORTCUTS.TYPE_ActiveList_Feedback;
      }
   }
}

