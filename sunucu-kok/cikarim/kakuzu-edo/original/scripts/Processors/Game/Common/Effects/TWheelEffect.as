package Processors.Game.Common.Effects
{
   import flash.utils.getTimer;
   
   public class TWheelEffect
   {
      
      protected var FItemCount:int;
      
      protected var FRandomTurns:Vector.<int>;
      
      protected var FTargetTurns:int;
      
      protected var FSpeed:int;
      
      protected var FIsStart:Boolean;
      
      protected var FOnStopState:Boolean;
      
      protected var FCurrentIndex:int;
      
      protected var FCurrentTurns:int;
      
      protected var FTotalTurns:int;
      
      protected var FRemainTime:int;
      
      protected var FLastTime:int;
      
      protected var FTargetIndex:int;
      
      protected var FRandomTurnsFinishCall:Function;
      
      protected var FStopToTargetCall:Function;
      
      protected var FChangeCall:Function;
      
      public function TWheelEffect()
      {
         super();
         this.FCurrentIndex = -1;
      }
      
      protected function Reset() : void
      {
         this.FIsStart = false;
         this.FOnStopState = false;
         this.FCurrentTurns = 0;
         this.FTotalTurns = 0;
         this.FRemainTime = this.FSpeed;
         this.FLastTime = 0;
      }
      
      public function set RandomTurnsFinishCall(param1:Function) : void
      {
         this.FRandomTurnsFinishCall = param1;
      }
      
      public function set StopToTargetCall(param1:Function) : void
      {
         this.FStopToTargetCall = param1;
      }
      
      public function set ChangeCall(param1:Function) : void
      {
         this.FChangeCall = param1;
      }
      
      public function get IsStart() : Boolean
      {
         return this.FIsStart;
      }
      
      public function Init(param1:int, param2:int, ... rest) : void
      {
         this.FItemCount = param1;
         this.FRandomTurns = Vector.<int>(rest);
         this.FSpeed = param2;
      }
      
      public function Play(param1:int = 0) : void
      {
         var _loc2_:int = 0;
         if(!this.FIsStart)
         {
            _loc2_ = Math.round(Math.random() * (this.FRandomTurns.length - 1));
            this.FTotalTurns = this.FRandomTurns[_loc2_];
            this.FRemainTime = this.FSpeed;
            this.FLastTime = getTimer();
            this.FIsStart = true;
            if(this.FChangeCall != null)
            {
               this.FChangeCall(this.FCurrentIndex,param1);
            }
            this.FCurrentIndex = param1;
         }
      }
      
      public function Stop(param1:int) : void
      {
         if(this.FIsStart)
         {
            this.FOnStopState = true;
            this.FTargetIndex = param1;
         }
      }
      
      public function ForcedStop(param1:int, param2:Boolean = true) : void
      {
         this.Reset();
         if(this.FChangeCall != null)
         {
            this.FChangeCall(this.FCurrentIndex,param1);
         }
         this.FTargetIndex = this.FCurrentIndex = param1;
         if(param2 && this.FStopToTargetCall != null)
         {
            this.FStopToTargetCall(param1);
         }
      }
      
      public function Loop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(this.FIsStart)
         {
            _loc2_ = getTimer();
            _loc1_ = _loc2_ - this.FLastTime;
            this.FLastTime = _loc2_;
            this.FRemainTime -= _loc1_;
            if(this.FRemainTime <= 0)
            {
               this.FRemainTime = this.FSpeed;
               _loc3_ = uint(this.FCurrentIndex);
               ++this.FCurrentIndex;
               if(this.FCurrentIndex == this.FItemCount - 1)
               {
                  ++this.FCurrentTurns;
                  if(this.FCurrentTurns == this.FTotalTurns && this.FRandomTurnsFinishCall != null)
                  {
                     this.FRandomTurnsFinishCall();
                  }
               }
               this.FCurrentIndex %= this.FItemCount;
               if(this.FChangeCall != null)
               {
                  this.FChangeCall(_loc3_,this.FCurrentIndex);
               }
               if(this.FOnStopState && this.FCurrentIndex == this.FTargetIndex)
               {
                  this.Reset();
                  if(this.FStopToTargetCall != null)
                  {
                     this.FStopToTargetCall(this.FTargetIndex);
                  }
               }
            }
         }
      }
   }
}

