package Processors.Game.Lobby.Activity.HDFoolsDay
{
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDFoolsDay.TFoolsDayRecharge;
   import Logics.HDFoolsDay.TFoolsDayShop;
   import Logics.Streamization.HDFoolsDay.TUnsteamizerFoolsDayShop;
   import Logics.Streamization.HDFoolsDay.TUnstreamizerFoolsDayRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDFoolsDay.windows.TProcessorHDWindowFoolsDayRecharge;
   import Processors.Game.Lobby.Activity.HDFoolsDay.windows.TProcessorHDWindowFoolsDayShop;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowFoosDay extends TProcessorHDMainWindowBase
   {
      
      protected var VecAtoms:Vector.<TActivityAtoms>;
      
      protected var VecData:Vector.<TActivityInitRetData>;
      
      public function TProcessorHDWindowFoosDay(param1:TUIComponent)
      {
         super(param1);
         this.VecAtoms = new Vector.<TActivityAtoms>();
         this.VecData = new Vector.<TActivityInitRetData>();
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHDWindowFoolsDayRecharge,TProcessorHDWindowFoolsDayShop]);
         FWindowUIName = Vector.<String>(["MC_Recharge","MC_Shop"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_FoolsDayRecharge,CONST_ACTIVITY_MODE.Activity_FoolsDayShop]);
         FActivitiesDataReference = Vector.<Class>([TFoolsDayRecharge,TFoolsDayShop]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerFoolsDayRecharge,TUnsteamizerFoolsDayShop]);
         FTabNum = 2;
         FSceneResourceName = "MC_FoolsDay";
      }
   }
}

