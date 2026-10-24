package Rendering.Overlayers.HelpTips
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterHtmlTextEffect;
   
   public class TOverlayerHelpTips extends TOverlayer
   {
      
      protected static const COLOR_ContextDefault:uint = 4294958161;
      
      protected static const SIZE_WordWrapWidthDefault:uint = 500;
      
      protected var FPainterHtmlTextEffect:TPainterHtmlTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FContextCaption:String;
      
      public function TOverlayerHelpTips(param1:TUIComponent)
      {
         super(param1);
         FWordWrapWidth = SIZE_WordWrapWidthDefault;
         this.FPainterHtmlTextEffect = this.ConstructPainterHtmlTextEffect(COLOR_ContextDefault);
         this.FBoundsCaption = new TBounds();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.Font.Leading = 3;
         _loc2_.Font.LetterSpacing = 2;
         _loc2_.WordWrap = true;
         _loc2_.Multilineable = true;
         return _loc2_;
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
         return this.FContextCaption != _loc2_.Content;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:THint = null;
         _loc1_ = FContext as THint;
         this.FContextCaption = _loc1_.Content;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:THint = null;
         _loc1_ = FContext as THint;
         this.EvaluationPerform_Caption(_loc1_);
      }
      
      protected function EvaluationPerform_Caption(param1:THint) : void
      {
         this.FPainterHtmlTextEffect.Text = param1.Content;
         this.FPainterHtmlTextEffect.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FBoundsCaption.Width = FBoundsContext.Width;
         this.FPainterHtmlTextEffect.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Center,TAlignment.VERTICAL_Center);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = (FBoundsSubstrate.Width - this.FPainterHtmlTextEffect.TextWidth) / 2;
         _loc3_ = (FBoundsSubstrate.Height - this.FPainterHtmlTextEffect.TextHeight) / 2;
         FBoundsRendering.X = _loc2_;
         FBoundsRendering.Y = _loc3_;
         this.FPainterHtmlTextEffect.X = FBoundsRendering.X;
         this.FPainterHtmlTextEffect.Y = FBoundsRendering.Y;
      }
   }
}

