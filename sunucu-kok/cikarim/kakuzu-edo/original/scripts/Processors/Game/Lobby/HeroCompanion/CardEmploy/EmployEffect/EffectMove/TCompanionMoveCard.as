package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.EffectMove
{
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.MovieClip;
   
   public class TCompanionMoveCard extends TCompanionMoveBase
   {
      
      protected static const State_Disappear:int = 0;
      
      protected static const State_FlyToCenter:int = 1;
      
      protected static const State_StopInCenter:int = 2;
      
      protected static const State_ShowEffect:int = 5;
      
      protected static const State_GoBack:int = 3;
      
      protected static const State_End:int = 4;
      
      protected static const StateArr:Vector.<int> = Vector.<int>([State_Disappear,State_FlyToCenter,State_StopInCenter,State_ShowEffect,State_GoBack,State_End]);
      
      protected var StateFunction:Vector.<Function>;
      
      protected var FCurrentState:int;
      
      protected var FShowMove:TMovementLinear;
      
      protected var FHideMove:TMovementLinear;
      
      protected var FEffect:MovieClip;
      
      public function TCompanionMoveCard()
      {
         this.StateFunction = Vector.<Function>([this.StateDisappearAction,this.StateFlyToCenterAction,this.StateStopInCenterAction,this.StateShowEffect,this.StateGoBackAction,this.StateEndAction]);
         super();
         this.FShowMove = new TMovementLinear();
         this.FHideMove = new TMovementLinear();
      }
      
      protected function StateDisappearAction() : void
      {
      }
      
      protected function StateFlyToCenterAction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         _loc1_ = STimingCore.TickCount - FStartTick;
         this.FShowMove.Move(_loc1_);
         Display.x = this.FShowMove.X;
         Display.y = this.FShowMove.Y;
         Display.alpha = this.FShowMove.Ratio;
         _loc2_ = this.FShowMove.Ratio + (1 - this.FShowMove.Ratio) * CONST_HEROCOMPANION.Card_Scale;
         Display.scaleX = _loc2_;
         Display.scaleY = _loc2_;
         if(this.FShowMove.MoveOver)
         {
            Display.alpha = 1;
            FStartTick = STimingCore.TickCount;
            this.FCurrentState = State_StopInCenter;
         }
      }
      
      protected function StateStopInCenterAction() : void
      {
         this.FCurrentState = State_ShowEffect;
         this.FEffect.gotoAndPlay(1);
         this.FEffect.visible = true;
      }
      
      protected function StateShowEffect() : void
      {
         if(this.FEffect.currentFrame == this.FEffect.totalFrames)
         {
            this.FEffect.visible = false;
            this.FEffect.stop();
            FStartTick = STimingCore.TickCount;
            this.FCurrentState = State_GoBack;
         }
      }
      
      protected function StateGoBackAction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         _loc1_ = STimingCore.TickCount - FStartTick;
         this.FHideMove.Move(_loc1_);
         Display.x = this.FHideMove.X;
         Display.y = this.FHideMove.Y;
         _loc2_ = 1 - (1 - CONST_HEROCOMPANION.Card_Scale) * this.FHideMove.Ratio;
         Display.scaleX = _loc2_;
         Display.scaleY = _loc2_;
         if(this.FHideMove.MoveOver)
         {
            Display.alpha = 0;
            if(FOnSpecialShowEnd != null)
            {
               FOnSpecialShowEnd(this);
            }
            this.FCurrentState = State_End;
         }
      }
      
      protected function StateEndAction() : void
      {
      }
      
      override public function StartToAction() : void
      {
         super.StartToAction();
         this.FCurrentState = State_FlyToCenter;
         FStartTick = STimingCore.TickCount;
      }
      
      override public function get MoveOver() : Boolean
      {
         return this.FCurrentState == State_End;
      }
      
      public function set Effect(param1:MovieClip) : void
      {
         this.FEffect = param1;
      }
      
      override public function SetMove(... rest) : void
      {
         super.SetMove(rest);
         this.FShowMove.SetupSegmentByDuration(rest[4],rest[5],rest[4] + (FDisplay.width >> 1),rest[5],rest[6]);
         this.FHideMove.SetupSegmentByDuration(rest[0],rest[1],rest[4],rest[5],rest[6]);
         this.FCurrentState = State_Disappear;
      }
      
      override public function Action() : void
      {
         var _loc1_:int = 0;
         _loc1_ = StateArr.indexOf(this.FCurrentState);
         this.StateFunction[_loc1_]();
      }
   }
}

