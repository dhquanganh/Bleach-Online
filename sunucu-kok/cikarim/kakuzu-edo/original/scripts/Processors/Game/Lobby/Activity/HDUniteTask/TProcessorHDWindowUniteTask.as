package Processors.Game.Lobby.Activity.HDUniteTask
{
   import Foundation.UI.TUIComponent;
   import Logics.HDUniteTask.TUniteTaskData;
   import Logics.Streamization.HDUniteTask.TUnstreamizerUniteTask;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDUniteTask.windows.TProcessorUniteTaskView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowUniteTask extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowUniteTask(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorUniteTaskView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_UniteTask]);
         FActivitiesDataReference = Vector.<Class>([TUniteTaskData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerUniteTask]);
         FTabNum = 0;
         FSceneResourceName = "MC_UniteTask";
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         (FActivityWindows[0] as TProcessorUniteTaskView).OnCreateKnifeOfKillSoulData = param1;
      }
   }
}

