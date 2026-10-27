package Processors.Game.Lobby.Activity.HDGhostKingForg
{
   import Foundation.UI.TUIComponent;
   import Logics.HDGhostKingForg.TGhostKingForgData;
   import Logics.Streamization.HDGhostKingForg.TUnstreamizerGhostKingForg;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDGhostKingForg.Windows.TProcessorGhostKingForgView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowGhostKingForg extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowGhostKingForg(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorGhostKingForgView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_GhostKingForg]);
         FActivitiesDataReference = Vector.<Class>([TGhostKingForgData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerGhostKingForg]);
         FTabNum = 0;
         FSceneResourceName = "MC_GhostKingForg";
      }
   }
}

