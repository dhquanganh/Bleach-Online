package Processors.Game.Common.Effects.Display
{
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   
   public class TEffectBaseGlowTwo extends TEffectBase
   {
      
      protected static const DEFAULT_Color_GlowFilter:uint = 0;
      
      protected static const DEFAULT_Alpha:uint = 1;
      
      protected static const SPEED:Number = 0.05;
      
      protected var FGlow:GlowFilter;
      
      protected var FFilterArray:Array;
      
      protected var FAngle:Number;
      
      protected var FDuration:int;
      
      public function TEffectBaseGlowTwo()
      {
         super();
         this.FGlow = new GlowFilter(DEFAULT_Color_GlowFilter,DEFAULT_Alpha,4,4);
         this.FFilterArray = new Array();
         this.Reset();
      }
      
      protected function Action() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = (Math.sin(this.FAngle) + 1) / 2;
         this.FGlow.alpha = _loc1_;
         FSource.filters = this.FFilterArray;
         this.FAngle += SPEED;
      }
      
      public function SetParameters(param1:DisplayObject, param2:uint, param3:int, param4:int) : void
      {
         FSource = param1;
         this.FGlow.color = param2;
         this.FGlow.blurX = param3;
         this.FGlow.blurY = param3;
         this.FGlow.strength = param4;
      }
      
      override public function Reset() : void
      {
         FIsRunOver = false;
         this.FAngle = 0;
         this.FFilterArray.push(this.FGlow);
      }
      
      public function Stop() : void
      {
         if(FSource != null)
         {
            FSource.filters = null;
         }
         FIsRunOver = true;
      }
      
      override public function Run() : void
      {
         this.Action();
      }
      
      override public function Dispose() : void
      {
         FSource = null;
         this.FGlow = null;
         this.FFilterArray.length = 0;
         this.FAngle = 0;
      }
   }
}

