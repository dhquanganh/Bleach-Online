package Processors.Game.Common.Effects.Animations
{
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementCrossfade;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.UI.TUIComponent;
   
   public class TEffectAnimationLinearCrossfade extends TEffectAnimation
   {
      
      protected var FMovementCrossfade:TMovementCrossfade;
      
      public function TEffectAnimationLinearCrossfade(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructMovementFields() : void
      {
         FMovementEffect = new TMovementLinear();
         this.FMovementCrossfade = new TMovementCrossfade();
      }
      
      override protected function ConstructRenderingFileds() : void
      {
         super.ConstructRenderingFileds();
      }
      
      override protected function TimingPerform_Effect() : int
      {
         if(FTimingTick < 0)
         {
            return TIMING_Bypass;
         }
         if(FTimingTick >= this.FMovementCrossfade.TerminationTick)
         {
            return TIMING_Terminate;
         }
         return TIMING_Render;
      }
      
      override protected function MovementPerform() : void
      {
         MovementPerform_Effect();
         this.MovementPerform_Crossfade();
      }
      
      protected function MovementPerform_Crossfade() : void
      {
         this.FMovementCrossfade.Move(FTimingTick);
      }
      
      override protected function RenderingPerform_Frame(param1:TAnimationFrame) : Boolean
      {
         var _loc2_:uint = 0;
         if(param1 == null)
         {
            return false;
         }
         _loc2_ = this.FMovementCrossfade.Alpha;
         FImage.bitmapData = param1.Surface;
         FImage.x = FMountPointsBounds.X;
         FImage.y = FMountPointsBounds.Y;
         FImage.alpha = _loc2_ / 255;
         return true;
      }
      
      public function SetupMovement(param1:TCoordinate, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:Number, param8:int, param9:int, param10:Boolean) : void
      {
         FTimingReferenceTick = param2;
         (FMovementEffect as TMovementLinear).SetupRay(param1.X,param1.Y,param6,param7,param8,param9);
         this.FMovementCrossfade.Setup(param3,param4,param5,param8,param9,param10);
         FSetupMovement = true;
      }
   }
}

