package Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.TActivitySheepRedPacketData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_SheepRedPacket;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowSheepRedPacket extends TProcessorHDSingleWindowBase
   {
      
      private const Props_Count:int = 6;
      
      private const Person_Count:int = 6;
      
      private const Gift_Count:int = 6;
      
      private var FData:TActivitySheepRedPacketData;
      
      private var FExchangeBtn:TUIButton;
      
      private var FMyFavournValueTF:TextField;
      
      private var FShowSlots:Vector.<TUISlot>;
      
      private var FPersonSlots:Vector.<TUISlot>;
      
      private var FReceiveRedPacketVec:Vector.<MovieClip>;
      
      private var FEffectVec:Vector.<MovieClip>;
      
      private var FGetShowEffectVec:Vector.<MovieClip>;
      
      private var FSendRedPacketBtn:TUIButton;
      
      private var FResetBtn:TUIButton;
      
      private var FPacketFreeTimeTF:TextField;
      
      private var FResetFreeTimeTF:TextField;
      
      private var FServiceFavournValueTF:TextField;
      
      private var FGiftAwardVec:Vector.<TUIButton>;
      
      private var FGiftConditionVec:Vector.<TextField>;
      
      private var FGiftGetAwardStateVec:Vector.<Sprite>;
      
      private var FGetGiftBtnVec:Vector.<TUIButton>;
      
      private var WindowUIPopUp:TUIWindowConfirmation;
      
      private var FFavourExchangeView:TFavourExchangeView;
      
      private var FCurPlayEffect:MovieClip;
      
      public function TProcessorHDWindowSheepRedPacket(param1:TUIComponent)
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
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.RenderShowPorpList();
         this.RenderPersonPorpList();
         this.UpdateBaseInfo();
         if(this.FFavourExchangeView != null && this.FFavourExchangeView.visible)
         {
            this.FFavourExchangeView.Data = this.FData;
            this.FFavourExchangeView.RefreshView();
         }
      }
      
      private function InitPropItemsResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         _loc2_ = this.Props_Count;
         this.FShowSlots = new Vector.<TUISlot>();
         _loc4_ = FScene["MC_RareItems"];
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_["Item" + _loc1_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc5_;
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FShowSlots[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FMyFavournValueTF = FScene["TF_FavourValue"];
         this.FExchangeBtn = new TUIButton();
         this.FExchangeBtn.Substrate = FScene["Btn_OpenExchangPanel"];
         this.FExchangeBtn.OnClick = this.OnOpenMallPanel;
      }
      
      private function InitGiftResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TUIButton = null;
         var _loc5_:Sprite = null;
         var _loc6_:TextField = null;
         var _loc7_:Sprite = null;
         _loc2_ = this.Gift_Count;
         this.FGiftAwardVec = new Vector.<TUIButton>();
         this.FGetGiftBtnVec = new Vector.<TUIButton>();
         this.FGiftConditionVec = new Vector.<TextField>();
         this.FGiftGetAwardStateVec = new Vector.<Sprite>();
         _loc5_ = FScene["MC_AllService"];
         this.FServiceFavournValueTF = _loc5_["TF_TotalFavourn"];
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc5_["Gift_" + _loc1_]["MC_Gift"];
            _loc3_.OnOut = this.GiftBagOnOut;
            _loc3_.OnMove = this.GiftBagOnMove;
            this.FGiftAwardVec[_loc1_] = _loc3_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc5_["Gift_" + _loc1_]["Btn_GetAward"];
            _loc4_.OnClick = this.OnGetAwardClick;
            this.FGetGiftBtnVec[_loc1_] = _loc4_;
            _loc6_ = _loc5_["Gift_" + _loc1_]["TF_NeedValue"];
            this.FGiftConditionVec[_loc1_] = _loc6_;
            _loc7_ = _loc5_["Gift_" + _loc1_]["MC_Already"];
            this.FGiftGetAwardStateVec[_loc1_] = _loc7_;
            _loc1_++;
         }
      }
      
      private function InitPersonResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         var _loc5_:MovieClip = null;
         _loc3_ = FScene["MC_Persons"];
         _loc2_ = this.Person_Count;
         this.FSendRedPacketBtn = new TUIButton();
         this.FSendRedPacketBtn.Substrate = _loc3_["Btn_SendPacket"];
         this.FSendRedPacketBtn.OnClick = this.OnSendPacketClick;
         this.FSendRedPacketBtn.OnMove = this.OverTipsShowHandler;
         this.FSendRedPacketBtn.OnOut = this.OutTipsHideHandler;
         this.FResetBtn = new TUIButton();
         this.FResetBtn.Substrate = _loc3_["Btn_Reset"];
         this.FResetBtn.OnMove = this.OverResetTipsShowHandler;
         this.FResetBtn.OnOut = this.OutTipsHideHandler;
         this.FResetBtn.OnClick = this.OnResetClick;
         this.FPacketFreeTimeTF = _loc3_["TF_PacketFreeTime"];
         this.FResetFreeTimeTF = _loc3_["TF_ResetFreeTime"];
         this.FPersonSlots = new Vector.<TUISlot>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["Slot_" + _loc1_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FPersonSlots[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FReceiveRedPacketVec = new Vector.<MovieClip>();
         this.FEffectVec = new Vector.<MovieClip>();
         this.FGetShowEffectVec = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc3_["MC_SendState_" + _loc1_];
            this.FReceiveRedPacketVec[_loc1_] = _loc5_;
            _loc5_ = _loc3_["MC_Effect_" + _loc1_];
            _loc5_.visible = false;
            this.FEffectVec[_loc1_] = _loc5_;
            _loc5_ = _loc3_["MC_GetShowEffect_" + _loc1_];
            if(_loc5_ != null)
            {
               _loc5_.visible = false;
            }
            this.FGetShowEffectVec[_loc1_] = _loc5_;
            _loc1_++;
         }
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
      
      private function RenderShowPorpList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FData.ShowInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.ShowInventories[_loc1_];
            this.FShowSlots[_loc1_].Context = null;
            this.FShowSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      private function RenderPersonPorpList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FData.PersonAwardVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.PersonAwardVec[_loc1_].Inventories;
            this.FPersonSlots[_loc1_].Context = null;
            this.FPersonSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.UpdatePropSlots(this.FShowSlots);
            this.UpdatePropSlots(this.FPersonSlots);
            if(this.FCurPlayEffect != null)
            {
               if(this.FCurPlayEffect.currentFrame >= this.FCurPlayEffect.totalFrames)
               {
                  this.FCurPlayEffect.gotoAndStop(1);
                  this.FCurPlayEffect.visible = false;
               }
            }
         }
         else if(this.FData != null)
         {
            this.FData.GetAwardPos = CONST_SheepRedPacket.No_Receive_Award;
         }
         if(this.FFavourExchangeView != null)
         {
            this.FFavourExchangeView.LogicsPerform_EnterFrame();
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as TActivitySheepRedPacketData;
      }
      
      protected function SendServerData(param1:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param1);
      }
      
      private function UpdateBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         this.FMyFavournValueTF.text = this.FData.MyFavornValue.toString();
         this.FPacketFreeTimeTF.text = this.FData.FreeSendRedPacketValue.toString();
         this.FResetFreeTimeTF.text = this.FData.FreeResetValue.toString();
         this.FServiceFavournValueTF.text = this.FData.AllServiceFavornValue.toString();
         _loc2_ = int(this.FData.FavornGiftVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGiftConditionVec[_loc1_].text = this.FData.FavornGiftVec[_loc1_].NeedFavornValue.toString();
            this.FGetGiftBtnVec[_loc1_].Enabled = this.FData.FavornGiftVec[_loc1_].GetAwardState != CONST_SheepRedPacket.Activity_AlreadyReceive && this.FData.FavornGiftVec[_loc1_].NeedFavornValue <= this.FData.AllServiceFavornValue ? true : false;
            if(this.FData.FavornGiftVec[_loc1_].GetAwardState != CONST_SheepRedPacket.Activity_AlreadyReceive)
            {
               this.FGiftGetAwardStateVec[_loc1_].visible = false;
            }
            else
            {
               this.FGiftGetAwardStateVec[_loc1_].visible = true;
            }
            _loc1_++;
         }
         _loc2_ = int(this.FData.PersonAwardVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FReceiveRedPacketVec[_loc1_];
            _loc4_ = this.FGetShowEffectVec[_loc1_];
            if(this.FData.PersonAwardVec[_loc1_].GetAwardState == CONST_SheepRedPacket.Activity_AlreadyReceive)
            {
               _loc3_.gotoAndStop(2);
               if(_loc4_ != null)
               {
                  _loc4_.visible = true;
                  _loc4_.play();
               }
            }
            else
            {
               _loc3_.gotoAndStop(1);
               if(_loc4_ != null)
               {
                  _loc4_.visible = false;
                  _loc4_.stop();
               }
            }
            _loc1_++;
         }
         if(this.FData.GetAwardPos != CONST_SheepRedPacket.No_Receive_Award)
         {
            if(this.FCurPlayEffect != null)
            {
               this.FCurPlayEffect.visible = false;
               this.FCurPlayEffect.gotoAndStop(1);
            }
            this.FCurPlayEffect = this.FEffectVec[this.FData.GetAwardPos];
            this.FData.GetAwardPos = CONST_SheepRedPacket.No_Receive_Award;
            if(this.FCurPlayEffect)
            {
               this.FCurPlayEffect.visible = true;
               this.FCurPlayEffect.play();
            }
         }
         this.SendRedPacketFinish();
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftAwardVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FData.FavornGiftVec[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnGetAwardClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGetGiftBtnVec.indexOf(param1 as TUIButton);
         this.SendServerData(this.FData.FavornGiftVec[_loc3_].Index);
      }
      
      protected function OnOpenMallPanel(param1:Object, param2:MouseEvent) : void
      {
         this.FFavourExchangeView.Data = this.FData;
         this.FFavourExchangeView.Show();
      }
      
      protected function OnSendPacketClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TUIWindowRecharge = null;
         _loc3_ = this.FData.ActivityConfig.SendRedPacketIndex;
         _loc4_ = this.FData.FreeSendRedPacketValue * this.FData.ActivityConfig.SendPacketCostGold;
         _loc7_ = SLogicsCore.Character.CreditGold + _loc4_;
         _loc5_ = this.FData.ActivityConfig.SendPacketCostGold;
         _loc6_ = _loc5_ - _loc4_;
         if(_loc7_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            _loc8_ = SUtilityOverLayer.UIWindowRecharge;
            _loc8_.SetGoldNum(Math.abs(_loc6_));
            _loc8_.Visible = true;
            return;
         }
         if(_loc6_ <= 0)
         {
            this.SendServerData(_loc3_);
         }
         else
         {
            this.WindowUIPopUp.visible = true;
            this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            this.WindowUIPopUp.OnOK = this.WindowOk;
            this.WindowUIPopUp.Tag = _loc3_;
         }
      }
      
      private function SendRedPacketFinish() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc4_ = true;
         _loc3_ = int(this.FData.PersonAwardVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.PersonAwardVec[_loc2_].GetAwardState == CONST_SheepRedPacket.Activity_AlreadyReceive)
            {
               _loc1_ = true;
            }
            else
            {
               _loc1_ = false;
            }
            _loc4_ &&= _loc1_;
            _loc2_++;
         }
         this.FSendRedPacketBtn.Enabled = !_loc4_;
         return _loc4_;
      }
      
      private function WindowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         this.SendServerData(_loc2_);
      }
      
      protected function OnResetClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TUIWindowRecharge = null;
         _loc3_ = this.FData.ActivityConfig.ResetBtnIndex;
         _loc4_ = this.FData.FreeResetValue * this.FData.ActivityConfig.ResetCostGold;
         _loc7_ = SLogicsCore.Character.CreditGold + _loc4_;
         _loc5_ = this.FData.ActivityConfig.ResetCostGold;
         _loc6_ = _loc5_ - _loc4_;
         if(_loc7_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            _loc8_ = SUtilityOverLayer.UIWindowRecharge;
            _loc8_.SetGoldNum(Math.abs(_loc6_));
            _loc8_.Visible = true;
            return;
         }
         if(_loc6_ <= 0)
         {
            if(this.FData.FreeResetValue > 0)
            {
               this.WindowUIPopUp.visible = true;
               this.WindowUIPopUp.Text = this.FData.ActivityConfig.FreeResetPrompt;
               this.WindowUIPopUp.OnOK = this.WindowOk;
               this.WindowUIPopUp.Tag = _loc3_;
            }
            else
            {
               this.SendServerData(_loc3_);
            }
         }
         else
         {
            this.WindowUIPopUp.visible = true;
            this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            this.WindowUIPopUp.OnOK = this.WindowOk;
            this.WindowUIPopUp.Tag = _loc3_;
         }
      }
      
      protected function OverTipsShowHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FData.ActivityConfig.SendPacketCostGold;
         _loc4_ = this.FData.ActivityConfig.SendPacketPrompt;
         _loc4_ = TUtilityString.Format(_loc4_,_loc3_);
         if(this.FData.FreeSendRedPacketValue > 0)
         {
            FHint.Caption = "";
         }
         else
         {
            FHint.Caption = _loc4_;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function OverResetTipsShowHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FData.ActivityConfig.ResetCostGold;
         _loc4_ = this.FData.ActivityConfig.ResetPrompt;
         _loc4_ = TUtilityString.Format(_loc4_,_loc3_);
         if(this.FData.FreeResetValue > 0)
         {
            FHint.Caption = "";
         }
         else
         {
            FHint.Caption = _loc4_;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function OutTipsHideHandler(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.InitWindow(param1);
         addChild(param1);
         this.InitPropItemsResource();
         this.InitGiftResource();
         this.InitPersonResource();
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
         this.FFavourExchangeView = new TFavourExchangeView(this);
         this.FFavourExchangeView.SendData = this.SendServerData;
         FParent.addChild(this.FFavourExchangeView);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.UpdateUI();
      }
   }
}

