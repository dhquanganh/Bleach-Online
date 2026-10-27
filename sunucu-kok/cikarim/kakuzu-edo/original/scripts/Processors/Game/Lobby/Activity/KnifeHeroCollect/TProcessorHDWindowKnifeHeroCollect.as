package Processors.Game.Lobby.Activity.KnifeHeroCollect
{
   import Foundation.UI.TUIComponent;
   import Logics.HDKnifeHeroCollect.TKnifeHeroCollectData;
   import Logics.Streamization.HDKnifeHeroCollect.TUnstreamizerKnifeHeroCollect;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.KnifeHeroCollect.Windows.TProcessorKnifeHeroCollectView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowKnifeHeroCollect extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowKnifeHeroCollect(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorKnifeHeroCollectView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_KnifeHeroCollect]);
         FActivitiesDataReference = Vector.<Class>([TKnifeHeroCollectData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerKnifeHeroCollect]);
         FTabNum = 0;
         FSceneResourceName = "MC_KnifeHeroCollect";
      }
   }
}

