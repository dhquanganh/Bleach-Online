package Processors.Game.Common.Effects.Display
{
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   
   public class TEffectBaseGlow extends TEffectBase
   {
      
      protected static const DEFAULT_Color_GlowFilter:uint = 0;
      
      protected static const DEFAULT_Alpha:uint = 1;
      
      protected static const SPEED:Number = 0.3;
      
      protected static const GLOWMAXWIDTH:int = 32;
      
      protected var FGlow:GlowFilter;
      
      protected var FFilterArray:Array;
      
      protected var FAngle:Number;
      
      protected var FDuration:int;
      
      public function TEffectBaseGlow()
      {
         super();
         this.FGlow = new GlowFilter(DEFAULT_Color_GlowFilter,DEFAULT_Alpha,4,4);
         this.FFilterArray = new Array();
         this.Reset();
      }
      
      protected function Action() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = (Math.sin(this.FAngle) + 1) / 2 * GLOWMAXWIDTH;
         this.FGlow.blurX = _loc1_;
         this.FGlow.blurY = _loc1_;
         FSource.filters = this.FFilterArray;
         this.FAngle += SPEED;
      }
      
      public function SetParameters(param1:DisplayObject, param2:uint, param3:Number, param4:int = -1, param5:Function = null) : void
      {
         FSource = param1;
         this.FGlow.color = param2;
         this.FGlow.alpha = param3;
         this.FDuration = param4;
         FCallBack = param5;
      }
      
      override public function Reset() : void
      {
         FIsRunOver = false;
         this.FAngle = 0;
         this.FFilterArray.push(this.FGlow);
      }
      
      override public function Run() : void
      {
         if(!FIsRunOver)
         {
            FIsRunOver = true;
         }
         this.Action();
      }
      
      public function Stop() : void
      {
         if(FSource != null)
         {
            FSource.filters = [];
            this.FFilterArray.length = 0;
            this.Reset();
         }
         if(FCallBack != null)
         {
            FCallBack();
         }
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

