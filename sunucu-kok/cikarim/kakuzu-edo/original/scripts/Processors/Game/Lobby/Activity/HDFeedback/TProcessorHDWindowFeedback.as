package Processors.Game.Lobby.Activity.HDFeedback
{
   import Foundation.UI.TUIComponent;
   import Logics.HDFeedback.TFeedbackData;
   import Logics.Streamization.HDFeedback.TUnstreamizerFeedback;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDFeedback.windows.TProcessorFeedbackView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowFeedback extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowFeedback(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorFeedbackView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_Feedback]);
         FActivitiesDataReference = Vector.<Class>([TFeedbackData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerFeedback]);
         FTabNum = 0;
         FSceneResourceName = "MC_Feedback";
      }
   }
}

