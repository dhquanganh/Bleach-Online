package Rendering.Common
{
   import Foundation.Common.Spaces.CommonSpace;
   import Foundation.Common.Stubs.TStubModification;
   import Foundation.Fonts.TFont;
   
   use namespace CommonSpace;
   
   public class TFontRendering extends TFont
   {
      
      protected var FModified:Boolean;
      
      public function TFontRendering(param1:TStubModification = null)
      {
         super(param1);
         CommonSpace::FName = "微软雅黑";
         CommonSpace::FSize = 12;
         CommonSpace::FColor = 4294967295;
         CommonSpace::FLetterSpacing = 1;
         CommonSpace::FBold = false;
         CommonSpace::FItalic = false;
         CommonSpace::FUnderline = false;
      }
      
      override public function set Name(param1:String) : void
      {
         if(param1 != FName)
         {
            FName = param1;
            this.FModified = true;
         }
      }
      
      override public function set Size(param1:int) : void
      {
         if(param1 != FSize)
         {
            FSize = param1;
            this.FModified = true;
         }
      }
      
      override public function set Color(param1:uint) : void
      {
         if(param1 != FColor)
         {
            FColor = param1;
            this.FModified = true;
         }
      }
      
      override public function set Bold(param1:Boolean) : void
      {
         if(param1 != FBold)
         {
            FBold = param1;
            this.FModified = true;
         }
      }
      
      override public function set Italic(param1:Boolean) : void
      {
         if(param1 != FItalic)
         {
            FItalic = param1;
            this.FModified = true;
         }
      }
      
      override public function set Underline(param1:Boolean) : void
      {
         if(param1 != FUnderline)
         {
            FUnderline = param1;
            this.FModified = true;
         }
      }
      
      public function get Modified() : Boolean
      {
         return this.FModified;
      }
      
      override public function Assign(param1:TFont) : void
      {
         if(FName != param1.FName)
         {
            FName = param1.FName;
            this.FModified = true;
         }
         if(FSize != param1.FSize)
         {
            FSize = param1.FSize;
            this.FModified = true;
         }
         if(FColor != param1.FColor)
         {
            FColor = param1.FColor;
            this.FModified = true;
         }
         if(FLetterSpacing != param1.FLetterSpacing)
         {
            FLetterSpacing = param1.FLetterSpacing;
            this.FModified = true;
         }
         if(FBold != param1.FBold)
         {
            FBold = param1.FBold;
            this.FModified = true;
         }
         if(FItalic != param1.FItalic)
         {
            FItalic = param1.FItalic;
            this.FModified = true;
         }
         if(FUnderline != param1.FUnderline)
         {
            FUnderline = param1.FUnderline;
            this.FModified = true;
         }
      }
      
      public function Update() : void
      {
         this.FModified = false;
      }
   }
}

