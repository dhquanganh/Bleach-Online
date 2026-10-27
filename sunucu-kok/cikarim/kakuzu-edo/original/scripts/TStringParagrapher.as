package
{
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Utilities.*;
   import Localization.Strings.*;
   import Resources.Constants.*;
   import flash.text.*;
   
   public class TStringParagrapher
   {
      
      public static const TEXTFIELD_GutterX:int = CONST_RENDERING.TEXTFIELD_GutterX;
      
      public static const TEXTFIELD_GutterY:int = CONST_RENDERING.TEXTFIELD_GutterY;
      
      protected var FTextFormat:TextFormat;
      
      protected var FTextField:TextField;
      
      protected var FTextFieldLine:TextField;
      
      protected var FSpaceWidth:int;
      
      protected var FParagraphIndent:int;
      
      protected var FParagraphWidth:int;
      
      protected var FParagraphHeight:int;
      
      protected var FLinesCharIndex:Vector.<int>;
      
      protected var FLinesLength:Vector.<int>;
      
      protected var FLinesText:Vector.<String>;
      
      protected var FLinesCR:Vector.<Boolean>;
      
      protected var FLinesWidth:Vector.<int>;
      
      protected var FLineHeight:int;
      
      public function TStringParagrapher()
      {
         super();
         this.FTextFormat = new TextFormat();
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
         this.FTextFieldLine = new TextField();
         this.FTextFieldLine.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextFieldLine.autoSize = TextFieldAutoSize.LEFT;
         this.FLinesCharIndex = new Vector.<int>();
         this.FLinesLength = new Vector.<int>();
         this.FLinesText = new Vector.<String>();
         this.FLinesCR = new Vector.<Boolean>();
         this.FLinesWidth = new Vector.<int>();
      }
      
      protected function StringTrimCR(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.length;
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = param1.charCodeAt(_loc3_);
            if(_loc4_ != 10 && _loc4_ != 13)
            {
               return param1.substr(0,_loc3_ + 1);
            }
            _loc3_--;
         }
         return "";
      }
      
      protected function StringTrimTrailingSpaces(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.length;
         _loc3_ = int(_loc2_ - 1);
         while(_loc3_ >= 1)
         {
            _loc4_ = param1.charCodeAt(_loc3_);
            if(_loc4_ != 32)
            {
               return param1.substr(0,_loc3_ + 1);
            }
            _loc3_--;
         }
         return param1.substr(0,1);
      }
      
      protected function ParagraphingPerform(param1:String, param2:TFont, param3:int, param4:TStringParagraphParameters) : void
      {
         this.ParagraphingPerform_Initialize(param1,param2,param3,param4);
         if(TUtilityString.Empty(param1))
         {
            return;
         }
         this.ParagraphingPerform_Text(param1,param2,param3,param4);
      }
      
      protected function ParagraphingPerform_Initialize(param1:String, param2:TFont, param3:int, param4:TStringParagraphParameters) : void
      {
         param2.FlushTextFormat(this.FTextFormat);
         this.FTextFormat.indent = 0;
         this.FTextField.text = "";
         this.FTextField.embedFonts = SFontCore.FontEmbedded(param2.Name);
         this.FTextField.defaultTextFormat = this.FTextFormat;
         if(param3 == 0)
         {
            this.FTextField.wordWrap = false;
         }
         else
         {
            this.FTextField.wordWrap = true;
         }
         this.FTextFieldLine.text = "";
         this.FTextFieldLine.embedFonts = SFontCore.FontEmbedded(param2.Name);
         this.FTextFieldLine.defaultTextFormat = this.FTextFormat;
         this.FTextFieldLine.text = " ";
         if(param4 == null)
         {
            this.FParagraphIndent = 0;
         }
         else
         {
            this.FParagraphIndent = param4.Indent;
         }
         this.FParagraphWidth = 0;
         this.FParagraphHeight = 0;
         this.FLinesCharIndex.length = 0;
         this.FLinesLength.length = 0;
         this.FLinesText.length = 0;
         this.FLinesCR.length = 0;
         this.FLinesWidth.length = 0;
         this.FSpaceWidth = Math.round(this.FTextFieldLine.textWidth);
         this.FLineHeight = Math.round(this.FTextFieldLine.textHeight);
      }
      
      protected function ParagraphingPerform_Text(param1:String, param2:TFont, param3:int, param4:TStringParagraphParameters) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(param4 == null)
         {
            _loc5_ = false;
         }
         else
         {
            _loc5_ = param4.WrapTrailingSpaces;
         }
         _loc9_ = this.FParagraphIndent;
         _loc6_ = param1.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param1.substr(_loc7_);
            this.FTextFormat.indent = _loc9_;
            this.FTextField.defaultTextFormat = this.FTextFormat;
            if(param3 != 0)
            {
               if(_loc9_ == 0)
               {
                  this.FTextField.width = param3 + TEXTFIELD_GutterX * 2;
                  this.FTextField.text = _loc8_;
                  _loc11_ = this.FTextField.getLineLength(0);
                  if(_loc11_ == 0 && _loc8_.length != 0)
                  {
                     _loc11_ = _loc8_.length;
                  }
               }
               else
               {
                  this.FTextField.width = param3 + TEXTFIELD_GutterX * 2 + this.FSpaceWidth;
                  this.FTextField.text = " " + _loc8_;
                  _loc11_ = this.FTextField.getLineLength(0) - 1;
               }
            }
            else
            {
               this.FTextField.text = _loc8_;
               _loc11_ = this.FTextField.getLineLength(0);
               if(_loc11_ == 0 && _loc8_.length != 0)
               {
                  _loc11_ = _loc8_.length;
               }
            }
            if(_loc11_ > 0)
            {
               _loc13_ = this.StringTrimCR(param1.substr(_loc7_,_loc11_));
               this.FTextFieldLine.text = _loc13_;
               _loc12_ = Math.round(this.FTextFieldLine.textWidth);
               _loc8_ = null;
            }
            else
            {
               _loc13_ = "";
               _loc12_ = 0;
            }
            if(param3 != 0)
            {
               _loc10_ = param3 - _loc9_;
               if(_loc10_ < 0)
               {
                  _loc10_ = 0;
               }
               if(_loc5_ && _loc12_ > _loc10_)
               {
                  _loc14_ = this.FTextFieldLine.width;
                  _loc14_ = this.FTextFieldLine.getCharIndexAtPoint(_loc10_ + TEXTFIELD_GutterX,this.FLineHeight / 2 + TEXTFIELD_GutterY);
                  if(_loc14_ == 0)
                  {
                     _loc14_ = 1;
                  }
                  while(_loc14_ < _loc11_)
                  {
                     _loc15_ = _loc13_.charCodeAt(_loc14_);
                     if(_loc15_ == 32)
                     {
                        _loc13_ = _loc13_.substr(0,_loc14_);
                        _loc11_ = _loc13_.length;
                        this.FTextFieldLine.text = _loc13_;
                        _loc12_ = Math.round(this.FTextFieldLine.textWidth);
                        break;
                     }
                     _loc14_++;
                  }
               }
               if(_loc12_ > _loc10_)
               {
                  _loc12_ = _loc10_;
               }
            }
            this.FLinesCharIndex.push(_loc7_);
            this.FLinesLength.push(_loc11_);
            this.FLinesText.push(_loc13_);
            this.FLinesCR.push(_loc11_ != _loc13_.length);
            this.FLinesWidth.push(_loc12_);
            _loc12_ += _loc9_;
            if(_loc12_ > this.FParagraphWidth)
            {
               this.FParagraphWidth = _loc12_;
            }
            this.FParagraphHeight += this.FLineHeight;
            _loc9_ = 0;
            _loc7_ += _loc11_;
         }
      }
      
      public function get ParagraphIndent() : int
      {
         return this.FParagraphIndent;
      }
      
      public function get ParagraphWidth() : int
      {
         return this.FParagraphWidth;
      }
      
      public function get ParagraphHeight() : int
      {
         return this.FParagraphHeight;
      }
      
      public function get Count() : int
      {
         return this.FLinesText.length;
      }
      
      public function GetLineCharIndexByIndex(param1:int) : int
      {
         return this.FLinesCharIndex[param1];
      }
      
      public function GetLineLengthByIndex(param1:int) : int
      {
         return this.FLinesLength[param1];
      }
      
      public function GetLineTextByIndex(param1:int) : String
      {
         return this.FLinesText[param1];
      }
      
      public function GetLineXByIndex(param1:int) : int
      {
         if(param1 == 0)
         {
            return this.FParagraphIndent;
         }
         return 0;
      }
      
      public function GetLineYByIndex(param1:int) : int
      {
         if(param1 < 0 || param1 >= this.FLinesText.length)
         {
            return -1;
         }
         return param1 * this.FLineHeight;
      }
      
      public function GetLineWidthByIndex(param1:int) : int
      {
         return this.FLinesWidth[param1];
      }
      
      public function GetLineHeightByIndex(param1:int) : int
      {
         return this.FLineHeight;
      }
      
      public function GetLineCRByIndex(param1:int) : Boolean
      {
         return this.FLinesCR[param1];
      }
      
      public function Paragraph(param1:String, param2:TFont, param3:int, param4:TStringParagraphParameters = null) : void
      {
         this.ParagraphingPerform(param1,param2,param3,param4);
      }
      
      public function GetLineIndexByY(param1:int) : int
      {
         var _loc2_:int = 0;
         if(param1 < 0)
         {
            return -1;
         }
         _loc2_ = param1 / this.FLineHeight;
         if(_loc2_ < this.FLinesText.length)
         {
            return _loc2_;
         }
         return -1;
      }
   }
}

