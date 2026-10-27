package Processors.Game.Lobby.Activity.HDDailyHero
{
   import Foundation.UI.TUIComponent;
   import Logics.HDDailyHero.THDDailyHeroData;
   import Logics.Streamization.HDDailyHero.TUnstreamizerDailyHero;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowDailyHero extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowDailyHero(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorDailyHeroView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_DailyHero]);
         FActivitiesDataReference = Vector.<Class>([THDDailyHeroData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerDailyHero]);
         FTabNum = 0;
         FSceneResourceName = "MC_DailyHero";
      }
   }
}

