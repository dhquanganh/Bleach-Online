package Processors.Game.Lobby.Activity.HDNationalDay2017.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNationalDayOne2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNationalDay2017.TNationalDay2017One;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNationalOne2017 extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_DayBuys:Vector.<TUIButton>;
      
      protected var FSlots_DayBuys:Vector.<TUISlot>;
      
      protected var FBtn_RightBags:Vector.<TUIButton>;
      
      protected var FDaySlots:Vector.<TUISlot>;
      
      protected var FDays:Vector.<MovieClip>;
      
      protected var FBtn_Check:TUIButton;
      
      protected var FBtn_ReCheck:TUIButton;
      
      protected var FOffSet:uint;
      
      protected var FCurBtn:uint;
      
      protected var FData:TNationalDay2017One;
      
      protected var FConfig:THDNationalDayOne2017;
      
      public function TProcessorNationalOne2017(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNationalDayOne2017;
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
         this.FData = param1 as TNationalDay2017One;
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_RightBag_" + _loc2_]["MC_Already"].visible = this.FData.RightBagsStatus[_loc2_] == -1 ? true : false;
            FScene["MC_RightBag_" + _loc2_]["TF_Day"].text = this.FData.Config.RightBags[_loc2_].cond + "";
            this.FBtn_RightBags[_loc2_].Enabled = this.FData.RightBagsStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         _loc3_ = 4;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            FScene["MC_block" + _loc2_]["MC_Already"].visible = this.FData.LeftBagsStatus[_loc2_] == -1 ? true : false;
            FScene["MC_block" + _loc2_]["TF_OldPrice"].text = this.FData.Config.LeftBags[_loc2_].originalPrice + "";
            FScene["MC_block" + _loc2_]["TF_Price"].text = this.FData.Config.LeftBags[_loc2_].currentPrice + "";
            FScene["MC_block" + _loc2_]["TF_Count"].text = this.FData.Config.LeftBags[_loc2_].limit + "";
            this.FSlots_DayBuys[_loc2_].Context = this.FData.LeftInvs.GetInventoryByIndex(_loc2_);
            this.FBtn_DayBuys[_loc2_].Enabled = this.FData.LeftBagsStatus[_loc2_] > 0 ? true : false;
            _loc2_++;
         }
         _loc3_ = 10;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDaySlots[_loc2_].Context = this.FData.DayInvs.GetInventoryByIndex(_loc2_);
            this.FDays[_loc2_]["MC_Hook"].visible = this.FData.DayStatus[_loc2_] == -1 ? true : false;
            this.FDays[_loc2_]["MC_SelectBox"].visible = false;
            this.FDaySlots[_loc2_].mouseEnabled = true;
            this.FDays[_loc2_].gotoAndStop(this.FData.DayStatus[_loc2_] == -1 ? 1 : 2);
            _loc2_++;
         }
         this.FDays[this.FData.NowDay - 1].gotoAndStop(3);
         this.FBtn_Check.Enabled = this.FData.DayStatus[this.FData.NowDay - 1] == -1 ? false : true;
         FScene["TF_Day"].text = this.FData.CheckedDays + "";
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         for each(_loc3_ in this.FSlots_DayBuys)
         {
            _loc3_.Update();
         }
         for each(_loc3_ in this.FDaySlots)
         {
            _loc3_.Update();
         }
      }
      
      protected function DaysOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FOffSet = uint(param1.currentTarget.name.split("_")[1]);
         _loc2_ = uint(this.FData.DayInvs.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDays[_loc3_]["MC_SelectBox"].visible = false;
            _loc3_++;
         }
         this.FDays[this.FOffSet]["MC_SelectBox"].visible = true;
         this.FBtn_ReCheck.Enabled = this.FOffSet < this.FData.NowDay - 1 && this.FData.DayStatus[this.FOffSet] == 1;
      }
      
      protected function RightBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RightBags[param1.Tag].index);
      }
      
      protected function RightBagsOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.RightBags[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function RightBagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function CheckOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.NowDay);
      }
      
      protected function ReCheckOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.CostGold,this.GoldReCheckOnClick);
      }
      
      protected function GoldReCheckOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FOffSet + 1);
      }
      
      protected function LeftBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.LeftBags[param1.Tag].currentPrice,this.GoldLeftBagsOnClick);
         this.FCurBtn = this.FConfig.LeftBags[param1.Tag].index;
      }
      
      protected function GoldLeftBagsOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurBtn);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         _loc2_ = 4;
         this.FBtn_DayBuys = new Vector.<TUIButton>(_loc2_);
         this.FSlots_DayBuys = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_DayBuys[_loc3_] = new TUIButton();
            this.FBtn_DayBuys[_loc3_].Substrate = FScene["MC_block" + _loc3_]["Btn_Buy"];
            this.FBtn_DayBuys[_loc3_].OnClick = this.LeftBagsOnClick;
            this.FBtn_DayBuys[_loc3_].Tag = _loc3_;
            this.FSlots_DayBuys[_loc3_] = new TUISlot(this);
            this.FSlots_DayBuys[_loc3_].Resource = FScene["MC_block" + _loc3_]["slot"];
            this.FSlots_DayBuys[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots_DayBuys[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots_DayBuys[_loc3_]);
            this.FSlots_DayBuys[_loc3_].Init();
            _loc3_++;
         }
         this.FBtn_Check = new TUIButton();
         this.FBtn_Check.Substrate = FScene["Btn_Check"];
         this.FBtn_Check.OnClick = this.CheckOnClick;
         this.FBtn_ReCheck = new TUIButton();
         this.FBtn_ReCheck.Substrate = FScene["Btn_Recheck"];
         this.FBtn_ReCheck.OnClick = this.ReCheckOnClick;
         this.FBtn_ReCheck.Enabled = false;
         _loc2_ = 10;
         this.FDays = new Vector.<MovieClip>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDays[_loc3_] = FScene["MC_Alldays"]["day_" + _loc3_];
            this.FDays[_loc3_].addEventListener(MouseEvent.CLICK,this.DaysOnClick);
            _loc3_++;
         }
         _loc2_ = 10;
         this.FDaySlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDaySlots[_loc3_] = new TUISlot(this);
            this.FDaySlots[_loc3_].Resource = FScene["MC_Alldays"]["day_" + _loc3_]["slot"];
            this.FDaySlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FDaySlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FDaySlots[_loc3_]);
            this.FDaySlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 4;
         this.FBtn_RightBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_RightBags[_loc3_] = new TUIButton();
            this.FBtn_RightBags[_loc3_].Substrate = FScene["MC_RightBag_" + _loc3_]["MC_Bag_0"];
            this.FBtn_RightBags[_loc3_].OnClick = this.RightBagsOnClick;
            this.FBtn_RightBags[_loc3_].Tag = _loc3_;
            this.FBtn_RightBags[_loc3_].OnMove = this.RightBagsOnMove;
            this.FBtn_RightBags[_loc3_].OnOut = this.RightBagsOnOut;
            _loc3_++;
         }
      }
   }
}

