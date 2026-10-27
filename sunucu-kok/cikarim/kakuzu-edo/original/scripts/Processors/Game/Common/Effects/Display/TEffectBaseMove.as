package Processors.Game.Common.Effects.Display
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class TEffectBaseMove extends TEffectBase
   {
      
      protected var FVX:Number;
      
      protected var FVY:Number;
      
      protected var FMoveDisplay:DisplayObject;
      
      protected var FStartPoint:Point;
      
      protected var FEndPoint:Point;
      
      protected var FFrameNum:int;
      
      protected var FCurrentCoordinate:Point;
      
      public function TEffectBaseMove(param1:DisplayObject, param2:Point, param3:Point, param4:int = 20, param5:Function = null)
      {
         super();
         FCallBack = param5;
         this.FMoveDisplay = param1;
         this.FStartPoint = param2;
         this.FEndPoint = param3;
         this.FFrameNum = param4;
         this.FCurrentCoordinate = new Point();
         this.Reset();
      }
      
      protected function InitSpeed() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = this.FEndPoint.x - this.FStartPoint.x;
         _loc2_ = this.FEndPoint.y - this.FStartPoint.y;
         if(this.FFrameNum <= 0)
         {
            this.FVX = 0;
            this.FVY = 0;
         }
         else
         {
            this.FVX = _loc1_ / this.FFrameNum;
            this.FVY = _loc2_ / this.FFrameNum;
         }
      }
      
      protected function InitCurrentCoordinate(param1:Point) : void
      {
         this.FCurrentCoordinate.x = param1.x;
         this.FCurrentCoordinate.y = param1.y;
      }
      
      protected function Action() : void
      {
         --this.FFrameNum;
         if(this.FFrameNum < 0)
         {
            this.OverAction();
         }
         else
         {
            this.FCurrentCoordinate.x += this.FVX;
            this.FCurrentCoordinate.y += this.FVY;
            this.FMoveDisplay.x = this.FCurrentCoordinate.x;
            this.FMoveDisplay.y = this.FCurrentCoordinate.y;
         }
      }
      
      protected function OverAction() : void
      {
         FIsRunOver = true;
         if(FCallBack != null)
         {
            FCallBack();
         }
      }
      
      public function set display(param1:DisplayObject) : void
      {
         this.FMoveDisplay = param1;
      }
      
      public function set StartPoint(param1:Point) : void
      {
         this.FStartPoint = param1;
      }
      
      public function set EndPoint(param1:Point) : void
      {
         this.FEndPoint = param1;
      }
      
      public function set FrameNum(param1:int) : void
      {
         this.FFrameNum = param1;
      }
      
      override public function Run() : void
      {
         this.Action();
      }
      
      override public function Reset() : void
      {
         FIsRunOver = false;
         MoveToPosition(this.FMoveDisplay,this.FStartPoint);
         this.InitCurrentCoordinate(this.FStartPoint);
         this.InitSpeed();
      }
   }
}

