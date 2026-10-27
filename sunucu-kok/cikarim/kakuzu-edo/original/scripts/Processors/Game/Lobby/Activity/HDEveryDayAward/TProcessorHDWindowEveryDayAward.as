package Processors.Game.Lobby.Activity.HDEveryDayAward
{
   import Foundation.UI.TUIComponent;
   import Logics.HDEveryDayAward.TEveryDayAwardData;
   import Logics.Streamization.HDEveryDayAward.TUnstreamizerEveryDayAward;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDEveryDayAward.Windows.TProcessorEveryDayAwardView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowEveryDayAward extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowEveryDayAward(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorEveryDayAwardView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_EveryDayAward]);
         FActivitiesDataReference = Vector.<Class>([TEveryDayAwardData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerEveryDayAward]);
         FTabNum = 0;
         FSceneResourceName = "MC_EveryDayAward";
      }
   }
}

