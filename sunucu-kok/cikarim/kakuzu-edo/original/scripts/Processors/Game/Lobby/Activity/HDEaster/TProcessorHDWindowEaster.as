package Processors.Game.Lobby.Activity.HDEaster
{
   import Foundation.UI.TUIComponent;
   import Logics.HDNewYearSheep.THDSheepGoodSellData;
   import Logics.Streamization.HDNewYearSheep.TUnstreamizerSheepGoodSell;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TProcessorHDWindowSheepGoodSell;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowEaster extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowEaster(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowSheepGoodSell]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_Easter]);
         FActivitiesDataReference = Vector.<Class>([THDSheepGoodSellData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerSheepGoodSell]);
         FTabNum = 0;
         FSceneResourceName = "MC_Easter";
      }
   }
}

