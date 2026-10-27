package
{
   import Foundation.Fonts.SFontCore;
   import Foundation.Fonts.TFont;
   import Foundation.Utilities.TUtilityString;
   import Resources.Constants.CONST_RENDERING;
   import flash.geom.Rectangle;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TStringGeometer
   {
      
      public static const TEXTFIELD_GutterX:int = CONST_RENDERING.TEXTFIELD_GutterX;
      
      public static const TEXTFIELD_GutterY:int = CONST_RENDERING.TEXTFIELD_GutterY;
      
      protected var FTextFormat:TextFormat;
      
      protected var FTextField:TextField;
      
      public function TStringGeometer()
      {
         super();
         this.FTextFormat = new TextFormat();
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function CharIndexByXCompact(param1:String, param2:TFont, param3:int, param4:Boolean = true) : int
      {
         return this.CharIndexByXTextField(param1,param2,param3 + TEXTFIELD_GutterX,param4);
      }
      
      public function CharIndexByXTextField(param1:String, param2:TFont, param3:int, param4:Boolean = true) : int
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Rectangle = null;
         if(TUtilityString.Empty(param1))
         {
            return 0;
         }
         if(param3 < TEXTFIELD_GutterX)
         {
            return 0;
         }
         _loc10_ = param1.length;
         param2.FlushTextFormat(this.FTextFormat);
         this.FTextField.text = "";
         this.FTextField.embedFonts = SFontCore.FontEmbedded(param2.Name);
         this.FTextField.defaultTextFormat = this.FTextFormat;
         this.FTextField.text = param1;
         _loc5_ = this.FTextField.width;
         if(param3 >= _loc5_)
         {
            return _loc10_;
         }
         _loc5_ = Math.round(this.FTextField.textWidth);
         _loc6_ = Math.round(this.FTextField.textHeight);
         _loc9_ = this.FTextField.numLines;
         _loc7_ = param3;
         if(_loc9_ != 0)
         {
            _loc8_ = _loc6_ / (_loc9_ * 2) + TEXTFIELD_GutterY;
         }
         else
         {
            _loc8_ = 0;
         }
         _loc11_ = this.FTextField.getCharIndexAtPoint(_loc7_,_loc8_);
         if(_loc11_ < 0)
         {
            return _loc10_;
         }
         if(param4)
         {
            _loc13_ = this.FTextField.getCharBoundaries(_loc11_);
            if(_loc7_ >= _loc13_.x + _loc13_.width / 2)
            {
               _loc11_++;
            }
         }
         return _loc11_;
      }
      
      public function XCompactByIndex(param1:String, param2:TFont, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         if(TUtilityString.Empty(param1))
         {
            return 0;
         }
         if(param3 <= 0)
         {
            return 0;
         }
         _loc4_ = param1.length;
         _loc5_ = param1.substr(0,param3);
         param2.FlushTextFormat(this.FTextFormat);
         this.FTextField.text = "";
         this.FTextField.embedFonts = SFontCore.FontEmbedded(param2.Name);
         this.FTextField.defaultTextFormat = this.FTextFormat;
         this.FTextField.text = _loc5_;
         _loc6_ = this.FTextField.width;
         return int(this.FTextField.textWidth);
      }
   }
}

