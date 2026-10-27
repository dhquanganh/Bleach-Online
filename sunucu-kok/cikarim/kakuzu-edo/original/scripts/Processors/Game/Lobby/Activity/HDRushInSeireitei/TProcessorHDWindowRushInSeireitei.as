package Processors.Game.Lobby.Activity.HDRushInSeireitei
{
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDRushInSeireitei.THDRushInSeireiteiData;
   import Logics.Streamization.HDRushInSeireitei.TUnstreamizerRushInSeireitei;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDMainWindowBase;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.windows.TViewHDRank;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.windows.TViewHDRushInSeireitei;
   import Processors.Game.Lobby.Activity.HDRushInSeireitei.windows.TViewHDShop;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.Sprite;
   
   public class TProcessorHDWindowRushInSeireitei extends TProcessorHDMainWindowBase
   {
      
      protected static const Rank_Num:int = 12;
      
      protected var FShopView:TViewHDShop;
      
      protected var FRankView:TViewHDRank;
      
      public function TProcessorHDWindowRushInSeireitei(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function SetupParams() : void
      {
         FActivityClassReference = Vector.<Class>([TViewHDRushInSeireitei]);
         FWindowUIName = Vector.<String>(["MC_View"]);
         FActivitiesID = Vector.<int>([CONST_ACTIVITY_MODE.Activity_RushInSeireitei]);
         FActivitiesDataReference = Vector.<Class>([THDRushInSeireiteiData]);
         FActivitiesUnstreamizer = Vector.<Class>([TUnstreamizerRushInSeireitei]);
         FTabNum = 0;
         FSceneResourceName = "MC_HDRushInSeireitei";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         if(this.FShopView.Visible)
         {
            this.FShopView.ProcessorUpDateDataBase(param1);
         }
         if(this.FRankView.Visible)
         {
            this.FRankView.ProcessorUpDateDataBase(param1);
         }
      }
      
      protected function CloseOnClick(param1:Object) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnGotoShop() : void
      {
         this.FShopView.Show(FActivityAtomsVect[0],FHDActivityConfigs[0],FActivityDatas[0]);
         FActivityWindows[0].mouseChildren = false;
         FActivityWindows[0].mouseEnabled = false;
      }
      
      protected function OnGotoRank() : void
      {
         this.FRankView.Show(FActivityAtomsVect[0],FHDActivityConfigs[0],FActivityDatas[0]);
         FActivityWindows[0].mouseChildren = false;
         FActivityWindows[0].mouseEnabled = false;
      }
      
      protected function OnViewClose(param1:Object) : void
      {
         FActivityWindows[0].mouseChildren = true;
         FActivityWindows[0].mouseEnabled = true;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:TViewHDRushInSeireitei = null;
         super.InitWindow(param1);
         _loc2_ = FActivityWindows[0] as TViewHDRushInSeireitei;
         _loc2_.OnGotoShop = this.OnGotoShop;
         _loc2_.OnGotoRank = this.OnGotoRank;
         _loc2_.OnClose = this.CloseOnClick;
         this.FShopView = new TViewHDShop(this);
         this.FShopView.InitWindow(FScene["MC_Shop"]);
         this.FShopView.OnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FShopView.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FShopView.OnClose = this.OnViewClose;
         this.FRankView = new TViewHDRank(this);
         this.FRankView.RankNum = Rank_Num;
         this.FRankView.InitWindow(FScene["MC_Rank"]);
         this.FRankView.OnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FRankView.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FRankView.OnClose = this.OnViewClose;
      }
      
      override public function SendActivityChangeData(param1:TActAwardStatusInfo) : void
      {
         super.SendActivityChangeData(param1);
         if(this.FShopView.Visible)
         {
            this.FShopView.ProcessorUpDateDataBase(FActivityDatas[0]);
         }
         if(this.FRankView.Visible)
         {
            this.FRankView.ProcessorUpDateDataBase(FActivityDatas[0]);
         }
      }
      
      override public function SendActivityInitData(param1:TActivityAtoms, param2:TActivityInitRetData) : void
      {
         super.SendActivityInitData(param1,param2);
         if(this.FShopView.Visible)
         {
            this.FShopView.ProcessorUpDateDataBase(FActivityDatas[0]);
         }
      }
   }
}

