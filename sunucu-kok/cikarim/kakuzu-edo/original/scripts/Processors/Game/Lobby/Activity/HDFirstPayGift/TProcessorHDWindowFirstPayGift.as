package Processors.Game.Lobby.Activity.HDFirstPayGift
{
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDFirstPayGift.TActivityFirstPayGiftData;
   import Logics.HDSwiftChange.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowFirstPayGift extends TProcessorHDSingleWindowBase
   {
      
      public static const State_0:int = 0;
      
      public static const State_1:int = 1;
      
      public static const state_2:int = -1;
      
      public const AwardNum:int = 3;
      
      private var FCurRechargeTxt:TextField;
      
      private var FLoginPayAwardMc:Sprite;
      
      private var FLoginGiftBag:TUIButton;
      
      private var FLoginReciveFlag:Sprite;
      
      private var FPayGiftVec:Vector.<TUIButton>;
      
      private var FPayGiftSignVec:Vector.<Sprite>;
      
      private var FPayConditionTFVec:Vector.<TextField>;
      
      private var FRechargeBtn:TUIButton;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      protected var FActivityData:TActivityFirstPayGiftData;
      
      public function TProcessorHDWindowFirstPayGift(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_FirstPayBag";
         FActivityID = CONST_ACTIVITY_MODE.Activity_FirstPayBag;
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
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIButton = null;
         this.FCurRechargeTxt = FScene["TF_RechargeGold"];
         this.FLoginPayAwardMc = FScene["MC_FirstAward"];
         this.FLoginGiftBag = new TUIButton();
         this.FLoginGiftBag.Substrate = this.FLoginPayAwardMc["MC_Award"];
         this.FLoginGiftBag.OnMove = this.LoginBoxOnMove;
         this.FLoginGiftBag.OnOut = this.BoxOnOut;
         this.FLoginGiftBag.OnClick = this.BtnLoginReciveOnClick;
         this.FLoginReciveFlag = this.FLoginPayAwardMc["MC_Sign"];
         this.FRechargeBtn = new TUIButton();
         this.FRechargeBtn.OnClick = this.OnRightNowRecharge;
         this.FRechargeBtn.Substrate = FScene["Btn_Recharge"];
         _loc2_ = this.AwardNum;
         this.FPayGiftVec = new Vector.<TUIButton>();
         this.FPayGiftSignVec = new Vector.<Sprite>();
         this.FPayConditionTFVec = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FScene["Item_" + _loc1_];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_["MC_Award"];
            _loc4_.OnMove = this.RechargeGiftBoxOnMove;
            _loc4_.OnOut = this.BoxOnOut;
            _loc4_.OnClick = this.BtnRechargeGiftOnClick;
            this.FPayGiftVec[_loc1_] = _loc4_;
            this.FPayGiftSignVec[_loc1_] = _loc3_["MC_Sign"];
            this.FPayConditionTFVec[_loc1_] = _loc3_["TF_Gold"];
            _loc1_++;
         }
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function LoginBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FActivityData.FirstInventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function BtnLoginReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityData.ActivityConfig.LoginIndex);
      }
      
      protected function BtnRechargeGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FPayGiftVec.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityData.RechargeGoldGiftVec[_loc3_].Index);
      }
      
      protected function RechargeGiftBoxOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FPayGiftVec.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityData.RechargeGoldGiftVec[_loc3_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnRightNowRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      public function set ActivityData(param1:TActivityFirstPayGiftData) : void
      {
         this.FActivityData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RefreshBaseInfo();
      }
      
      public function RefreshBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FCurRechargeTxt.text = this.FActivityData.RechargeGoldValue.toString();
         if(this.FActivityData.FirstState == State_0)
         {
            this.FLoginReciveFlag.visible = false;
            this.FLoginGiftBag.Enabled = false;
         }
         else if(this.FActivityData.FirstState == State_1)
         {
            this.FLoginReciveFlag.visible = false;
            this.FLoginGiftBag.Enabled = true;
         }
         else
         {
            this.FLoginReciveFlag.visible = true;
            this.FLoginGiftBag.Enabled = false;
         }
         _loc2_ = int(this.FActivityData.RechargeGoldGiftVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FPayConditionTFVec[_loc1_].text = this.FActivityData.RechargeGoldGiftVec[_loc1_].Gold.toString();
            if(this.FActivityData.RechargeGoldGiftVec[_loc1_].GetAwardState == State_0)
            {
               this.FPayGiftSignVec[_loc1_].visible = false;
               this.FPayGiftVec[_loc1_].Enabled = false;
            }
            else if(this.FActivityData.RechargeGoldGiftVec[_loc1_].GetAwardState == State_1)
            {
               this.FPayGiftSignVec[_loc1_].visible = false;
               this.FPayGiftVec[_loc1_].Enabled = true;
            }
            else
            {
               this.FPayGiftSignVec[_loc1_].visible = true;
               this.FPayGiftVec[_loc1_].Enabled = false;
            }
            _loc1_++;
         }
      }
   }
}

