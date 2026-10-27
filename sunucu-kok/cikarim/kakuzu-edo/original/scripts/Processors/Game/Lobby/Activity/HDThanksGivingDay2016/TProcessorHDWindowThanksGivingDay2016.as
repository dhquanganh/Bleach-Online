package Processors.Game.Lobby.Activity.HDThanksGivingDay2016
{
   import Foundation.UI.TUIComponent;
   import Logics.HDThanksGivingDay2016.TTGD_1;
   import Logics.HDThanksGivingDay2016.TTGD_2;
   import Logics.HDThanksGivingDay2016.TTGD_3;
   import Logics.Streamization.HDThanksGivingDay2016.TUnstreamizerTGD_1;
   import Logics.Streamization.HDThanksGivingDay2016.TUnstreamizerTGD_2;
   import Logics.Streamization.HDThanksGivingDay2016.TUnstreamizerTGD_3;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows.TProcessorTGD2016_1;
   import Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows.TProcessorTGD2016_2;
   import Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows.TProcessorTGD2016_3;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowThanksGivingDay2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowThanksGivingDay2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorTGD2016_1,TProcessorTGD2016_2,TProcessorTGD2016_3]);
         FWindowUIName = Vector.<String>(["MC_TGD_1","MC_TGD_2","MC_TGD_3"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_TGD_1,CONST_ACTIVITY_MODE.Activity_TGD_2,CONST_ACTIVITY_MODE.Activity_TGD_3]);
         FActivitiesDataReference = Vector.<Class>([TTGD_1,TTGD_2,TTGD_3]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerTGD_1,TUnstreamizerTGD_2,TUnstreamizerTGD_3]);
         FTabNum = 3;
         FSceneResourceName = "MC_TGD2016";
      }
   }
}

