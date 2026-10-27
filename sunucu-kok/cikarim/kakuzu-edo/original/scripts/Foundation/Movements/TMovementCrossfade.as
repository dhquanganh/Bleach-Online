package Foundation.Movements
{
   public class TMovementCrossfade extends TMovement
   {
      
      protected var FFadeInTicks:int;
      
      protected var FFadeOutTicks:int;
      
      protected var FSustainTicks:int;
      
      protected var FPauseTicks:int;
      
      protected var FPauseSustainTicks:int;
      
      protected var FTerminationTick:int;
      
      protected var FIsScale:Boolean;
      
      protected var FAlpha:uint;
      
      protected var FScale:Number;
      
      public function TMovementCrossfade()
      {
         super();
      }
      
      public function get Alpha() : uint
      {
         return this.FAlpha;
      }
      
      public function set Alpha(param1:uint) : void
      {
         this.FAlpha = param1;
      }
      
      public function get Scale() : Number
      {
         return this.FScale;
      }
      
      public function set Scale(param1:Number) : void
      {
         this.FScale = param1;
      }
      
      public function get TerminationTick() : int
      {
         return this.FTerminationTick;
      }
      
      override public function Move(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         _loc3_ = 1;
         if(param1 < 0 || param1 >= this.FTerminationTick)
         {
            this.FAlpha = 0;
            return;
         }
         if(param1 < this.FFadeInTicks)
         {
            _loc2_ = param1 / this.FFadeInTicks;
            if(this.FIsScale)
            {
               _loc3_ = param1 / this.FFadeInTicks;
            }
         }
         else if(param1 >= this.FPauseTicks && param1 <= this.FPauseTicks + this.FPauseSustainTicks)
         {
            _loc2_ = 1;
         }
         else
         {
            _loc4_ = this.FFadeInTicks + this.FSustainTicks;
            if(this.FIsScale)
            {
               _loc3_ = 1;
            }
            if(param1 < _loc4_)
            {
               _loc2_ = 1;
            }
            else
            {
               _loc2_ = 1 - (param1 - _loc4_) / this.FFadeOutTicks;
            }
         }
         this.FAlpha = _loc2_ * 255 | 0x0F;
         this.FScale = _loc3_;
      }
      
      public function Setup(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Boolean) : void
      {
         this.FFadeInTicks = param1;
         this.FFadeOutTicks = param2;
         this.FSustainTicks = param3;
         this.FPauseTicks = param4;
         this.FPauseSustainTicks = param5;
         this.FIsScale = param6;
         this.FTerminationTick = param1 + param2 + param3;
      }
   }
}

