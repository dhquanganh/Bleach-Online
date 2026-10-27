package Processors.Game.Common.Effects.Animations
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Common.Effects.Common.TEffect;
   import flash.display.Bitmap;
   
   public class TEffectAnimation extends TEffect
   {
      
      protected var FImage:Bitmap;
      
      protected var FResourceSequence:TAnimationSequence;
      
      protected var FMountPointsBounds:TBounds;
      
      public function TEffectAnimation(param1:TUIComponent)
      {
         super(param1);
         this.FImage = new Bitmap();
         this.addChild(this.FImage);
         this.FMountPointsBounds = new TBounds();
      }
      
      override protected function TimingPerform_Effect() : int
      {
         if(FTimingTick < 0)
         {
            return TIMING_Bypass;
         }
         return TIMING_Terminate;
      }
      
      override protected function RenderingPerform_Effect() : Boolean
      {
         var _loc1_:TAnimationFrame = null;
         if(this.FResourceSequence == null)
         {
            return false;
         }
         _loc1_ = this.FResourceSequence.GetAnimationFrameByTick(FTimingTick);
         this.FResourceSequence.Evaluate(FCoordinate,this.FMountPointsBounds);
         return this.RenderingPerform_Frame(_loc1_);
      }
      
      protected function RenderingPerform_Frame(param1:TAnimationFrame) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return true;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FImage.bitmapData = null;
         this.FResourceSequence = null;
      }
      
      public function SetupResources(param1:TAnimationSequence) : void
      {
         this.FResourceSequence = param1;
         FSetupResources = true;
      }
   }
}

