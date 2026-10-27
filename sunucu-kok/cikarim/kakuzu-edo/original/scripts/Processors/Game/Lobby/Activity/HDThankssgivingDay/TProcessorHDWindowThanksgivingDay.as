package Processors.Game.Lobby.Activity.HDThankssgivingDay
{
   import Foundation.UI.TUIComponent;
   import Logics.HDThanksgivingDay.TThankYouData;
   import Logics.HDThanksgivingDay.TThanksFeastData;
   import Logics.HDThanksgivingDay.TThanksTreasureData;
   import Logics.Streamization.HDThanksgivingDay.TUnstreamizerThankYou;
   import Logics.Streamization.HDThanksgivingDay.TUnstreamizerThanksFeast;
   import Logics.Streamization.HDThanksgivingDay.TUnstreamizerThanksTreasure;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows.TProcessorThankYouView;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows.TProcessorThanksFeastView;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows.TProcessorThanksTreasureView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowThanksgivingDay extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowThanksgivingDay(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorThankYouView,TProcessorThanksFeastView,TProcessorThanksTreasureView]);
         FWindowUIName = Vector.<String>(["MC_ThankYouView","MC_ThanksFeastView","MC_ThanksTreasureView"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_ThankYou,CONST_ACTIVITY_MODE.Activity_ThanksFeast,CONST_ACTIVITY_MODE.Activity_ThanksTreasure]);
         FActivitiesDataReference = Vector.<Class>([TThankYouData,TThanksFeastData,TThanksTreasureData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerThankYou,TUnstreamizerThanksFeast,TUnstreamizerThanksTreasure]);
         FTabNum = 3;
         FSceneResourceName = "MC_ThanksgivingDay";
      }
   }
}

