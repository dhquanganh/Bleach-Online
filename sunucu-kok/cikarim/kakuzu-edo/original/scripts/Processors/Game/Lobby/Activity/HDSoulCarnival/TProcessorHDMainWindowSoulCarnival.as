package Processors.Game.Lobby.Activity.HDSoulCarnival
{
   import Foundation.UI.TUIComponent;
   import Logics.HDSoulCarnival.TSoulBuy;
   import Logics.HDSoulCarnival.TSoulDraw;
   import Logics.HDSoulCarnival.TSoulRecharge;
   import Logics.Streamization.HDSoulCarnival.TUnstreamizerSoulBuy;
   import Logics.Streamization.HDSoulCarnival.TUnstreamizerSoulDraw;
   import Logics.Streamization.HDSoulCarnival.TUnstreamizerSoulRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDSoulCarnival.windows.TProcessorHDWindowSoulBuy;
   import Processors.Game.Lobby.Activity.HDSoulCarnival.windows.TProcessorHDWindowSoulDraw;
   import Processors.Game.Lobby.Activity.HDSoulCarnival.windows.TProcessorHDWindowSoulRecharge;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDMainWindowSoulCarnival extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDMainWindowSoulCarnival(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowSoulDraw,TProcessorHDWindowSoulBuy,TProcessorHDWindowSoulRecharge]);
         FWindowUIName = Vector.<String>(["MC_SoulDraw","MC_SoulBuy","MC_SoulRecharge"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_SoulDraw,CONST_ACTIVITY_MODE.Activity_SoulBuy,CONST_ACTIVITY_MODE.Activity_SoulRecharge]);
         FActivitiesDataReference = Vector.<Class>([TSoulDraw,TSoulBuy,TSoulRecharge]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerSoulDraw,TUnstreamizerSoulBuy,TUnstreamizerSoulRecharge]);
         FTabNum = 3;
         FSceneResourceName = "MC_SoulCarnival";
      }
   }
}

