package Processors.Game.Lobby.Activity.HDEveryDayAward.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEveryDayAward.TEveryDayAwardData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorEveryDayAwardView extends TProcessorHDSingleWindowBase
   {
      
      protected const ShareGiftCount:uint = 4;
      
      protected var FRechargeGift:TUIButton;
      
      protected var FRechargeGiftGet:TUIButton;
      
      protected var FShareGift:Vector.<TUIButton>;
      
      protected var FShareGiftBuy:Vector.<TUIButton>;
      
      protected var FShareGiftReceive:Vector.<TUIButton>;
      
      protected var FData:TEveryDayAwardData;
      
      protected var FShareGiftPos:uint;
      
      public function TProcessorEveryDayAwardView(param1:TUIComponent)
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
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:TUIButton = null;
         this.FData = param1 as TEveryDayAwardData;
         _loc2_ = FScene["MC_EveryDayAwardPanel"];
         _loc6_ = this.FData.Config.RechargeGift[this.FData.Day];
         _loc2_.TF_Cost.text = String(_loc6_.cost);
         _loc2_.TF_Recharge.text = String(this.FData.Recharge);
         if(this.FData.RechargeGift == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            _loc2_.MC_Get.visible = true;
            this.FRechargeGiftGet.Enabled = false;
         }
         else if(this.FData.RechargeGift == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
         {
            _loc2_.MC_Get.visible = false;
            this.FRechargeGiftGet.Enabled = false;
         }
         else
         {
            _loc2_.MC_Get.visible = false;
            this.FRechargeGiftGet.Enabled = true;
         }
         _loc7_ = Vector.<Object>(this.FData.Config.ShareGift[this.FData.Day]);
         _loc5_ = 0;
         while(_loc5_ < this.ShareGiftCount)
         {
            _loc6_ = _loc7_[_loc5_];
            _loc2_ = FScene["MC_Gift_" + _loc5_];
            _loc2_.TF_Cost.text = String(_loc6_.cost);
            _loc2_.TF_Desc.text = TUtilityString.Format(this.FData.Config.Language.shareGiftDesc,_loc6_.condition);
            _loc8_ = this.FShareGiftReceive[_loc5_];
            if(this.FData.ShareGiftState[_loc5_] == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               _loc8_.Enabled = false;
               _loc2_.MC_Get.visible = true;
            }
            else
            {
               _loc8_.Enabled = this.FData.Recharge >= this.FData.Config.RechargeGift[this.FData.Day].cost;
               _loc2_.MC_Get.visible = false;
            }
            _loc5_++;
         }
         FScene["TF_Participate"].text = this.FData.Participate.toString();
      }
      
      protected function OnRechargeGiftMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.RechargeGiftInv[this.FData.Day],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnShareGiftMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.ShareGiftInvs[this.FData.Day][_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnGiftOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnRechargeGiftGetClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RechargeGiftIndex);
      }
      
      protected function OnShareGiftGetClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         this.FShareGiftPos = (param1 as TUIButton).Tag;
         _loc4_ = this.FData.Config.ShareGift[this.FData.Day][this.FShareGiftPos];
         _loc3_ = _loc4_.cost * Math.max(0,1 - this.FData.Participate / _loc4_.condition);
         if(_loc3_ == 0)
         {
            this.OnShareGiftGetClickOK(null);
         }
         else
         {
            GoldBuy(_loc3_,this.OnShareGiftGetClickOK);
         }
      }
      
      protected function OnBuyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         this.FShareGiftPos = (param1 as TUIButton).Tag;
         _loc4_ = this.FData.Config.ShareGift[this.FData.Day][this.FShareGiftPos];
         _loc3_ = uint(_loc4_.cost);
         if(_loc3_ == 0)
         {
            this.OnBuyBtnClickOK(null);
         }
         else
         {
            GoldBuy(_loc3_,this.OnBuyBtnClickOK);
         }
      }
      
      protected function OnShareGiftGetClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RechargeIndexs[this.FShareGiftPos]);
      }
      
      protected function OnBuyBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BuyIndexs[this.FShareGiftPos]);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUIButton = null;
         super.InitWindow(param1);
         this.FShareGift = new Vector.<TUIButton>();
         this.FShareGiftBuy = new Vector.<TUIButton>();
         this.FShareGiftReceive = new Vector.<TUIButton>();
         _loc2_ = FScene["MC_EveryDayAwardPanel"];
         this.FRechargeGift = new TUIButton();
         this.FRechargeGift.Substrate = _loc2_.MC_Gift;
         this.FRechargeGift.OnMove = this.OnRechargeGiftMove;
         this.FRechargeGift.OnOut = this.OnGiftOut;
         this.FRechargeGiftGet = new TUIButton();
         this.FRechargeGiftGet.Substrate = _loc2_.Btn_Receive;
         this.FRechargeGiftGet.OnClick = this.OnRechargeGiftGetClick;
         _loc4_ = 0;
         while(_loc4_ < this.ShareGiftCount)
         {
            _loc2_ = FScene["MC_Gift_" + _loc4_];
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc2_.MC_Gift;
            _loc6_.OnMove = this.OnShareGiftMove;
            _loc6_.OnOut = this.OnGiftOut;
            this.FShareGift.push(_loc6_);
            _loc6_.Tag = _loc4_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc2_.Btn_Receive;
            _loc6_.OnClick = this.OnShareGiftGetClick;
            this.FShareGiftReceive.push(_loc6_);
            _loc6_.Tag = _loc4_;
            _loc6_ = new TUIButton();
            _loc6_.Substrate = _loc2_.Btn_Buy;
            _loc6_.OnClick = this.OnBuyBtnClick;
            this.FShareGiftBuy.push(_loc6_);
            _loc6_.Tag = _loc4_;
            _loc4_++;
         }
      }
   }
}

