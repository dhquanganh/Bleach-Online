package Processors.Game.Lobby.Activity.HDFoolsDay.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDFoolsDayRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDFoolsDay.TFoolsDayRecharge;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowFoolsDayRecharge extends TProcessorHDSingleWindowBase
   {
      
      protected var FJackPoint:TShowAwardUI;
      
      protected var FBtn_Report:TUIButton;
      
      protected var FBtn_GetJackPoint:TUIButton;
      
      protected var FBtn_Bag:TUIButton;
      
      protected var FBtn_ProgressBags:Vector.<TUIButton>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_ProgressGet:Vector.<TUIButton>;
      
      protected var FData:TFoolsDayRecharge;
      
      protected var FConfig:THDFoolsDayRecharge;
      
      public function TProcessorHDWindowFoolsDayRecharge(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDFoolsDayRecharge;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(Visible == false)
         {
            return;
         }
         _loc1_ = 2;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as TFoolsDayRecharge;
         this.FBtn_Bag.Enabled = this.FData.CurStatus == 1 ? true : false;
         if(this.FData.CurStatus == 1)
         {
            FScene["MC_Bag"].gotoAndStop(1);
            (FScene["MC_Bag"] as MovieClip).mouseEnabled = true;
         }
         if(this.FData.CurStatus == -1)
         {
            FScene["MC_Bag"].gotoAndStop(4);
            (FScene["MC_Bag"] as MovieClip).mouseEnabled = true;
            (FScene["MC_Bag"] as MovieClip).addEventListener(MouseEvent.MOUSE_MOVE,this.ProgressBagsMoveEx);
            (FScene["MC_Bag"] as MovieClip).addEventListener(MouseEvent.MOUSE_OUT,this.ProgressBagsOutEx);
         }
         if(this.FData.CurStatus == 0)
         {
            FScene["MC_Bag"].gotoAndStop(3);
            (FScene["MC_Bag"] as MovieClip).mouseEnabled = true;
         }
         this.FSlots[0].Context = this.FData.ProgressBags[2].GetInventoryByIndex(0);
         this.FSlots[1].Context = this.FData.ProgressBags[4].GetInventoryByIndex(0);
         this.FBtn_ProgressBags[0].Enabled = this.FData.ProgressStatus[0] == 1 ? true : false;
         this.FBtn_ProgressBags[1].Enabled = this.FData.ProgressStatus[1] == 1 ? true : false;
         this.FBtn_ProgressBags[2].Enabled = this.FData.ProgressStatus[3] == 1 ? true : false;
         this.FSlots[0].Enabled = this.FData.ProgressStatus[2] == 1 ? true : false;
         this.FSlots[1].Enabled = this.FData.ProgressStatus[4] == 1 ? true : false;
         FScene["MC_DailyGift"]["MC_Item0"]["MC_Get"].visible = this.FData.ProgressStatus[0] == -1 ? true : false;
         FScene["MC_DailyGift"]["MC_Item1"]["MC_Get"].visible = this.FData.ProgressStatus[1] == -1 ? true : false;
         FScene["MC_DailyGift"]["MC_slot0"]["MC_Get"].visible = this.FData.ProgressStatus[2] == -1 ? true : false;
         FScene["MC_DailyGift"]["MC_Item2"]["MC_Get"].visible = this.FData.ProgressStatus[3] == -1 ? true : false;
         FScene["MC_DailyGift"]["MC_slot1"]["MC_Get"].visible = this.FData.ProgressStatus[4] == -1 ? true : false;
         _loc3_ = 5;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_ProgressGet[_loc2_].Enabled = this.FData.ProgressStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.UpdateJackPoint();
         FScene["TF_Need2"].text = this.FData.Config.TotalAward.gold + "";
         FScene["TF_Need"].text = this.FData.Config.DayAward[0].cond + "";
         FScene["MC_DailyGift"]["TF_Recharge"].text = this.FData.Recharge + "";
         FScene["TF_Recharge"].text = this.FData.Recharge + "";
      }
      
      protected function UpdateJackPoint() : void
      {
         var _loc1_:Sprite = null;
         this.FJackPoint.SetData(this.FData.Config.TotalAward.showType,this.FData.Config.TotalAward.awardId,this.FData.Config.TotalAward.showID);
         this.FBtn_Report.Visible = this.FData.Config.TotalAward.fightReportAddr != "";
         this.FBtn_GetJackPoint.Enabled = this.FData.JackPointStatus == 1 ? true : false;
      }
      
      protected function ProcessorReport(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.TotalAward.fightReportAddr);
      }
      
      protected function ProcessorGetBag(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.DayAward[0].index);
         if(FScene["MC_Effect_0"] == null)
         {
            return;
         }
         FScene["MC_Effect_0"].gotoAndPlay(1);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         switch(_loc3_)
         {
            case 0:
               ProcessorOnGiftBoxMove(this,this.FData.ProgressBags[0],TOverlayerGiftBox.TYPE_ALL);
               break;
            case 1:
               ProcessorOnGiftBoxMove(this,this.FData.ProgressBags[1],TOverlayerGiftBox.TYPE_ALL);
               break;
            case 2:
               ProcessorOnGiftBoxMove(this,this.FData.ProgressBags[3],TOverlayerGiftBox.TYPE_ALL);
               break;
            case 99:
               ProcessorOnGiftBoxMove(this,this.FData.CurBag,TOverlayerGiftBox.TYPE_ALL);
         }
      }
      
      protected function ProgressBagsMoveEx(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.CurBag,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProgressBagsOutEx(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorBagsGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ProgressAward[param1.Tag].index);
      }
      
      protected function ProcessorGetJackPoint(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.TotalAward.index);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FJackPoint = new TShowAwardUI(this);
         this.FJackPoint.UIDispatch(FScene["MC_MountPoint"]);
         this.FBtn_Report = new TUIButton();
         this.FBtn_Report.Substrate = FScene["Btn_Report"];
         this.FBtn_Report.OnClick = this.ProcessorReport;
         this.FBtn_GetJackPoint = new TUIButton();
         this.FBtn_GetJackPoint.Substrate = FScene["Btn_GetJackPoint"];
         this.FBtn_GetJackPoint.OnClick = this.ProcessorGetJackPoint;
         this.FBtn_Bag = new TUIButton();
         this.FBtn_Bag.Substrate = FScene["MC_Bag"];
         this.FBtn_Bag.OnClick = this.ProcessorGetBag;
         this.FBtn_Bag.Tag = 99;
         this.FBtn_Bag.OnMove = this.ProcessorGiftOnMove;
         this.FBtn_Bag.OnOut = this.ProcessorGiftOnOut;
         _loc2_ = 2;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_DailyGift"]["MC_slot" + _loc3_]["slot"];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc2_ = 3;
         this.FBtn_ProgressBags = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_ProgressBags[_loc3_] = new TUIButton();
            this.FBtn_ProgressBags[_loc3_].Substrate = FScene["MC_DailyGift"]["MC_Item" + _loc3_]["Btn_Gift"];
            this.FBtn_ProgressBags[_loc3_].Tag = _loc3_;
            this.FBtn_ProgressBags[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_ProgressBags[_loc3_].OnOut = this.ProcessorGiftOnOut;
            _loc3_++;
         }
         _loc2_ = 5;
         this.FBtn_ProgressGet = new Vector.<TUIButton>(_loc2_);
         this.FBtn_ProgressGet[0] = new TUIButton();
         this.FBtn_ProgressGet[0].Substrate = FScene["MC_DailyGift"]["MC_Item0"]["Btn_ExchargeOne"];
         this.FBtn_ProgressGet[0].Tag = 0;
         this.FBtn_ProgressGet[0].OnClick = this.ProcessorBagsGet;
         this.FBtn_ProgressGet[1] = new TUIButton();
         this.FBtn_ProgressGet[1].Substrate = FScene["MC_DailyGift"]["MC_Item1"]["Btn_ExchargeOne"];
         this.FBtn_ProgressGet[1].Tag = 1;
         this.FBtn_ProgressGet[1].OnClick = this.ProcessorBagsGet;
         this.FBtn_ProgressGet[2] = new TUIButton();
         this.FBtn_ProgressGet[2].Substrate = FScene["MC_DailyGift"]["MC_slot0"]["Btn_ExchargeOne"];
         this.FBtn_ProgressGet[2].Tag = 2;
         this.FBtn_ProgressGet[2].OnClick = this.ProcessorBagsGet;
         this.FBtn_ProgressGet[3] = new TUIButton();
         this.FBtn_ProgressGet[3].Substrate = FScene["MC_DailyGift"]["MC_Item2"]["Btn_ExchargeOne"];
         this.FBtn_ProgressGet[3].Tag = 3;
         this.FBtn_ProgressGet[3].OnClick = this.ProcessorBagsGet;
         this.FBtn_ProgressGet[4] = new TUIButton();
         this.FBtn_ProgressGet[4].Substrate = FScene["MC_DailyGift"]["MC_slot1"]["Btn_ExchargeOne"];
         this.FBtn_ProgressGet[4].Tag = 4;
         this.FBtn_ProgressGet[4].OnClick = this.ProcessorBagsGet;
         FScene["MC_Effect_1"].gotoAndPlay(1);
         (FScene["MC_Effect_1"] as MovieClip).mouseChildren = false;
         (FScene["MC_Effect_1"] as MovieClip).mouseEnabled = false;
         FScene["MC_Effect_2"].gotoAndPlay(1);
         (FScene["MC_Effect_2"] as MovieClip).mouseChildren = false;
         (FScene["MC_Effect_2"] as MovieClip).mouseEnabled = false;
      }
   }
}

