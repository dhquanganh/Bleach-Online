package Processors.Game.Common.Effects.Movements
{
   import Foundation.Movements.TMovementCartisian;
   
   public class TMovementPuzzleBallistic extends TMovementCartisian
   {
      
      public static const BALLISTIC_TimeExponent:Number = 6;
      
      protected var FSourceX:Number;
      
      protected var FSourceY:Number;
      
      protected var FDestinationX:Number;
      
      protected var FDestinationY:Number;
      
      protected var FDuration:Number;
      
      protected var FVelocityX:Number;
      
      protected var FVelocityY:Number;
      
      protected var FAccelerationX:Number;
      
      protected var FAccelerationY:Number;
      
      public function TMovementPuzzleBallistic()
      {
         super();
      }
      
      override public function Move(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = param1 * 0.001;
         if(_loc2_ < 0)
         {
            FX = this.FSourceX;
            FY = this.FSourceY;
            return;
         }
         if(_loc2_ >= this.FDuration)
         {
            FX = this.FDestinationX;
            FY = this.FDestinationY;
            return;
         }
         _loc3_ = Math.pow(_loc2_,BALLISTIC_TimeExponent);
         FX = this.FSourceX + this.FVelocityX * _loc2_ + this.FAccelerationX * _loc3_;
         FY = this.FSourceY + this.FVelocityY * _loc2_ + this.FAccelerationY * _loc3_;
      }
      
      public function Setup(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:Number, param7:Number) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         this.FDestinationX = param1;
         this.FDestinationY = param2;
         this.FSourceX = param3;
         this.FSourceY = param4;
         if(param5 > 0)
         {
            _loc10_ = param5 * 0.001;
         }
         else
         {
            _loc10_ = 0;
         }
         this.FDuration = _loc10_;
         this.FVelocityX = param6;
         this.FVelocityY = param7;
         _loc8_ = param1 - param3;
         _loc9_ = param2 - param4;
         _loc11_ = Math.pow(_loc10_,BALLISTIC_TimeExponent);
         this.FAccelerationX = (_loc8_ - param6 * _loc10_) / _loc11_;
         this.FAccelerationY = (_loc9_ - param7 * _loc10_) / _loc11_;
      }
   }
}

