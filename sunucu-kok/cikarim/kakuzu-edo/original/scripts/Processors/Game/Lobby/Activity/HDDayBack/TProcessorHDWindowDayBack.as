package Processors.Game.Lobby.Activity.HDDayBack
{
   import Foundation.UI.TUIComponent;
   import Logics.HDDayBack.TDayBackData;
   import Logics.Streamization.HDDayBack.TUnstreamizerDayBack;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDDayBack.windows.TProcessorDayBackView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowDayBack extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowDayBack(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorDayBackView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_DayBack]);
         FActivitiesDataReference = Vector.<Class>([TDayBackData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerDayBack]);
         FTabNum = 0;
         FSceneResourceName = "MC_DayBack";
      }
   }
}

