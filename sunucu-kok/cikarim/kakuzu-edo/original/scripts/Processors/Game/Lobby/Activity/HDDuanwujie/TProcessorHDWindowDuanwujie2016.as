package Processors.Game.Lobby.Activity.HDDuanwujie
{
   import Foundation.UI.TUIComponent;
   import Logics.HDDuanwujie.TDuanwujieBoat;
   import Logics.HDDuanwujie.TDuanwujiePet;
   import Logics.Streamization.HDDuanwujie.TUnstreamizerDuanwujieBoat;
   import Logics.Streamization.HDDuanwujie.TUnstreamizerDuanwujiePet;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDDuanwujie.windows.TProcessorDuanwujieBoat;
   import Processors.Game.Lobby.Activity.HDDuanwujie.windows.TProcessorDuanwujiePet;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowDuanwujie2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowDuanwujie2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorDuanwujiePet,TProcessorDuanwujieBoat]);
         FWindowUIName = Vector.<String>(["MC_DuanwujiePet","MC_DuanwujieBoat"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_DuanwujiePet,CONST_ACTIVITY_MODE.Activity_DuanwujieBoat]);
         FActivitiesDataReference = Vector.<Class>([TDuanwujiePet,TDuanwujieBoat]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerDuanwujiePet,TUnstreamizerDuanwujieBoat]);
         FTabNum = 2;
         FSceneResourceName = "MC_Duanwujie";
      }
   }
}

