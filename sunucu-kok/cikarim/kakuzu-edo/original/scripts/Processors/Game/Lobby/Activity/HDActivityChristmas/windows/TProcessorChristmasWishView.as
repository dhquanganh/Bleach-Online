package Processors.Game.Lobby.Activity.HDActivityChristmas.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDChristmas.TActivityChristmasWishData;
   import Logics.HDChristmas.VO.TBellVo;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.TPlayAnimaEffect;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_CHRISTMAS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class TProcessorChristmasWishView extends TUIComponent
   {
      
      public static const Extract_Count:int = 10;
      
      public static const Extract_One:int = 1;
      
      public static const Gift_Count:int = 5;
      
      public static const DelaySendTime:int = 1000;
      
      private var FMC_Scene:Sprite;
      
      private var FFreeWishValueTF:TextField;
      
      private var FRechargeGoldTF:TextField;
      
      private var FAllServerBellValueTF:TextField;
      
      private var FSelectBoxVec:Vector.<Sprite>;
      
      private var FExtractAwardSlots:Vector.<TUISlot>;
      
      private var FLookRank_Btn:TUIButton;
      
      private var FExchange_Btn:TUIButton;
      
      private var FOneWishBtn:TUIButton;
      
      private var FTenWishBtn:TUIButton;
      
      private var FGiftsList:Vector.<TUIButton>;
      
      private var FGetAwardStateSpVec:Vector.<Sprite>;
      
      private var FGetNeedBellVec:Vector.<TextField>;
      
      private var FGetAwardBtnVec:Vector.<TUIButton>;
      
      protected var FHint:THint;
      
      private var FTurntableEffect:TPlayAnimaEffect;
      
      private var FBellExchangView:TBellExchangeView;
      
      private var FBellRankView:TBellRankView;
      
      private var FDelayTime:uint;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      protected var FData:TActivityChristmasWishData;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FSendData:Function;
      
      protected var FAddMaskLayer:Function;
      
      public function TProcessorChristmasWishView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TUIButton = null;
         this.FHint = new THint();
         this.FFreeWishValueTF = this.FMC_Scene["TF_FreeWishValue"];
         this.FRechargeGoldTF = this.FMC_Scene["TF_Recharge"];
         this.FLookRank_Btn = new TUIButton();
         this.FLookRank_Btn.Substrate = this.FMC_Scene["Btn_LookRank"];
         this.FLookRank_Btn.OnClick = this.OpenRankView;
         this.FExchange_Btn = new TUIButton();
         this.FExchange_Btn.Substrate = this.FMC_Scene["Btn_Excharge"];
         this.FExchange_Btn.OnClick = this.OpenExchangView;
         this.FOneWishBtn = new TUIButton();
         this.FOneWishBtn.Substrate = this.FMC_Scene["MC_Wish"];
         this.FOneWishBtn.OnClick = this.OnOneWishHandler;
         this.FOneWishBtn.OnOut = this.OutHandler;
         this.FOneWishBtn.OnMove = this.OverOneWishHandler;
         this.FTenWishBtn = new TUIButton();
         this.FTenWishBtn.Substrate = this.FMC_Scene["MC_OneKey"];
         this.FTenWishBtn.OnClick = this.OnTenWishHandler;
         this.FTenWishBtn.OnOut = this.OutHandler;
         this.FTenWishBtn.OnMove = this.OverTenWishHandler;
         this.FSelectBoxVec = new Vector.<Sprite>();
         this.FExtractAwardSlots = new Vector.<TUISlot>();
         _loc2_ = Extract_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Slot" + _loc1_];
            this.FSelectBoxVec[_loc1_] = _loc3_["SelectBox"];
            this.FSelectBoxVec[_loc1_].visible = false;
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = _loc3_["Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FExtractAwardSlots[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc2_ = Gift_Count;
         this.FGiftsList = new Vector.<TUIButton>();
         this.FGetAwardBtnVec = new Vector.<TUIButton>();
         this.FGetNeedBellVec = new Vector.<TextField>();
         this.FGetAwardStateSpVec = new Vector.<Sprite>();
         _loc3_ = this.FMC_Scene["MC_Award"];
         this.FAllServerBellValueTF = _loc3_["TF_TotalValue"];
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = new TUIButton();
            _loc4_ = _loc3_["MC_Award" + _loc1_];
            _loc6_.Substrate = _loc4_["MC_Gift"];
            _loc6_.OnMove = this.GiftBagOnMove;
            _loc6_.OnOut = this.GiftBagOnOut;
            this.FGiftsList.push(_loc6_);
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc4_["Btn_GetAward"];
            _loc6_.OnClick = this.OnGetAwardClick;
            this.FGetAwardBtnVec.push(_loc6_);
            this.FGetNeedBellVec.push(_loc4_["TF_NeedBell"]);
            this.FGetAwardStateSpVec.push(_loc4_["MC_Finish"]);
            _loc1_++;
         }
         this.FTurntableEffect = new TPlayAnimaEffect();
         this.FTurntableEffect.SelectVec = this.FSelectBoxVec;
         this.FTurntableEffect.FMix_ax = 4;
         this.FTurntableEffect.Fax = 40;
         this.FTurntableEffect.FMax_ax = 10;
         this.FTurntableEffect.FRotationTurns = 1;
         this.FBellExchangView = new TBellExchangeView(this);
         FParent.addChild(this.FBellExchangView);
         this.FBellRankView = new TBellRankView(this);
         FParent.addChild(this.FBellRankView);
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      private function RenderShowExtractList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FData.ExtractInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.ExtractInventories[_loc1_];
            this.FExtractAwardSlots[_loc1_].Context = null;
            this.FExtractAwardSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      private function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FExtractAwardSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FExtractAwardSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      private function UpdateGift() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBellVo = null;
         _loc2_ = Gift_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.BellAwardList[_loc1_];
            if(_loc3_.GetAwardState == CONST_CHRISTMAS.UnFinish)
            {
               this.FGetAwardBtnVec[_loc1_].Enabled = false;
               this.FGetAwardStateSpVec[_loc1_].visible = false;
            }
            else if(_loc3_.GetAwardState == CONST_CHRISTMAS.Finish)
            {
               this.FGetAwardBtnVec[_loc1_].Enabled = false;
               this.FGetAwardStateSpVec[_loc1_].visible = true;
            }
            else
            {
               this.FGetAwardBtnVec[_loc1_].Enabled = true;
               this.FGetAwardStateSpVec[_loc1_].visible = false;
            }
            this.FGetNeedBellVec[_loc1_].text = _loc3_.NeedBellValue.toString();
            _loc1_++;
         }
      }
      
      private function UpdateBaseInfo() : void
      {
         this.FFreeWishValueTF.text = this.FData.FreeWishValue.toString();
         this.FRechargeGoldTF.text = this.FData.ActivityConfig.RechargeCondition.toString();
         this.FAllServerBellValueTF.text = this.FData.AllServerBellValue.toString();
      }
      
      protected function UpdateUI() : void
      {
         this.RenderShowExtractList();
         this.UpdateGift();
         this.UpdateBaseInfo();
      }
      
      protected function OpenRankView(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.FBellRankView.Data = this.FData;
         this.FBellRankView.Show();
      }
      
      protected function OpenExchangView(param1:Object, param2:MouseEvent) : void
      {
         this.FBellExchangView.Data = this.FData;
         this.FBellExchangView.SendData = this.FSendData;
         this.FBellExchangView.Show();
      }
      
      protected function OnOneWishHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FData.ActivityConfig.OneKeyIndex;
         if(SLogicsCore.Character.CreditGold < this.FData.ActivityConfig.OneGoldCost && this.FData.FreeWishValue <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FTurntableEffect.CurrentState == 0)
         {
            _loc4_ = this.FData.ActivityConfig.OneGoldCost * (1 - this.FData.FreeWishValue);
            if(_loc4_ <= 0)
            {
               this.startPlayAnima(_loc3_);
            }
            else
            {
               this.WindowUIPopUp.visible = true;
               this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc4_);
               this.WindowUIPopUp.OnOK = this.WindowOk;
               this.WindowUIPopUp.Tag = _loc3_;
            }
         }
      }
      
      private function WindowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         this.startPlayAnima(_loc2_);
      }
      
      private function WindowTenOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         this.SendServiceData(_loc2_);
         this.FTurntableEffect.ClearSelectBox();
      }
      
      private function startPlayAnima(param1:int) : void
      {
         var Index:int = param1;
         if(this.FAddMaskLayer != null)
         {
            this.FAddMaskLayer(false);
         }
         this.FDelayTime = setTimeout(function DelaySendFun():void
         {
            SendServiceData(Index);
            FAddMaskLayer(true);
            clearTimeout(FDelayTime);
         },DelaySendTime);
         this.FTurntableEffect.startPlay();
      }
      
      private function OnTenWishHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FData.ActivityConfig.TenKeyIndex;
         _loc4_ = this.FData.ActivityConfig.OneGoldCost * (Extract_Count - this.FData.FreeWishValue);
         _loc4_ = _loc4_ <= 0 ? 0 : _loc4_;
         if(SLogicsCore.Character.CreditGold < _loc4_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FTurntableEffect.CurrentState == 0)
         {
            this.WindowUIPopUp.visible = true;
            this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc4_);
            this.WindowUIPopUp.OnOK = this.WindowTenOk;
            this.WindowUIPopUp.Tag = _loc3_;
         }
      }
      
      private function OnGetAwardClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGetAwardBtnVec.indexOf(param1);
         this.SendServiceData(this.FData.ActivityConfig.AllServerIndexVec[_loc3_]);
      }
      
      protected function OverTenWishHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FData.ActivityConfig.OneGoldCost * (Extract_Count - this.FData.FreeWishValue);
         _loc3_ = _loc3_ <= 0 ? 0 : _loc3_;
         _loc4_ = TUtilityString.Format(this.FData.ActivityConfig.OneKeyPrompt,_loc3_);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OverOneWishHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FData.ActivityConfig.OneGoldCost * (Extract_One - this.FData.FreeWishValue);
         _loc3_ = _loc3_ <= 0 ? 0 : _loc3_;
         _loc4_ = TUtilityString.Format(this.FData.ActivityConfig.OneWishPrompt,_loc3_);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OutHandler(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftsList.indexOf(param1);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FData.BellAwardList[_loc3_].Inventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      public function get Data() : TActivityChristmasWishData
      {
         return this.FData;
      }
      
      public function set Data(param1:TActivityChristmasWishData) : void
      {
         this.FData = param1;
      }
      
      public function get GiftMoveFun() : Function
      {
         return this.FGiftMoveFun;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function get GiftOutFun() : Function
      {
         return this.FGiftOutFun;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function get AddMaskLayer() : Function
      {
         return this.FAddMaskLayer;
      }
      
      public function set AddMaskLayer(param1:Function) : void
      {
         this.FAddMaskLayer = param1;
      }
      
      public function ShowView(param1:Boolean) : void
      {
         this.UpdateUI();
         if(this.FBellExchangView != null && this.FBellExchangView.visible)
         {
            this.FBellExchangView.Data = this.FData;
            this.FBellExchangView.RefreshView();
         }
         if(this.FBellRankView != null && this.FBellRankView.visible)
         {
            this.FBellRankView.Data = this.FData;
            this.FBellRankView.RefreshView();
         }
         if(param1)
         {
            this.OpenExchangView(null,null);
         }
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdateExtractSlots();
            this.FBellExchangView.LogicsPerform_EnterFrame();
            this.FBellRankView.LogicsPerform_EnterFrame();
            this.FTurntableEffect.update();
         }
      }
      
      public function StopAnima(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 != this.FData.ActivityConfig.OneKeyIndex)
         {
            return;
         }
         this.FTurntableEffect.FindRewardPos(this.FData.TurntablePos);
      }
   }
}

