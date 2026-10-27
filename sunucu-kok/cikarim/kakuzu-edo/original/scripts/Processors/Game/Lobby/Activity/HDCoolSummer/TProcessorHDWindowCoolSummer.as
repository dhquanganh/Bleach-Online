package Processors.Game.Lobby.Activity.HDCoolSummer
{
   import Foundation.UI.TUIComponent;
   import Logics.HDCoolSummer.TCoolSummerData;
   import Logics.Streamization.HDCoolSummer.TUnstreamizerCoolSummer;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDCoolSummer.Windows.TProcessorCoolSummerView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowCoolSummer extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowCoolSummer(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorCoolSummerView]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_CoolSummer]);
         FActivitiesDataReference = Vector.<Class>([TCoolSummerData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerCoolSummer]);
         FTabNum = 0;
         FSceneResourceName = "MC_CoolSummer";
      }
   }
}

