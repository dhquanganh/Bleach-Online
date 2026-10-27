package Processors.Game.Lobby.Activity.HDAnniversary2017.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDAnniversaryTwo;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAnniversary.TAnniversaryTwo;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowAnniversaryTwo extends TProcessorHDSingleWindowBase
   {
      
      protected var FDayAward:Vector.<TUIButton>;
      
      protected var FTotalAward:Vector.<TUIButton>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_GetJackPoint:TUIButton;
      
      protected var FConfig:THDAnniversaryTwo;
      
      protected var FData:TAnniversaryTwo;
      
      public function TProcessorHDWindowAnniversaryTwo(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDAnniversaryTwo;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TAnniversaryTwo;
         _loc3_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDayAward[_loc2_].Enabled = this.FData.DayAwardStatus[_loc2_] == 1 ? true : false;
            FScene["MC_Item" + _loc2_]["MC_Get"].visible = this.FData.DayAwardStatus[_loc2_] == -1 ? true : false;
            FScene["TF_Cost_" + _loc2_].text = this.FData.Config.DayAward[_loc2_].cond + "";
            _loc2_++;
         }
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTotalAward[_loc2_].Enabled = this.FData.TotalAwardStatus[_loc2_] == 1 ? true : false;
            FScene["MC_" + _loc2_]["MC_Receive"].visible = this.FData.TotalAwardStatus[_loc2_] == -1 ? true : false;
            FScene["MC_" + _loc2_]["TF_Cost"].text = this.FData.Config.TotalAward[_loc2_].cond + "";
            _loc2_++;
         }
         FScene["TF_Need"].text = this.FData.Config.Bag.gold + "";
         FScene["TF_Recharge"].text = this.FData.Recharge.toString();
         this.UpdateJackPoint();
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.Bag.showType,this.FData.Config.Bag.awardId,this.FData.Config.Bag.showID);
         this.FBtn_Report.Visible = this.FData.Config.Bag.fightReportAddr != "";
         this.FBtn_GetJackPoint.Enabled = this.FData.JackPointStatus == 1 ? true : false;
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.Bag.fightReportAddr);
      }
      
      protected function ProcessorGetJackPoint(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Bag.index);
      }
      
      protected function ProcesserOnTotalAward(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.TotalAward[param1.Tag].index);
      }
      
      protected function ProcesserOnDayAward(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.DayAward[param1.Tag].index);
      }
      
      protected function ProcessorTotalAwardOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.TotalAward[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorDayAwardOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.DayAward[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         super.InitWindow(param1);
         this.FDayAward = new Vector.<TUIButton>(3);
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = FScene["MC_Item" + _loc3_]["Btn_Gift"];
            _loc4_.OnClick = this.ProcesserOnDayAward;
            _loc4_.OnMove = this.ProcessorDayAwardOnMove;
            _loc4_.OnOut = this.ProcessorGiftOnOut;
            _loc4_.Tag = _loc3_;
            this.FDayAward[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FTotalAward = new Vector.<TUIButton>(5);
         _loc3_ = 0;
         while(_loc3_ < 5)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = FScene["MC_" + _loc3_]["Btn"];
            _loc4_.OnClick = this.ProcesserOnTotalAward;
            _loc4_.OnMove = this.ProcessorTotalAwardOnMove;
            _loc4_.OnOut = this.ProcessorGiftOnOut;
            _loc4_.Tag = _loc3_;
            this.FTotalAward[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_MountPoint"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_MountPoint"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
         this.FBtn_GetJackPoint = new TUIButton();
         this.FBtn_GetJackPoint.Substrate = FScene["MC_MountPoint"]["Btn_Shop"];
         this.FBtn_GetJackPoint.OnClick = this.ProcessorGetJackPoint;
      }
   }
}

