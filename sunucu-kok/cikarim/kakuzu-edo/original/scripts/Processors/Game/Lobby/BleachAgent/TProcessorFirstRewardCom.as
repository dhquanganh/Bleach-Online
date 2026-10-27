package Processors.Game.Lobby.BleachAgent
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import Logics.Streamization.BleachAgent.TUnstreamizerBleachAgent;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorFirstRewardCom extends TUIComponent
   {
      
      protected const NormalRewardCount:uint = 9;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TBleachAgentData;
      
      protected var FNormalSlot:Vector.<TUISlot>;
      
      protected var FReceiveBtn:TUIButton;
      
      protected var FUnstreamizer:TUnstreamizerBleachAgent;
      
      public function TProcessorFirstRewardCom(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.BleachAgentData;
         this.FUnstreamizer = new TUnstreamizerBleachAgent(this.FData);
      }
      
      protected function OnReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUnstreamizer.UpdateReq(this.FUnstreamizer.AwardType_First);
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FNormalSlot = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < this.NormalRewardCount)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI["MC_Slot_" + _loc2_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FNormalSlot[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FReceiveBtn = new TUIButton();
         this.FReceiveBtn.Substrate = this.FMainUI.Btn_Receive;
         this.FReceiveBtn.OnClick = this.OnReceiveBtnClick;
      }
      
      public function UIFinalize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < this.NormalRewardCount)
         {
            _loc2_ = this.FNormalSlot[_loc1_];
            _loc2_.Context = this.FData.ConfigValueVO.FirstReward.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      public function UIUpdate() : void
      {
         this.FMainUI.MC_Receive.visible = this.FData.FirstRewardState == CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         this.FReceiveBtn.Enabled = this.FData.FirstRewardState == CONST_ACTIVITY_MODE.Activity_CanReceive;
      }
      
      public function UILoop() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         if(Visible && this.FMainUI != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.NormalRewardCount)
            {
               _loc2_ = this.FNormalSlot[_loc1_];
               _loc2_.Update();
               _loc1_++;
            }
         }
      }
   }
}

