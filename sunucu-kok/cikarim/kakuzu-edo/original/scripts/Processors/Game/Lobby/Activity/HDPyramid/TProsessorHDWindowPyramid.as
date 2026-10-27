package Processors.Game.Lobby.Activity.HDPyramid
{
   import Foundation.UI.TUIComponent;
   import Logics.HDPyramid.THDPyramidData;
   import Logics.Streamization.HDPyramid.TunstreamizerPyramid;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProsessorHDWindowPyramid extends TProcessorHDMainWindowBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProsessorHDWindowPyramid(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProsessorHDPyramidView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_Pyramid]);
         FActivitiesDataReference = Vector.<Class>([THDPyramidData]);
         FActivitiesUnstreamizer = Vector.<Class>([TunstreamizerPyramid]);
         FTabNum = 0;
         FSceneResourceName = "MC_Pyramid";
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FActivityWindows[0] as TProsessorHDPyramidView).OnLoadLog = this.FOnLoadLog;
      }
   }
}

