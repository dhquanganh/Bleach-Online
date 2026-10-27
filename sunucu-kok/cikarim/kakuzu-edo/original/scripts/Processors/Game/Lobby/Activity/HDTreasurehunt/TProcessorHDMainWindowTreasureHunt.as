package Processors.Game.Lobby.Activity.HDTreasurehunt
{
   import Foundation.UI.TUIComponent;
   import Logics.HDTreasureHunt.TTreasureHunt;
   import Logics.HDTreasureHunt.TTreasureShop;
   import Logics.Streamization.HDTreasureHunt.TUnstreamizerTreasureHunt;
   import Logics.Streamization.HDTreasureHunt.TUnstreamizerTreasureShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDTreasurehunt.windows.TProcessorHDWindowTreasureHunt;
   import Processors.Game.Lobby.Activity.HDTreasurehunt.windows.TProcessorHDWindowTreasureShop;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDMainWindowTreasureHunt extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDMainWindowTreasureHunt(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowTreasureHunt,TProcessorHDWindowTreasureShop]);
         FWindowUIName = Vector.<String>(["MC_TreasureHunt","MC_TreasureShop"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_TreasureHunt,CONST_ACTIVITY_MODE.Activity_TreasureShop]);
         FActivitiesDataReference = Vector.<Class>([TTreasureHunt,TTreasureShop]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerTreasureHunt,TUnstreamizerTreasureShop]);
         FTabNum = 2;
         FSceneResourceName = "MC_TreasureMainWin";
      }
   }
}

