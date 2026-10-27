package Components.ScrollBar
{
   import Foundation.UI.TUIComponent;
   import Processors.TProcessor;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class TScrollBarSimple extends TProcessor
   {
      
      protected static const SPEED:Number = 5;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FBTN_Up:MovieClip;
      
      protected var FBTN_Down:MovieClip;
      
      protected var FTextField:TScrollTextField;
      
      protected var FActiveLength:Number;
      
      protected var FRect:Rectangle;
      
      protected var FDraging:Boolean;
      
      public function TScrollBarSimple(param1:TUIComponent, param2:MovieClip, param3:MovieClip, param4:MovieClip, param5:int, param6:TScrollTextField)
      {
         super(param1);
         this.FMC_Bar = param2;
         this.FBTN_Up = param3;
         this.FBTN_Down = param4;
         this.FActiveLength = param5;
         this.FRect = new Rectangle(this.FMC_Bar.x,param3.y + param3.height,0,this.FActiveLength);
         this.FTextField = param6;
         this.Location();
      }
      
      protected function Location() : void
      {
         this.FMC_Bar.addEventListener(MouseEvent.MOUSE_DOWN,this.BarStartDrag);
         this.FBTN_Up.addEventListener(MouseEvent.CLICK,this.BtnDownClick);
         this.FBTN_Down.addEventListener(MouseEvent.CLICK,this.BtnUpClick);
         this.FMC_Bar.buttonMode = true;
         this.FBTN_Up.buttonMode = true;
         this.FBTN_Down.buttonMode = true;
         this.FTextField.OnResetHtmlText = this.ChangeContent;
         this.FTextField.OnAppendHtmlText = this.ChangeContent;
      }
      
      protected function ScrollTextField() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc1_ = this.FMC_Bar.y - this.FBTN_Up.y - this.FBTN_Up.height;
         _loc2_ = _loc1_ / this.FActiveLength;
         this.FTextField.SetScrool(_loc2_);
      }
      
      protected function TextFieldStateSetScroolBar() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this.FTextField.MaxScrollV == 1)
         {
            this.FMC_Bar.y = this.FBTN_Up.y + this.FBTN_Up.height;
         }
         else
         {
            _loc1_ = (this.FTextField.ScrollV - 1) / (this.FTextField.MaxScrollV - 1);
            _loc2_ = this.FActiveLength * _loc1_;
            this.FMC_Bar.y = this.FBTN_Up.y + this.FBTN_Up.height + _loc2_;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         if(this.FDraging == true)
         {
            this.ScrollTextField();
         }
      }
      
      protected function BarStartDrag(param1:MouseEvent) : void
      {
         this.FMC_Bar.startDrag(false,this.FRect);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.ScrollBarMouseUp);
         this.FDraging = true;
      }
      
      protected function ScrollBarMouseUp(param1:MouseEvent) : void
      {
         this.FDraging = false;
         this.FMC_Bar.stopDrag();
      }
      
      protected function BtnDownClick(param1:MouseEvent) : void
      {
         this.FMC_Bar.y -= SPEED;
         if(this.FMC_Bar.y < this.FBTN_Up.y + this.FBTN_Up.height)
         {
            this.FMC_Bar.y = this.FBTN_Up.y + this.FBTN_Up.height;
         }
         this.ScrollTextField();
      }
      
      protected function BtnUpClick(param1:MouseEvent) : void
      {
         this.FMC_Bar.y += SPEED;
         if(this.FMC_Bar.y - this.FBTN_Up.y - this.FBTN_Up.height > this.FActiveLength)
         {
            this.FMC_Bar.y = this.FActiveLength + this.FBTN_Up.y + this.FBTN_Up.height;
         }
         this.ScrollTextField();
      }
      
      protected function TextFieldScroolByMouseWheel() : void
      {
         this.TextFieldStateSetScroolBar();
      }
      
      protected function ChangeContent() : void
      {
         this.TextFieldStateSetScroolBar();
      }
      
      public function Update() : void
      {
         if(this.FDraging == true)
         {
            this.ScrollTextField();
         }
      }
   }
}

