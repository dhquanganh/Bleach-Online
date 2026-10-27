package Processors.Game.Lobby.Activity.HDNationalDay2017.Windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNationalDayTwo2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay2017.TNationalDay2017Two;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNationalTwo2017 extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_SingleBags:Vector.<TUIButton>;
      
      protected var FBtn_ChargeBags:Vector.<TUIButton>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_GetPrize:TUIButton;
      
      protected var FData:TNationalDay2017Two;
      
      protected var FConfig:THDNationalDayTwo2017;
      
      public function TProcessorNationalTwo2017(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNationalDayTwo2017;
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
         this.FData = param1 as TNationalDay2017Two;
         this.UpdateJackPoint();
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_SingleBags[_loc2_].Enabled = this.FData.SignleBagsStatus[_loc2_] > 0 ? true : false;
            FScene["MC_SingleBag_" + _loc2_]["TF_Count"].text = this.FData.Config.SingleAward[_loc2_].cond + "";
            FScene["MC_SingleBag_" + _loc2_]["TF_Last"].text = this.FData.SignleBagsStatus[_loc2_] + "";
            _loc2_++;
         }
         _loc3_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_ChargeBags[_loc2_].Enabled = this.FData.ChargeBagsStatus[_loc2_] == 1;
            FScene["MC_Bottom"]["MC_Item" + _loc2_]["TF_Count"].text = this.FData.Config.TotalAward[_loc2_].cond + "";
            FScene["MC_Bottom"]["MC_Item" + _loc2_]["MC_Get"].visible = this.FData.ChargeBagsStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         FScene["MC_Bottom"]["TF_Candy"].text = this.FData.TodayCharge + "";
         FScene["TF_Candy"].text = this.FData.TotalCharge + "";
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         FScene["MC_Hero"]["MC_Already"].visible = this.FData.BigAwardStatus == -1 ? true : false;
         FScene["MC_Hero"]["TF_CostOriginal"].text = this.FData.Config.BigAward.gold + "";
         this.FBtn_GetPrize.Enabled = this.FData.BigAwardStatus == 1 ? true : false;
      }
      
      protected function ProcessorSingleBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.SingleBags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorChargeBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.ChargeBags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorBagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      protected function ProcessorGetJackPoint(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BigAward.index);
      }
      
      protected function ProcessorSingleOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.SingleAward[param1.Tag].index);
      }
      
      protected function ProcessorChargeOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.TotalAward[param1.Tag].index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_Hero"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["MC_Hero"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
         this.FBtn_GetPrize = new TUIButton();
         this.FBtn_GetPrize.Substrate = FScene["MC_Hero"]["Btn_Get"];
         this.FBtn_GetPrize.OnClick = this.ProcessorGetJackPoint;
         _loc2_ = 4;
         this.FBtn_SingleBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_SingleBags[_loc3_] = new TUIButton();
            this.FBtn_SingleBags[_loc3_].Substrate = FScene["MC_SingleBag_" + _loc3_]["Btn_Bag"];
            this.FBtn_SingleBags[_loc3_].OnClick = this.ProcessorSingleOnClick;
            this.FBtn_SingleBags[_loc3_].OnMove = this.ProcessorSingleBagOnMove;
            this.FBtn_SingleBags[_loc3_].OnOut = this.ProcessorBagsOnOut;
            this.FBtn_SingleBags[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         _loc2_ = 6;
         this.FBtn_ChargeBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_ChargeBags[_loc3_] = new TUIButton();
            this.FBtn_ChargeBags[_loc3_].Substrate = FScene["MC_Bottom"]["MC_Item" + _loc3_]["Btn_Gift"];
            this.FBtn_ChargeBags[_loc3_].OnClick = this.ProcessorChargeOnClick;
            this.FBtn_ChargeBags[_loc3_].OnMove = this.ProcessorChargeBagOnMove;
            this.FBtn_ChargeBags[_loc3_].OnOut = this.ProcessorBagsOnOut;
            this.FBtn_ChargeBags[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
      }
   }
}

