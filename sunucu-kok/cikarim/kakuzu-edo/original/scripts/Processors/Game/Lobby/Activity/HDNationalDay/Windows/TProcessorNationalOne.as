package Processors.Game.Lobby.Activity.HDNationalDay.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNationalDayOne;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay.TNationalDayOne;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNationalOne extends TProcessorHDSingleWindowBase
   {
      
      protected var FProgressGifts:Vector.<TUIButton>;
      
      protected var FDayGifts:Vector.<TUIButton>;
      
      protected var FBtn_DayGifts:Vector.<TUIButton>;
      
      protected var FConfig:THDNationalDayOne;
      
      protected var FData:TNationalDayOne;
      
      public function TProcessorNationalOne(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDNationalDayOne = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDNationalDayOne;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["TF_Progress_0"].text = this.FConfig.ProgressGifts[0].gold + "";
         FScene["TF_Progress_1"].text = this.FConfig.ProgressGifts[1].gold + "";
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TNationalDayOne;
         FScene["TF_Recharge"].text = this.FData.Recharge + "";
         this.FProgressGifts[0].Enabled = this.FData.ProgressGiftStatus[0] == 1 ? true : false;
         FScene["MC_Already_0"].visible = this.FData.ProgressGiftStatus[0] == -1 ? true : false;
         this.FProgressGifts[1].Enabled = this.FData.ProgressGiftStatus[1] == 1 ? true : false;
         FScene["MC_Already_1"].visible = this.FData.ProgressGiftStatus[1] == -1 ? true : false;
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_DayGifts[_loc2_].Enabled = this.FData.DayGiftStatus[_loc2_] == 1 ? true : false;
            FScene["MC_Gift_" + _loc2_]["MC_Get"].visible = this.FData.DayGiftStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         FScene["MC_Bar"].width = this.FData.Recharge / this.FData.Config.ProgressGifts[1].gold < 1 ? this.FData.Recharge / this.FData.Config.ProgressGifts[1].gold * 531 : 531;
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.ProgressGifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorDayOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.DayGifts[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorProgressClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ProgressGifts[param1.Tag].index);
      }
      
      protected function ProcessorDayClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.DayGifts[param1.Tag].index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         _loc2_ = 2;
         this.FProgressGifts = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FProgressGifts[_loc3_] = new TUIButton();
            this.FProgressGifts[_loc3_].Substrate = FScene["MC_Bag_" + _loc3_];
            this.FProgressGifts[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FProgressGifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FProgressGifts[_loc3_].OnClick = this.ProcessorProgressClick;
            this.FProgressGifts[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         _loc2_ = 5;
         this.FDayGifts = new Vector.<TUIButton>(_loc2_);
         this.FBtn_DayGifts = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDayGifts[_loc3_] = new TUIButton();
            this.FDayGifts[_loc3_].Substrate = FScene["MC_Gift_" + _loc3_]["MC_Gift"];
            this.FDayGifts[_loc3_].OnMove = this.ProcessorDayOnMove;
            this.FDayGifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FDayGifts[_loc3_].Tag = _loc3_;
            this.FBtn_DayGifts[_loc3_] = new TUIButton();
            this.FBtn_DayGifts[_loc3_].Substrate = FScene["MC_Gift_" + _loc3_]["Btn_Get"];
            this.FBtn_DayGifts[_loc3_].OnClick = this.ProcessorDayClick;
            this.FBtn_DayGifts[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
      }
   }
}

