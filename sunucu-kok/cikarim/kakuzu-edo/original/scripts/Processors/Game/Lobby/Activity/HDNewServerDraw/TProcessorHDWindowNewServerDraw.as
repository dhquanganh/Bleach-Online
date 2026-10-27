package Processors.Game.Lobby.Activity.HDNewServerDraw
{
   import Foundation.UI.TUIComponent;
   import Logics.HDNewServerDraw.TNewServerDrawData;
   import Logics.Streamization.HDNewServerDraw.TUnstreamizerNewServerDraw;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNewServerDraw.Windows.TProcessorNewServerDrawView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNewServerDraw extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowNewServerDraw(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorNewServerDrawView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NewServerDraw]);
         FActivitiesDataReference = Vector.<Class>([TNewServerDrawData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNewServerDraw]);
         FTabNum = 0;
         FSceneResourceName = "MC_NewServerDraw";
      }
   }
}

