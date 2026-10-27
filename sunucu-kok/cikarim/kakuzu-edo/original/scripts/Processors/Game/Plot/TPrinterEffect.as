package Processors.Game.Plot
{
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_COMMON;
   import flash.text.TextField;
   
   public class TPrinterEffect extends TUIComponent
   {
      
      protected static const Speed_Printer:int = 100;
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      protected var FTextContains:TextField;
      
      protected var FTextInfo:String;
      
      protected var FPrinterIndex:int;
      
      protected var StartTime:uint;
      
      protected var FIsPrinterEnd:Boolean;
      
      protected var FColorBefor:Vector.<uint>;
      
      protected var FColorEnd:Vector.<uint>;
      
      protected var FColor:Vector.<String>;
      
      protected var FOnEndPrinter:Function;
      
      public function TPrinterEffect(param1:TUIComponent)
      {
         super(param1);
         this.FIsPrinterEnd = true;
         this.FColorBefor = new Vector.<uint>();
         this.FColorEnd = new Vector.<uint>();
         this.FColor = new Vector.<String>();
      }
      
      protected function NextPrinter() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.FTextContains == null)
         {
            return;
         }
         _loc5_ = 0;
         _loc6_ = 0;
         _loc3_ = this.FTextInfo.substring(0,this.FPrinterIndex);
         _loc1_ = int(this.FPrinterIndex - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = int(this.FColorBefor.length - 1);
            while(_loc2_ >= 0)
            {
               if(_loc1_ == this.FColorBefor[_loc2_])
               {
                  _loc4_ = _loc3_.substring(_loc1_);
                  _loc3_ = _loc3_.substring(0,_loc1_) + "<font color=\'#" + this.FColor[_loc2_] + "\'>";
                  _loc3_ += _loc4_;
                  _loc5_++;
               }
               else if(_loc1_ == this.FColorEnd[_loc2_])
               {
                  _loc4_ = _loc3_.substring(_loc1_);
                  _loc3_ = _loc3_.substring(0,_loc1_) + "</font>";
                  _loc3_ += _loc4_;
                  _loc6_++;
               }
               _loc2_--;
            }
            _loc1_--;
         }
         if(_loc5_ != _loc6_)
         {
            _loc3_ += "</font>";
         }
         this.FTextContains.htmlText = _loc3_;
         ++this.FPrinterIndex;
      }
      
      protected function ShowAllText() : void
      {
         this.FPrinterIndex = this.FTextInfo.length;
         this.NextPrinter();
      }
      
      protected function FomatText(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         this.FColorBefor.length = 0;
         this.FColorEnd.length = 0;
         this.FColor.length = 0;
         _loc3_ = param1.split("$");
         this.FTextInfo = "";
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.FTextInfo += _loc3_[_loc2_];
            _loc6_ = _loc3_[_loc2_ + 1];
            if(_loc6_ != null)
            {
               _loc4_ = uint(this.FTextInfo.length);
               _loc5_ = this.FTextInfo.length + _loc6_.length - 6;
               this.FColor.push(_loc6_.substring(0,6));
               this.FTextInfo += _loc6_.substring(6);
               this.FColorBefor.push(_loc4_);
               this.FColorEnd.push(_loc5_);
            }
            _loc2_ += 2;
         }
      }
      
      public function get OnEndPrinter() : Function
      {
         return this.FOnEndPrinter;
      }
      
      public function set OnEndPrinter(param1:Function) : void
      {
         this.FOnEndPrinter = param1;
      }
      
      public function get IsPrinterEnd() : Boolean
      {
         return this.FIsPrinterEnd;
      }
      
      public function OnShowAllText() : void
      {
         if(this.FIsPrinterEnd)
         {
            return;
         }
         this.FIsPrinterEnd = true;
         this.ShowAllText();
      }
      
      public function Clear() : void
      {
         this.FTextContains.text = "";
      }
      
      public function SetTextContains(param1:TextField) : void
      {
         this.FTextContains = param1;
      }
      
      public function SetTextInfo(param1:String) : void
      {
         if(this.FTextContains == null)
         {
            return;
         }
         this.FTextContains.text = "";
         this.FomatText(param1);
         this.FPrinterIndex = 0;
         this.StartTime = 0;
         this.FIsPrinterEnd = false;
      }
      
      public function CheckTimingByFrame() : void
      {
         if(this.FIsPrinterEnd)
         {
            return;
         }
         if(this.FPrinterIndex > this.FTextInfo.length)
         {
            this.FIsPrinterEnd = true;
            if(this.FOnEndPrinter != null)
            {
               this.FOnEndPrinter(this);
            }
            return;
         }
         this.StartTime += SIZE_FrameRatePerSecond;
         if(this.StartTime > Speed_Printer)
         {
            this.StartTime -= Speed_Printer;
            this.NextPrinter();
         }
      }
   }
}

