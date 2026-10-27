package Processors.Game.Common.Effects.Texts
{
   import Foundation.Common.TAlignment;
   import Foundation.Fonts.SFontCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Common.Effects.Common.TEffect;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Resources.Constants.CONST_EFFECT;
   import Resources.Constants.CONST_OVERLAYER;
   
   public class TEffectHtmlText extends TEffect implements IEffectText
   {
      
      protected static const COLOR_ContextDefault:uint = 4294089481;
      
      protected static const SIZE_WordWrapWidthDefault:uint = 500;
      
      protected var FResourcesText:String;
      
      protected var FRenderingPainterHtmlText:TPainterHtmlTextEffect;
      
      protected var FWordWrapWidth:int;
      
      protected var FAlignmentHorizontal:int;
      
      protected var FAlignmentVertical:int;
      
      public function TEffectHtmlText(param1:TUIComponent)
      {
         super(param1);
         this.FWordWrapWidth = SIZE_WordWrapWidthDefault;
         this.FAlignmentHorizontal = TAlignment.HORIZONTAL_Center;
         this.FAlignmentVertical = TAlignment.VERTICAL_Top;
      }
      
      override protected function ConstructRenderingFileds() : void
      {
         this.FRenderingPainterHtmlText = new TPainterHtmlTextEffect(this);
         SFontCore.FontSelect(this.FRenderingPainterHtmlText.Font,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetName,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetSize,CONST_OVERLAYER.TEXT_ANTIALIAS_FontSetBold);
         this.FRenderingPainterHtmlText.Font.Color = COLOR_ContextDefault;
         this.FRenderingPainterHtmlText.FontEffect.AntiAliased = true;
         this.FRenderingPainterHtmlText.FontEffect.Outlined = true;
         this.FRenderingPainterHtmlText.FontEffect.OutlineSize = CONST_EFFECT.TEXT_DEFAULT_OutlineSize;
         this.FRenderingPainterHtmlText.FontEffect.OutlineColor = CONST_EFFECT.OUTLINECOLOR_Black;
         this.FRenderingPainterHtmlText.FontEffect.OutlineIntensity = CONST_EFFECT.TEXT_DEFAULT_OutlineIntensity;
         this.FRenderingPainterHtmlText.FontEffect.Shadowed = true;
         this.FRenderingPainterHtmlText.FontEffect.ShadowDistance = CONST_EFFECT.TEXT_DEFAULT_ShadowDistance;
         this.FRenderingPainterHtmlText.FontEffect.ShadowAngle = CONST_EFFECT.TEXT_DEFAULT_ShadowAngle;
         this.FRenderingPainterHtmlText.FontEffect.ShadowBlur = CONST_EFFECT.TEXT_DEFAULT_ShadowBlur;
         this.FRenderingPainterHtmlText.FontEffect.ShadowColor = CONST_EFFECT.TEXT_DEFAULT_ShadowColor;
         this.FRenderingPainterHtmlText.Multilineable = true;
      }
      
      override protected function RenderingPerform_Effect() : Boolean
      {
         return this.RenderingPerform_HtmlText();
      }
      
      protected function RenderingPerform_HtmlText() : Boolean
      {
         this.FRenderingPainterHtmlText.Render(FCoordinate,this.FAlignmentHorizontal,this.FAlignmentVertical);
         this.X = this.FRenderingPainterHtmlText.TextX;
         this.Y = this.FRenderingPainterHtmlText.TextY;
         return true;
      }
      
      protected function SketchingPerform() : void
      {
         this.FRenderingPainterHtmlText.Text = this.FResourcesText;
      }
      
      public function get AlignmentHorizontal() : int
      {
         return this.FAlignmentHorizontal;
      }
      
      public function set AlignmentHorizontal(param1:int) : void
      {
         this.FAlignmentHorizontal = param1;
      }
      
      public function get AlignmentVertical() : int
      {
         return this.FAlignmentVertical;
      }
      
      public function set AlignmentVertical(param1:int) : void
      {
         this.FAlignmentVertical = param1;
      }
      
      public function get ResourcesText() : String
      {
         return this.FResourcesText;
      }
      
      public function get TextHeight() : int
      {
         return this.FRenderingPainterHtmlText.TextHeight;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FResourcesText = "";
         this.FRenderingPainterHtmlText.Text = "";
         this.FAlignmentHorizontal = TAlignment.HORIZONTAL_Center;
         this.FAlignmentVertical = TAlignment.VERTICAL_Top;
      }
      
      public function SetupResources(param1:String) : void
      {
         if(TUtilityString.Empty(param1))
         {
            FSetupResources = false;
            return;
         }
         this.FResourcesText = param1;
         this.SketchingPerform();
         FSetupResources = true;
      }
   }
}

