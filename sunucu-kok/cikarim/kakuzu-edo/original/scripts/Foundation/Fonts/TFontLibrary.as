package Foundation.Fonts
{
   import Foundation.Utilities.TUtilityReflection;
   import Resources.Constants.*;
   import flash.text.*;
   
   public class TFontLibrary
   {
      
      protected var FFontClass:Class;
      
      protected var FFontsName:Array;
      
      public function TFontLibrary()
      {
         super();
         this.Initialization();
         SFontCore.InitFont();
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         _loc2_ = int(CONST_FONTLIBRARY.FONT_CLASSNAMES.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = CONST_FONTLIBRARY.FONT_CLASSNAMES[_loc1_];
            this.FFontClass = TUtilityReflection.GetClass(_loc3_) as Class;
            if(this.FFontClass != null)
            {
               Font.registerFont(this.FFontClass);
            }
            _loc1_++;
         }
         _loc4_ = new Array();
         _loc4_ = Font.enumerateFonts(true);
      }
   }
}

