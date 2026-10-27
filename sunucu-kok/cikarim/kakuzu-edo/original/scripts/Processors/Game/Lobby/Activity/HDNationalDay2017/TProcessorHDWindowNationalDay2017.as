package Processors.Game.Lobby.Activity.HDNationalDay2017
{
   import Foundation.UI.TUIComponent;
   import Logics.HDNationalDay2017.TNationalDay2017One;
   import Logics.HDNationalDay2017.TNationalDay2017Three;
   import Logics.HDNationalDay2017.TNationalDay2017Two;
   import Logics.Streamization.HDNationalDay2017.TUnstreamizerNationalDayOne2017;
   import Logics.Streamization.HDNationalDay2017.TUnstreamizerNationalDayThree2017;
   import Logics.Streamization.HDNationalDay2017.TUnstreamizerNationalDayTwo2017;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNationalDay2017.Windows.TProcessorNationalOne2017;
   import Processors.Game.Lobby.Activity.HDNationalDay2017.Windows.TProcessorNationalThree2017;
   import Processors.Game.Lobby.Activity.HDNationalDay2017.Windows.TProcessorNationalTwo2017;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNationalDay2017 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowNationalDay2017(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FSceneResourceName = "MC_NationalDay2017";
         FActivityClassReference = Vector.<Class>([TProcessorNationalOne2017,TProcessorNationalTwo2017,TProcessorNationalThree2017]);
         FWindowUIName = Vector.<String>(["MC_NationalOne2017","MC_NationalTwo2017","MC_NationalThree2017"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NationalOne2017,CONST_ACTIVITY_MODE.Activity_NationalTwo2017,CONST_ACTIVITY_MODE.Activity_NationalThree2017]);
         FActivitiesDataReference = Vector.<Class>([TNationalDay2017One,TNationalDay2017Two,TNationalDay2017Three]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNationalDayOne2017,TUnstreamizerNationalDayTwo2017,TUnstreamizerNationalDayThree2017]);
         FTabNum = 3;
         FSceneResourceName = "MC_NationalDay2017";
      }
   }
}

