package Processors.Game.Lobby.Activity.HDLaborDay2016.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDLaborDay2016.TLaborConsume;
   import Logics.HDLaborDay2016.VO.TLaborConsumeCondVO;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorLaborConsumeView extends TProcessorHDSingleWindowBase
   {
      
      public static const FlagCount:uint = 5;
      
      public static const ConditionMaxCount:uint = 5;
      
      protected var FData:TLaborConsume;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FConfigFirstArrive:Boolean = true;
      
      protected var FScoreMallBtn:TUIButton;
      
      protected var FRefreshBtn:TUIButton;
      
      protected var FGiftBtnVec:Vector.<TUIButton>;
      
      protected var FSlotVec:Vector.<TUISlot>;
      
      protected var FExchangeBtn:TUIButton;
      
      protected var FShowUI:TShowAwardUI;
      
      protected var FReportBtn:TUIButton;
      
      protected var FBuyBtn:TUIButton;
      
      protected var FGiftInvsVec:Vector.<TInventories>;
      
      protected var FCondVec:Vector.<TLaborConsumeCondVO>;
      
      protected var FSelectIndex:int = -1;
      
      public function TProcessorLaborConsumeView(param1:TUIComponent)
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
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:TUIButton = null;
         var _loc9_:Object = null;
         this.FData = param1 as TLaborConsume;
         if(this.FConfigFirstArrive)
         {
            this.SetupScoreShop();
            this.FConfigFirstArrive = false;
         }
         FScene["TF_Score"].text = this.FData.Score.toString();
         FScene["TF_RefreshCount"].text = Math.max(0,this.FData.Config.FreeTimes - this.FData.RefreshCount);
         _loc2_ = 0;
         while(_loc2_ < FlagCount)
         {
            _loc7_ = FScene["MC_Flag_" + _loc2_];
            _loc8_ = this.FGiftBtnVec[_loc2_];
            _loc6_ = this.FData.GiftInfo[_loc2_];
            _loc5_ = _loc6_ / 100;
            _loc4_ = _loc6_ % 100;
            if(_loc4_ == 1)
            {
               _loc7_.MC_Get.visible = true;
               _loc8_.Enabled = false;
            }
            else
            {
               _loc7_.MC_Get.visible = false;
               _loc8_.Enabled = true;
            }
            _loc3_ = this.FGiftInvsVec[_loc2_];
            _loc3_.Clear();
            _loc9_ = this.GetAwardObjBySeq(_loc5_);
            SToolReward.GetAwardsByAwardID(_loc9_.award,_loc3_);
            this.UpdateCond(_loc2_,_loc9_.condition);
            _loc2_++;
         }
         this.UpdateSlots();
         _loc7_ = FScene["MC_ShowUI"];
         this.FShowUI.SetData(this.FData.Config.Bag.showType,this.FData.Config.Bag.awardId,this.FData.Config.Bag.showID,TOverlayerGiftBox.TYPE_ALL);
         if(this.FData.ShowState == Activity_AlreadyReceive)
         {
            _loc7_.MC_Get.visible = true;
            this.FBuyBtn.Enabled = false;
         }
         else
         {
            _loc7_.MC_Get.visible = false;
            this.FBuyBtn.Enabled = true;
         }
         _loc7_.TF_Cost.text = String(this.FData.Config.Bag.gold);
         this.FReportBtn.Visible = this.FData.Config.Bag.fightReportAddr != "";
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.StoreState);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         for each(_loc1_ in this.FSlotVec)
         {
            _loc1_.Update();
         }
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc4_ = new TInventories();
         for each(_loc1_ in this.FData.Config.Mall)
         {
            _loc2_.push(_loc1_.score);
            _loc3_.push(_loc1_.count == 0);
            SToolReward.GetAwardsByAwardID(_loc1_.awardId,_loc4_);
         }
         this.FScoreExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function GetAwardObjBySeq(param1:int) : Object
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         for each(_loc3_ in this.FData.Config.Banner)
         {
            if(_loc3_.seq == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected function UpdateCond(param1:uint, param2:Array) : void
      {
         var _loc3_:TLaborConsumeCondVO = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         _loc3_ = this.FCondVec[param1];
         _loc3_.CostVec.length = 0;
         _loc3_.TypeVec.length = 0;
         _loc3_.CodeVec.length = 0;
         _loc3_.Invs.Clear();
         for each(_loc4_ in param2)
         {
            for each(_loc5_ in this.FData.Config.Condition)
            {
               if(_loc4_ == _loc5_.id)
               {
                  _loc6_ = int(CONST_COMMON.RewardIDToTemplateID(_loc5_.type,_loc5_.code));
                  SToolReward.GetInventoryByIDAmount(_loc6_,_loc5_.amount,_loc3_.Invs);
                  _loc3_.CostVec.push(_loc5_.gold);
                  _loc3_.TypeVec.push(_loc5_.type);
                  _loc3_.CodeVec.push(_loc5_.code);
               }
            }
         }
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:TLaborConsumeCondVO = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUISlot = null;
         var _loc7_:Number = NaN;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         if(this.FSelectIndex == -1)
         {
            return;
         }
         _loc4_ = this.FCondVec[this.FSelectIndex];
         _loc4_.ReachedVec.length = 0;
         _loc1_ = uint(_loc4_.Invs.Count);
         _loc3_ = 0;
         while(_loc3_ < ConditionMaxCount)
         {
            _loc5_ = FScene["MC_Condition_" + _loc3_];
            _loc6_ = this.FSlotVec[_loc3_];
            if(_loc3_ < _loc1_)
            {
               _loc2_ = _loc4_.Invs.GetInventoryByIndex(_loc3_);
               _loc8_ = _loc4_.TypeVec[_loc3_];
               _loc9_ = _loc4_.CodeVec[_loc3_];
               _loc5_.visible = true;
               _loc6_.Context = _loc2_;
               _loc7_ = 0;
               if(_loc8_ == 0 && _loc9_ == 0)
               {
                  _loc7_ = Number(SLogicsCore.Character.CreditSilverCoin.ToNumber());
               }
               else if(_loc8_ == 0 && _loc9_ == 1)
               {
                  _loc7_ = Number(SLogicsCore.Character.CreditGold);
               }
               else if(_loc8_ == 0 && _loc9_ == 2)
               {
                  _loc7_ = Number(SLogicsCore.Character.CreditGiftCertificate);
               }
               else if(_loc8_ == 3 && _loc9_ == 0)
               {
                  _loc7_ = Number(SLogicsCore.Character.CreditMilitaryOrders);
               }
               else
               {
                  _loc7_ = TUtilityLobby.GetArticleQuantity(_loc2_.IDTemplate,_loc2_.Category);
               }
               if(_loc7_ >= _loc2_.Quantity)
               {
                  _loc5_.TF_Prog.text = this.FData.Config.Language.reached;
                  _loc4_.ReachedVec.push(true);
               }
               else
               {
                  if(_loc8_ == 0 && _loc9_ == 0)
                  {
                     _loc5_.TF_Prog.text = this.GetSilver(_loc7_) + "/" + this.GetSilver(_loc2_.Quantity);
                  }
                  else
                  {
                     _loc5_.TF_Prog.text = _loc7_ + "/" + _loc2_.Quantity;
                  }
                  _loc4_.ReachedVec.push(false);
               }
               _loc5_.TF_Cost.text = _loc4_.CostVec[_loc3_].toString();
            }
            else
            {
               _loc5_.visible = false;
            }
            _loc3_++;
         }
         this.FExchangeBtn.Enabled = this.FData.GiftInfo[this.FSelectIndex] % 100 == 0;
      }
      
      protected function GetSilver(param1:Number) : String
      {
         if(param1 >= 10000)
         {
            return Number(param1 / 10000).toFixed(0) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Thousand);
         }
         return param1.toString();
      }
      
      protected function OnScoreMallBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.Score,this.FData.StoreState);
      }
      
      protected function OnRefreshBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = Math.max(0,this.FData.Config.FreeTimes - this.FData.RefreshCount);
         if(_loc3_ > 0)
         {
            this.OnRefreshBtnClickOK(null);
         }
         else
         {
            GoldBuy(this.FData.Config.RefreshCost,this.OnRefreshBtnClickOK);
         }
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.scoreLack);
         }
      }
      
      protected function OnExchangeBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TLaborConsumeCondVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc3_ = this.FCondVec[this.FSelectIndex];
         _loc6_ = uint(_loc3_.Invs.Count);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(!_loc3_.ReachedVec[_loc5_])
            {
               _loc4_ += _loc3_.CostVec[_loc5_];
            }
            else if(_loc3_.TypeVec[_loc5_] == 0 && _loc3_.CodeVec[_loc5_] == 1)
            {
               _loc4_ += _loc3_.Invs.GetInventoryByIndex(_loc5_).Quantity;
            }
            _loc5_++;
         }
         if(_loc4_ == 0)
         {
            this.OnExchangeBtnClickOK(null);
         }
         else
         {
            GoldBuy(_loc4_,this.OnExchangeBtnClickOK,this.FData.Config.Language.costTip);
         }
      }
      
      protected function OnGiftBtnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FGiftInvsVec[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftBtnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.Bag.fightReportAddr);
      }
      
      protected function OnBuyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Bag.gold,this.OnBuyBtnClickOK);
      }
      
      protected function OnFlagOver(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.Tag);
         if(_loc2_ != this.FSelectIndex)
         {
            FScene["MC_Flag_" + _loc2_].MC_BG.gotoAndStop(2);
         }
      }
      
      protected function OnFlagOut(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.Tag);
         if(_loc2_ != this.FSelectIndex)
         {
            FScene["MC_Flag_" + _loc2_].MC_BG.gotoAndStop(1);
         }
      }
      
      protected function OnFlagClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = uint(param1.currentTarget.Tag);
         if(_loc2_ != this.FSelectIndex)
         {
            if(this.FSelectIndex != -1)
            {
               _loc3_ = FScene["MC_Flag_" + this.FSelectIndex];
               _loc3_.MC_BG.gotoAndStop(1);
               _loc3_.buttonMode = true;
            }
            _loc3_ = FScene["MC_Flag_" + _loc2_];
            _loc3_.MC_BG.gotoAndStop(3);
            _loc3_.buttonMode = false;
            this.FSelectIndex = _loc2_;
            this.FExchangeBtn.Visible = true;
            this.UpdateSlots();
         }
      }
      
      protected function OnRefreshBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Refresh);
      }
      
      protected function OnExchangeBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BannerIndex[this.FSelectIndex]);
      }
      
      protected function OnBuyBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Bag.index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:TUIButton = null;
         var _loc6_:TUISlot = null;
         var _loc7_:TInventories = null;
         var _loc8_:TLaborConsumeCondVO = null;
         super.InitWindow(param1);
         this.FScoreMallBtn = new TUIButton();
         this.FScoreMallBtn.Substrate = FScene["Btn_Mall"];
         this.FScoreMallBtn.OnClick = this.OnScoreMallBtnClick;
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = FScene["Btn_Refresh"];
         this.FRefreshBtn.OnClick = this.OnRefreshBtnClick;
         this.FGiftBtnVec = new Vector.<TUIButton>(FlagCount);
         this.FGiftInvsVec = new Vector.<TInventories>(FlagCount);
         this.FCondVec = new Vector.<TLaborConsumeCondVO>(FlagCount);
         _loc4_ = 0;
         while(_loc4_ < FlagCount)
         {
            _loc2_ = FScene["MC_Flag_" + _loc4_];
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc2_.MC_Gift;
            _loc5_.Tag = _loc4_;
            _loc5_.OnMove = this.OnGiftBtnMove;
            _loc5_.OnOut = this.OnGiftBtnOut;
            this.FGiftBtnVec[_loc4_] = _loc5_;
            _loc7_ = new TInventories();
            this.FGiftInvsVec[_loc4_] = _loc7_;
            _loc8_ = new TLaborConsumeCondVO();
            this.FCondVec[_loc4_] = _loc8_;
            _loc2_.MC_Get.mouseEnabled = false;
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.OnFlagOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.OnFlagOut);
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnFlagClick);
            _loc2_.Tag = _loc4_;
            _loc2_.buttonMode = true;
            _loc4_++;
         }
         this.FSlotVec = new Vector.<TUISlot>(ConditionMaxCount);
         _loc4_ = 0;
         while(_loc4_ < ConditionMaxCount)
         {
            _loc2_ = FScene["MC_Condition_" + _loc4_];
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = _loc2_.MC_Slot;
            _loc6_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc6_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc6_);
            _loc6_.Init();
            this.FSlotVec[_loc4_] = _loc6_;
            _loc2_.visible = false;
            _loc4_++;
         }
         this.FExchangeBtn = new TUIButton();
         this.FExchangeBtn.Substrate = FScene["Btn_Exchange"];
         this.FExchangeBtn.OnClick = this.OnExchangeBtnClick;
         this.FExchangeBtn.Visible = false;
         _loc2_ = FScene["MC_ShowUI"];
         this.FShowUI = new TShowAwardUI(this);
         this.FShowUI.UIDispatch(_loc2_);
         this.FReportBtn = new TUIButton();
         this.FReportBtn.Substrate = _loc2_.Btn_Report;
         this.FReportBtn.OnClick = this.OnReportBtnClick;
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = _loc2_.Btn_Buy;
         this.FBuyBtn.OnClick = this.OnBuyBtnClick;
         _loc2_.MC_Get.mouseEnabled = false;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_LaborDay2016Mall") as MovieClip;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(_loc2_);
      }
   }
}

