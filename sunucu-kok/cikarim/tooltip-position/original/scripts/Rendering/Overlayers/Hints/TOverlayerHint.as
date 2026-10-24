package Rendering.Overlayers.Hints
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterText;
   
   public class TOverlayerHint extends TOverlayer
   {
      
      protected static const COLOR_ContextDefault:uint = 4294958161;
      
      protected static const SIZE_WordWrapWidthDefault:uint = 440;
      
      protected var FPainterCaption:TPainterText;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FContextCaption:String;
      
      public function TOverlayerHint(param1:TUIComponent)
      {
         super(param1);
         FWordWrapWidth = SIZE_WordWrapWidthDefault;
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsCaption = new TBounds();
         mouseChildren = false;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is THint;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:THint = null;
         _loc2_ = FContext as THint;
         return this.FContextCaption != _loc2_.Caption;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:THint = null;
         _loc1_ = FContext as THint;
         this.FContextCaption = _loc1_.Caption;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:THint = null;
         _loc1_ = FContext as THint;
         this.EvaluationPerform_Caption(_loc1_);
      }
      
      protected function EvaluationPerform_Caption(param1:THint) : void
      {
         BoundsAlignDown(this.FBoundsCaption);
         this.FPainterCaption.Text = param1.Caption;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FBoundsCaption.Width = FBoundsContext.Width;
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Center);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y;
      }
   }
}

