package Processors.Game.Effects
{
   import Foundation.Common.TCoordinate;
   import Foundation.Fonts.SFontCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Common.Effects.Common.TEffect;
   import Processors.Game.Common.Effects.TEffectLayer;
   import Processors.Game.Common.Effects.TProcessorEffect;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Common.Effects.Texts.TEffectTextLinearCrossfade;
   import Processors.Game.Common.Effects.Texts.TEffectTextParameters;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_EFFECT;
   
   public class TProcessorRootEffect extends TProcessorEffect
   {
      
      protected static const COORDINATE_TextX:int = 620;
      
      protected static const COORDINATE_TextY:int = 300;
      
      protected static const COLOR_EffectText:uint = 4294952980;
      
      public static const CAPACITY_ParallelOutputRows:uint = CONST_EFFECT.CAPACITY_ParallelOutputRows;
      
      protected static const SEQUENCEID_Default:uint = CONST_COMMON.SEQUENCEID_Default;
      
      protected var FLayerText:TEffectLayer;
      
      protected var FTextParameters:TEffectTextParameters;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FCoordinateText:TCoordinate;
      
      public function TProcessorRootEffect(param1:TUIComponent)
      {
         super(param1);
         this.ConstructEffectFields();
         this.ConstructEffectParameters();
         this.FCoordinateText = new TCoordinate();
         this.mouseEnabled = false;
      }
      
      override protected function ConstructEffectLayers() : void
      {
         super.ConstructEffectLayers();
         this.FLayerText = ConstructEffectLayer();
      }
      
      protected function ConstructEffectFields() : void
      {
         this.ConstructEffectFields_Text();
      }
      
      protected function ConstructEffectParameters() : void
      {
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FEffectCoordinateParameters.IsShakeEffect = true;
      }
      
      protected function ConstructEffectFields_Text() : void
      {
         this.FTextParameters = new TEffectTextParameters();
         this.FTextParameters.Font.Color = COLOR_EffectText;
         SFontCore.FontSelect(this.FTextParameters.Font,CONST_EFFECT.TEXT_DEFAULT_FontSetName,CONST_EFFECT.TEXT_DEFAULT_FontSetSize,CONST_EFFECT.TEXT_DEFAULT_FontSetBold);
      }
      
      protected function ImportingPerform_Text(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:TEffectTextLinearCrossfade = null;
         var _loc7_:TEffect = null;
         this.FCoordinateText.X = COORDINATE_TextX;
         this.FCoordinateText.Y = COORDINATE_TextY;
         _loc6_ = FPoolEffect.AcquireTextLinearCrossfade(this);
         if(param2 != null)
         {
            _loc6_.SetupResources(param1,param2);
         }
         else
         {
            _loc6_.SetupResources(param1,this.FTextParameters);
         }
         if(param3 != null)
         {
            this.FEffectCoordinateParameters.Assign(param3);
            this.FCoordinateText.X = param3.X;
            this.FCoordinateText.Y = param3.Y;
         }
         else
         {
            this.FEffectCoordinateParameters.Reset();
         }
         _loc5_ = this.FLayerText.Count;
         if(this.FLayerText.Count > 0)
         {
            _loc4_ = int(_loc5_ - 1);
            while(_loc4_ >= 0)
            {
               _loc7_ = this.FLayerText.GetEffectByIndex(_loc4_) as TEffect;
               if(!_loc7_.IsParallelOutput)
               {
                  break;
               }
               if(_loc5_ - _loc4_ > CAPACITY_ParallelOutputRows)
               {
                  _loc7_.TerminateMovement();
               }
               else
               {
                  _loc7_.SourceY = this.FCoordinateText.Y - (_loc5_ - _loc4_) * _loc7_.Height;
               }
               _loc4_--;
            }
         }
         _loc6_.SetupMovement(this.FCoordinateText,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks,this.FEffectCoordinateParameters.VelocityX,this.FEffectCoordinateParameters.VelocityY,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsShakeEffect,this.FEffectCoordinateParameters.IsScale,this.FEffectCoordinateParameters.IsParallelOutput);
         this.FLayerText.Add(_loc6_);
      }
      
      public function ImportText(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         this.ImportingPerform_Text(param1,param2,param3);
      }
   }
}

