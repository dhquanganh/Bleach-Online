package Foundation.Resources.Textures
{
   import Foundation.Common.*;
   import Foundation.Resources.Common.*;
   import Foundation.Resources.Spaces.*;
   import flash.display.*;
   
   use namespace ResourcesSpace;
   
   public class TAnimationSequence extends TResource
   {
      
      public static const TIMING_Manual:int = 0;
      
      public static const TIMING_Once:int = 1;
      
      public static const TIMING_Loop:int = 2;
      
      protected var FSurface:BitmapData;
      
      protected var FAnimationFrames:Vector.<TAnimationFrame>;
      
      protected var FTiming:int;
      
      protected var FDuration:int;
      
      protected var FIndex:int;
      
      public function TAnimationSequence(param1:uint)
      {
         super(param1);
         this.FAnimationFrames = new Vector.<TAnimationFrame>();
      }
      
      ResourcesSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      ResourcesSpace function CoerceProperties(param1:int) : void
      {
         this.FTiming = param1;
      }
      
      ResourcesSpace function FramesClear() : void
      {
         this.FAnimationFrames.length = 0;
         this.FDuration = 0;
      }
      
      ResourcesSpace function FrameAppend(param1:TAnimationFrame) : void
      {
         this.FAnimationFrames.push(param1);
         this.FDuration += param1.Duration;
      }
      
      protected function AnimationFrameAtTick(param1:int) : TAnimationFrame
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAnimationFrame = null;
         _loc2_ = 0;
         _loc3_ = int(this.FAnimationFrames.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FAnimationFrames[_loc4_];
            _loc2_ += _loc5_.Duration;
            if(_loc2_ >= param1)
            {
               this.FIndex = _loc4_;
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function get Count() : int
      {
         return this.FAnimationFrames.length;
      }
      
      public function get Timing() : int
      {
         return this.FTiming;
      }
      
      public function get Duration() : int
      {
         return this.FDuration;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAnimationFrame = null;
         _loc2_ = int(this.FAnimationFrames.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAnimationFrames[_loc1_];
            _loc3_.Clear();
            _loc1_++;
         }
         this.FramesClear();
      }
      
      public function Evaluate(param1:TCoordinate, param2:TBounds) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAnimationFrame = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc3_ = int(this.FAnimationFrames.length);
         if(_loc3_ == 0)
         {
            param2.X = param1.X;
            param2.Y = param1.Y;
            param2.Width = 0;
            param2.Height = 0;
            return;
         }
         if(this.FTiming == TIMING_Manual)
         {
            _loc3_ = 1;
         }
         _loc6_ = 2147483647;
         _loc7_ = 2147483647;
         _loc8_ = 2147483648;
         _loc9_ = 2147483648;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FAnimationFrames[_loc4_];
            _loc5_.Evaluate(param1,param2);
            _loc6_ = Math.min(_loc6_,param2.X);
            _loc7_ = Math.min(_loc7_,param2.Y);
            _loc8_ = Math.max(_loc8_,param2.XEnd);
            _loc9_ = Math.max(_loc9_,param2.YEnd);
            _loc4_++;
         }
         param2.X = _loc6_;
         param2.Y = _loc7_;
         param2.Width = _loc8_ - _loc6_;
         param2.Height = _loc9_ - _loc7_;
      }
      
      public function GetAnimationFrameByIndex(param1:int) : TAnimationFrame
      {
         return this.FAnimationFrames[param1];
      }
      
      public function GetAnimationFrameByTick(param1:int) : TAnimationFrame
      {
         if(this.FAnimationFrames.length != 0)
         {
            switch(this.FTiming)
            {
               case TIMING_Manual:
                  return this.FAnimationFrames[0];
               case TIMING_Once:
                  if(param1 < this.FDuration)
                  {
                     return this.AnimationFrameAtTick(param1);
                  }
                  return null;
                  break;
               case TIMING_Loop:
                  return this.AnimationFrameAtTick(param1 % this.FDuration);
            }
         }
         return null;
      }
   }
}

