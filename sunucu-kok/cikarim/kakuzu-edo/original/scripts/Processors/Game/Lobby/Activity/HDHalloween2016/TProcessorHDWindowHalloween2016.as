package Processors.Game.Lobby.Activity.HDHalloween2016
{
   import Foundation.UI.TUIComponent;
   import Logics.HDHalloween2016.THalloweenShop;
   import Logics.HDHalloween2016.THalloweenVip;
   import Logics.Streamization.HDHalloween2016.TUnstreamizerHalloweenShop;
   import Logics.Streamization.HDHalloween2016.TUnstreamizerHalloweenVip;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDHalloween2016.Windows.TProcessorHalloweenShop;
   import Processors.Game.Lobby.Activity.HDHalloween2016.Windows.TProcessorHalloweenVip;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowHalloween2016 extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowHalloween2016(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorHalloweenVip,TProcessorHalloweenShop]);
         FWindowUIName = Vector.<String>(["MC_HalloweenVip","MC_HalloweenShop"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_HalloweenVip,CONST_ACTIVITY_MODE.Activity_HalloweenRoundShop]);
         FActivitiesDataReference = Vector.<Class>([THalloweenVip,THalloweenShop]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerHalloweenVip,TUnstreamizerHalloweenShop]);
         FTabNum = 2;
         FSceneResourceName = "MC_Halloween2016";
      }
   }
}

