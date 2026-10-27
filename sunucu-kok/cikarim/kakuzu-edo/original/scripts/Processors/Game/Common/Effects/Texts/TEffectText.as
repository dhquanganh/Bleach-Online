package Processors.Game.Common.Effects.Texts
{
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Common.Effects.Common.*;
   import Rendering.Texts.*;
   
   public class TEffectText extends TEffect implements IEffectText
   {
      
      protected static var FParametersDefault:TEffectTextParameters;
      
      protected static var FParametersExternal:TEffectTextParameters;
      
      protected var FResourcesText:String;
      
      protected var FRenderingPainterText:TPainterTextEffect;
      
      protected var FAlignmentHorizontal:int;
      
      protected var FAlignmentVertical:int;
      
      protected var FIsSetEffectTextFormat:Boolean;
      
      public function TEffectText(param1:TUIComponent)
      {
         super(param1);
         FParametersDefault = new TEffectTextParameters();
         FParametersExternal = new TEffectTextParameters();
         this.FAlignmentHorizontal = TAlignment.HORIZONTAL_Center;
         this.FAlignmentVertical = TAlignment.VERTICAL_Center;
      }
      
      override protected function ConstructRenderingFileds() : void
      {
         this.FRenderingPainterText = new TPainterTextEffect(this);
      }
      
      override protected function RenderingPerform_Effect() : Boolean
      {
         return this.RenderingPerform_Text();
      }
      
      protected function RenderingPerform_Text() : Boolean
      {
         this.FRenderingPainterText.Render(FCoordinate,this.FAlignmentHorizontal,this.FAlignmentVertical);
         this.X = this.FRenderingPainterText.TextX;
         this.Y = this.FRenderingPainterText.TextY;
         return true;
      }
      
      protected function SketchingPerform(param1:TEffectTextParameters) : void
      {
         this.FRenderingPainterText.Font.Assign(param1.Font);
         this.FRenderingPainterText.FontEffect.Assign(param1.FontEffect);
         this.FRenderingPainterText.Text = this.FResourcesText;
      }
      
      protected function SetEffectTextFormat() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(FParametersExternal.EffectTextFormats.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FRenderingPainterText.SetTextFormat(FParametersExternal.EffectTextFormats[_loc1_],FParametersExternal.FormatsBeginIndex[_loc1_],FParametersExternal.FormatsEndIndex[_loc1_]);
            _loc1_++;
         }
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
         return this.FRenderingPainterText.TextHeight;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FResourcesText = "";
         this.FRenderingPainterText.Text = "";
         FParametersExternal.Clear();
         this.FAlignmentHorizontal = TAlignment.HORIZONTAL_Center;
         this.FAlignmentVertical = TAlignment.VERTICAL_Center;
         this.FIsSetEffectTextFormat = true;
      }
      
      public function SetupResources(param1:String, param2:TEffectTextParameters = null) : void
      {
         if(TUtilityString.Empty(param1))
         {
            FSetupResources = false;
            return;
         }
         this.FResourcesText = param1;
         if(param2 == null)
         {
            this.SketchingPerform(FParametersDefault);
         }
         else
         {
            this.SketchingPerform(param2);
            if(FParametersExternal.EffectTextFormats.length != 0)
            {
               FParametersExternal.Clear();
            }
            FParametersExternal.Assign(param2.EffectTextFormats,param2.FormatsBeginIndex,param2.FormatsEndIndex);
         }
         FSetupResources = true;
      }
   }
}

