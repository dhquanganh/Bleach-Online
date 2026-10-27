package Processors.Game.Lobby.Activity.HDNewYear2016Two
{
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDChristmas2015.VO.TActivityChristmasSock;
   import Logics.HDNewYear2016.TNewYear2016Chess;
   import Logics.HDNewYear2016.TNewYear2016Fund;
   import Logics.Streamization.HDChristmas2015.TUnstreamizerChristmasSock;
   import Logics.Streamization.NewYear2016.TUnstreamizerNYChess;
   import Logics.Streamization.NewYear2016.TUnstreamizerNYFund;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Windows.TProcessorHDChristmasSock;
   import Processors.Game.Lobby.Activity.HDNewYear2016Two.windows.TProcessorHDWindowNewYear2016Chess;
   import Processors.Game.Lobby.Activity.HDNewYear2016Two.windows.TProcessorHDWindowNewYear2016Fund;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNewYear2016Two extends TProcessorHDMainWindowBase
   {
      
      protected var VecAtoms:Vector.<TActivityAtoms>;
      
      protected var VecData:Vector.<TActivityInitRetData>;
      
      public function TProcessorHDWindowNewYear2016Two(param1:TUIComponent)
      {
         super(param1);
         this.VecAtoms = new Vector.<TActivityAtoms>();
         this.VecData = new Vector.<TActivityInitRetData>();
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowNewYear2016Fund,TProcessorHDChristmasSock,TProcessorHDWindowNewYear2016Chess]);
         FWindowUIName = Vector.<String>(["MC_NYFund","MC_Dumpling","MC_NYChess"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NewYearFund,CONST_ACTIVITY_MODE.Activity_Sock,CONST_ACTIVITY_MODE.Activity_NewYearChess]);
         FActivitiesDataReference = Vector.<Class>([TNewYear2016Fund,TActivityChristmasSock,TNewYear2016Chess]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNYFund,TUnstreamizerChristmasSock,TUnstreamizerNYChess]);
         FTabNum = 3;
         FSceneResourceName = "MC_NewYear2016Two";
      }
   }
}

