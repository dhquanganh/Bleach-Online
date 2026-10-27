package Processors.Game.Lobby.Activity.HDChristmas2015
{
   import Foundation.UI.TUIComponent;
   import Logics.HDChristmas2015.TSledData;
   import Logics.HDChristmas2015.TSnowBattleData;
   import Logics.HDChristmas2015.VO.TActivityChristmasRecharge;
   import Logics.HDChristmas2015.VO.TActivityChristmasSock;
   import Logics.Streamization.HDChristmas2015.TUnstreamizerChristmasRecharge;
   import Logics.Streamization.HDChristmas2015.TUnstreamizerChristmasSock;
   import Logics.Streamization.HDChristmas2015.TUnstreamizerSled;
   import Logics.Streamization.HDChristmas2015.TUnstreamizerSnowBattle;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Windows.TProcessorHDChristmasRecharge;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Windows.TProcessorHDChristmasSock;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Windows.TProcessorSledView;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Windows.TProcessorSnowBattleView;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowChristmas2015 extends TProcessorHDMainWindowBase
   {
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDWindowChristmas2015(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorSnowBattleView,TProcessorHDChristmasRecharge,TProcessorHDChristmasSock,TProcessorSledView]);
         FWindowUIName = Vector.<String>(["MC_CSSnowBattle","MC_Recharge","MC_Cheers","MC_CSSled"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_SnowBattle,CONST_ACTIVITY_MODE.Activity_Tree,CONST_ACTIVITY_MODE.Activity_Sock,CONST_ACTIVITY_MODE.Activity_Sled]);
         FActivitiesDataReference = Vector.<Class>([TSnowBattleData,TActivityChristmasRecharge,TActivityChristmasSock,TSledData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerSnowBattle,TUnstreamizerChristmasRecharge,TUnstreamizerChristmasSock,TUnstreamizerSled]);
         FTabNum = 4;
         FSceneResourceName = "MC_Christmas2015";
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         (FActivityWindows[3] as TProcessorSledView).OnLoadLog = this.FOnLoadLog;
      }
   }
}

