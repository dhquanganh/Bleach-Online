package Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.FirecrackersVO.TFireGiftBoxVO;
   import Logics.HDNewYearSheep.TFirecrackersData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorFirecrackersView extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TFirecrackersData;
      
      protected var FOneFireBtn:TUIButton;
      
      protected var FAllFireBtn:TUIButton;
      
      protected var FAllReceiveBtn:TUIButton;
      
      protected var FResetBtn:TUIButton;
      
      protected var FShowAwardUI:TShowAwardUI;
      
      protected var FGiftBtnList:Vector.<TUIButton>;
      
      protected var FFightReportBtn:TUIButton;
      
      protected var FHintObj:THint;
      
      public function TProcessorFirecrackersView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
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
         var _loc2_:TextField = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:TUIButton = null;
         var _loc7_:TFireGiftBoxVO = null;
         this.FData = param1 as TFirecrackersData;
         _loc3_ = FScene["MC_Panel1"];
         _loc5_ = 0;
         while(_loc5_ < TFirecrackersData.BoxCount)
         {
            _loc6_ = this.FGiftBtnList[_loc5_];
            _loc7_ = this.FData.BoxList[_loc5_];
            _loc6_.Enabled = _loc7_.State == Activity_CanReceive;
            _loc4_ = _loc3_["MC_GiftReceive_" + _loc5_];
            _loc4_.visible = _loc7_.State == Activity_AlreadyReceive;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < TFirecrackersData.FireCount)
         {
            _loc4_ = _loc3_["MC_Fire_" + _loc5_];
            if(this.FData.FireState[_loc5_] == TFirecrackersData.FireState_ON)
            {
               if(this.FData.Init)
               {
                  _loc4_.MC_Effect.gotoAndStop(_loc4_.MC_Effect.totalFrames);
               }
               else if(_loc4_.MC_Effect.currentFrame == 1)
               {
                  _loc4_.MC_Effect.play();
               }
               _loc4_.gotoAndStop(2);
            }
            else
            {
               _loc4_.MC_Effect.gotoAndStop(1);
               _loc4_.gotoAndStop(1);
            }
            _loc5_++;
         }
         this.FOneFireBtn.Enabled = this.FAllFireBtn.Enabled = !this.FData.IsAllFire();
         this.FAllReceiveBtn.Enabled = this.FData.HasCanReceive();
         _loc3_ = FScene["MC_Panel1"];
         _loc2_ = _loc3_.TF_FreeFireCount;
         _loc2_.text = this.FData.RemainFreeFire.toString();
         _loc2_ = _loc3_.TF_FreeResetCount;
         _loc2_.text = this.FData.RemainFreeReset.toString();
         _loc3_ = FScene["MC_Panel2"];
         _loc2_ = _loc3_.TF_FireTotal;
         _loc2_.text = this.FData.FireTotal.toString();
         _loc2_ = _loc3_.TF_NeedFire;
         _loc2_.text = this.FData.NeedFire.toString();
         this.FShowAwardUI.SetData(this.FData.AwardType,this.FData.AwardID,this.FData.ShowAwardID,this.FData.GiftType);
         _loc3_.MC_Receive.visible = this.FData.AwardState == Activity_AlreadyReceive;
         this.FFightReportBtn.Visible = this.FData.AwardType == TShowAwardUI.ArticalType_Hero;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      protected function OneFireBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         _loc4_ = this.FData.Config.LightingAndReset[0];
         if(this.FData.RemainFreeFire > 0)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc4_.lightingIndex);
         }
         else
         {
            _loc3_ = uint(this.FData.OneFireCost);
            if(_loc3_ <= SLogicsCore.Character.CreditGold)
            {
               FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
               FUIWindowConfirmation.OnOK = this.OneFireBtnOnClickOK;
               FUIWindowConfirmation.Visible = true;
            }
            else
            {
               FUIWindowRecharge.SetGoldNum(_loc3_);
               FUIWindowRecharge.Visible = true;
            }
         }
      }
      
      protected function AllFireBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(this.FData.AllFireCost);
         if(_loc3_ <= SLogicsCore.Character.CreditGold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
            FUIWindowConfirmation.OnOK = this.AllFireBtnOnClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(_loc3_);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function AllReceiveBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OneKeyDraw);
      }
      
      protected function ResetBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         _loc4_ = this.FData.Config.Language;
         _loc3_ = uint(this.FData.ResetCost);
         if(!this.FData.AllReceive())
         {
            SToolReward.ShowMessage(this.FData.Config.Language.resetTip);
            return;
         }
         if(this.FData.RemainFreeReset > 0)
         {
            FUIWindowConfirmation.Text = _loc4_.freeReset;
            FUIWindowConfirmation.OnOK = this.ResetBtnOnClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else if(_loc3_ <= SLogicsCore.Character.CreditGold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
            FUIWindowConfirmation.OnOK = this.ResetBtnOnClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(_loc3_);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function GiftBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OutsideAwardState,0,Vector.<int>([_loc3_.Tag]));
      }
      
      protected function GiftBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         ProcessorOnGiftBoxMove(this,this.FData.BoxList[_loc3_.Tag].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function GiftBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function FightReportBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.FightReportAddr);
      }
      
      protected function OneCostTipMove(param1:Object, param2:MouseEvent) : void
      {
         switch(param1)
         {
            case this.FOneFireBtn:
               if(this.FData.RemainFreeFire == 0)
               {
                  this.FHintObj.Caption = TUtilityString.Format(this.FData.Config.Language.costTip,this.FData.OneFireCost);
                  SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHintObj);
               }
               break;
            case this.FAllFireBtn:
               this.FHintObj.Caption = TUtilityString.Format(this.FData.Config.Language.costTip,this.FData.AllFireCost);
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHintObj);
               break;
            case this.FResetBtn:
               if(this.FData.RemainFreeReset == 0)
               {
                  this.FHintObj.Caption = TUtilityString.Format(this.FData.Config.Language.costTip,this.FData.ResetCost);
                  SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHintObj);
               }
         }
      }
      
      protected function OneCostTipOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHintObj);
      }
      
      protected function OneFireBtnOnClickOK(param1:Object) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.FData.Config.LightingAndReset[0];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc2_.lightingIndex);
      }
      
      protected function AllFireBtnOnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.OneKeyLighting);
      }
      
      protected function ResetBtnOnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.LightingAndReset[1].resetIndex);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         super.InitWindow(param1);
         this.FHintObj = new THint();
         _loc3_ = FScene["MC_Panel1"];
         this.FOneFireBtn = new TUIButton();
         this.FOneFireBtn.Substrate = _loc3_.Btn_OneFire;
         this.FOneFireBtn.OnClick = this.OneFireBtnOnClick;
         this.FOneFireBtn.OnMove = this.OneCostTipMove;
         this.FOneFireBtn.OnOut = this.OneCostTipOut;
         this.FAllFireBtn = new TUIButton();
         this.FAllFireBtn.Substrate = _loc3_.Btn_AllFire;
         this.FAllFireBtn.OnClick = this.AllFireBtnOnClick;
         this.FAllFireBtn.OnMove = this.OneCostTipMove;
         this.FAllFireBtn.OnOut = this.OneCostTipOut;
         this.FAllReceiveBtn = new TUIButton();
         this.FAllReceiveBtn.Substrate = _loc3_.Btn_AllReceive;
         this.FAllReceiveBtn.OnClick = this.AllReceiveBtnOnClick;
         this.FResetBtn = new TUIButton();
         this.FResetBtn.Substrate = _loc3_.Btn_Reset;
         this.FResetBtn.OnClick = this.ResetBtnOnClick;
         this.FResetBtn.OnMove = this.OneCostTipMove;
         this.FResetBtn.OnOut = this.OneCostTipOut;
         _loc3_ = FScene["MC_Panel2"];
         this.FShowAwardUI = new TShowAwardUI(this);
         this.FShowAwardUI.UIDispatch(_loc3_);
         _loc3_ = FScene["MC_Panel1"];
         this.FGiftBtnList = new Vector.<TUIButton>(TFirecrackersData.BoxCount);
         _loc2_ = 0;
         while(_loc2_ < TFirecrackersData.BoxCount)
         {
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_["Btn_Gift_" + _loc2_];
            _loc5_.OnClick = this.GiftBtnOnClick;
            _loc5_.OnMove = this.GiftBtnOnMove;
            _loc5_.OnOut = this.GiftBtnOnOut;
            _loc5_.Tag = _loc2_;
            this.FGiftBtnList[_loc2_] = _loc5_;
            _loc4_ = _loc3_["MC_GiftReceive_" + _loc2_];
            _loc4_.mouseChildren = _loc4_.mouseEnabled = false;
            _loc2_++;
         }
         _loc3_ = FScene["MC_Panel2"];
         this.FFightReportBtn = new TUIButton();
         this.FFightReportBtn.Substrate = _loc3_.Btn_FightReport;
         this.FFightReportBtn.OnClick = this.FightReportBtnOnClick;
      }
   }
}

