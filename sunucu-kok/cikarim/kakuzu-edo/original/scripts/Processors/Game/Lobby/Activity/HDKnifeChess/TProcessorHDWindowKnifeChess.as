package Processors.Game.Lobby.Activity.HDKnifeChess
{
   import Foundation.UI.TUIComponent;
   import Logics.HDKnifeChess.TKnifeChessBuy;
   import Logics.HDKnifeChess.TKnifeChessRecharge;
   import Logics.Streamization.HDKnifeChess.TUnstreamizerKnifeChessBuy;
   import Logics.Streamization.HDKnifeChess.TUnstreamizerKnifeChessRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDKnifeChess.Windows.TProcessorKnifeChessBuy;
   import Processors.Game.Lobby.Activity.HDKnifeChess.Windows.TProcessorKnifeChessRecharge;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TProcessorHDWindowKnifeChess extends TProcessorHDMainWindowBase
   {
      
      public function TProcessorHDWindowKnifeChess(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TProcessorKnifeChessRecharge,TProcessorKnifeChessBuy]);
         FWindowUIName = Vector.<String>(["MC_KnifeChessRecharge","MC_KnifeChessBuy"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_KnifeChessRecharge,CONST_ACTIVITY_MODE.Activity_KnifeChessBuy]);
         FActivitiesDataReference = Vector.<Class>([TKnifeChessRecharge,TKnifeChessBuy]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerKnifeChessRecharge,TUnstreamizerKnifeChessBuy]);
         FTabNum = 2;
         FSceneResourceName = "MC_KnifeChess";
      }
   }
}

