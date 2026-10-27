package Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDSheepGoodSell;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.THDSheepGoodSellData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowSheepGoodSell extends TProcessorHDSingleWindowBase
   {
      
      protected static const TabNum:int = 6;
      
      protected static const GoodsNum:int = 9;
      
      protected static const FreeAwardBuyIndex:int = 31;
      
      protected static const AllGoodsBuyedFlag:int = 511;
      
      protected var FUITab:TUITab;
      
      protected var FBuyGoodsUI:Sprite;
      
      protected var FBtnBuys:Vector.<TUIButton>;
      
      protected var FUIGoods:Vector.<TUIButton>;
      
      protected var FBuyFlags:Vector.<Sprite>;
      
      protected var FTFCosts:Vector.<TextField>;
      
      protected var FLoadingGiftBag:TUIButton;
      
      protected var FLoadingReciveFlag:Sprite;
      
      protected var FLoadingReciveBtn:TUIButton;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FFreeAwardReciveBtn:TUIButton;
      
      protected var FFreeAwardReciveFlag:Sprite;
      
      protected var FFreeAwardBtnFightReport:TUIButton;
      
      protected var FFinalAwardUI:Sprite;
      
      protected var FFinalShowAwardUI:TShowAwardUI;
      
      protected var FFinalTFGoodsNum:TextField;
      
      protected var FFinalAwardReciveBtn:TUIButton;
      
      protected var FFinalAwardReciveFlag:Sprite;
      
      protected var FFinalAwardBtnFightReport:TUIButton;
      
      protected var FCurrentSelectTab:int;
      
      protected var FHDSheepGoodSell:THDSheepGoodSell;
      
      protected var FHDSheepGoodSellData:THDSheepGoodSellData;
      
      public function TProcessorHDWindowSheepGoodSell(param1:TUIComponent)
      {
         super(param1);
         this.FCurrentSelectTab = -1;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDSheepGoodSell = FHDActivityConfig as THDSheepGoodSell;
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
         super.InitWindow(param1);
         this.FFinalAwardUI = param1["FinalAward"];
         this.FFinalShowAwardUI = new TShowAwardUI(this);
         this.FFinalShowAwardUI.UIDispatch(this.FFinalAwardUI["ShowAward"]);
         this.FFinalTFGoodsNum = this.FFinalAwardUI["GoodsNum"];
         this.FFinalAwardReciveFlag = this.FFinalAwardUI["MC_Get"];
         this.FFinalAwardBtnFightReport = new TUIButton();
         this.FFinalAwardBtnFightReport.Substrate = this.FFinalAwardUI["BtnFightReport"];
         this.FFinalAwardBtnFightReport.OnClick = this.BtnFinalFightReportOnClick;
         this.FFinalAwardReciveBtn = new TUIButton();
         this.FFinalAwardReciveBtn.Substrate = this.FFinalAwardUI["BtnRecive"];
         this.FFinalAwardReciveBtn.OnClick = this.BtnFinalAwardReciveOnClick;
         this.FBuyGoodsUI = param1["GoodsSell"];
         this.FUITab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < TabNum)
         {
            this.FUITab.SetTabByIndex(param1["Tab" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.OnTabSwitch;
         this.FUITab.Init();
         this.FBtnBuys = new Vector.<TUIButton>();
         this.FUIGoods = new Vector.<TUIButton>();
         this.FBuyFlags = new Vector.<Sprite>();
         this.FTFCosts = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < GoodsNum)
         {
            _loc4_ = this.FBuyGoodsUI["Goods" + _loc2_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["Gift"];
            _loc3_.OnMove = this.GiftBoxOnMove;
            _loc3_.OnOut = this.BoxOnOut;
            this.FUIGoods.push(_loc3_);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_["Btn_Buy"];
            _loc3_.OnClick = this.BtnBuyOnClick;
            this.FBtnBuys.push(_loc3_);
            this.FBuyFlags.push(_loc4_["MC_BuyFlag"]);
            this.FTFCosts.push(_loc4_["TF_Cost"]);
            _loc2_++;
         }
         this.FLoadingGiftBag = new TUIButton();
         this.FLoadingGiftBag.Substrate = this.FBuyGoodsUI["LoadingMoudle"]["MC_Box"];
         this.FLoadingGiftBag.OnMove = this.LoadingBoxOnMove;
         this.FLoadingGiftBag.OnOut = this.BoxOnOut;
         this.FLoadingReciveFlag = this.FBuyGoodsUI["LoadingMoudle"]["MC_ReciveFlag"];
         this.FLoadingReciveBtn = new TUIButton();
         this.FLoadingReciveBtn.Substrate = this.FBuyGoodsUI["LoadingMoudle"]["Btn_BoxBtn"];
         this.FLoadingReciveBtn.OnClick = this.BtnLoadingReciveOnClick;
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(this.FBuyGoodsUI["ShowAward"]);
         this.FFreeAwardReciveBtn = new TUIButton();
         this.FFreeAwardReciveBtn.Substrate = this.FBuyGoodsUI["BtnRecive"];
         this.FFreeAwardReciveBtn.OnClick = this.BtnFreeAwardReciveOnClick;
         this.FFreeAwardReciveFlag = this.FBuyGoodsUI["MC_Get"];
         this.FFreeAwardBtnFightReport = new TUIButton();
         this.FFreeAwardBtnFightReport.Substrate = this.FBuyGoodsUI["BtnFightReport"];
         this.FFreeAwardBtnFightReport.OnClick = this.BtnFreeFightReportOnClick;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FHDSheepGoodSellData = param1 as THDSheepGoodSellData;
         this.RenderTabs();
         this.RenderDailyAward();
         if(this.FCurrentSelectTab == -1)
         {
            this.FCurrentSelectTab = this.FHDSheepGoodSellData.ActivityNum;
         }
         this.FUITab.SwithTagManual(this.FCurrentSelectTab);
      }
      
      protected function RenderTabs() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < TabNum)
         {
            this.FUITab.SetTabEnabledByIndex(_loc1_,_loc1_ <= this.FHDSheepGoodSellData.ActivityNum + 1);
            _loc1_++;
         }
      }
      
      protected function RenderGoodSell() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Boolean = false;
         _loc3_ = this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardGold[this.FCurrentSelectTab];
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFCosts[_loc1_].text = _loc3_[_loc1_].toString();
            _loc4_ = (this.FHDSheepGoodSellData.ActAwardBuyFlag[this.FCurrentSelectTab] & 1 << _loc1_) != 0;
            if(this.FCurrentSelectTab > this.FHDSheepGoodSellData.ActivityNum)
            {
               this.FBtnBuys[_loc1_].Visible = false;
               this.FBuyFlags[_loc1_].visible = false;
            }
            else
            {
               this.FBtnBuys[_loc1_].Visible = !_loc4_;
               this.FBuyFlags[_loc1_].visible = _loc4_;
            }
            _loc1_++;
         }
      }
      
      protected function RenderDailyAward() : void
      {
         if(this.FCurrentSelectTab != this.FHDSheepGoodSellData.ActivityNum)
         {
            this.FLoadingReciveBtn.Visible = false;
            this.FLoadingReciveFlag.visible = false;
            this.FLoadingGiftBag.Enabled = false;
         }
         else
         {
            this.FLoadingGiftBag.Enabled = true;
            this.FLoadingReciveBtn.Visible = !this.FHDSheepGoodSellData.LoadingAwardReciveFlag;
            this.FLoadingReciveFlag.visible = this.FHDSheepGoodSellData.LoadingAwardReciveFlag;
         }
      }
      
      protected function RenderFreeAward() : void
      {
         var _loc1_:Boolean = false;
         this.FShowAwardUI.SetData(this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardFreeAwardType[this.FCurrentSelectTab],this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardFreeAwardID[this.FCurrentSelectTab],this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardFreeAwardShowID[this.FCurrentSelectTab],TOverlayerGiftBox.TYPE_ALL);
         _loc1_ = (this.FHDSheepGoodSellData.ActAwardBuyFlag[this.FCurrentSelectTab] & 1 << 31) != 0;
         this.FFreeAwardReciveBtn.Enabled = (this.FHDSheepGoodSellData.ActAwardBuyFlag[this.FCurrentSelectTab] & AllGoodsBuyedFlag) == AllGoodsBuyedFlag;
         this.FFreeAwardReciveBtn.Visible = !_loc1_;
         this.FFreeAwardReciveFlag.visible = _loc1_;
         this.FFreeAwardBtnFightReport.Visible = this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardFreeAwarFightReportAddr[this.FCurrentSelectTab] != "";
      }
      
      protected function RenderFinalAward() : void
      {
         this.FFinalTFGoodsNum.text = this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardCostNeed.toString();
         this.FFinalShowAwardUI.SetData(this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardAwardType,this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardAwardID,this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardShowID,TOverlayerGiftBox.TYPE_ALL);
         this.FFinalAwardReciveBtn.Enabled = this.CurrentBuyedNum() >= this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardCostNeed;
         this.FFinalAwardReciveBtn.Visible = !this.FHDSheepGoodSellData.FinalAwardReciveFlag;
         this.FFinalAwardReciveFlag.visible = this.FHDSheepGoodSellData.FinalAwardReciveFlag;
         this.FFinalAwardBtnFightReport.Visible = this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardFightReportAddr != "";
      }
      
      protected function CurrentBuyedNum() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = 0;
         _loc3_ = int(this.FHDSheepGoodSellData.ActAwardBuyFlag.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = int(this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardAward[_loc2_].length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if((this.FHDSheepGoodSellData.ActAwardBuyFlag[_loc2_] & 1 << _loc4_) != 0)
               {
                  _loc1_++;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function BuyGoodsReq(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardIndex[this.FCurrentSelectTab],0,Vector.<int>([SUtilityOverLayer.UIWindowConfirmation.Tag]));
      }
      
      protected function OnTabSwitch(param1:int) : void
      {
         this.FCurrentSelectTab = param1;
         if(param1 < TabNum - 1)
         {
            this.FBuyGoodsUI.visible = true;
            this.FFinalAwardUI.visible = false;
            this.RenderGoodSell();
            this.RenderFreeAward();
            this.RenderDailyAward();
         }
         else
         {
            this.FBuyGoodsUI.visible = false;
            this.FFinalAwardUI.visible = true;
            this.RenderFinalAward();
         }
         FScene.addChild(this.FUITab.GetTabByIndex(param1));
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnBuys.indexOf(param1 as TUIButton);
         SUtilityOverLayer.UIWindowConfirmation.Tag = _loc3_;
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardGold[this.FCurrentSelectTab][_loc3_]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnLoadingReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSheepGoodSellData.SheepGoodSellVO.LoadingAwardIndex);
      }
      
      protected function BtnFreeAwardReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardIndex[this.FCurrentSelectTab],0,Vector.<int>([FreeAwardBuyIndex]));
      }
      
      protected function BtnFreeFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FHDSheepGoodSellData.SheepGoodSellVO.ActAwardFreeAwarFightReportAddr[this.FCurrentSelectTab]);
      }
      
      protected function BtnFinalFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardFightReportAddr);
      }
      
      protected function BtnFinalAwardReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHDSheepGoodSellData.SheepGoodSellVO.FinalAwardIndex);
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FUIGoods.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FHDSheepGoodSellData.ActAwards[this.FCurrentSelectTab][_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function LoadingBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FHDSheepGoodSellData.LoadingAwards[this.FCurrentSelectTab],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
   }
}

