package Processors.Game.Common.Effects.Texts
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementCrossfade;
   import Foundation.Movements.TMovementLinear;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import ghostcat.util.easing.Cubic;
   
   public class TEffectTextLinearCrossfade extends TEffectText
   {
      
      protected var FMovementCrossfade:TMovementCrossfade;
      
      protected var FRenderingCoordinateRendering:TCoordinate;
      
      protected var FRenderingBoundsSketch:TBounds;
      
      protected var FRenderingPreviousAlpha:uint;
      
      protected var FRenderingPreviousScale:Number;
      
      public function TEffectTextLinearCrossfade(param1:TUIComponent)
      {
         super(param1);
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override protected function ConstructMovementFields() : void
      {
         FMovementEffect = new TMovementLinear();
         this.FMovementCrossfade = new TMovementCrossfade();
      }
      
      override protected function ConstructRenderingFileds() : void
      {
         super.ConstructRenderingFileds();
         this.FRenderingCoordinateRendering = new TCoordinate();
         this.FRenderingBoundsSketch = new TBounds();
         this.FRenderingPreviousAlpha = 4294967295;
         this.FRenderingPreviousScale = 1;
      }
      
      override protected function ConstructFilter() : void
      {
         super.ConstructFilter();
         FFilterProxy.applyFilter(FRenderingPainterText);
         FTweenOperIn.target = FFilterProxy;
         FTweenOperIn.duration = 80;
         FTweenOperIn.params = {
            "blurX":35,
            "blurY":0,
            "ease":Cubic.easeIn
         };
         FTweenOperOut.target = FFilterProxy;
         FTweenOperOut.duration = 100;
         FTweenOperOut.params = {
            "blurX":0,
            "blurY":0,
            "ease":Cubic.easeOut
         };
         FRepeatOper.loop = 1;
         FRepeatOper.children = [FTweenOperIn,FTweenOperOut];
      }
      
      override protected function TimingPerform_Effect() : int
      {
         if(FTimingTick < 0)
         {
            return TIMING_Bypass;
         }
         if(FTimingTick > this.FMovementCrossfade.TerminationTick + FPauseSustainTicks)
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
      
      override protected function RenderingPerform_Text() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         _loc1_ = this.FMovementCrossfade.Alpha;
         _loc2_ = this.FMovementCrossfade.Scale;
         if(_loc2_ != this.FRenderingPreviousScale)
         {
            FRenderingPainterText.scaleX = _loc2_;
            FRenderingPainterText.scaleY = _loc2_;
            FRenderingPainterText.Evaluate(this.FRenderingBoundsSketch);
            this.FRenderingPreviousScale = _loc2_;
         }
         if(_loc1_ == 255)
         {
            return super.RenderingPerform_Text();
         }
         return this.RenderingPerform_TextCrossfade(_loc1_,_loc2_);
      }
      
      protected function RenderingPerform_TextCrossfade(param1:uint, param2:Number) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param1 != this.FRenderingPreviousAlpha)
         {
            FRenderingPainterText.Evaluate(this.FRenderingBoundsSketch);
            if(FIsSetEffectTextFormat)
            {
               SetEffectTextFormat();
               FIsSetEffectTextFormat = false;
            }
            FRenderingPainterText.Alpha = param1 / 255;
            this.FRenderingPreviousAlpha = param1;
         }
         _loc3_ = this.FRenderingBoundsSketch.Width;
         _loc4_ = this.FRenderingBoundsSketch.Height;
         _loc5_ = FCoordinate.X;
         _loc6_ = FCoordinate.Y;
         switch(FAlignmentHorizontal)
         {
            case TAlignment.HORIZONTAL_Center:
               _loc5_ -= _loc3_ / 2;
               break;
            case TAlignment.HORIZONTAL_Right:
               _loc5_ -= _loc3_;
         }
         switch(FAlignmentVertical)
         {
            case TAlignment.VERTICAL_Center:
               _loc6_ -= _loc4_ / 2;
               break;
            case TAlignment.VERTICAL_Bottom:
               _loc6_ -= _loc4_;
         }
         TUtilityCartisian.CoordinateSet(this.FRenderingCoordinateRendering,_loc5_,_loc6_);
         this.X = this.FRenderingCoordinateRendering.X;
         this.Y = this.FRenderingCoordinateRendering.Y;
         return true;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FMovementCrossfade.Alpha = 0;
         this.FRenderingPreviousAlpha = 4294967295;
         this.FMovementCrossfade.Scale = 1;
         this.FRenderingPreviousScale = 1;
         this.Visible = false;
      }
      
      public function SetupMovement(param1:TCoordinate, param2:int, param3:int, param4:int, param5:int, param6:Number, param7:Number, param8:int, param9:int, param10:Boolean, param11:Boolean, param12:Boolean) : void
      {
         FTimingReferenceTick = param2;
         FPauseTicks = param8;
         FPauseSustainTicks = param9;
         FIsParallelOutput = param12;
         (FMovementEffect as TMovementLinear).SetupRay(param1.X,param1.Y,param6,param7,param8,param9);
         this.FMovementCrossfade.Setup(param3,param4,param5,param8,param9,param11);
         this.FRenderingCoordinateRendering.X = param1.X;
         this.FRenderingCoordinateRendering.Y = param1.Y;
         FSetupMovement = true;
         if(param10)
         {
            FIsShakeEffect = true;
            FRepeatOper.execute();
         }
      }
      
      override public function TerminateMovement() : void
      {
         this.Visible = false;
         FForciblyTerminate = true;
      }
   }
}

