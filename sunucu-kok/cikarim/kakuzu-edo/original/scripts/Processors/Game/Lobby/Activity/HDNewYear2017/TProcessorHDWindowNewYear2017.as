package Processors.Game.Lobby.Activity.HDNewYear2017
{
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDNewYear2017.TNewYear2017Bags;
   import Logics.HDNewYear2017.TNewYear2017Discount;
   import Logics.HDNewYear2017.TNewYear2017Task;
   import Logics.Streamization.NewYear2017.TUnstreamizerNYBags;
   import Logics.Streamization.NewYear2017.TUnstreamizerNYDiscount;
   import Logics.Streamization.NewYear2017.TUnstreamizerNYTask;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYear2017.windows.TProcessorHDWindowNewYear2017Bags;
   import Processors.Game.Lobby.Activity.HDNewYear2017.windows.TProcessorHDWindowNewYear2017Discount;
   import Processors.Game.Lobby.Activity.HDNewYear2017.windows.TProcessorHDWindowNewYear2017Task;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowNewYear2017 extends TProcessorHDMainWindowBase
   {
      
      protected var VecAtoms:Vector.<TActivityAtoms>;
      
      protected var VecData:Vector.<TActivityInitRetData>;
      
      public function TProcessorHDWindowNewYear2017(param1:TUIComponent)
      {
         super(param1);
         this.VecAtoms = new Vector.<TActivityAtoms>();
         this.VecData = new Vector.<TActivityInitRetData>();
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowNewYear2017Task,TProcessorHDWindowNewYear2017Bags,TProcessorHDWindowNewYear2017Discount]);
         FWindowUIName = Vector.<String>(["MC_NYTask","MC_NYBags","MC_NYDiscount"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_NewYearTask,CONST_ACTIVITY_MODE.Activity_NewYearBags,CONST_ACTIVITY_MODE.Activity_NewYearDiscount]);
         FActivitiesDataReference = Vector.<Class>([TNewYear2017Task,TNewYear2017Bags,TNewYear2017Discount]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerNYTask,TUnstreamizerNYBags,TUnstreamizerNYDiscount]);
         FTabNum = 3;
         FSceneResourceName = "MC_NewYear2017";
      }
   }
}

