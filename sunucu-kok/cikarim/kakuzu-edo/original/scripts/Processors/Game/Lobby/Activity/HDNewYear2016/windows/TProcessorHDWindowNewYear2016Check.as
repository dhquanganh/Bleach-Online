package Processors.Game.Lobby.Activity.HDNewYear2016.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDNewYear2016Check;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYear2016.TNewYear2016Check;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowNewYear2016Check extends TProcessorHDSingleWindowBase
   {
      
      protected var FSP_Left:Sprite;
      
      protected var FSP_Mid:Sprite;
      
      protected var FSP_Right:Sprite;
      
      protected var FTF_Checked:TextField;
      
      protected var FSP_LeftBags:Vector.<Sprite>;
      
      protected var FBtn_LeftBags:Vector.<TUIButton>;
      
      protected var FSP_RightBags:Vector.<Sprite>;
      
      protected var FBtn_RightBags:Vector.<TUIButton>;
      
      protected var FBtn_Check:TUIButton;
      
      protected var Fbtn_ReCheck:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FDaySlots:Vector.<TUISlot>;
      
      protected var FDays:Vector.<MovieClip>;
      
      protected var FOffSet:uint;
      
      protected var FCurBtn:uint;
      
      protected var FConfig:THDNewYear2016Check;
      
      protected var FData:TNewYear2016Check;
      
      public function TProcessorHDWindowNewYear2016Check(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDNewYear2016Check;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         _loc2_ = this.FConfig.PreferentialGifts.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_LeftBags[_loc1_]["TF_DeskName"].text = this.FConfig.PreferentialGifts[_loc1_].OriginalGold + "";
            this.FSP_LeftBags[_loc1_]["TF_DeskProg"].text = this.FConfig.PreferentialGifts[_loc1_].RealGold + "";
            this.FSP_LeftBags[_loc1_]["TF_Limit"].text = this.FConfig.PreferentialGifts[_loc1_].count + "";
            _loc1_++;
         }
         _loc2_ = this.FConfig.SignInGifts.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSP_RightBags[_loc1_]["TF_Cost"].text = this.FConfig.SignInGifts[_loc1_].days + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TNewYear2016Check;
         _loc3_ = this.FData.LeftGiftsStatus.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSP_LeftBags[_loc2_]["MC_ReceiveFlag"].visible = this.FData.LeftGiftsStatus[_loc2_] >= this.FConfig.PreferentialGifts[_loc2_].count ? true : false;
            this.FBtn_LeftBags[_loc2_].Visible = !this.FSP_LeftBags[_loc2_]["MC_ReceiveFlag"].visible;
            _loc2_++;
         }
         _loc3_ = this.FConfig.PreferentialGifts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.LeftGifts[_loc2_].GetInventoryByIndex(0);
            _loc2_++;
         }
         _loc3_ = uint(this.FConfig.SignIn.awardIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDaySlots[_loc2_].Context = this.FData.DayGifts[_loc2_].GetInventoryByIndex(0);
            _loc2_++;
         }
         _loc3_ = 10;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDays[_loc2_]["MC_Hook"].visible = this.FData.DayStatus[_loc2_] == 1 ? true : false;
            this.FDays[_loc2_]["MC_SelectBox"].visible = false;
            this.FDaySlots[_loc2_].mouseEnabled = true;
            this.FDays[_loc2_].gotoAndStop(this.FData.DayStatus[_loc2_] == 1 ? 1 : 2);
            _loc2_++;
         }
         _loc2_ = this.FData.NowDay + 2;
         while(_loc2_ < _loc3_)
         {
            this.FDays[_loc2_].gotoAndStop(5);
            this.FDaySlots[_loc2_].mouseEnabled = false;
            _loc2_++;
         }
         this.FOffSet = this.FData.NowDay;
         this.FDays[this.FOffSet]["MC_SelectBox"].visible = true;
         this.Fbtn_ReCheck.Enabled = this.FOffSet < this.FData.NowDay && this.FData.DayStatus[this.FOffSet] == 0;
         this.FTF_Checked.text = this.FData.CheckedDays + "";
         _loc3_ = this.FData.RightGifts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_RightBags[_loc2_].Enabled = this.FData.RightGiftsStatus[_loc2_] == 1 ? true : false;
            this.FSP_RightBags[_loc2_]["SP_Already"].visible = this.FData.RightGiftsStatus[_loc2_] == -1 ? true : false;
            _loc2_++;
         }
         this.FBtn_Check.Enabled = this.FData.DayStatus[this.FOffSet] == 0 ? true : false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc1_ = this.FConfig.PreferentialGifts.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Update();
            _loc2_++;
         }
         _loc1_ = uint(this.FConfig.SignIn.awardIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FDaySlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function RightBagsOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.RightGifts[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function RightBagsOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function CheckOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.SignIn.index);
      }
      
      protected function ReCheckOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         if(SLogicsCore.Character.CreditGiftCertificate >= this.FConfig.SignIn.gold)
         {
            this.GoldReCheckOnClick(this);
         }
         else
         {
            GoldBuy(this.FConfig.SignIn.gold,this.GoldReCheckOnClick);
         }
      }
      
      protected function GoldReCheckOnClick(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = this.FOffSet;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.OffSet,0,_loc2_);
      }
      
      protected function LeftBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.PreferentialGifts[param1.Tag].RealGold,this.GoldLeftBagsOnClick);
         this.FCurBtn = param1.Tag;
      }
      
      protected function GoldLeftBagsOnClick(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurBtn);
      }
      
      protected function DaysOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = this.FData.DayGifts.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FDays[_loc4_]["MC_SelectBox"].visible = false;
            _loc4_++;
         }
         _loc2_ = param1.currentTarget as Sprite;
         _loc2_["MC_SelectBox"].visible = true;
         this.FDays[this.FOffSet]["MC_SelectBox"].visible = true;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FData.DayGifts[uint(param1.currentTarget.name.split("_")[1])].GetInventoryByIndex(0));
      }
      
      protected function DaysOnOut(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         SUtilityOverLayer.UIComponentsHintOnOut(this,null);
         _loc2_ = this.FData.DayGifts.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDays[_loc3_]["MC_SelectBox"].visible = false;
            _loc3_++;
         }
         this.FDays[this.FOffSet]["MC_SelectBox"].visible = true;
      }
      
      protected function DaysOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FOffSet = uint(param1.currentTarget.name.split("_")[1]);
         _loc2_ = this.FData.DayGifts.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDays[_loc3_]["MC_SelectBox"].visible = false;
            _loc3_++;
         }
         this.FDays[this.FOffSet]["MC_SelectBox"].visible = true;
         this.Fbtn_ReCheck.Enabled = this.FOffSet < this.FData.NowDay && this.FData.DayStatus[this.FOffSet] == 0;
      }
      
      protected function RightBagsOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.SignInGifts[param1.Tag].index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FSP_Left = FScene["SP_LeftBags"];
         this.FSP_Mid = FScene["SP_Mid"];
         this.FSP_Right = FScene["SP_RightBags"];
         this.FTF_Checked = new TextField();
         this.FTF_Checked = FScene["TF_FavourValue"];
         _loc2_ = 4;
         this.FSP_LeftBags = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSP_LeftBags[_loc3_] = this.FSP_Left["SP_Bag_" + _loc3_];
            _loc3_++;
         }
         _loc2_ = 4;
         this.FSP_RightBags = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSP_RightBags[_loc3_] = this.FSP_Right["SP_Bag_" + _loc3_];
            _loc3_++;
         }
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = this.FSP_LeftBags[_loc3_]["slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FBtn_LeftBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_LeftBags[_loc3_] = new TUIButton();
            this.FBtn_LeftBags[_loc3_].Substrate = this.FSP_LeftBags[_loc3_]["Btn_GoTask"];
            this.FBtn_LeftBags[_loc3_].OnClick = this.LeftBagsOnClick;
            this.FBtn_LeftBags[_loc3_].Tag = _loc3_;
            _loc3_++;
         }
         this.FBtn_Check = new TUIButton();
         this.FBtn_Check.Substrate = this.FSP_Mid["Btn_Check"];
         this.FBtn_Check.OnClick = this.CheckOnClick;
         this.Fbtn_ReCheck = new TUIButton();
         this.Fbtn_ReCheck.Substrate = this.FSP_Mid["Btn_ReCheck"];
         this.Fbtn_ReCheck.OnClick = this.ReCheckOnClick;
         _loc2_ = 10;
         this.FDays = new Vector.<MovieClip>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDays[_loc3_] = this.FSP_Mid["MC_Alldays"]["day_" + _loc3_];
            this.FDays[_loc3_].addEventListener(MouseEvent.CLICK,this.DaysOnClick);
            _loc3_++;
         }
         _loc2_ = 10;
         this.FDaySlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FDaySlots[_loc3_] = new TUISlot(this);
            this.FDaySlots[_loc3_].Resource = this.FDays[_loc3_]["slot"];
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
            this.FBtn_RightBags[_loc3_].Substrate = this.FSP_RightBags[_loc3_]["MC_Box"];
            this.FBtn_RightBags[_loc3_].OnClick = this.RightBagsOnClick;
            this.FBtn_RightBags[_loc3_].Tag = _loc3_;
            this.FBtn_RightBags[_loc3_].OnMove = this.RightBagsOnMove;
            this.FBtn_RightBags[_loc3_].OnOut = this.RightBagsOnOut;
            _loc3_++;
         }
      }
   }
}

