package Rendering.Texts
{
   import Foundation.Common.Stubs.TStubModification;
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Fonts.SFontCore;
   import Foundation.Fonts.TFont;
   import Foundation.UI.TUIComponent;
   import Localization.Strings.TStringParagraphParameters;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TPainterHtmlText extends TUIComponent
   {
      
      protected static var FParagrapher:TStringParagrapher = new TStringParagrapher();
      
      protected static var FParagraphParameters:TStringParagraphParameters = new TStringParagraphParameters();
      
      protected var FStubModification:TStubModification;
      
      protected var FTextField:TextField;
      
      protected var FTextFormat:TextFormat;
      
      protected var FCoordinateSketching:TCoordinate;
      
      protected var FCoordinateRendering:TCoordinate;
      
      protected var FBoundsText:TBounds;
      
      protected var FParagraphWidth:int;
      
      protected var FParagraphHeight:int;
      
      protected var FModified:Boolean;
      
      protected var FFont:TFont;
      
      protected var FText:String;
      
      protected var FWordWrap:Boolean;
      
      protected var FWordWrapWidth:int;
      
      protected var FWrapTrailingSpaces:Boolean;
      
      protected var FSelectable:Boolean;
      
      protected var FMultilineable:Boolean;
      
      public function TPainterHtmlText(param1:TUIComponent)
      {
         super(param1);
         this.FStubModification = new TStubModification(this);
         this.ConstructFonts();
         this.FTextField = new TextField();
         this.FTextField.antiAliasType = AntiAliasType.ADVANCED;
         this.FTextField.autoSize = TextFieldAutoSize.NONE;
         this.FTextField.condenseWhite = true;
         this.FTextField.mouseEnabled = false;
         addChild(this.FTextField);
         this.FTextFormat = new TextFormat();
         this.FCoordinateSketching = new TCoordinate();
         this.FCoordinateRendering = new TCoordinate();
         this.FBoundsText = new TBounds();
         this.FontSynchronize();
         this.FText = "";
         this.FWordWrap = false;
         this.FSelectable = false;
         this.FMultilineable = false;
         this.FWordWrapWidth = 320;
         this.mouseEnabled = false;
      }
      
      protected function ConstructFonts() : void
      {
         this.FFont = new TFont(this.FStubModification);
      }
      
      protected function FontSynchronize() : void
      {
         this.FFont.FlushTextFormat(this.FTextFormat);
         this.FTextField.embedFonts = SFontCore.FontEmbedded(this.FFont.Name);
         this.FTextField.selectable = this.FSelectable;
         this.FTextField.multiline = this.FMultilineable;
      }
      
      protected function AlignCoordinateRenderingByCoordinate(param1:TCoordinate, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.X;
         switch(param2)
         {
            case TAlignment.HORIZONTAL_Center:
               _loc4_ -= this.FBoundsText.Width / 2;
               break;
            case TAlignment.HORIZONTAL_Right:
               _loc4_ -= this.FBoundsText.Width;
         }
         _loc5_ = param1.Y;
         switch(param3)
         {
            case TAlignment.VERTICAL_Center:
               _loc5_ -= this.FBoundsText.Height / 2;
               break;
            case TAlignment.VERTICAL_Bottom:
               _loc5_ -= this.FBoundsText.Height;
         }
         this.FCoordinateRendering.X = _loc4_;
         this.FCoordinateRendering.Y = _loc5_;
      }
      
      protected function AlignCoordinateRenderingByBounds(param1:TBounds, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.X;
         switch(param2)
         {
            case TAlignment.HORIZONTAL_Center:
               _loc4_ += (param1.Width - this.FBoundsText.Width) / 2;
               break;
            case TAlignment.HORIZONTAL_Right:
               _loc4_ += param1.Width - this.FBoundsText.Width;
         }
         _loc5_ = param1.Y;
         switch(param3)
         {
            case TAlignment.VERTICAL_Center:
               _loc5_ += (param1.Height - this.FBoundsText.Height) / 2;
               break;
            case TAlignment.VERTICAL_Bottom:
               _loc5_ += param1.Height - this.FBoundsText.Height;
         }
         this.FCoordinateRendering.X = _loc4_;
         this.FCoordinateRendering.Y = _loc5_;
      }
      
      protected function UpdatingPerform() : void
      {
         if(this.FModified || this.FStubModification.Modified)
         {
            this.EvaluationPerform();
            this.SketchingPerform();
            this.FModified = false;
            this.FSelectable = false;
            this.FStubModification.Modified = false;
         }
      }
      
      protected function EvaluationPerform() : void
      {
         this.EvaluationPerform_Font();
         this.EvaluationPerform_HtmlText();
         this.EvaluationPerform_Dimension();
         this.EvaluationPerform_Bounds();
      }
      
      protected function EvaluationPerform_Font() : void
      {
         this.FontSynchronize();
      }
      
      protected function EvaluationPerform_HtmlText() : void
      {
         this.FTextField.htmlText = "";
         this.FTextField.wordWrap = this.FWordWrap;
         if(this.FWordWrap)
         {
            this.FTextField.width = this.FWordWrapWidth;
         }
         this.FTextField.htmlText = this.FText;
         if(this.FWordWrap && this.FTextField.textWidth > this.FWordWrapWidth)
         {
            this.FTextField.width = this.FWordWrapWidth;
         }
         else
         {
            this.FTextField.width = this.FTextField.textWidth;
         }
         this.FTextField.height = this.FTextField.textHeight;
         this.FParagraphWidth = this.FTextField.width;
         this.FParagraphHeight = this.FTextField.textHeight;
      }
      
      protected function EvaluationPerform_Dimension() : void
      {
         this.FParagraphWidth = this.FTextField.textWidth;
         this.FParagraphHeight = this.FTextField.textHeight;
      }
      
      protected function EvaluationPerform_Bounds() : void
      {
         this.FBoundsText.Width = this.FTextField.textWidth;
         this.FBoundsText.Height = this.FTextField.textHeight;
      }
      
      protected function SketchingPerform() : void
      {
         this.SketchingPerform_Sketch();
         this.SketchingPerform_Text();
      }
      
      protected function SketchingPerform_Sketch() : void
      {
      }
      
      protected function SketchingPerform_Text() : void
      {
      }
      
      public function get Font() : TFont
      {
         return this.FFont;
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
      
      public function set Text(param1:String) : void
      {
         if(param1 != this.FText)
         {
            this.FText = param1;
            this.FModified = true;
         }
      }
      
      public function get WordWrap() : Boolean
      {
         return this.FWordWrap;
      }
      
      public function set WordWrap(param1:Boolean) : void
      {
         if(param1 != this.FWordWrap)
         {
            this.FWordWrap = param1;
            this.FModified = true;
         }
      }
      
      public function get WordWrapWidth() : int
      {
         return this.FWordWrapWidth;
      }
      
      public function set WordWrapWidth(param1:int) : void
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 != this.FWordWrapWidth)
         {
            this.FWordWrapWidth = param1;
            this.FModified = true;
         }
      }
      
      public function get TextWidth() : int
      {
         this.UpdatingPerform();
         return this.FBoundsText.Width;
      }
      
      public function get TextHeight() : int
      {
         this.UpdatingPerform();
         return this.FBoundsText.Height;
      }
      
      public function get WrapTrailingSpaces() : Boolean
      {
         return this.FWrapTrailingSpaces;
      }
      
      public function set WrapTrailingSpaces(param1:Boolean) : void
      {
         if(param1 != this.FWrapTrailingSpaces)
         {
            this.FWrapTrailingSpaces = param1;
            this.FModified = true;
         }
      }
      
      public function get Selectable() : Boolean
      {
         return this.FSelectable;
      }
      
      public function set Selectable(param1:Boolean) : void
      {
         this.FSelectable = param1;
      }
      
      public function get Multilineable() : Boolean
      {
         return this.FMultilineable;
      }
      
      public function set Multilineable(param1:Boolean) : void
      {
         if(param1 != this.FMultilineable)
         {
            this.FMultilineable = param1;
            this.FModified = true;
         }
      }
      
      public function get NumLines() : uint
      {
         return this.FTextField.numLines;
      }
      
      public function get Alpha() : Number
      {
         return this.FTextField.alpha;
      }
      
      public function set Alpha(param1:Number) : void
      {
         if(this.FTextField.alpha != param1)
         {
            this.FTextField.alpha = param1;
         }
      }
      
      public function get ScaleX() : Number
      {
         return this.scaleX;
      }
      
      public function set ScaleX(param1:Number) : void
      {
         if(this.scaleX != param1)
         {
            this.scaleX = param1;
         }
      }
      
      public function get ScaleY() : Number
      {
         return this.scaleY;
      }
      
      public function set ScaleY(param1:Number) : void
      {
         if(this.scaleY != param1)
         {
            this.scaleY = param1;
         }
      }
      
      public function get TextX() : int
      {
         return this.FCoordinateRendering.X;
      }
      
      public function get TextY() : int
      {
         return this.FCoordinateRendering.Y;
      }
      
      public function Evaluate(param1:TBounds) : void
      {
         this.UpdatingPerform();
         param1.Width = this.FBoundsText.Width;
         param1.Height = this.FBoundsText.Height;
         this.FTextField.width = this.FBoundsText.Width;
         this.FTextField.height = this.FBoundsText.Height;
      }
      
      public function Render(param1:TCoordinate, param2:int = 0, param3:int = 0) : void
      {
         this.UpdatingPerform();
         this.AlignCoordinateRenderingByCoordinate(param1,param2,param3);
         param1.X = this.FCoordinateRendering.X;
         param1.Y = this.FCoordinateRendering.Y;
      }
      
      public function RenderBounds(param1:TBounds, param2:int = 0, param3:int = 0) : void
      {
         this.UpdatingPerform();
         if(this.FTextField.htmlText != null)
         {
            this.FBoundsText.Width = this.Width;
            this.FBoundsText.Height = this.Height;
            this.AlignCoordinateRenderingByBounds(param1,param2,param3);
            this.X = this.FCoordinateRendering.X;
            this.Y = this.FCoordinateRendering.Y;
         }
      }
   }
}

