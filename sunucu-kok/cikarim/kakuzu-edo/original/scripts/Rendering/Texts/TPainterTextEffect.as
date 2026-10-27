package Rendering.Texts
{
   import Foundation.Common.TBounds;
   import Foundation.Fonts.SFontCore;
   import Foundation.Fonts.TFont;
   import Foundation.Fonts.TFontEffect;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.text.AntiAliasType;
   import flash.text.TextFormat;
   
   public class TPainterTextEffect extends TPainterText
   {
      
      protected static const FONTSCALE_Normal:int = 1;
      
      protected static const FONTSCALE_AntiAlias:int = 2;
      
      protected var FFontEffecting:TFont;
      
      protected var FEffectFontEmbedded:Boolean;
      
      protected var FEffectFontScale:int;
      
      protected var FEffectFontBlendMode:String;
      
      protected var FBoundsEffectPrevious:TBounds;
      
      protected var FBoundsEffectBase:TBounds;
      
      protected var FBoundsEffectAntiAlias:TBounds;
      
      protected var FBoundsEffectGradient:TBounds;
      
      protected var FBoundsEffectOutline:TBounds;
      
      protected var FBoundsEffectShadow:TBounds;
      
      protected var FGradientSprite:Sprite;
      
      protected var FGradientGraphics:Graphics;
      
      protected var FGradientMatrix:Matrix;
      
      protected var FOutlineFilter:GlowFilter;
      
      protected var FShadowFilter:DropShadowFilter;
      
      protected var FFontEffect:TFontEffect;
      
      public function TPainterTextEffect(param1:TUIComponent)
      {
         super(param1);
         this.ConstructFontEffects();
         this.FGradientSprite = new Sprite();
         this.FGradientGraphics = this.FGradientSprite.graphics;
         this.FGradientMatrix = new Matrix();
         this.FOutlineFilter = new GlowFilter();
         this.FShadowFilter = new DropShadowFilter();
         this.FBoundsEffectBase = new TBounds();
         this.FBoundsEffectAntiAlias = new TBounds();
         this.FBoundsEffectGradient = new TBounds();
         this.FBoundsEffectOutline = new TBounds();
         this.FBoundsEffectShadow = new TBounds();
      }
      
      override protected function ConstructFonts() : void
      {
         super.ConstructFonts();
         this.FFontEffecting = new TFont();
         this.FEffectFontEmbedded = false;
         this.FEffectFontScale = FONTSCALE_Normal;
         this.FEffectFontBlendMode = null;
      }
      
      protected function ConstructFontEffects() : void
      {
         this.FFontEffect = new TFontEffect(FStubModification);
      }
      
      override protected function FontSynchronize() : void
      {
         this.FFontEffecting.Assign(FFont);
         this.FFontEffecting.Size = FFont.Size;
         this.FFontEffecting.FlushTextFormat(FTextFormat);
         FTextField.embedFonts = this.FEffectFontEmbedded;
         FTextField.selectable = FSelectable;
      }
      
      override protected function EvaluationPerform_Font() : void
      {
         this.FEffectFontEmbedded = SFontCore.FontEmbedded(FFont.Name);
         if(!this.FEffectFontEmbedded && this.FFontEffect.AntiAliased)
         {
            this.FEffectFontScale = FONTSCALE_AntiAlias;
         }
         else
         {
            this.FEffectFontScale = FONTSCALE_Normal;
         }
         this.FontSynchronize();
      }
      
      override protected function EvaluationPerform_Text() : void
      {
         if(FWordWrap)
         {
            FParagraphParameters.WrapTrailingSpaces = FWrapTrailingSpaces;
            FParagrapher.Paragraph(FText,this.FFontEffecting,FWordWrapWidth * this.FEffectFontScale);
         }
         else
         {
            FParagrapher.Paragraph(FText,this.FFontEffecting,0);
         }
      }
      
      override protected function EvaluationPerform_Dimension() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = FParagrapher.ParagraphWidth;
         _loc2_ = FParagrapher.ParagraphHeight;
         _loc3_ = _loc1_ % this.FEffectFontScale;
         if(_loc3_ != 0)
         {
            _loc1_ += this.FEffectFontScale - _loc3_;
         }
         _loc3_ = _loc2_ % this.FEffectFontScale;
         if(_loc3_ != 0)
         {
            _loc2_ += this.FEffectFontScale - _loc3_;
         }
         FParagraphWidth = _loc1_;
         FParagraphHeight = _loc2_;
      }
      
      override protected function EvaluationPerform_Bounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = FParagraphWidth;
         _loc2_ = FParagraphHeight;
         if(_loc1_ == 0 || _loc2_ == 0)
         {
            FBoundsText.Reset();
            return;
         }
         TUtilityCartisian.BoundsSetSize(this.FBoundsEffectBase,_loc1_,_loc2_);
         TUtilityCartisian.BoundsSetSize(this.FBoundsEffectAntiAlias,_loc1_,_loc2_);
         TUtilityCartisian.BoundsSetSize(this.FBoundsEffectGradient,_loc1_,_loc2_);
         if(this.FFontEffect.Outlined)
         {
            _loc3_ = this.FFontEffect.OutlineSize;
         }
         else
         {
            _loc3_ = 0;
         }
         _loc1_ += _loc3_;
         _loc2_ += _loc3_;
         TUtilityCartisian.BoundsSetSize(this.FBoundsEffectOutline,_loc1_,_loc2_);
         if(this.FFontEffect.Shadowed)
         {
            _loc3_ = this.FFontEffect.ShadowDistance + this.FFontEffect.ShadowBlur;
         }
         else
         {
            _loc3_ = 0;
         }
         _loc1_ += _loc3_;
         TUtilityCartisian.BoundsSetSize(this.FBoundsEffectShadow,_loc1_,_loc2_);
         TUtilityCartisian.BoundsSetSize(FBoundsText,_loc1_,_loc2_);
      }
      
      override protected function SketchingPerform() : void
      {
         this.SketchingPerform_Sketch();
         this.SketchingPerform_EffectBase();
         this.SketchingPerform_EffectBaseText();
         this.SketchingPerform_Effects();
         this.SketchingPerform_Text();
      }
      
      override protected function SketchingPerform_Sketch() : void
      {
      }
      
      protected function SketchingPerform_EffectBase() : void
      {
      }
      
      protected function SketchingPerform_EffectBaseText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         FTextField.text = "";
         FTextField.defaultTextFormat = FTextFormat;
         _loc3_ = -TEXTFIELD_GutterY;
         _loc1_ = FParagrapher.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            FTextField.appendText(FParagrapher.GetLineTextByIndex(_loc2_));
            if(_loc2_ >= 0 && _loc2_ < _loc1_ - 1)
            {
               FTextField.appendText("\n");
            }
            FCoordinateSketching.X = FParagrapher.GetLineXByIndex(_loc2_) - TEXTFIELD_GutterX;
            FCoordinateSketching.Y = _loc3_;
            if(_loc2_ == 0)
            {
               FTextField.x = FCoordinateSketching.X;
               FTextField.y = FCoordinateSketching.Y;
            }
            _loc3_ += FParagrapher.GetLineHeightByIndex(_loc2_);
            _loc2_++;
         }
      }
      
      protected function SketchingPerform_Effects() : void
      {
         this.SketchingPerform_EffectAntiAlias();
         this.SketchingPerform_EffectOutline();
         this.SketchingPerform_EffectShadow();
      }
      
      protected function SketchingPerform_EffectAntiAlias() : void
      {
         if(this.FEffectFontEmbedded || !this.FFontEffect.AntiAliased)
         {
            return;
         }
         FTextField.antiAliasType = AntiAliasType.ADVANCED;
      }
      
      protected function SketchingPerform_EffectOutline() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         if(!this.FFontEffect.Outlined)
         {
            return;
         }
         _loc2_ = this.FFontEffect.OutlineSize;
         _loc3_ = this.FFontEffect.OutlineColor;
         _loc4_ = this.FFontEffect.OutlineIntensity;
         if(_loc2_ == 0 || _loc3_ >>> 24 == 0 || _loc4_ == 0)
         {
            return;
         }
         this.FOutlineFilter.blurX = _loc2_;
         this.FOutlineFilter.blurY = _loc2_;
         this.FOutlineFilter.color = _loc3_;
         this.FOutlineFilter.alpha = (_loc3_ >>> 24) / 255;
         this.FOutlineFilter.strength = _loc4_;
         _loc1_ = FTextField.filters.indexOf(this.FOutlineFilter);
         if(_loc1_ < 0)
         {
            FTextField.filters = [this.FOutlineFilter];
         }
      }
      
      protected function SketchingPerform_EffectShadow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         if(!this.FFontEffect.Shadowed)
         {
            return;
         }
         _loc2_ = this.FFontEffect.ShadowDistance;
         _loc3_ = this.FFontEffect.ShadowBlur;
         _loc4_ = this.FFontEffect.ShadowColor;
         if(_loc2_ == 0 && _loc3_ == 0)
         {
            return;
         }
         if(_loc4_ >>> 24 == 0)
         {
            return;
         }
         this.FShadowFilter.distance = _loc2_;
         this.FShadowFilter.angle = this.FFontEffect.ShadowAngle;
         this.FShadowFilter.blurX = _loc3_;
         this.FShadowFilter.blurY = _loc3_;
         this.FShadowFilter.color = _loc4_;
         this.FShadowFilter.alpha = (_loc4_ >>> 24) / 255;
         _loc5_ = _loc2_ + _loc3_;
         _loc1_ = FTextField.filters.indexOf(this.FShadowFilter);
         if(_loc1_ < 0)
         {
            if(this.FFontEffect.Outlined)
            {
               FTextField.filters = [this.FOutlineFilter,this.FShadowFilter];
            }
            else
            {
               FTextField.filters = [this.FShadowFilter];
            }
         }
      }
      
      override protected function SketchingPerform_Text() : void
      {
      }
      
      public function get FontEffect() : TFontEffect
      {
         return this.FFontEffect;
      }
      
      public function SetTextFormat(param1:TextFormat, param2:int = -1, param3:int = -1) : void
      {
         FTextField.setTextFormat(param1,param2,param3);
      }
   }
}

