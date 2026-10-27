package Processors.Game.Lobby.Activity.HDBleachBag
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDBleachBag.THDBleachBagData;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TprocessorHDWindowBleachBag extends TProcessorHDSingleWindowBase
   {
      
      public static const GoodsNum:int = 6;
      
      public static const RechargeGiftsNum:int = 3;
      
      private var FPreviewUI:Sprite;
      
      private var FFinalAwardUI:Sprite;
      
      private var FBackBtn:TUIButton;
      
      private var FFinalAwardReciveFlag:Sprite;
      
      private var FFinalShowAwardUI:TShowAwardUI;
      
      private var FShowAwardUI:TShowAwardUI;
      
      private var FFreeAwardReciveBtn:TUIButton;
      
      private var FFreeAwardReciveFlag:Sprite;
      
      private var FFreeAwardBtnFightReport:TUIButton;
      
      private var FBleachBagUI:Sprite;
      
      private var FLoginGiftBag:TUIButton;
      
      private var FLoginReciveFlag:Sprite;
      
      private var FLoginReciveBtn:TUIButton;
      
      protected var FBtnBuys:Vector.<TUIButton>;
      
      protected var FUIGoods:Vector.<TUIButton>;
      
      protected var FBuyFlags:Vector.<Sprite>;
      
      protected var FTFCosts:Vector.<TextField>;
      
      protected var FTFConditionVec:Vector.<TextField>;
      
      protected var FRechargeFlagsVec:Vector.<Sprite>;
      
      protected var FRechargeGiftsVec:Vector.<TUIButton>;
      
      protected var FAchieve:TBleachBagAchieve;
      
      protected var FAchieveSkin:Sprite;
      
      protected var FOpenAchieveBtn:TUIButton;
      
      protected var FOpenPreviewBtn:TUIButton;
      
      protected var FActivityData:THDBleachBagData;
      
      public function TprocessorHDWindowBleachBag(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_BleachBag";
         FActivityID = CONST_ACTIVITY_MODE.Activity_BleachBag;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatch();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         this.FPreviewUI = FScene["MC_PreviewUI"];
         this.FPreviewUI.visible = false;
         this.FFinalAwardUI = this.FPreviewUI["MC_FinalAward"];
         this.FFinalShowAwardUI = new TShowAwardUI(this);
         this.FFinalShowAwardUI.UIDispatch(this.FFinalAwardUI["ShowAward"]);
         this.FFinalAwardReciveFlag = this.FFinalAwardUI["MC_Get"];
         this.FBackBtn = new TUIButton();
         this.FBackBtn.Substrate = this.FFinalAwardUI["BtnRecive"];
         this.FBackBtn.OnClick = this.OnOpenPreview;
         this.FBleachBagUI = FScene["MC_BleachBag"];
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(this.FBleachBagUI["MC_FinalAward"]["ShowAward"]);
         this.FFreeAwardReciveBtn = new TUIButton();
         this.FFreeAwardReciveBtn.Substrate = this.FBleachBagUI["MC_FinalAward"]["BtnRecive"];
         this.FFreeAwardReciveBtn.OnClick = this.BtnFinalAwardReciveOnClick;
         this.FFreeAwardReciveFlag = this.FBleachBagUI["MC_FinalAward"]["MC_Get"];
         this.FLoginGiftBag = new TUIButton();
         this.FLoginGiftBag.Substrate = this.FBleachBagUI["LoginMoudle"]["MC_Box"];
         this.FLoginGiftBag.OnMove = this.LoginBoxOnMove;
         this.FLoginGiftBag.OnOut = this.BoxOnOut;
         this.FLoginReciveFlag = this.FBleachBagUI["LoginMoudle"]["MC_ReciveFlag"];
         this.FLoginReciveBtn = new TUIButton();
         this.FLoginReciveBtn.Substrate = this.FBleachBagUI["LoginMoudle"]["Btn_BoxBtn"];
         this.FLoginReciveBtn.OnClick = this.BtnLoginReciveOnClick;
         this.FBtnBuys = new Vector.<TUIButton>();
         this.FUIGoods = new Vector.<TUIButton>();
         this.FBuyFlags = new Vector.<Sprite>();
         this.FTFCosts = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < GoodsNum)
         {
            _loc2_ = this.FBleachBagUI["Goods" + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Gift"];
            _loc3_.OnMove = this.GiftBoxOnMove;
            _loc3_.OnOut = this.BoxOnOut;
            this.FUIGoods.push(_loc3_);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Btn_Buy"];
            _loc3_.OnClick = this.BtnBuyOnClick;
            this.FBtnBuys.push(_loc3_);
            this.FBuyFlags.push(_loc2_["MC_BuyFlag"]);
            this.FTFCosts.push(_loc2_["TF_Cost"]);
            _loc1_++;
         }
         this.FTFConditionVec = new Vector.<TextField>();
         this.FRechargeFlagsVec = new Vector.<Sprite>();
         this.FRechargeGiftsVec = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < RechargeGiftsNum)
         {
            _loc2_ = this.FBleachBagUI["Mc_Recharge_" + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Btn_Gift"];
            _loc3_.OnMove = this.RechargeGiftBoxOnMove;
            _loc3_.OnOut = this.BoxOnOut;
            _loc3_.OnClick = this.BtnRechargeGiftOnClick;
            this.FRechargeGiftsVec[_loc1_] = _loc3_;
            this.FRechargeFlagsVec.push(_loc2_["MC_Get"]);
            this.FTFConditionVec.push(_loc2_["TF_Gold"]);
            _loc1_++;
         }
         this.FAchieveSkin = FScene["MC_TaskView"];
         this.FAchieve = new TBleachBagAchieve(this,this.FAchieveSkin);
         this.FAchieve.OnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FAchieve.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FAchieve.OnSendMessageFun = this.SendMsgFun;
         this.FOpenAchieveBtn = new TUIButton();
         this.FOpenAchieveBtn.Substrate = this.FBleachBagUI["BtnOpenTaskView"];
         this.FOpenAchieveBtn.OnClick = this.OnOpenAchieve;
         this.FOpenPreviewBtn = new TUIButton();
         this.FOpenPreviewBtn.Substrate = this.FBleachBagUI["BtnPreviewView"];
         this.FOpenPreviewBtn.OnClick = this.OnOpenPreview;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
         }
      }
      
      protected function BuyGoodsReq(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag);
      }
      
      private function SendMsgFun(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      public function RefreshView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FLoginReciveFlag.visible = this.FActivityData.CurFreeAwardState == CONST_CHRISTMAS.Finish;
         this.FLoginReciveBtn.Enabled = this.FActivityData.CurFreeAwardState == CONST_CHRISTMAS.ScanGetState;
         _loc2_ = RechargeGiftsNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFConditionVec[_loc1_].text = TUtilityString.Format(this.FActivityData.ActivityConfig.Desc2,this.FActivityData.GetRechargeGiftsData()[_loc1_].Condition);
            this.FRechargeFlagsVec[_loc1_].visible = this.FActivityData.GetRechargeGiftsData()[_loc1_].GiftState == CONST_CHRISTMAS.Finish;
            this.FRechargeGiftsVec[_loc1_].Enabled = this.FActivityData.GetRechargeGiftsData()[_loc1_].GiftState == CONST_CHRISTMAS.ScanGetState;
            _loc1_++;
         }
         _loc2_ = GoodsNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(SLogicsCore.Character.CreditGold < this.FActivityData.GetCostGiftsData()[_loc1_].Condition || this.FActivityData.GetCostGiftsData()[_loc1_].State == CONST_CHRISTMAS.Finish)
            {
               this.FBtnBuys[_loc1_].Enabled = false;
            }
            else
            {
               this.FBtnBuys[_loc1_].Enabled = true;
            }
            this.FBuyFlags[_loc1_].visible = this.FActivityData.GetCostGiftsData()[_loc1_].State == CONST_CHRISTMAS.Finish;
            this.FTFCosts[_loc1_].text = this.FActivityData.GetCostGiftsData()[_loc1_].Condition.toString();
            _loc1_++;
         }
         this.FShowAwardUI.SetData(this.FActivityData.ActivityConfig.FinalAwardTypeVec[this.FActivityData.ActivityDay],this.FActivityData.ActivityConfig.FinalAwardAwardVec[this.FActivityData.ActivityDay],this.FActivityData.ActivityConfig.FinalAwardShowIDVec[this.FActivityData.ActivityDay],TOverlayerGiftBox.TYPE_ALL);
         this.FFreeAwardReciveBtn.Enabled = this.FActivityData.FinalAwardState == CONST_CHRISTMAS.ScanGetState;
         this.FFreeAwardReciveFlag.visible = this.FActivityData.FinalAwardState == CONST_CHRISTMAS.Finish;
         if(this.FActivityData.ActivityDay < this.FActivityData.ActivityConfig.FinalAwardAwardVec.length - 1)
         {
            this.FOpenPreviewBtn.Enabled = true;
            this.FFinalShowAwardUI.SetData(this.FActivityData.ActivityConfig.FinalAwardTypeVec[this.FActivityData.ActivityDay + 1],this.FActivityData.ActivityConfig.FinalAwardAwardVec[this.FActivityData.ActivityDay + 1],this.FActivityData.ActivityConfig.FinalAwardShowIDVec[this.FActivityData.ActivityDay + 1],TOverlayerGiftBox.TYPE_ALL);
         }
         else
         {
            this.FOpenPreviewBtn.Enabled = false;
         }
         this.FAchieve.Data = this.FActivityData;
         this.FAchieve.RefreshView();
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnFinalAwardReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityData.ActivityConfig.FinalAwardIndex);
      }
      
      protected function BtnLoginReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityData.ActivityConfig.PerDayFreeIndex);
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnBuys.indexOf(param1 as TUIButton);
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FActivityData.GetCostGiftsData()[_loc3_].Index;
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityData.GetCostGiftsData()[_loc3_].Condition);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnRechargeGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FRechargeGiftsVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityData.GetRechargeGiftsData()[_loc3_].Index);
      }
      
      protected function LoginBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FActivityData.FreeAwards[this.FActivityData.ActivityDay],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FUIGoods.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityData.GetCostGiftsData()[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function RechargeGiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FRechargeGiftsVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityData.GetRechargeGiftsData()[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnOpenPreview(param1:Object, param2:MouseEvent) : void
      {
         this.FPreviewUI.visible = !this.FPreviewUI.visible;
      }
      
      protected function OnOpenAchieve(param1:Object, param2:MouseEvent) : void
      {
         this.FAchieve.Show(this.FActivityData);
      }
      
      public function set ActivityData(param1:THDBleachBagData) : void
      {
         this.FActivityData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RefreshView();
      }
   }
}

