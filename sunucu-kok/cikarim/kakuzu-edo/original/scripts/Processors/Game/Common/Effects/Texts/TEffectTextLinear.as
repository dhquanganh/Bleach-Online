package Processors.Game.Common.Effects.Texts
{
   import Foundation.Common.TCoordinate;
   import Foundation.Movements.TMovementLinear;
   import Foundation.UI.TUIComponent;
   
   public class TEffectTextLinear extends TEffectText
   {
      
      protected var FTimingDurationTicks:int;
      
      public function TEffectTextLinear(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ConstructMovementFields() : void
      {
         FMovementEffect = new TMovementLinear();
      }
      
      override protected function TimingPerform_Effect() : int
      {
         if(FTimingTick < 0)
         {
            return TIMING_Bypass;
         }
         if(FTimingTick >= this.FTimingDurationTicks)
         {
            return TIMING_Terminate;
         }
         return TIMING_Render;
      }
      
      public function SetupMovement(param1:TCoordinate, param2:int, param3:int, param4:Number, param5:Number, param6:int, param7:int) : void
      {
         FTimingReferenceTick = param2;
         this.FTimingDurationTicks = param3;
         (FMovementEffect as TMovementLinear).SetupRay(param1.X,param1.Y,param4,param5,param6,param7);
         FSetupMovement = true;
      }
   }
}

