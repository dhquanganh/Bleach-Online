package Processors.Game.Lobby.Activity.HDNewYear2016
{
   import Foundation.UI.TUIComponent;
   import Logics.HDNewYear2016.TNewYear2016Check;
   import Logics.HDNewYear2016.TNewYear2016Nian;
   import Logics.HDNewYear2016.TNewYear2016Pocket;
   import Logics.Streamization.NewYear2016.TUnstreamizerNYCheck;
   import Logics.Streamization.NewYear2016.TUnstreamizerNYNian;
   import Logics.Streamization.NewYear2016.TUnstreamizerNYPocket;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYear2016.windows.TProcessorHDWindowNewYear2016Check;
   import Processors.Game.Lobby.Activity.HDNewYear2016.windows.TProcessorHDWindowNewYearNian;
   import Processors.Game.Lobby.Activity.HDNewYear2016.windows.TProcessorHDWindowNewYearPocket;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNewYear2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowNewYear2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowNewYear2016Check,TProcessorHDWindowNewYearNian,TProcessorHDWindowNewYearPocket]);
         FWindowUIName = Vector.<String>(["MC_NYCheck","MC_NYNian","MC_NYPocket"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NewYearCheck,CONST_ACTIVITY_MODE.Activity_NewYearNian,CONST_ACTIVITY_MODE.Activity_NewYearPocket]);
         FActivitiesDataReference = Vector.<Class>([TNewYear2016Check,TNewYear2016Nian,TNewYear2016Pocket]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNYCheck,TUnstreamizerNYNian,TUnstreamizerNYPocket]);
         FTabNum = 3;
         FSceneResourceName = "MC_NewYear2016";
      }
   }
}

