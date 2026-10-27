package Processors.Game.Lobby.Activity.HDNewServerDraw.Components
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDNewServerDraw.TNewServerDrawData;
   import Processors.Game.Common.Effects.TWheelEffect;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TNewServerDrawLottery extends TUIComponent
   {
      
      protected const LotteryRewardCount:uint = 5;
      
      protected var FMainUI:MovieClip;
      
      protected var FWheelEffect:TWheelEffect;
      
      protected var FLotteryBtn:TUIButton;
      
      public function TNewServerDrawLottery(param1:TUIComponent)
      {
         super(param1);
         this.FWheelEffect = new TWheelEffect();
         this.FWheelEffect.Init(this.LotteryRewardCount,70,1,2,3);
         this.FWheelEffect.ChangeCall = this.Change;
      }
      
      protected function Change(param1:int, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         _loc3_ = 0;
         while(_loc3_ < this.LotteryRewardCount)
         {
            this.FMainUI["MC_Prize_" + _loc3_].SelectBox.visible = false;
            _loc3_++;
         }
         if(param2 != -1)
         {
            this.FMainUI["MC_Prize_" + param2].SelectBox.visible = true;
         }
      }
      
      protected function LotteryBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWheelEffect.Play();
      }
      
      public function set Lottery_C2S(param1:Function) : void
      {
         this.FWheelEffect.RandomTurnsFinishCall = param1;
      }
      
      public function set BtnEnabled(param1:Boolean) : void
      {
         this.FLotteryBtn.Enabled = param1;
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         this.FMainUI = param1;
         this.FLotteryBtn = new TUIButton();
         this.FLotteryBtn.Substrate = this.FMainUI.Btn_Draw;
         this.FLotteryBtn.OnClick = this.LotteryBtnOnClick;
         _loc2_ = 0;
         while(_loc2_ < this.LotteryRewardCount)
         {
            this.FMainUI["MC_Prize_" + _loc2_].SelectBox.visible = false;
            _loc2_++;
         }
      }
      
      public function LogicsPerform() : void
      {
         this.FWheelEffect.Loop();
      }
      
      public function Reset() : void
      {
         this.FWheelEffect.ForcedStop(-1);
         this.BtnEnabled = false;
      }
      
      public function UpdateUI(param1:TNewServerDrawData) : void
      {
         if(param1.LotteryTargetIndex != -1)
         {
            this.FWheelEffect.Stop(param1.LotteryTargetIndex);
         }
      }
   }
}

