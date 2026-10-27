package Components.Standard
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class TUIImage extends TUIComponent
   {
      
      protected var FImage:Bitmap;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FBoundsEvaluated:TBounds;
      
      protected var FSequence:TAnimationSequence;
      
      public function TUIImage(param1:TUIComponent)
      {
         super(param1);
         this.FImage = new Bitmap();
         addChild(this.FImage);
         this.FCoordinate = new TCoordinate();
         this.FBoundsEvaluated = new TBounds();
      }
      
      public function get Sequence() : TAnimationSequence
      {
         return this.FSequence;
      }
      
      public function set Sequence(param1:TAnimationSequence) : void
      {
         if(param1 != this.FSequence)
         {
            this.FSequence = param1;
            if(param1 == null)
            {
               this.FImage.bitmapData = null;
               return;
            }
            this.FImage.bitmapData = this.FSequence.GetAnimationFrameByTick(0).Surface;
         }
      }
      
      public function SetRegistrationPoint(param1:int, param2:int) : void
      {
         this.FImage.x = param1;
         this.FImage.y = param2;
      }
      
      public function RenderingPerformByTick(param1:int) : void
      {
         var _loc2_:BitmapData = null;
         _loc2_ = this.FSequence.GetAnimationFrameByTick(param1).Surface;
         if(this.FImage.bitmapData != _loc2_)
         {
            this.FImage.bitmapData = _loc2_;
         }
      }
      
      override public function Dispose() : void
      {
         this.FImage.bitmapData = null;
         if(this.FImage.parent != null)
         {
            this.FImage.parent.removeChild(this.FImage);
         }
         this.FImage = null;
         if(this.FSequence != null)
         {
            this.FSequence.Clear();
            this.FSequence = null;
         }
         this.FCoordinate = null;
         this.FBoundsEvaluated = null;
      }
   }
}

