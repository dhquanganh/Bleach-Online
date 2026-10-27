package Processors.Game.Lobby.BleachAgent
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import Logics.Streamization.BleachAgent.TUnstreamizerBleachAgent;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorDailyRewardCom extends TUIComponent
   {
      
      protected const DailyCount:uint = 4;
      
      protected const WeeklyCount:uint = 4;
      
      protected const RenewCount:uint = 4;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TBleachAgentData;
      
      protected var FDailySlot:Vector.<TUISlot>;
      
      protected var FWeeklySlot:Vector.<TUISlot>;
      
      protected var FRenewSlot:Vector.<TUISlot>;
      
      protected var FLookWelfareBtn:TUIButton;
      
      protected var FDailyReceiveBtn:TUIButton;
      
      protected var FWeeklyReceiveBtn:TUIButton;
      
      protected var FRenewReceiveBtn:TUIButton;
      
      protected var FPage:TUIPage;
      
      protected var FPageIndex:uint;
      
      protected var FUnstreamizer:TUnstreamizerBleachAgent;
      
      protected var FLookWelfare:Function;
      
      public function TProcessorDailyRewardCom(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.BleachAgentData;
         this.FUnstreamizer = new TUnstreamizerBleachAgent(this.FData);
      }
      
      protected function LocalToGlobalIndex(param1:uint) : uint
      {
         return this.FPageIndex * this.RenewCount + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < this.RenewCount)
         {
            _loc3_ = this.FRenewSlot[_loc1_];
            _loc2_ = this.LocalToGlobalIndex(_loc1_);
            if(_loc2_ < this.FData.ConfigValueVO.RenewReward.Count)
            {
               _loc3_.Context = this.FData.ConfigValueVO.RenewReward.GetInventoryByIndex(_loc2_);
            }
            else
            {
               _loc3_.Context = null;
            }
            _loc1_++;
         }
      }
      
      protected function OnWelfareBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FLookWelfare();
      }
      
      protected function OnDailyReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizer.UpdateReq(this.FUnstreamizer.AwardType_Daily);
      }
      
      protected function OnWeeklyReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizer.UpdateReq(this.FUnstreamizer.AwardType_Week);
      }
      
      protected function OnRenewReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizer.UpdateReq(this.FUnstreamizer.AwardType_Renewal);
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePage();
      }
      
      public function set LookWelfare(param1:Function) : void
      {
         this.FLookWelfare = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FDailySlot = new Vector.<TUISlot>();
         this.FWeeklySlot = new Vector.<TUISlot>();
         this.FRenewSlot = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < this.DailyCount)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI.MC_DailyReward["MC_Slot_" + _loc2_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FDailySlot[_loc2_] = _loc3_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.WeeklyCount)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI.MC_WeeklyReward["MC_Slot_" + _loc2_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FWeeklySlot[_loc2_] = _loc3_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.RenewCount)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI.MC_RenewReward["MC_Slot_" + _loc2_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FRenewSlot[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FLookWelfareBtn = new TUIButton();
         this.FLookWelfareBtn.Substrate = this.FMainUI.Btn_LookWelfare;
         this.FLookWelfareBtn.OnClick = this.OnWelfareBtnClick;
         this.FDailyReceiveBtn = new TUIButton();
         this.FDailyReceiveBtn.Substrate = this.FMainUI.MC_DailyReward.Btn_Receive;
         this.FDailyReceiveBtn.OnClick = this.OnDailyReceiveBtnClick;
         this.FWeeklyReceiveBtn = new TUIButton();
         this.FWeeklyReceiveBtn.Substrate = this.FMainUI.MC_WeeklyReward.Btn_Receive;
         this.FWeeklyReceiveBtn.OnClick = this.OnWeeklyReceiveBtnClick;
         this.FRenewReceiveBtn = new TUIButton();
         this.FRenewReceiveBtn.Substrate = this.FMainUI.MC_RenewReward.Btn_Receive;
         this.FRenewReceiveBtn.OnClick = this.OnRenewReceiveBtnClick;
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = this.FMainUI.MC_RenewReward.Btn_Right;
         this.FPage.ButtonPrevious.Substrate = this.FMainUI.MC_RenewReward.Btn_Left;
         this.FPage.PageSize = this.RenewCount;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FPage.Update();
      }
      
      public function UIFinalize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < this.DailyCount)
         {
            _loc2_ = this.FDailySlot[_loc1_];
            _loc2_.Context = this.FData.ConfigValueVO.DailyReward.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.WeeklyCount)
         {
            _loc2_ = this.FWeeklySlot[_loc1_];
            _loc2_.Context = this.FData.ConfigValueVO.WeeklyReward.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         this.UpdatePage();
      }
      
      public function UIUpdate() : void
      {
         this.FMainUI.MC_DailyReward.MC_Receive.visible = this.FData.DailyRewardState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         this.FMainUI.MC_WeeklyReward.MC_Receive.visible = this.FData.WeeklyRewardState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         this.FMainUI.MC_RenewReward.MC_Receive.visible = this.FData.RenewRewardState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         this.FDailyReceiveBtn.Enabled = this.FData.DailyRewardState == CONST_ACTIVITY_MODE.Activity_CanReceive;
         this.FWeeklyReceiveBtn.Enabled = this.FData.WeeklyRewardState == CONST_ACTIVITY_MODE.Activity_CanReceive;
         this.FRenewReceiveBtn.Enabled = this.FData.RenewRewardState == CONST_ACTIVITY_MODE.Activity_CanReceive;
      }
      
      public function UILoop() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         if(Visible && this.FMainUI != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.DailyCount)
            {
               _loc2_ = this.FDailySlot[_loc1_];
               _loc2_.Update();
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.WeeklyCount)
            {
               _loc2_ = this.FWeeklySlot[_loc1_];
               _loc2_.Update();
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.RenewCount)
            {
               _loc2_ = this.FRenewSlot[_loc1_];
               _loc2_.Update();
               _loc1_++;
            }
         }
      }
   }
}

