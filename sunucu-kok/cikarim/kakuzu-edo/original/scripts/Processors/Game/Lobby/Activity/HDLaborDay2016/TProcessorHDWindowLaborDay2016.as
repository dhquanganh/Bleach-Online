package Processors.Game.Lobby.Activity.HDLaborDay2016
{
   import Foundation.UI.TUIComponent;
   import Logics.HDLaborDay2016.TLaborConsume;
   import Logics.HDLaborDay2016.TLaborDayCultivation;
   import Logics.HDLaborDay2016.TLaborDayPet;
   import Logics.Streamization.HDLaborDay2016.TUnstreamizerLaborConsume;
   import Logics.Streamization.HDLaborDay2016.TUnstreamizerLaborDayCultivation;
   import Logics.Streamization.HDLaborDay2016.TUnstreamizerLaborDayPet;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDLaborDay2016.Windows.TProcessorLaborConsumeView;
   import Processors.Game.Lobby.Activity.HDLaborDay2016.Windows.TProcessorLaborCultivation;
   import Processors.Game.Lobby.Activity.HDLaborDay2016.Windows.TProcessorLaborPet;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowLaborDay2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowLaborDay2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorLaborCultivation,TProcessorLaborPet,TProcessorLaborConsumeView]);
         FWindowUIName = Vector.<String>(["MC_LaborCultivation","MC_LaborPet","MC_LaborConsume"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_LaborCultivation,CONST_ACTIVITY_MODE.Activity_LaborPet,CONST_ACTIVITY_MODE.Activity_LaborConsume]);
         FActivitiesDataReference = Vector.<Class>([TLaborDayCultivation,TLaborDayPet,TLaborConsume]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerLaborDayCultivation,TUnstreamizerLaborDayPet,TUnstreamizerLaborConsume]);
         FTabNum = 3;
         FSceneResourceName = "MC_LaborDay2016";
      }
   }
}

