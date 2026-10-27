package Processors.Game.Lobby.Activity.HDNewHalloween.HDWindow
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewHalloween.THDNewHalloweenConsumeData;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TCandyShopVo;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TPumpkinShopVo;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_NewHalloween;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHalloweenConsumeView extends TProcessorHDSingleWindowBase
   {
      
      public static const AwardMax:int = 8;
      
      public static const TabNum:int = 3;
      
      protected var FUITab:TUITab;
      
      protected var FConsumePromptMC:Sprite;
      
      protected var FRechargeGoldTF:TextField;
      
      protected var FRechargeScoreTF:TextField;
      
      protected var FScoreTF:TextField;
      
      protected var FMaxAwardAreaMc:Sprite;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FAwardReceiveBtn:TUIButton;
      
      protected var FAwardReciveFlag:Sprite;
      
      protected var FBtnFightReport:TUIButton;
      
      protected var FNeedGoldTF:TextField;
      
      protected var FPumpkinAreaMc:Sprite;
      
      protected var FPumpkinDoubleScoreFlagVec:Vector.<Sprite>;
      
      protected var FPumpkinGoldTFVec:Vector.<TextField>;
      
      protected var FPumpkinNameTFVec:Vector.<TextField>;
      
      protected var FPumpkinSlotsVec:Vector.<TUISlot>;
      
      protected var FPumpkinBuyBtnVec:Vector.<TUIButton>;
      
      protected var FCandyAreaMc:Sprite;
      
      protected var FCandyDiscountVec:Vector.<Sprite>;
      
      protected var FCandyGoldTFVec:Vector.<TextField>;
      
      protected var FCandyGiftBtnVec:Vector.<TUIButton>;
      
      protected var FCandyNameTFVec:Vector.<TextField>;
      
      protected var FCandyBuyBtnVec:Vector.<TUIButton>;
      
      protected var FShopCartAreaMc:Sprite;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FGlobalMinusPromptTF:TextField;
      
      protected var FTotalGoldTF:TextField;
      
      protected var FExtraScoreTF:TextField;
      
      protected var FSpareGoldTF:TextField;
      
      protected var FSpendGoldTF:TextField;
      
      protected var FShopCartBuyBtn:TUIButton;
      
      protected var FCurrentSelectTab:int;
      
      protected var FRanderItemVec:Vector.<Sprite>;
      
      protected var FDeleteBtnVec:Vector.<TUIButton>;
      
      protected var FAddBtnVec:Vector.<TUIButton>;
      
      protected var FMinusBtnVec:Vector.<TUIButton>;
      
      protected var FData:THDNewHalloweenConsumeData;
      
      public function TProcessorHalloweenConsumeView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUISlot = null;
         super.InitWindow(param1);
         this.FMaxAwardAreaMc = FScene["MC_MaxAwardArea"];
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(this.FMaxAwardAreaMc["ShowAward"]);
         this.FAwardReceiveBtn = new TUIButton();
         this.FAwardReceiveBtn.Substrate = this.FMaxAwardAreaMc["BtnReceive"];
         this.FAwardReceiveBtn.OnClick = this.BtnBuyMaxAwardOnClick;
         this.FAwardReciveFlag = this.FMaxAwardAreaMc["MC_Get"];
         this.FBtnFightReport = new TUIButton();
         this.FBtnFightReport.Substrate = this.FMaxAwardAreaMc["BtnFightReport"];
         this.FBtnFightReport.OnClick = this.BtnFightReportOnClick;
         this.FNeedGoldTF = this.FMaxAwardAreaMc["TF_Gold"];
         this.FUITab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < TabNum)
         {
            this.FUITab.SetTabByIndex(FScene["MC_Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.OnTabSwitch;
         this.FUITab.Init();
         this.FConsumePromptMC = FScene["MC_Consume"];
         this.FRechargeGoldTF = this.FConsumePromptMC["TF_RechargeGold"];
         this.FRechargeScoreTF = this.FConsumePromptMC["TF_RechargeScore"];
         this.FScoreTF = FScene["TF_Score"];
         this.FPumpkinAreaMc = FScene["MC_PumpkinArea"];
         this.FPumpkinDoubleScoreFlagVec = new Vector.<Sprite>();
         this.FPumpkinGoldTFVec = new Vector.<TextField>();
         this.FPumpkinNameTFVec = new Vector.<TextField>();
         this.FPumpkinSlotsVec = new Vector.<TUISlot>();
         this.FPumpkinBuyBtnVec = new Vector.<TUIButton>();
         _loc2_ = 0;
         while(_loc2_ < AwardMax)
         {
            _loc4_ = this.FPumpkinAreaMc["Item" + _loc2_];
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc4_["Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FPumpkinSlotsVec[_loc2_] = _loc5_;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["Btn_ShoppingCart"];
            _loc3_.OnClick = this.BtnAddShopCartOnClick;
            this.FPumpkinBuyBtnVec[_loc2_] = _loc3_;
            this.FPumpkinDoubleScoreFlagVec[_loc2_] = _loc4_["MC_ScoreSign"];
            this.FPumpkinGoldTFVec[_loc2_] = _loc4_["TF_Gold"];
            this.FPumpkinNameTFVec[_loc2_] = _loc4_["TF_Name"];
            _loc2_++;
         }
         this.FCandyAreaMc = FScene["MC_CandyArea"];
         this.FCandyDiscountVec = new Vector.<Sprite>();
         this.FCandyGoldTFVec = new Vector.<TextField>();
         this.FCandyGiftBtnVec = new Vector.<TUIButton>();
         this.FCandyNameTFVec = new Vector.<TextField>();
         this.FCandyBuyBtnVec = new Vector.<TUIButton>();
         _loc2_ = 0;
         while(_loc2_ < AwardMax)
         {
            _loc4_ = this.FCandyAreaMc["Item" + _loc2_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["MC_Gift"];
            _loc3_.OnMove = this.GiftBoxOnMove;
            _loc3_.OnOut = this.BoxOnOut;
            this.FCandyGiftBtnVec[_loc2_] = _loc3_;
            this.FCandyDiscountVec[_loc2_] = _loc4_["MC_Back"];
            this.FCandyGoldTFVec[_loc2_] = _loc4_["TF_Gold"];
            this.FCandyNameTFVec[_loc2_] = _loc4_["TF_Name"];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["Btn_ShoppingCart"];
            _loc3_.OnClick = this.CandyAddShopCartOnClick;
            this.FCandyBuyBtnVec[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FShopCartAreaMc = FScene["MC_ShoppingCart"];
         this.FUIScrollBar = new TScrollBar(this.FShopCartAreaMc["MC_AwardList"],109,false,4,25);
         this.FUIScrollBar.Visible = false;
         this.FGlobalMinusPromptTF = this.FShopCartAreaMc["TF_GlobalMinus"];
         this.FExtraScoreTF = this.FShopCartAreaMc["TF_ExtraScore"];
         this.FTotalGoldTF = this.FShopCartAreaMc["TF_TotalGold"];
         this.FSpareGoldTF = this.FShopCartAreaMc["TF_SpareGold"];
         this.FSpendGoldTF = this.FShopCartAreaMc["TF_SpendGold"];
         this.FShopCartBuyBtn = new TUIButton();
         this.FShopCartBuyBtn.OnClick = this.ConfirmShopCartOnClick;
         this.FShopCartBuyBtn.Substrate = this.FShopCartAreaMc["Btn_OK"];
         this.FCurrentSelectTab = 0;
         this.FRanderItemVec = new Vector.<Sprite>();
         this.FDeleteBtnVec = new Vector.<TUIButton>();
         this.FAddBtnVec = new Vector.<TUIButton>();
         this.FMinusBtnVec = new Vector.<TUIButton>();
         this.FUITab.SwithTagManual(this.FCurrentSelectTab);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.UpdatePropSlots(this.FPumpkinSlotsVec);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as THDNewHalloweenConsumeData;
         super.UpdateDataBase(param1);
         this.RenderMaxAwardArea();
         this.RenderPumpkinArea();
         this.RenderCandyArea();
         this.RenderShopCartArea();
         this.FScoreTF.text = this.FData.Score.toString();
         this.FRechargeGoldTF.text = this.FData.ActivityConfig.Rate.toString();
      }
      
      protected function RenderMaxAwardArea() : void
      {
         this.FShowAwardUI.SetData(this.FData.ActivityConfig.BuyAwardObj.showType,this.FData.ActivityConfig.BuyAwardObj.award,this.FData.ActivityConfig.BuyAwardObj.showID,TOverlayerGiftBox.TYPE_ALL);
         this.FNeedGoldTF.text = this.FData.ActivityConfig.BuyAwardObj.gold.toString();
         if(this.FData.ActivityConfig.BuyAwardObj.fightReportAddr == "")
         {
            this.FBtnFightReport.Visible = false;
         }
         else
         {
            this.FBtnFightReport.Visible = true;
         }
         this.FAwardReceiveBtn.Enabled = this.FData.AwardState != CONST_NewHalloween.Finish ? true : false;
         this.FAwardReciveFlag.visible = this.FData.AwardState == CONST_NewHalloween.Finish;
      }
      
      protected function RenderPumpkinArea() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPumpkinShopVo = null;
         _loc2_ = int(this.FData.PumpkinDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.PumpkinDataVec[_loc1_];
            this.FPumpkinSlotsVec[_loc1_].Context = null;
            this.FPumpkinSlotsVec[_loc1_].Context = _loc3_.Inventories.GetInventoryByIndex(0);
            this.FPumpkinNameTFVec[_loc1_].text = _loc3_.Name;
            this.FPumpkinDoubleScoreFlagVec[_loc1_].visible = _loc3_.IsDouble;
            this.FPumpkinGoldTFVec[_loc1_].text = _loc3_.Gold.toString();
            _loc1_++;
         }
      }
      
      protected function RenderCandyArea() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCandyShopVo = null;
         _loc2_ = int(this.FData.CandyDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.CandyDataVec[_loc1_];
            this.FCandyNameTFVec[_loc1_].text = _loc3_.Name;
            this.FCandyDiscountVec[_loc1_].visible = _loc3_.IsDiscount;
            this.FCandyDiscountVec[_loc1_]["TF_MaxValue"].text = _loc3_.Condition.toString();
            this.FCandyDiscountVec[_loc1_]["TF_Minus"].text = _loc3_.Minus.toString();
            this.FCandyGoldTFVec[_loc1_].text = _loc3_.Gold.toString();
            _loc1_++;
         }
      }
      
      protected function RenderShopCartArea() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Object = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TUIButton = null;
         var _loc7_:TUIButton = null;
         var _loc8_:Vector.<Object> = null;
         _loc8_ = this.FData.GetShopCartData();
         _loc2_ = int(_loc8_.length);
         this.FUIScrollBar.Clear();
         this.FRanderItemVec.length = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc8_[_loc1_];
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("ItemRender") as Sprite;
            this.FRanderItemVec[_loc1_] = _loc3_;
            _loc3_["TF_Name"].text = _loc4_.Name;
            _loc3_["TF_Gold"].text = _loc4_.Gold.toString();
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_["Btn_Delete"];
            _loc5_.OnClick = this.DeleteOnClick;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc3_["MC_Amount"]["BTN_Add"];
            _loc6_.OnClick = this.AddOnClick;
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc3_["MC_Amount"]["BTN_Reduce"];
            _loc7_.OnClick = this.MinusOnClick;
            _loc3_["MC_Amount"]["TF_GoodsNum"].text = _loc4_.ShopCartAmount.toString();
            this.FUIScrollBar.AddItem(_loc3_);
            this.FDeleteBtnVec[_loc1_] = _loc5_;
            this.FAddBtnVec[_loc1_] = _loc6_;
            this.FMinusBtnVec[_loc1_] = _loc7_;
            _loc1_++;
         }
         this.FUIScrollBar.ScrollToUp();
         this.FUIScrollBar.Visible = true;
         _loc4_ = this.FData.GlobalSpareGold(1);
         if(_loc4_.IsSatisfyCondition)
         {
            this.FGlobalMinusPromptTF.text = this.FData.ActivityConfig.PromptMsgObj.prompt1;
         }
         else
         {
            this.FGlobalMinusPromptTF.text = TUtilityString.Format(this.FData.ActivityConfig.PromptMsgObj.prompt2,_loc4_.SpareGold);
         }
         this.FExtraScoreTF.text = this.FData.GlobalExtraScore().toString();
         this.FTotalGoldTF.text = this.FData.GlobalTotalGold().toString();
         this.FSpareGoldTF.text = this.FData.GlobalSpareGold().SpareGold.toString();
         this.FSpendGoldTF.text = this.FData.GlobalShopSpendGold().toString();
      }
      
      private function UpdatePropSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function OnTabSwitch(param1:int) : void
      {
         if(param1 == CONST_NewHalloween.CHRISTMAS_TAB_0)
         {
            this.FMaxAwardAreaMc.visible = true;
            this.FPumpkinAreaMc.visible = false;
            this.FShopCartAreaMc.visible = false;
            this.FCandyAreaMc.visible = false;
            this.FConsumePromptMC.visible = false;
         }
         else if(param1 == CONST_NewHalloween.CHRISTMAS_TAB_1)
         {
            this.FMaxAwardAreaMc.visible = false;
            this.FPumpkinAreaMc.visible = true;
            this.FShopCartAreaMc.visible = true;
            this.FCandyAreaMc.visible = false;
            this.FConsumePromptMC.visible = true;
         }
         else
         {
            this.FMaxAwardAreaMc.visible = false;
            this.FPumpkinAreaMc.visible = false;
            this.FShopCartAreaMc.visible = true;
            this.FCandyAreaMc.visible = true;
            this.FConsumePromptMC.visible = true;
         }
      }
      
      protected function BtnBuyMaxAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.ActivityConfig.BuyAwardObj.gold,this.SendBuyMaxAward);
      }
      
      private function SendBuyMaxAward(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.ActivityConfig.BuyAwardObj.index);
      }
      
      protected function BtnAddShopCartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         _loc4_ = new Vector.<int>();
         _loc4_[0] = 1;
         _loc3_ = this.FPumpkinBuyBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.PumpkinDataVec[_loc3_].Index,0,_loc4_);
      }
      
      protected function CandyAddShopCartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         _loc4_ = new Vector.<int>();
         _loc4_[0] = 1;
         _loc3_ = this.FCandyBuyBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.CandyDataVec[_loc3_].Index,0,_loc4_);
      }
      
      protected function BtnFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.ActivityConfig.BuyAwardObj.fightReportAddr);
      }
      
      protected function DeleteOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Vector.<int> = null;
         _loc5_ = new Vector.<int>();
         _loc4_ = this.FData.GetShopCartData();
         _loc3_ = this.FDeleteBtnVec.indexOf(param1 as TUIButton);
         _loc5_[0] = _loc4_[_loc3_].ShopCartAmount * -1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc4_[_loc3_].Index,0,_loc5_);
      }
      
      protected function AddOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Vector.<int> = null;
         _loc5_ = new Vector.<int>();
         _loc5_[0] = 1;
         _loc4_ = this.FData.GetShopCartData();
         _loc3_ = this.FAddBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc4_[_loc3_].Index,0,_loc5_);
      }
      
      protected function MinusOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Vector.<int> = null;
         _loc5_ = new Vector.<int>();
         _loc5_[0] = -1;
         _loc4_ = this.FData.GetShopCartData();
         _loc3_ = this.FMinusBtnVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc4_[_loc3_].Index,0,_loc5_);
      }
      
      protected function ConfirmShopCartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         GoldBuy(this.FData.GlobalShopSpendGold(),function SendBuyMsg():void
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,FData.ActivityConfig.BuyShopIndex);
         });
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FCandyGiftBtnVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FData.CandyDataVec[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
   }
}

