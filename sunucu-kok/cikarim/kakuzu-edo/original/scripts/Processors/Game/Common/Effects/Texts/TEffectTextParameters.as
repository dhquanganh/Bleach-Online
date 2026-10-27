package Processors.Game.Common.Effects.Texts
{
   import Foundation.Fonts.*;
   import Foundation.Utilities.*;
   import Resources.Constants.*;
   import flash.text.TextFormat;
   
   public class TEffectTextParameters
   {
      
      protected var FFont:TFont;
      
      protected var FFontEffect:TFontEffect;
      
      protected var FEffectTextFormats:Vector.<TextFormat>;
      
      protected var FFormatsBeginIndex:Vector.<uint>;
      
      protected var FFormatsEndIndex:Vector.<uint>;
      
      public function TEffectTextParameters()
      {
         super();
         this.FEffectTextFormats = new Vector.<TextFormat>();
         this.FFont = new TFont();
         this.FFontEffect = new TFontEffect();
         this.FFormatsBeginIndex = new Vector.<uint>();
         this.FFormatsEndIndex = new Vector.<uint>();
         this.PropertiesInitialize();
      }
      
      protected function PropertiesInitialize() : void
      {
         SFontCore.FontSelect(this.FFont,CONST_EFFECT.TEXT_DEFAULT_FontSetName,CONST_EFFECT.TEXT_DEFAULT_FontSetSize,CONST_EFFECT.TEXT_DEFAULT_FontSetBold);
         this.FFontEffect.AntiAliased = true;
         this.FFontEffect.Outlined = true;
         this.FFontEffect.OutlineSize = CONST_EFFECT.TEXT_DEFAULT_OutlineSize;
         this.FFontEffect.OutlineColor = CONST_EFFECT.OUTLINECOLOR_Black;
         this.FFontEffect.OutlineIntensity = CONST_EFFECT.TEXT_DEFAULT_OutlineIntensity;
         this.FFontEffect.Shadowed = true;
         this.FFontEffect.ShadowDistance = CONST_EFFECT.TEXT_DEFAULT_ShadowDistance;
         this.FFontEffect.ShadowAngle = CONST_EFFECT.TEXT_DEFAULT_ShadowAngle;
         this.FFontEffect.ShadowBlur = CONST_EFFECT.TEXT_DEFAULT_ShadowBlur;
         this.FFontEffect.ShadowColor = CONST_EFFECT.TEXT_DEFAULT_ShadowColor;
      }
      
      public function get Font() : TFont
      {
         return this.FFont;
      }
      
      public function get FontEffect() : TFontEffect
      {
         return this.FFontEffect;
      }
      
      public function get EffectTextFormats() : Vector.<TextFormat>
      {
         return this.FEffectTextFormats;
      }
      
      public function get FormatsBeginIndex() : Vector.<uint>
      {
         return this.FFormatsBeginIndex;
      }
      
      public function get FormatsEndIndex() : Vector.<uint>
      {
         return this.FFormatsEndIndex;
      }
      
      public function Clear() : void
      {
         this.FEffectTextFormats.length = 0;
         this.FFormatsBeginIndex.length = 0;
         this.FFormatsEndIndex.length = 0;
      }
      
      public function Assign(param1:Vector.<TextFormat>, param2:Vector.<uint>, param3:Vector.<uint>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param1.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FEffectTextFormats[_loc4_] = param1[_loc4_];
            this.FFormatsBeginIndex[_loc4_] = param2[_loc4_];
            this.FFormatsEndIndex[_loc4_] = param3[_loc4_];
            _loc4_++;
         }
      }
   }
}

