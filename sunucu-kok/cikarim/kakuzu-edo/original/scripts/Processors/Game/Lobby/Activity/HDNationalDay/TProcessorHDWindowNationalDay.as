package Processors.Game.Lobby.Activity.HDNationalDay
{
   import Foundation.UI.TUIComponent;
   import Logics.HDNationalDay.TNationalDayOne;
   import Logics.HDNationalDay.TNationalDayTwo;
   import Logics.Streamization.HDNationalDay.TUnstreamizerNationalDayOne;
   import Logics.Streamization.HDNationalDay.TUnstreamizerNationalDayTwo;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNationalDay.Windows.TProcessorNationalOne;
   import Processors.Game.Lobby.Activity.HDNationalDay.Windows.TProcessorNationalTwo;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNationalDay extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowNationalDay(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorNationalOne,TProcessorNationalTwo]);
         FWindowUIName = Vector.<String>(["MC_NationalOne","MC_NationalTwo"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NationalOne,CONST_ACTIVITY_MODE.Activity_NationalTwo]);
         FActivitiesDataReference = Vector.<Class>([TNationalDayOne,TNationalDayTwo]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNationalDayOne,TUnstreamizerNationalDayTwo]);
         FTabNum = 2;
         FSceneResourceName = "MC_NationalDay";
      }
   }
}

