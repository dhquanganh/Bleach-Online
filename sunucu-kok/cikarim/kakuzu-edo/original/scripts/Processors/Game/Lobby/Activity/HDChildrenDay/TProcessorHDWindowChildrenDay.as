package Processors.Game.Lobby.Activity.HDChildrenDay
{
   import Foundation.UI.TUIComponent;
   import Logics.HDChildrenDay.TChildrenDayCollect;
   import Logics.HDChildrenDay.TChildrenDayHero;
   import Logics.HDChildrenDay.TChildrenDayShop;
   import Logics.Streamization.HDChildrenDay.TUnstreamizerChildrenDayCollect;
   import Logics.Streamization.HDChildrenDay.TUnstreamizerChildrenDayHero;
   import Logics.Streamization.HDChildrenDay.TUnstreamizerChildrenDayShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDChildrenDay.windows.TProcessorHDWindowChildrenDayCollect;
   import Processors.Game.Lobby.Activity.HDChildrenDay.windows.TProcessorHDWindowChildrenDayHero;
   import Processors.Game.Lobby.Activity.HDChildrenDay.windows.TProcessorHDWindowChildrenDayShop;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowChildrenDay extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowChildrenDay(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowChildrenDayShop,TProcessorHDWindowChildrenDayHero,TProcessorHDWindowChildrenDayCollect]);
         FWindowUIName = Vector.<String>(["MC_CD_1","MC_CD_2","MC_CD_3"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_ChildrenDayShop,CONST_ACTIVITY_MODE.Activity_ChildrenDayHero,CONST_ACTIVITY_MODE.Activity_ChildrenDayCollect]);
         FActivitiesDataReference = Vector.<Class>([TChildrenDayShop,TChildrenDayHero,TChildrenDayCollect]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerChildrenDayShop,TUnstreamizerChildrenDayHero,TUnstreamizerChildrenDayCollect]);
         FTabNum = 3;
         FSceneResourceName = "MC_ChildrenDay";
      }
   }
}

