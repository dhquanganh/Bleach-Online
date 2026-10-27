package Foundation.Fonts
{
   import Foundation.Common.Spaces.CommonSpace;
   import Foundation.Common.Stubs.TStubModification;
   import Resources.Constants.CONST_COMMON;
   import flash.text.TextFormat;
   
   use namespace CommonSpace;
   
   public class TFont
   {
      
      protected var FStubModification:TStubModification;
      
      CommonSpace var FName:String;
      
      CommonSpace var FSize:int;
      
      CommonSpace var FColor:uint;
      
      CommonSpace var FBold:Boolean;
      
      CommonSpace var FItalic:Boolean;
      
      CommonSpace var FUnderline:Boolean;
      
      CommonSpace var FLetterSpacing:uint;
      
      CommonSpace var FLeading:uint;
      
      public function TFont(param1:TStubModification = null)
      {
         super();
         this.FStubModification = param1;
         this.FName = CONST_COMMON.FONT_DefaultName;
         this.FSize = CONST_COMMON.FONT_DefaultSize;
         this.FColor = 4294967295;
         this.FBold = false;
         this.FItalic = false;
         this.FUnderline = false;
         this.FLetterSpacing = 1;
         this.FLeading = 1;
      }
      
      protected function ModificationUpdate() : void
      {
         if(this.FStubModification != null)
         {
            this.FStubModification.Modified = true;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         if(param1 != this.FName)
         {
            this.FName = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Size() : int
      {
         return this.FSize;
      }
      
      public function set Size(param1:int) : void
      {
         if(param1 != this.FSize)
         {
            this.FSize = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Color() : uint
      {
         return this.FColor;
      }
      
      public function set Color(param1:uint) : void
      {
         if(param1 != this.FColor)
         {
            this.FColor = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Bold() : Boolean
      {
         return this.FBold;
      }
      
      public function set Bold(param1:Boolean) : void
      {
         if(param1 != this.FBold)
         {
            this.FBold = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Italic() : Boolean
      {
         return this.FItalic;
      }
      
      public function set Italic(param1:Boolean) : void
      {
         if(param1 != this.FItalic)
         {
            this.FItalic = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Underline() : Boolean
      {
         return this.FUnderline;
      }
      
      public function set Underline(param1:Boolean) : void
      {
         if(param1 != this.FUnderline)
         {
            this.FUnderline = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get LetterSpacing() : uint
      {
         return this.FLetterSpacing;
      }
      
      public function set LetterSpacing(param1:uint) : void
      {
         this.FLetterSpacing = param1;
      }
      
      public function get Leading() : uint
      {
         return this.FLeading;
      }
      
      public function set Leading(param1:uint) : void
      {
         this.FLeading = param1;
      }
      
      public function Assign(param1:TFont) : void
      {
         var _loc2_:Boolean = false;
         if(this.FName != param1.FName)
         {
            this.FName = param1.FName;
            _loc2_ = true;
         }
         if(this.FSize != param1.FSize)
         {
            this.FSize = param1.FSize;
            _loc2_ = true;
         }
         if(this.FColor != param1.FColor)
         {
            this.FColor = param1.FColor;
            _loc2_ = true;
         }
         if(this.FBold != param1.FBold)
         {
            this.FBold = param1.FBold;
            _loc2_ = true;
         }
         if(this.FItalic != param1.FItalic)
         {
            this.FItalic = param1.FItalic;
            _loc2_ = true;
         }
         if(this.FUnderline != param1.FUnderline)
         {
            this.FUnderline = param1.FUnderline;
            _loc2_ = true;
         }
         if(this.FLetterSpacing != param1.FLetterSpacing)
         {
            this.FLetterSpacing = param1.FLetterSpacing;
            _loc2_ = true;
         }
         if(this.FLeading != param1.Leading)
         {
            this.FLeading = param1.Leading;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.ModificationUpdate();
         }
      }
      
      public function FlushTextFormat(param1:TextFormat) : void
      {
         param1.font = this.FName;
         param1.size = this.FSize;
         param1.color = this.FColor;
         param1.bold = this.FBold;
         param1.italic = this.FItalic;
         param1.underline = this.FUnderline;
         param1.letterSpacing = this.FLetterSpacing;
         param1.leading = this.FLeading;
      }
   }
}

