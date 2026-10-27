package Processors.Accessories.Performance
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TProcessorWindowProfiler extends TUIComponent
   {
      
      private static const FORMAT_INFO:String = "Platform: %0   |   Version: %1   |   %2   |   SSD: %3   |   CSD: %4   |   Current Fps %5   |   Average Fps %6   |   Memory Used %7 Mb";
      
      private var FTFMinFps:TextField;
      
      private var FTFMaxFps:TextField;
      
      private var FTFMinMem:TextField;
      
      private var FTFMaxMem:TextField;
      
      private var FTFInfo:TextField;
      
      private var FShapeBox:Shape;
      
      private var FShapeFps:Shape;
      
      private var FShapeMb:Shape;
      
      public function TProcessorWindowProfiler(param1:TUIComponent)
      {
         var _loc2_:TextFormat = null;
         super(param1);
         this.FShapeFps = new Shape();
         this.FShapeMb = new Shape();
         this.FShapeBox = new Shape();
         addChild(this.FShapeBox);
         addChild(this.FShapeFps);
         addChild(this.FShapeMb);
         this.FShapeFps.x = 65;
         this.FShapeFps.y = 45;
         this.FShapeMb.x = 65;
         this.FShapeMb.y = 90;
         _loc2_ = new TextFormat(CONST_COMMON.FONT_DefaultName,CONST_COMMON.FONT_DefaultSize - 2,11184810);
         this.FTFInfo = this.ConstructTextField(this,_loc2_,0,98);
         this.FTFInfo.defaultTextFormat = new TextFormat(CONST_COMMON.FONT_DefaultName,CONST_COMMON.FONT_DefaultSize,13421772);
         this.FTFMaxFps = this.ConstructTextField(this,_loc2_,7,5);
         this.FTFMinFps = this.ConstructTextField(this,_loc2_,7,37);
         this.FTFMaxMem = this.ConstructTextField(this,_loc2_,7,50);
         this.FTFMinMem = this.ConstructTextField(this,_loc2_,7,83);
      }
      
      protected function ConstructTextField(param1:TUIComponent, param2:TextFormat, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:String = "left") : TextField
      {
         var _loc8_:TextField = null;
         _loc8_ = new TextField();
         _loc8_.defaultTextFormat = param2;
         _loc8_.x = param3;
         _loc8_.y = param4;
         _loc8_.width = param5;
         _loc8_.height = param6;
         _loc8_.autoSize = param7;
         param1.addChild(_loc8_);
         return _loc8_;
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Graphics = null;
         if(!this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         _loc3_ = this.FShapeBox.graphics;
         _loc3_.clear();
         _loc3_.beginFill(0,0.5);
         _loc3_.drawRect(0,0,_loc1_,120);
         _loc3_.lineStyle(1,16777215,0.2);
         _loc3_.moveTo(65,45);
         _loc3_.lineTo(65,10);
         _loc3_.moveTo(65,45);
         _loc3_.lineTo(_loc1_ - 15,45);
         _loc3_.moveTo(65,90);
         _loc3_.lineTo(65,55);
         _loc3_.moveTo(65,90);
         _loc3_.lineTo(_loc1_ - 15,90);
         _loc3_.endFill();
         this.FTFInfo.x = 65;
      }
      
      public function Update(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:String, param8:String, param9:Number, param10:Number, param11:Number, param12:Array, param13:Array, param14:int, param15:String, param16:String) : void
      {
         var _loc17_:Number = NaN;
         var _loc18_:Graphics = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         if(param2 >= 1)
         {
            this.FTFMaxFps.text = param4.toFixed(3) + " Fps";
            this.FTFMinFps.text = param3.toFixed(3) + " Fps";
            this.FTFMaxMem.text = param6.toFixed(3) + " Mb";
            this.FTFMinMem.text = param5.toFixed(3) + " Mb";
         }
         this.FTFInfo.text = TUtilityString.Format(FORMAT_INFO,param15,param16,param1,param7,param8,param9.toFixed(3),param11.toFixed(3),param10.toFixed(3));
         this.FTFInfo.x = 65;
         _loc18_ = this.FShapeFps.graphics;
         _loc18_.clear();
         _loc18_.lineStyle(1,3407616,0.7);
         _loc19_ = 0;
         _loc20_ = int(param12.length);
         _loc22_ = 35;
         _loc21_ = FUICore.StageWidth - 80;
         _loc23_ = _loc21_ / (param14 - 1);
         _loc24_ = param4 - param3;
         while(_loc19_ < _loc20_)
         {
            _loc17_ = (param12[_loc19_] - param3) / _loc24_;
            if(_loc19_ == 0)
            {
               _loc18_.moveTo(0,-_loc17_ * _loc22_);
            }
            else
            {
               _loc18_.lineTo(_loc19_ * _loc23_,-_loc17_ * _loc22_);
            }
            _loc19_++;
         }
         _loc18_ = this.FShapeMb.graphics;
         _loc18_.clear();
         _loc18_.lineStyle(1,26367,0.7);
         _loc19_ = 0;
         _loc20_ = int(param13.length);
         _loc24_ = param6 - param5;
         _loc19_ = 0;
         while(_loc19_ < _loc20_)
         {
            _loc17_ = (param13[_loc19_] - param5) / _loc24_;
            if(_loc19_ == 0)
            {
               _loc18_.moveTo(0,-_loc17_ * _loc22_);
            }
            else
            {
               _loc18_.lineTo(_loc19_ * _loc23_,-_loc17_ * _loc22_);
            }
            _loc19_++;
         }
      }
   }
}

