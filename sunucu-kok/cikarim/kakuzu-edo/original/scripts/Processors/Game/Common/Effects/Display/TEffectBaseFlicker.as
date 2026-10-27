package Processors.Game.Common.Effects.Display
{
   import flash.display.DisplayObject;
   import flash.text.TextField;
   
   public class TEffectBaseFlicker extends TEffectBase
   {
      
      protected var FFlickerPeriod:uint;
      
      protected var FDefaultColor:uint;
      
      protected var FColorStart:uint;
      
      protected var FFrameNum:int;
      
      public function TEffectBaseFlicker()
      {
         super();
         this.Reset();
      }
      
      protected function SetColor(param1:uint) : void
      {
         if(FSource != null)
         {
            this.FDefaultColor = (FSource as TextField).textColor;
         }
         if(this.FDefaultColor != 16777215)
         {
            this.FColorStart = param1;
         }
         else
         {
            this.FColorStart = 4294936064;
         }
      }
      
      protected function InitSpeed() : void
      {
         this.FFlickerPeriod = 10;
      }
      
      protected function OverAction() : void
      {
         FIsRunOver = true;
         (FSource as TextField).textColor = this.FDefaultColor;
         if(FCallBack != null)
         {
            FCallBack();
         }
      }
      
      public function Action() : void
      {
         var _loc1_:uint = 0;
         --this.FFrameNum;
         if(this.FFrameNum < 0)
         {
            this.OverAction();
         }
         else
         {
            if(this.FFrameNum % this.FFlickerPeriod <= this.FFlickerPeriod / 2)
            {
               _loc1_ = this.FColorStart;
            }
            else
            {
               _loc1_ = this.FDefaultColor;
            }
            (FSource as TextField).textColor = _loc1_;
         }
      }
      
      public function get FrameNum() : int
      {
         return this.FFrameNum;
      }
      
      public function set FrameNum(param1:int) : void
      {
         this.FFrameNum = param1;
      }
      
      public function get ColorStart() : Number
      {
         return this.FColorStart;
      }
      
      public function set ColorStart(param1:Number) : void
      {
         this.FColorStart = param1;
      }
      
      public function SetParameters(param1:DisplayObject, param2:Number = 4294967295, param3:int = 60, param4:Function = null) : void
      {
         FSource = param1;
         this.FFrameNum = param3;
         FCallBack = param4;
         this.SetColor(param2);
         this.InitSpeed();
         FIsRunOver = false;
      }
      
      override public function Reset() : void
      {
         FIsRunOver = true;
         this.SetColor(this.FColorStart);
         this.InitSpeed();
      }
      
      override public function Run() : void
      {
         this.Action();
      }
      
      override public function Dispose() : void
      {
         FSource = null;
      }
   }
}

