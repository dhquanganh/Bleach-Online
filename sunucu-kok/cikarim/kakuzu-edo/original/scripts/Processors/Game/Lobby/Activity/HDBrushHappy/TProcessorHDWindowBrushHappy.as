package Processors.Game.Lobby.Activity.HDBrushHappy
{
   import Foundation.UI.TUIComponent;
   import Logics.HDBrushHappy.TBrushHappyData;
   import Logics.Streamization.HDBrushHappy.TUnstreamizerBrushHappy;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDBrushHappy.Windows.TProcessorBrushHappyView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowBrushHappy extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowBrushHappy(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorBrushHappyView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_BrushHappy]);
         FActivitiesDataReference = Vector.<Class>([TBrushHappyData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerBrushHappy]);
         FTabNum = 0;
         FSceneResourceName = "MC_BrushHappy";
      }
   }
}

