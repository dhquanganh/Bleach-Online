package Processors.Game.Lobby.Activity.HDThanksGivingDay2016.Windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDTGD_1;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksGivingDay2016.TTGD_1;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorTGD2016_1 extends TProcessorHDSingleWindowBase
   {
      
      protected var FGifts:Vector.<TUIButton>;
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_JackPointGet:TUIButton;
      
      protected var FConfig:THDTGD_1;
      
      protected var FData:TTGD_1;
      
      public function TProcessorTGD2016_1(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDTGD_1 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDTGD_1;
         this.FConfig = _loc3_;
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
         this.FData = param1 as TTGD_1;
         this.UpdateJackPoint();
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_Item" + _loc2_]["MC_Get"].visible = this.FData.GiftStatus[_loc2_] == -1 ? true : false;
            this.FGifts[_loc2_].Enabled = this.FData.GiftStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.Bag.showType,this.FData.Config.Bag.awardId,this.FData.Config.Bag.showID);
         this.FBtn_Report.Visible = this.FData.Config.Bag.fightReportAddr != "";
      }
      
      protected function ProcessorJackPoint(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Bag.index);
      }
      
      protected function ProcessorGoldBuyJackPoint(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Bag.gold,this.ProcessorJackPoint);
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.Bag.fightReportAddr);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.Gifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DayFreeGifts[param1.Tag].index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         _loc2_ = 5;
         this.FGifts = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FGifts[_loc3_] = new TUIButton();
            this.FGifts[_loc3_].Substrate = FScene["MC_Item" + _loc3_]["Btn_Gift"];
            this.FGifts[_loc3_].OnClick = this.ProcessorGiftOnClick;
            this.FGifts[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FGifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FGifts[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["SP_ShowUI"]);
         this.FBtn_JackPointGet = new TUIButton();
         this.FBtn_JackPointGet.Substrate = FScene["SP_ShowUI"]["Btn_Buy"];
         this.FBtn_JackPointGet.OnClick = this.ProcessorGoldBuyJackPoint;
         this.FBtn_JackPointGet.Visible = false;
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["SP_ShowUI"]["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
      }
   }
}

