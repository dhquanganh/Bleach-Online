package Foundation.Movements
{
   public class TMovementLinear extends TMovementCartisian
   {
      
      protected static const MOVEMENTMODE_Ray:int = 0;
      
      protected static const MOVEMENTMODE_Segment:int = 1;
      
      protected var FMovementMode:int;
      
      protected var FDestinationX:Number;
      
      protected var FDestinationY:Number;
      
      protected var FSourceX:Number;
      
      protected var FSourceY:Number;
      
      protected var FPauseTicks:int;
      
      protected var FPauseSustainTicks:int;
      
      protected var FVelocityX:Number;
      
      protected var FVelocityY:Number;
      
      protected var FDuration:Number;
      
      protected var FMoveOver:Boolean;
      
      protected var FRatio:Number;
      
      public function TMovementLinear()
      {
         super();
      }
      
      protected function MovementPerform_Ray(param1:int) : void
      {
         var _loc2_:Number = NaN;
         _loc2_ = param1 * 0.001;
         if(param1 >= this.FPauseTicks && param1 <= this.FPauseTicks + this.FPauseSustainTicks)
         {
            _loc2_ = this.FPauseTicks * 0.001;
         }
         else if(param1 > this.FPauseTicks + this.FPauseSustainTicks)
         {
            param1 -= this.FPauseSustainTicks;
            _loc2_ = param1 * 0.001;
         }
         FX = this.FSourceX + this.FVelocityX * _loc2_;
         FY = this.FSourceY + this.FVelocityY * _loc2_;
      }
      
      protected function MovementPerform_Segment(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = param1 * 0.001;
         if(_loc2_ >= this.FDuration)
         {
            _loc3_ = 1;
            this.FMoveOver = true;
         }
         else if(_loc2_ <= 0)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = _loc2_ / this.FDuration;
         }
         this.FRatio = _loc3_;
         FX = this.FSourceX + (this.FDestinationX - this.FSourceX) * _loc3_;
         FY = this.FSourceY + (this.FDestinationY - this.FSourceY) * _loc3_;
      }
      
      public function get SourceY() : Number
      {
         return this.FSourceY;
      }
      
      public function set SourceY(param1:Number) : void
      {
         this.FSourceY = param1;
      }
      
      public function get MoveOver() : Boolean
      {
         return this.FMoveOver;
      }
      
      public function set MoveOver(param1:Boolean) : void
      {
         this.FMoveOver = param1;
      }
      
      public function get Ratio() : Number
      {
         return this.FRatio;
      }
      
      override public function Move(param1:int) : void
      {
         switch(this.FMovementMode)
         {
            case MOVEMENTMODE_Ray:
               this.MovementPerform_Ray(param1);
               break;
            case MOVEMENTMODE_Segment:
               this.MovementPerform_Segment(param1);
         }
      }
      
      public function SetupRay(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:int) : void
      {
         this.FSourceX = param1;
         this.FSourceY = param2;
         this.FVelocityX = param3;
         this.FVelocityY = param4;
         this.FPauseTicks = param5;
         this.FPauseSustainTicks = param6;
         this.FMovementMode = MOVEMENTMODE_Ray;
      }
      
      public function SetupSegmentByDuration(param1:Number, param2:Number, param3:Number, param4:Number, param5:int) : void
      {
         this.FDestinationX = param1;
         this.FDestinationY = param2;
         this.FSourceX = param3;
         this.FSourceY = param4;
         if(param5 > 0)
         {
            this.FDuration = param5 * 0.001;
         }
         else
         {
            this.FDuration = 0;
         }
         this.FMoveOver = false;
         this.FMovementMode = MOVEMENTMODE_Segment;
      }
   }
}

