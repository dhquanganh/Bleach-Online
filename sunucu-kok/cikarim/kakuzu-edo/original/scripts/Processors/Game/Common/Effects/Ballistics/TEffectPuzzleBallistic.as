package Processors.Game.Common.Effects.Ballistics
{
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Common.Effects.Common.TEffect;
   import Processors.Game.Common.Effects.Movements.TMovementPuzzleBallistic;
   import flash.display.Bitmap;
   
   public class TEffectPuzzleBallistic extends TEffect
   {
      
      protected static const TRAJECTORY_Interval:int = 20;
      
      protected static const SEQUENCEID_Projectile:uint = 0;
      
      protected static const SEQUENCEID_Trajectory:uint = 1;
      
      protected static const SEQUENCEID_Explosion:uint = 2;
      
      protected var FImage:Bitmap;
      
      protected var FTimingTicksProjectile:int;
      
      protected var FTimingTicksExplosion:int;
      
      protected var FTimingTicksTrajectory:int;
      
      protected var FResourceSequenceProjectile:TAnimationSequence;
      
      protected var FResourceSequenceExplosion:TAnimationSequence;
      
      protected var FResourceSequenceTrajectory:TAnimationSequence;
      
      protected var FMovementTrajectory:TMovementPuzzleBallistic;
      
      protected var FRenderingCoordinateTrajectory:TCoordinate;
      
      public function TEffectPuzzleBallistic(param1:TUIComponent)
      {
         super(param1);
         this.FImage = new Bitmap();
         this.addChild(this.FImage);
      }
      
      override protected function ConstructMovementFields() : void
      {
         FMovementEffect = new TMovementPuzzleBallistic();
         this.FMovementTrajectory = new TMovementPuzzleBallistic();
      }
      
      override protected function ConstructRenderingFileds() : void
      {
         this.FRenderingCoordinateTrajectory = new TCoordinate();
      }
      
      override protected function TimingPerform_Effect() : int
      {
         var _loc1_:int = 0;
         if(FTimingTick < 0)
         {
            return TIMING_Bypass;
         }
         _loc1_ = Math.max(this.FTimingTicksProjectile + this.FTimingTicksExplosion,this.FTimingTicksProjectile + this.FTimingTicksTrajectory);
         if(FTimingTick >= _loc1_)
         {
            return TIMING_Terminate;
         }
         return TIMING_Render;
      }
      
      override protected function RenderingPerform_Effect() : Boolean
      {
         this.RenderingPerform_EffectTrajectory();
         if(FTimingTick < this.FTimingTicksProjectile)
         {
            this.RenderingPerform_EffectProjectile();
         }
         else
         {
            this.RenderingPerform_EffectExplosion();
         }
         return true;
      }
      
      protected function RenderingPerform_EffectTrajectory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAnimationFrame = null;
         if(this.FResourceSequenceTrajectory == null)
         {
            return;
         }
         _loc2_ = Math.min(FTimingTick,this.FTimingTicksProjectile);
         _loc1_ = FTimingTick - this.FTimingTicksTrajectory;
         _loc1_ /= TRAJECTORY_Interval;
         _loc1_ *= TRAJECTORY_Interval;
         if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FResourceSequenceTrajectory.GetAnimationFrameByTick(FTimingTick - _loc1_);
            if(_loc3_ != null)
            {
               this.FMovementTrajectory.Move(_loc1_);
               this.FMovementTrajectory.FlushCoordinate(this.FRenderingCoordinateTrajectory);
               this.FImage.bitmapData = _loc3_.Surface;
               this.X = this.FRenderingCoordinateTrajectory.X - _loc3_.Pivot.X;
               this.Y = this.FRenderingCoordinateTrajectory.Y - _loc3_.Pivot.Y;
            }
            _loc1_ += TRAJECTORY_Interval;
         }
      }
      
      protected function RenderingPerform_EffectProjectile() : void
      {
         var _loc1_:TAnimationFrame = null;
         if(this.FResourceSequenceProjectile == null)
         {
            return;
         }
         _loc1_ = this.FResourceSequenceProjectile.GetAnimationFrameByTick(FTimingTick);
         if(_loc1_ == null)
         {
            return;
         }
         this.FImage.bitmapData = _loc1_.Surface;
         this.X = this.FRenderingCoordinateTrajectory.X - _loc1_.Pivot.X;
         this.Y = this.FRenderingCoordinateTrajectory.Y - _loc1_.Pivot.Y;
      }
      
      protected function RenderingPerform_EffectExplosion() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAnimationFrame = null;
         if(this.FResourceSequenceExplosion == null)
         {
            return;
         }
         _loc1_ = FTimingTick - this.FTimingTicksProjectile;
         _loc2_ = this.FResourceSequenceExplosion.GetAnimationFrameByTick(_loc1_);
         if(_loc2_ == null)
         {
            return;
         }
         this.FImage.bitmapData = _loc2_.Surface;
         this.X = this.FRenderingCoordinateTrajectory.X - _loc2_.Pivot.X;
         this.Y = this.FRenderingCoordinateTrajectory.Y - _loc2_.Pivot.Y;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FImage.bitmapData = null;
         this.Visible = false;
      }
      
      public function SetupResources(param1:TTexture) : void
      {
         if(param1 == null)
         {
            FSetupResources = false;
            return;
         }
         this.FResourceSequenceProjectile = param1.GetAnimationSequenceByIdentifier(SEQUENCEID_Projectile);
         this.FResourceSequenceExplosion = param1.GetAnimationSequenceByIdentifier(SEQUENCEID_Explosion);
         this.FResourceSequenceTrajectory = param1.GetAnimationSequenceByIdentifier(SEQUENCEID_Trajectory);
         if(this.FResourceSequenceExplosion == null)
         {
            this.FTimingTicksExplosion = 0;
         }
         else
         {
            this.FTimingTicksExplosion = this.FResourceSequenceExplosion.Duration;
         }
         if(this.FResourceSequenceTrajectory == null)
         {
            this.FTimingTicksTrajectory = 0;
         }
         else
         {
            this.FTimingTicksTrajectory = this.FResourceSequenceTrajectory.Duration;
         }
         FSetupResources = true;
      }
      
      public function SetupMovement(param1:TCoordinate, param2:TCoordinate, param3:int, param4:int, param5:Number, param6:Number) : void
      {
         FTimingReferenceTick = param3;
         this.FTimingTicksProjectile = param4;
         this.FRenderingCoordinateTrajectory.X = param2.X;
         this.FRenderingCoordinateTrajectory.Y = param2.Y;
         (FMovementEffect as TMovementPuzzleBallistic).Setup(param1.X,param1.Y,param2.X,param2.Y,param4,param5,param6);
         this.FMovementTrajectory.Setup(param1.X,param1.Y,param2.X,param2.Y,param4,param5,param6);
         FSetupMovement = true;
      }
   }
}

