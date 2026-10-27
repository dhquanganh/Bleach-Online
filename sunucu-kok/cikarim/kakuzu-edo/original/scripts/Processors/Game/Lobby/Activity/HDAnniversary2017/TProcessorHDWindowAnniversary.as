package Processors.Game.Lobby.Activity.HDAnniversary2017
{
   import Foundation.UI.TUIComponent;
   import Logics.HDAnniversary.TAnniversaryOne;
   import Logics.HDAnniversary.TAnniversaryThree;
   import Logics.HDAnniversary.TAnniversaryTwo;
   import Logics.Streamization.HDAnniversary.TUnstreamizerAnniversaryOne;
   import Logics.Streamization.HDAnniversary.TUnstreamizerAnniversaryThree;
   import Logics.Streamization.HDAnniversary.TUnstreamizerAnniversaryTwo;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDAnniversary2017.windows.TProcessorHDWindowAnniversaryOne;
   import Processors.Game.Lobby.Activity.HDAnniversary2017.windows.TProcessorHDWindowAnniversaryThree;
   import Processors.Game.Lobby.Activity.HDAnniversary2017.windows.TProcessorHDWindowAnniversaryTwo;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowAnniversary extends TProcessorHDMainWindowBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDWindowAnniversary(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowAnniversaryOne,TProcessorHDWindowAnniversaryTwo,TProcessorHDWindowAnniversaryThree]);
         FWindowUIName = Vector.<String>(["MC_Anniversary_1","MC_Anniversary_2","MC_Anniversary_3"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_AnniversaryOne,CONST_ACTIVITY_MODE.Activity_AnniversaryTwo,CONST_ACTIVITY_MODE.Activity_AnniversaryThree]);
         FActivitiesDataReference = Vector.<Class>([TAnniversaryOne,TAnniversaryTwo,TAnniversaryThree]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerAnniversaryOne,TUnstreamizerAnniversaryTwo,TUnstreamizerAnniversaryThree]);
         FTabNum = 3;
         FSceneResourceName = "MC_Anniversary";
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FActivityWindows[2] as TProcessorHDWindowAnniversaryThree).OnLoadLog = this.FOnLoadLog;
      }
   }
}

