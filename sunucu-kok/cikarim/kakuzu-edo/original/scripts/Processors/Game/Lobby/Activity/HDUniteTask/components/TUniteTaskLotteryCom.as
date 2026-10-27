package Processors.Game.Lobby.Activity.HDUniteTask.components
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDUniteTask.TUniteTaskData;
   import Processors.Game.Common.Effects.TWheelEffect;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUniteTaskLotteryCom extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FLotteryBtn:TUIButton;
      
      protected var FData:TUniteTaskData;
      
      protected var FWheelEffect:TWheelEffect;
      
      protected var FLottery_C2S:Function;
      
      public function TUniteTaskLotteryCom(param1:TUIComponent)
      {
         super(param1);
         this.FSlots = new Vector.<TUISlot>(TUniteTaskData.LotteryRewardCount);
         this.FWheelEffect = new TWheelEffect();
         this.FWheelEffect.Init(TUniteTaskData.LotteryRewardCount,70,1,2,3);
         this.FWheelEffect.ChangeCall = this.Change;
      }
      
      protected function Change(param1:int, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         _loc3_ = 0;
         while(_loc3_ < TUniteTaskData.LotteryRewardCount)
         {
            this.FMainUI.MC_MainView["MC_Award_" + _loc3_].SelectBox.visible = false;
            _loc3_++;
         }
         if(param2 != -1)
         {
            this.FMainUI.MC_MainView["MC_Award_" + param2].SelectBox.visible = true;
         }
      }
      
      protected function OnLotteryClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWheelEffect.Play();
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:TUISlot = null;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.FMainUI = param1;
         _loc4_ = this.FMainUI["MC_MainView"];
         _loc3_ = 0;
         while(_loc3_ < TUniteTaskData.LotteryRewardCount)
         {
            _loc5_ = _loc4_["MC_Award_" + _loc3_];
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = _loc5_.MC_Slot;
            _loc2_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc2_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc2_);
            _loc2_.Init();
            this.FSlots[_loc3_] = _loc2_;
            _loc5_.SelectBox.mouseChildren = _loc5_.SelectBox.mouseEnabled = _loc5_.SelectBox.visible = false;
            _loc3_++;
         }
         this.FLotteryBtn = new TUIButton();
         this.FLotteryBtn.Substrate = _loc4_.Btn_Lottery;
         this.FLotteryBtn.OnClick = this.OnLotteryClick;
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < TUniteTaskData.LotteryRewardCount)
         {
            _loc2_ = this.FSlots[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.Update();
            }
            _loc1_++;
         }
         this.FWheelEffect.Loop();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         _loc3_ = this.FMainUI["MC_MainView"];
         _loc1_ = 0;
         while(_loc1_ < TUniteTaskData.LotteryRewardCount)
         {
            _loc4_ = _loc3_["MC_Award_" + _loc1_];
            _loc2_ = this.FSlots[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.Context = null;
            }
            _loc1_++;
         }
         this.FWheelEffect.ForcedStop(-1);
      }
      
      public function UpdateUI(param1:TUniteTaskData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.FData = param1;
         _loc4_ = this.FMainUI["MC_MainView"];
         _loc2_ = 0;
         while(_loc2_ < TUniteTaskData.LotteryRewardCount)
         {
            _loc5_ = _loc4_["MC_Award_" + _loc2_];
            _loc3_ = this.FSlots[_loc2_];
            _loc3_.Context = this.FData.LotteryInventories.GetInventoryByIndex(_loc2_);
            _loc5_.MC_Effect.play();
            _loc2_++;
         }
         this.FMainUI.TF_RemainLotteryCount.text = this.FData.RemainLotteryCount.toString();
         this.FLotteryBtn.Enabled = this.FData.RemainLotteryCount > 0;
         if(this.FData.LotteryTarget != null)
         {
            this.FWheelEffect.Stop(this.FData.GetAwardIndexByAwardInfo());
         }
      }
      
      public function set Lottery_C2S(param1:Function) : void
      {
         this.FLottery_C2S = param1;
         this.FWheelEffect.RandomTurnsFinishCall = this.FLottery_C2S;
      }
   }
}

