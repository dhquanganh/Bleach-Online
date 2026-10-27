package Processors.Game.Lobby.Activity.HDLottery
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDLottery.*;
   import Logics.Inventories.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowLottery extends TProcessorHDSingleWindowBase
   {
      
      protected static const ITEMCOUNT:uint = 9;
      
      protected static const TICKETSNUM:uint = 7;
      
      protected static const TICKETNUMLENGTH:uint = 7;
      
      protected static const TicketPanleDurationtime:uint = 3000;
      
      protected static const FlashNum:int = 3;
      
      protected static const MaxTicketNum:int = 99;
      
      protected static const DisplayNum:int = 8;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FHD_Lottery:THDLottery;
      
      protected var FData_Lottery:TActivityLottery;
      
      protected var FTF_Prize:TextField;
      
      protected var FTF_CoolDown:TextField;
      
      protected var FTF_CurScore:TextField;
      
      protected var FTF_CurNum:TextField;
      
      protected var FMC_Note:Sprite;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Code:TextField;
      
      protected var FTF_GetPrize:TextField;
      
      protected var FBtn_GetTicket:TUIButton;
      
      protected var FBtn_ShowTickets:TUIButton;
      
      protected var FBtn_Items:Vector.<TUIButton>;
      
      protected var FTF_ItemsCost:Vector.<TextField>;
      
      protected var FOverFlags:Vector.<Sprite>;
      
      protected var FFlashEffect:Vector.<MovieClip>;
      
      protected var FInventories:Vector.<TInventories>;
      
      protected var FMC_TicketsBar:Sprite;
      
      protected var FTF_Tickets:Vector.<TextField>;
      
      protected var FTicketPage:TUIPage;
      
      protected var FBtn_BarHide:TUIButton;
      
      protected var FNowDate:Date;
      
      protected var FTicketPanle:Sprite;
      
      protected var FTicketNums:Vector.<MovieClip>;
      
      protected var FTicketMask:MovieClip;
      
      protected var FGoldEffect:MovieClip;
      
      protected var FGoldHeap:MovieClip;
      
      protected var FDisplaySlots:Vector.<TUISlot>;
      
      protected var FCurrentPage:int;
      
      protected var FIfSetPage:Boolean;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      public function TProcessorHDWindowLottery(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_Lottery";
         FActivityID = CONST_ACTIVITY_MODE.Activity_Lottery;
         FHint = new THint();
         this.FNowDate = new Date();
         this.FIsInitWindow = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUISlot = null;
         super.InitWindow(param1);
         _loc3_ = ITEMCOUNT;
         this.FBtn_Items = new Vector.<TUIButton>(_loc3_);
         this.FTF_ItemsCost = new Vector.<TextField>(_loc3_);
         this.FOverFlags = new Vector.<Sprite>();
         this.FFlashEffect = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_Items[_loc2_] = new TUIButton();
            this.FBtn_Items[_loc2_].Substrate = FScene["MC_Item_" + _loc2_]["MC_Item"];
            this.FTF_ItemsCost[_loc2_] = FScene["MC_Item_" + _loc2_]["TF_Cost"];
            this.FOverFlags[_loc2_] = FScene["MC_Item_" + _loc2_]["OverFlag"];
            this.FBtn_Items[_loc2_].OnMove = this.ProcessorOnMove;
            this.FBtn_Items[_loc2_].OnOut = this.ProcessorOnOut;
            this.FBtn_Items[_loc2_].OnClick = this.ProcessorOnClick;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < FlashNum)
         {
            this.FFlashEffect[_loc2_] = FScene["MC_Item_" + _loc2_]["FlashEffect"];
            this.FFlashEffect[_loc2_].mouseEnabled = false;
            this.FFlashEffect[_loc2_].mouseChildren = false;
            _loc2_++;
         }
         this.FBtn_GetTicket = new TUIButton();
         this.FBtn_GetTicket.Substrate = FScene["Btn_GetTicket"];
         this.FBtn_GetTicket.OnClick = this.ProcessorOnGetTicket;
         this.FBtn_ShowTickets = new TUIButton();
         this.FBtn_ShowTickets.Substrate = FScene["Btn_ShowTickets"];
         this.FBtn_ShowTickets.OnClick = this.ProcessorOnShow;
         this.FMC_TicketsBar = FScene["MC_TicketsBar"];
         this.FMC_TicketsBar.visible = false;
         this.FTF_Tickets = new Vector.<TextField>(TICKETSNUM);
         _loc3_ = TICKETSNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTF_Tickets[_loc2_] = this.FMC_TicketsBar["TF_Ticket_" + _loc2_];
            _loc2_++;
         }
         this.FBtn_BarHide = new TUIButton();
         this.FBtn_BarHide.Substrate = this.FMC_TicketsBar["Btn_Close"];
         this.FBtn_BarHide.OnClick = this.ProcessorOnHide;
         this.FTF_Prize = FScene["TF_Prize"];
         this.FTF_CurScore = FScene["TF_CurScore"];
         this.FTF_CurNum = FScene["TF_CurNum"];
         this.FTF_CoolDown = FScene["TF_CoolDown"];
         this.FTicketPage = new TUIPage(this);
         this.FTicketPage.ButtonNext.Substrate = this.FMC_TicketsBar["MC_ChangeListPage"]["MC_PageRight"];
         this.FTicketPage.ButtonPrevious.Substrate = this.FMC_TicketsBar["MC_ChangeListPage"]["MC_PageLeft"];
         this.FTicketPage.LabelPage = this.FMC_TicketsBar["MC_ChangeListPage"]["TF_Page"];
         this.FTicketPage.OnChangePage = this.OnChangePage;
         this.FTicketPage.PageSize = TICKETSNUM;
         this.FTicketPage.Init();
         this.FMC_Note = FScene["MC_Note"];
         this.FTF_Name = this.FMC_Note["TF_Name"];
         this.FTF_Code = this.FMC_Note["TF_Code"];
         this.FTF_GetPrize = this.FMC_Note["TF_GetPrize"];
         this.FTicketPanle = FScene["TicketPanle"];
         this.FTicketMask = this.FTicketPanle["TicketMask"];
         this.FTicketNums = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < TICKETNUMLENGTH)
         {
            this.FTicketNums.push(this.FTicketPanle["Num" + _loc2_]);
            _loc2_++;
         }
         this.FTicketPanle.visible = false;
         this.FGoldEffect = FScene["GoldEffect"];
         this.FGoldHeap = FScene["GoldHead"];
         this.FGoldEffect.visible = false;
         this.FDisplaySlots = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < DisplayNum)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = FScene["EquipmentDisplay"]["MC_Slot_" + _loc2_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FDisplaySlots.push(_loc4_);
            _loc2_++;
         }
         this.FIfSetPage = false;
         this.FIsInitWindow = true;
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FData_Lottery = param1 as TActivityLottery;
         this.FTF_CurScore.text = this.FData_Lottery.CurScore.toString();
         this.FTF_CurNum.text = uint(this.FData_Lottery.CurScore / this.FHD_Lottery.BtnGetCost).toString();
         this.FTF_Prize.text = this.FData_Lottery.CurPrize.toString();
         this.FCurrentPage = !this.FIfSetPage ? 0 : this.FCurrentPage;
         this.FIfSetPage = true;
         this.SetupPage(this.FData_Lottery.ListCodes.length,this.FCurrentPage,this.FTicketPage);
         this.RenderDisplayEquipment();
         this.RenderTicketList();
         this.RenderPrizeInfor();
         this.RenderNewTicket();
         this.RenderBox();
         this.RenderGoldHead();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_Lottery = FHDActivityConfig as THDLottery;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         _loc1_ = this.FHD_Lottery.ItemIndex.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FTF_ItemsCost[_loc2_].text = this.FHD_Lottery.ItemsCost[_loc2_].toString();
            _loc2_++;
         }
         _loc3_ = new Vector.<uint>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_[_loc2_] = this.FHD_Lottery.ItemsAward[_loc2_];
            _loc2_++;
         }
         this.FInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
      }
      
      protected function RenderPrizeInfor() : void
      {
         var _loc1_:int = 0;
         _loc1_ = (STimingCore.ServerTime - FActivityAtoms.StartTime) / CONST_COMMON.SecondPerDay;
         if(_loc1_ > 0 && this.FData_Lottery.LastNames.length > 0 && this.FData_Lottery.LastNames.length >= _loc1_ && this.FData_Lottery.LastNames[_loc1_ - 1] != null)
         {
            this.FTF_Name.text = this.FData_Lottery.LastNames[_loc1_ - 1];
            this.FTF_Code.text = this.ExpandStringByLength(this.FData_Lottery.LastCodes[_loc1_ - 1],TICKETNUMLENGTH);
            this.FTF_GetPrize.text = this.FData_Lottery.LastGetMoneys[_loc1_ - 1].toString();
         }
         else
         {
            this.FTF_Name.text = "";
            this.FTF_Code.text = "";
            this.FTF_GetPrize.text = "";
         }
      }
      
      protected function RenderBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = (STimingCore.ServerTime - FActivityAtoms.StartTime) / CONST_COMMON.SecondPerDay;
         _loc3_ = int(this.FOverFlags.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FOverFlags[_loc2_].visible = _loc1_ >= this.FHD_Lottery.Day;
            this.FBtn_Items[_loc2_].Enabled = _loc1_ < this.FHD_Lottery.Day;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < FlashNum)
         {
            this.FFlashEffect[_loc2_].visible = _loc1_ < this.FHD_Lottery.Day;
            if(this.FFlashEffect[_loc2_].visible)
            {
               this.FFlashEffect[_loc2_].play();
            }
            _loc2_++;
         }
         this.FBtn_GetTicket.Enabled = _loc1_ < this.FHD_Lottery.Day && this.FData_Lottery.CurScore >= this.FHD_Lottery.BtnGetCost;
         this.FBtn_ShowTickets.Enabled = _loc1_ < this.FHD_Lottery.Day;
      }
      
      protected function RenderDisplayEquipment() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHD_Lottery.Show.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDisplaySlots[_loc1_].Context = this.FData_Lottery.DisplayInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function RenderTicketList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.FCurrentPage * TICKETSNUM;
         _loc2_ = _loc1_ + TICKETSNUM;
         _loc2_ = _loc2_ > this.FData_Lottery.ListCodes.length ? int(this.FData_Lottery.ListCodes.length) : _loc2_;
         _loc3_ = 0;
         _loc4_ = _loc1_;
         while(_loc4_ < _loc2_)
         {
            this.FTF_Tickets[_loc3_].text = this.ExpandStringByLength(this.FData_Lottery.ListCodes[_loc4_],TICKETNUMLENGTH);
            _loc3_++;
            _loc4_++;
         }
         _loc4_ = _loc3_;
         while(_loc4_ < TICKETSNUM)
         {
            this.FTF_Tickets[_loc4_].text = "";
            _loc4_++;
         }
      }
      
      protected function RenderNewTicket() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!this.FData_Lottery.IfNewTicketCreate)
         {
            return;
         }
         this.FTicketPanle.visible = true;
         this.FTicketMask.gotoAndPlay(1);
         _loc4_ = int(this.FData_Lottery.ListCodes[this.FData_Lottery.ListCodes.length - 1]);
         _loc1_ = 0;
         while(_loc1_ < TICKETNUMLENGTH)
         {
            _loc3_ = _loc4_ % 10;
            _loc4_ /= 10;
            this.FTicketNums[_loc1_].gotoAndStop(_loc3_ + 1);
            _loc1_++;
         }
      }
      
      protected function RenderGoldHead() : void
      {
         var _loc1_:int = 0;
         if(!this.FData_Lottery.IfGoldHeadChange)
         {
            return;
         }
         this.FGoldEffect.gotoAndPlay(1);
         this.FGoldEffect.visible = true;
         _loc1_ = this.FData_Lottery.CurPrize / 500 + 1;
         if(_loc1_ > this.FGoldHeap.totalFrames)
         {
            _loc1_ = this.FGoldHeap.totalFrames;
         }
         this.FGoldHeap.gotoAndStop(_loc1_);
      }
      
      protected function ExpandStringByLength(param1:int, param2:int) : String
      {
         var _loc3_:String = null;
         _loc3_ = param1.toString();
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      protected function MyFormatTime(param1:uint) : String
      {
         var _loc2_:int = 0;
         _loc2_ = param1 / TUtilityTiming.CONST_DAY;
         if(_loc2_ > 0)
         {
            return _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Day);
         }
         return TUtilityTiming.fomatTime(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow || !Visible)
         {
            return;
         }
         this.UpdateDisplayEquipment();
         this.UpdateCoolDownTime();
         this.UpdateTicketPanle();
         this.UpdateGoldEffect();
      }
      
      protected function UpdateDisplayEquipment() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHD_Lottery.Show.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDisplaySlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function UpdateCoolDownTime() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = STimingCore.ServerLocalTime % CONST_COMMON.SecondPerDay;
         _loc2_ = CONST_COMMON.SecondPerDay - _loc1_;
         this.FTF_CoolDown.text = TUtilityTiming.fomatTime(_loc2_);
      }
      
      protected function UpdateTicketPanle() : void
      {
         if(this.FData_Lottery.IfNewTicketCreate)
         {
            if(STimingCore.TickCount - this.FData_Lottery.TimeStore > TicketPanleDurationtime)
            {
               this.FData_Lottery.IfNewTicketCreate = false;
               this.FTicketPanle.visible = false;
            }
         }
      }
      
      protected function UpdateGoldEffect() : void
      {
         if(this.FData_Lottery.IfGoldHeadChange)
         {
            if(this.FGoldEffect.currentFrame == this.FGoldEffect.totalFrames)
            {
               this.FGoldEffect.stop();
               this.FGoldEffect.visible = false;
               this.FData_Lottery.IfGoldHeadChange = false;
            }
         }
      }
      
      protected function SetupPage(param1:int, param2:int, param3:TUIPage) : void
      {
         param3.TotalQuantity = param1;
         param3.Update();
         param3.PageIndex = param2;
      }
      
      protected function OnChangePage(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.RenderTicketList();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      protected function ProcessorOnGetTicket(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData_Lottery.ListCodes.length >= MaxTicketNum)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_75));
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_Lottery.BtnGetIndex);
      }
      
      protected function ProcessorOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtn_Items.indexOf(param1);
         if(SLogicsCore.Character.CreditGold < this.FHD_Lottery.ItemsCost[_loc3_])
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         this.WindowUIPopUp.visible = true;
         this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_Lottery.ItemsCost[_loc3_]);
         this.WindowUIPopUp.OnOK = this.WindowOk;
         this.WindowUIPopUp.Tag = this.FHD_Lottery.ItemIndex[param2.currentTarget.parent.name.split("_")[2]];
      }
      
      private function WindowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc2_);
      }
      
      protected function ProcessorOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function ProcessorOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.parent.name.split("_")[2]);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FInventories[_loc3_]);
         }
      }
      
      protected function ProcessorOnShow(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_TicketsBar.visible = true;
      }
      
      protected function ProcessorOnHide(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_TicketsBar.visible = false;
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         this.FMC_TicketsBar.visible = false;
         this.FCurrentPage = 0;
         this.SetupPage(this.FData_Lottery.ListCodes.length,0,this.FTicketPage);
         this.FData_Lottery.IfNewTicketCreate = false;
         this.FTicketPanle.visible = false;
         this.FData_Lottery.IfGoldHeadChange = false;
         this.FGoldEffect.visible = false;
         _loc2_ = int(this.FHD_Lottery.Show.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDisplaySlots[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

