package Processors.Game.Common.Effects.Common
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementCartisian;
   import Foundation.Movements.TMovementLinear;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import flash.filters.BlurFilter;
   import ghostcat.display.filter.FilterProxy;
   import ghostcat.operation.RepeatOper;
   import ghostcat.operation.TweenOper;
   
   public class TEffect extends TUIComponent
   {
      
      protected static const TIMING_Terminate:int = 0;
      
      protected static const TIMING_Bypass:int = 1;
      
      protected static const TIMING_Render:int = 2;
      
      protected var FTimingReferenceTick:int;
      
      protected var FTimingTick:int;
      
      protected var FPauseTicks:int;
      
      protected var FPauseSustainTicks:int;
      
      protected var FMovementEffect:TMovementCartisian;
      
      protected var FSetupResources:Boolean;
      
      protected var FSetupMovement:Boolean;
      
      protected var FIsShakeEffect:Boolean;
      
      protected var FFilterProxy:FilterProxy;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FTweenOperIn:TweenOper;
      
      protected var FTweenOperOut:TweenOper;
      
      protected var FStubReferences:TStubReferences;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FForciblyTerminate:Boolean;
      
      protected var FIsParallelOutput:Boolean;
      
      public function TEffect(param1:TUIComponent)
      {
         super(param1);
         this.ConstructEffectFields();
         this.ConstructResoucesFields();
         this.ConstructMovementFields();
         this.ConstructRenderingFileds();
         this.ConstructFilter();
         this.FStubReferences = new TStubReferences(this);
         this.FCoordinate = new TCoordinate();
         this.FIsShakeEffect = false;
         this.FForciblyTerminate = false;
      }
      
      protected function ConstructEffectFields() : void
      {
      }
      
      protected function ConstructResoucesFields() : void
      {
      }
      
      protected function ConstructMovementFields() : void
      {
         this.FMovementEffect = new TMovementCartisian();
      }
      
      protected function ConstructRenderingFileds() : void
      {
      }
      
      protected function ConstructFilter() : void
      {
         this.FFilterProxy = new FilterProxy(new BlurFilter(0,0));
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperIn = new TweenOper();
         this.FTweenOperOut = new TweenOper();
      }
      
      protected function TimingPerform() : int
      {
         this.FTimingTick = STimingCore.TickCount - this.FTimingReferenceTick;
         if(this.FTimingTick >= this.FPauseTicks && this.FTimingTick <= this.FPauseTicks + this.FPauseSustainTicks)
         {
            this.FTimingTick = this.FPauseTicks;
         }
         else if(this.FTimingTick > this.FPauseTicks + this.FPauseSustainTicks)
         {
            this.FTimingTick -= this.FPauseSustainTicks;
         }
         return this.TimingPerform_Effect();
      }
      
      protected function TimingPerform_Effect() : int
      {
         return TIMING_Terminate;
      }
      
      protected function MovementPerform() : void
      {
         this.MovementPerform_Effect();
      }
      
      protected function MovementPerform_Effect() : void
      {
         this.FMovementEffect.Move(this.FTimingTick);
         this.FMovementEffect.FlushCoordinate(this.FCoordinate);
      }
      
      protected function RenderingPerform() : Boolean
      {
         return this.RenderingPerform_Effect();
      }
      
      protected function RenderingPerform_Effect() : Boolean
      {
         return false;
      }
      
      protected function SetupReady() : Boolean
      {
         return this.FSetupMovement && this.FSetupResources;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get TimingTick() : int
      {
         return this.FTimingTick;
      }
      
      public function set TimingTick(param1:int) : void
      {
         this.FTimingTick = param1;
      }
      
      public function get SourceY() : Number
      {
         return (this.FMovementEffect as TMovementLinear).SourceY;
      }
      
      public function set SourceY(param1:Number) : void
      {
         (this.FMovementEffect as TMovementLinear).SourceY = param1;
      }
      
      public function get IsParallelOutput() : Boolean
      {
         return this.FIsParallelOutput;
      }
      
      public function set IsParallelOutput(param1:Boolean) : void
      {
         this.FIsParallelOutput = param1;
      }
      
      public function Reset() : void
      {
         FTag = 0;
         this.FTimingReferenceTick = 0;
         this.FTimingTick = 0;
         this.FIsShakeEffect = false;
         this.FPauseTicks = 0;
         this.FPauseSustainTicks = 0;
         this.FSetupResources = false;
         this.FSetupMovement = false;
         this.FForciblyTerminate = false;
      }
      
      public function Render() : Boolean
      {
         var _loc1_:int = 0;
         if(!this.SetupReady())
         {
            return false;
         }
         _loc1_ = this.TimingPerform();
         if(this.FForciblyTerminate)
         {
            _loc1_ = TIMING_Terminate;
         }
         switch(_loc1_)
         {
            case TIMING_Terminate:
               return false;
            case TIMING_Bypass:
               return true;
            case TIMING_Render:
               this.MovementPerform();
               return this.RenderingPerform();
            default:
               return false;
         }
      }
      
      public function TerminateMovement() : void
      {
      }
   }
}

