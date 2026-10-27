package Processors.Game.Lobby.Activity.HDEaster2016
{
   import Foundation.UI.TUIComponent;
   import Logics.HDEaster2016.THDEasterData2016_0;
   import Logics.HDEaster2016.THDEasterData2016_1;
   import Logics.HDEaster2016.THDEasterData2016_2;
   import Logics.Streamization.HDEaster2016.TUnstreamizerEaster2016_0;
   import Logics.Streamization.HDEaster2016.TUnstreamizerEaster2016_1;
   import Logics.Streamization.HDEaster2016.TUnstreamizerEaster2016_2;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDEaster2016.windows.TProcessorHDWindowEaster2016_0;
   import Processors.Game.Lobby.Activity.HDEaster2016.windows.TProcessorHDWindowEaster2016_1;
   import Processors.Game.Lobby.Activity.HDEaster2016.windows.TProcessorHDWindowEaster2016_2;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowEaster2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowEaster2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowEaster2016_0,TProcessorHDWindowEaster2016_1,TProcessorHDWindowEaster2016_2]);
         FWindowUIName = Vector.<String>(["MC_View_0","MC_View_1","MC_View_2"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_Easter2016_0,CONST_ACTIVITY_MODE.Activity_Easter2016_1,CONST_ACTIVITY_MODE.Activity_Easter2016_2]);
         FActivitiesDataReference = Vector.<Class>([THDEasterData2016_0,THDEasterData2016_1,THDEasterData2016_2]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerEaster2016_0,TUnstreamizerEaster2016_1,TUnstreamizerEaster2016_2]);
         FTabNum = 3;
         FSceneResourceName = "MC_Easter2016";
      }
   }
}

