package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect.EffectMove
{
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   import Resources.Constants.CONST_HEROCOMPANION;
   
   public class TCompanionMoveChip extends TCompanionMoveBase
   {
      
      protected var FMovement:TMovementLinear;
      
      protected var FSpecialShowEnd:Boolean;
      
      public function TCompanionMoveChip()
      {
         super();
         this.FMovement = new TMovementLinear();
      }
      
      override public function StartToAction() : void
      {
         super.StartToAction();
         FStartTick = STimingCore.TickCount;
      }
      
      override public function get MoveOver() : Boolean
      {
         return this.FMovement.MoveOver;
      }
      
      override public function SetMove(... rest) : void
      {
         super.SetMove(rest);
         this.FMovement.SetupSegmentByDuration(rest[0],rest[1],rest[0] + CONST_HEROCOMPANION.Animation_Offset,rest[1],rest[4]);
         this.FSpecialShowEnd = false;
      }
      
      override public function Action() : void
      {
         var _loc1_:int = 0;
         super.Action();
         _loc1_ = STimingCore.TickCount - FStartTick;
         this.FMovement.Move(_loc1_);
         Display.x = this.FMovement.X;
         Display.y = this.FMovement.Y;
         Display.alpha = this.FMovement.Ratio;
         if(_loc1_ > CONST_HEROCOMPANION.Animation_Interval)
         {
            Display.alpha = 1;
            if(!this.FSpecialShowEnd)
            {
               if(FOnSpecialShowEnd != null)
               {
                  FOnSpecialShowEnd(this);
               }
               this.FSpecialShowEnd = true;
            }
         }
      }
   }
}

