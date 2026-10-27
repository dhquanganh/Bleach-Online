package Processors.Game.Lobby.Activity.HDGhostKingForg.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGhostKingForg.TGhostKingForgData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDGiftScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorGhostKingForgView extends TProcessorHDSingleWindowBase
   {
      
      protected const SlotCount:uint = 6;
      
      protected const GradeCount:uint = 5;
      
      protected var FData:TGhostKingForgData;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FReportBtn:TUIButton;
      
      protected var FBuyBtn:TUIButton;
      
      protected var FForg0Btn:TUIButton;
      
      protected var FForg1Btn:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FReceiveBtn:TUIButton;
      
      protected var FReceive10Btn:TUIButton;
      
      protected var FShopBtn:TUIButton;
      
      protected var FForgGifts:Vector.<TUIButton>;
      
      protected var FSelectIndex:int = -1;
      
      protected var FConfigFirstArrive:Boolean = true;
      
      protected var FForgGiftInvs:Vector.<TInventories>;
      
      protected var FLastForgPower:uint;
      
      protected var FGradeUnitHeight:Number;
      
      protected var FScoreExchangeShop:THDGiftScoreExchangeShop;
      
      public function TProcessorGhostKingForgView(param1:TUIComponent)
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
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:TUISlot = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         this.FData = param1 as TGhostKingForgData;
         if(this.FConfigFirstArrive)
         {
            this.ConfigFirst();
            this.FConfigFirstArrive = false;
         }
         _loc2_ = FScene["MC_ShowUI"];
         this.FShowAwardUI.SetData(this.FData.Config.BigAward.showType,this.FData.Config.BigAward.awardId,this.FData.Config.BigAward.showID,TOverlayerGiftBox.TYPE_ALL);
         this.FReportBtn.Visible = this.FData.Config.BigAward.fightReportAddr != "";
         _loc2_.TF_Score.text = String(this.FData.Config.BigAward.gold);
         if(this.FData.ShowUIState == Activity_AlreadyReceive)
         {
            this.FBuyBtn.Enabled = false;
            _loc2_.MC_Get.visible = true;
         }
         else
         {
            _loc2_.MC_Get.visible = false;
            this.FBuyBtn.Enabled = true;
         }
         _loc2_ = FScene["MC_Knife"];
         _loc5_ = this.FData.Config.ForgingAward.award;
         _loc8_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.GradeCount)
         {
            _loc6_ = _loc5_[_loc3_];
            _loc4_ = this.FForgGifts[_loc3_];
            _loc2_ = FScene["TF_ForgReward_" + _loc3_];
            _loc2_.TF_ForgReturn.text = _loc6_.discount + "%";
            _loc2_.TF_ForgNeed.text = String(_loc6_.score);
            if(this.FData.ForgPower >= _loc6_.score)
            {
               _loc8_ = int(_loc6_.discount);
               _loc4_.Enabled = true;
            }
            else
            {
               _loc4_.Enabled = false;
            }
            if(TUtilityTool.GetValueByBit(this.FData.ForgGiftState,_loc3_) == 1)
            {
               _loc4_.Enabled = false;
               _loc2_.MC_Get.visible = true;
            }
            else
            {
               _loc4_.Enabled = this.FData.ForgPower >= _loc6_.score;
               _loc2_.MC_Get.visible = false;
            }
            _loc3_++;
         }
         FScene["TF_ForgRate"].text = this.FData.ForgPower + "/" + this.FData.Config.ForgingMax;
         _loc9_ = this.FData.Config.ForgingMax - this.FData.ForgPower;
         this.FForg0Btn.Enabled = _loc9_ >= this.FData.Config.Forging.cost;
         this.FForg1Btn.Enabled = _loc9_ >= this.FData.Config.Forging.cost * 10;
         FScene["TF_Recharge"].text = String(this.FData.TotalRecharge);
         FScene["TF_SelectNeed"].text = String(this.FData.Config.AdditionalAward.gold);
         FScene["TF_Select"].text = String(this.FData.CanSelectCount);
         this.CheckReceiveBtnEnabled();
         FScene["TF_Power"].text = String(this.FData.TotalGhostKingPower);
         FScene["TF_ReturnRatio"].text = _loc8_ + "%";
         FScene["TF_Return"].text = String(Math.floor(this.FData.TotalRecharge * (_loc8_ / 100)));
         this.FScoreExchangeShop.Update(this.FData.TotalGhostKingPower,this.FData.ScoreItemStates);
         if(this.FData.ForgPower != this.FLastForgPower)
         {
            _loc3_ = 0;
            while(_loc3_ < this.GradeCount)
            {
               _loc6_ = _loc5_[_loc3_];
               if(_loc6_.score > this.FLastForgPower && _loc6_.score <= this.FData.ForgPower)
               {
                  FScene["MC_Effect_" + _loc3_].play();
               }
               _loc3_++;
            }
            this.UpdateForgScaleAll();
            if(this.FData.ForgPower >= this.FData.Config.ForgingMax)
            {
               _loc2_ = FScene["MC_Knife"];
               _loc2_.MC_SuperEffect1.gotoAndPlay(2);
               _loc2_.MC_SuperEffect2.gotoAndPlay(2);
            }
            this.FLastForgPower = this.FData.ForgPower;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         for each(_loc1_ in this.FSlots)
         {
            _loc1_.Update();
         }
      }
      
      protected function ConfigFirst() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:TInventories = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         this.SetupScoreShop();
         _loc1_ = 0;
         while(_loc1_ < this.SlotCount)
         {
            _loc2_ = this.FSlots[_loc1_];
            _loc3_ = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FData.Config.AdditionalItems[_loc1_],_loc3_);
            _loc2_.Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
         this.FForgGiftInvs = new Vector.<TInventories>();
         _loc4_ = this.FData.Config.ForgingAward.award;
         _loc1_ = 0;
         while(_loc1_ < this.GradeCount)
         {
            _loc5_ = _loc4_[_loc1_];
            _loc3_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc5_.awardId,_loc3_);
            this.FForgGiftInvs[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FLastForgPower = 0;
         this.UpdateForgScaleAll();
         this.FLastForgPower = this.FData.ForgPower;
         if(this.FData.ForgPower >= this.FData.Config.ForgingMax)
         {
            FScene["MC_Knife"].MC_SuperEffect2.gotoAndPlay("loop");
         }
      }
      
      protected function UpdateForgScaleAll() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         if(this.FData.ForgPower >= this.FData.Config.ForgingMax)
         {
            FScene["MC_Knife"].MC_Mask.height = this.FGradeUnitHeight * this.GradeCount;
            return;
         }
         _loc3_ = this.FData.Config.ForgingAward.award;
         _loc6_ = this.FLastForgPower;
         _loc1_ = 0;
         while(_loc1_ < this.GradeCount)
         {
            _loc4_ = _loc3_[_loc1_];
            _loc5_ = _loc1_ == 0 ? null : _loc3_[_loc1_ - 1];
            if(_loc6_ < _loc4_.score)
            {
               if(_loc5_ == null || this.FData.ForgPower > _loc5_.score)
               {
                  _loc7_ = Math.min(_loc4_.score,this.FData.ForgPower);
                  _loc8_ = _loc7_ - _loc6_;
                  _loc6_ = uint(_loc4_.score);
                  _loc2_ = _loc5_ == null ? uint(_loc4_.score) : uint(_loc4_.score - _loc5_.score);
                  this.UpdateForgScale(_loc2_,_loc8_);
               }
            }
            _loc1_++;
         }
      }
      
      protected function UpdateForgScale(param1:uint, param2:uint) : void
      {
         FScene["MC_Knife"].MC_Mask.height += param2 / param1 * this.FGradeUnitHeight;
      }
      
      protected function CheckReceiveBtnEnabled() : void
      {
         if(this.FData.CanSelectCount == 0)
         {
            this.FReceiveBtn.Enabled = false;
         }
         else
         {
            this.FReceiveBtn.Enabled = this.FSelectIndex != -1;
         }
         if(this.FData.CanSelectCount < 10)
         {
            this.FReceive10Btn.Enabled = false;
         }
         else
         {
            this.FReceive10Btn.Enabled = this.FSelectIndex != -1;
         }
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         var _loc5_:Vector.<TInventories> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc5_ = new Vector.<TInventories>();
         for each(_loc1_ in this.FData.Config.ScoreShop)
         {
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
            _loc4_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc1_.awardId,_loc4_);
            _loc5_.push(_loc4_);
         }
         this.FScoreExchangeShop.SetupBasicInfo(_loc5_,_loc2_,_loc3_);
      }
      
      protected function OnScoreShopBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.TotalGhostKingPower,this.FData.ScoreItemStates);
      }
      
      protected function OnReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigAward.fightReportAddr);
      }
      
      protected function OnBuyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.BigAward.gold,this.OnBuyBtnClickOK);
      }
      
      protected function OnForg0BtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.TotalGhostKingPower >= this.FData.Config.Forging.cost)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Forging.index,0,Vector.<int>([1]));
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.powerLack);
         }
      }
      
      protected function OnForg1BtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.TotalGhostKingPower >= this.FData.Config.Forging.cost * 10)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Forging.index,0,Vector.<int>([10]));
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.powerLack);
         }
      }
      
      protected function OnReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.AdditionalAward.index,0,Vector.<int>([this.FData.Config.AdditionalItems[this.FSelectIndex],1]));
      }
      
      protected function OnReceive10BtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.AdditionalAward.index,0,Vector.<int>([this.FData.Config.AdditionalItems[this.FSelectIndex],10]));
      }
      
      protected function OnForgGiftBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ForgingAward.index,0,Vector.<int>([param1.Tag]));
      }
      
      protected function OnForgGiftBtnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FForgGiftInvs[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnForgGiftBtnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnForg0BtnMove(param1:Object, param2:MouseEvent) : void
      {
         FHint.Caption = TUtilityString.Format(this.FData.Config.Language.forgNeed,this.FData.Config.Forging.cost);
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function OnForg0BtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function OnForg1BtnMove(param1:Object, param2:MouseEvent) : void
      {
         FHint.Caption = TUtilityString.Format(this.FData.Config.Language.forgNeed,this.FData.Config.Forging.cost * 10);
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function OnForg1BtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function OnSlotClick(param1:Object, param2:Object) : void
      {
         var _loc3_:MovieClip = null;
         if(this.FSelectIndex != -1)
         {
            _loc3_ = FScene["MC_Slot_" + this.FSelectIndex];
            _loc3_.MC_Select.visible = false;
         }
         this.FSelectIndex = param1.Tag;
         _loc3_ = FScene["MC_Slot_" + this.FSelectIndex];
         _loc3_.MC_Select.visible = true;
         this.CheckReceiveBtnEnabled();
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.ScoreShop[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.TotalGhostKingPower >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.powerLack);
         }
      }
      
      protected function OnBuyBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BigAward.index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         var _loc5_:uint = 0;
         var _loc6_:TUIButton = null;
         super.InitWindow(param1);
         _loc3_ = FScene["MC_ShowUI"];
         this.FReportBtn = new TUIButton();
         this.FReportBtn.Substrate = _loc3_.Btn_FightReport;
         this.FReportBtn.OnClick = this.OnReportBtnClick;
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = _loc3_.Btn_Get;
         this.FBuyBtn.OnClick = this.OnBuyBtnClick;
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(_loc3_);
         _loc3_.MC_Get.mouseChildren = _loc3_.MC_Get.mouseEnabled = false;
         this.FForg0Btn = new TUIButton();
         this.FForg0Btn.Substrate = FScene["Btn_Forg0"];
         this.FForg0Btn.OnClick = this.OnForg0BtnClick;
         this.FForg0Btn.OnMove = this.OnForg0BtnMove;
         this.FForg0Btn.OnOut = this.OnForg0BtnOut;
         this.FForg1Btn = new TUIButton();
         this.FForg1Btn.Substrate = FScene["Btn_Forg1"];
         this.FForg1Btn.OnClick = this.OnForg1BtnClick;
         this.FForg1Btn.OnMove = this.OnForg1BtnMove;
         this.FForg1Btn.OnOut = this.OnForg1BtnOut;
         this.FSlots = new Vector.<TUISlot>();
         _loc5_ = 0;
         while(_loc5_ < this.SlotCount)
         {
            _loc3_ = FScene["MC_Slot_" + _loc5_];
            _loc4_ = new TUISlot(this);
            _loc4_.Tag = _loc5_;
            _loc4_.Resource = _loc3_;
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnClick = this.OnSlotClick;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FSlots[_loc5_] = _loc4_;
            _loc3_.buttonMode = true;
            _loc3_.MC_Select.visible = false;
            _loc5_++;
         }
         this.FReceiveBtn = new TUIButton();
         this.FReceiveBtn.Substrate = FScene["Btn_Receive"];
         this.FReceiveBtn.OnClick = this.OnReceiveBtnClick;
         this.FReceive10Btn = new TUIButton();
         this.FReceive10Btn.Substrate = FScene["Btn_Receive10"];
         this.FReceive10Btn.OnClick = this.OnReceive10BtnClick;
         this.FShopBtn = new TUIButton();
         this.FShopBtn.Substrate = FScene["Btn_Shop"];
         this.FShopBtn.OnClick = this.OnScoreShopBtnClick;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_GhostKingForgShop") as MovieClip;
         this.FScoreExchangeShop = new THDGiftScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(_loc2_);
         this.FForgGifts = new Vector.<TUIButton>();
         _loc5_ = 0;
         while(_loc5_ < this.GradeCount)
         {
            _loc3_ = FScene["TF_ForgReward_" + _loc5_];
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc3_.Btn_Gift;
            _loc6_.Tag = _loc5_;
            _loc6_.OnClick = this.OnForgGiftBtnClick;
            _loc6_.OnMove = this.OnForgGiftBtnMove;
            _loc6_.OnOut = this.OnForgGiftBtnOut;
            this.FForgGifts[_loc5_] = _loc6_;
            _loc3_.MC_Get.mouseChildren = _loc3_.MC_Get.mouseEnabled = false;
            _loc5_++;
         }
         _loc3_ = FScene["MC_Knife"];
         _loc3_.MC_Light.gotoAndPlay(1);
         this.FGradeUnitHeight = _loc3_.MC_Mask.height / this.GradeCount;
         _loc3_.MC_Mask.height = 0;
      }
   }
}

